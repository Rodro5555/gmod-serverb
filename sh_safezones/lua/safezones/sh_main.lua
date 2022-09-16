SH_SZ.OUTSIDE = 0
SH_SZ.ENTERING = 1
SH_SZ.PROTECTED = 2

function SH_SZ:GetSafeStatus(ply, sz)
	local i = ply:GetNWInt("SH_SZ.Safe", SH_SZ.OUTSIDE)
	if (SERVER) then
		return i
	else
		if (i == SH_SZ.ENTERING) then
			return "will_be_protected_in_x", math.max(math.ceil(sz.enter + sz.opts.ptime - CurTime()), 0)
		elseif (i == SH_SZ.PROTECTED) then
			return "safe_from_damage"
		else
			return ""
		end
	end
end

function SH_SZ:StartCommand(ply, cmd)
	if (self.Usergroups[ply:GetUserGroup()]) then
		return end

	local sz = SERVER and ply.SH_SZ or SH_SZ.m_Safe
	if (!sz) then
		return end

	if (sz.opts.noatk) then
		local swep = ply:GetActiveWeapon()
		if (IsValid(swep) and !self.WeaponWhitelist[swep:GetClass()]) then
			cmd:RemoveKey(IN_ATTACK)
			cmd:RemoveKey(IN_ATTACK2)
		end
	end
end

hook.Add("StartCommand", "SH_SZ.StartCommand", function(ply, cmd)
	SH_SZ:StartCommand(ply, cmd)
end)