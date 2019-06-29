local Tunnel = module("bre", "lib/Tunnel")
local Proxy = module("bre", "lib/Proxy")

BRE = Proxy.getInterface("BRE")
BREclient = Tunnel.getInterface("BRE","BRE_chat")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')
RegisterServerEvent('achat:checke')

local function sendTagMessage(tag, author, message)
	TriggerClientEvent('chatMessage', -1, tag .. " ^7- "  .. author .. ": ^7" ..  message)
end

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end
	
    TriggerEvent('chatMessage', source, author, message)

	local id = BRE.getUserId({source}) 
	local prevName = BRE.getUserName({id})
	local name = prevName
	
	if not BRE.hasGradeLevel({id, "vip", 1}) then
		name = sanitizeString(prevName, "^", false)
		if name ~= prevName then
			BREclient.msgError(source, {"Doar membrii cu grade VIP au voie sa detina culori in nume"})
		end
	end
	
    if not WasEventCanceled() then
		if BRE.hasGradeLevel({id, "admin", 7}) then				sendTagMessage("^9Fondator", name, message)
		elseif BRE.hasGradeLevel({id, "admin", 5}) then			sendTagMessage("^1Admin Superior", name, message)
		elseif BRE.hasGradeLevel({id, "admin", 1}) then 		sendTagMessage("^1Admin", name, message)
		elseif BRE.hasGradeLevel({id, "helper", 1}) then		sendTagMessage("^2Helper", name, message)
		else 													sendTagMessage("Civil", name, message)
		end
	end

    print(name .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
		BREclient.msgError(source, {"comanda ^1/"..command.." ^7nu exista!"})
    end

    CancelEvent()
end)
