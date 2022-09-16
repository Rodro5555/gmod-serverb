CarePackage = CarePackage or {}
CarePackage.Planes = CarePackage.Planes or {}
CarePackage.Crates = CarePackage.Crates or {}

CAREPACKAGE_STANDARD = 0
CAREPACKAGE_INVENTORY = 1

function CarePackage:IncludeClient(path)
	if (CLIENT) then
		include("care_package/" .. path .. ".lua")
	end

	if (SERVER) then
		AddCSLuaFile("care_package/" .. path .. ".lua")
	end
end

function CarePackage:IncludeServer(path)
	if (SERVER) then
		include("care_package/" .. path .. ".lua")
	end
end

function CarePackage:IncludeShared(path)
	self:IncludeServer(path)
	self:IncludeClient(path)
end

local function Load()
	CarePackage.FinishedLoading = nil

	CarePackage:IncludeShared("core/language")
	for i, v in pairs(file.Find("care_package/languages/*.lua", "LUA")) do
		CarePackage:IncludeShared("languages/" .. v:sub(1, v:len() - 4))
	end

	CarePackage:IncludeShared("core/drops")
	for i, v in pairs(file.Find("care_package/drops/*.lua", "LUA")) do
		CarePackage:IncludeShared("drops/" .. v:sub(1, v:len() - 4))
	end

	function CarePackage:AddItem(ent, type, options)
		local tbl = self.Drops[type]
		if (!tbl) then return end
		tbl = table.Copy(tbl)
		tbl.Options = options or tbl.Options

		table.insert(self.Config.Drops, {
			Drop = tbl,
			Ent = ent,
		})
	end

	CarePackage:IncludeShared("configuration/config")
	CarePackage:IncludeServer("configuration/mysql")
	CarePackage:IncludeShared("configuration/items")

	CarePackage:IncludeServer("database/database")
	CarePackage:IncludeServer("database/mysqlite")

	CarePackage:IncludeClient("ui/frame")
	CarePackage:IncludeClient("ui/plane")

	CarePackage:IncludeServer("controller/spawner")
	CarePackage:IncludeServer("controller/plane")
	CarePackage:IncludeShared("controller/saving")

	CarePackage:IncludeClient("networking/client")
	CarePackage:IncludeServer("networking/server")

	CarePackage.FinishedLoading = true

	hook.Run("CarePackage.FinishedLoading")
end

if (XeninUI) then
	Load()
else
	hook.Add("XeninUI.Loaded", "CarePackage", Load)
end
