fx_version 'cerulean'
game 'gta5'

author 'KERRYGAMER'
description 'Realistic Bus Job for QBX/QBCore'
version '1.0.0'

lua54 'yes'

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/utils.lua',
    'client/client.lua',
    'client/effects.lua',
}

server_scripts {
    'server/server.lua',
    'server/logs.lua',
}

dependencies {
    'qbx_core',
    'qbx_vehiclekeys',
}

exports {
    'StartBusRoute',
    'EndBusRoute',
    'GetCurrentRoute',
    'GetBusStats',
    'IsPlayerOnBus',
}
