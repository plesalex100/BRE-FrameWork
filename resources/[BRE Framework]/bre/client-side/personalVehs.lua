
local personalVehs = {}

local function initNewPersonalCar(nveh, model, plate)
	local theVeh = {nveh, model, plate, false}
	table.insert(personalVehs, theVeh)
end

function BREcl.getPersonalVehicle(vId)
	local theVeh = personalVehs[vId]
	if theVeh then
		return theVeh
	else
		return false 
	end
end

function BREcl.getVIDbyPlate(thePlate)
	for k, v in pairs(personalVehs) do
		if v[2] == thePlate then 
			return k
		end
	end
	
	return false
end

function BREcl.getPersonalVehicleCoords(vId) 
	local tveh = BREcl.getPersonalVehicle(vId)[1]
	
	if IsEntityAVehicle(tveh) then
		local x, y, z = table.unpack(GetEntityCoords(nveh))
		local h = GetEntityHeading(nveh)
		return x, y, z, h
	end
	return 0, 0, 0, 0
end

function BREcl.isPersonalVehAllive(vId)
	return not BREcl.getPersonalVehicle(vId)[4]
end

function BREcl.spawnPersonalVehicle(model, plate, x, y, z, h)
	local vehicle = GetHashKey(model)
    RequestModel(vehicle)
	local i = 0
	while not HasModelLoaded(vehicle) and i < 100 do
		i = i + 1
		Citizen.Wait(100)
	end
    if HasModelLoaded(vehicle) then
		local nveh = CreateVehicle(vehicle, x, y, z, h, true, false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh, false)
		SetPedIntoVehicle(GetPlayerPed(-1), nveh, -1)
		SetVehicleNumberPlateText(nveh, plate)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetModelAsNoLongerNeeded(vehicle)
		
		initNewPersonalCar(nveh, model, plate)
	end
end

function BREcl.setParkCoordsHere()
    local nveh = BREcl.getUsingVehicle()
	if IsEntityAVehicle(nveh) then
		plate = GetVehicleNumberPlateText(nveh)
		pos = GetEntityCoords(nveh)
		h = GetEntityHeading(nveh)
		
		Citizen.Trace("Smekerie lvl 100: "..plate)
		
		if BREserver.checkVehiclePlate(plate) then
			BREserver.setParkCoords(plate, pos.x, pos.y, pos.z, h)
		else
			BREcl.msgError("Nu esti intr-o masina personala!")
		end
	else
		BREcl.msgError("Nu esti intr-o masina!")
	end
end

function BREcl.getUsingVehPlate()
	local tveh = BREcl.getUsingVehicle()
	if IsEntityAVehicle(tveh) then
		return tostring(GetVehicleNumberPlateText(tveh))
	else
		return false
	end
end

function BREcl.getUsingVehicle()
    local tveh = GetVehiclePedIsUsing(GetPlayerPed(-1))
end