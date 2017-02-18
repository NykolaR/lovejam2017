-- 
-- rectangle.lua
-- Contains rectangle information and functions
-- Features intersect, collisions, etc
--

local Rectangle = {}
Rectangle.__index = Rectangle

setmetatable (Rectangle, {
    __call = function (cls, ...)
        local self = setmetatable ({}, cls)
        self:_init (...)
        return self
    end,
})

-- REQUIRED MODULES --

local Constants = require ("src.logic.general")

-- END MODULES --

function Rectangle:_init (x, y, width, height, xShift, yShift)
    self.x = x or 0
    self.y = y or 0
    self.xLast = x or 0
    self.yLast = y or 0
    self.width = width or 1
    self.height = height or 1

    self.x = self.x + (xShift or 0)
    self.y = self.y + (yShift or 0)
end

-- Sets position
-- Call after movement in update
function Rectangle:setPosition (x, y)
    self.x = x
    self.y = y
end

-- Sets last position
-- Call before movement in update
function Rectangle:setLastPosition (x, y)
    self.xLast = x or self.x
    self.yLast = y or self.y
end

-- Returns whether there was a collision with the arg rectangle
-- Also returns which direction collided in a table
function Rectangle:collision (rectangle)
    local ret = {false, false, false, false}
    --[[
    -- 1 = up
    -- 2 = right
    -- 3 = down
    -- 4 = left
    --]]

    if self:intersects (rectangle) then
        ret [Constants.Directions.UP] = self:collidedTop (rectangle)
        ret [Constants.Directions.RIGHT] = self:collidedRight (rectangle)
        ret [Constants.Directions.DOWN] = self:collidedBottom (rectangle)
        ret [Constants.Directions.LEFT] = self:collidedLeft (rectangle)
    end

    return ret
end

-- Returns whether the rectangles have an overlap in X values
function Rectangle:horizontalOverlap (rectangle)
    if self.x < rectangle.x then
        return ((self.x + self.width) > rectangle.x)
    else
        return ((rectangle.x + rectangle.width) > self.x)
    end
end

-- Returns whether the rectangles have an overlap in Y values
function Rectangle:verticalOverlap (rectangle)
    if self.y < rectangle.y then
        return ((self.y + self.height) > rectangle.y)
    else
        return ((rectangle.y + rectangle.height) > self.y)
    end
end

function Rectangle:collidedTop (rectangle)
    if ( (self.x > (rectangle.x - self.width)) and (self.x < rectangle.x + rectangle.width) ) then
        return (   (self.yLast >= (rectangle.y + rectangle.height))   and   (self.y <= (rectangle.y + rectangle.height))   )
    end
    return false
end

function Rectangle:collidedRight (rectangle)
    if ((self.y > (rectangle.y - self.height)) and (self.y < rectangle.y + rectangle.height)) then
        return (   ((self.xLast + self.width) <= rectangle.x)   and    ((self.x + self.width) >= rectangle.x)   )
    end
    return false
end

function Rectangle:collidedBottom (rectangle)
    if ((self.x > (rectangle.x - self.width)) and (self.x < rectangle.x + rectangle.width)) then
        return (   ((self.yLast + self.height) <= rectangle.y)   and   ((self.y + self.height) >= rectangle.y)   )
    end
    return false
end

function Rectangle:collidedLeft (rectangle)
    if ( (self.y > (rectangle.y - self.height)) and (self.y < rectangle.y + rectangle.height) ) then
        return (   (self.xLast >= (rectangle.x + rectangle.width))   and   (self.x <= (rectangle.x + rectangle.width))   )
    end
    return false
end

function Rectangle:intersects (other)
    if ( ((self.x + self.width) < other.x) or ((other.x + other.width) < self.x)
        or ((self.y + self.height) < other.y) or ((other.y + other.height) < self.y)) then
        return false
    end
    return true
end

function Rectangle:resetX ()
    self.x = self.xLast
end

function Rectangle:resetY ()
    self.y = self.yLast
end

function Rectangle:render ()
    love.graphics.rectangle ("fill", self.x, self.y, self.width, self.height)
end

return Rectangle
