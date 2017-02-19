local Bee = {}

local Rectangle = require ("src.logic.rectangle")
local Quads = require ("src.logic.quads")
local General = require ("src.logic.general")
local Input = require ("src.boundary.input")

local Sound = require ("src.boundary.audio.bee")

Bee.rect = Rectangle (12 * 8, 15 * 8, 6, 2)
Bee.spriteSheet = love.graphics.newImage ("assets/visual/sprites/bee.png")
Bee.sprites = {}

Quads.generateQuads (Bee.sprites, Bee.spriteSheet, 8)

Bee.hSpeed, Bee.vSpeed = 0, 0
Bee.friction = 5
Bee.direction = General.Directions.RIGHT
Bee.grounded = false

Bee.frame = 1
Bee.framePoint, Bee.autoAdvance, Bee.animationSpeed = 0, 2, 3

Bee.maxHSpeed, Bee.maxVSpeed = 4, 4
Bee.speed = 8

function Bee.updateHorizontally (dt, moving)
    if moving and Input.keyDown (Input.KEYS.RIGHT) then
        Bee.hSpeed = Bee.hSpeed + (Bee.speed * dt)
    end

    if moving and Input.keyDown (Input.KEYS.LEFT) then
        Bee.hSpeed = Bee.hSpeed - (Bee.speed * dt)
    end

    if Bee.hSpeed > 0 then
        if Bee.hSpeed < (Bee.friction * dt) then
            Bee.hSpeed = 0
        else
            Bee.hSpeed = Bee.hSpeed - (Bee.friction * dt)
        end
    else
        if Bee.hSpeed > (-Bee.friction * dt) then
            Bee.hSpeed = 0
        else
            Bee.hSpeed = Bee.hSpeed + (Bee.friction * dt)
        end
    end

    Bee.framePoint = Bee.framePoint + Bee.autoAdvance

    if Bee.grounded and Bee.hSpeed == 0 then
        Bee.framePoint = 0
        Bee.frame = 1
    end

    if Bee.hSpeed < 0 then
        Bee.direction = General.Directions.LEFT
    end
    if Bee.hSpeed > 0 then
        Bee.direction = General.Directions.RIGHT
    end

    if math.abs (Bee.hSpeed) > Bee.maxHSpeed then
        if Bee.hSpeed < 0 then
            Bee.hSpeed = -Bee.maxHSpeed
        else
            Bee.hSpeed = Bee.maxHSpeed
        end
    end

    Bee.rect.x = Bee.rect.x + Bee.hSpeed

    if hSpeed == 0 then
        Bee.grounded = false
    end
end

function Bee.updateVertically (dt, moving)
    if moving and Input.keyDown (Input.KEYS.DOWN) then
        Bee.vSpeed = Bee.vSpeed + (Bee.speed * dt)
    end

    if moving and Input.keyDown (Input.KEYS.UP) then
        Bee.vSpeed = Bee.vSpeed - (Bee.speed * dt)
    end

    if Bee.vSpeed > 0 then
        if Bee.vSpeed < (Bee.friction * dt) then
            Bee.vSpeed = 0
        else
            Bee.vSpeed = Bee.vSpeed - (Bee.friction * dt)
        end
    else
        if Bee.vSpeed > (-Bee.friction * dt) then
            Bee.vSpeed = 0
        else
            Bee.vSpeed = Bee.vSpeed + (Bee.friction * dt)
        end
    end

    Bee.framePoint = Bee.framePoint + math.abs (Bee.vSpeed)

    if Bee.framePoint > Bee.animationSpeed then
        Bee.framePoint = 0

        if Bee.frame == 1 then
            Bee.frame = 2
        else
            Bee.frame = 1
        end
    end

    if math.abs (Bee.vSpeed) > Bee.maxVSpeed then
        if Bee.vSpeed < 0 then
            Bee.vSpeed = -Bee.maxVSpeed
        else
            Bee.vSpeed = Bee.maxVSpeed
        end
    end

    Bee.rect.y = Bee.rect.y + Bee.vSpeed

    if not (Bee.vSpeed == 0) or not (Bee.hSpeed == 0) then
        Bee.grounded = false
    end

    if Bee.grounded and Bee.hSpeed == 0 then
        Sound.endBuzz ()
    else
        Sound.startBuzz ()
    end

    Sound.setAttributes (Bee)
end

function Bee.render ()
    if Bee.direction == General.Directions.RIGHT then
            love.graphics.draw (Bee.spriteSheet, Bee.sprites [Bee.frame], math.floor (Bee.rect.x) - 1, math.floor (Bee.rect.y) - 3)
    else
            love.graphics.draw (Bee.spriteSheet, Bee.sprites [Bee.frame], math.floor (Bee.rect.x) + 7, math.floor (Bee.rect.y) - 3, 0, -1, 1)
    end

    --Bee.rect:render ()
end

function Bee.reset ()
    Bee.rect.x, Bee.rect.y = 0, 0
end

function Bee.environmentCollision (rect, direction)
    local col = Bee.rect:collision (rect)

    if not col then return end

    if direction == General.Directions.VERTICAL then
        if col [General.Directions.DOWN] then
            Bee.rect.y = rect.y - Bee.rect.height
            Bee.vSpeed = -Bee.vSpeed * 0.6
            if math.abs (Bee.vSpeed) > 2 then
                Bee.rect.y = Bee.rect.y + Bee.vSpeed
            end

            Bee.grounded = true
            if Bee.hSpeed == 0 then
                Sound.endBuzz ()
            end
        end

        if col [General.Directions.UP] then
            Bee.rect.y = rect.y + rect.height
            Bee.vSpeed = -Bee.vSpeed * 0.6
            if math.abs (Bee.vSpeed) > 2 then
                Bee.rect.y = Bee.rect.y + Bee.vSpeed
            end
        end
    end

    if direction == General.Directions.HORIZONTAL then
        if col [General.Directions.RIGHT] then
            Bee.rect.x = rect.x - Bee.rect.width
            Bee.hSpeed = -Bee.hSpeed * 0.6
            if math.abs (Bee.hSpeed) > 2 then
                Bee.rect.x = Bee.rect.x + Bee.hSpeed
            end
        end
    
        if col [General.Directions.LEFT] then
            Bee.rect.x = rect.x + rect.width
            Bee.hSpeed = -Bee.hSpeed * 0.6
            if math.abs (Bee.hSpeed) > 2 then
                Bee.rect.x = Bee.rect.x + Bee.hSpeed
            end
        end
    end
end

return Bee
