
-- Initializare BREclient
BREcl = {}
Tunnel.bindInterface("BRE",BREcl)
BREserver = Tunnel.getInterface("BRE","BRE")
Proxy.addInterface("BRE",BREcl)


local phone = false

RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
end)

RegisterNUICallback('triggerchoice', function(data, cb)
	if data.text == "" then
		--put ur trigger or function
	end
end)

Citizen.CreateThread(function()
	BREcl.AddChoice("salut")
	BREcl.AddChoice("admin")
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustPressed(1,172) then
			SendNUIMessage({select = "up"})
		elseif IsControlJustPressed(1,173) then
			SendNUIMessage({select = "down"})
		elseif IsControlJustPressed(1,190) then
			SendNUIMessage({select = "left"})
		elseif IsControlJustPressed(1,189) then
			SendNUIMessage({select = "right"})
		end
	end
end)

-- DIVS --

function BREcl.setDiv(name,css,content)
	SendNUIMessage({act="set_div", name = name, css = css, content = content})
end

function BREcl.setDivCss(name,css)
	SendNUIMessage({act="set_div_css", name = name, css = css})
end

function BREcl.setDivContent(name,content)
	SendNUIMessage({act="set_div_content", name = name, content = content})
end

function BREcl.divExecuteJS(name,js)
	SendNUIMessage({act="div_execjs", name = name, js = js})
end

function BREcl.removeDiv(name)
	SendNUIMessage({act="remove_div", name = name})
end

function BREcl.AddChoice(name)
	SendNUIMessage({act = "add_choice",choice = name})
end


  
  -- END --
  
function BREcl.notify(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(false, true)
end

function BREcl.msg(text) -- trimite un chatMessage catre jucator
	TriggerEvent("chatMessage", text)
end

function BREcl.msgError(text)
	BREcl.msg("^1Eroare^7: "..text)
end

function BREcl.msgSyntax(text)
	BREcl.msg("^1Syntax^7: "..text)
end