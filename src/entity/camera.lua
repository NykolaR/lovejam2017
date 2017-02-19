local Camera = {}

local _HALFSCREENWIDTH = 10 * 8
local _HALFSCREENHEIGHT = 9 * 8
local _SCREENWIDTH = 20 * 8
local _SCREENHEIGHT = 18 * 8

Camera.boundX, Camera.boundY = 0, 0
Camera.x, Camera.y = 0, 0
Camera.xLast, Camera.yLast = 0, 0
Camera.width, Camera.height = 20, 18
Camera.speed = 2.8

local shortMountain = love.graphics.newImage ("assets/visual/sprites/mountains1.png")
shortMountain:setWrap ("repeat", "clamp")
local shortMountainQuad = love.graphics.newQuad (0, 0, shortMountain:getWidth () * 3, shortMountain:getHeight (), shortMountain:getWidth (), shortMountain:getHeight ())
local tallMountain = love.graphics.newImage ("assets/visual/sprites/mountains2.png")
tallMountain:setWrap ("repeat", "clamp")
local tallMountainQuad = love.graphics.newQuad (0, 0, tallMountain:getWidth () * 6, tallMountain:getHeight (), tallMountain:getWidth (), tallMountain:getHeight ())

local cloudsThick = love.graphics.newImage ("assets/visual/sprites/cloudsthick.png")
cloudsThick:setWrap ("repeat", "clamp")
cloudsThin = love.graphics.newImage ("assets/visual/sprites/cloudsthin.png")
cloudsThin:setWrap ("repeat", "clamp")
local cloudsQuad = love.graphics.newQuad (0, 0, cloudsThick:getWidth () * 6, cloudsThick:getHeight (), cloudsThin:getWidth (), cloudsThick:getHeight ())
function Camera.setPosition (object)
    Camera.x, Camera.y = object.rect.x - _HALFSCREENWIDTH, object.rect.y - _HALFSCREENHEIGHT

    Camera.bound ()
end

function Camera.approach (object)
    --[[ object positions relative to camera--]]
    Camera.xLast, Camera.yLast = Camera.x, Camera.y
    
    local lx, ly = object.rect.x - _HALFSCREENWIDTH, object.rect.y - _HALFSCREENHEIGHT

    if (math.abs (Camera.x - lx) < Camera.speed) then
        Camera.x = lx
    else
        if Camera.x < lx then
            Camera.x = Camera.x + Camera.speed
        else
            Camera.x = Camera.x - Camera.speed
        end
    end

    if (math.abs (Camera.y - ly) < Camera.speed) then
        Camera.y = ly
    else
        if Camera.y < ly then
            Camera.y = Camera.y + Camera.speed
        else
            Camera.y = Camera.y - Camera.speed
        end
    end

    Camera.bound ()
    love.audio.setPosition (Camera.x + _HALFSCREENWIDTH, Camera.y + _HALFSCREENHEIGHT)
    love.audio.setVelocity (Camera.x - Camera.xLast, Camera.y - Camera.yLast)
    --love.audio.setPosition (object.rect.x, object.rect.y)
    --love.audio.setVelocity (object.hSpeed, object.vSpeed)
end

function Camera.bound ()
    if Camera.x < 0 then
        Camera.x = 0
    elseif Camera.x > Camera.boundX then
        Camera.x = Camera.boundX
    end

    if Camera.y < 0 then
        Camera.y = 0
    elseif Camera.y > Camera.boundY then
        Camera.y = Camera.boundY
    end
end

function Camera.clear ()
    --love.graphics.setColor (120, 120, 120)
    --love.graphics.rectangle ("fill", Camera.x, Camera.y, _SCREENWIDTH, _SCREENHEIGHT)
end

function Camera.setBounds (xMax, yMax)
    Camera.boundX, Camera.boundY = xMax - (_SCREENWIDTH), yMax - (_SCREENHEIGHT)
end

function Camera.update ()
    love.graphics.translate (math.floor (-Camera.x), math.floor (-Camera.y))
end

function Camera.renderParallex ()
    local renderX = math.floor (Camera.x * 0.9) + tallMountain:getWidth () * (math.floor (Camera.x / _SCREENWIDTH)) - _HALFSCREENWIDTH
    love.graphics.setColor (255, 255, 255, 128)
    love.graphics.draw (cloudsThin, cloudsQuad, renderX, 8 * 22)
    renderX = math.floor (Camera.x * 0.7) + tallMountain:getWidth () * (math.floor (Camera.x / _SCREENWIDTH)) - _HALFSCREENWIDTH
    love.graphics.draw (tallMountain, tallMountainQuad, renderX, 8 * 19)
    renderX = math.floor (Camera.x * 0.6) + tallMountain:getWidth () * (math.floor (Camera.x / _SCREENWIDTH)) - _HALFSCREENWIDTH
    love.graphics.draw (cloudsThick, cloudsQuad, renderX, 8 * 29)
    renderX = math.floor (Camera.x * 0.5) + shortMountain:getWidth () * (math.floor (Camera.x / _SCREENWIDTH)) - _HALFSCREENWIDTH
    love.graphics.setColor (255, 255, 255, 255)
    love.graphics.draw (shortMountain, shortMountainQuad, renderX, 8 * 27)

    love.graphics.setColor (255, 255, 255, 60)
    renderX = math.floor (Camera.x * 0.55) + tallMountain:getWidth () * (math.floor (Camera.x / _SCREENWIDTH)) - _HALFSCREENWIDTH
    love.graphics.draw (cloudsThick, cloudsQuad, renderX - 11, 8 * 29 + 3)
    love.graphics.setColor (255, 255, 255, 255)
end

return Camera
