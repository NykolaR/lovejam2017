local Boy = {}

Boy.JUMP = love.audio.newSource ("assets/audio/effects/jump.wav")
Boy.JUMP:setVolume (0.4)

Boy.STEP = love.audio.newSource ("assets/audio/effects/step.wav")
Boy.STEP:setVolume (0.4)

return Boy
