fx_version 'cerulean'

version '1.0.0'

game 'gta5'

lua54 'yes'


client_script 'client.lua'

server_script 'server.lua'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

files {
    'locales/*.json'
}
