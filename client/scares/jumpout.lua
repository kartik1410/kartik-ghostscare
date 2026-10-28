Scares.jumpout = {
    canRun = function()
        local vehicle = Ghost.GetDrivenVehicle()
        return vehicle ~= nil and GetEntitySpeed(vehicle) > 10.0
    end,

    run = function()
        local vehicle = Ghost.GetDrivenVehicle()
        if not vehicle then return false end

        local speed = GetEntitySpeed(vehicle)
        local dist = math.max(15.0, speed * 1.1)
        local pos = GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle) * dist
        local z = Ghost.GroundZ(pos.x, pos.y, pos.z)
        if not z then return false end

        local ghost = Ghost.Spawn(vector3(pos.x, pos.y, z))
        if not ghost then return false end

        Ghost.Stare(ghost)
        SetEntityAlpha(ghost, Config.GhostAlpha, false)

        local timeout = GetGameTimer() + 4000
        while GetGameTimer() < timeout and DoesEntityExist(ghost) and DoesEntityExist(vehicle) do
            local coords = GetEntityCoords(ghost)
            if #(coords - GetEntityCoords(vehicle)) < 4.0 or Ghost.DistAhead(vehicle, coords) < 0.0 then
                Effects.Jumpscare()
                Effects.StallEngine(vehicle, 2500)
                break
            end
            Wait(0)
        end

        Ghost.Vanish(ghost)
        return true
    end,
}
