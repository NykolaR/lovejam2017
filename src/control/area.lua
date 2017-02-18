local Area = {}

Area.environment = {}
Area.collisions = {}

Area.width = 0
Area.height = 0
Area.tileSize = 0

local Rectangle = require ("src.logic.rectangle")
local Quads = require ("src.logic.quads")

Area.tileSheet = love.graphics.newImage ("assets/visual/tiles/environment.png")
Area.tiles = {}
Quads.generateQuads (Area.tiles, Area.tileSheet, 8)

function Area.loadArea ()
    local data = require ("assets.maps.test")
    Area.environment = {}

    Area.width, Area.height = data.width, data.height

    Area.tileSize = data.tilewidth

    for i = 1, (Area.width * Area.height) do
        table.insert (Area.environment, data.layers [1].data [i])
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

function Area.renderEnvironment ()
    local index = 1

    for y=0, Area.height - 1 do
        for x=0, Area.width - 1 do
            if not (Area.environment [index] == 0) then
                love.graphics.draw (Area.tileSheet, Area.tiles [Area.environment [index]] , x * Area.tileSize, y * Area.tileSize)
            end
            index = index + 1
        end
    end
end

return Area
