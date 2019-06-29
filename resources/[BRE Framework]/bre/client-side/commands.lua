
function BREcl.spawnVeh(vehName, putInVeh)
	local putPed = putInVeh or false
	local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped) 
    local h = GetEntityHeading(ped)
	local vehicle = GetHashKey(vehName)
	
    RequestModel(vehicle)
	local x = 0
	while not HasModelLoaded(vehicle) and x <= 100 do
		Citizen.Wait(100)
		x = x + 1
	end
	
    if HasModelLoaded(vehicle) then
		if IsPedInAnyVehicle(ped, true) then
			BREcl.delveh() 
		end
	
		local nveh = CreateVehicle(vehicle, pos, h,true,false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		if putPed then
			SetPedIntoVehicle(ped,nveh,-1)
		end
		SetVehicleNumberPlateText(nveh, "ADMVEH")
		SetModelAsNoLongerNeeded(vehicle)
		
		return nveh
	else
		BREcl.msgError("Masina ^1"..vehName.."^7 nu a fost gasita!")
	end
end

function BREcl.flipVeh()
	local ped = GetPlayerPed(-1)
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped)
		SetVehicleOnGroundProperly(vehicle)
	end
end

function BREcl.repairveh()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed)
		SetVehicleEngineHealth(vehicle, 9999)
		SetVehiclePetrolTankHealth(vehicle, 9999)
		SetVehicleFixed(vehicle)
	end
end
 
function BREcl.delveh()
	local ped = GetPlayerPed(-1)
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                SetEntityAsMissionEntity( vehicle, true, true )
                Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( vehicle ) )

                if ( DoesEntityExist( vehicle ) ) then 
                	BREcl.msgError("Incearca din nou")
                else 
                	BREcl.notify("Vehicul Sters")
                end  
            else 
                BREcl.msgError("Trebuie sa fii la volanul masinii")
            end 
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                SetEntityAsMissionEntity( vehicle, true, true )
                Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( vehicle ) )

                if ( DoesEntityExist( vehicle ) ) then 
                	BREcl.msgError("Incearca din nou")
                else 
                	BREcl.notify("Vehicul Sters")
                end 
            else 
				BREcl.msgError("Trebuie sa fii la volanul masinii")
            end 
        end 
    end 
end


local shieldActive = false
local shieldEntity = nil
local hadPistol = false

local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

local prop = GetHashKey("prop_ballistic_shield")
local pistol = GetHashKey("WEAPON_PISTOL")

function BREcl.togShield()
	local ped = GetPlayerPed(-1)
	if not shieldActive then
        local pedPos = GetEntityCoords(ped, false)
        
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(100)
        end

        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

        RequestModel(prop)
        while not HasModelLoaded(prop) do
            Citizen.Wait(100)
        end

        local shield = CreateObject(prop, pedPos.x, pedPos.y, pedPos.z, 1, 1, 1)
        shieldEntity = shield
        AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
        SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))

        if HasPedGotWeapon(ped, pistol, 0) or GetSelectedPedWeapon(ped) == pistol then
            SetCurrentPedWeapon(ped, pistol, 1)
            hadPistol = true
        else
            GiveWeaponToPed(ped, pistol, 300, 0, 1)
            SetCurrentPedWeapon(ped, pistol, 1)
            hadPistol = false
        end
        SetEnableHandcuffs(ped, true)
		
		BREcl.notify("Shield ON")
    else
        DeleteEntity(shieldEntity)
        ClearPedTasksImmediately(ped)
        SetWeaponAnimationOverride(ped, GetHashKey("Default"))
    
        if not hadPistol then
            RemoveWeaponFromPed(ped, pistol)
        end
        SetEnableHandcuffs(ped, false)
        hadPistol = false
		
		BREcl.notify("Shield OFF")
    end
	
	shieldActive = not shieldActive
end

Citizen.CreateThread(function()
	local ped = GetPlayerPed(-1)
    while true do
        if shieldActive then
            local ped = GetPlayerPed(-1)
            if not IsEntityPlayingAnim(ped, animDict, animName, 1) then
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Citizen.Wait(100)
                end
            
                TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
            end
        end
        Citizen.Wait(500)
    end
end)