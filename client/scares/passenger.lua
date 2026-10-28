local function getCar()
    local vehicle = Ghost.GetDrivenVehicle()
    if not vehicle then return end
    if GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) < 2 or not IsVehicleSeatFree(vehicle, 0) then return end

    return vehicle
end

Scares.passenger = {
    canRun = function()
        return getCar() ~= nil
    end,

    run = function()
        local vehicle = getCar()
        if not vehicle then return false end

        local ghost = Ghost.Spawn(GetEntityCoords(vehicle), 0.0, true)
        if not ghost then return false end

        SetPedIntoVehicle(ghost, vehicle, 0)
        SetPedCanBeDraggedOut(ghost, false)
        TaskLookAtEntity(ghost, cache.ped, -1, 2048, 3)

        Effects.KillRadio(vehicle)
        CreateThread(function()
            Effects.FlickerLights(vehicle, 4)
        end)
        Ghost.Show(ghost, 2500)

        local timeout = GetGameTimer() + 12000
        while GetGameTimer() < timeout and DoesEntityExist(ghost) do
            if cache.vehicle ~= vehicle then break end

            if Ghost.LookDot(GetEntityCoords(ghost)) > 0.85 then
                Wait(700)
                Effects.Jumpscare()
                Ghost.Vanish(ghost)
                return true
            end

            Wait(100)
        end

        Ghost.FadeOut(ghost)
        return true
    end,
}
