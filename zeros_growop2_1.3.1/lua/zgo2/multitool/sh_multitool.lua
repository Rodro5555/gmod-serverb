zgo2 = zgo2 or {}
zgo2.Multitool = zgo2.Multitool or {}

/*
	Checks if the area is free
	TODO Integrate this somehow so the tent when we place it doesent glitch through the world mesh
*/
local vec01 = Vector(0, 0, -5)
local vec02 = Vector(0, 0, 5)
function zgo2.Multitool.PostionCheck(ent)

	//if IsValid(HitEntity) then return false end

    local function AddTrace(l_pos,l_dir)
        local s_pos = ent:LocalToWorld(l_pos)
        local e_pos = ent:LocalToWorld(l_pos + l_dir)
        local c_trace = zclib.util.TraceLine({
            start = s_pos,
            endpos = e_pos,
            mask = MASK_SOLID_BRUSHONLY,
        }, "zgo2_PositionCheck")

        //debugoverlay.Line(s_pos,e_pos, 5, (c_trace and c_trace.Hit) and Color( 255, 255, 255 ) or Color( 255, 0, 0 ), false )

        return c_trace and c_trace.Hit
    end

    local min, max = ent:GetCollisionBounds()

    // Check if the bottom of the crate is near the ground
    local HasGround = true
    HasGround = AddTrace(Vector(min.x, min.y, min.z + 2), vec01)
    HasGround = AddTrace(Vector(max.x, min.y, min.z + 2), vec01)
    HasGround = AddTrace(Vector(max.x, max.y, min.z + 2), vec01)
    HasGround = AddTrace(Vector(min.x, max.y, min.z + 2), vec01)

    // Check if the area above is free
    local AreaFree = true
    AreaFree = not AddTrace(Vector(min.x, min.y, max.z - 2), vec02)
    AreaFree = not AddTrace(Vector(max.x, min.y, max.z - 2), vec02)
    AreaFree = not AddTrace(Vector(max.x, max.y, max.z - 2), vec02)
    AreaFree = not AddTrace(Vector(min.x, max.y, max.z - 2), vec02)

    return HasGround and AreaFree
end

function zgo2.Multitool.IsPlaceTarget(ply,class,HitPos,HitEntity,category,ItemID)
	if not zclib.util.InDistance(HitPos, ply:GetPos(), 500) then return false end

	if not zgo2.Shop.List[category] then return end
	local data = zgo2.Shop.List[category].items[ItemID]
	if not data then return end

	if class == "zgo2_soil" and IsValid(HitEntity) and HitEntity:GetClass() == "zgo2_pot" then
		if HitEntity:GetHasSoil() then
			return false
		else
			return true
		end
	end

	if class == "zgo2_jar" and IsValid(HitEntity) and HitEntity:GetClass() == "zgo2_clipper" then return true end

	if class == "zgo2_fuel" then
		if not IsValid(HitEntity) then return true end
		return not zgo2.Generator.FuelLimitReached(HitEntity)
	end

	if class == "zgo2_seed" then
		if not IsValid(HitEntity) then return true end
		if HitEntity:GetClass() ~= "zgo2_pot" then return false end
		if not HitEntity:GetHasSoil() then return false end
		if IsValid(HitEntity:GetPlant()) then return false end

		if SERVER and not zgo2.Pot.GotPlaced(HitEntity) then
			zclib.Notify(ply,zgo2.language[ "PotsToRackRequierment" ], 1)
			return
		end

		return true
	end

	if class == "zgo2_battery" then
		if not IsValid(HitEntity) then
			if SERVER then zclib.Notify(ply,zgo2.language[ "BatteryToMachine" ], 1) end
			return false
		end

		if HitEntity:GetClass() ~= "zgo2_lamp" and HitEntity:GetClass() ~= "zgo2_clipper" then
			if SERVER then zclib.Notify(ply,zgo2.language[ "BatteryToMachine" ], 1) end
			return false
		end

		if HitEntity:GetPower() >= zgo2.config.Battery.Power then

			return false
		end

		if HitEntity:GetClass() == "zgo2_clipper" and not HitEntity:GetHasMotor() then
			if SERVER then zclib.Notify(ply,zgo2.language[ "ClipperNeedsMotor" ], 1) end
			return false
		end

		return true
	end

	if class == "zgo2_bulb" then
		if not IsValid(HitEntity) then
			if SERVER then zclib.Notify(ply,zgo2.language[ "BulbToSodiumLamp" ], 1) end
			return false
		end
		if HitEntity:GetClass() ~= "zgo2_lamp" then
			if SERVER then zclib.Notify(ply,zgo2.language[ "BulbToSodiumLamp" ], 1) end
			return false
		end
		return zgo2.Lamp.UsesBulbs(HitEntity)
	end

	if class == "zgo2_motor" then
		if not IsValid(HitEntity) then
			if SERVER then zclib.Notify(ply,zgo2.language[ "MotorToClipper" ], 1) end
			return false
		end
		if HitEntity:GetClass() ~= "zgo2_clipper" then
			if SERVER then zclib.Notify(ply,zgo2.language[ "MotorToClipper" ], 1) end
			return false
		end
		return not HitEntity:GetHasMotor()
	end

	if class == "zgo2_fuel" then
		if not IsValid(HitEntity) then return false end
		if HitEntity:GetClass() ~= "zgo2_generator" then return false end
		if zgo2.Generator.FuelLimitReached(HitEntity) then return false end
		return true
	end

	if class == "zgo2_pot" then
		if zgo2.config.Pot.RequiereRack then

			if not IsValid(HitEntity) then
				if SERVER then zclib.Notify(ply,zgo2.language[ "PotsToRackRequierment" ], 1) end
				return false
			end

			if HitEntity:GetClass() ~= "zgo2_rack" and HitEntity:GetClass() ~= "zgo2_tent" then
				if SERVER then zclib.Notify(ply,zgo2.language[ "PotsToRackRequierment" ], 1) end
				return false
			end

			if SERVER then
				if HitEntity:GetClass() == "zgo2_tent" and not zgo2.Tent.GetPotSpot(HitEntity) then return false end
				if HitEntity:GetClass() == "zgo2_rack" and not zgo2.Rack.GetPotSpot(HitEntity) then return false end
			end
		end
		return true
	end

	if class == "zgo2_lamp" then
		if zgo2.Lamp.TentOnly(data.id) then
			if not IsValid(HitEntity) then
				if SERVER then zclib.Notify(ply,zgo2.language[ "LampsToTentRequierment" ], 1) end
				return false
			end

			if HitEntity:GetClass() ~= "zgo2_tent" then
				if SERVER then zclib.Notify(ply,zgo2.language[ "LampsToTentRequierment" ], 1) end
				return false
			end

			if SERVER and not zgo2.Tent.GetLampSpot(HitEntity) then return false end

			return true
		else
			if IsValid(HitEntity) then return false end
		end
	end

	if class == "zgo2_dryline" then
		if zgo2.config.Dryline.WorldOnly and (HitEntity and not HitEntity:IsWorld()) then
			return false
		else
			return true
		end
	end

	if IsValid(HitEntity) then return false end

	return true
end

/*
	Defines which entity we should ignore
*/
function zgo2.Multitool.IsHitTarget(ent)
	if not IsValid(ent) then return false end

	local class = ent:GetClass()
	if class == "zgo2_plant" then return false end

	return true
end


/*
	Specifies a rotational offset
*/
local offsets = {
	["models/zerochain/props_growop2/zgo2_tent01.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_tent02.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_generator.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_watertank.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_watertank_small.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_rack.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_rack01.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_weedseeds.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_weedpacker.mdl"] = 180,
	["models/zerochain/props_growop2/zgo2_generator01.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_pump.mdl"] = 180,
	["models/zerochain/props_growop2/zgo2_led_lamp01.mdl"] = 180,
	["models/zerochain/props_growop2/zgo2_led_lamp02.mdl"] = 180,
	["models/zerochain/props_growop2/zgo2_led_lamp03.mdl"] = 180,

	["models/zerochain/props_growop2/zgo2_sodium_lamp01.mdl"] = 180,
	["models/zerochain/props_growop2/zgo2_sodium_lamp02.mdl"] = 180,
	["models/zerochain/props_growop2/zgo2_sodium_lamp03.mdl"] = 180,

	["models/zerochain/props_growop2/zgo2_lab.mdl"] = 90,

	["models/zerochain/props_growop2/zgo2_mixer.mdl"] = 90,
	["models/zerochain/props_growop2/zgo2_oven.mdl"] = 90,
}

function zgo2.Multitool.GetOffset(mdl)
	return offsets[mdl] or 0
end
