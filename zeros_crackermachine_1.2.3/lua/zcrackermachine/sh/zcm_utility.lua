zcm = zcm or {}
zcm.f = zcm.f or {}
zcm.utility = zcm.utility or {}

if SERVER then

	// Basic notify function
	function zcm.f.Notify(ply, msg, ntfType)
		if DarkRP then
			DarkRP.notify(ply, ntfType, 8, msg)
		else
			ply:ChatPrint(msg)
		end
	end
end

if (CLIENT) then

	function zcm.f.LerpColor(t, c1, c2)
		local c3 = Color(0, 0, 0)
		c3.r = Lerp(t, c1.r, c2.r)
		c3.g = Lerp(t, c1.g, c2.g)
		c3.b = Lerp(t, c1.b, c2.b)
		c3.a = Lerp(t, c1.a, c2.a)

		return c3
	end

	function zcm.f.stringWrap(str, w, f)
		if not isstring(str) then return end

		if f then
			surface.SetFont(f)
		else
			surface.SetFont("DermaDefault")
		end

		local stre = string.Explode(" ", str)
		local stri = {}
		local ti = 1
		stri[ti] = {}

		for k, v in pairs(stre) do
			local vw, vh = surface.GetTextSize(v)
			local tw, th = surface.GetTextSize(table.concat(stri[ti], ""))

			if tw + vw <= w then
				table.insert(stri[ti], v)
			else
				ti = ti + 1
				stri[ti] = {}
				table.insert(stri[ti], v)
			end
		end

		return stri
	end
end

//Used to fix the Duplication Glitch
function zcm.f.CollisionCooldown(ent)
	if ent.zwf_CollisionCooldown == nil then
		ent.zwf_CollisionCooldown = true

		timer.Simple(0.1,function()
			if IsValid(ent) then
				ent.zwf_CollisionCooldown = false
			end
		end)

		return false
	else
		if ent.zwf_CollisionCooldown then
			return true
		else
			ent.zwf_CollisionCooldown = true

			timer.Simple(0.1,function()
				if IsValid(ent) then
					ent.zwf_CollisionCooldown = false
				end
			end)
			return false
		end
	end
end


// Used for Debug
function zcm.f.Debug(mgs)
	if (zcm.config.Debug) then
		if istable(mgs) then
			print("[    DEBUG    ] Table Start >")
			PrintTable(mgs)
			print("[    DEBUG    ] Table End <")
		else
			print("[    DEBUG    ] " .. mgs)
		end
	end
end

// Checks if the distance between pos01 and pos02 is smaller then dist
function zcm.f.InDistance(pos01, pos02, dist)
	return pos01:DistToSqr(pos02) < (dist * dist)
end





////////////////////////////////////////////
///////////////// OWNER ////////////////////
////////////////////////////////////////////
if SERVER then
	// This saves the owners SteamID
	function zcm.f.SetOwnerByID(ent, id)
		ent:SetNWString("zcm_Owner", id)
	end

	// This saves the owners SteamID
	function zcm.f.SetOwner(ent, ply)
		if (IsValid(ply)) then
			ent:SetNWString("zcm_Owner", zcm.f.Player_GetID(ply))
			if zcm.config.CPPI and CPPI then
				ent:CPPISetOwner(ply)
			end
		else
			ent:SetNWString("zcm_Owner", "world")
		end
	end
end

// This returns the entites owner SteamID
function zcm.f.GetOwnerID(ent)
	return ent:GetNWString("zcm_Owner", "nil")
end

// Checks if both entities have the same owner
function zcm.f.OwnerID_Check(ent01,ent02)

	if IsValid(ent01) and IsValid(ent02) then

		if zcm.f.GetOwnerID(ent01) == zcm.f.GetOwnerID(ent02) then
			return true
		else
			return false
		end
	else
		return false
	end
end

// This returns the owner
function zcm.f.GetOwner(ent)
	if IsValid(ent) then
		local id = ent:GetNWString("zcm_Owner", "nil")
		local ply = player.GetBySteamID(id)

		if (IsValid(ply)) then
			return ply
		else
			return false
		end
	else
		return false
	end
end

// Checks if the player is the owner of the entitiy
function zcm.f.IsOwner(ply, ent)
	if IsValid(ent) and IsValid(ply) then
		local id = ent:GetNWString("zcm_Owner", "nil")
		local ply_id = zcm.f.Player_GetID(ply)

		if id == ply_id or id == "world" then
			return true
		else
			return false
		end
	else
		return false
	end
end

// This returns true if the player is a admin
function zcm.f.IsAdmin(ply)
	if IsValid(ply) then
		if xAdmin then
			//xAdmin Support
			return ply:IsAdmin()
		else
			if zcm.config.AdminRanks[zcm.f.GetPlayerRank(ply)] then
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
function zcm.f.GetPlayerRank(ply)
	return ply:GetUserGroup()
end

// Returns the players job
function zcm.f.GetPlayerJobName(ply)
	return team.GetName( zcm.f.GetPlayerJob(ply) )
end

function zcm.f.GetPlayerJob(ply)
	return ply:Team()
end
////////////////////////////////////////////
////////////////////////////////////////////




////////////////////////////////////////////
//////////////// Custom ////////////////////
////////////////////////////////////////////

function zcm.f.IsCrackerMaker(ply)
	if zcm.config.Jobs and table.Count(zcm.config.Jobs) > 0 then
		if zcm.config.Jobs[zcm.f.GetPlayerJob(ply)] then
			return true
		else
			return false
		end
	else
		return true
	end
end

function zcm.f.IsCrackerMakerJobID(jobid)
	if zcm.config.Jobs and table.Count(zcm.config.Jobs) > 0 then
		if zcm.config.Jobs[jobid] then
			return true
		else
			return false
		end
	else
		return true
	end
end

////////////////////////////////////////////
////////////////////////////////////////////
