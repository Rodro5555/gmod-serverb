if SERVER then return end
zcm = zcm or {}
zcm.f = zcm.f or {}
local ActiveEffects = {}

function zcm.f.ParticleOverFlow_Check()
	local maxCount = GetConVar("zcm_cl_vfx_effectcount"):GetFloat()

	// Here we remove every timecode that is allready over
	if ActiveEffects and table.Count(ActiveEffects) > 0 then
		for k, v in pairs(ActiveEffects) do
			if isnumber(v) and CurTime() > v then
				table.RemoveByValue(ActiveEffects, v)
			end
		end
	end

	if table.Count(ActiveEffects) > maxCount then
		return false
	else
		// Here we add the Duration of the effect in the active effect table
		table.insert(ActiveEffects, CurTime() + 1)

		return true
	end
end
