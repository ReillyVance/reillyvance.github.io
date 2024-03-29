require_relative "M1_environment.rb"
require_relative "M1_model.rb"
require_relative "M1_cell.rb"


spreadsheet = M1_Environment::Environment.new

# primitives and functions to put in cells
int1 = Model::IntegerPrim.new(5.1)
int2 = Model::IntegerPrim.new(56)
int3 = Model::IntegerPrim.new(3)
int4 = Model::IntegerPrim.new(27)
int5 = Model::IntegerPrim.new(10)
float1 = Model::FloatPrim.new(3.14)
float2 = Model::FloatPrim.new(89.1)
bool1 = Model::BooleanPrim.new(true)
bool2 = Model::BooleanPrim.new(false)
str1 = Model::StringPrim.new("wowee")
str2 = Model::StringPrim.new("zowee")
add1 = Model::Add.new(int1, int2)
sub1 = Model::Subtract.new(int2, int4)
exp1 = Model::Exponent.new(int5, int3)
lshift1 = Model::LShift.new(int1, int3)
rshift1 = Model::RShift.new(int1, int3)
and1 = Model::And.new(bool2, bool1)
or1 = Model::Or.new(bool2, bool1)
not1 = Model::Not.new(bool2)
bAnd1 = Model::BitAnd.new(int1, int3)
bOr1 = Model::BitOr.new(int1, int3)
bXor1 = Model::BitXor.new(int1, int4)
bNot1 = Model::BitNot.new(int1, int3)

# cell definitions
cellAddr1 = M1_Cell::CellAddress.new(1, 1)
cellAddr2 = M1_Cell::CellAddress.new(1, 2)
cellAddr3 = M1_Cell::CellAddress.new(2, 1)
cellAddr4 = M1_Cell::CellAddress.new(2, 2)
cellAddr5 = M1_Cell::CellAddress.new(2, 3)
cellAddr6 = M1_Cell::CellAddress.new(3, 4)
cell1 = M1_Cell::Cell.new(cellAddr1, or1)
cell2 = M1_Cell::Cell.new(cellAddr2, int2)
cell3 = M1_Cell::Cell.new(cellAddr3, and1)
cell4 = M1_Cell::Cell.new(cellAddr4, exp1)
cell5 = M1_Cell::Cell.new(cellAddr5, int5)

max = Model::Max.new(cell1, cell5)
min = Model::Min.new(cell1, cell5)
sum = Model::Sum.new(cell1, cell5)
mean = Model::Mean.new(cell1, cell5)

cell6 = M1_Cell::Cell.new(cellAddr6, sum)


#add to spreadsheet
spreadsheet.sheet.grid[cellAddr1.xy] = cell1
spreadsheet.sheet.grid[cellAddr2.xy] = cell2
spreadsheet.sheet.grid[cellAddr3.xy] = cell3
spreadsheet.sheet.grid[cellAddr4.xy] = cell4
spreadsheet.sheet.grid[cellAddr5.xy] = cell5
spreadsheet.sheet.grid[cellAddr6.xy] = cell6


puts "max: " + max.evaluate(spreadsheet).to_s
puts "min: " + min.evaluate(spreadsheet).to_s
puts "sum: " + sum.evaluate(spreadsheet).to_s
puts "mean: " + mean.evaluate(spreadsheet).to_s

puts "cell1: #{spreadsheet.sheet.grid[[1,1]]}" + " => " + spreadsheet.sheet.grid[[1,1]].evaluate(spreadsheet).to_s
puts "cell3: #{spreadsheet.sheet.grid[[2,1]]}" + " => " + spreadsheet.sheet.grid[[2,1]].evaluate(spreadsheet).to_s
puts "cell4: #{spreadsheet.sheet.grid[[2,2]]}" + " => " + spreadsheet.sheet.grid[[2,2]].evaluate(spreadsheet).to_s
puts "cell6: #{spreadsheet.sheet.grid[[3,4]]}" + " => " + spreadsheet.sheet.grid[[3,4]].evaluate(spreadsheet).to_s

# spreadsheet.sheet.grid[cellAddr1] = cell1
# spreadsheet.sheet.grid[cellAddr2] = cell2
# spreadsheet.sheet.grid[cellAddr3] = cell3

# puts spreadsheet.sheet.grid[cellAddr1].evaluate.to_s
# puts spreadsheet.sheet.grid[cellAddr2].evaluate.to_s
# puts spreadsheet.sheet.grid[cellAddr3].evaluate.to_s