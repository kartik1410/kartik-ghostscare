local function follow(ghost)
    TaskFollowToOffsetOfEntity(ghost, cache.ped, 0.0, -3.0, 0.0, 1.5, -1, 1.5, true)
end

Scares.stalker = {
    canRun = function()
        return not cache.vehicle
    end,

    run = function()
        local spot = Ghost.PointBehind(10.0)
        if not spot then return false end

        local ghost = Ghost.Spawn(spot, 0.0, true)
        if not ghost then return false end

        follow(ghost)

        local endAt = GetGameTimer() + math.random(20000, 35000)
        local nextShimmer = GetGameTimer() + math.random(4000, 8000)

        while GetGameTimer() < endAt and DoesEntityExist(ghost) do
            if cache.vehicle then
                Ghost.Remove(ghost)
                return true
            end

            local now = GetGameTimer()
            if #(GetEntityCoords(ghost) - GetEntityCoords(cache.ped)) > 12.0 then
                local behind = Ghost.PointBehind(6.0)
                if behind then
                    SetEntityCoords(ghost, behind.x, behind.y, behind.z, false, false, false, false)
                    follow(ghost)
                end
            end

            if now >= nextShimmer and IsEntityOnScreen(ghost) then
                SetEntityAlpha(ghost, 45, false)
                Wait(120)
                SetEntityAlpha(ghost, 0, false)
                nextShimmer = now + math.random(4000, 8000)
            end

            Wait(200)
        end

        if not DoesEntityExist(ghost) then return true end

        ClearPedTasksImmediately(ghost)
        local front = Ghost.PointFromCam(0, 0.8)
        if front then SetEntityCoords(ghost, front.x, front.y, front.z, false, false, false, false) end
        FreezeEntityPosition(ghost, true)
        SetEntityCollision(ghost, false, false)
        Ghost.Face(ghost)
        ResetEntityAlpha(ghost)

        Effects.FaceCloseUp(ghost)
        Ghost.Remove(ghost)
        return true
    end,
}
