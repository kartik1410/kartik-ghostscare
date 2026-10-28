Scares = {}

local busy = false
local nextScare = 0
local hauntLevel = 0

local function isNight()
    local hour = GetClockHours()
    local from, to = Config.NightHours.from, Config.NightHours.to

    if from <= to then return hour >= from and hour < to end
    return hour >= from or hour < to
end

local function isAlone(pos)
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= cache.playerId and #(GetEntityCoords(GetPlayerPed(player)) - pos) < Config.AloneRadius then
            return false
        end
    end

    return true
end

local function getHotspotChance(pos)
    local chance = 0

    for _, spot in ipairs(Config.Hotspots) do
        if #(pos - spot.coords) < spot.radius then
            chance = math.max(chance, spot.chance)
        end
    end

    return chance
end

local function canBeHaunted()
    if not GlobalState.ghostscareActive or not isNight() then return false end
    if IsEntityDead(cache.ped) or GetInteriorFromEntity(cache.ped) ~= 0 then return false end

    return isAlone(GetEntityCoords(cache.ped))
end

function GetHauntTier()
    local tier = 0

    for i, threshold in ipairs(Config.Haunting.tiers) do
        if hauntLevel >= threshold then tier = i end
    end

    return tier
end

local function pickScare(only, anyTier)
    local tier = anyTier and math.huge or GetHauntTier()
    local pool, total = {}, 0

    for name, scare in pairs(Scares) do
        local settings = Config.Scares[name] or {}
        local weight

        if only then
            weight = name == only and 1 or 0
        else
            weight = (settings.tier or 1) <= tier and (settings.weight or 0) or 0
        end

        if weight > 0 and scare.canRun() then
            pool[#pool + 1] = { name = name, weight = weight }
            total = total + weight
        end
    end

    if total == 0 then return end

    local roll = math.random() * total
    for _, entry in ipairs(pool) do
        roll = roll - entry.weight
        if roll <= 0 then return entry.name end
    end

    return pool[#pool].name
end

local function runScare(name)
    busy = true
    local ok, played = pcall(Scares[name].run)
    busy = false

    if not ok then
        if IsScreenFadedOut() or IsScreenFadingOut() then DoScreenFadeIn(250) end
        print(('^1[kartik-ghostscare] %s scare errored: %s^0'):format(name, played))
        return
    end

    if not played then return end

    local minor = (Config.Scares[name] and Config.Scares[name].tier or 1) == 1
    local cooldown = minor and Config.MinorCooldown or Config.Cooldown
    nextScare = GetGameTimer() + math.random(cooldown.min, cooldown.max) * 60000

    if not minor then
        hauntLevel = math.max(0, hauntLevel - Config.Haunting.drop)
    end
end

CreateThread(function()
    while true do
        Wait(Config.CheckInterval * 1000)

        if canBeHaunted() then
            hauntLevel = math.min(100, hauntLevel + Config.Haunting.gain)

            if not busy and GetGameTimer() >= nextScare and not IsPauseMenuActive() then
                local chance = Config.Chance + getHotspotChance(GetEntityCoords(cache.ped))
                if Emf.IsOn() then chance = chance + Config.EmfChance end

                if math.random(100) <= chance then
                    local name = pickScare()
                    if name then runScare(name) end
                end
            end
        else
            hauntLevel = math.max(0, hauntLevel - Config.Haunting.decay)
        end
    end
end)

RegisterNetEvent('kartik-ghostscare:client:haunt', function(only)
    if busy then
        return SendNotification('Ghost Scare', 'A scare is already running', 'error')
    end

    if only and not Scares[only] then
        return SendNotification('Ghost Scare', ('Unknown scare: %s'):format(only), 'error')
    end

    local name = pickScare(only, true)
    if not name then
        return SendNotification('Ghost Scare', ('Can\'t run %s here'):format(only or 'a scare'), 'error')
    end

    CreateThread(function()
        runScare(name)
    end)
end)
