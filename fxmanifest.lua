fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'qr-Multicharacter'
version '1.0.0'

shared_scripts {
    '@qr-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts  {
    '@oxmysql/lib/MySQL.lua',
    -- '@qr-apartments/config.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    "html/vue.js",
    "html/swal2.js",
    'html/profanity.js'
}

dependencies {
    'qr-core',
    'qr-spawn'
}

lua54 'yes'
