version '1.0.0'
author 'brpDevs'
description "A FiveM Framework"
repository 'https://github.com/BRP-Developers/brp'

client_scripts {
    "client/*"
}

server_scripts {
    "server/lib/utils.lua",
    "server/*"
}

fx_version 'adamant'
games { 'gta5' }



