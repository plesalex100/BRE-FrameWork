MySQL = module("bre_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")
cfg = module("config")

Debug.active = true
MySQL.debug = false

local dbData = module("dbConfig")
MySQL.createConnection("BRE", dbData.ip, dbData.user, dbData.password, dbData.database)


MySQL.createCommand("BRE/database_init",[[
CREATE TABLE IF NOT EXISTS bre_logdetails(
    id INTEGER AUTO_INCREMENT,
    username VARCHAR(200),
    password VARCHAR(200),
    whitelisted BOOLEAN DEFAULT 0,
    banned VARCHAR(100) DEFAULT '0',
    CONSTRAINT pk_logdetails PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS bre_userdetails(
    user_id INTEGER,
    wallet FLOAT(11),
    bank FLOAT(11),
    inventory VARCHAR(255) DEFAULT '[]',
    identity_card VARCHAR(255) DEFAULT '0',
    helper INTEGER DEFAULT 0,
    admin INTEGER DEFAULT 0,
    grades VARCHAR(255) DEFAULT '[]',
	x DOUBLE(8, 2) DEFAULT 0.0,
	y DOUBLE(8, 2) DEFAULT 0.0,
	z DOUBLE(8, 2) DEFAULT 0.0,
    CONSTRAINT pk_userdetails PRIMARY KEY(user_id),
    CONSTRAINT fk_userdetails FOREIGN KEY(user_id) REFERENCES bre_logdetails(id) ON DELETE CASCADE
);
]])

print("[BRE] Checking database...")
MySQL.execute("BRE/database_init")
SetTimeout(3000, function() print("[BRE] Database checked.") end)

BRE = {}
Proxy.addInterface("BRE",BRE)

BREcl = {}
Tunnel.bindInterface("BRE",BREcl)

BREclient = Tunnel.getInterface("BRE","BRE")

function BRE.isDebugActive()
	return Debug.active
end