-- 
-- quads.lua
-- Constains quad functions

local Quads = {}

-- Generates quads for a tilesheet
-- Args: table to store quads, tilesheet image, tile size
function Quads.generateQuads (quadTable, image, tilesizeX, tsizeY)
    tilesizeY = tsizeY or tilesizeX
    for y = 0, (image:getHeight () / tilesizeY - 1) do
        for x = 0, (image:getWidth () / tilesizeX - 1) do
            table.insert (quadTable, love.graphics.newQuad (x * tilesizeX, y * tilesizeY, tilesizeX, tilesizeY, image:getWidth (), image:getHeight ()))
        end
    end
end

return Quads
