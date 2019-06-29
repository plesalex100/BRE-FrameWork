
local bre_userSource = {}
local bre_userId = {}
local bre_userName = {}

function BRE.loginSuccess(id, player, username)
  bre_userSource[id] = player
  bre_userName[id] = username
  bre_userId[player] = id
  print("Autentificare reusita: "..username.."["..id.."]")
end
 
function BRE.getUserSource(id)
  return bre_userSource[id]
end

function BRE.getUserName(id)
  return bre_userName[id]
end

function BRE.getUserId(player)
  return bre_userId[player]
end

function BRE.kick(player, reason)
  DropPlayer(player, reason)
end

function BRE.allUsers()
  return bre_userId
end

AddEventHandler('playerDropped', function(source, reason)
  local id = BRE.getUserId(source)
  if id then
    Wait(5000)
    bre_userSource[id] = nil -- clear some space
    bre_userId[source] = nil
    bre_userName[id] = nil
  end
end)
