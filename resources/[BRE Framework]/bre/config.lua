
local cfg = {}

cfg.saveDetailsInterval = 90 -- secunde
cfg.startWallet = 200 -- suma cu care un jucator incepe in buzunar
cfg.startBank = 1000 -- suma cu care un jucator incepe in banca
cfg.whitelistON = true

cfg.grades = {
  ["admin"] = 7, -- Nu schimba numele
  ["helper"] = 3, -- Nu schimba numele
  
  -- ["Grad"] = max_level
  ["politist"] = 4,
  ["medic"] = 3,
  ["magician"] = 2,
  ["vip"] = 3
}

cfg.gradesSpawn = {
  ["helper"] = {340.44674682617,-1300.2272949219,32.509239196777},
  ["politist"] = {300.44674682617,-1388.2272949219,32.509239196777},
  
  ["default"] = {340.44674682617,-1388.2272949219,32.509239196777}
} 


cfg.walletDisplayCSS = [[
.div_wallet .Background {
  position: absolute;
  background: linear-gradient(135deg, rgba(50, 50, 50, 1) 0%, rgba(164, 164, 164, 0.25) 100%);
  right: 2%;
  top: 5%;
  text-align:center;
  color: white;
  padding: 5px;
  width: 10%;
  height: 2.5%;
  line-height: 120%;
  border-radius: 20px;
  font-family: 'Lucida Console';
  font-size: 25px;
  font-weight: bold;
  color: #FFFFFF;
}

.div_wallet .Box {
	content: url("http://i.imgur.com/WALbXKv.png");
	float: left;
	margin-left: 5px;
	width: 25px;
	height: 25px;
}
]]

cfg.bankDisplayCSS = [[
.div_bank .Background {
  position: absolute;
  background: linear-gradient(135deg, rgba(50, 50, 50, 1) 0%, rgba(164, 164, 164, 0.25) 100%);
  right: 2%;
  top: 10%;
  text-align:center;
  color: white;
  padding: 5px;
  width: 10%;
  height: 2.5%;
  line-height: 120%;
  border-radius: 20px;
  font-family: 'Lucida Console';
  font-size: 25px;
  font-weight: bold;
  color: #FFFFFF;
}
.div_bank .Box {
  content: url("http://i.imgur.com/305vtZ2.png");
  float: left;
  margin-left: 5px;
  width: 25px;
  height: 25px;
}
]]

return cfg
