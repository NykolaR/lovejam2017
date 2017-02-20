local Bee = {}

local rate, bits, channels = 16000, 8, 1
local samples = rate / 1024
Bee.soundData = love.sound.newSoundData (samples, rate, bits, channels)

love.math.setRandomSeed (0)

-- Generate noise
for i=0, samples - 1 do
    local nextSample = love.math.random ()
    if love.math.random (2) == 1 then
        nextSample = -nextSample
    end
    Bee.soundData:setSample (i, nextSample)
end

Bee.sound = love.audio.newSource (Bee.soundData)
Bee.sound:setLooping (true)
Bee.sound:setVolume (0.013)
Bee.sound:setPitch (0.2)
Bee.sound:setRelative (false)
Bee.sound:setAttenuationDistances (1, 82)
love.audio.play (Bee.sound)

function Bee.startBuzz ()
    Bee.sound:setVolume (0.013)
end

function Bee.endBuzz ()
    Bee.sound:setVolume (0.0)
end

function Bee.setAttributes (bee)
    Bee.sound:setPosition (bee.rect.x + 4, bee.rect.y + 4)
    Bee.sound:setVelocity (bee.hSpeed, bee.vSpeed)
end

return Bee
