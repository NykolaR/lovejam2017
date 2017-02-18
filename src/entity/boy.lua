local Boy = {}

local Rectangle = require ("src.logic.rectangle")
local General = require ("src.logic.general")
local Input = require ("src.boundary.input")

Boy.rect = Rectangle (12 * 8, 12 * 8, 8, 8)

Boy.xSpeed, Boy.ySpeed = 0, 0

function Boy.update (dt)
    Boy.rect:setLastPosition ()

    Boy.act (dt)
end

function Boy.updateHorizontally (dt)
    if Input.keyDown (Input.KEYS.RIGHT) then
        Boy.rect.x = Boy.rect.x + 1
    end

    if Input.keyDown (Input.KEYS.LEFT) then
        Boy.rect.x = Boy.rect.x - 1
    end
end

function Boy.updateVertically (dt)
    Boy.gravity (dt)
end

function Boy.gravity (dt)
    Boy.rect.y = Boy.rect.y + (200 * dt)
end

function Boy.render ()
    Boy.rect:render ()
end

function Boy.reset ()
    Boy.rect.x, Boy.rect.y = 0, 0
end

function Boy.environmentCollision (rect)
    local col = Boy.rect:collision (rect)

    if not col then return end

    if col [General.Directions.DOWN] then
        Boy.rect.y = rect.y - rect.height
    end

    if col [General.Directions.UP] then
        Boy.rect.y = rect.y + rect.height
    end

    if col [General.Directions.RIGHT] then
        Boy.rect.x = rect.x - rect.width
    end

    if col [General.Directions.LEFT] then
        Boy.rect.x = rect.x + rect.width
    end
end

return Boy
