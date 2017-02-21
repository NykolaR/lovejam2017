local Boy = {}

Boy.JUMP = love.audio.newSource ("assets/audio/effects/jump.wav")
Boy.JUMP:setVolume (0.4)

Boy.STEP = love.audio.newSource ("assets/audio/effects/step.wav")
Boy.STEP:setVolume (0.4)

Boy.SPLASH = love.audio.newSource ("assets/audio/effects/water.wav")
Boy.SPLASH:setVolume (0.4)

Boy.SWIM = love.audio.newSource ("assets/audio/effects/swim.wav")

Boy.CHEST = love.audio.newSource ("assets/audio/effects/chest.wav")
Boy.CHEST:setVolume (0.4)

return Boy
