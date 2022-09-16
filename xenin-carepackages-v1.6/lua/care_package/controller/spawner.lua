function CarePackage:PrepareNextDrop()
	local cfg = CarePackage.Config
	local time = 0
	if (cfg.SpawnTime.PlayerBased.Enabled) then
		local players = player.GetCount()
		if (players <= 5) then
			time = cfg.SpawnTime.Max
		else
			local frac = math.Clamp(players / cfg.SpawnTime.PlayerBased.CapAt, 0, 1)
			time = Lerp(frac, cfg.SpawnTime.Max, cfg.SpawnTime.Min)
		end
	else
		time = math.random(cfg.SpawnTime.Min, cfg.SpawnTime.Max)
	end
	-- Make it minutes
	time = time * 60

	timer.Simple(time, function()
		self:Start()
	end)
end

function CarePackage:Message(str)
	net.Start("CarePackage.Message")
		net.WriteString(str)
	net.Broadcast()
end

function CarePackage:MessagePlayer(ply, str)
	net.Start("CarePackage.Message")
		net.WriteString(str)
	net.Send(ply)
end

function CarePackage:Start()
	local sec = CarePackage.Config.CommencingSeconds
	self:Message(CarePackage:GetPhrase("Spawn.Commencing", { time = sec }))

	timer.Simple(CarePackage.Config.CommencingSeconds, function()
		CarePackage:Spawn()
	end)
end

function CarePackage:Spawn()
	self:Message(CarePackage:GetPhrase("Spawn.Spawned"))

	local startPos, dropPos, z = self:GetRandomPositions()
	self:CreatePlane(startPos, dropPos, z)
	self:PrepareNextDrop()
end

hook.Add("InitPostEntity", "CarePackage", function()
	CarePackage:PrepareNextDrop()
end)

hook.Add("CarePackage.FlareDropped", "CarePackage", function(ent, pos)
	local ply = ent:GetOwner()
	CarePackage:Message(CarePackage:GetPhrase("Flare.Plane"))

	local startPos, dropPos, z = CarePackage:GetRandomPositions()
	local realZ = pos.z + 30
	pos.z = dropPos.z
	CarePackage:CreatePlane(startPos, pos, realZ)

	timer.Simple(15, function()
		if (IsValid(ent)) then
			ent:Remove()
		end
	end)
end)

hook.Add("CarePackage.FlareInvalid", "CarePackage", function(ent)
	local ply = ent:GetOwner()
	ply:Give("cp_flaregun")
	ply:SelectWeapon("cp_flaregun")

	if (IsValid(ent)) then
		ent:Remove()
	end
end)