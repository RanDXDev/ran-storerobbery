fx_version 'cerulean'

version '1.0.2'

game 'gta5'

lua54 'yes'


client_scripts {
    'bridge/client.lua',
    'client.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'server.lua'
}
shared_scripts {
    '@ox_lib/init.lua',

    'bridge/shared.lua',
    'config.lua'
}

files {
    'locales/*.json',
    'bridge/**/client.lua'
}
