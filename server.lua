-- Bus Job Server Script

local QBCore = exports['qbx_core']:GetCoreObject()

-- Events
RegisterNetEvent('bus_job:completeRoute', function(earnings, passengers, distance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Add money
    Player.Functions.AddMoney('bank', earnings, 'Bus Job Route')
    
    -- Log
    print('^2[BUS JOB]^7 Player ' .. Player.PlayerData.name .. ' completed route and earned $' .. earnings)
    print(string.format('^2[BUS JOB]^7 Passengers: %d | Distance: %.1f km', passengers, distance))
    
    -- Trigger event for logging
    TriggerEvent('bus_job:routeCompleted', src, earnings, passengers, distance)
end)

RegisterNetEvent('bus_job:endRoute', function(status)
    local src = source
    print('^3[BUS JOB]^7 Player ' .. src .. ' ended route with status: ' .. status)
end)

-- Command to give bus items (admin)
RegisterCommand('givebusitems', function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return end
    
    -- Check if admin
    if not IsPlayerAceAllowed(source, 'admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {'System', 'You do not have permission to use this command!'}
        })
        return
    end
    
    print('^2[BUS JOB]^7 Admin ' .. Player.PlayerData.name .. ' gave bus job items')
end)

-- Callback for route info
RegisterCallback('bus_job:getRouteInfo', function(source, cb, routeId)
    local routes = {
        [1] = {name = 'Downtown', pay = 500},
        [2] = {name = 'Beach', pay = 750},
        [3] = {name = 'Airport', pay = 1200},
        [4] = {name = 'Suburban', pay = 1500},
    }
    
    if routes[routeId] then
        cb(routes[routeId])
    else
        cb(nil)
    end
end)

-- Database logging (optional)
if GetResourceState('oxmysql') == 'started' then
    local MySQL = exports.oxmysql
    
    RegisterNetEvent('bus_job:logRoute', function(playerId, earnings, passengers, distance)
        MySQL.insert('INSERT INTO bus_job_logs (player_id, earnings, passengers, distance, timestamp) VALUES (?, ?, ?, ?, NOW())', 
            {playerId, earnings, passengers, distance})
    end)
end

print('^2Bus Job Server Script Loaded^7')
