zrmine = zrmine or {}
zrmine.f = zrmine.f or {}


local rtypes = {
	[1] = "Coal",
	[2] = "Iron",
	[3] = "Bronze",
	[4] = "Silver",
	[5] = "Gold",
}


if SERVER then

	// Animation
	util.AddNetworkString("zrmine_AnimEvent")
	function zrmine.f.CreateAnimTable(prop, anim, speed)
		zrmine.f.Animation(prop, anim, speed)

		local seqid = prop:LookupSequence( anim )

		net.Start("zrmine_AnimEvent")
		net.WriteEntity(prop)
		net.WriteInt(seqid,16)
		net.WriteFloat(speed)
		net.SendPVS(prop:GetPos())
	end



	//Custom Emitter
	util.AddNetworkString("zrmine_insert_FX")
	function zrmine.f.CreateInsertEffect(prop, rtype)
		if zrmine.config.DisableVFX then return end

		local typeid = 1

		if rtype == "Coal" then
			typeid = 1
		elseif rtype == "Iron" then
			typeid = 2
		elseif rtype == "Bronze" then
			typeid = 3
		elseif rtype == "Silver" then
			typeid = 4
		elseif rtype == "Gold" then
			typeid = 5
		end

		net.Start("zrmine_insert_FX")
		net.WriteEntity(prop)
		net.WriteInt(typeid,16)
		net.SendPVS(prop:GetPos())
	end

	function zrmine.f.GenericEffect(effect,vPoint)
		local effectdata = EffectData()
		effectdata:SetStart(vPoint)
		effectdata:SetOrigin(vPoint)
		effectdata:SetScale(1)
		util.Effect(effect, effectdata)
	end


	util.AddNetworkString("zrmine_SFX")
	function zrmine.f.CreateSoundEffect(sound, ent)
		net.Start("zrmine_SFX")
		net.WriteString(sound)
		net.WriteEntity(ent)
		net.SendPVS(ent:GetPos())
	end
end

if CLIENT then

	net.Receive("zrmine_AnimEvent", function(len, ply)
		zrmine.f.Debug("zrmine_AnimEvent Len: " .. len)

		local prop = net.ReadEntity()
		local seqid = net.ReadInt(16)
		local speed = net.ReadFloat()


		if speed and IsValid(prop) and seqid then
			local anim = prop:GetSequenceName(seqid)

			zrmine.f.Animation(prop, anim, speed)
		end
	end)

	net.Receive("zrmine_SFX", function(len, ply)
		local sound = net.ReadString()
		local ent = net.ReadEntity()
		if sound and IsValid(ent) then
			zrmine.f.EmitSoundENT(sound,ent)
		end
	end)

	//Custom Emitter
	local function Emit_InsertEffect(prop, rtype)
		//TODO This should be included aswell in the new system
		if (GetConVar("zrms_cl_FillIndicator"):GetInt() == 0) then return end

		local pos = prop:GetPos()
		local vel = Vector(0, 0, 200)

		if prop:GetClass() == "zrms_ore" then
			pos = prop:GetPos() + prop:GetRight() * math.random(-50, 50) + prop:GetForward() * math.random(-50, 50)
			vel = Vector(0, 0, math.random(300, 350))
		elseif string.sub(prop:GetClass(), 1, 12) == "zrms_refiner" then
			pos = prop:GetPos() + prop:GetUp() * 45
		end

		local icon = prop.InsertEffect:Add("zerochain/zrms/particles/zrms_ore", pos)
		icon:SetVelocity(vel)
		icon:SetDieTime(2)
		icon:SetStartAlpha(255)
		icon:SetEndAlpha(0)
		icon:SetStartSize(7)
		icon:SetEndSize(10)

		local iconColor = zrmine.f.GetOreColor(rtype)

		icon:SetColor(iconColor.r, iconColor.g, iconColor.b)
		icon:SetGravity(Vector(0, 0, 0))
		icon:SetAirResistance(256)
	end

	net.Receive("zrmine_insert_FX", function(len, ply)
		zrmine.f.Debug("zrmine_insert_FX Len: " .. len)

		local ent = net.ReadEntity()
		local typeid = net.ReadInt(16)

		local rtype = rtypes[typeid]
		// Triggers our insert effect
		if IsValid(ent) and zrmine.f.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 500) then
			Emit_InsertEffect(ent, rtype)
		end
	end)

	function zrmine.f.ParticleEffect(effect, pos, ang, ent)
		if GetConVar("zrms_cl_particleffects"):GetInt() == 1 then
			ParticleEffect(effect, pos, ang, ent)
		end
	end

	function zrmine.f.ParticleEffectAttach(effect, ent, attachid)
		if GetConVar("zrms_cl_particleffects"):GetInt() == 1 then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, attachid)
		end
	end
end


function zrmine.f.Animation(prop, anim, speed)
	local sequence = prop:LookupSequence(anim)
	prop:SetCycle(0)
	prop:ResetSequence(sequence)
	prop:SetPlaybackRate(speed)
	prop:SetCycle(0)
end

// Here we define diffrent effect groups which later make it pretty optimized to create Sound/Particle effects over the network
// The key will be used as the NetworkString
zrmine.NetEffectGroups = {
	["mine_close"] = {
		_type = "entity",
		_server = true,
		action = function(ent)

			zrmine.f.Animation(ent, "door_close", 1)

			if CLIENT then
				zrmine.f.EmitSoundENT("zrmine_connect_refinery", ent)

				timer.Simple(1.5, function()
					if IsValid(ent) then
						zrmine.f.EmitSoundENT("zrmine_mine_door_move", ent)
					end
				end)

				timer.Simple(2, function()
					if IsValid(ent) then
						zrmine.f.EmitSoundENT("zrmine_mine_door_stop", ent)
					end
				end)
			end
			timer.Simple(5, function()
				if IsValid(ent) then
					zrmine.f.Animation(ent, "wheel_roll", 0.5)
				end
			end)
		end,
	},
	["mine_close_instantly"] = {
		_type = "entity",
		_server = true,
		action = function(ent)

			zrmine.f.Animation(ent, "door_close", 10)
			if CLIENT then
				zrmine.f.EmitSoundENT("zrmine_mine_door_stop", ent)
			end
		end,
	},
	["mine_open"] = {
		_type = "entity",
		_server = true,
		action = function(ent)

			zrmine.f.Animation(ent, "door_open", 1)

			if CLIENT then
				zrmine.f.EmitSoundENT("zrmine_mine_door_move",ent)

				timer.Simple(0.3, function()
					if IsValid(ent) then

						zrmine.f.EmitSoundENT("zrmine_mine_door_stop",ent)
					end
				end)
			end
		end,
	},
	["mine_foundore"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundENT("zrmine_connect_refinery",ent)
			zrmine.f.ParticleEffect("zrms_ore_mine", ent:GetPos(), Angle(0,0,0), ent)
		end,
	},
	["mine_orejunkspawn"] = {
		action = function(pos)
			zrmine.f.EmitSoundPos("zrmine_spawnresource", pos)
			zrmine.f.ParticleEffect("mine_res_spawn01", pos, Angle(0,0,0), Entity(1))
		end,
	},

	["minecart_unload"] = {
		_type = "entity",
		_server = true,
		action = function(ent)
			zrmine.f.Animation(ent, "unloading", 0.5)
		end,
	},
	["minecart_down"] = {
		_type = "entity",
		_server = true,
		action = function(ent)
			zrmine.f.Animation(ent, "rolling_down", 1)
		end,
	},

	["sorter_wheel"] = {
		_type = "entity",

		action = function(ent)

			zrmine.f.Animation(ent, "rolling_down", 1)

		end,
	},
	["swep_buymodule"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundPos("zrmine_cash", ent:GetPos())

			// Connection Sound
			timer.Simple(0.2, function()
				if IsValid(ent) then
					if string.sub(ent:GetClass(), 1, 12) == "zrms_refiner" then
						zrmine.f.EmitSoundENT("zrmine_connect_refinery",ent)
					else
						zrmine.f.EmitSoundENT("zrmine_connect_belt",ent)
					end
				end
			end)
		end,
	},
	["swep_sellmodule"] = {
		_type = "entity",

		action = function(ent)

			zrmine.f.EmitSoundPos("zrmine_cash", ent:GetPos())
		end,
	},
	["object_destroy"] = {
		_type = "entity",

		action = function(ent)

			zrmine.f.EmitSoundPos("zrmine_resourcedespawn", ent:GetPos())
		end,
	},
	["pickaxe_hit"] = {
		action = function(pos)
			zrmine.f.EmitSoundPos("zrmine_pickaxeHit", pos)
			zrmine.f.ParticleEffect("pickaxe_hit01", pos, Angle(0,0,0), Entity(1))
		end,
	},
	["pickaxe_empty"] = {
		action = function(pos)
			zrmine.f.EmitSoundPos("zrmine_pickaxeHit", pos)
		end,
	},

	["entity_despawn"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundPos("zrmine_resourcedespawn", ent:GetPos())
			zrmine.f.ParticleEffect("zrms_resource_despawn",  ent:GetPos(), Angle(0,0,0), ent)
		end,
	},

	["belt_clear"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundENT("zrmine_refinerdirt",ent)
		end,
	},

	["belt_destroyressource"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundPos("zrmine_addgravel", ent:GetPos())

			local attach = ent:LookupAttachment("output")
			if attach == nil then return end
			attach = ent:GetAttachment(attach)
			if attach == nil then return end

			local effectPos02 = attach.Pos + ent:GetUp() * 24 + ent:GetForward() * 5
			local effectAng02 = ent:GetAngles()

			zrmine.f.EmitSoundENT("zrmine_refinerdirt",ent)
			zrmine.f.ParticleEffect("zrms_refiner_dirt02",  effectPos02, effectAng02, ent)
		end,
	},

	["crusher_addressource"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundENT("zrmine_addgravel",ent)
		end,
	},

	["entity_sendressource"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundENT("zrmine_crush_expo",ent)
		end,
	},

	["crate_break"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.EmitSoundENT("zrmine_crate_break",ent)
		end,
	},

	["orespawn_decrease"] = {
		_type = "entity",

		action = function(ent)

			zrmine.f.EmitSoundENT("zrmine_resourcedespawn",ent)
			zrmine.f.ParticleEffect("zrms_ore_mine",  ent:GetPos(), ent:GetAngles(), ent)
		end,
	},
	["orespawn_refresh"] = {
		_type = "entity",

		action = function(ent)
			zrmine.f.ParticleEffect("zrms_ore_refresh",  ent:GetPos(), ent:GetAngles(), ent)
		end,
	},

	["place_crate"] = {
		_type = "entity",

		action = function(ent)

			zrmine.f.EmitSoundENT("zrmine_placecrate",ent)
		end,
	},

	["refinery_refine"] = {
		_type = "entity",

		action = function(ent)

			zrmine.f.ParticleEffect("zrms_refiner_refine",  ent:GetPos(), ent:GetAngles(), ent)
		end,
	},
}

if SERVER then



	// Creates a network string for all the effect groups
	for k, v in pairs(zrmine.NetEffectGroups) do
		util.AddNetworkString("zrmine_fx_" .. k)
	end

	// Sends a Net Effect Msg to all clients
	function zrmine.f.CreateNetEffect(id,data)

		// Data can be a entity or position

		local EffectGroup = zrmine.NetEffectGroups[id]

		// Some events should be called on server to
		if EffectGroup._server then
			EffectGroup.action(data)
		end

		net.Start("zrmine_fx_" .. id)
		if EffectGroup._type == "entity" then
			net.WriteEntity(data)
		else
			net.WriteVector(data)
		end
		net.Broadcast()
	end
end

if CLIENT then

	for k, v in pairs(zrmine.NetEffectGroups) do
		net.Receive("zrmine_fx_" .. k, function(len)
			zrmine.f.Debug("zrmine_fx_" .. k .. " Len: " .. len)

			if v._type == "entity" then
				local ent = net.ReadEntity()

				if IsValid(ent) then

					zrmine.NetEffectGroups[k].action(ent)
				end
			else
				local pos = net.ReadVector()
				if pos then
					zrmine.NetEffectGroups[k].action(pos)
				end
			end
		end)
	end
end
