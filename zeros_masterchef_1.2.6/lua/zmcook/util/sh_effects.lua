
zmc = zmc or {}
zmc.Effect = zmc.Effect or {}

local EatEffects = {"zmc_eat_splash01","zmc_eat_splash02","zmc_eat_splash03"}
function zmc.Effect.Eat(ent,isvomit)
	local pos,ang = ent:GetPos(),ent:GetAngles()
	if ent:IsPlayer() then
		local attach = ent:GetAttachment(ent:LookupAttachment("eyes"))
		if attach then
			pos,ang = attach.Pos,attach.Ang
		end

		if isvomit then
			//ent:EmitSound("zmc_posion_food")
			ent:EmitSound("zmc_vomit")

			// Add vomit effect
			local mouth_attach = ent:GetAttachment(ent:LookupAttachment("mouth"))
			if mouth_attach and mouth_attach.Pos and mouth_attach.Ang then
				zclib.Effect.ParticleEffectAttach("zmc_vomit", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("mouth"))
			end
		else
			ent:EmitSound("zmc_eat")
		end
	else
		ent:EmitSound("zmc_eat")
	end

	zclib.Effect.ParticleEffect(EatEffects[math.random(#EatEffects)], pos, ang, ent)
end


zclib.NetEvent.AddDefinition("worktable_interact", {
	[1] = {
		type = "entity"
	},
}, function(received)
	local ent = received[1]

	zmc.Worktable.Interaction(ent)
end)

zclib.NetEvent.AddDefinition("wok_interact", {
	[1] = {
		type = "entity"
	},
}, function(received)
	zmc.Wok.Interaction(received[1])
end)

zclib.NetEvent.AddDefinition("eat_effect", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "bool"
	},
}, function(received)
	local ent = received[1]
	local isvomit = received[2]
	zmc.Effect.Eat(ent,isvomit)
end)

zclib.NetEvent.AddDefinition("grill_flip", {
	[1] = {
		type = "entity"
	},
}, function(received)
	local ent = received[1]
	zmc.Grill.FlipItems(ent)
end)


local FlameObjects = {}
local function AddFlame(ent,pos,ang)
	local cl_ent = zclib.ClientModel.AddProp()
	if not IsValid(cl_ent) then return end
	cl_ent:DrawShadow(false)
	cl_ent:SetNoDraw(true)
	cl_ent:SetModel("models/props_junk/PopCan01a.mdl")
	cl_ent.FlameObject = true
	zclib.Effect.ParticleEffectAttach("zmc_flame_burst", PATTACH_POINT_FOLLOW, cl_ent, 0)

	cl_ent:SetPos(pos)
	cl_ent:SetAngles(ang)
	cl_ent:SetParent(ent)

	table.insert(FlameObjects,{parent = ent,cl_ent = cl_ent,killtime = CurTime() + 7})
end

zclib.NetEvent.AddDefinition("gastank_damage", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "vector"
	},
}, function(received)
	local ent = received[1]
	local lpos = received[2]
	local wpos = ent:LocalToWorld(lpos)
	local dir = (wpos - ent:GetPos()):Angle()

	AddFlame(ent,wpos,dir)

	local timerid = "zmc_flameobject_timer"
	if timer.Exists(timerid) then return end
	zclib.Timer.Create(timerid,0.1,0,function()
		for k,v in pairs(FlameObjects) do
			if v == nil then FlameObjects[k] = nil continue end
			if v.killtime == nil then
				if IsValid(v.cl_ent) then zclib.ClientModel.Remove(v.cl_ent) end
				FlameObjects[k] = nil
				continue
			end
			if not IsValid(v.parent) then
				if IsValid(v.cl_ent) then zclib.ClientModel.Remove(v.cl_ent) end
				FlameObjects[k] = nil
				continue
			end
			if CurTime() >= v.killtime then
				if IsValid(v.cl_ent) then zclib.ClientModel.Remove(v.cl_ent) end
				FlameObjects[k] = nil
			end
		end
		if table.IsEmpty(FlameObjects) then
			zclib.Timer.Remove(timerid)
		end
	end)
end)

zclib.NetEvent.AddDefinition("gastank_preexplo", {
	[1] = {
		type = "entity"
	},
}, function(received)
	local ent = received[1]

	if IsValid(ent) then zclib.Effect.ParticleEffectAttach("zmc_flame_base", PATTACH_POINT_FOLLOW, ent, 0) end
end)

zclib.NetEvent.AddDefinition("cleaning", {
	[1] = {
		type = "entity"
	},
}, function(received)
	local ent = received[1]
	if IsValid(ent) then
		zclib.Sound.EmitFromEntity("splash", ent)
		zclib.Effect.ParticleEffect("zmc_cleaning", ent:LocalToWorld(Vector(0,13,43)), Angle(0,0,0), ent)
	end
end)
