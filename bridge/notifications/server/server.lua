function SendNotification(target, title, msg, type)
    if not target or target == -1 then return end

    TriggerClientEvent('ox_lib:notify', target, { title = title, description = msg, type = type or 'inform' })
end
