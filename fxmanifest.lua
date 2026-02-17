fx_version 'cerulean'
game 'gta5'

version '1.0.0'
lua54 'yes'
author 'Sleepless'
description 'CS:GO style lootbox/case opening system'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
    'client/modules/*.lua',
    'bridge/**/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/version.lua',
    'server/main.lua',
}
