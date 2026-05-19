Utils = {}

function Utils.Notify(title, message, type)
    type = type or 'inform'
    if Config.Notifications.style == 'standard' then
        TriggerEvent('QBCore:Notify', message, type, 5000)
    elseif Config.Notifications.style == 'advanced' then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {title, message}
        })
    end
end

function Utils.GetDistance(x1, y1, z1, x2, y2, z2)
    return #(vector3(x1, y1, z1) - vector3(x2, y2, z2))
end

function Utils.GetDistanceInKm(x1, y1, z1, x2, y2, z2)
    return Utils.GetDistance(x1, y1, z1, x2, y2, z2) / 1000
end

function Utils.GetDistance2D(x1, y1, x2, y2)
    return #(vector2(x1, y1) - vector2(x2, y2))
end

function Utils.LoadModel(modelHash)
    if not IsModelAHash(modelHash) then
        modelHash = GetHashKey(modelHash)
    end
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    return modelHash
end

function Utils.LoadDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    return dict
end

function Utils.PlayAnim(ped, dict, anim, flags)
    flags = flags or -1
    Utils.LoadDict(dict)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, flags, 0, false, false, false)
end

function Utils.GetPlayerPed()
    return PlayerPedId()
end

function Utils.GetPlayerCoords()
    return GetEntityCoords(Utils.GetPlayerPed())
end

function Utils.GetVehicleSpeed(vehicle)
    return GetEntitySpeed(vehicle)
end

function Utils.GetVehicleSpeedMph(vehicle)
    return math.floor(GetEntitySpeed(vehicle) * 2.236936)
end

function Utils.GetVehicleSpeedKmh(vehicle)
    return math.floor(GetEntitySpeed(vehicle) * 3.6)
end

function Utils.GetVehicleHealth(vehicle)
    return GetEntityHealth(vehicle)
end

function Utils.GetVehicleHealthPercent(vehicle)
    local health = GetEntityHealth(vehicle)
    local maxHealth = 1000
    return math.floor((health / maxHealth) * 100)
end

function Utils.GetFuel(vehicle)
    return GetVehicleFuelLevel(vehicle)
end

function Utils.SetFuel(vehicle, amount)
    SetVehicleFuelLevel(vehicle, amount)
end

function Utils.IsVehicleSeatFree(vehicle, seat)
    return IsVehicleSeatFree(vehicle, seat)
end

function Utils.WarpPlayerIntoVehicle(vehicle, seat)
    seat = seat or -1
    WarpCharIntoVehicle(Utils.GetPlayerPed(), vehicle, seat)
end

function Utils.GetVehicleInDirection(distance)
    local ped = Utils.GetPlayerPed()
    local pedCoords = GetEntityCoords(ped)
    local inDirection = GetOffsetFromEntityInWorldCoords(ped, 0.0, distance, 0.0)
    local vehicle = nil
    
    for v in EnumerateVehicles() do
        local vehicleCoords = GetEntityCoords(v)
        if Utils.GetDistance(pedCoords.x, pedCoords.y, pedCoords.z, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z) < distance then
            vehicle = v
        end
    end
    
    return vehicle
end

function Utils.IsPlayerInVehicle(vehicle)
    local ped = Utils.GetPlayerPed()
    return GetPedInVehicleSeat(vehicle, -1) == ped
end

function Utils.DrawText3D(x, y, z, text)
    local camCoords = GetGameplayCamCoord()
    local distance = Utils.GetDistance(camCoords.x, camCoords.y, camCoords.z, x, y, z)
    
    if distance < 100 then
        BeginTextCommandDisplayText('STRING')
        AddTextComponentString(text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 215)
        local factor = string.len(text) / 370
        DrawText(0.5 - factor / 2, 0.5)
        EndTextCommandDisplayText(0, vector3(x, y, z), false, true)
    end
end

function Utils.DrawMarker(type, x, y, z, dir, rot, scale, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
    DrawMarker(type, x, y, z, dir, rot, scale, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
end

function Utils.SpawnVehicle(modelName, x, y, z, heading)
    local modelHash = Utils.LoadModel(modelName)
    local vehicle = CreateVehicle(modelHash, x, y, z, heading, true, false)
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
    
    Wait(100)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleEngineHealth(vehicle, 1000)
    SetVehicleDeformationFixed(vehicle)
    SmashVehicleWindow(vehicle, 0, false)
    SmashVehicleWindow(vehicle, 1, false)
    SmashVehicleWindow(vehicle, 2, false)
    SmashVehicleWindow(vehicle, 3, false)
    
    return vehicle
end

function Utils.DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end

function Utils.SpawnPed(modelName, x, y, z, heading)
    local modelHash = Utils.LoadModel(modelName)
    local ped = CreatePed(4, modelHash, x, y, z, heading, true, false)
    
    return ped
end

function Utils.DeletePed(ped)
    if DoesEntityExist(ped) then
        DeleteEntity(ped)
    end
end

function Utils.TeleportToCoords(x, y, z)
    local ped = Utils.GetPlayerPed()
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoords(ped, x, y, z, false, false, false, false)
end

function Utils.Progressbar(duration, label)
    local start = GetGameTimer()
    
    while (GetGameTimer() - start) < duration do
        TriggerEvent('progressBar', label, duration)
        Wait(100)
    end
end

function Utils.GetRouteDistance(stops)
    local totalDistance = 0
    for i = 1, #stops - 1 do
        local currentStop = stops[i]
        local nextStop = stops[i + 1]
        totalDistance = totalDistance + Utils.GetDistance(currentStop.coords.x, currentStop.coords.y, currentStop.coords.z, nextStop.coords.x, nextStop.coords.y, nextStop.coords.z)
    end
    return totalDistance
end

-- Export functions
exports('StartBusRoute', function(routeId)
    TriggerEvent('bus_job:startRoute', routeId)
end)

exports('EndBusRoute', function()
    TriggerEvent('bus_job:endRoute')
end)

exports('GetCurrentRoute', function()
    return BusPlayerData.currentRoute
end)

exports('GetBusStats', function()
    return BusPlayerData.stats
end)

exports('IsPlayerOnBus', function()
    if BusPlayerData.bus and DoesEntityExist(BusPlayerData.bus) then
        return Utils.IsPlayerInVehicle(BusPlayerData.bus)
    end
    return false
end)
