playerStartX = 300
playerStartY = 100

player = world:newRectangleCollider(playerStartX, playerStartY, 40, 100, {collision_class = "Player"})
-- Prevents player from rotating when falling
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.idle
player.isMoving = false
player.direction = 1
player.grounded = true

------------------------ UPDATE ----------------------
function playerUpdate(dt)
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 30, 2, {'Platform'})
        if #colliders > 0 then
            player.grounded = true
        else
            player.grounded = false
        end


        player.isMoving = false
        local px, py = player:getPosition()
        -- Moves the player around
        if love.keyboard.isDown('d') then
            player:setX(px + player.speed*dt)
            player.isMoving = true
            player.direction = 1
        end

        if love.keyboard.isDown('a') then
            player:setX(px - player.speed*dt)
            player.isMoving = true
            player.direction = -1
        end

        if player:enter('Danger') then
            local value = math.random(1, 2)
            if value == 1 then
                sounds.death1:play()
            elseif value == 2 then
                sounds.death2:play()
            end
            loadMap(saveData.currentLevel)
        end
    end

    if player.grounded then
        if player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end

    player.animation:update(dt)
end


------------------------ DRAW ----------------------
function drawPlayer()
    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
end
