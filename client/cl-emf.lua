Emf = {}

local isOn = false
local level = 0

local beepDelay = { 1600, 1000, 600, 320, 140 }
local barColours = {
    { 80, 200, 90 },
    { 80, 200, 90 },
    { 230, 200, 60 },
    { 240, 130, 40 },
    { 230, 50, 50 },
}

local function readLevel()
    local dist = Ghost.NearestDistance()
    if dist and dist < Config.EmfRange then
        return math.max(1, math.ceil(5 * (1.0 - dist / Config.EmfRange)))
    end

    local base = GetHauntTier()
    local pos = GetEntityCoords(cache.ped)
    for _, spot in ipairs(Config.Hotspots) do
        if #(pos - spot.coords) < spot.radius then
            base = base + 1
            break
        end
    end

    if base == 0 then return 0 end
    return math.min(4, base + math.random(0, 1))
end

local function drawMeter()
    local x, y = 0.5, 0.93
    DrawRect(x, y, 0.13, 0.06, 0, 0, 0, 170)

    SetTextFont(4)
    SetTextScale(0.0, 0.32)
    SetTextColour(220, 220, 220, 255)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName('EMF')
    EndTextCommandDisplayText(x, y - 0.031)

    for i = 1, 5 do
        local c = barColours[i]
        DrawRect(x - 0.048 + (i - 1) * 0.024, y + 0.008, 0.018, 0.022, c[1], c[2], c[3], i <= level and 255 or 50)
    end
end

function Emf.IsOn()
    return isOn
end

function Emf.Toggle()
    isOn = not isOn
    SendNotification('EMF Reader', isOn and 'Switched on' or 'Switched off', isOn and 'success' or 'inform')
    if not isOn then return end

    CreateThread(function()
        while isOn do
            level = readLevel()
            Wait(300)
        end
        level = 0
    end)

    CreateThread(function()
        local nextBeep = 0

        while isOn do
            if IsEntityDead(cache.ped) then
                isOn = false
                break
            end

            drawMeter()

            if level > 0 and GetGameTimer() >= nextBeep then
                PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
                nextBeep = GetGameTimer() + beepDelay[level]
            end

            Wait(0)
        end
    end)
end

RegisterNetEvent('kartik-ghostscare:client:toggleEmf', Emf.Toggle)
