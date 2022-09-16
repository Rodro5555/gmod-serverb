
game.AddParticles("particles/zgo2_water_vfx.pcf")
PrecacheParticleSystem("zgo2_water_tail")
PrecacheParticleSystem("zgo2_water_explosion")

game.AddParticles("particles/zgo2_dirt_vfx.pcf")
PrecacheParticleSystem("zgo2_dirt_fill")
PrecacheParticleSystem("zgo2_dirt_explo")

game.AddParticles("particles/zgo2_bong_vfx.pcf")
PrecacheParticleSystem("zgo2_vm_fire")
PrecacheParticleSystem("zgo2_ent_fire")

game.AddParticles("particles/zgo2_lighter_vfx.pcf")
PrecacheParticleSystem("zgo2_lighter_flame")

game.AddParticles("particles/zgo2_buy_vfx.pcf")
PrecacheParticleSystem("zgo2_buy")

game.AddParticles("particles/zgo2_generator_vfx.pcf")
PrecacheParticleSystem("zgo2_damaged")
PrecacheParticleSystem("zgo2_exaust")
PrecacheParticleSystem("zgo2_electro")

game.AddParticles("particles/zgo2_splice_vfx.pcf")
PrecacheParticleSystem("zgo2_scan")

timer.Simple(1,function()

	zclib.CacheModel("models/zerochain/props_growop2/zgo2_lightray01.mdl")

	for k,v in pairs(zgo2.Plant.Shapes) do zclib.CacheModel(v) end

	zclib.CacheModel("models/hunter/misc/sphere025x025.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_plant_root.mdl")

	zclib.CacheModel("models/zerochain/props_growop2/zgo2_photowall.mdl")

	zclib.CacheModel("models/zerochain/props_growop2/zgo2_weedstick.mdl")

	zclib.CacheModel("models/zerochain/props_growop2/zgo2_weedblock.mdl")

	/*
		Precache Shop Item Models
	*/
	for _, v in pairs(zgo2.Shop.List) do
		if v.items then
			for _, data in pairs(v.items) do
				if data and data.mdl then
					zclib.CacheModel(data.mdl)
				end
			end
		end
	end

	/*
		Precache Bong Models
	*/
	for k,v in pairs(zgo2.Bong.Types) do
		zclib.CacheModel(v.wm)
	end

	// Precache any model which is used in the cargo Thumbnail for the Snapshoter system
	for k,v in pairs(zgo2.Cargo.List) do
		if v and v.GetThumbnailData then
			local dat = v.GetThumbnailData()
			if dat and dat.model then
				zclib.CacheModel(dat.model)
			end
		end
	end

	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break01.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break02.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break03.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break04.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break05.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break06.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break07.mdl")
	zclib.CacheModel("models/zerochain/props_growop2/zgo2_doobytable_break08.mdl")
end)
