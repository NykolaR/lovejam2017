local Play = {}

local Area = require ("src.control.area")
local Camera = require ("src.entity.camera")
local Boy = require ("src.entity.boy")

function Play.reset ()
    
end

function Play.loadArea ()
    Area.loadArea ()
    Camera.setBounds (Area.width * Area.tileSize, Area.height * Area.tileSize)
end

function Play.update (dt)
    Play.updateBoy (dt)
end

function Play.updateBoy (dt)
    Boy.rect:setLastPosition ()
    Boy.updateVertically (dt)
    Play.playableCollide (Boy)
    Boy.updateHorizontally (dt)
    Play.playableCollide (Boy)
end

function Play.playableCollide (playable)
    for _,r in pairs (Area.collisions) do
        playable.environmentCollision (r)
    end
end

function Play.render ()
    Camera.setPosition (Boy)
    Camera.update ()
    Camera.clear ()
    --love.graphics.clear (120, 120, 120)

    Area.renderEnvironment ()
    Boy.render ()

    --[[for _,r in pairs (Area.collisions) do
        r:render ()
    end]]
end

return Play
