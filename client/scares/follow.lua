Scares.follow = {
    canRun = function()
        return not cache.vehicle
    end,

    run = function()
        local spot = Ghost.PointBehind(25.0)
        if not spot then return false end

        local ghost = Ghost.Spawn(spot)
        if not ghost then return false end

        Ghost.Stare(ghost)
        Ghost.Show(ghost, 2000)

        local timeout = GetGameTimer() + 90000
        local lastMove = GetGameTimer()
        local closeSince

        while GetGameTimer() < timeout and DoesEntityExist(ghost) do
            local now = GetGameTimer()
            local playerPos = GetEntityCoords(cache.ped)
            local ghostPos = GetEntityCoords(ghost)
            local dist = #(ghostPos - playerPos)

            if dist > 80.0 or cache.vehicle then break end

            if dist < 2.5 then
                closeSince = closeSince or now
                if Ghost.LookDot(ghostPos) > 0.5 or now - closeSince > 8000 then
                    Effects.Jumpscare()
                    Ghost.Vanish(ghost)
                    return true
                end
            elseif Ghost.LookDot(ghostPos) < 0.3 and now - lastMove > 2500 then
                local step = math.min(5.0, dist - 1.5)
                local dir = (playerPos - ghostPos) / dist
                local x, y = ghostPos.x + dir.x * step, ghostPos.y + dir.y * step
                local z = Ghost.GroundZ(x, y, playerPos.z)

                if z then
                    SetEntityCoords(ghost, x, y, z, false, false, false, false)
                    Ghost.Face(ghost)
                end

                lastMove = now
            end

            Wait(200)
        end

        Ghost.FadeOut(ghost)
        return true
    end,
}
