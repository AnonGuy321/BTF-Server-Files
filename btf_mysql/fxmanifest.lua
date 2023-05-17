
fx_version 'cerulean'
games {  'gta5' }

description "BTF MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@btf/lib/utils.lua",
  "MySQL.lua"
}

