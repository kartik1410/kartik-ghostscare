if GetResourceState('qbx_core') ~= 'started' then return end

function CreateUseableItem(item, cb)
    exports.qbx_core:CreateUseableItem(item, function(source, itemData)
        cb(source, itemData)
    end)
end
