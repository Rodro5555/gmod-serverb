zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}

local function GetMaterialName(PotData,IsEditor)
	return IsEditor and "zgo2_pot_editor" or "zgo2_pot_" .. PotData.uniqueid
end

local function FindMaterialIDByName(ent,name)
	local id
	for k,v in pairs(ent:GetMaterials()) do
		local _,ePos = string.find(v,name)
		if ePos then
			id = k - 1
			break
		end
	end
	return id
end

/*
	Rebuilds / Updates all materials which are used for this plant
*/
function zgo2.Pot.RebuildMaterial(PotData,IsEditor)
	zgo2.Pot.GetMaterial(PotData,GetMaterialName(PotData,IsEditor))
end

/*
	Update the plants material
*/
function zgo2.Pot.ApplyMaterial(Pot,PotData,IsEditor)
	if not IsValid(Pot) then return end

	Pot:SetSubMaterial(FindMaterialIDByName(Pot, "pots/zgo2_pot0"), "!" .. GetMaterialName(PotData, IsEditor))
end

/*
	Creates / Caches / Updates the final lua material
*/
zgo2.Pot.CachedMaterials = {}
function zgo2.Pot.GetMaterial(PotData,MatID)
	local m_material

	local PotMeshData = zgo2.Pot.Types[PotData.type]

	// Create / Cache the material
	if zgo2.Pot.CachedMaterials[MatID] == nil then
		zgo2.Print("Cached "..tostring(MatID))
		zgo2.Pot.CachedMaterials[MatID] = CreateMaterial(MatID, "VertexLitGeneric", {
			["$basetexture"] = "zerochain/props_growop2/pot/zgo2_pot",

			["$color2"] = "[1 1 1]",

			["$halflambert"] = 1,
			["$model"] = 1,
			["$nodecal"] = 1,
			["$surfaceprop"] = "glass",

			["$bumpmap"] = "null-bumpmap",
			["$normalmapalphaenvmapmask"] = 1,

			["$envmap"] = "env_cubemap",
			["$envmaptint"] = "[1 1 1]",
			["$envmapfresnel"] = 1,

			["$phong"] = 1,
			["$phongexponent"] = 15,
			["$phongboost"] = 0.5,
			["$phongfresnelranges"] = "[1 1 1]",
			["$phongtint"] = "[1 1 1]",
		})
	end
	m_material = zgo2.Pot.CachedMaterials[MatID]

	// Load imgur image
	if PotData.style.url then
		zclib.Imgur.GetMaterial(tostring(PotData.style.url), function(ImgurMat)
			local base_target = zgo2.util.PushTexture(0,0,0,255,MatID,function()
				local w,h = ScrW(), ScrH()
				zgo2.Pot.DrawTexture(w,h, PotData, ImgurMat)
			end)
			m_material:SetTexture("$basetexture", base_target)
		end)
	else
		local base_target = zgo2.util.PushTexture(0,0,0,255,MatID,function()
			local w,h = ScrW(), ScrH()
			zgo2.Pot.DrawTexture(w,h, PotData, nil)
		end)
		m_material:SetTexture("$basetexture", base_target)
	end


	m_material:SetVector("$color2", zclib.util.ColorToVector(PotData.style.color))

	m_material:SetInt("$halflambert", 1)
	m_material:SetInt("$model", 1)

	local v_spec_color = zclib.util.ColorToVector(PotData.style.phongtint)
	v_spec_color = Vector(v_spec_color.x * PotData.style.fresnel,v_spec_color.y * PotData.style.fresnel,v_spec_color.z * PotData.style.fresnel)

	m_material:SetInt("$phong", 1)
	m_material:SetFloat("$phongexponent", PotData.style.phongexponent)
	m_material:SetFloat("$phongboost", PotData.style.phongboost)
	m_material:SetVector("$phongfresnelranges", Vector(1, 4, 6))
	m_material:SetVector("$phongtint", v_spec_color)

	// $model + $normalmapalphaenvmapmask + $opaquetexture
	m_material:SetInt("$flags", 2048 + 4194304 + 16777216)


	m_material:SetVector("$envmaptint", v_spec_color)
	m_material:SetFloat("$envmapfresnel", PotData.style.fresnel)

	m_material:SetTexture("$bumpmap", PotMeshData.nrm)
	m_material:SetInt("$normalmapalphaenvmapmask", 1)

	m_material:SetInt("$rimlight", 1)
	m_material:SetFloat("$rimlightexponent", PotData.style.phongexponent)
	m_material:SetFloat("$rimlightboost", PotData.style.fresnel)

	// Refresh the material
	m_material:Recompute()

	return m_material
end

/*
	Draws the final texture using multiply blend modes and gradients
*/
function zgo2.Pot.DrawTexture(w, h, PotData,ImgurMat,IsPreview)

	local col = PotData.style.color

	local PotMeshData = zgo2.Pot.Types[PotData.type]

	surface.SetDrawColor(col.r,col.g,col.b,255)
	surface.SetMaterial(PotMeshData.diff)
	surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)

	if ImgurMat then

		local imgCol = PotData.style.img_color

		local x, y = PotData.style.pos_x or 0, PotData.style.pos_y or 0
		local u0, v0 = 0 + x, 0 + y
		local u1, v1 = 1 + x, 1 + y

		if PotData.style.blendmode == 0 then
			// Dont blend
			surface.SetDrawColor(imgCol.r,imgCol.g,imgCol.b,imgCol.a)
			surface.SetMaterial(ImgurMat)
			surface.DrawTexturedRectUV(0, 0, w, h, u0 * PotData.style.scale, v0 * PotData.style.scale, u1 * PotData.style.scale, v1 * PotData.style.scale)
		else

			// Blend according to mode
			local bm = zclib.Blendmodes.List[PotData.style.blendmode]
			render.OverrideBlend(true, bm.srcBlend, bm.destBlend, bm.blendFunc, bm.srcBlendAlpha, bm.destBlendAlpha, bm.blendFuncAlpha)
				surface.SetDrawColor(imgCol.r,imgCol.g,imgCol.b,imgCol.a)
				surface.SetMaterial(ImgurMat)
				surface.DrawTexturedRectUV(0, 0, w, h, u0 * PotData.style.scale, v0 * PotData.style.scale, u1 * PotData.style.scale, v1 * PotData.style.scale)
			render.OverrideBlend( false )
		end
	end
end
