
/*

	The plant images

*/
zclib.RenderData.Add("zgo2_plant", {
	ang = Angle(0, 0, 0),
	FOV = 10,
	CamPosOverwrite = Vector(-1200, 0, 50),
	EyeAngOverwrite = Angle(0, 0, 0),
})
if CLIENT then

	zclib.Snapshoter.SetPath("zgo2_plant",function(ItemData)
		if ItemData.PlantID then
			return "zgo2/plant_" .. ItemData.PlantID
		end
	end)

	zclib.Hook.Add("zclib_Snapshoter_Overwrite_FOV","zclib_Snapshoter_Overwrite_FOV_ZerosGrowOP2", function( ItemData)
		if ItemData and ItemData.class == "zgo2_plant" and ItemData.PlantID then
			return 12
		end
	end)

	zclib.Hook.Add("zclib_Snapshoter_Overwrite_CamPos","zclib_Snapshoter_Overwrite_CamPos_ZerosGrowOP2", function( ItemData)
		if ItemData and ItemData.class == "zgo2_plant" and ItemData.PlantID then
			return Vector(-700, 0,55 )
		end
	end)

	zclib.Hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosGrowOP2_Plant", function(PlantRoot, ItemData)
		if ItemData and ItemData.class == "zgo2_plant" and ItemData.PlantID then

			local PlantData = zgo2.Plant.GetData(ItemData.PlantID)

			PlantRoot.IsEditor = true

			// Update the plants root model
			zgo2.Plant.Update(PlantRoot,PlantData,1)

			// Draw pot
			if not IsValid(PlantRoot.PotModel) then
				PlantRoot.PotModel = zclib.ClientModel.Add("models/zerochain/props_growop2/zgo2_pot01.mdl", RENDERGROUP_OTHER)
				PlantRoot.PotModel:SetLOD( 0 )
				PlantRoot.PotModel:SetBodygroup(1,1)
				PlantRoot.PotModel:SetSkin(1)
			end
			if IsValid(PlantRoot.PotModel) then
				render.Model({
					model = PlantRoot.PotModel:GetModel(),
					pos = Vector(0,0,-15),
					angle = Angle(0,0,0)
				}, PlantRoot.PotModel)
			end

			// Apply the plant material
			zgo2.Plant.UpdateMaterial(PlantRoot, PlantData)

			// Remove any existing 3d models
			PlantRoot:CallOnRemove("zgo2_plant_mat_" .. ItemData.PlantID, function(ent)
				if IsValid(PlantRoot.PotModel) then PlantRoot.PotModel:Remove() end
			end)
		end
	end)
end

/*

	The jar images

*/
zclib.RenderData.Add("zgo2_jar", {
	ang = Angle(0, 0, 0),
	FOV = 11,
})
if CLIENT then

	zclib.Snapshoter.SetPath("zgo2_jar",function(ItemData)
		if ItemData.PlantID then
			return "zgo2/jar_" .. ItemData.PlantID
		end
	end)

	zclib.Hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosGrowOP2_Jar", function(JarEntity, ItemData)
		if ItemData and ItemData.class == "zgo2_jar" and ItemData.PlantID then
			JarEntity:SetBodygroup(0, 1)
			JarEntity:SetBodygroup(1, 1)
			JarEntity:SetBodygroup(2, 1)
			JarEntity:SetBodygroup(3, 1)
			JarEntity:SetBodygroup(4, 1)
			zgo2.Plant.UpdateMaterial(JarEntity, zgo2.Plant.GetData(ItemData.PlantID))
		end
	end)
end


/*

	The jar images

*/
zclib.RenderData.Add("zgo2_weedblock", {
	ang = Angle(0, 0, 0),
	FOV = 11,
})
if CLIENT then

	zclib.Snapshoter.SetPath("zgo2_weedblock",function(ItemData)
		if ItemData.PlantID then
			return "zgo2/weedblock_" .. ItemData.PlantID
		end
	end)

	zclib.Hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosGrowOP2_Weedblock", function(JarEntity, ItemData)
		if ItemData and ItemData.class == "zgo2_weedblock" and ItemData.PlantID then
			zgo2.Plant.UpdateMaterial(JarEntity, zgo2.Plant.GetData(ItemData.PlantID))
		end
	end)
end

/*

	The bong images

*/
zclib.RenderData.Add("zgo2_bong", {
	ang = Angle(0, 45, 0),
	FOV = 11,
})
if CLIENT then

	zclib.Snapshoter.SetPath("zgo2_bong",function(ItemData)
		if ItemData.BongID then
			return "zgo2/bong_" .. ItemData.BongID
		end
	end)

	zclib.Hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosGrowOP2_Bong", function(BongEntity, ItemData)
		if ItemData and ItemData.class == "zgo2_bong" and ItemData.BongID then
			zgo2.Bong.ApplyMaterial(BongEntity,zgo2.Bong.GetData(ItemData.BongID))
		end
	end)
	zclib.Hook.Add("zclib_PreRenderStartProductImage", "zclib_PreRenderStartProductImage_ZerosGrowOP2_Bong", function(ItemData)
		if ItemData and ItemData.class == "zgo2_bong" and ItemData.BongID then
			zgo2.Bong.RebuildMaterial(zgo2.Bong.GetData(ItemData.BongID))
		end
	end)
end

/*

	The pot images

*/
zclib.RenderData.Add("zgo2_pot", {
	ang = Angle(0, 180, 0),
	FOV = 10,
})
if CLIENT then

	zclib.Snapshoter.SetPath("zgo2_pot",function(ItemData)
		if ItemData.PotID then
			return "zgo2/pot_" .. ItemData.PotID
		end
	end)

	zclib.Hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosGrowOP2_Pot", function(PotEntity, ItemData)
		if ItemData and ItemData.class == "zgo2_pot" and ItemData.PotID then
			local data = zgo2.Pot.GetData(ItemData.PotID)

			if data then
				PotEntity:SetModelScale(data.scale or 1, 0)

				if data.hose then
					PotEntity:SetBodygroup(2, 1)
				end

				zgo2.Pot.ApplyMaterial(PotEntity, data)
			end
		end
	end)

	zclib.Hook.Add("zclib_PreRenderStartProductImage", "zclib_PreRenderStartProductImage_ZerosGrowOP2_Pot", function(ItemData)
		if ItemData and ItemData.class == "zgo2_pot" and ItemData.PotID then
			zgo2.Pot.RebuildMaterial(zgo2.Pot.GetData(ItemData.PotID))
		end
	end)
end


zclib.RenderData.Add("zgo2_backmix", {
	ang = Angle(0, 180, 0),
	FOV = 10,
})

zclib.RenderData.Add("zgo2_mixer", {
	ang = Angle(0, -90, 0),
	FOV = 10,
})

zclib.RenderData.Add("zgo2_doobytable", {
	ang = Angle(0, 180, 0),
	FOV = 10,
})

zclib.RenderData.Add("zgo2_oven", {
	ang = Angle(0, -90, 0),
	FOV = 10,
})

zclib.RenderData.Add("zgo2_splicer", {
	ang = Angle(0, -90, 0),
	FOV = 10,
})
