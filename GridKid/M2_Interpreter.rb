require_relative "M1_environment.rb"
require_relative "M1_model.rb"
require_relative "M1_cell.rb"

module Interpreter

    class Token
        attr_reader :type, :source, :start, :finish, :coords

        # coords nil by default as only cell assignment uses it
        def initialize(type, source, start, finish, coords = nil)
            @type = type
            @source = source
            @start = start
            @finish = finish
            @coords = coords
        end

        def to_s
            "type:#{@type} source:#{@source} start:#{@start} finish:#{@finish} coords:#{@coords}"
        end
    end

    class Lexer
        def self.lex(input)
            tokens = []
            start = 0

            # if token pattern is some form of {Letter,Integer}[expression]
            if input.match?(/^{[A-Z]+,\s*\d+}\[/)
                start_pos = input.index("[")
                end_pos = input.index("]")
                coordinates = input[...start_pos].sub('{', '(').sub('}', ')')
                input = input[start_pos + 1...end_pos]
                
                [Token.new("CellAssignment", input, start_pos, end_pos, coordinates)]
            else
                input.chars.each.with_index do |char, finish|
                    if char.include?(" ")
                        if start < finish
                            tokens.push(
                                emit_token(input[start...finish], start, finish))
                        end
                        start = finish + 1
                    end
                end
                if start < input.length
                    tokens.push(emit_token(input[start...], start, input.length))
                end
                tokens
            end
        end

        def self.emit_token(input, start, finish)
            # puts input
            finish = finish - 1
            case input
            # Cell Dereference
            when /{([A-Z]+),(\d+)}/
                Token.new("CellDereference", input, start, finish)
            
            # atoms
            when /^\d+$/
                Token.new("IntegerPrim", input, start, finish)
            when /^\d+\.\d+$/
                Token.new("FloatPrim", input, start, finish)
            when "True"
                Token.new("BooleanPrim", input, start, finish)
            when "False"
                Token.new("BooleanPrim", input, start, finish)
            when "("
                Token.new("LeftParen", input, start, finish)
            when ")"
                Token.new("RightParen", input, start, finish)
            
            # unary Operators
            when "!"
                Token.new("Exclamation", nil, start, finish)
            when /^~/
                Token.new("Tilde", nil, start, finish)
            when /^Int/
                Token.new("IntCast", nil, start, finish)
            when /^Float/
                Token.new("FloatCast", nil, start, finish)

            # Exponent Operators
            when "**"
                Token.new("Exponent", input, start, finish)
            
            # Multiplicative Operators
            when "*"
                Token.new("Multiply", input, start, finish)
            when  "/"
                Token.new("Divide", input, start, finish)
            when "%"
                Token.new("Modulo", input, start, finish)
            
            # Arithmetic Operators
            when "+"
                Token.new("Addition", input, start, finish)
            when "-"
                Token.new("Subtraction", input, start, finish)
            
            # Bit-Shift Operators
            when "<<"
                Token.new("LeftShift", input, start, finish)
            when ">>"
                Token.new("RightShift", input, start, finish)
            
            # Bitwise Operators
            when "&"
                Token.new("BitAnd", input, start, finish)
            when "^"
                Token.new("BitXOR", input, start, finish)
            
            # Compare
            when "<="
                Token.new("LessThanEquals", input, start, finish)
            when ">="
                Token.new("GreaterThanEquals", input, start, finish)
            when "<"
                Token.new("LessThan", input, start, finish)
            when ">"
                Token.new("GreaterThan", input, start, finish)
            when "!="
                Token.new("NotEquals", input, start, finish)
            when "=="
                Token.new("Equals", input, start, finish)
            
            # Logic
            when "&&"
                Token.new("LogAnd", input, start, finish)
            when "||"
                Token.new("LogOr", input, start, finish)
            
            # Error
            else
                raise StandardError.new "unknown character #{input}"
            end
        end
    end

    class ASTNode
        attr_reader :val, :left, :right
        def initialize(val, left = nil, right = nil)
            @val = val
            @left = left
            @right = right
        end

        def to_s
            if !(@left.nil? || @right.nil?)
                "#{@val}(#{@left}, #{@right})"
            elsif !@left.nil?
                "#{@val}(#{@left})"
            elsif !@right.nil?
                "#{@val}(#{@right})"
            else
                "#{@val}"
            end
        end
    end

    class AST
        attr_reader :tokens, :root
        def initialize(expression)
            @tokens = expression
            @root = self.p_log_or
        end

        def p_log_or
            node = self.p_log_and

            while !@tokens.empty? && ["LogOr"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_log_and
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_log_and
            node = self.p_compare

            while !@tokens.empty? && ["LogAnd"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_compare
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_compare
            node = self.p_ord

            while !@tokens.empty? && ["NotEquals", "Equals"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_ord
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_ord
            node = self.p_bit_xor

            while !@tokens.empty? && ["LessThanEquals", "GreaterThanEquals", "LessThan", "GreaterThan"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_bit_xor
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_bit_xor
            node = self.p_bit_and

            while !@tokens.empty? && ["BitXOR"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_bit_and
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_bit_and
            node = self.p_bit_shift

            while !@tokens.empty? && ["BitAnd"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_bit_shift
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_bit_shift
            node = self.p_add

            while !@tokens.empty? && ["LeftShift", "RightShift"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_add
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_add
            node = self.p_mult
            while !@tokens.empty? && ["Addition", "Subtraction"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_mult
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_mult
            node = self.p_exponent

            while !@tokens.empty? && ["Multiply", "Divide", "Modulo"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_exponent
                node = ASTNode.new(op.type, node, right)
            end
            node
        end
        
        def p_exponent
            node = self.p_unary
            while !@tokens.empty? && ["Exponent"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                right = self.p_unary
                node = ASTNode.new(op.type, node, right)
            end
            node
        end

        def p_unary
            while !@tokens.empty? && ["Exclamation", "Tilde", "IntCast", "FloatCast"].include?(@tokens[0].type)
                op = @tokens.delete_at(0)
                left = self.p_log_or
                node = ASTNode.new(op.type, left)
                return node
            end
            node = self.p_atom
            node
        end

        def p_atom
            token = @tokens.delete_at(0)
            case token.type
            when "IntegerPrim", "FloatPrim", "BooleanPrim", "CellDereference"
                ASTNode.new([token.type, token.source])
            when "LeftParen"
                node = self.p_log_or
                @tokens.delete_at(0)
                node
            end
        end

        def to_s
            @root.to_s
        end
    end
    
    class Parser
        def initialize(environment)
            @env = environment
        end

        # A kind of gross method that recursively evaluates an AST
        # in the form Addition(["IntegerPrim", "3"], ["IntegerPrim", "2"])
        def evaluate(ast)

            # a blank case statement is required due to primitives being stored as tuple-equivalents.
            case
            # Primitives
            when ast.val[0] == "IntegerPrim"
                Model::IntegerPrim.new(ast.val[1].to_i)
            when ast.val[0] == "FloatPrim"
                Model::FloatPrim.new(ast.val[1].to_f)
            when ast.val[0] == "BooleanPrim"
                Model::BooleanPrim.new(ast.val[1].downcase == "true")

            # Dereference
            when ast.val[0] == "CellDereference"
                exp = @env.sheet.grid[ast.val[1].sub("{", "(").sub("}", ")")]
                self.evaluate(AST.new(Lexer::lex(exp)).root)
            
            # Unary
            when ast.val == "Exclamation"
                Model::Not.new(self.evaluate(ast.left))
            when ast.val == "Tilde"
                Model::BitNot.new(self.evaluate(ast.left))
            when ast.val == "IntCast"
                Model::FloatToInt.new(self.evaluate(ast.left))
            when ast.val == "FloatCast"
                Model::IntToFloat.new(self.evaluate(ast.left))

            # Exponent
            when ast.val == "Exponent"
                Model::Exponent.new(self.evaluate(ast.left), self.evaluate(ast.right))
            
            # Multiplicitave
            when ast.val == "Multiply"
                Model::Multiply.new(self.evaluate(ast.left), self.evaluate(ast.right))
            when ast.val == "Divide"
                Model::Divide.new(self.evaluate(ast.left), self.evaluate(ast.right))
            when ast.val == "Modulo"
                Model::Modulo.new(self.evaluate(ast.left), self.evaluate(ast.right))
            
            # Additive
            when ast.val == "Addition"
                Model::Add.new(self.evaluate(ast.left), self.evaluate(ast.right))
            when ast.val == "Subtraction"
                Model::Subtract.new(self.evaluate(ast.left), self.evaluate(ast.right))

            # BitShift
            when ast.val == "LeftShift"
                Model::LShift.new(self.evaluate(ast.left), self.evaluate(ast.right))
            when ast.val == "RightShift"
                Model::RShift.new(self.evaluate(ast.left), self.evaluate(ast.right))

            # Bitwise
            when ast.val == "BitAnd"
                Model::BitAnd.new(self.evaluate(ast.left), self.evaluate(ast.right))
            when ast.val == "BitXOR"
                Model::BitXOR.new(self.evaluate(ast.left), self.evaluate(ast.right))
            
            # Compare & Ord
            when ast.val == "LessThanEquals"
                Model::BooleanPrim.new(self.evaluate(ast.left) <= self.evaluate(ast.right))
            when ast.val == "GreaterThanEquals"
                Model::BooleanPrim.new(self.evaluate(ast.left) >= self.evaluate(ast.right))
            when ast.val == "LessThan"
                Model::BooleanPrim.new(self.evaluate(ast.left) < self.evaluate(ast.right))
            when ast.val == "GreaterThan"
                Model::BooleanPrim.new(self.evaluate(ast.left) > self.evaluate(ast.right))
            when ast.val == "NotEquals"
                Model::BooleanPrim.new(self.evaluate(ast.left) != self.evaluate(ast.right))
            when ast.val == "Equals"
                Model::BooleanPrim.new(self.evaluate(ast.left) == self.evaluate(ast.right))
            
            # Logic
            when ast.val == "LogAnd"
                Model::And.new(self.evaluate(ast.left), self.evaluate(ast.right))
            when ast.val == "LogOr"
                Model::Or.new(self.evaluate(ast.left), self.evaluate(ast.right))
            
            # Error
            else
                raise StandardError.new "FAILED TO PARSE #{ast.val}"
            end
        end

        def parse(expression)
            tok_expression = Lexer.lex(expression)
            puts "TOKENIZED EXPRESSION\n================\n#{tok_expression}\n"

            if tok_expression[0].type == "CellAssignment"
                @env.sheet.grid[tok_expression[0].coords] = tok_expression[0].source
                return "Assigned #{tok_expression}"
            end
            tree = AST.new(tok_expression)
            puts "\nABSTRACT SYNTAX TREE\n===============\n#{tree}\n"
            eval_tree = self.evaluate(tree.root)
            puts "\nEVALUATED TREE\n================\n#{eval_tree}"
            eval_tree
        end
    end
end

teststr1 = "{A,1}[4 ** 2]"
teststr2 = "{B,2}[24.3]"
teststr3 = "{A,1} + {B,2}"
teststr4 = "70 + y"
teststr5 = "Int 3.2"
spreadsheet = M1_Environment::Environment.new

pars = Interpreter::Parser.new(spreadsheet)

tree1 = pars.parse(teststr1)
tree2 = pars.parse(teststr2)
tree3 = pars.parse(teststr3)

puts tree1
puts tree2
puts tree3

tree5 = pars.parse(teststr5)

tree4 = pars.parse(teststr4)