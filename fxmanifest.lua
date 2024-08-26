-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Trusted-Studios || fxmanifest
-- ════════════════════════════════════════════════════════════════════════════════════ --
fx_version 'cerulean'
lua54 'yes'
games { 'gta5' }

author 'Trusted-Studios | Quest System'
description 'Quest System made by GMW'
repository 'https://github.com/Trusted-Studios/ts_Quests'
version '0.0.0'

shared_scripts {
    'lib/modules/shared/*.lua',
    'config.lua'
}

client_scripts {
    'lib/modules/client/*.lua',
    'client/main.lua',
    'client/missions/*.lua',
}

server_scripts {
    'server/main.lua'
}