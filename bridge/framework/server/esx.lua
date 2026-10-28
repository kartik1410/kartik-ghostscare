if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports['es_extended']:getSharedObject()

function CreateUseableItem(item, cb)
    ESX.RegisterUsableItem(item, function(source, itemName, itemData)
        cb(source, itemData)
    end)
end
