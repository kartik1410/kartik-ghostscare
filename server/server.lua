local function isSeason()
    if #Config.Months == 0 then return true end

    local month = tonumber(os.date('%m'))
    for _, m in ipairs(Config.Months) do
        if m == month then return true end
    end

    return false
end

CreateThread(function()
    while true do
        GlobalState.ghostscareActive = isSeason()
        Wait(30 * 60000)
    end
end)

lib.addCommand('haunt', {
    help = 'Haunt a player',
    params = {
        { name = 'target', type = 'playerId', help = 'Player id', optional = true },
        { name = 'scare', type = 'string', help = 'glimpse, footsteps, blackout, phone, behind, road, jumpout, passenger, screamer, follow, angel, possessed, stalker', optional = true },
    },
    restricted = 'group.admin',
}, function(source, args)
    local target = args.target or source
    if target == 0 then return print('usage: haunt <id> [scare]') end

    TriggerClientEvent('kartik-ghostscare:client:haunt', target, args.scare)
end)

lib.addCommand('emf', {
    help = 'Toggle the EMF reader',
    restricted = 'group.admin',
}, function(source)
    if source == 0 then return end
    TriggerClientEvent('kartik-ghostscare:client:toggleEmf', source)
end)
