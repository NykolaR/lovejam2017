local _INITIALWIDTH, _INITIALHEIGHT = 20 * 8, 18 * 8
local _CANVAS = love.graphics.newCanvas (_INITIALWIDTH, _INITIALHEIGHT, "rgba8")

local _SCALE = 1
local _SHADER = love.graphics.newShader ("assets/shaders/shade.glsl")
local _PALETTEINDEX = 1

local Play = require ("src.control.states.play")
local Input = require ("src.boundary.input")
local Palette = require ("src.boundary.palettes")

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)

function love.load ()
    love.window.setPosition (0, 0)
    _CANVAS:setFilter ("nearest", "nearest")
    Palette.loadPalette (_SHADER, _PALETTEINDEX)

    Play.loadArea ()

    scaleScreen ()
    scaleScreen ()
    scaleScreen ()
end

function love.update (dt)
    Input.handleInputs ()
    checkQuit ()

    Play.update (dt)
end

function love.draw ()
    love.graphics.setCanvas (_CANVAS)
    love.graphics.setBlendMode ("alpha", "alphamultiply")

    love.graphics.clear (Palette [_PALETTEINDEX] [3])

    love.graphics.setShader (_SHADER)
    Play.render ()

    love.graphics.origin ()
    love.graphics.setShader ()
    love.graphics.setCanvas ()
    love.graphics.setBlendMode ("alpha", "premultiplied")
    love.graphics.draw (_CANVAS, 0, 0, 0, _SCALE, _SCALE)

    --[[if Input.keyPressed (Input.KEYS.DOWN) then
        scaleScreen ()
    end]]
end

function checkQuit ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
end

function scaleScreen ()
    --local w1, h1 = love.window.getMode ()
    local w2, h2 = _INITIALWIDTH * (_SCALE + 1), _INITIALHEIGHT * (_SCALE + 1)
    local dw, dh = love.window.getDesktopDimensions ()

    if (w2 > dw or h2 > dh) then
        w2, h2 = _INITIALWIDTH, _INITIALHEIGHT
        _SCALE = 1
    else
        _SCALE = _SCALE + 1
    end

    love.window.setMode (w2, h2)
    love.window.setPosition (0, 0)

    _SHADER = love.graphics.newShader ("assets/shaders/shade.glsl")
    Palette.loadPalette (_SHADER, _PALETTEINDEX)
end
