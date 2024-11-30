message = 0
fontSize = 33

output = message
test = 0
pickle = 0

condition = -25

function increaseMessage()
    while message < 10 do
        local bruh = "useless variable"
        message = message + 1
        test = test - 5
    end
end

increaseMessage()

for i=1, 3, 1 do
    pickle = pickle + 10 + i
end

-- SETTING THE MESSAGE BASED ON A CONDITION
function setMessage(condition)
    if condition > 0 then
        message = message + 42
    elseif condition < -10 then
        message = 69
    else 
        message = "No conditions met!"
    end
end

setMessage(55)

--------- TABLES ----------------

testScores = {}
testScores.subject = "Science"


testScores[1] = 95
testScores[2] = 87
testScores[3] = 98

table.insert(testScores, 95)
table.insert(testScores, 321)
table.insert(testScores, 555)

testScores["math"] = "Math test"

for i,s in ipairs(testScores) do
    message = message + s
end


-- 
function love.draw()
    love.graphics.setFont(love.graphics.newFont(fontSize))
    love.graphics.print(message)
    -- love.graphics.print("Hello World!")
end