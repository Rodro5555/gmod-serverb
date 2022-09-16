zgo2 = zgo2 or {}
zgo2.Seed = zgo2.Seed or {}
zgo2.Seed.List = zgo2.Seed.List or {}

/*
	Rebuilds / Updates all materials which are used for this plant
*/

function zgo2.Seed.RebuildMaterial(PlantData,IsEditor)
	zgo2.Seed.GetMaterial("zgo2_seedbox_" .. (IsEditor and "editor" or PlantData.uniqueid), PlantData)
end

function zgo2.Seed.UpdateMaterial(SeedBox,PlantData,IsEditor)
	if not IsValid(SeedBox) then return end

	zgo2.Seed.RebuildMaterial(PlantData,IsEditor)

	SeedBox:SetSubMaterial(0, "!zgo2_seedbox_" .. (IsEditor and "editor" or PlantData.uniqueid))

	local bud_mat
	if IsEditor then
		bud_mat = "!zgo2_plant_bud_editor"
	else
		bud_mat = "!zgo2_plant_bud_dried_" .. PlantData.uniqueid
	end
	SeedBox:SetSubMaterial(2, bud_mat)
end

zgo2.Seed.CachedMaterials = {}
function zgo2.Seed.GetMaterial(MatID,PlantData)
	local m_material

	// Create / Cache the material
	if zgo2.Seed.CachedMaterials[MatID] == nil then

		local matData = {
			[ "$basetexture" ] = "",
			[ "$halflambert" ] = 1,
			[ "$model" ] = 1,
			[ "$nodecal" ] = 1,
			[ "$detail" ] = "zerochain/zgo2/noise02",
			[ "$detailscale" ] = 10,
			[ "$detailblendfactor" ] = 0.5,
			[ "$detailblendmode" ] = 0,
			//[ "$vertexcolor" ] = 1,

			["$bumpmap"] = "zerochain/props_growop2/seedbox/zgo2_seeds_nrm",
			["$normalmapalphaenvmapmask"] = 1,

			["$envmap"] = "env_cubemap",
			["$envmaptint"] = "[1 1 1]",
			["$envmapfresnel"] = 1,

			["$phong"] = 1,
			["$phongexponent"] = 3,
			["$phongboost"] = 0.5,
			["$phongfresnelranges"] = "[1 1 1]",
			["$phongtint"] = "[1 1 1]",
		}

		zgo2.Seed.CachedMaterials[MatID] = CreateMaterial(MatID, "VertexLitGeneric", matData)
	end

	m_material = zgo2.Seed.CachedMaterials[MatID]

	local ImgurMat
	if PlantData.style.seedbox.imgur_url then
		zclib.Imgur.GetMaterial(tostring(PlantData.style.seedbox.imgur_url), function(result)
			if result then
				ImgurMat = result
			end
		end)
	end

	local base_target = zgo2.util.PushTexture(0,0,0,255,MatID,function()
		zgo2.Seed.DrawTexture(ScrW(), ScrH(), PlantData,ImgurMat)
	end)
	m_material:SetTexture("$basetexture", base_target)

	m_material:SetInt("$halflambert", 1)
	m_material:SetInt("$model", 1)

	m_material:SetTexture("$bumpmap", "zerochain/props_growop2/seedbox/zgo2_seeds_nrm")
	m_material:SetInt("$normalmapalphaenvmapmask", 1)

	/////////////////
	local v_spec_color = zclib.util.ColorToVector(PlantData.style.seedbox.phongtint)
	v_spec_color = Vector(v_spec_color.x * PlantData.style.seedbox.fresnel,v_spec_color.y * PlantData.style.seedbox.fresnel,v_spec_color.z * PlantData.style.seedbox.fresnel)

	m_material:SetInt("$phong", 1)
	m_material:SetFloat("$phongexponent", PlantData.style.seedbox.phongexponent)
	m_material:SetFloat("$phongboost", PlantData.style.seedbox.phongboost)
	m_material:SetVector("$phongfresnelranges", Vector(1 * PlantData.style.seedbox.fresnel, 4 * PlantData.style.seedbox.fresnel, 6 * PlantData.style.seedbox.fresnel))
	m_material:SetVector("$phongtint", v_spec_color)

	m_material:SetFloat("$alphatestreference",0.01)

	m_material:SetVector("$envmaptint", v_spec_color)
	m_material:SetFloat("$envmapfresnel", PlantData.style.seedbox.fresnel)
	m_material:SetFloat("$fresnelreflection", PlantData.style.seedbox.fresnel)
	m_material:SetVector("$envmapfresnelminmaxexp", Vector(1 * PlantData.style.seedbox.fresnel, 4 * PlantData.style.seedbox.fresnel, 6 * PlantData.style.seedbox.fresnel))

	/////////////////

	m_material:SetInt("$flags", 2048 + 4194304 + 16777216)

	// Refresh the material
	m_material:Recompute()

	return m_material
end

function zgo2.Seed.DrawImgur( w, h,PlantData, ImgurMat)
	local x, y = PlantData.style.seedbox.imgur_pos_x, PlantData.style.seedbox.imgur_pos_y
	local u0, v0 = 0 * PlantData.style.seedbox.imgur_scale + x, 0 * PlantData.style.seedbox.imgur_scale + y
	local u1, v1 = 1 * PlantData.style.seedbox.imgur_scale + x, 1 * PlantData.style.seedbox.imgur_scale + y
	surface.SetDrawColor(PlantData.style.seedbox.imgur_color)
	surface.SetMaterial(ImgurMat)
	surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
end

/*
	Draws the final texture using multiply blend modes and gradients
*/
local BaseMat = Material("zerochain/props_growop2/seedbox/zgo2_seedbox_design.png","smooth")
function zgo2.Seed.DrawTexture(w, h, PlantData,ImgurMat)

	// BASE
	surface.SetDrawColor(PlantData.style.seedbox.main_color)
	surface.SetMaterial(BaseMat)
	surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)

	if ImgurMat then

		if PlantData.style.seedbox.imgur_blendmode == 0 then
			// Dont blend
			zgo2.Seed.DrawImgur(w, h, PlantData, ImgurMat)
		else
			// Blend according to mode
			zclib.Blendmodes.Blend(PlantData.style.seedbox.imgur_blendmode,false,function()
				zgo2.Seed.DrawImgur(w, h, PlantData, ImgurMat)
			end)
		end
	end

	if PlantData.style.seedbox.title_enabled then
		draw.SimpleText(PlantData.name, PlantData.style.seedbox.title_font, w * PlantData.style.seedbox.title_pos_x, h * PlantData.style.seedbox.title_pos_y, PlantData.style.seedbox.title_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function zgo2.Seed.PreDraw()
	if not LocalPlayer().zgo2_Initialized then return end
    for ent,_ in pairs(zgo2.Seed.List) do
        if not IsValid(ent) then
			continue
		end

		if not ent.Initialized then continue end

        // If we cant see the Seed then skip
        if zclib.util.IsInsideViewCone(ent:GetPos(),EyePos(),EyeAngles(),1000,2000) == false then
			ent.UpdatedSeed_material = nil
            continue
        end

		if ent.UpdatedSeed_material == nil then

			// Get the weed entities weed id
			local PlantData = zgo2.Plant.GetData(ent:GetPlantID())
			if not PlantData then continue end

			// Creates / Updates the plants lua materials
			zgo2.Seed.UpdateMaterial(ent,PlantData,false)

			ent.UpdatedSeed_material = true
		end
    end
end
zclib.Hook.Remove("PreDrawHUD", "zgo2_Seed_draw")
zclib.Hook.Add("PreDrawHUD", "zgo2_Seed_draw", function() zgo2.Seed.PreDraw() end)
