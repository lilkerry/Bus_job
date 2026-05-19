Config = {}

Config.Debug = false

-- Framework
Config.Framework = 'qbx' -- 'qbx' or 'qbcore'

-- Bus Routes Configuration
Config.Routes = {
    [1] = {
        name = 'Downtown Route',
        description = 'Start: Central Station → Downtown → City Center',
        vehicle = 'bus',
        startLocation = {x = 425.5, y = -986.5, z = 29.4, h = 0.0},
        endLocation = {x = 425.5, y = -986.5, z = 29.4, h = 0.0},
        distance = 5.2, -- km
        estimatedTime = 12, -- minutes
        basePay = 500,
        payPerPassenger = 25,
        payPerKm = 15,
        stops = {
            {name = 'Central Station', coords = {x = 425.5, y = -986.5, z = 29.4}, passengers = 3},
            {name = 'Bus Stop 1', coords = {x = 311.45, y = -265.4, z = 45.16}, passengers = 2},
            {name = 'Bus Stop 2', coords = {x = 138.32, y = 222.15, z = 104.28}, passengers = 4},
            {name = 'Downtown Station', coords = {x = -425.63, y = -312.26, z = 36.37}, passengers = 5},
            {name = 'City Center', coords = {x = -545.71, y = -875.12, z = 29.30}, passengers = 2},
        },
        difficulty = 'easy',
    },
    [2] = {
        name = 'Beach Route',
        description = 'Start: Station → Vinewood → Beach → Del Perro',
        vehicle = 'bus',
        startLocation = {x = -425.63, y = -312.26, z = 36.37, h = 90.0},
        endLocation = {x = -425.63, y = -312.26, z = 36.37, h = 90.0},
        distance = 8.5,
        estimatedTime = 18,
        basePay = 750,
        payPerPassenger = 30,
        payPerKm = 20,
        stops = {
            {name = 'Downtown Station', coords = {x = -425.63, y = -312.26, z = 36.37}, passengers = 4},
            {name = 'Vinewood Sign', coords = {x = 707.43, y = 57.32, z = 88.04}, passengers = 3},
            {name = 'Beach Way', coords = {x = -1289.36, y = -1286.15, z = 5.30}, passengers = 6},
            {name = 'Del Perro Station', coords = {x = -1580.52, y = -1190.45, z = 26.55}, passengers = 4},
            {name = 'Beach Pier', coords = {x = -1553.25, y = -1412.32, z = 6.50}, passengers = 2},
        },
        difficulty = 'normal',
    },
    [3] = {
        name = 'Airport Route',
        description = 'Start: Pillbox → MRPD → Airport → Highway',
        vehicle = 'bus',
        startLocation = {x = 425.5, y = -986.5, z = 29.4, h = 180.0},
        endLocation = {x = 425.5, y = -986.5, z = 29.4, h = 180.0},
        distance = 12.3,
        estimatedTime = 25,
        basePay = 1200,
        payPerPassenger = 40,
        payPerKm = 25,
        stops = {
            {name = 'Police Station', coords = {x = 425.5, y = -986.5, z = 29.4}, passengers = 3},
            {name = 'Medical Center', coords = {x = 295.12, y = -350.25, z = 45.15}, passengers = 5},
            {name = 'Highway Exit', coords = {x = 1200.45, y = -550.32, z = 69.21}, passengers = 4},
            {name = 'Airport Entrance', coords = {x = -1033.42, y = -2730.56, z = 21.36}, passengers = 8},
            {name = 'Terminal 1', coords = {x = -1043.25, y = -2851.45, z = 13.95}, passengers = 3},
        },
        difficulty = 'hard',
    },
    [4] = {
        name = 'Suburban Route',
        description = 'Start: Rancho → Paleto Bay → Chiliad → Return',
        vehicle = 'bus',
        startLocation = {x = 350.25, y = -500.15, z = 35.4, h = 270.0},
        endLocation = {x = 350.25, y = -500.15, z = 35.4, h = 270.0},
        distance = 15.8,
        estimatedTime = 32,
        basePay = 1500,
        payPerPassenger = 35,
        payPerKm = 30,
        stops = {
            {name = 'Sandy Shores Station', coords = {x = 1936.45, y = 3816.32, z = 32.27}, passengers = 2},
            {name = 'Paleto Bay', coords = {x = -97.45, y = 6232.15, z = 31.49}, passengers = 4},
            {name = 'Mount Chiliad', coords = {x = 511.35, y = 5591.45, z = 796.62}, passengers = 1},
            {name = 'Grapeseed', coords = {x = 2542.32, y = 4661.25, z = 44.18}, passengers = 3},
            {name = 'Rancho Station', coords = {x = 350.25, y = -500.15, z = 35.4}, passengers = 2},
        },
        difficulty = 'very_hard',
    },
}

-- Passenger System
Config.PassengerSystem = {
    enabled = true,
    randomPassengers = true, -- Spawn random passengers at stops
    passengerModels = {
        'a_m_m_business_1',
        'a_m_m_business_2',
        'a_f_m_business_1',
        'a_f_m_business_2',
        'a_m_y_business_1',
        'a_f_y_business_1',
    },
    passengerDialogue = {
        'Thanks for the ride!',
        'Great service!',
        'Have a good day!',
        'See you next time!',
        'Thanks driver!',
    },
    passengerWaitTime = 2000, -- ms before passenger enters bus
}

-- Traffic Rules
Config.TrafficRules = {
    enforceSpeedLimit = true,
    speedLimitPerRoute = {
        [1] = 100, -- km/h
        [2] = 80,
        [3] = 100,
        [4] = 80,
    },
    maxSpeedExcess = 20, -- km/h over limit before penalty
    speedPenalty = -50, -- $ per km/h over
    enforceStops = true, -- Must stop at each stop
    stopDuration = 3000, -- ms at each stop
    enforcePassengerPickup = true,
    enforcePassengerDropoff = true,
}

-- Damage System
Config.DamageSystem = {
    enabled = true,
    vehicleDamageThreshold = 40, -- % health before mission fails
    penaltyPerDamagePercent = 5, -- $ per % damage
    damageFromCrash = true,
    damageFromHitting = true,
    repairPenalty = 100, -- $ if bus needs repair after mission
}

-- Realistic Features
Config.Realistic = {
    fuel = true,
    fuelConsumption = 0.8, -- liters per km
    engineCheck = true,
    engineHealthThreshold = 80, -- % health minimum
    doors = true, -- Bus doors must be opened/closed
    doorsOpenDuration = 2000, -- ms per stop
    parkingBrake = true,
    parkingRequired = true,
    brakeLights = true,
    hazardLights = true,
}

-- Income Configuration
Config.Income = {
    basePay = true,
    passengerPay = true,
    bonusPerKm = true,
    speedBonus = false, -- Bonus for arriving early
    onTimeBonus = 100, -- $ bonus if on time
    perfectBonus = 200, -- $ bonus for perfect route (no damage, no speeding, no incidents)
    taxPercentage = 15, -- % tax on earnings
}

-- HUD Configuration
Config.HUD = {
    enabled = true,
    position = {x = 0.01, y = 0.02}, -- Top-left
    scale = 1.0,
    color = {r = 255, g = 255, b = 255, a = 255},
    showRoute = true,
    showPassengers = true,
    showSpeed = true,
    showFuel = true,
    showEarnings = true,
    showTime = true,
}

-- Commands
Config.Commands = {
    startRoute = 'startbus',
    endRoute = 'stopbus',
    routeInfo = 'busroute',
    myStats = 'busstats',
    routeList = 'busroutes',
}

-- Job Requirements
Config.Requirements = {
    minLevel = 5,
    minMoney = 100, -- Deposit requirement
    licenseRequired = 'drive', -- or 'bus' for CDL
    validLicense = true,
}

-- Notifications
Config.Notifications = {
    style = 'standard', -- 'standard', 'advanced', 'simple'
    duration = 5000, -- ms
}

-- Blip Configuration
Config.Blips = {
    enabled = true,
    style = 227, -- Bus blip
    color = 2, -- Green
    scale = 0.8,
    display = 4,
    route = 8, -- Route blip
}

-- Locale
Config.Language = 'en'

Config.Strings = {
    en = {
        -- General
        bus_job = 'Bus Driver',
        start_route = 'Start Route',
        end_route = 'End Route',
        route_completed = 'Route Completed!',
        route_cancelled = 'Route Cancelled',
        
        -- HUD
        route = 'Route',
        next_stop = 'Next Stop',
        passengers = 'Passengers',
        distance = 'Distance',
        time = 'Time',
        speed = 'Speed',
        fuel = 'Fuel',
        earnings = 'Earnings',
        
        -- Notifications
        get_in_bus = 'Get in the bus',
        drive_to_stop = 'Drive to the next stop',
        wait_passengers = 'Wait for passengers to board',
        passenger_boarding = 'Passengers boarding...',
        passenger_getting_off = 'Passengers getting off...',
        speed_limit_exceeded = 'Speed limit exceeded: -$%s',
        bus_damaged = 'Bus is too damaged to continue',
        route_failed = 'Route failed!',
        route_passed = 'Route completed successfully!',
        earnings_display = 'Earned: $%s',
        
        -- Commands
        invalid_route = 'Invalid route ID',
        route_already_started = 'You already have an active route',
        no_active_route = 'You do not have an active route',
        bus_spawned = 'Bus spawned at location',
        bus_despawned = 'Bus despawned',
        
        -- Route Names
        route_downtown = 'Downtown Route',
        route_beach = 'Beach Route',
        route_airport = 'Airport Route',
        route_suburban = 'Suburban Route',
    }
}

-- Debug
Config.Debug = false
Config.DebugBlips = false -- Show debug blips at stop locations
Config.TestMode = false -- Infinite money, no damage, etc
