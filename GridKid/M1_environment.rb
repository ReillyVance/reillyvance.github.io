require_relative "M1_model.rb"
require_relative "M1_cell.rb"


module M1_Environment
    class Grid
        attr_reader :grid
        def initialize
            @grid = Hash.new(nil)
        end

        # def set(addr, expression)
        #     @grid[addr] = M1_Cell::Cell.new(addr, expression)
        # end

        # def get(addr)
        #     if @grid[addr] == 0
        #         raise StandardError.new "invalid address"
        #     else
        #         @grid[addr]
        #     end
        # end
    end

    class Environment
        attr_reader :sheet
        def initialize
            @sheet = Grid.new
        end
    end
end