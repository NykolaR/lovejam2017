function love.conf (t)
    -- Disable mouse
    t.modules.touch = false

    t.window.title = "Boy and Bee"
    t.window.width, t.window.height = 20 * 8 * 3, 18 * 8 * 3

    t.window.resizeable = false
end
