fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'qr-multicharacter'
version '2.0.0'

client_scripts {
    'client/main.lua'
}

shared_scripts { 
    '@ox_lib/init.lua', 
    'config.lua',
    'shared/locale.lua',
    'shared/language_selector.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'qr-core'
}

lua54 'yes'