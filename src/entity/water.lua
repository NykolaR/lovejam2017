local Water = {}
Water.__index = Water

setmetatable (Water, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

local Rectangle = require ("src.logic.rectangle")
local Palette = require ("src.boundary.palettes")

function Water:_init (x, y, w, h)
    self.rect = Rectangle (x, y, w, h)
end

local waterColor = 2

function Water:render ()
    local lastShader = love.graphics.getShader ()
    love.graphics.setShader ()
    love.graphics.setColor (Palette [Palette.current] [waterColor] [1], Palette [Palette.current] [waterColor] [2], Palette [Palette.current] [waterColor] [3], 180)
    love.graphics.rectangle ("fill", self.rect.x, self.rect.y - 2, self.rect.width, self.rect.height)
    --self.rect:render ()
    love.graphics.setColor (255, 255, 255, 255)
    love.graphics.setShader (lastShader)
end

return Water
