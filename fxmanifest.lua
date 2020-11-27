fx_version "adamant"
game "gta5"

client_script {
    "serverCallbackLib/client.lua",
    "lib/Tunnel.lua",
	"lib/Proxy.lua",
    "client/client.lua",
    "config.lua"
}

server_script {
    "serverCallbackLib/server.lua",
    '@vrp/lib/utils.lua',
    "@mysql-async/lib/MySQL.lua",
    "server/banking.lua"
}

ui_page "web/html/index.html"

files {
    "web/html/index.html",
    "web/html/main.js"
}