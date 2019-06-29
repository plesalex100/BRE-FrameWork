
MySQL.createCommand("BRE/init_vehicles", [[
    CREATE TABLE IF NOT EXISTS bre_vehicles(
		id INT NOT NULL AUTO_INCREMENT,
		owner INTEGER NOT NULL,
		vehicle varchar(50) NOT NULL,
		vehicle_plate varchar(50) NOT NULL,
		upgrades varchar(255) NOT NULL DEFAULT "{}",
		odometer FLOAT DEFAULT 0,
		x FLOAT DEFAULT 0,
		y FLOAT DEFAULT 0,
		z FLOAT DEFAULT 0,
		h FLOAT DEFAULT 0,
		PRIMARY KEY (id)
	);
]])

MySQL.createCommand("BRE/park_veh", "UPDATE bre_vehicles SET `x` = @x, `y` = @y, `z` = @z, `h` = @h WHERE `vehicle_plate` = @plate")
MySQL.createCommand("BRE/select_vehs", "SELECT * FROM bre_vehicles WHERE owner = @id")
MySQL.createCommand("BRE/select_plate", "SELECT owner FROM bre_vehicles WHERE vehicle_plate LIKE @plate")
MySQL.createCommand("BRE/add_vehicle", "INSERT INTO bre_vehicles (`owner`, `vehicle`, `vehicle_plate`) VALUES(@owner, @vehicle, @plate)")

-- init
MySQL.execute("BRE/init_vehicles")

local function generateNewPlate()
	local function genRandomString(form) -- N = Numar, L = Litera
		local str = ""
		for i=1,#form do
			local char = string.sub(form, i,i)
			math.randomseed(os.time())
			if char == "N" then str = str..string.char(string.byte("0") + math.random(0,9))
			elseif char == "L" then str = str..string.char(string.byte("A") + math.random(0,25))
			else str = str..char end
		end

		return str
	end

	local plate = genRandomString("BRE NLLN")
	while BRE.checkVehiclePlate(plate) do
		plate = genRandomString("BRE NLLN")
	end

	return plate
end

function BRE.buyPersonalVeh(id, vehicle, price, notify)
	local player = BRE.getUserSource(id)
	if not notify then notify = false end
	if player then
		local plate = generateNewPlate()
		if plate then
			if BRE.payMoney(id, price, notify) then
				MySQL.execute("BRE/add_vehicle", {owner = id, vehicle = vehicle, plate = plate})
				
				local x,y,z = BREclient.getPlayerPos(player, {})
				local head = BREclient.getPlayerHeading(player, {})
				
				print(head)
				BREclient.spawnPersonalVehicle(player, {vehicle, plate, tonumber(x), tonumber(y), tonumber(z), tonumber(head)})
			end
		end
	end
end

RegisterCommand("buySmekerie", function(player, args)
	local id = BRE.getUserId(player)
	BRE.buyPersonalVeh(id, args[1] or "neon", 0, true)
end)

function BRE.checkVehiclePlate(plate)
	plate = tostring(plate)
    MySQL.query("BRE/select_plate", {plate = plate}, function(rows, affected)
		print("SELECTED "..#rows)
        if #rows > 0 then
			return tonumber(rows[1].owner)
		else
			return false
		end
    end)
	
	return false
end

RegisterCommand("park", function(player, args)
	local id = BRE.getUserId(player)
	local vehPlate = BREclient.getUsingVehPlate(player, {})
	if vehPlate then
		local vId = BREclient.getVIDbyPlate(player, {vehPlate})
		if vId then
			local x, y, z, h = BREclient.getPersonalVehicleCoords(player, {vId})
			
			MySQL.execute("BRE/park_veh", {x = x, y = y, z = z, h = h, plate = vehPlate})
			BREclient.notify(player, {"Ti-ai parcat masina cu succes"})
		else
			BREclient.msgError(player, {"Nu esti in masina ta"})
		end
	else
		BREclient.msgError(player, {"Nu esti intr-o masina"})
	end
end)

AddEventHandler("BRE:playerLoggedIn", function(id, source)
    MySQL.query("BRE/select_vehs",{id = id}, function(rows, affected)
		for _, v in pairs(rows) do
			BREclient.spawnPersonalVehicle(source, {v.vehicle, v.vehicle_plate, tonumber(v.x), tonumber(v.y), tonumber(v.z), tonumber(v.h)})
		end
    end)
end)