local Boy = {}

local Rectangle = require ("src.logic.rectangle")
local Quads = require ("src.logic.quads")
local General = require ("src.logic.general")
local Input = require ("src.boundary.input")

local Sound = require ("src.boundary.audio.boy")

Boy.rect = Rectangle (3 * 8, 21 * 8, 4, 8)
Boy.spriteSheet = love.graphics.newImage ("assets/visual/sprites/player.png")
Boy.spriteSheet:setFilter ("nearest", "nearest")
Boy.sprites = {}

Quads.generateQuads (Boy.sprites, Boy.spriteSheet, 8)

Boy.hSpeed, Boy.vSpeed = 0, 0
Boy.friction = 4
Boy.grounded, Boy.water = false, false
Boy.lastWater = false
Boy.groundDirection = General.Directions.RIGHT

Boy.frame = 1
Boy.framePoint, Boy.groundAnimationSpeed, Boy.waterAnimationSpeed = 0, 5, 5

Boy.speed = 7

Boy.maxHSpeed, Boy.maxVSpeed, Boy.jump = 3, 6, -3
Boy.maxWSpeed = 3

function Boy.updateHorizontally (dt, moving)
    if Boy.water then
        Boy.updateHorizontallyWater (dt, moving)
    else
        Boy.updateHorizontallyGround (dt, moving)
    end
end

function Boy.updateVertically (dt, moving)
    if Boy.water then
        Boy.updateVerticallyWater (dt, moving)
    else
        Boy.updateVerticallyGround (dt, moving)
    end

    Boy.lastWater = Boy.water
    Boy.water = false
end

function Boy.updateHorizontallyWater (dt, moving)
    if moving and Input.keyDown (Input.KEYS.RIGHT) then
        Boy.hSpeed = Boy.hSpeed + (Boy.speed * dt)
    end

    if moving and Input.keyDown (Input.KEYS.LEFT) then
        Boy.hSpeed = Boy.hSpeed - (Boy.speed * dt)
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

    if Boy.hSpeed < 0 then
        Boy.groundDirection = General.Directions.LEFT
    end
    if Boy.hSpeed > 0 then
        Boy.groundDirection = General.Directions.RIGHT
    end

    if math.abs (Boy.hSpeed) > Boy.maxWSpeed then
        if Boy.hSpeed < 0 then
            Boy.hSpeed = -Boy.maxWSpeed
        else
            Boy.hSpeed = Boy.maxWSpeed
        end
    end

    Boy.framePoint = Boy.framePoint + math.abs ((Boy.hSpeed + Boy.vSpeed) * 0.3)

    if Boy.framePoint > Boy.groundAnimationSpeed then
        Boy.framePoint = 0
        if Boy.frame == 1 then
            Boy.frame = 2
        else
            Boy.frame = 1
            Sound.SWIM:stop ()
            Sound.SWIM:setPosition (Boy.rect.x, Boy.rect.y)
            Sound.SWIM:setVolume (math.min (0.2, math.abs (Boy.hSpeed + Boy.vSpeed) * 0.02))
            Sound.SWIM:play ()
        end
    end


    Boy.rect.x = Boy.rect.x + Boy.hSpeed
end

function Boy.updateVerticallyWater (dt, moving)
    if moving and Input.keyDown (Input.KEYS.DOWN) then
        Boy.vSpeed = Boy.vSpeed + (Boy.speed * dt)
    end

    if moving and Input.keyDown (Input.KEYS.UP) then
        Boy.vSpeed = Boy.vSpeed - (Boy.speed * dt)
    end

    if Boy.vSpeed > 0 then
        if Boy.vSpeed < (Boy.friction * dt) then
            Boy.vSpeed = 0
        else
            Boy.vSpeed = Boy.vSpeed - (Boy.friction * dt)
        end
    else
        if Boy.vSpeed > (-Boy.friction * dt) then
            Boy.vSpeed = 0
        else
            Boy.vSpeed = Boy.vSpeed + (Boy.friction * dt)
        end
    end

    if math.abs (Boy.vSpeed) > Boy.maxWSpeed then
        if Boy.vSpeed < 0 then
            Boy.vSpeed = -Boy.maxWSpeed
        else
            Boy.vSpeed = Boy.maxWSpeed
        end
    end

    Boy.rect.y = Boy.rect.y + Boy.vSpeed
end

function Boy.updateHorizontallyGround (dt, moving)
    if Boy.grounded then
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
                    Sound.STEP:setPosition (Boy.rect.x, Boy.rect.y)
                    Sound.STEP:play ()
                end
            end
        end

        if Boy.hSpeed < 0 then
            Boy.groundDirection = General.Directions.LEFT
        end
        if Boy.hSpeed > 0 then
            Boy.groundDirection = General.Directions.RIGHT
        end
    else
        if moving and Input.keyDown (Input.KEYS.RIGHT) then
            Boy.hSpeed = Boy.hSpeed + (1 * dt)
        end

        if moving and Input.keyDown (Input.KEYS.LEFT) then
            Boy.hSpeed = Boy.hSpeed - (1 * dt)
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

function Boy.updateVerticallyGround (dt, moving)
    if moving and Boy.grounded and (Input.keyPressed (Input.KEYS.JUMP) or Input.keyPressed (Input.KEYS.UP)) then
        Boy.vSpeed = Boy.jump

        Sound.JUMP:setPosition (Boy.rect.x, Boy.rect.y)
        Sound.JUMP:play ()
    else
        Boy.gravity (dt)
    end

    if Boy.lastWater and math.abs (Boy.vSpeed) < 1.2 then
        Boy.vSpeed = -1.2
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

Boy.angle = 0

function Boy.render ()
    if Boy.water then
        local dy = Boy.rect.y - Boy.rect.yLast
        local dx = Boy.rect.x - Boy.rect.xLast

        if not (dy == 0) and not (dx == 0) then
            Boy.angle = math.atan (dy / dx) + 1.57
        end
        if dx == 0 and not (dy == 0) then
            Boy.groundDirection = General.Directions.RIGHT
            if dy > 0 then
                Boy.angle = math.pi
            else
                Boy.angle = 0
            end
        end
        if dy == 0 and not (dx == 0) then
            Boy.angle = 1.57
            if dx > 0 then
                Boy.groundDirection = General.Directions.RIGHT
            else
                Boy.groundDirection = General.Directions.LEFT
            end
        end

        if Boy.groundDirection == General.Directions.RIGHT then
            love.graphics.draw (Boy.spriteSheet, Boy.sprites [Boy.frame + 2], math.floor (Boy.rect.x) + 2, math.floor (Boy.rect.y) + 4, Boy.angle , 1, 1, 4, 4)
        else
            love.graphics.draw (Boy.spriteSheet, Boy.sprites [Boy.frame + 2], math.floor (Boy.rect.x) + 2, math.floor (Boy.rect.y) + 4, Boy.angle , 1, -1, 4, 4)
        end
    else
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

function Boy.environmentCollision (rect, direction)
    local col = Boy.rect:collision (rect)

    if not col then return end

    if direction == General.Directions.VERTICAL then
        if col [General.Directions.DOWN] then
            Boy.rect.y = rect.y - Boy.rect.height
            Boy.vSpeed = 0
            Boy.grounded = true
        end

        if col [General.Directions.UP] then
            Boy.rect.y = rect.y + rect.height
            Boy.vSpeed = 0
        end
    end

    if direction == General.Directions.HORIZONTAL then
        if col [General.Directions.RIGHT] then
            Boy.rect.x = rect.x - Boy.rect.width
            Boy.hSpeed = 0
        end
    
        if col [General.Directions.LEFT] then
            Boy.rect.x = rect.x + rect.width
            Boy.hSpeed = 0
        end
    end
end

function Boy.waterCollision (rect, direction)
    local col = Boy.rect:collision (rect)

    if not col then return end

    Boy.water = true

    if col [General.Directions.DOWN] then
        -- Play splash noise

        Sound.SPLASH:stop ()
        Sound.SPLASH:setVolume (math.min (Boy.vSpeed * 0.05, 0.4))
        Sound.SPLASH:setPosition (Boy.rect.x, Boy.rect.y)
        Sound.SPLASH:play ()

        Boy.vSpeed = Boy.vSpeed + 0.5
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

function Boy.chestCollision (chest, direction)
    local col = Boy.rect:collision (chest.rect)

    if not col then return end

    if not chest.open then
        chest.open = true
        Sound.CHEST:play ()

        if col [General.Directions.LEFT] or col [General.Directions.RIGHT] then
            Boy.hSpeed = 0
        else
            Boy.vSpeed = 0
        end
    end
end

return Boy
