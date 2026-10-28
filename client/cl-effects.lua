Effects = {}

function Effects.Jumpscare()
    PlaySoundFrontend(-1, 'ScreenFlash', 'WastedSounds', true)
    ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.25)
    AnimpostfxPlay('DeathFailMPIn', 0, false)

    SetTimeout(900, function()
        AnimpostfxStop('DeathFailMPIn')
    end)
end

function Effects.ScreamFace(ped)
    local dict = IsPedMale(ped) and 'facials@gen_male@base' or 'facials@gen_female@base'
    if pcall(lib.requestAnimDict, dict) then
        PlayFacialAnim(ped, 'burning_1', dict)
    end
end

function Effects.Scream(ped, voice)
    StopPedSpeaking(ped, false)
    DisablePedPainAudio(ped, false)
    Effects.ScreamFace(ped)

    if voice then
        PlayPedAmbientSpeechWithVoiceNative(ped, 'SCREAM_TERROR', voice, 'SPEECH_PARAMS_FORCE_SHOUTED_CRITICAL', false)
    else
        PlayPedAmbientSpeechNative(ped, 'SCREAM_TERROR', 'SPEECH_PARAMS_FORCE_SHOUTED_CRITICAL')
    end

    SetTimeout(150, function()
        if not DoesEntityExist(ped) or IsAnySpeechPlaying(ped) then return end
        PlayPedAmbientSpeechWithVoiceNative(ped, 'SCREAM_PANIC', 'WAVELOAD_PAIN_FEMALE', 'SPEECH_PARAMS_FORCE_SHOUTED_CRITICAL', false)
    end)
end

local function makeCam(pos, target, fov)
    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, fov, false, 0)
    PointCamAtCoord(cam, target.x, target.y, target.z)
    return cam
end

local function closeUp(ped, cams)
    local head = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local fwd = GetEntityForwardVector(ped)

    local far = makeCam(head + fwd * 1.4, head, 45.0)
    local near = makeCam(vector3(head.x + fwd.x * 0.42, head.y + fwd.y * 0.42, head.z - 0.03), head, 50.0)
    cams[1], cams[2] = far, near

    SetCamActive(far, true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamActiveWithInterp(near, far, 120, 1, 1)
    ShakeCam(near, 'LARGE_EXPLOSION_SHAKE', 0.3)

    Effects.Scream(ped, 'WAVELOAD_PAIN_FEMALE')
    PlaySoundFrontend(-1, 'ScreenFlash', 'WastedSounds', true)
    AnimpostfxPlay('DeathFailMPIn', 0, false)

    local untilTime = GetGameTimer() + 1300
    local nextFace = GetGameTimer() + 400
    while GetGameTimer() < untilTime do
        HideHudAndRadarThisFrame()
        if GetGameTimer() >= nextFace then
            Effects.ScreamFace(ped)
            nextFace = GetGameTimer() + 400
        end
        Wait(0)
    end
end

function Effects.FaceCloseUp(ped)
    Wait(50)

    local cams = {}
    local ok = pcall(closeUp, ped, cams)

    RenderScriptCams(false, false, 0, true, true)
    for _, cam in pairs(cams) do DestroyCam(cam, false) end
    AnimpostfxStop('DeathFailMPIn')

    return ok
end

function Effects.Chill()
    PlaySoundFrontend(-1, 'Bed', 'WastedSounds', true)
    ShakeGameplayCam('HAND_SHAKE', 0.6)

    SetTimeout(2500, function()
        StopGameplayCamShaking(false)
    end)
end

function Effects.LightsOut()
    SetArtificialLightsStateAffectsVehicles(false)
    SetArtificialLightsState(true)
end

function Effects.LightsBack()
    SetArtificialLightsState(GlobalState.blackout == true or GlobalState.blackOut == true)
end

function Effects.FlickerLights(vehicle, times)
    for _ = 1, times or 6 do
        if not DoesEntityExist(vehicle) then break end
        SetVehicleLights(vehicle, 1)
        Wait(math.random(60, 180))
        SetVehicleLights(vehicle, 2)
        Wait(math.random(60, 180))
    end

    if DoesEntityExist(vehicle) then SetVehicleLights(vehicle, 0) end
end

function Effects.KillRadio(vehicle)
    if DoesEntityExist(vehicle) then SetVehRadioStation(vehicle, 'OFF') end
end

function Effects.StallEngine(vehicle, ms)
    if not DoesEntityExist(vehicle) then return end

    SetVehicleEngineOn(vehicle, false, true, true)

    CreateThread(function()
        Effects.FlickerLights(vehicle, 5)
        Wait(ms or 3000)
        if DoesEntityExist(vehicle) then SetVehicleEngineOn(vehicle, true, false, true) end
    end)
end
