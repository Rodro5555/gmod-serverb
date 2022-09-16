zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

/*

    This system creates the custom Plant lua material

*/


/*
	Gets the pattern data
*/
local function GetPattern(id)
	return zgo2.Plant.Patterns[id]
end

local function BuildMateralString(Part, UniqueID, IsEditor, IsDried)
	local str = "zgo2_plant_" .. Part

	if IsDried then
		str = str .. "_dried"
	end

	if IsEditor then
		str = str .. "_editor"
	else
		str = str .. "_" .. UniqueID
	end

	return str
end

/*
	Rebuilds / Updates all materials which are used for this plant
*/
function zgo2.Plant.RebuildMaterial(PlantData,IsEditor,IsDried)
	zgo2.Plant.GetMaterial("stem",BuildMateralString("stem", PlantData.uniqueid, IsEditor, IsDried), "Opaque", PlantData.style.stem,IsDried)
	zgo2.Plant.GetMaterial("leaf01",BuildMateralString("leaf01", PlantData.uniqueid, IsEditor, IsDried), "Alphatest", PlantData.style.leaf01,IsDried)
	zgo2.Plant.GetMaterial("leaf02",BuildMateralString("leaf02", PlantData.uniqueid, IsEditor, IsDried), "Alphatest", PlantData.style.leaf02,IsDried)
	zgo2.Plant.GetMaterial("bud",BuildMateralString("bud", PlantData.uniqueid, IsEditor, IsDried), "Opaque", PlantData.style.bud,IsDried)
	zgo2.Plant.GetMaterial("hair",BuildMateralString("hair", PlantData.uniqueid, IsEditor, IsDried), "Translucent", PlantData.style.hair,IsDried)
end

/*
	Update the plants material
*/
local function FindMaterialIDByName(ent,name)
	local id
	for k,v in pairs(ent:GetMaterials()) do
		local _,ePos = string.find(v,name)
		if ePos and ePos >= string.len(v) then
			id = k - 1
			break
		end
	end
	return id
end
function zgo2.Plant.UpdateMaterial(Plant,PlantData,IsEditor,IsDried)
	if not IsValid(Plant) then return end
	if not PlantData then return end

	// PrintTable(Plant:GetMaterials())

	local stem_id = FindMaterialIDByName(Plant,"plant/zgo2_stem")
	if stem_id then Plant:SetSubMaterial(stem_id, "!" .. BuildMateralString("stem", PlantData.uniqueid, IsEditor, IsDried)) end

	local leaf01_id = FindMaterialIDByName(Plant,"plant/zgo2_leaf")
	if leaf01_id then Plant:SetSubMaterial(leaf01_id, "!" .. BuildMateralString("leaf01", PlantData.uniqueid, IsEditor, IsDried)) end

	local leaf02_id = FindMaterialIDByName(Plant,"plant/zgo2_leaf02")
	if leaf02_id then Plant:SetSubMaterial(leaf02_id, "!" .. BuildMateralString("leaf02", PlantData.uniqueid, IsEditor, IsDried)) end

	local bud_id = FindMaterialIDByName(Plant,"plant/zgo2_bud")

	if bud_id then Plant:SetSubMaterial(bud_id, "!" .. BuildMateralString("bud", PlantData.uniqueid, IsEditor, IsDried)) end

	local hair_id = FindMaterialIDByName(Plant,"plant/zgo2_hair")
	if hair_id then Plant:SetSubMaterial(hair_id, "!" .. BuildMateralString("hair", PlantData.uniqueid, IsEditor, IsDried)) end
end

/*
	Creates / Caches / Updates the final lua material
*/
local MaterialTypes = {
	["Opaque"] = {
		material = {
			["$basetexture"] = "",
			["$halflambert"] = 1,
			["$model"] = 1,
			["$nodecal"] = 1,
		},

		// $model + $nodecal + $halflambert
		flags = 2048 + 67108864 + 134217728
	},
	["Alphatest"] = {
		material = {
			["$basetexture"] = "",
			["$halflambert"] = 1,
			["$model"] = 1,
			["$nodecal"] = 1,
			["$nocull"] = 1,

			["$alphatest"] = 1,
			// NOTE The image might look smoother if we just use the allowalphatocoverage instead of alphatestreference
			//["$alphatestreference"] = 0.5,
			["$allowalphatocoverage"] = 1
		},

		// $model + $nodecal  + $nocull + $alphatest
		flags = 2048 + 67108864 + 134217728 + 8192 + 256,

		["$alphatestreference"] = 0.2,
	},
	["Translucent"] = {
		material = {
			["$basetexture"] = "",
			["$halflambert"] = 1,
			["$model"] = 1,
			["$nodecal"] = 1,
			["$nocull"] = 1,

			["$translucent"] = 1,
		},

		// $model + $nodecal + $halflambert + $nocull + $translucent
		flags = 2048 + 67108864 + 134217728 + 8192 + 2097152,

		ReapplyMask = true,
	},
}
function zgo2.Plant.GetMaterialBase(MaterialType) return MaterialTypes[MaterialType] end

local function GetDryColor(PlantPart,IsDried,col)
	if IsDried then
		// For the dried weed color we just decrease the saturation a bit and increase its brightness
		local h,s,v = ColorToHSV(col)
		if PlantPart == "bud" then
			return HSVToColor(h, math.Clamp(s * 1.05,0,1), math.Clamp(v * 1.05,0,1))
		else
			return col//HSVToColor(h, s * 0.75, v * 0.7)
		end
	else
		return col
	end
end

zgo2.Plant.CachedMaterials = {}
function zgo2.Plant.GetMaterial(PlantPart,MatID, MaterialType,MaterialData,IsDried)
	local m_material

	// Get the material base
	local MaterialBase = zgo2.Plant.GetMaterialBase(MaterialType)

	// Create / Cache the material
	if zgo2.Plant.CachedMaterials[MatID] == nil then
		local matData = {}
		table.Merge(matData,MaterialBase.material)
		// 229407176

		if not IsDried then
			table.Merge(matData, {
				[ "$treeSway" ] = 1,

				[ "$treeSwayStartHeight" ] = 0,
				[ "$treeSwayHeight" ] = 300,

				[ "$treeSwayStartRadius" ] = 0,
				[ "$treeSwayRadius" ] = 300,

				[ "$treeSwaySpeed" ] = 0.5,
				[ "$treeSwayStrength" ] = 1,
				[ "$treeSwayFalloffExp" ] = 0.8,

				[ "$treeSwayScrumbleSpeed" ] = 0.8,
				[ "$treeSwayScrumbleStrength" ] = 2,
				[ "$treeSwayScrumbleFrequency" ] = 5,
				[ "$treeSwayScrumbleFalloffExp" ] = 0.8,

				[ "$treeSwaySpeedHighWindMultiplier" ] = 1,
				[ "$treeSwaySpeedLerpStart" ] = 3,
				[ "$treeSwaySpeedLerpEnd" ] = 6,

				[ "$treeswaystatic" ] = 1,
			})
		end

		// Add some noise for increased detail
		table.Merge(matData, {
			[ "$detail" ] = "zerochain/zgo2/noise02",
			[ "$detailscale" ] = 10,
			[ "$detailblendfactor" ] = 0.5,
			[ "$detailblendmode" ] = 0,
			[ "$vertexcolor" ] = 1,
		})

		zgo2.Plant.CachedMaterials[MatID] = CreateMaterial(MatID, "VertexLitGeneric", matData)
	end

	m_material = zgo2.Plant.CachedMaterials[MatID]

	// Set the material flags
	m_material:SetInt("$flags", MaterialBase.flags )

	// Set the alpha reference if available
	if MaterialBase["$alphatestreference"] then m_material:SetFloat("$alphatestreference", MaterialBase["$alphatestreference"]) end

	local base_target = zgo2.util.PushTexture(0,0,0,255,MatID,function()
		local w,h = ScrW(), ScrH()

		zgo2.Plant.DrawTexture(w, h, MaterialData.pattern_id, MaterialData.texture, GetDryColor(PlantPart,IsDried,MaterialData.color01), GetDryColor(PlantPart,IsDried,MaterialData.color02),MaterialData.x, MaterialData.y)

		// Adds the ALPHA channel of the base texture over it again
		if MaterialBase.ReapplyMask then

			local BaseTexMat = zgo2.Plant.GetTextureMaterial(MaterialData.texture)
			if not BaseTexMat then return end

			zclib.Blendmodes.Blend("Additive",false,function()
				surface.SetDrawColor(GetDryColor(PlantPart,IsDried,MaterialData.color01))
				surface.SetMaterial(BaseTexMat)
				surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)
			end)
		end
	end)
	m_material:SetTexture("$basetexture", base_target)

	// Refresh the material
	m_material:Recompute()

	return m_material
end

/*
	Creates / Caches the base diffuse map as lua material and also its color mask png
*/
local CachedTextureMaterials = {}
function zgo2.Plant.GetTextureMaterial(imgpath)
	if CachedTextureMaterials[imgpath] == nil then CachedTextureMaterials[imgpath] = Material(imgpath .. ".png","ignorez smooth") end
	return CachedTextureMaterials[imgpath]
end

/*
	Draws the final texture using multiply blend modes and gradients
*/
function zgo2.Plant.DrawTexture(w, h, pattern_id,Image, color01, color02 ,xPos,yPos)
	local BaseTexMat = zgo2.Plant.GetTextureMaterial(Image)
	if not BaseTexMat then return end

	local pattern = GetPattern(pattern_id)

	local x, y = xPos or 0, yPos or 0
	local u0, v0 = 0 + x, 0 + y
	local u1, v1 = 1 + x, 1 + y

	// BASE
	zclib.Blendmodes.Blend("Additive",false,function()
		surface.SetDrawColor(color_white)
		surface.SetMaterial(BaseTexMat)
		surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)
	end)

	// Gradient END
	zclib.Blendmodes.Blend("Multiply",true,function()
		surface.SetDrawColor(color02)
		surface.SetMaterial(pattern.bottom)
		surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)

		surface.SetDrawColor(color01)
		surface.SetMaterial(pattern.top)
		surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
	end)
end
