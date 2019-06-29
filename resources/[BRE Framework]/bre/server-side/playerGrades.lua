
local allUserGrades = {}

function BRE.isGradeReal(theGrade)
  return cfg.grades[theGrade] or 0
end

local function insertToUserDetail(id, userTbl)
  BRE.setUserDetail(id, "admin", tonumber(userTbl["admin"]))
  BRE.setUserDetail(id, "helper", tonumber(userTbl["helper"]))

  local aux = {userTbl["admin"], userTbl["helper"]}

  userTbl["admin"] = nil
  userTbl["helper"] = nil

  local gradesTbl = json.encode(userTbl)
  BRE.setUserDetail(id, "grades", gradesTbl)

  userTbl["admin"] = aux[1]
  userTbl["helper"] = aux[2]
end

function BRE.getGradeLevel(id, grade)
  if BRE.isGradeReal(grade) then
    local userTable = allUserGrades[id]
    if userTable ~= nil then
      local grdLvl = userTable[grade] or 0
      return grdLvl or 0
    end
  end
  return 0
end

function BRE.hasGradeLevel(id, grade, levelNeeded)
  local gradLvl = BRE.getGradeLevel(id, grade) or 0
  if not levelNeeded then levelNeeded = 0 end
  return (gradLvl >= levelNeeded)
end

function BRE.setGradeLevel(id, grade, newLevel)
  local ok = tonumber(BRE.isGradeReal(grade))
  newLevel = tonumber(newLevel)
  if ok > 0 then
    local userTbl = allUserGrades[id]
    if userTbl then
      if newLevel > ok then newLevel = ok end
      userTbl[grade] = newLevel
	  
	  if newLevel == 0 then
		userTbl[grade] = nil
	  end

      insertToUserDetail(id, userTbl)
    end
  end
end

function BRE.sendGradeMessage(msg, grade1, grade2, grade3) -- optional
  local users = BRE.allUsers()
  for _, id in pairs(users) do
    if BRE.hasGradeLevel(id, grade1, 1) or BRE.hasGradeLevel(id, grade2, 1) or BRE.hasGradeLevel(id, grade3, 1) then
      BREclient.msg(BRE.getUserSource(id), {msg})
    end
  end
end

function BRE.sendStaffMsg(msg)
  BRE.sendGradeMessage(msg, "admin", "helper")
end

AddEventHandler("BRE:playerLoggedIn", function(id, player)
  local userGrades = {}

  BRE.getUserDetail(id, "grades", function(grd)
    userGrades = json.decode(grd)
  end)

  BRE.getUserDetail(id, "admin", function(adm)
    userGrades['admin'] = tonumber(adm) or 0
  end)
  BRE.getUserDetail(id, "helper", function(hlp)
    userGrades['helper'] = tonumber(hlp) or 0
  end)

  allUserGrades[id] = userGrades
end)
