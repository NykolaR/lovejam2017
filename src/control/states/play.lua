local Play = {}

local Area = require ("src.control.area")
local Camera = require ("src.entity.camera")
local Boy = require ("src.entity.boy")
local Bee = require ("src.entity.bee")
local Input = require ("src.boundary.input")
local General = require ("src.logic.general")

Play.allChestSound = love.audio.newSource ("assets/audio/effects/allchests.wav")
Play.allChestSound:setVolume (0.4)

Play.boyMove = true
Play.completed = false

function Play.loadArea ()
    Area.loadArea ()
    Camera.setBounds (Area.width * Area.tileSize, Area.height * Area.tileSize)

    Camera.setPosition (Boy)
end

function Play.update (dt)

    if not Play.GAMEOVER then
        if Input.keyPressed (Input.KEYS.ACTION) then
            Play.boyMove = not Play.boyMove
        end

        Play.updateBeeAndBoy (dt)

        if Play.boyMove then
            Camera.approach (Boy)
        else
            Camera.approach (Bee)
        end

        if not Play.completed then Play.allChests () end
    else
        if Boy.rect.y > - 16 then
            Boy.rect.y = Boy.rect.y - 1
        end
        if Bee.rect.y > -16 then
            Bee.rect.y = Bee.rect.y - 1
        end
    end
end

function Play.updateBeeAndBoy (dt)
    Boy.rect:setLastPosition ()
    Bee.rect:setLastPosition ()
    Boy.updateVertically (dt, Play.boyMove)
    Boy.beeCollision (Bee)
    Bee.updateVertically (dt, (not Play.boyMove))
    Play.playableCollide (Boy, General.Directions.VERTICAL)
    Play.playableCollide (Bee, General.Directions.VERTICAL)
    Play.waterCollide (Bee, General.Directions.VERTICAL)
    Play.waterCollide (Boy, General.Directions.VERTICAL)
    Boy.updateHorizontally (dt, Play.boyMove)
    Bee.updateHorizontally (dt, (not Play.boyMove))
    Play.playableCollide (Boy, General.Directions.HORIZONTAL)
    Play.playableCollide (Bee, General.Directions.HORIZONTAL)
    Play.chestCollide (Boy)
end

function Play.playableCollide (playable, direction)
    for _,r in pairs (Area.collisions) do
        playable.environmentCollision (r, direction)
    end
end

function Play.waterCollide (playable, direction)
    for _,r in pairs (Area.water) do
        if playable == Boy then
            playable.waterCollision (r.rect, direction)
        else
            r.rect.y = r.rect.y - 2
            playable.waterCollision (r.rect, direction)
            r.rect.y = r.rect.y + 2
        end
    end
end

function Play.chestCollide (playable, direction)
    for _,chest in pairs (Area.chests) do
        playable.chestCollision (chest)
    end
end

function Play.render ()
    Camera.update ()

    Camera.renderParallex ()

    Area.renderBelow ()

    Boy.render ()
    Bee.render ()

    love.graphics.setColor (255, 255, 255, 180)
    Area.renderAbove ()

    Area.renderWater ()

    Area.renderGroundWater ()
    Area.renderEnvironment ()

    if Play.completed then
        love.graphics.setColor (255, 255, 255, 180)
        love.graphics.rectangle ("fill", 156 * 8, 0, 3 * 8, 14 * 8)

        if (Bee.rect.x > 157 * 8 and Boy.rect.x > 157 * 8) then
            Play.GAMEOVER = true
        end
    end

    love.graphics.setColor (255, 255, 255, 255)


    if Play.GAMEOVER then
        local lastShader = love.graphics.getShader ()
        love.graphics.setShader ()
        Camera.endGame ()
        love.graphics.setShader (lastShader)
    end
end

function Play.allChests ()
    local collected = 0
    for _,chest in pairs (Area.chests) do
        if chest.open then
            collected = collected + 1
        end
    end
    if collected == #Area.chests then
        Play.completed = true
        Play.allChestSound:play ()
    end
end 

return Play
