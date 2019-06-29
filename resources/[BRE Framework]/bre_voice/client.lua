local defaultkey = 74
local defaultdistance = 5.001
local highdistance = 12.001
local lowdistance = 1.001 
local currentdistancevoice = 0

local function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

local function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local function drawCerculetz(chestie, thePed)
	local pos = GetEntityCoords(thePed)

	local proxs = defaultdistance
	if chestie == 1 then
		proxs = highdistance
	elseif chestie == 2 then
		proxs = lowdistance
	end

	DrawMarker(1, pos.x, pos.y, pos.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, proxs*2, proxs*2, 0.3, 255, 255, 255, 90, false, false, 2, false)
end

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

AddEventHandler("BREclient:playerLoggedIn", function()
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		local thePed = GetPlayerPed(-1)
		NetworkSetTalkerProximity(defaultdistance)

		while true do
			Citizen.Wait(1)
			if NetworkIsPlayerTalking(PlayerId()) then
				drawCerculetz(currentdistancevoice, thePed)
			end
			if IsControlJustPressed(1, defaultkey) then
				currentdistancevoice = (currentdistancevoice + 1) % 3
				if currentdistancevoice == 0 then
					NetworkSetTalkerProximity(defaultdistance)
					Notify("~w~Noice Level : ~b~Normal-"..math.floor(defaultdistance).."M")
				elseif currentdistancevoice == 1 then
					NetworkSetTalkerProximity(highdistance) 
					Notify("~w~Noice Level : ~b~Loud-"..math.floor(highdistance).."M")
				elseif currentdistancevoice == 2 then
					NetworkSetTalkerProximity(lowdistance)
					Notify("~w~Noice Level : ~b~Low-"..math.floor(lowdistance).."M")
				end
			end
			local rgb = RGBRainbow(1)
			local t = 0
			for i = 0,32 do
				if(GetPlayerName(i))then
					if(NetworkIsPlayerTalking(i))then
						t = t + 1

						if(t == 1)then
							drawTxt(1.435, 0.95, 1.0,1.0,0.4, "[Talking]", rgb.r, rgb.g, rgb.b, 255)
						end

						drawTxt(1.440, 0.95 + (t * 0.023), 1.0,1.0,0.4, "" .. GetPlayerName(i), 255, 255, 255, 255)
					end
				end
			end
		end
	end)
end)
