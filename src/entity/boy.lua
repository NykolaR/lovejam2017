local Boy = {}

local Rectangle = require ("src.logic.rectangle")
local Quads = require ("src.logic.quads")
local General = require ("src.logic.general")
local Input = require ("src.boundary.input")

Boy.rect = Rectangle (12 * 8, 12 * 8, 4, 8)
Boy.spriteSheet = love.graphics.newImage ("assets/visual/sprites/player.png")
Boy.sprites = {}

Quads.generateQuads (Boy.sprites, Boy.spriteSheet, 8)

Boy.hSpeed, Boy.vSpeed = 0, 0
Boy.friction = 4
Boy.grounded, Boy.water = false, false
Boy.groundDirection = General.Directions.RIGHT

Boy.frame = 1
Boy.framePoint, Boy.groundAnimationSpeed, Boy.waterAnimationSpeed = 0, 5, 5

Boy.maxHSpeed, Boy.maxVSpeed, Boy.jump = 3, 6, -3

function Boy.updateHorizontally (dt, moving)
    if Boy.grounded and not Boy.water then
        if moving and Input.keyDown (Input.KEYS.RIGHT) then
            Boy.hSpeed = Boy.hSpeed + (6 * dt)
        end

        if moving and Input.keyDown (Input.KEYS.LEFT) then
            Boy.hSpeed = Boy.hSpeed - (6 * dt)
        end

        if Boy.hSpeed > 0 then
            if Boy.hSpeed < (Boy.friction * dt) then
                Boy.hSpeed = 0
            else
                Boy.hSpeed = Boy.hSpeed - (Boy.friction * dt)
            end
        else
            if Boy.hSpeed > (-Boy.friction * dt) then
                Boy.hSpeed = 0
            else
                Boy.hSpeed = Boy.hSpeed + (Boy.friction * dt)
            end
        end

        if math.abs (Boy.hSpeed) < (Boy.friction * dt) then
            Boy.frame = 1
        else
            Boy.framePoint = Boy.framePoint + math.abs (Boy.hSpeed)
            if Boy.framePoint > Boy.groundAnimationSpeed then
                Boy.framePoint = 0
                if Boy.frame == 1 then
                    Boy.frame = 2
                else
                    Boy.frame = 1
                end
            end
        end

        if Boy.hSpeed < 0 then
            Boy.groundDirection = General.Directions.LEFT
        end
        if Boy.hSpeed > 0 then
            Boy.groundDirection = General.Directions.RIGHT
        end
    end

    if math.abs (Boy.hSpeed) > Boy.maxHSpeed then
        if Boy.hSpeed < 0 then
            Boy.hSpeed = -Boy.maxHSpeed
        else
            Boy.hSpeed = Boy.maxHSpeed
        end
    end

    Boy.rect.x = Boy.rect.x + Boy.hSpeed
end

function Boy.updateVertically (dt, moving)
    if moving and Boy.grounded and Input.keyPressed (Input.KEYS.JUMP) then
        Boy.vSpeed = Boy.jump
    else
        Boy.gravity (dt)
    end

    if math.abs (Boy.vSpeed) > Boy.maxVSpeed then
        if Boy.vSpeed < 0 then
            Boy.vSpeed = -Boy.maxVSpeed
        else
            Boy.vSpeed = Boy.maxVSpeed
        end
    end

    Boy.rect.y = Boy.rect.y + Boy.vSpeed

    Boy.grounded = false
end

function Boy.gravity (dt)
    Boy.vSpeed = Boy.vSpeed + (10 * dt)
end

function Boy.render ()
    if not Boy.water then
        if Boy.groundDirection == General.Directions.RIGHT then
            love.graphics.draw (Boy.spriteSheet, Boy.sprites [Boy.frame], math.floor (Boy.rect.x) - 2, math.floor (Boy.rect.y))
        else
            love.graphics.draw (Boy.spriteSheet, Boy.sprites [Boy.frame], math.floor (Boy.rect.x) + 6, math.floor (Boy.rect.y), 0, -1, 1)
        end
    end

    --Boy.rect:render ()
end

function Boy.reset ()
    Boy.rect.x, Boy.rect.y = 0, 0
end

function Boy.environmentCollision (rect)
    local col = Boy.rect:collision (rect)

    if not col then return end

    if col [General.Directions.DOWN] then
        Boy.rect.y = rect.y - Boy.rect.height
        Boy.vSpeed = 0
        Boy.grounded = true
    end

    if col [General.Directions.UP] then
        Boy.rect.y = rect.y + rect.height
        Boy.vSpeed = 0
    end

    if col [General.Directions.RIGHT] then
        Boy.rect.x = rect.x - Boy.rect.width
        Boy.hSpeed = 0
    end

    if col [General.Directions.LEFT] then
        Boy.rect.x = rect.x + rect.width
        Boy.hSpeed = 0
    end
end

function Boy.beeCollision (bee)
    local beerect = bee.rect
    local col = Boy.rect:collision (beerect)

    if not col then return end

    if col [General.Directions.DOWN] then
        if bee.hSpeed == 0 then
            beerect.y = beerect.y + 0.1
            Boy.rect.y = beerect.y - Boy.rect.height
            Boy.vSpeed = 0
            Boy.grounded = true
        end
    end

    if col [General.Directions.UP] then
        bee.vSpeed = Boy.vSpeed * 0.8
        Boy.vSpeed = 0
    end
end

return Boy
