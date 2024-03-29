module Model

    # primitives    
    class IntegerPrim
        attr_reader :val
        def initialize(val)
            @val = val.to_i
        end

        def evaluate(environment)
            self
        end

        def to_s
            "#{@val}"
        end
    end
    
    class FloatPrim
        attr_reader :val
        def initialize(val)
            @val = val.to_f
        end

        def evaluate(environment)
            self
        end

        def to_s
            "#{@val}"
        end
    end
    
    class BooleanPrim
        attr_reader :val
        def initialize(val)
            if val.is_a?(TrueClass) || val.is_a?(FalseClass)
                @val = val
            else
                raise StandardError.new "not boolean"
            end
        end

        def evaluate(environment)
            self
        end

        def to_s
            "#{@val}"
        end
    end
    
    class StringPrim
        attr_reader :val
        def initialize(val)
            @val = val.to_s
        end

        def evaluate(environment)
            self
        end

        def to_s
            @val
        end
    end

    # Arithmetic Operations
    class Add
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(StringPrim) && right_val.is_a?(StringPrim)
                StringPrim.new(left_val.val + right_val.val)
            elsif left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val + right_val.val)
            elsif left_val.is_a?(FloatPrim) && right_val.is_a?(FloatPrim)
                FloatPrim.new(left_val.val + right_val.val)
            else
                raise StandardError.new "invalid addition"
            end
        end

        def to_s
            "#{@left} + #{@right}"
        end
    end

    class Subtract
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val - right_val.val)
            elsif left_val.is_a?(FloatPrim) && right_val.is_a?(FloatPrim)
                FloatPrim.new(left_val.val - right_val.val)
            else
                raise StandardError.new "invalid subtraction"
            end
        end

        def to_s
            "#{@left} - #{@right}"
        end
    end

    class Multiply
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val * right_val.val)
            elsif left_val.is_a?(FloatPrim) && right_val.is_a?(FloatPrim)
                FloatPrim.new(left_val.val * right_val.val)
            else
                raise StandardError.new "invalid multiplication"
            end
        end

        def to_s
            "#{@left} * #{@right}"
        end
    end

    class Divide
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val / right_val.val)
            elsif left_val.is_a?(FloatPrim) && right_val.is_a?(FloatPrim)
                FloatPrim.new(left_val.val / right_val.val)
            else
                raise StandardError.new "invalid division"
            end
        end

        def to_s
            "#{@left} / #{@right}"
        end
    end

    class Modulo
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val % right_val.val)
            elsif left_val.is_a?(FloatPrim) && right_val.is_a?(FloatPrim)
                FloatPrim.new(left_val.val % right_val.val)
            else
                raise StandardError.new "invalid modulation"
            end
        end

        def to_s
            "#{@left} % #{@right}"
        end
    end

    class Exponent
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val ** right_val.val)
            elsif left_val.is_a?(FloatPrim) && right_val.is_a?(FloatPrim)
                FloatPrim.new(left_val.val ** right_val.val)
            else
                raise StandardError.new "invalid exponent(s)"
            end
        end

        def to_s
            "#{@left} ** #{@right}"
        end
    end

    # logical operations
    class And
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            if left_val.is_a?(BooleanPrim) && !left_val.val
                BooleanPrim.new(false)
            end

            right_val = @right.evaluate(environment)
            if left_val.is_a?(BooleanPrim) && right_val.is_a?(BooleanPrim)
                BooleanPrim.new(left_val.val && right_val.val)
            else
                raise StandardError.new "invalid logical AND"
            end
        end

        def to_s
            "#{@left} && #{@right}"
        end
    end

    class Or
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            if left_val.is_a?(BooleanPrim) && left_val.val
                BooleanPrim.new(true)
            end

            right_val = @right.evaluate(environment)
            if left_val.is_a?(BooleanPrim) && right_val.is_a?(BooleanPrim)
                BooleanPrim.new(left_val.val || right_val.val)
            else
                raise StandardError.new "invalid logical OR"
            end
        end

        def to_s
            "#{@left} || #{@right}"
        end
    end

    class Not
        def initialize(left)
            @left = left
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            if left_val.is_a?(BooleanPrim)
                BooleanPrim.new(!@left.val)
            else
                raise StandardError.new "Non-boolean type"
            end
        end

        def to_s
            "!#{@left}"
        end
    end

    # Bitwise operations
    class BitAnd
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val & right_val.val)
            else
                raise StandardError.new "Non-integer types"
            end
        end

        def to_s
            "#{@left} & #{@right}"
        end
    end

    class BitOr
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val | right_val.val)
            else
                raise StandardError.new "Non-integer types"
            end
        end

        def to_s
            "#{@left} | #{@right}"
        end
    end

    class BitXor
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val ^ right_val.val)
            else
                raise StandardError.new "Non-integer types"
            end
        end

        def to_s
            "#{@left} ^ #{@right}"
        end
    end

    class BitNot
        def initialize(left)
            @left = left
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            if left_val.is_a?(IntegerPrim)
                IntegerPrim.new(~left_val.val)
            else
                raise StandardError.new "Non-integer type"
            end
        end

        def to_s
            "~#{@left} & #{@right}"
        end
    end

    class LShift
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val << right_val.val)
            else
                raise StandardError.new "Non-integer types"
            end
        end

        def to_s
            "#{@left} << #{@right}"
        end
    end

    class RShift
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            left_val = @left.evaluate(environment)
            right_val = @right.evaluate(environment)
            if left_val.is_a?(IntegerPrim) && right_val.is_a?(IntegerPrim)
                IntegerPrim.new(left_val.val >> right_val.val)
            else
                raise StandardError.new "Non-integer types"
            end
        end

        def to_s
            "#{@left} >> #{@right}"
        end
    end

    # Casting operators
    class FloatToInt
        def initialize(num)
            @num = num
        end

        def evaluate(environment)
            num_val = @num.evaluate(evaluate)
            if num_val.is_a?(FloatPrim)
                IntegerPrim.new(@num.val.to_i)
            else
                raise StandardError.new "Non-float type"
            end
        end

        def to_s
            "int(#{@num})"
        end

    end

    class IntToFloat
        def initialize(num)
            @num = num
        end

        def evaluate(environment)
            num_val = @num.evaluate(evaluate)
            if num_val.is_a?(IntegerPrim)
                IntegerPrim.new(@num.val.to_f)
            else
                raise StandardError.new "Non-integer type"
            end
        end

        def to_s
            "float(#{@num})"
        end
    end

    # Statistical functions

    ##
    # Max and min just return the biggest and smallest values found 
    # within the given range. The statistical functions are 
    # tree nodes, just like Add. 
    # They have two operands: the top-left address and the bottom-right address.
    # In their evaluate method, you evaluate these two operands and then loop through the subgrid.

    
    class Helpers
    
        def self.getAddressList(xy1, xy2)
            addressList = Array.new
            for x in xy1[0]..xy2[0] do
                for y in xy1[1]..xy2[1] do
                    addressList.push(M1_Cell::CellAddress.new(x, y))
                end
            end
            addressList
        end
    end
    
    



    class Max
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            addressList = Helpers.getAddressList(@left.xy, @right.xy)
            evaluated = Array.new
            for addr in addressList
                begin
                    temp = addr.evaluate(environment)
                rescue
                else
                    if temp.is_a?(IntegerPrim) || temp.is_a?(FloatPrim)
                        evaluated.append(temp.val)
                    end
                end
            end
            max_val = evaluated.max
            if max_val.is_a?(Integer)
                IntegerPrim.new(max_val)
            else
                FloatPrim.new(max_val)
            end
        end

        def to_s
            "max((#{@left.xy[0]}, #{@left.xy[1]}), (#{@right.xy[0]}, #{@right.xy[1]}))"
        end
    end

    class Min
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            addressList = Helpers.getAddressList(@left.xy, @right.xy)
            evaluated = Array.new
            for addr in addressList
                begin
                    temp = addr.evaluate(environment)
                rescue
                else
                    if temp.is_a?(IntegerPrim) || temp.is_a?(FloatPrim)
                        evaluated.append(temp.val)
                    end
                end
            end
            min_val = evaluated.min
            if min_val.is_a?(Integer)
                IntegerPrim.new(min_val)
            else
                FloatPrim.new(min_val)
            end
        end

        def to_s
            "min((#{@left.xy[0]}, #{@left.xy[1]}), (#{@right.xy[0]}, #{@right.xy[1]}))"
        end
    end

    class Mean
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            sum = Sum.new(@left, @right).evaluate(environment).val
            mean = sum / ((@right.xy[0] - @left.xy[0]) * (@right.xy[1] - @left.xy[1]))
            if mean.is_a?(Integer)
                IntegerPrim.new(mean)
            else
                FloatPrim.new(mean)
            end
        end

        def to_s
            "mean((#{@left.xy[0]}, #{@left.xy[1]}), (#{@right.xy[0]}, #{@right.xy[1]}))"
        end
    end

    class Sum
        def initialize(left, right)
            @left = left
            @right = right
        end

        def evaluate(environment)
            addressList = Helpers.getAddressList(@left.xy, @right.xy)
            sum = 0
            for addr in addressList
                begin
                    temp = addr.evaluate(environment)
                rescue
                else
                    if temp.is_a?(IntegerPrim) || temp.is_a?(FloatPrim)
                        sum += temp.val
                    end
                end
            end
            if sum.is_a?(Integer)
                IntegerPrim.new(sum)
            else
                FloatPrim.new(sum)
            end
        end

        def to_s
            "sum((#{@left.xy[0]}, #{@left.xy[1]}), (#{@right.xy[0]}, #{@right.xy[1]}))"
        end
    end
end