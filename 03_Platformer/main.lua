------------------------ LOAD ----------------------
function love.load()
    love.window.setTitle("fFukurou Platformer-Proto")
    love.window.setMode(1000, 768)


    love.graphics.setColor(1, 0, 0) -- Red line for the bottom
    love.graphics.line(0, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1) -- Reset color

    anim8 = require 'libraries/anim8/anim8'
    wf = require './libraries/windfield/windfield'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'

    cam = cameraFile()

    sounds = {}
    -- static means you're loading the entire sound in memory, stream means you're streaming the audio file over time
    sounds.jump = love.audio.newSource('audio/jump.wav', 'static')
    sounds.music = love.audio.newSource('audio/music.mp3', 'stream')
    sounds.win = love.audio.newSource('audio/ahShii.mp3', 'stream')
    sounds.death1 = love.audio.newSource('audio/death1.mp3', 'stream')
    sounds.death2 = love.audio.newSource('audio/death2.mp3', 'stream')

    sounds.death1:setVolume(0.05)
    sounds.death2:setVolume(0.1)
    sounds.jump:setVolume(0.5)
    sounds.music:setLooping(true)
    sounds.music:setVolume(0.25)

    sounds.music:play()

    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')
    sprites.background = love.graphics.newImage('sprites/background.png')
    -- We divide the total size of the sheet by the number rows/columns there are in the sheet
    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    local enemyGrid = anim8.newGrid(100,79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())

    animations = {}
    animations.idle = anim8. newAnimation(grid('1-15', 1), 0.025)
    animations.jump = anim8. newAnimation(grid('1-7', 2), 0.025)
    animations.run = anim8. newAnimation(grid('1-15', 3), 0.025)
    animations.enemy = anim8.newAnimation(enemyGrid('1-2', 1), 0.03)

    -- Dictates the direction that gravity is going in our world
    world = wf.newWorld(0, 700, false)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Player'--[[, {ignores = {'Platform'}}]])
    world:addCollisionClass('Danger')

    require('player')
    require('enemy')
    require('libraries/show')

    dangerZone = world:newRectangleCollider(-500, 800, 5000, 50, {collision_class = "Danger"})
    dangerZone:setType('static')

    platforms = {}

    flagX = 0
    flagY = 0
    
    saveData = {}
    saveData.currentLevel = "level1"

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    loadMap(saveData.currentLevel)

end

------------------------ UPDATE ----------------------
function love.update(dt)
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    updateEnemies(dt)

    local px, py = player:getPosition()
    cam:lookAt(px, love.graphics.getHeight()/2)

    local colliders = world:queryCircleArea(flagX, flagY, 10, {'Player'})
    if #colliders > 0 then
        if saveData.currentLevel == "level1" then
            loadMap("level2")
        elseif saveData.currentLevel == "level2" then
            loadMap("level1")
        end

        sounds.win:play()
    end
end

------------------------ DRAW ----------------------
function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        drawPlayer()
        drawEnemies()
    cam:detach()
end

------------------------ FUNCTIONS ----------------------

function love.keypressed(key)
    if key == 'w' then
        if player.grounded then
            player:applyLinearImpulse(0, -4200)
            sounds.jump:play()
        end
    end
    if key == 'r' then
        loadMap(saveData.currentLevel)
    end
end

-- function love.mousepressed(x, y, button)
--     if button == 1 then
--         local colliders = world:queryCircleArea(x, y, 200, {'Platform', 'Danger'})
--         for i,c in ipairs(colliders) do
--             c:destroy()
--         end
--     end

-- end

function spawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Platform"})
        -- There are Dynamic, Static, and Kinematic colliders
        platform:setType('static')
        table.insert(platforms, platform)
    end

end

function destroyAll()
    local i = #platforms
    while i > -1 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i-1
    end

    local i = #enemies
    while i > -1 do
        if enemies[i] ~= nil then
            enemies[i]:destroy()
        end
        table.remove(enemies, i)
        i = i-1
    end
end

function loadMap(mapName)
    saveData.currentLevel = mapName
    love.filesystem.write("data.lua", table.show(saveData, "saveData"))
    destroyAll()
    
    gameMap = sti("maps/" .. mapName .. ".lua")
    for i, obj in pairs(gameMap.layers['Start'].objects) do
        playerStartX = obj.x    
        playerStartY = obj.y
    end
    player:setPosition(playerStartX, playerStartY)
    for i, obj in pairs(gameMap.layers['Platforms'].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers['Enemies'].objects) do
        spawnEnemy(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers['Flag'].objects) do
        flagX = obj.x
        flagY = obj.y
    end
end