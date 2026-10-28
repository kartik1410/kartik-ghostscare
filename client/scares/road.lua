Scares.road = {
    canRun = function()
        local vehicle = Ghost.GetDrivenVehicle()
        return vehicle ~= nil and GetEntitySpeed(vehicle) > 8.0
    end,

    run = function()
        local vehicle = Ghost.GetDrivenVehicle()
        if not vehicle then return false end

        local target = GetEntityCoords(vehicle) + GetEntityForwardVector(vehicle) * 90.0
        local found, node = GetClosestVehicleNode(target.x, target.y, target.z, 0, 3.0, 0)
        if not found or Ghost.DistAhead(vehicle, node) < 50.0 then return false end

        local ghost = Ghost.Spawn(vector3(node.x, node.y, Ghost.GroundZ(node.x, node.y, node.z) or node.z))
        if not ghost then return false end

        Ghost.Stare(ghost)
        Ghost.Show(ghost, 600)

        local timeout = GetGameTimer() + 20000
        while GetGameTimer() < timeout and DoesEntityExist(ghost) and DoesEntityExist(vehicle) do
            local coords = GetEntityCoords(ghost)
            local dist = #(coords - GetEntityCoords(vehicle))
            local ahead = Ghost.DistAhead(vehicle, coords)

            if dist < 12.0 and ahead > 0.0 then
                Effects.StallEngine(vehicle, 3500)
                Effects.Jumpscare()
                Ghost.Vanish(ghost)
                return true
            end

            if dist > 150.0 or ahead < -5.0 then break end

            Wait(50)
        end

        Ghost.FadeOut(ghost)
        return true
    end,
}
