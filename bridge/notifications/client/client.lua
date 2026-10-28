function SendNotification(title, msg, type)
    lib.notify({
        title = title,
        description = msg,
        type = type or 'inform'
    })
end
