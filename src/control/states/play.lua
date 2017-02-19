local Play = {}

local Area = require ("src.control.area")
local Camera = require ("src.entity.camera")
local Boy = require ("src.entity.boy")
local Bee = require ("src.entity.bee")
local Input = require ("src.boundary.input")
local General = require ("src.logic.general")

Play.boyMove = true

function Play.reset ()
    
end

function Play.loadArea ()
    Area.loadArea ()
    Camera.setBounds (Area.width * Area.tileSize, Area.height * Area.tileSize)
end

function Play.update (dt)
    if Input.keyPressed (Input.KEYS.ACTION) then
        Play.boyMove = not Play.boyMove
    end

    Play.updateBeeAndBoy (dt)
end

function Play.updateBeeAndBoy (dt)
    Boy.rect:setLastPosition ()
    Bee.rect:setLastPosition ()
    Boy.updateVertically (dt, Play.boyMove)
    Boy.beeCollision (Bee)
    Bee.updateVertically (dt, (not Play.boyMove))
    Play.playableCollide (Boy)
    Play.playableCollide (Bee, General.Directions.VERTICAL)
    Boy.updateHorizontally (dt, Play.boyMove)
    Bee.updateHorizontally (dt, (not Play.boyMove))
    Play.playableCollide (Boy)
    Play.playableCollide (Bee, General.Directions.HORIZONTAL)
end

function Play.playableCollide (playable, direction)
    for _,r in pairs (Area.collisions) do
        playable.environmentCollision (r, direction)
    end
end

function Play.render ()
    if Play.boyMove then
        Camera.approach (Boy)
    else
        Camera.approach (Bee)
    end
    Camera.update ()
    Camera.clear ()
    --love.graphics.clear (120, 120, 120)

    Area.renderEnvironment ()
    Boy.render ()
    Bee.render ()

    --[[for _,r in pairs (Area.collisions) do
        r:render ()
    end]]
end

return Play
