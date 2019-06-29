
local function setSpawnPoint(id)
	-- aici ar trebuii verificat daca are o casa, idk
	local useDefault = true
	
	for k, v in pairs(cfg.gradesSpawn) do
		if k ~= "default" then
			if BRE.hasGradeLevel(id, k, 1) then
				useDefault = false
				BRE.setUserDetail(id, "x", v[1])
				BRE.setUserDetail(id, "y", v[2])
				BRE.setUserDetail(id, "z", v[3])
			end
		end
	end

	if useDefault then 
		local v = cfg.gradesSpawn["default"]
		BRE.setUserDetail(id, "x", v[1])
		BRE.setUserDetail(id, "y", v[2])
		BRE.setUserDetail(id, "z", v[3])
	end
end

AddEventHandler("BRE:playerDied", function(id, player)
	setSpawnPoint(id)
end)

RegisterServerEvent("BRE:savePlyPos")
AddEventHandler("BRE:savePlyPos", function(x, y, z)
	local player = source
	local id = BRE.getUserId(player)
	
	BRE.setUserDetail(id, "x", x)
	BRE.setUserDetail(id, "y", y)
	BRE.setUserDetail(id, "z", z)
end)

local function spawnThePlayer(player)
	local id = BRE.getUserId(player)
	
	local x
	BRE.getUserDetail(id, "x", function(xA) x = tonumber(xA) end)
	
	local y
	BRE.getUserDetail(id, "y", function(yA) y = tonumber(yA) end)
	
	local z
	BRE.getUserDetail(id, "z", function(zA) z = tonumber(zA) end)
	
	if x and y and z then
		BREclient.tp(player, {x, y, z}) 
	else
		setSpawnPoint(id)
		spawnPlayer(player)
	end
end

RegisterServerEvent("BRE:spawnPlayer")
AddEventHandler("BRE:spawnPlayer", function()
	spawnThePlayer(source)
end)
