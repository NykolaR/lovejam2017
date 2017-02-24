local _INITIALWIDTH, _INITIALHEIGHT = 20 * 8, 18 * 8
local _CANVAS = love.graphics.newCanvas (_INITIALWIDTH, _INITIALHEIGHT, "rgba8")

local _SCALE = 3
local _SHADER = love.graphics.newShader ("assets/shaders/shade.glsl")
--local _PALETTEINDEX = 1

local _TITLESCREEN = love.graphics.newImage ("assets/visual/sprites/logo.png")
local _MUSIC = love.audio.newSource ("assets/audio/music/main.ogg", "stream")

local Play-- = require ("src.control.states.play")
local Pause = require ("src.control.states.pause")


local Input = require ("src.boundary.input")
local Palette = require ("src.boundary.palettes")

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)

local GAMESTATE = {PLAY = 1, PAUSE = 2, TITLE = 3}
local state = GAMESTATE.TITLE

local PauseSounds = require ("src.boundary.audio.pause")

function love.load ()
    love.window.setPosition (0, 0)
    _CANVAS:setFilter ("nearest", "nearest")
    Palette.loadPalette (_SHADER)

    _MUSIC:setLooping (true)
    _MUSIC:setVolume (0.5)
    _MUSIC:play ()

    love.audio.setDistanceModel ("linearclamped")
    --Play.loadArea ()
end

function love.update (dt)
    Input.handleInputs ()
    checkQuit ()

    if state == GAMESTATE.PLAY then
        Play.update (dt)
    end

    if state == GAMESTATE.PAUSE then
        Pause.update ()

        if Input.keyPressed (Input.KEYS.JUMP) then
            if Pause.selected == 1 then
                Palette.nextPalette (_SHADER)
            elseif Pause.selected == 2 then
                scaleScreen ()
            elseif Pause.selected == 3 then
                love.event.quit ()
            end
            PauseSounds.SELECT:play ()
        end
    end

    if Input.keyPressed (Input.KEYS.PAUSE) then
        if state == GAMESTATE.PLAY then
            state = GAMESTATE.PAUSE
            Pause.selected = 1
        elseif state == GAMESTATE.PAUSE then
            state = GAMESTATE.PLAY
        elseif state == GAMESTATE.TITLE then
            Play = require ("src.control.states.play")
            Play.loadArea ()
            state = GAMESTATE.PLAY
        end
        PauseSounds.OPEN:play ()
    end

    if Input.keyPressed (Input.KEYS.ACTION) then
        if state == GAMESTATE.PAUSE then
            state = GAMESTATE.PLAY
            PauseSounds.OPEN:play ()
        end
    end
end

function love.draw ()
    love.graphics.setCanvas (_CANVAS)
    love.graphics.setBlendMode ("alpha", "alphamultiply")

    love.graphics.clear (Palette [Palette.current] [3])
    love.graphics.setShader (_SHADER)

    if state == GAMESTATE.PLAY then
        Play.render ()
        love.graphics.origin ()
        love.graphics.setShader ()
    elseif state == GAMESTATE.PAUSE then
        Play.render ()
        love.graphics.origin ()
        love.graphics.setShader ()
        love.graphics.setColor (0, 0, 0, 128)
        love.graphics.rectangle ("fill", 0, 0, _INITIALWIDTH, _INITIALHEIGHT)
        love.graphics.setColor (255, 255, 255, 255)
        Pause.render ()
    elseif state == GAMESTATE.TITLE then
        love.graphics.draw (_TITLESCREEN, 0, 0)
        love.graphics.setShader ()
    end

    --love.graphics.setShader ()
    --love.graphics.setShader (_SHADER)
    love.graphics.setCanvas ()
    love.graphics.setBlendMode ("alpha", "premultiplied")
    love.graphics.setColor (255, 255, 255, 255)
    love.graphics.draw (_CANVAS, 0, 0, 0, _SCALE, _SCALE)
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
    Palette.loadPalette (_SHADER, Palette.current)
end
