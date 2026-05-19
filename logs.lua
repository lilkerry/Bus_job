-- Bus Job Logging System

local BusJobLogs = {}

-- Log route completion
AddEventHandler('bus_job:routeCompleted', function(playerId, earnings, passengers, distance)
    local logEntry = {
        playerId = playerId,
        earnings = earnings,
        passengers = passengers,
        distance = distance,
        timestamp = os.time(),
    }
    
    table.insert(BusJobLogs, logEntry)
    
    -- Console log
    print('^3[BUS JOB LOG]^7 Player: ' .. playerId .. ' | Earnings: $' .. earnings .. ' | Passengers: ' .. passengers .. ' | Distance: ' .. string.format('%.1f', distance) .. ' km')
end)

-- Get logs command
RegisterCommand('busJobLogs', function(source)
    if not IsPlayerAceAllowed(source, 'admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {'System', 'You do not have permission!'}
        })
        return
    end
    
    print('^3=== Bus Job Logs ===^7')
    for i, log in ipairs(BusJobLogs) do
        print(string.format('%d. Player: %d | $%d | %d passengers | %.1f km', 
            i, log.playerId, log.earnings, log.passengers, log.distance))
    end
    print('^3===================^7')
end)

-- Clear logs command
RegisterCommand('clearBusJobLogs', function(source)
    if not IsPlayerAceAllowed(source, 'admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {'System', 'You do not have permission!'}
        })
        return
    end
    
    BusJobLogs = {}
    print('^2Bus Job logs cleared^7')
end)

-- Export function to get logs
exports('GetBusJobLogs', function()
    return BusJobLogs
end)

-- Get total stats
exports('GetBusJobStats', function()
    local totalEarnings = 0
    local totalPassengers = 0
    local totalDistance = 0
    local totalRoutes = #BusJobLogs
    
    for _, log in ipairs(BusJobLogs) do
        totalEarnings = totalEarnings + log.earnings
        totalPassengers = totalPassengers + log.passengers
        totalDistance = totalDistance + log.distance
    end
    
    return {
        totalRoutes = totalRoutes,
        totalEarnings = totalEarnings,
        totalPassengers = totalPassengers,
        totalDistance = totalDistance,
    }
end)
