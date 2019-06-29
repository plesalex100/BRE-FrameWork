local first_spawn = true
local open = true

AddEventHandler("playerSpawned", function()
	if first_spawn then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			SendNUIMessage({
				action = "changeTitle",
				theTitle = Cfg.title
			})
			SendNUIMessage({
				action = "open"
			})
			SetNuiFocus(true, true)
		end)
		first_spawn = false
	end
end)

RegisterNetEvent("BRElogin:loginSuccess")
AddEventHandler("BRElogin:loginSuccess", function()
	open = false
	SetNuiFocus(false, false)
	SendNUIMessage({
		action = "close"
	})

	Citizen.Wait(1000)
	TriggerEvent("BREclient:playerLoggedIn")
end)

RegisterNetEvent("BRElogin:sendError")
AddEventHandler("BRElogin:sendError", function(msg)
	SendNUIMessage({
    action = "error",
    theError = msg
  })
end)

RegisterNUICallback('tryEnter', function(data, cb)
	local name = data.nume
	local pass = data.parola
	if name ~= "" and pass ~= "" then
		if data.doWhat == "login" then
			TriggerServerEvent("BRElogin:sendLogin", name, pass)
		else
			TriggerServerEvent("BRElogin:sendRegister", name, pass)
		end
	else
		TriggerEvent("BRElogin:sendError", "There's no text, bro!")
	end
	cb('ok')
end)

local function stop_camera()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    DoScreenFadeIn(800) --- Fade In Showing the Screen
    FreezeEntityPosition(playerPed, false) -- unfreeze
    DestroyCam(createdCamera, 0)
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
end

AddEventHandler("playerSpawned", function()
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)
	
		-- Enable PVP
		NetworkSetFriendlyFireOption(true)
		SetCanAttackFriendly(playerPed, true, true)
		
		-- Disable Police
		SetPoliceIgnorePlayer(PlayerId(), true)
		SetDispatchCopsForPlayer(PlayerId(), false)
	
	 
		SetEntityVisible(playerPed, 0, 0)
		FreezeEntityPosition(playerPed, true)
		SetEntityInvincible(playerPed, true)
		DisplayRadar(false)
		Wait(100)
		SetEntityCoordsNoOffset(playerPed, -1710.0, -1390.0, 160.0, 1.0, 0.0, 0.0)
		Wait(100)
		local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		SetCamRot(cam, 0.0, 0.0, 120.0, 0)
		ShakeCam(cam, "DRUNK_SHAKE", 2.5)
		RenderScriptCams(1, 1, 25000, 1, 1)
		SetCamCoord(cam, 0.0,0.0,120.0)
		if Vdist( GetCamCoord(coord), 0.0, 0.0, 120.0 ) < 20.0 then
			SetEntityCoordsNoOffset(playerPed, 340.44674682617,-1388.2272949219,32.509239196777 + 1.0)
		end
		while true do
			Wait(1)
			if not open then
				Wait(2500)
				FreezeEntityPosition(playerPed, false)
				SetEntityInvincible(playerPed, false)
				SetEntityVisible(playerPed, 1, 0)
				DisplayRadar(true)
				--SetEntityCoordsNoOffset(playerPed, 340.44674682617,-1388.2272949219,32.509239196777 + 1.0)
				TriggerServerEvent("BRE:spawnPlayer")
				Wait(500)
				stop_camera()
				break
			end
		end
	end)
end)
