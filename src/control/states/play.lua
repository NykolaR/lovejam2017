local Play = {}

local Area = require ("src.control.area")

function Play.loadArea ()
    Area.loadArea ()
end

function Play.update (dt)
    
end

function Play.render ()
    love.graphics.clear (120, 120, 120)

    Area.renderEnvironment ()
end

return Play
