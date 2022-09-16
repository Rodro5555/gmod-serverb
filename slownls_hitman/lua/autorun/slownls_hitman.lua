--[[  
    Addon: Hitman
    By: SlownLS
]]

SlownLS = SlownLS or {}
SlownLS.Hitman = SlownLS.Hitman or {}

function SlownLS.Hitman:addFile(strPath,boolInclude)
	local files, folders = file.Find(strPath.."*","LUA")
    
	for _,v in pairs(files or {}) do
		if boolInclude then
			include(strPath..v)
		else
			AddCSLuaFile(strPath..v)
		end
	end

	for _,v in pairs(folders or {}) do
		self:addFile(strPath..v.."/",boolInclude)
	end
end

function SlownLS.Hitman:load()
	if SERVER then
		-- Load Shared Files
		self:addFile("slownls_hitman/shared/",true)
		self:addFile("slownls_hitman/shared/",false)

		-- Load Server Files
		self:addFile("slownls_hitman/server/",true)

		-- Load Client Files
		self:addFile("slownls_hitman/client/",false)

		-- Load Languages Files
		self:addFile("slownls_hitman/languages/",true)
		self:addFile("slownls_hitman/languages/",false)

		return
	end

	-- Load Shared Files
	self:addFile("slownls_hitman/shared/",true)

	-- Load Client Files
	self:addFile("slownls_hitman/client/",true)

	-- Load Languages Files
	self:addFile("slownls_hitman/languages/",true)
end

SlownLS.Hitman:load()

print('SlownLS Hitman loaded!')
