local Chest = {}
Chest.__index = Chest

setmetatable (Chest, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

local Rectangle = require ("src.logic.rectangle")

function Chest:_init (x, y)
    self.rect = Rectangle (x, y, 8, 8)
    self.open = false
end

return Chest
