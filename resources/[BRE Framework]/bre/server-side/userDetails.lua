
MySQL.createCommand("BRE/get_userId", "SELECT `user_id` FROM `bre_userdetails` WHERE `user_id`=@id") -- varianta care gaseste doar daca exista un rand
MySQL.createCommand("BRE/get_userDetails", "SELECT * FROM `bre_userdetails` WHERE `user_id`=@id")
MySQL.createCommand("BRE/insert_userDetails", "INSERT INTO `bre_userdetails` (user_id, wallet, bank) VALUES(@id, @wallet, @bank)")
MySQL.createCommand("BRE/update_userDetails", [[
  UPDATE `bre_userdetails` SET
    `wallet` = @wallet,
    `bank` = @bank,
    `inventory` = @inventory,
    `identity_card` = @identity_card,
    `admin` = @admin,
    `helper` = @helper,
    `grades` = @grades,
	`x` = @x,
	`y` = @y, 
	`z` = @z

  WHERE `user_id`=@id;
]])

local bre_userDetails = {}

local function loadUserDetail(id)
  MySQL.query("BRE/get_userDetails", {id = id}, function(rows, affected)
    local userTable = {}
    for k, v in pairs(rows[1]) do
      if k ~= "user_id" then
        userTable[k] = v
      end
    end

    bre_userDetails[id] = userTable
  end)
end
 
-- exemple de key-uri: wallet, bank, identity_card, inventory
function BRE.getUserDetail(id, key, cbr)
  local task = Task(cbr)
  local usrTable = bre_userDetails[id] 
  if usrTable then
	task({usrTable[key]})
  else
	task({})
  end
end

function BRE.setUserDetail(id, key, value)
  local userTable = bre_userDetails[id]
  if userTable and value then
    userTable[key] = value
  end
end

local function saveUserDetails(id)
  local uTable = bre_userDetails[id] 

  local wallet = uTable.wallet or 0
  local bank = uTable.bank or 0
  local inventory = uTable.inventory
  local identity_card = uTable.identity_card
  local admin = uTable.admin
  local helper = uTable.helper
  local grades = uTable.grades
  local x = uTable.x
  local y = uTable.y
  local z = uTable.z
  
  MySQL.execute("BRE/update_userDetails", {
    wallet = wallet,
    bank = bank,
    inventory = inventory,
    identity_card = identity_card,
    admin = admin,
    helper = helper,
    grades = grades,
	x = x,
	y = y,
	z = z,
    id = id
  })
end

local function saveUsersDetails()
  if Debug.active then print("[BRE] Users Details Saved") end
  for k, v in pairs(bre_userDetails) do
    saveUserDetails(k)
  end
  SetTimeout(cfg.saveDetailsInterval * 1000, function() saveUsersDetails() end)
end

SetTimeout(cfg.saveDetailsInterval * 1000, function() saveUsersDetails() end)

local function sendDeathContent(player)
	local id = BRE.getUserId(player)
	
	TriggerEvent("BRE:playerDied", id, player)
end

RegisterServerEvent("BREclient:onPlayerDied")
RegisterServerEvent("BREclient:onPlayerKilled")
AddEventHandler("BREclient:onPlayerDied", function() sendDeathContent(source) end)
AddEventHandler("BREclient:onPlayerKilled", function() sendDeathContent(source) end)

AddEventHandler('playerDropped', function(source, reason)
  local id = BRE.getUserId(source)
  if id then
    TriggerEvent("BRE:playerLeave", id, source, reason)
    saveUserDetails(id)
    Wait(5000)
    bre_userDetails[id] = nil -- clear some space
  end
end)

AddEventHandler("BRE:playerLoggedInBefore", function(id, source)
  MySQL.query("BRE/get_userId", {id = id}, function(rows, affected)
    if #rows == 0 then
      MySQL.execute("BRE/insert_userDetails", {id = id, wallet = cfg.startWallet, bank = cfg.startBank})
    end
    loadUserDetail(id)
  end)
  Wait(1000)
  TriggerEvent("BRE:playerLoggedIn", id, source)
end)
