
local function moneyFormatDisplay(amount)
  local bre = tonumber(amount)
  if bre > 0 then
    return "<div class='Background'><div class='Box'></div>"..formatMoney(bre).."</div>"
  else
    return ""
  end
end

local function round(n)
  return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function formatMoney(value)
  if value >= 1000000000 then
    return tostring(math.floor(round(value%1000000000000)/1000000000*100)/100).." B"

  elseif value >= 1000000 then
    return tostring(math.floor(round(value%1000000000)/1000000*100)/100).." M"

  elseif value >= 1000 then
    return tostring(math.floor(round(value%1000000)/1000*100)/100).." K"
  else
    return value
  end
end

local function updateDisplay(id, div_name, amount)
  local player = BRE.getUserSource(id)
  if player then
    BREclient.setDivContent(player, {div_name, moneyFormatDisplay(amount)})
  end
end

-- Wallet

function BRE.setMoney(id, amount)
  local amount = (tonumber(amount)* 10) / 10
  BRE.setUserDetail(id, "wallet", amount)
  updateDisplay(id, "wallet", amount)
end

function BRE.getMoney(id)
  local bre = 0
  BRE.getUserDetail(id, "wallet", function(wallet)
    bre = tonumber(wallet)
  end)
  if bre then
    return bre or 0
  else
    return 0
  end
end

function BRE.giveMoney(id, amount)
  local money = BRE.getMoney(id) + amount
  BRE.setMoney(id, money)
end

function BRE.payMoney(id, amount, notify)
  local newMoney = BRE.getMoney(id) - amount
  if newMoney >= 0 then
    if notify then
      BREclient.notify(BRE.getUserSource(id), {"Ai platit ~r~$"..amount})
    end
    BRE.setMoney(id, newMoney)
    return true
  end
  return false
end

-- Bank

function BRE.setBankMoney(id, amount)
  local amount = (tonumber(amount)* 10) / 10
  BRE.setUserDetail(id, "bank", amount)
  updateDisplay(id, "bank", amount)
end

function BRE.getBankMoney(id)
  local bre = 0
  BRE.getUserDetail(id, "bank", function(bank)
    bre = tonumber(bank)
  end)
  if bre then
    return bre or 0
  else
    return 0
  end
end

function BRE.giveBankMoney(id, amount)
  local bmoney = BRE.getBankMoney(id) + amount
  BRE.setBankMoney(id, bmoney)
end

function BRE.payBankMoney(id, amount, notify)
  local newMoney = BRE.getBankMoney(id) - amount
  if newMoney >= 0 then
    if notify then
      BREclient.notify(BRE.getUserSource(id), {"Ai platit cu cardul ~r~$"..amount})
    end
    BRE.setBankMoney(id, newMoney)
    return true
  end
  return false
end

-- Money Display

AddEventHandler("BRE:playerLoggedIn", function(id, player)
  local wallet = BRE.getMoney(id)
  local bank = BRE.getBankMoney(id)
  BREclient.setDiv(player, {"wallet", cfg.walletDisplayCSS, moneyFormatDisplay(wallet)})
  BREclient.setDiv(player, {"bank", cfg.bankDisplayCSS, moneyFormatDisplay(bank)})
end)

-- Bank Functions

function BRE.withdrawMoney(id, amount)
  if BRE.payBankMoney(id, amount, false) then
    BRE.giveMoney(id, amount)
    return true
  end
  return false
end

function BRE.depositMoney(id, amount)
  if BRE.payMoney(id, amount, false) then
    BRE.giveBankMoney(id, amount)
    return true
  end
  return false
end
