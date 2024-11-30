-- Variables

foo = "lua is awesome!"
bar = 1
number = 999


-- Conditional Statements

if foo == 1 then
  foo = foo + 1
end

if bar < 1 then
  bar = "bar is less than 1"
elseif bar > 1 then
  bar = "bar is greater than 1"
else
  bar = "bar is equal to 1"
end


-- Loops

while number > 900 do
  number = number - 1
end

-- i is the iterator, 3 is the ending value, and 1 is the amount that i will
-- change each loop
for i=1,3,1 do
  number = number * i
end


-- Functions

function increaseNumber(i)
  number = number + i
end

increaseNumber(20)


-- Tables

myTable = {}

-- Puts item at index 1
myTable[1] = "First item in the table"

-- Adds item to the table
table.insert(myTable, "Second item in the table")

-- Set a property of a table (doesn't have an index)
table.name = "Kyle"

-- Cycle through every item in a table
for i,s in ipairs(myTable) do
  -- i is the current index, s is the current value
  foo = s
end
