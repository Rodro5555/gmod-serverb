zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

// Stores  all the plants
zgo2.Plant.List = zgo2.Plant.List or {}

// Stores a list of all objects which weed material should be updated
zgo2.Plant.UpdateMaterials = zgo2.Plant.UpdateMaterials or {}

/*

	The Weed plant is the core element of the game and it can have a lot of diffrent stats

*/
function zgo2.Plant.Initialize(Plant)
	Plant:DestroyShadow()

	timer.Simple(0.5, function()
		if IsValid(Plant) then
			Plant.m_Initialized = true
		end
	end)
end

function zgo2.Plant.OnDraw(Plant)
	if not Plant.m_Initialized then return end
	Plant:DrawModel()

	if not LocalPlayer().zgo2_Initialized then return end
	if zclib.util.InDistance(Plant:GetPos(), LocalPlayer():GetPos(), 1000) == false then return end

	if zclib.Convar.GetBool("zgo2_cl_smoothgrow") then
		Plant.LastProgress = Lerp(FrameTime() * 0.5,Plant.LastProgress or 0,Plant:GetGrowProgress())
		zgo2.Plant.UpdateModel(Plant)
	end
end

function zgo2.Plant.OnThink(Plant)

	if not LocalPlayer().zgo2_Initialized then return end

	if zgo2.Plant.List[Plant] == nil then
		zgo2.Plant.List[Plant] = true
	end

	if zgo2.Plant.UpdateMaterials[Plant] == nil then
		zgo2.Plant.UpdateMaterials[Plant] = true
	end

	if not zclib.Convar.GetBool("zgo2_cl_smoothgrow") then
		local g_progress = Plant:GetGrowProgress()
		if g_progress ~= Plant.LastProgress then
			Plant.LastProgress = g_progress
			zgo2.Plant.UpdateModel(Plant)
		end
	end
end

function zgo2.Plant.OnRemove(Plant)
	if Plant.SmokeEmitter and Plant.SmokeEmitter:IsValid() then
		Plant.SmokeEmitter:Finish()
		Plant.SmokeEmitter = nil
	end
end

local DriedMDLs = {
	[ "models/zerochain/props_growop2/zgo2_jar.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_weedseeds.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_weedcruncher.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_weedpacker.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_weedblock.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_doobytable.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_baggy.mdl" ] = true,

	[ "models/zerochain/props_growop2/zgo2_mixerbowl.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_mixer.mdl" ] = true,
}
for k,v in pairs(zgo2.config.Edibles) do DriedMDLs[v.edible_model] = true end
function zgo2.Plant.IsDried(ent)
	if ent.Dried then return ent.Dried end
	if ent.GetIsDried then return ent:GetIsDried() end
	return DriedMDLs[ent:GetModel()] == true
end

function zgo2.Plant.GetWeedID(ent)
	if ent.GetPlantID then return ent:GetPlantID() end
	if ent.GetWeedID then return ent:GetWeedID() end
	if IsValid(ent.Plant) then return ent.Plant:GetPlantID() end
	if ent.WeedID then return ent.WeedID end
	return 0
end

function zgo2.Plant.PreDraw()
	if not LocalPlayer().zgo2_Initialized then return end
    for ent,_ in pairs(zgo2.Plant.UpdateMaterials) do
        if not IsValid(ent) then
			continue
		end

		if not ent.m_Initialized then continue end

        // If we cant see the Plant then skip
        if zclib.util.IsInsideViewCone(ent:GetPos(),EyePos(),EyeAngles(),1000,2000) == false then
			ent.UpdatedPlant_material = nil
            continue
        end

		if ent.UpdatedPlant_material == nil then

			// Check if the weed entity is dried
			local IsDried = zgo2.Plant.IsDried(ent)

			// Get the weed entities weed id
			local PlantData = zgo2.Plant.GetData(zgo2.Plant.GetWeedID(ent))
			if not PlantData then continue end

			// Creates / Updates the plants lua materials
			zgo2.Plant.UpdateMaterial(ent,PlantData,nil,IsDried)

			ent.UpdatedPlant_material = true
		end
    end
end
zclib.Hook.Remove("PreDrawHUD", "zgo2_plant_draw")
zclib.Hook.Add("PreDrawHUD", "zgo2_plant_draw", zgo2.Plant.PreDraw)

/*
	Handels the jiggle logic
*/
function zgo2.Plant.Jiggle(ent)
	ent.JiggleStrength = math.Clamp((ent.JiggleStrength or 0) - (0.6 * FrameTime()),0,9999)

	local stre = ent.JiggleStrength

	local limit = 2

	local deg = limit * stre
	local speed = math.sin(20 * stre)

	/*
	TODO This would try to get the direction from the object that collided with the plant and calculates how the plant needs to jiggle
	if ent.JiggleDirection == nil then ent.JiggleDirection = Vector(0,0,0) end
	local ang = ent.JiggleDirection:Angle()
	ang = ent:WorldToLocalAngles(ang)
	ang = Angle(math.Clamp(ang.p * stre,-limit,limit),math.Clamp(ang.y * stre,-limit,limit),math.Clamp(ang.r * stre,-limit,limit))

	ent:ManipulateBoneAngles( 0, ang * speed )
	*/

	ent:ManipulateBoneAngles(0, Angle(deg * speed, deg * speed, deg * speed))
end

function zgo2.Plant.Logic()
    for ent,_ in pairs(zgo2.Plant.List) do
        if not IsValid(ent) then
			continue
		end

		if not ent.m_Initialized then continue end

		// Handels the skank effect
		zgo2.Plant.Skank(ent)

        // If we cant see the Plant then skip
        if zclib.util.IsInsideViewCone(ent:GetPos(),EyePos(),EyeAngles(),1000,2000) == false then
			ent.UpdatedPlant_model = nil
            continue
        end

		if ent.UpdatedPlant_model == nil then

			// Creates / Updates the plants model
			zgo2.Plant.UpdateModel(ent)

			ent.UpdatedPlant_model = true
		end

		// Handels the jiggle logic
		zgo2.Plant.Jiggle(ent)
    end
end
zclib.Hook.Remove("Think", "zgo2_plant_logic")
zclib.Hook.Add("Think", "zgo2_plant_logic", zgo2.Plant.Logic)

local vec01 = Vector(0, 0, 25)
local vec02  = Vector(0, 0, 5)
function zgo2.Plant.Skank(Plant)

	if zclib.util.InDistance(Plant:GetPos(), LocalPlayer():GetPos(), 1000) == false or not zclib.Convar.GetBool("zgo2_cl_drawskank") then
		if Plant.SmokeEmitter and Plant.SmokeEmitter:IsValid() then
			Plant.SmokeEmitter:Finish()
			Plant.SmokeEmitter = nil
		end
		return
	end

	local WeedID = Plant:GetPlantID()
	local PlantData = zgo2.Plant.GetData(WeedID)
	if not PlantData then return end

	local _,height = zgo2.Plant.GetFinalSize(Plant,PlantData)

	local pos = Plant:LocalToWorld((Plant:OBBCenter() - vec01) * height)

	local GrowProgress = Plant:GetGrowProgress()
	if GrowProgress < zgo2.Plant.GetGrowTime(WeedID,Plant) then return end

	if Plant.NextSmokeEmit and CurTime() < Plant.NextSmokeEmit then return end
	Plant.NextSmokeEmit = CurTime() + math.Rand(0.7,1)

	if not Plant.SmokeEmitter or not Plant.SmokeEmitter:IsValid() then Plant.SmokeEmitter = ParticleEmitter( pos , false ) end

	local col = zgo2.Plant.GetColor(WeedID)

	local h = ColorToHSV(col)
	col = HSVToColor(h,0.5,1)

	local PotScale = 1
	if IsValid(Plant:GetParent()) then PotScale = Plant:GetParent():GetModelScale() end
	local scale = (PlantData.style.scale * PotScale)

	local particle = Plant.SmokeEmitter:Add("zerochain/zgo2/particle/skankcloud", pos)
	particle:SetVelocity(Plant:GetUp() * 15)
	particle:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
	particle:SetDieTime(math.random(2, 9))
	particle:SetStartAlpha(50)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(15, 25) * scale)
	particle:SetEndSize(math.random(45, 50) * scale)
	particle:SetColor(col.r, col.g, col.b)
	particle:SetGravity(vec02)
	particle:SetAirResistance(55)
end
