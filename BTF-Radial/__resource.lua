

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    "config.lua",
	"client_menu.lua",
	"emotes_triggers.lua",
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
}

server_scripts {
	"@btf/lib/utils.lua",
    "server_menu.lua",
}

ui_page "html/ui.html"

files {
	"html/ui.html",
	"html/css/RadialMenu.css",
	"html/js/RadialMenu.js",
	'html/css/all.min.css',
	'html/js/all.min.js',
	'html/webfonts/fa-brands-400.eot',
	'html/webfonts/fa-brands-400.svg',
	'html/webfonts/fa-brands-400.ttf',
	'html/webfonts/fa-brands-400.woff',
	'html/webfonts/fa-brands-400.woff2',
	'html/webfonts/fa-regular-400.eot',
	'html/webfonts/fa-regular-400.svg',
	'html/webfonts/fa-regular-400.ttf',
	'html/webfonts/fa-regular-400.woff',
	'html/webfonts/fa-regular-400.woff2',
	'html/webfonts/fa-solid-900.eot',
	'html/webfonts/fa-solid-900.svg',
	'html/webfonts/fa-solid-900.ttf',
	'html/webfonts/fa-solid-900.woff',
	'html/webfonts/fa-solid-900.woff2',

	'crosshair/style.css',
	'crosshair/script.js',
	'crosshair/front.js',
	'crosshair/debounce.min.js',
}


