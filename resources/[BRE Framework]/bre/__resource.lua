resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "bre_mysql"

ui_page "gui/ui.html"

files { 
	"gui/ui.html",
	"gui/styles.css",
	"gui/scripts.js",
	"gui/debounce.min.js",
	"gui/pricedown.ttf",
	"gui/background.gif",
	"gui/phone_border.png",
	"gui/icons/apps.png",
	"gui/icons/bank.png",
	"gui/icons/calculator.png",
	"gui/icons/giftbox.png",
	"gui/icons/message.png",
	"gui/icons/navigation.png",
	"gui/icons/phone.png",
	"gui/icons/settings.png",
	"gui/icons/vehicle.png"
}

client_scripts {
	"lib/utils.lua",
	"client-side/lib/Proxy.lua",
	"client-side/lib/Tunnel.lua",
	"client-side/gui.lua",
	"client-side/commands.lua",
	"client-side/basicFunctions.lua",
	"client-side/personalVehs.lua"
}

server_scripts {
	"lib/utils.lua",
	"server-side/db.lua",
	"server-side/login.lua",
	"server-side/userDetails.lua",
	"server-side/commands.lua",
	"server-side/money.lua",
	"server-side/playerGrades.lua",
	"server-side/playerSpawn.lua",
	"server-side/personalVehs.lua"
}
