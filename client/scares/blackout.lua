Scares.blackout = {
    canRun = function()
        return true
    end,

    run = function()
        PlaySoundFrontend(-1, 'Power_Down', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
        Effects.LightsOut()

        if cache.vehicle then
            CreateThread(function() Effects.FlickerLights(cache.vehicle, 8) end)
        end

        Wait(math.random(3000, 5000))
        Effects.LightsBack()
        return true
    end,
}
