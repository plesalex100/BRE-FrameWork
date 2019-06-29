
local function tick()
  TriggerEvent("MySQL_tick")
  SetTimeout(10, tick)
end
tick()
