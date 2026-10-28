if not CreateUseableItem then
    return print('^3[kartik-ghostscare] No framework found, use /emf for the EMF reader^0')
end

CreateUseableItem(Config.EmfItem, function(source)
    TriggerClientEvent('kartik-ghostscare:client:toggleEmf', source)
end)
