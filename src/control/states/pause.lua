local Pause = {}

local Input = require ("src.boundary.input")
local Palette = require ("src.boundary.palettes")

Pause.OPTIONS = {"  palette  ", "screen size", "   quit   "}
Pause.selected = 1

function Pause.update ()
    if Input.keyPressed (Input.KEYS.UP) then
        Pause.selected = Pause.selected - 1
        if Pause.selected < 1 then
            Pause.selected = #Pause.OPTIONS
        end
    end

    if Input.keyPressed (Input.KEYS.DOWN) then
        Pause.selected = Pause.selected + 1
        if Pause.selected > #Pause.OPTIONS then
            Pause.selected = 1
        end
    end
end

function Pause.render ()
    love.graphics.setColor (Palette [Palette.current] [5])
    love.graphics.rectangle ("fill", 5 * 8 - 2, 6, 10 * 8 + 4, 10 * 8 + 4, 8, 8, 2)
    love.graphics.setColor (Palette [Palette.current] [1])
    love.graphics.rectangle ("fill", 5 * 8, 8, 10 * 8, 10 * 8, 8, 8, 2)


    love.graphics.setColor (Palette [Palette.current] [5])
    

    love.graphics.print ("   pause   ", 6 * 8, 2 * 8)

    for i,text in pairs (Pause.OPTIONS) do
        if i == Pause.selected then
            love.graphics.setColor (Palette [Palette.current] [5])
        else
            love.graphics.setColor (Palette [Palette.current] [3])
        end

        if i == 3 then
            love.graphics.print (Pause.OPTIONS [i], 6 * 8 + 4, (3 + (i * 2)) * 8)
        else
            love.graphics.print (Pause.OPTIONS [i], 6 * 8, (3 + (i * 2)) * 8)
        end
    end
end

return Pause
