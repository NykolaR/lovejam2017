local Pause = {}

Pause.OPEN = love.audio.newSource ("assets/audio/effects/pause.wav")
Pause.OPEN:setVolume (0.4)

Pause.SELECT = love.audio.newSource ("assets/audio/effects/select.wav")
Pause.SELECT:setVolume (0.4)

Pause.MOVE = love.audio.newSource ("assets/audio/effects/pausemove.wav")
Pause.MOVE:setVolume (0.4)

return Pause
