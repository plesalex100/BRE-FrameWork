

RegisterCommand("setadmin", function(source, args)
    local id = BRE.getUserId(source)
	local id_level = BRE.getGradeLevel(id, "admin")
	if id_level >= 5 then
		if args[1] ~= nil and args[2] ~= nil then
			local tid = tonumber(args[1]) or 0
			local aLevel = tonumber(args[2]) or 0
			if tonumber(tid) > 0 and tonumber(aLevel) >= 0 then
				local tsource = BRE.getUserSource(tid)
				if tsource then
					if id_level == 7 or id_level > aLevel then
						if id_level == 7 or not BRE.hasGradeLevel(tid, "admin", id_level - 1) then
							BRE.setGradeLevel(tid, "admin", aLevel)
							
							BRE.sendStaffMsg("Admin-ul ^4"..BRE.getUserName(id).."^7 i-a dat Admin level ^4"..aLevel.."^7 lui ^4"..BRE.getUserName(tid))
						else
							BREclient.msgError(source, {"Nu poti modifica gradul unui admin superior sau egal tie"})
						end
					else
						BREclient.msgError(source, {"Nu poti da un grad mai mare ca al tau"})
					end
				else
					BREclient.msgError(source, {"Jucatorul nu este conectat!"})
				end
			else
				BREclient.msgSyntax(source, {"/setadmin <id> <level>"})
			end
		else 
			BREclient.msgSyntax(source, {"/setadmin <id> <level>"})
		end 
	else
		BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
	end
end)

RegisterCommand("setgrade", function(source, args)
	local id = BRE.getUserId(source)
	if BRE.hasGradeLevel(id, "admin", 3) then
		local tid = tonumber(args[1]) or 0
		local grade = args[2] or ""
		local level = tonumber(args[3]) or 0
		if grade:len() > 0 and level >= 0 and tid > 0 then
			local max_lvl = BRE.isGradeReal(grade)
			if max_lvl > 0 then
				local tsource = BRE.getUserSource(tid)
				if tsource then
					if max_lvl < level then 
						level = BRE.isGradeReal(grade) 
					end
					
					BRE.setGradeLevel(tid, grade, level)
					
					BRE.sendStaffMsg("Admin-ul ^4"..BRE.getUserName(id).."^7 i-a dat gradul ^4"..grade.."^7 lvl ^4"..level.."^7 lui ^4"..BRE.getUserName(tid).."^7 !")
					BREclient.msg(tsource, {"Admin-ul ^4"..BRE.getUserName(id).."^7 ti-a dat gradul ^4"..grade.."^7 lvl ^4"..level.."^7 !"})
				else
					BREclient.msgError(source, {"Jucatorul nu este conectat!"})
				end
			else	
				BREclient.msgError(source, {"Grad inexistent!"}) 
			end
		else
			BREclient.msgSyntax(source, {"/setgrade <id> <grade> <level>"})
		end
	else
		BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"}) 
	end
end)

RegisterCommand("sethelper", function(source, args)
    local id = BRE.getUserId(source)
	if BRE.hasGradeLevel(id, "admin", 4) then
		if args[1] ~= nil and args[2] ~= nil then
			local tid = tonumber(args[1])
			local hLevel = tonumber(args[2]) 
			if tid > 0 and hLevel >= 0 then
				local tsource = BRE.getUserSource(tid)
				if tsource then
					BRE.setGradeLevel(tid, "helper", hLevel)
					
					BRE.sendStaffMsg("Admin-ul ^4"..BRE.getUserName(id).."^7 i-a dat Helper level ^4"..hLevel.."^7 lui ^4"..BRE.getUserName(tid))
				else
					BREclient.msgError(source, {"Jucatorul nu este conectat!"})
				end
			else
				BREclient.msgSyntax(source, {"/sethelper <id> <level>"})
			end
		else
			BREclient.msgSyntax(source, {"/sethelper <id> <level>"})
		end
	else
		BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
	end
end)

RegisterCommand('flip', function(source, args, msg)
	local id = BRE.getUserId({source})
	if id ~= nil then
		if BRE.hasGradeLevel(id, "admin", 1) then
			BREclient.flipVeh(source, {})
		else
			BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
		end
	end
end)

RegisterCommand('fix', function(source, args, msg)
	local id = BRE.getUserId({source})
	if id ~= nil then
		if BRE.hasGradeLevel(id, "admin", 1) then
			BREclient.repairVeh(source, {})
		else
			BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
		end
	end
end)

RegisterCommand("a", function(source, args, msg)
	local id = BRE.getUserId(source)
	if BRE.hasGradeLevel(id, "admin", 1) or BRE.hasGradeLevel(id, "helper", 1) then
		BRE.sendStaffMsg("^4[^7STAFF^4]^7 - "..BRE.getUserName(id)..": "..msg:sub(3))
	else
		BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
	end
end)

RegisterCommand('clear', function(source)
    local id = BRE.getUserId(source)
    if id ~= nil then
        if BRE.hasGradeLevel(id, "admin", 2) then
            TriggerClientEvent("chat:clear", -1)
            BREclient.msg(-1, {"^1Server^7: Adminul ^1".. BRE.getUserName(id) .."^7 a sters tot chat-ul."})
        else
            BREclient.msgError(source, {"nu ai acces la aceasta comanda."})
        end
    end
end)

RegisterCommand('say', function(source, args, rawCommand)
  if (source == 0) then
    BREclient.msg(-1, {'^1Console^7: '..rawCommand:sub(5)})
  else
    local id = BRE.getUserId(source)
    if BRE.hasGradeLevel(id, "admin", 5) then
      BREclient.msg(-1, {'^1'..BRE.getUserName(id).."^7: "..rawCommand:sub(5)})
    else
      BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
    end
  end
end)

RegisterCommand("spawnveh", function(source, args)
    local id = BRE.getUserId(source)
    if BRE.hasGradeLevel(id, "helper", 3) or BRE.hasGradeLevel(id, "admin", 1) then
        if args[1] then
            BREclient.spawnVeh(source, {args[1], true})
        else
			BREclient.msgSyntax(source, {"/spawnveh <model>"})
		end
    else
      BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
    end
end)

RegisterCommand("dv", function(source, args)
    BREclient.delveh(source, {})
end)

RegisterCommand("shield", function(source, args)
    local id = BRE.getUserId(source)
    if BRE.hasGradeLevel(id, "politist", 1) then
        BREclient.togShield(source, {})
    else
      BREclient.msgError(source, {"Nu ai acces la aceasta comanda!"})
    end
end)
