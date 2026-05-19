BusPlayerData = {
    currentRoute = nil,
    bus = nil,
    passengers = 0,
    earnings = 0,
    distance = 0,
    stops = {},
    currentStop = 0,
    speed = 0,
    damage = 0,
    fuel = 100,
    startTime = 0,
    stats = {
        totalTrips = 0,
        totalEarnings = 0,
        totalPassengers = 0,
        totalDistance = 0,
        accidents = 0,
        speedingTickets = 0,
    },
    inProgress = false,
    routeBlip = nil,
    stopBlips = {},
}

local busBlip = nil
local routeActive = false

-- Initialize
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print('^2Bus Job Script Started^7')
end)

-- Commands
RegisterCommand(Config.Commands.startRoute, function(source, args)
    if not args[1] then
        Utils.Notify('Bus Job', 'Usage: /' .. Config.Commands.startRoute .. ' [route_id]', 'error')
        return
    end
    
    local routeId = tonumber(args[1])
    if not Config.Routes[routeId] then
        Utils.Notify('Bus Job', 'Invalid route ID', 'error')
        return
    end
    
    if BusPlayerData.inProgress then
        Utils.Notify('Bus Job', 'You already have an active route', 'error')
        return
    end
    
    TriggerEvent('bus_job:startRoute', routeId)
end)

RegisterCommand(Config.Commands.endRoute, function(source, args)
    if not BusPlayerData.inProgress then
        Utils.Notify('Bus Job', 'You do not have an active route', 'error')
        return
    end
    
    TriggerEvent('bus_job:endRoute', 'cancelled')
end)

RegisterCommand(Config.Commands.routeList, function(source, args)
    print('^3=== Available Bus Routes ===^7')
    for routeId, route in pairs(Config.Routes) do
        print(string.format('^2Route %d:^7 %s (%s) - Distance: %.1f km - Est. Time: %d min - Pay: $%d', 
            routeId, route.name, route.difficulty, route.distance, route.estimatedTime, route.basePay))
    end
end)

RegisterCommand(Config.Commands.myStats, function(source, args)
    print('^3=== Your Bus Driver Stats ===^7')
    print(string.format('^2Total Trips:^7 %d', BusPlayerData.stats.totalTrips))
    print(string.format('^2Total Earnings:^7 $%d', BusPlayerData.stats.totalEarnings))
    print(string.format('^2Total Passengers:^7 %d', BusPlayerData.stats.totalPassengers))
    print(string.format('^2Total Distance:^7 %.1f km', BusPlayerData.stats.totalDistance / 1000))
    print(string.format('^2Accidents:^7 %d', BusPlayerData.stats.accidents))
    print(string.format('^2Speeding Tickets:^7 %d', BusPlayerData.stats.speedingTickets))
end)

-- Start Route Event
RegisterNetEvent('bus_job:startRoute', function(routeId)
    if BusPlayerData.inProgress then
        return
    end
    
    local route = Config.Routes[routeId]
    if not route then return end
    
    -- Spawn bus
    BusPlayerData.bus = Utils.SpawnVehicle(route.vehicle, route.startLocation.x, route.startLocation.y, route.startLocation.z, route.startLocation.h)
    
    if not BusPlayerData.bus then
        Utils.Notify('Bus Job', 'Failed to spawn bus', 'error')
        return
    end
    
    -- Setup route
    BusPlayerData.currentRoute = routeId
    BusPlayerData.passengers = 0
    BusPlayerData.earnings = 0
    BusPlayerData.distance = 0
    BusPlayerData.stops = route.stops
    BusPlayerData.currentStop = 1
    BusPlayerData.inProgress = true
    BusPlayerData.startTime = GetGameTimer()
    BusPlayerData.damage = 0
    BusPlayerData.fuel = 100
    
    -- Give keys
    TriggerEvent('vehiclekeys:client:SetVehicleProperties', BusPlayerData.bus, {})
    
    -- Create blips
    if Config.Blips.enabled then
        Effects.ClearWaypoint()
        
        -- Route blip at starting location
        BusPlayerData.routeBlip = AddBlipForCoord(route.startLocation.x, route.startLocation.y, route.startLocation.z)
        SetBlipSprite(BusPlayerData.routeBlip, Config.Blips.style)
        SetBlipColour(BusPlayerData.routeBlip, Config.Blips.color)
        SetBlipScale(BusPlayerData.routeBlip, Config.Blips.scale)
        AddTextComponentString(route.name)
        AddTextComponentString('Bus Route')
        
        -- Stop blips
        for _, stop in ipairs(route.stops) do
            local stopBlip = AddBlipForCoord(stop.coords.x, stop.coords.y, stop.coords.z)
            SetBlipSprite(stopBlip, Config.Blips.route)
            SetBlipColour(stopBlip, Config.Blips.color)
            SetBlipScale(stopBlip, Config.Blips.scale * 0.7)
            AddTextComponentString(stop.name)
            table.insert(BusPlayerData.stopBlips, stopBlip)
        end
    end
    
    Utils.Notify('Bus Job', 'Route started: ' .. route.name, 'success')
    Utils.Notify('Bus Job', 'Drive to the next stop', 'inform')
    
    -- Start route loop
    RouteLoop()
end)

-- Route Loop
function RouteLoop()
    while BusPlayerData.inProgress do
        local ped = Utils.GetPlayerPed()
        local route = Config.Routes[BusPlayerData.currentRoute]
        
        if not BusPlayerData.bus or not DoesEntityExist(BusPlayerData.bus) then
            Utils.Notify('Bus Job', 'Bus was destroyed!', 'error')
            BusPlayerData.inProgress = false
            break
        end
        
        if not Utils.IsPlayerInVehicle(BusPlayerData.bus) then
            Utils.Notify('Bus Job', 'You left the bus! Route cancelled', 'error')
            BusPlayerData.inProgress = false
            TriggerServerEvent('bus_job:endRoute', 'failed')
            break
        end
        
        -- Get current stop
        local currentStop = route.stops[BusPlayerData.currentStop]
        if not currentStop then
            -- Route completed
            TriggerEvent('bus_job:endRoute', 'completed', route)
            break
        end
        
        -- Check distance to stop
        local playerCoords = GetEntityCoords(ped)
        local distance = Utils.GetDistance(playerCoords.x, playerCoords.y, playerCoords.z, currentStop.coords.x, currentStop.coords.y, currentStop.coords.z)
        
        -- Draw marker at stop
        if distance < 50 then
            Utils.DrawMarker(2, currentStop.coords.x, currentStop.coords.y, currentStop.coords.z, 0, 0, 0, 0, 255, 0, 255, false, true, 2, true)
        end
        
        -- Check if reached stop
        if distance < 15 then
            HandleStop(currentStop)
            BusPlayerData.currentStop = BusPlayerData.currentStop + 1
        end
        
        -- Update HUD
        UpdateHUD(route, currentStop, distance)
        
        -- Check for violations
        CheckTrafficViolations(route)
        
        -- Check fuel
        if Config.Realistic.fuel then
            local speed = Utils.GetVehicleSpeedKmh(BusPlayerData.bus)
            if speed > 0 then
                local fuelConsumption = (Config.Realistic.fuelConsumption / 100) * (speed / 100)
                Utils.SetFuel(BusPlayerData.bus, GetVehicleFuelLevel(BusPlayerData.bus) - fuelConsumption)
                
                if GetVehicleFuelLevel(BusPlayerData.bus) < 5 then
                    Utils.Notify('Bus Job', 'WARNING: Low fuel!', 'error')
                end
            end
        end
        
        -- Check damage
        local health = Utils.GetVehicleHealthPercent(BusPlayerData.bus)
        if health < Config.TrafficRules.vehicleDamageThreshold then
            Utils.Notify('Bus Job', 'Bus too damaged! Route failed', 'error')
            BusPlayerData.inProgress = false
            TriggerServerEvent('bus_job:endRoute', 'failed')
            break
        end
        
        Wait(100)
    end
end

-- Handle Stop
function HandleStop(stop)
    local bus = BusPlayerData.bus
    
    -- Stop bus
    SetEntityVelocity(bus, 0.0, 0.0, 0.0)
    
    -- Open doors
    if Config.Realistic.doors then
        Effects.OpenBusDoorsAnimation(bus)
    end
    
    -- Passenger boarding
    Effects.PassengerBoarding(Config.TrafficRules.stopDuration)
    
    -- Passenger exiting
    Effects.PassengerExiting(1000)
    
    -- Close doors
    if Config.Realistic.doors then
        Effects.CloseBusDoorsAnimation(bus)
    end
    
    -- Add earnings
    local earnings = stop.passengers * Config.Routes[BusPlayerData.currentRoute].payPerPassenger
    BusPlayerData.earnings = BusPlayerData.earnings + earnings
    BusPlayerData.passengers = BusPlayerData.passengers + stop.passengers
    
    Utils.Notify('Bus Job', 'Passengers boarded: ' .. stop.passengers .. ' (+$' .. earnings .. ')', 'success')
end

-- Check Traffic Violations
function CheckTrafficViolations(route)
    local speed = Utils.GetVehicleSpeedKmh(BusPlayerData.bus)
    local speedLimit = Config.TrafficRules.speedLimitPerRoute[BusPlayerData.currentRoute] or 80
    
    if Config.TrafficRules.enforceSpeedLimit then
        if speed > speedLimit + Config.TrafficRules.maxSpeedExcess then
            local penalty = (speed - speedLimit) * Config.TrafficRules.speedPenalty
            BusPlayerData.earnings = BusPlayerData.earnings - penalty
            BusPlayerData.stats.speedingTickets = BusPlayerData.stats.speedingTickets + 1
            Utils.Notify('Bus Job', 'Speeding! -$' .. penalty, 'error')
        end
    end
end

-- Update HUD
function UpdateHUD(route, currentStop, distance)
    if not Config.HUD.enabled then return end
    
    -- HUD position
    local x = Config.HUD.position.x
    local y = Config.HUD.position.y
    
    -- Background
    DrawRect(x + 0.12, y + 0.10, 0.25, 0.25, 0, 0, 0, 200)
    
    -- Title
    Effects.DrawText('BUS JOB', x + 0.01, y + 0.01, 0.7, 0, 255, 0, 255)
    
    -- Route info
    if Config.HUD.showRoute then
        Effects.DrawText('Route: ' .. route.name, x + 0.01, y + 0.07, 0.4, 255, 255, 255, 255)
    end
    
    -- Current stop
    if Config.HUD.showRoute then
        Effects.DrawText('Stop: ' .. currentStop.name, x + 0.01, y + 0.11, 0.4, 255, 255, 255, 255)
        Effects.DrawText('Distance: ' .. string.format('%.0f m', distance), x + 0.01, y + 0.14, 0.4, 255, 255, 255, 255)
    end
    
    -- Passengers
    if Config.HUD.showPassengers then
        Effects.DrawText('Passengers: ' .. BusPlayerData.passengers, x + 0.01, y + 0.17, 0.4, 255, 255, 255, 255)
    end
    
    -- Speed
    if Config.HUD.showSpeed then
        local speed = Utils.GetVehicleSpeedKmh(BusPlayerData.bus)
        Effects.DrawText('Speed: ' .. speed .. ' km/h', x + 0.01, y + 0.20, 0.4, 255, 255, 255, 255)
    end
    
    -- Fuel
    if Config.HUD.showFuel and Config.Realistic.fuel then
        local fuel = math.floor(GetVehicleFuelLevel(BusPlayerData.bus))
        Effects.DrawText('Fuel: ' .. fuel .. '%', x + 0.01, y + 0.23, 0.4, 255, 255, 255, 255)
    end
    
    -- Earnings
    if Config.HUD.showEarnings then
        Effects.DrawText('Earnings: $' .. BusPlayerData.earnings, x + 0.01, y + 0.26, 0.4, 0, 255, 0, 255)
    end
end

-- End Route Event
RegisterNetEvent('bus_job:endRoute', function(status, route)
    BusPlayerData.inProgress = false
    
    local finalEarnings = BusPlayerData.earnings
    
    -- Calculate bonuses/penalties
    if status == 'completed' then
        -- On-time bonus
        if Config.Income.onTimeBonus then
            local timeTaken = (GetGameTimer() - BusPlayerData.startTime) / 60000
            local estimatedTime = route.estimatedTime
            if timeTaken <= estimatedTime then
                finalEarnings = finalEarnings + Config.Income.onTimeBonus
            end
        end
        
        -- Perfect bonus
        if Config.Income.perfectBonus then
            if BusPlayerData.stats.speedingTickets == 0 and Utils.GetVehicleHealthPercent(BusPlayerData.bus) > 80 then
                finalEarnings = finalEarnings + Config.Income.perfectBonus
            end
        end
        
        Utils.Notify('Bus Job', 'Route completed! Earned: $' .. finalEarnings, 'success')
    elseif status == 'failed' then
        finalEarnings = 0
        Utils.Notify('Bus Job', 'Route failed! No payment', 'error')
    else
        finalEarnings = math.floor(finalEarnings * 0.5)
        Utils.Notify('Bus Job', 'Route cancelled. Earned: $' .. finalEarnings, 'inform')
    end
    
    -- Apply tax
    if Config.Income.taxPercentage then
        local tax = math.floor(finalEarnings * (Config.Income.taxPercentage / 100))
        finalEarnings = finalEarnings - tax
    end
    
    -- Update stats
    BusPlayerData.stats.totalTrips = BusPlayerData.stats.totalTrips + 1
    BusPlayerData.stats.totalEarnings = BusPlayerData.stats.totalEarnings + finalEarnings
    BusPlayerData.stats.totalPassengers = BusPlayerData.stats.totalPassengers + BusPlayerData.passengers
    BusPlayerData.stats.totalDistance = BusPlayerData.stats.totalDistance + (route.distance * 1000)
    
    -- Send to server
    TriggerServerEvent('bus_job:completeRoute', finalEarnings, BusPlayerData.passengers, route.distance)
    
    -- Clean up
    if BusPlayerData.bus and DoesEntityExist(BusPlayerData.bus) then
        Utils.DeleteVehicle(BusPlayerData.bus)
    end
    
    BusPlayerData.bus = nil
    BusPlayerData.currentRoute = nil
    
    -- Remove blips
    if BusPlayerData.routeBlip then
        Effects.RemoveBlip(BusPlayerData.routeBlip)
    end
    for _, blip in ipairs(BusPlayerData.stopBlips) do
        Effects.RemoveBlip(blip)
    end
    BusPlayerData.stopBlips = {}
end)
