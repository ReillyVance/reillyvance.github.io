module M1_Cell
    
    # cell values
    class CellAddress
        attr_reader :xy
        def initialize(x, y)
            @xy = [x, y]
        end

        def evaluate(environment)
            cell = environment.sheet.grid[@xy]
            if cell.nil?
                raise StandardError.new "invalid coordinates"
            else
                cell.evaluate(environment)
            end
        end

        def to_s
            "(#{@xy[0]}, #{@xy[1]})"
        end 
    end
    
    class Cell
        attr_reader :xy, :expression
        def initialize(cellAddr, expression)
            @xy = cellAddr.xy
            @expression = expression
        end

        def evaluate(environment)
            @expression.evaluate(environment)
        end

        def to_s
            "(#{@xy[0]}, #{@xy[1]}) => #{@expression}"
        end
    end
end