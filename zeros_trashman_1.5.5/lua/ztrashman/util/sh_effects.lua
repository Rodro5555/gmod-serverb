ztm = ztm or {}
ztm.Effects = ztm.Effects or {}

local effects = {"ztm_trash_break01","ztm_trash_break02","ztm_trash_break03"}
function ztm.Effects.Trash(pos,ent)
	zclib.Effect.ParticleEffect(effects[ math.random( #effects ) ],pos, angle_zero, ent or Entity(1))
	if IsValid(ent) then ent:EmitSound("ztm_trash_break") end
end


zclib.NetEvent.AddDefinition("ztm_leafpile_fx", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	if zclib.util.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 1500) == false then return end
	ent:EmitSound("ztm_leafpile_explode01")
	zclib.Effect.ParticleEffect("ztm_leafpile_explode", ent:GetPos(), ent:GetAngles(), ent)
end)

zclib.NetEvent.AddDefinition("ztm_trashcollector_primary_fx", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local SwepOwner = received[1]
	if not IsValid(SwepOwner) then return end
	if zclib.util.InDistance(LocalPlayer():GetPos(), SwepOwner:GetPos(), 500) == false then return end
	local swep = SwepOwner:GetActiveWeapon()
	if not IsValid(swep) then return end
	if swep:GetClass() ~= "ztm_trashcollector" then return end

	if LocalPlayer() == SwepOwner then
		local ve = GetViewEntity()

		if ve:GetClass() ~= "player" then
			zclib.Effect.ParticleEffectAttach("ztm_air_burst", PATTACH_POINT_FOLLOW, swep, 1)
		end
	else
		zclib.Effect.ParticleEffectAttach("ztm_air_burst", PATTACH_POINT_FOLLOW, swep, 1)
	end
end)
