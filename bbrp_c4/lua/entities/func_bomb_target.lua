ENT.Base = "base_brush"
ENT.Type = "brush"

local events = {
	BombExplode = true,
	BombDefused = true,
	BombPlanted = true
}

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
end

function ENT:KeyValue(key, value)
	if events[key] then
		self:StoreOutput(key, value)
	end
end

function ENT:AcceptInput(key, ply, caller, data)
	if events[key] then
		self:TriggerOutput(key, ply, data)
	end
end

function ENT:CheckBrush(pos)
	local mins = self:LocalToWorld(self:OBBMins())
	local maxs = self:LocalToWorld(self:OBBMaxs())

	return pos:WithinAABox(mins, maxs)
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		ent:SetNWBool("enhanced_c4_bomb_target", true)
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		ent:SetNWBool("enhanced_c4_bomb_target", false)
	end
end
