fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Kartik'
description 'Ghosts that haunt players who are alone at night'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'bridge/**/client/*.lua',
    'client/*.lua',
    'client/scares/*.lua',
}

server_scripts {
    'bridge/**/server/*.lua',
    'server/*.lua',
}

dependencies {
    'ox_lib',
}