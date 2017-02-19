local Area = {}

Area.environment = {}
Area.below = {}
Area.above = {}

Area.collisions = {}

Area.width = 0
Area.height = 0
Area.tileSize = 0

local Rectangle = require ("src.logic.rectangle")
local Quads = require ("src.logic.quads")
local Camera = require ("src.entity.camera")

Area.tileSheet = love.graphics.newImage ("assets/visual/tiles/tileset.png")
Area.tiles = {}
Quads.generateQuads (Area.tiles, Area.tileSheet, 8)

function Area.loadArea ()
    local data = require ("assets.maps.test2")
    Area.environment = {}

    Area.width, Area.height = data.width, data.height

    Area.tileSize = data.tilewidth

    for i = 1, (Area.width * Area.height) do
        table.insert (Area.environment, data.layers [1].data [i])
        table.insert (Area.below, data.layers [2].data [i])
        table.insert (Area.above, data.layers [3].data [i])
    end

    for i = 1, #Area.environment do
        if not (Area.environment [i] == 0) then
            table.insert (Area.collisions, Rectangle (Area.getX (i - 1), Area.getY (i - 1), Area.tileSize, Area.tileSize))
        end
    end

end

function Area.getX (index)
    -- Position goes from 0 to Area.width * tileSize
    return (index % Area.width) * Area.tileSize
end

function Area.getY (index)
    -- Position goes from 0 to Area.height * tileSize
    return math.floor (index / Area.width) * Area.tileSize
end

Area.shiftWidth, Area.shiftHeight = 21 * 8, 19 * 8

function Area.renderEnvironment ()
    local index = 1
    local xMin, yMin, xMax, yMax = Camera.x - 8, Camera.y - 8, Camera.x + Area.shiftWidth, Camera.y + Area.shiftHeight

    for y=0, Area.height - 1 do
        for x=0, Area.width - 1 do
            if ((x * 8) > xMin and (x * 8) < xMax) and ((y * 8) > yMin and (y * 8) < yMax) then
                if not (Area.environment [index] == 0) then
                    love.graphics.draw (Area.tileSheet, Area.tiles [Area.environment [index]] , x * Area.tileSize, y * Area.tileSize)
                end
            end
            index = index + 1
        end
    end
end

function Area.renderAbove ()
    local index = 1
    local xMin, yMin, xMax, yMax = Camera.x - 8, Camera.y - 8, Camera.x + Area.shiftWidth, Camera.y + Area.shiftHeight

    for y=0, Area.height - 1 do
        for x=0, Area.width - 1 do
            if ((x * 8) > xMin and (x * 8) < xMax) and ((y * 8) > yMin and (y * 8) < yMax) then
                if not (Area.above [index] == 0) then
                    --love.graphics.draw (Area.decoration, Area.decorationTiles [2], x * Area.tileSize, y * Area.tileSize)
                    --love.graphics.draw (Area.decoration, Area.decorationTiles [Area.above [index]], x * Area.tileSize, y * Area.tileSize)
                    love.graphics.draw (Area.tileSheet, Area.tiles [Area.above [index]] , x * Area.tileSize, y * Area.tileSize)
                end
            end
            index = index + 1
        end
    end
end

function Area.renderBelow ()
    local index = 1
    local xMin, yMin, xMax, yMax = Camera.x - 8, Camera.y - 8, Camera.x + Area.shiftWidth, Camera.y + Area.shiftHeight

    for y=0, Area.height - 1 do
        for x=0, Area.width - 1 do
            if ((x * 8) > xMin and (x * 8) < xMax) and ((y * 8) > yMin and (y * 8) < yMax) then
                if not (Area.below [index] == 0) then
                    love.graphics.draw (Area.tileSheet, Area.tiles [Area.below [index]], x * Area.tileSize, y * Area.tileSize)
                end
            end
            index = index + 1
        end
    end
end

return Area
