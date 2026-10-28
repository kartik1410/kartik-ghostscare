Scares.phone = {
    canRun = function()
        return true
    end,

    run = function()
        PlayPedRingtone('Remote_Ring', cache.ped, true)
        Wait(math.random(4000, 6000))
        StopPedRingtone(cache.ped)

        SendNotification('Missed Call', 'Unknown number', 'error')
        return true
    end,
}
