local Input = require ("src.boundary.input")

local font = love.graphics.newImageFont ("assets/visual/font.png",
    " abcdefghijklmnopqrstuvwxyz0123456789", 1)
love.graphics.setFont (font)

function love.load ()

end

function love.update (dt)
    Input.handleInputs ()
    checkQuit ()
end

function love.draw ()
    if Input.keyPressed (Input.KEYS.UP) then
        love.graphics.print ("hi there, this is a message 11011")
    end
end

function checkQuit ()
    if love.keyboard.isDown ("escape") then
        love.event.quit ()
    end
end
