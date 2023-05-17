fx_version 'cerulean'
game 'gta5'

description 'BTF Server Announcements'
version '1.0.2'

client_scripts {
    'client/*',
}

server_scripts {
    'server/*',
}

escrow_ignore {
    'config.lua'
}

shared_script 'config.lua'

lua54 'yes'
dependency '/assetpacks'