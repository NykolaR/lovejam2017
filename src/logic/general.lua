-- 
-- general.lua
-- General logic things
-- Mostly contains constants, a few functions though
--

local General = {}

General.Directions = {UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4,
    UPRIGHT = 5, DOWNRIGHT = 6, DOWNLEFT = 7, UPLEFT = 8, HORIZONTAL = 9, VERTICAL = 10}

General.dt = 0

-- Returns a random direction that *isn't* the argument direction
function General.randomFourWayDirection (notDirection)
    local nd = notDirection or 0
    local retVal = nd

    while (nd == retVal) do
        retVal = General.Random:random (1, 4)
    end
    return retVal
end

function General.oppositeDirection (dir)
    if not dir then return 0 end

    if dir == 1 then return 3 end
    if dir == 2 then return 4 end
    if dir == 3 then return 1 end
    if dir == 4 then return 2 end
    if dir == 5 then return 6 end
    if dir == 6 then return 5 end
    return 0
end

return General
