Effects = {}

function Effects.PlayNotificationSound()
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
end

function Effects.PlayErrorSound()
    PlaySoundFrontend(-1, 'ERROR', 'HUD_MINI_GAME_SOUNDSET', true)
end

function Effects.PlaySuccessSound()
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
end

function Effects.PlayWarningSound()
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
end

function Effects.CreateBlip(coords, sprite, color, scale, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    AddTextComponentString(label)
    SetBlipAsNoLongerNeeded(blip)
    return blip
end

function Effects.RemoveBlip(blip)
    if blip ~= nil then
        RemoveBlip(blip)
    end
end

function Effects.ShowAdvancedNotification(title, message, icon)
    icon = icon or 1
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    local iconType = 1
    EndTextCommandThefeedPostTxt(icon, icon, true, iconType, title, message)
end

function Effects.DrawScaleformMovieFullScreen(scaleform, red, green, blue, alpha)
    DrawScaleformMovieFullScreen(scaleform, red, green, blue, alpha, 0)
end

function Effects.LoadScaleform(scaleformName)
    local scaleform = RequestScaleformMovie(scaleformName)
    local loaded = false
    
    local timeout = 0
    while not loaded and timeout < 100 do
        if GetScaleformMovieMethods(scaleform) then
            loaded = true
        end
        Wait(10)
        timeout = timeout + 1
    end
    
    return scaleform
end

function Effects.PulseBus(vehicle, duration)
    duration = duration or 1000
    local start = GetGameTimer()
    
    while (GetGameTimer() - start) < duration do
        FlashActorIfPossible(vehicle)
        Wait(100)
    end
end

function Effects.ShowHUDDirectionalIndicator(direction)
    local scaleform = Effects.LoadScaleform('minimap')
    
    if direction == 'left' then
        CallScaleformMovieMethods(scaleform, 'SET_SPEED', 10.0)
    elseif direction == 'right' then
        CallScaleformMovieMethods(scaleform, 'SET_SPEED', -10.0)
    end
end

function Effects.ShowRadar(toggle)
    if toggle then
        DisplayRadar(true)
    else
        DisplayRadar(false)
    end
end

function Effects.ShowWaypoint(x, y, z)
    local groundZ = z
    local found = false
    
    for i = 0, 100 do
        if GetCollisionHeightForPoint(x, y, i * 10.0, groundZ) then
            found = true
            break
        end
    end
    
    SetNewWaypoint(x, y)
end

function Effects.ClearWaypoint()
    ClearGpsMultiRoute()
end

function Effects.AddRouteWaypoint(x, y, z)
    AddNextGpsMultiRoute(x, y)
end

function Effects.DrawRectangle(x, y, width, height, r, g, b, a)
    DrawRect(x, y, width, height, r, g, b, a)
end

function Effects.DrawText(text, x, y, scale, r, g, b, a)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function Effects.ShowSubtitle(text, duration)
    duration = duration or 3000
    BeginTextCommandPrint('STRING')
    AddTextComponentString(text)
    EndTextCommandPrint(duration, true)
end

function Effects.ShowLoadingBar(label, duration)
    local start = GetGameTimer()
    
    while (GetGameTimer() - start) < duration do
        DrawRect(0.5, 0.9, 0.3, 0.1, 0, 0, 0, 200)
        local progress = (GetGameTimer() - start) / duration
        DrawRect(0.35 + (progress * 0.3), 0.9, progress * 0.3, 0.08, 0, 255, 0, 200)
        
        BeginTextCommandDisplayText('STRING')
        AddTextComponentString(label)
        SetTextScale(0.5, 0.5)
        SetTextColour(255, 255, 255, 255)
        EndTextCommandDisplayText(0.5, 0.85, 0)
        
        Wait(0)
    end
end

function Effects.PlayAnimation(ped, dict, anim, duration)
    Utils.LoadDict(dict)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration, 0, 0, false, false, false)
end

function Effects.ShakeCam(duration, intensity)
    intensity = intensity or 0.5
    ShakeCam(GetGameplayCam(), duration, intensity)
end

function Effects.FreezePlayer(freeze)
    FreezeEntityPosition(Utils.GetPlayerPed(), freeze)
end

function Effects.FadeScreen(duration, fadeOut)
    if fadeOut then
        TriggerScreenblurFadeIn(duration)
    else
        TriggerScreenblurFadeOut(duration)
    end
end

function Effects.OpenBlur(strength)
    strength = strength or 0.5
    TriggerScreenblurFadeIn(strength * 1000)
end

function Effects.CloseBlur(duration)
    duration = duration or 500
    TriggerScreenblurFadeOut(duration)
end

function Effects.VehicleAlarm(vehicle, duration)
    duration = duration or 5000
    SmashVehicleWindow(vehicle, 0, false)
    SmashVehicleWindow(vehicle, 1, false)
end

function Effects.FlashVehicleLights(vehicle, duration)
    duration = duration or 5000
    local start = GetGameTimer()
    
    while (GetGameTimer() - start) < duration do
        SetVehicleIndicatorLights(vehicle, 0, true)
        SetVehicleIndicatorLights(vehicle, 1, true)
        Wait(500)
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
        Wait(500)
    end
end

function Effects.EnableEngineCheck(vehicle)
    if GetVehicleEngineHealth(vehicle) < 800 then
        SmokeyEffect(vehicle, 5.0, 8.0)
    end
end

function Effects.OpenBusDoorsAnimation(vehicle)
    TaskStartScenarioInPlace(Utils.GetPlayerPed(), 'WORLD_HUMAN_STUPOR', 0, true)
    Wait(500)
    SetVehicleDoorBroken(vehicle, 0, true)
    SetVehicleDoorBroken(vehicle, 1, true)
    Wait(1000)
    ClearPedTasksImmediately(Utils.GetPlayerPed())
end

function Effects.CloseBusDoorsAnimation(vehicle)
    TaskStartScenarioInPlace(Utils.GetPlayerPed(), 'WORLD_HUMAN_STUPOR', 0, true)
    Wait(500)
    SetVehicleDoorShut(vehicle, 0, false)
    SetVehicleDoorShut(vehicle, 1, false)
    Wait(1000)
    ClearPedTasksImmediately(Utils.GetPlayerPed())
end

function Effects.PassengerBoarding(duration)
    local start = GetGameTimer()
    
    while (GetGameTimer() - start) < duration do
        Utils.DrawText3D(GetEntityCoords(Utils.GetPlayerPed()).x, GetEntityCoords(Utils.GetPlayerPed()).y, GetEntityCoords(Utils.GetPlayerPed()).z + 1.0, 'Passengers boarding...')
        Effects.PlayNotificationSound()
        Wait(500)
    end
end

function Effects.PassengerExiting(duration)
    local start = GetGameTimer()
    
    while (GetGameTimer() - start) < duration do
        Utils.DrawText3D(GetEntityCoords(Utils.GetPlayerPed()).x, GetEntityCoords(Utils.GetPlayerPed()).y, GetEntityCoords(Utils.GetPlayerPed()).z + 1.0, 'Passengers getting off...')
        Effects.PlayNotificationSound()
        Wait(500)
    end
end
