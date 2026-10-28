if GetResourceState('qb-core') ~= 'started' or GetResourceState('qbx_core') == 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function CreateUseableItem(item, cb)
    QBCore.Functions.CreateUseableItem(item, function(source, itemData)
        cb(source, itemData)
    end)
end
