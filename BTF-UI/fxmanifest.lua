fx_version 'bodacious'
game 'gta5'

dependencies {
	'btf'
}

ui_page "ui/index.html"

files {
	"ui/index.html",
	"ui/assets/bank.png",
	"ui/assets/cash.png",
	"ui/assets/hunger.png",
	"ui/assets/thirst.png",
	"ui/fonts/fonts/Circular-Bold.ttf",
	"ui/fonts/fonts/Circular-Bold.ttf",
	"ui/fonts/fonts/Circular-Regular.ttf",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js"
}

client_scripts {
    "cl_moneyui.lua",
}

server_scripts {
    "@btf/lib/utils.lua",
    "server.lua",
}

