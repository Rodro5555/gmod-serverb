zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

if SERVER then
	function zrmine.f.Notify(ply, msg, ntfType)
		if (not IsValid(ply)) then return end

		if ply.zrms_LastNotify and ply.zrms_LastNotify > CurTime() then return end

		if DarkRP then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end

		ply.zrms_LastNotify = CurTime() + 0.5
	end

	// Is the Player allowed to steal metal bars or storagecrates
	function zrmine.f.CanSteal(ply,ent)
		local canSteal = false

		if zrmine.f.IsOwner(ply, ent) then
			canSteal = true
		else
			if zrmine.config.MetalBar_Stealing.Enabled then

				if table.Count(zrmine.config.MetalBar_Stealing.Jobs) > 0 then

					if zrmine.config.MetalBar_Stealing.Jobs[team.GetName(ply:Team())] then
						canSteal = true
					else
						canSteal = false
					end
				else
					canSteal = true
				end
			else
				canSteal = false
			end
		end
		return canSteal
	end

	//This function is used do calculate the max Capacity amount we can use
	function zrmine.f.Calculate_AmountCap(hAmount, cap)
		local sAmount

		if (hAmount > cap) then
			sAmount = cap
		else
			sAmount = hAmount
		end

		return sAmount
	end

	//Used to fix the Duplication Glitch
	function zrmine.f.CollisionCooldown(ent)
		if ent.zrms_CollisionCooldown == nil then
			ent.zrms_CollisionCooldown = true

			timer.Simple(0.1,function()
				if IsValid(ent) then
					ent.zrms_CollisionCooldown = false
				end
			end)

			return false
		else
			if ent.zrms_CollisionCooldown then
				return true
			else
				ent.zrms_CollisionCooldown = true

				timer.Simple(0.1,function()
					if IsValid(ent) then
						ent.zrms_CollisionCooldown = false
					end
				end)
				return false
			end
		end
	end
end

if CLIENT then
	// Checks if the entity did not got drawn for certain amount of time and call update functions for visuals
	function zrmine.f.UpdateEntityVisuals(ent)
		if zrmine.f.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 1000) then

			local curDraw = CurTime()

			if ent.LastDraw == nil then
				ent.LastDraw = CurTime()
			end

			if ent.LastDraw < (curDraw - 1) then
				//print("Entity: " .. ent:EntIndex() .. " , Call UpdateVisuals() at " .. math.Round(CurTime()))

				ent:UpdateVisuals()
			end

			ent.LastDraw = curDraw
		end
	end
end

function zrmine.f.Debug(msg)
	if zrmine.config.debug then
		print("[    DEBUG    ] " .. msg)
	end
end

function zrmine.f.Debug_Sphere(pos,size,lifetime,color,ignorez)
	if zrmine.config.debug then
		debugoverlay.Sphere( pos, size, lifetime, color, ignorez )
	end
end

function zrmine.f.LerpColor(t, c1, c2)
	local c3 = Color(0, 0, 0)
	c3.r = Lerp(t, c1.r, c2.r)
	c3.g = Lerp(t, c1.g, c2.g)
	c3.b = Lerp(t, c1.b, c2.b)
	c3.a = Lerp(t, c1.a, c2.a)

	return c3
end

function zrmine.f.InDistance(pos01, pos02, dist)
	local inDistance = pos01:DistToSqr(pos02) < (dist * dist)
	return  inDistance
end

// Tells us if the function is valid
function zrmine.f.FunctionValidater(func)
	if (type(func) == "function") then return true end

	return false
end

// Converts a color to a vector
function zrmine.f.ColorToVector(col)
	return Vector((1 / 255) * col.r, (1 / 255) * col.g, (1 / 255) * col.b)
end

////////////////////////////////////////////
///////////////// OWNER ////////////////////
////////////////////////////////////////////
if SERVER then
	// This saves the owners SteamID
	function zrmine.f.SetOwnerByID(ent, id)
		ent:SetNWString("zrmine_Owner", id)
	end

	// This saves the owners SteamID
	function zrmine.f.SetOwner(ent, ply)
		if IsValid(ply) then
			ent:SetNWString("zrmine_Owner", zrmine.f.Player_GetID(ply))
			if CPPI then
				ent:CPPISetOwner(ply)
			end
		else
			ent:SetNWString("zrmine_Owner", "world")
		end
	end
end

// This returns the entites owner SteamID
function zrmine.f.GetOwnerID(ent)
	return ent:GetNWString("zrmine_Owner", "nil")
end

// Checks if both entities have the same owner
function zrmine.f.OwnerID_Check(ent01,ent02)

	if IsValid(ent01) and IsValid(ent02) then
		local id01 = zrmine.f.GetOwnerID(ent01)
		local id02 = zrmine.f.GetOwnerID(ent02)
		if id01 == id02 or id02 == "world" or id02 == "world" then
			return true
		else
			return false
		end
	else
		return false
	end
end

// This returns the owner
function zrmine.f.GetOwner(ent)
	if IsValid(ent) then
		local id = ent:GetNWString("zrmine_Owner", "nil")
		local ply = player.GetBySteamID(id)

		if IsValid(ply) then
			return ply
		else
			return false
		end
	else
		return false
	end
end

// Checks if the player is the owner of the entitiy
function zrmine.f.IsOwner(ply, ent)
	if IsValid(ent) and IsValid(ply) then

		if zrmine.config.SharedOwnership then
			return true
		else

			local id = ent:GetNWString("zrmine_Owner", "nil")
			local ply_id = zrmine.f.Player_GetID(ply)

			if id == ply_id or id == "world" then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

// This returns true if the player is a admin
function zrmine.f.IsAdmin(ply)
	if IsValid(ply) then
		if xAdmin then
		//xAdmin Support
			return ply:IsAdmin()
		// SAM Support
		elseif sam then
			return ply:IsAdmin()
		else
			if zrmine.config.AdminRanks[zrmine.f.GetPlayerRank(ply)] then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end
/////////////////////////////////////////////
/////////////////////////////////////////////





////////////////////////////////////////////
////////////// Rank / Job //////////////////
////////////////////////////////////////////
// Returns the player rank / usergroup
function zrmine.f.GetPlayerRank(ply)
	return ply:GetUserGroup()
end

// Returns the players job
function zrmine.f.GetPlayerJobName(ply)
	return team.GetName( zrmine.f.GetPlayerJob(ply) )
end

function zrmine.f.GetPlayerJob(ply)
	return ply:Team()
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
///////////////// Timer ////////////////////
////////////////////////////////////////////
concommand.Add("zrmine_debug_Timer_PrintAll", function(ply, cmd, args)
	if zrmine.f.IsAdmin(ply) then
		zrmine.f.Timer_PrintAll()
	end
end)

if zrmine_TimerList == nil then
	zrmine_TimerList = {}
end

function zrmine.f.Timer_PrintAll()
	PrintTable(zrmine_TimerList)
end

function zrmine.f.Timer_Create(timerid, time, rep, func)
	if zrmine.f.FunctionValidater(func) then
		timer.Create(timerid, time, rep, func)
		table.insert(zrmine_TimerList, timerid)
	end
end

function zrmine.f.Timer_Remove(timerid)
	if timer.Exists(timerid) then
		timer.Remove(timerid)
		table.RemoveByValue(zrmine_TimerList, timerid)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
//////////////// CUSTOM ////////////////////
////////////////////////////////////////////
// This table will alter be used to convert a ore / metal type to a translation
// I know its stupid to write the ores as a string to begin with but thats how this script was writen back then
zrmine.OreToTranslation = {
	["Random"] = zrmine.language.Ore_Random,
	["Coal"] = zrmine.language.Ore_Coal,
	["Iron"] = zrmine.language.Ore_Iron,
	["Bronze"] = zrmine.language.Ore_Bronze,
	["Silver"] = zrmine.language.Ore_Silver,
	["Gold"] = zrmine.language.Ore_Gold,
}
function zrmine.f.GetOreTranslation(ore)
	return zrmine.OreToTranslation[ore] or "nil"
end

zrmine.OreToColor = {
	["Random"] = zrmine.default_colors["Random"],
	["Coal"] = zrmine.default_colors["Coal"],
	["Iron"] = zrmine.default_colors["Iron"],
	["Bronze"] = zrmine.default_colors["Bronze"],
	["Silver"] = zrmine.default_colors["Silver"],
	["Gold"] = zrmine.default_colors["Gold"],
}
function zrmine.f.GetOreColor(ore)
	return zrmine.OreToColor[ore] or Color(255,255,255)
end

zrmine.OreFromEnt = {
	["Coal"] = function(ent) return math.Round(ent:GetCoal(), 2) end,
	["Iron"] = function(ent) return math.Round(ent:GetIron(), 2) end,
	["Bronze"] = function(ent) return math.Round(ent:GetBronze(), 2) end,
	["Silver"] = function(ent) return math.Round(ent:GetSilver(), 2) end,
	["Gold"] = function(ent) return math.Round(ent:GetGold(), 2) end,
}
function zrmine.f.GetOreFromEnt(ent,ore)
	return zrmine.OreFromEnt[ore](ent) or 0
end
////////////////////////////////////////////
////////////////////////////////////////////
