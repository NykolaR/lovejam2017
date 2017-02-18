local Camera = {}

local _HALFSCREENWIDTH = 10 * 8
local _HALFSCREENHEIGHT = 9 * 8
local _SCREENWIDTH = 20 * 8
local _SCREENHEIGHT = 18 * 8

Camera.boundX, Camera.boundY = 0, 0
Camera.x, Camera.y = 0, 0
Camera.speed = 64

function Camera.setPosition (object)
    Camera.x, Camera.y = object.rect.x - _HALFSCREENWIDTH, object.rect.y - _HALFSCREENHEIGHT

    Camera.bound ()
end

function Camera.approach (object)
    --[[ object positions relative to camera--]]
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
    love.graphics.rectangle ("fill", Camera.x, Camera.y, _SCREENWIDTH, _SCREENHEIGHT)
end

function Camera.setBounds (xMax, yMax)
    Camera.boundX, Camera.boundY = xMax - (_SCREENWIDTH), yMax - (_SCREENHEIGHT)
end

function Camera.update ()
    love.graphics.translate (-Camera.x, -Camera.y)
end

return Camera
