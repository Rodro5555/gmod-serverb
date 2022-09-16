zgo2 = zgo2 or {}
zgo2.Destruction = zgo2.Destruction or {}

/*
	NOTE This system handels the destruction of objects
*/

zgo2.Destruction.Effects = {}

local offset = Vector(0, 0, 150)
local function ShootGibs(force,OnCatched)
	// Its a bit of a hacky way todo it but thats how we apply the lua material on the gibs models
	for k,v in pairs(ents.FindByClass("class C_PhysPropClientside")) do
		if not IsValid(v) then continue end

		// Stop if this one already got a material assigned
		if v.zgo2_GibUpdated then continue end

		if not OnCatched(v) then continue end

		v.zgo2_GibUpdated = true

		local phy = v:GetPhysicsObject()
		if IsValid(phy) then
			phy:SetMaterial( "gmod_silent" )
			phy:SetVelocityInstantaneous((VectorRand(-150, 150) + offset) * force)
			phy:SetAngleVelocityInstantaneous(VectorRand(-500, 500) * force)
		end
	end
end

local function GibWeed(PlantID,pos,scale)
	local dat = zgo2.Plant.GetData(PlantID)
	ShootGibs(1,function(ent)

		// Check if the C_PhysPropClientside is even from the plant model
		if not zclib.util.InDistance(ent:GetPos(), pos, 200) then return false end

		zgo2.Plant.UpdateMaterial(ent,dat,false,true)
		ent:SetModelScale(scale,0)

		return true
	end)
end

local WeedJunks = {
	[ "models/zerochain/props_growop2/zgo2_jar_break01.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_jar_break02.mdl" ] = true,

	[ "models/zerochain/props_growop2/zgo2_doobytable_break02.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_doobytable_break03.mdl" ] = true,
	[ "models/zerochain/props_growop2/zgo2_doobytable_break04.mdl" ] = true,
}
local function GibJar(PlantID,pos,IsEmpty)
	local dat = zgo2.Plant.GetData(PlantID)
	ShootGibs(1,function(ent)

		// Check if the C_PhysPropClientside is even from the plant model
		if not zclib.util.InDistance(ent:GetPos(), pos, 200) then return false end

		// If the jar was empty then quick remove the weed junk entity
		if IsEmpty and WeedJunks[ ent:GetModel() ] then
			ent:Remove()
			return false
		end

		zgo2.Plant.UpdateMaterial(ent,dat,false,true)

		return true
	end)
end

local function GibPot(PotID,pos,scale)
	local dat = zgo2.Pot.GetData(PotID)
	ShootGibs(1,function(ent)

		if not string.find(ent:GetModel(),"models/zerochain/props_growop2/zgo2_pot") then return false end

		// If the jar was empty then quick remove the weed junk entity
		if IsEmpty and WeedJunks[ ent:GetModel() ] then
			ent:Remove()
			return false
		end

		ent:SetModelScale(scale,0)
		zgo2.Pot.ApplyMaterial(ent,dat,false)

		return true
	end)
end

zgo2.Destruction.Effects["zgo2_plant"] = function(ent)

	if SERVER then
		zclib.NetEvent.Create("zgo2_plant_leafexplode", { ent:GetPos(), ent:GetPlantID(), 600 })
		zgo2.Pot.Reset(ent:GetParent())
	else

		ent:GibBreakClient(vector_origin)

		GibWeed(ent:GetPlantID(),ent:GetPos(),ent:GetModelScale())
	end
end

zgo2.Destruction.Effects["zgo2_weedbranch"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		GibWeed(ent:GetPlantID(),ent:GetPos(),1)

		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_cut")

		local PlantData = zgo2.Plant.GetData(ent:GetPlantID())
		if not PlantData then return end

		zgo2.util.ParticleExplosion(ent:GetPos(),3,10,1,function()
			return "!zgo2_plant_leaf0" .. math.random(1, 2) .. "_dried_" .. PlantData.uniqueid
		end)

		zgo2.util.ParticleExplosion(ent:GetPos(),3,10,1,function()
			return "!zgo2_plant_hair_dried_" .. PlantData.uniqueid
		end)
	end
end

zgo2.Destruction.Effects["zgo2_weedblock"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		GibWeed(ent:GetWeedID(),ent:GetPos(),1)

		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_cut")

		local PlantData = zgo2.Plant.GetData(ent:GetWeedID())
		if not PlantData then return end

		zgo2.util.ParticleExplosion(ent:GetPos(),3,10,1,function()
			return "!zgo2_plant_leaf0" .. math.random(1, 2) .. "_dried_" .. PlantData.uniqueid
		end)

		zgo2.util.ParticleExplosion(ent:GetPos(),3,10,1,function()
			return "!zgo2_plant_hair_dried_" .. PlantData.uniqueid
		end)
	end
end

zgo2.Destruction.Effects["zgo2_jar"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		GibJar(ent:GetWeedID(),ent:GetPos(),ent:GetWeedAmount() <= 0)

		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_cut")
	end
end

zgo2.Destruction.Effects["zgo2_pot"] = function(ent)

	if SERVER then
		local plant = ent:GetPlant()
		if IsValid(plant) then zclib.NetEvent.Create("zgo2_plant_leafexplode", { plant:GetPos(), plant:GetPlantID(), 600 }) end

		if ent:GetHasSoil() then
			zclib.NetEvent.Create("zgo2_pot_expodedirt", { ent:LocalToWorld(ent:OBBCenter()) })
		end
	else
		ent:GibBreakClient(vector_origin)

		GibPot(ent:GetPotID(),ent:GetPos(),ent:GetModelScale())

		local plant = ent:GetPlant()
		if IsValid(plant) then
			local effect = zgo2.Destruction.Effects[plant:GetClass()]
			if effect then effect(plant) end
		end
	end
end

zgo2.Destruction.Effects["zgo2_crate"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		ShootGibs(1,function(entity)

			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_crate") then return false end

			return true
		end)

		for k, data in pairs(ent.WeedBranches) do
			local PlantData = zgo2.Plant.GetData(data.id)
			if not PlantData then continue end
			zgo2.util.ParticleExplosion(ent:GetPos(), 3, 10, 1.5, function() return "!zgo2_plant_leaf0" .. math.random(1, 2) .. "_dried_" .. PlantData.uniqueid end)
			zgo2.util.ParticleExplosion(ent:GetPos(), 3, 10, 1.5, function() return "!zgo2_plant_hair_dried_" .. PlantData.uniqueid end)
		end
	end
end

zgo2.Destruction.Effects["zgo2_soil"] = function(ent)

	if CLIENT then
		zclib.Effect.ParticleEffect("zgo2_dirt_explo", ent:GetPos(), ent:GetAngles(), ent)
		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_dirt")
	end
end

zgo2.Destruction.Effects["zgo2_motor"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_motor") then return false end
			return true
		end)

		ent:EmitSound("zgo2_bulb_burnout")
		zclib.Effect.ParticleEffect("zgo2_electro", ent:GetPos(), ent:GetAngles(), nil)
	end
end

zgo2.Destruction.Effects["zgo2_jarcrate"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		ShootGibs(1,function(entity)

			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_jarcrate") then return false end

			return true
		end)
	else
		for k,v in pairs(ent.WeedList) do
			if not IsValid(v) then continue end
			zgo2.JarCrate.DropJar(ent, v,true)

			zgo2.Destruction.Destroy(v)
		end
	end
end

zgo2.Destruction.Effects["zgo2_fuel"] = function(ent)

	if SERVER then
		zclib.Effect.Generic("HelicopterMegaBomb",ent:GetPos())
		ent:EmitSound("ambient/fire/gascan_ignite1.wav")
	end
end

zgo2.Destruction.Effects["zgo2_bulb"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		ShootGibs(1,function(entity)

			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_bulb") then return false end

			return true
		end)
	end
end

zgo2.Destruction.Effects["zgo2_battery"] = function(ent)

	if CLIENT then
		ent:EmitSound("zgo2_bulb_burnout")
		zclib.Effect.ParticleEffect("zgo2_electro", ent:GetPos(), ent:GetAngles(), nil)
	end
end

zgo2.Destruction.Effects["zgo2_palette"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		ShootGibs(1,function(entity)

			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_palette") then return false end

			return true
		end)

		/*
		for k, id in pairs(ent.WeedList) do
			local PlantData = zgo2.Plant.GetData(id)
			if not PlantData then continue end
			zgo2.util.ParticleExplosion(ent:LocalToWorld(VectorRand(-50,50)), 3, 60, 1.5, function() return "!zgo2_plant_leaf0" .. math.random(1, 2) .. "_dried_" .. PlantData.uniqueid end)
			zgo2.util.ParticleExplosion(ent:LocalToWorld(VectorRand(-50,50)), 3, 60, 1.5, function() return "!zgo2_plant_hair_dried_" .. PlantData.uniqueid end)
		end
		*/
	else

		for k, id in pairs(ent.WeedList) do
			local PlantData = zgo2.Plant.GetData(id)
			if not PlantData then return end
			local aent = ents.Create("zgo2_weedblock")
			if not IsValid(aent) then return end
			aent:SetPos(ent:GetPos() + zclib.util.GetRandomPositionInsideCircle(0, 150, math.random(50)))
			aent:SetAngles(angle_zero)
			aent:Spawn()
			aent:Activate()
			aent:SetWeedID(id)
			timer.Simple(0.1,function()
				if IsValid(aent) then
					zgo2.Destruction.Destroy(aent)
				end
			end)
		end

	end
end

zgo2.Destruction.Effects["zgo2_bong"] = function(ent)

	if CLIENT then
		// TODO Add glass shatter particle effect
		/*
		ent:GibBreakClient(vector_origin)

		ShootGibs(10,function(entity)

			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_bong") then return false end

			return true
		end)
		*/
	end
end

zgo2.Destruction.Effects["zgo2_clipper"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_weedcruncher") then return false end
			return true
		end)

		ent:EmitSound("zgo2_bulb_burnout")
		zclib.Effect.ParticleEffect("zgo2_electro", ent:GetPos(), ent:GetAngles(), nil)
	end
end

zgo2.Destruction.Effects["zgo2_generator"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_generator") then return false end
			return true
		end)

		ent:EmitSound("zgo2_bulb_burnout")
		zclib.Effect.ParticleEffect("zgo2_electro", ent:GetPos(), ent:GetAngles(), nil)
	end
end

zgo2.Destruction.Effects["zgo2_tent"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_tent") then return false end
			return true
		end)
	end
end

zgo2.Destruction.Effects["zgo2_rack"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_rack") then return false end
			return true
		end)
	end
end

zgo2.Destruction.Effects["zgo2_pump"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_pump") then return false end
			return true
		end)

		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_water")
		zclib.Effect.ParticleEffect("zgo2_water_explosion", ent:LocalToWorld(ent:OBBCenter()), ent:GetAngles(), nil)
	end
end

zgo2.Destruction.Effects["zgo2_watertank"] = function(ent)

	if CLIENT then
		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_water")
		zclib.Effect.ParticleEffect("zgo2_water_explosion", ent:LocalToWorld(ent:OBBCenter()), ent:GetAngles(), nil)
	end
end

zgo2.Destruction.Effects["zgo2_packer"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"models/zerochain/props_growop2/zgo2_weedpacker") then return false end
			return true
		end)
	end
end

zgo2.Destruction.Effects["zgo2_lamp"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)
		ShootGibs(1,function(entity)
			if not string.find(entity:GetModel(),"_lamp") then return false end
			return true
		end)
	end
end

zgo2.Destruction.Effects["zgo2_doobytable"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		GibJar(ent:GetWeedID(),ent:GetPos(),ent:GetWeedAmount() <= 0)

		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_cut")
	end
end

zgo2.Destruction.Effects["zgo2_baggy"] = function(ent)

	if CLIENT then
		ent:GibBreakClient(vector_origin)

		GibJar(ent:GetWeedID(),ent:GetPos(),ent:GetWeedAmount() <= 0)

		zclib.Sound.EmitFromPosition(ent:GetPos(),"zgo2_plant_cut")
	end
end

if CLIENT then return end

/*
	Called on init to set the health
*/
function zgo2.Destruction.SetupHealth(ent)
	if not IsValid(ent) then return end
	local health = zgo2.config.Damageable[ent:GetClass()]
	if not health then return end
	if health <= 0 then return end

	health = health * ent:GetModelScale()

	ent:SetHealth(health)
	ent:SetMaxHealth(health)

	ent:PrecacheGibs()
end

/*
	Called when the entity gets damaged
*/
function zgo2.Destruction.OnDamaged(ent,dmginfo)
	if not IsValid(ent) then return end
	if not zgo2.config.Damageable[ent:GetClass()] then return end
	if zgo2.config.Damageable[ent:GetClass()] <= 0 then return end
	ent:SetHealth(ent:Health() - dmginfo:GetDamage())

	if ent:Health() <= 0 then
		zgo2.Destruction.Destroy(ent)
	end
end

/*
	Triggers the effects and removal of the object
*/
function zgo2.Destruction.Destroy(ent)
	if ent.Destroyed then return end
	ent.Destroyed = true

	zclib.NetEvent.Create("zgo2_destruction", {ent})

	local effect = zgo2.Destruction.Effects[ent:GetClass()]
	if effect then effect(ent) end

	zclib.Entity.SafeRemove(ent)
end
