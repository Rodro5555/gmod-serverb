zcm = zcm or {}
zcm.f = zcm.f or {}


// Here we define diffrent effect groups which later make it pretty optimized to create Sound/Particle effects over the network
// The key will be used as the NetworkString
zcm.NetEffectGroups = {
	["sell_effect"] = {
		action = function(pos)
			zcm.f.ParticleEffect("zcm_sell", pos, Angle(0,0,0), Entity(1))
			sound.Play(zcm.Sounds["zcm_sell"], pos, 75, 100, zcm.f.GetVolume())
		end,
	},
	["zcm_blackpowder_explode"] = {
		action = function(pos)
			zcm.f.ParticleEffect("zcm_blackpowder_explode", pos, Angle(0,0,0), Entity(1))
			sound.Play(zcm.Sounds["zcm_explode"][math.random(#zcm.Sounds["zcm_explode"])], pos, 75, 100, zcm.f.GetVolume())
		end,
	},
	["zcm_fuse"] = {
		_type = "entity",
		action = function(ent)
			zcm.f.ParticleEffectAttach("zcm_fuse", ent, 1)
			EmitSound("zcm/zcm_fuse.wav", ent:GetPos(), ent:EntIndex(), CHAN_STATIC, zcm.f.GetVolume(), 75, 0, 100)

			local pos = ent:GetPos()
			timer.Simple(2,function()
				zcm.f.CrackerPackExplode(pos)
			end)
		end,
	},
	["crackerpack_explosion"] = {
		action = function(pos)
			zcm.f.ParticleEffect("crackerpack_explosion", pos, Angle(0,0,0), Entity(1))
			zcm.f.ParticleEffect("zcm_crackermain", pos, Angle(0,0,0), Entity(1))
			sound.Play(zcm.Sounds["zcm_explode01"][math.random(#zcm.Sounds["zcm_explode01"])], pos, 75, 100, zcm.f.GetVolume())
			sound.Play(zcm.Sounds["zcm_explode"][math.random(#zcm.Sounds["zcm_explode"])], pos, 75, 100, zcm.f.GetVolume())
		end,
	},

}

function zcm.f.PlayAnimation(ent,anim, speed)
	local sequence = ent:LookupSequence(anim)
	ent:SetCycle(0)
	ent:ResetSequence(sequence)
	ent:SetPlaybackRate(speed)
	ent:SetCycle(0)
end

if SERVER then

	// Creates a network string for all the effect groups
	for k, v in pairs(zcm.NetEffectGroups) do
		util.AddNetworkString("zcm_fx_" .. k)
	end

	// Sends a Net Effect Msg to all clients
	function zcm.f.CreateNetEffect(id,data)

		// Data can be a entity or position

		local EffectGroup = zcm.NetEffectGroups[id]

		// Some events should be called on server to
		if EffectGroup._server then
			EffectGroup.action(data)
		end

		net.Start("zcm_fx_" .. id)
		if EffectGroup._type == "entity" then
			net.WriteEntity(data)
		else
			net.WriteVector(data)
		end
		net.Broadcast()
	end
end

if CLIENT then

	for k, v in pairs(zcm.NetEffectGroups) do
		net.Receive("zcm_fx_" .. k, function(len)

			if v._type == "entity" then
				local ent = net.ReadEntity()

				if IsValid(ent) then

					zcm.NetEffectGroups[k].action(ent)
				end
			else
				local pos = net.ReadVector()
				if pos then
					zcm.NetEffectGroups[k].action(pos)
				end
			end
		end)
	end

	function zcm.f.ParticleEffect(effect, pos, ang, ent)
		if GetConVar("zcm_cl_vfx_particleffects"):GetInt() == 1 then
			ParticleEffect(effect, pos, ang, ent)
		end
	end

	function zcm.f.ParticleEffectAttach(effect, ent, attachid)
		if GetConVar("zcm_cl_vfx_particleffects"):GetInt() == 1 then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, attachid)
		end
	end
end


// Creates a util.Effect
function zcm.f.Destruct(ent,effect)
	local vPoint = ent:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect(effect, effectdata)
end
