local Tunnel = module("bre", "lib/Tunnel")
local Proxy = module("bre", "lib/Proxy")
local MySQL = module("bre_mysql", "MySQL")
local cfg = module("bre", "config")

BRE = Proxy.getInterface("BRE")
BREclient = Tunnel.getInterface("BRE","BRE_login")

MySQL.createCommand("BRE/reg_insert","INSERT IGNORE INTO `bre_logdetails` (username,password) VALUES(@username,@password)")
MySQL.createCommand("BRE/login_check","SELECT * FROM `bre_logdetails` WHERE `username`=@username")

RegisterServerEvent("BRElogin:sendRegister")
RegisterServerEvent("BRElogin:sendLogin")

local function loginError(player, msg)
  TriggerClientEvent("BRElogin:sendError", player, msg)
end

local function loginSuccess(id, player, username)
  TriggerClientEvent("BRElogin:loginSuccess", player, id, player)
  BRE.loginSuccess({id, player, username})

  Wait(500)
  TriggerEvent("BRE:playerLoggedInBefore", id, player)
end

local allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.:_!#$()[]{}<>'"

AddEventHandler("BRElogin:sendRegister", function(user, pass)
  local player = source
  local username = sanitizeString(user, allowed, true)
  local password = sanitizeString(pass, allowed, true)
  MySQL.query("BRE/login_check", {username = username}, function(rows, affected)
    if #rows == 0 then
      if username == user and password == pass then
        if username:len() >= 3 then
          if password:len() >= 4 then
            MySQL.execute("BRE/reg_insert", {username = username, password = password})
            MySQL.query("BRE/login_check", {username = username}, function(rows2, affected2)
              if not cfg.whitelistON then
                loginSuccess(rows2[1].id, player, rows2[1].username)
              else
                loginError(player, "Contul tau a fost creeat [id: "..rows2[1].id.."]<br/>Nu esti un Beta Tester")
              end
            end)
          else
            loginError(player, "Parola prea scurta")
          end
        else
          loginError(player, "Username prea scurt")
        end
      else
        loginError(player, "Au fost gasite caractere interzise in nume sau parola")
      end
    else
      loginError(player, "Username deja ocupat")
    end
  end)
end)

local errors = {}

AddEventHandler("BRElogin:sendLogin", function(username, password)
  local player = source
  MySQL.query("BRE/login_check", {username = username}, function(rows, affected)
    if #rows > 0 then
      if rows[1].password == password then
        if rows[1].banned ~= "0" then
          loginError(player, "Acest username are BAN<br/>Motiv: "..rows[1].banned)
        else
          local id = BRE.getUserId({player})
          if not id then
            if (cfg.whitelistON and rows[1].whitelisted) or not cfg.whitelistON then
              loginSuccess(rows[1].id, player, rows[1].username)
            else
              loginError(player, "Nu esti whitelisted")
            end
          else
            loginError(player, "Pe acest cont este deja cineva conectat<br/>Daca nu cunoaste-ti aceasta activitate contactati un Administrator!")
          end
        end
      else
        errors[player] = (errors[player] or 0) + 1
        loginError(player, "Username sau parola incorecta")
		print("Invalid password.")
        if errors[player] > 3 then
          BRE.kick(player, "Ai depasit incercarile de a te loga")
        end
      end
    else
      loginError(player, "Acest username nu este inregistrat")
    end
  end)
end)
