zgo2 = zgo2 or {}
zgo2.Bong = zgo2.Bong or {}

local function GetMaterialName(BongData,IsEditor)
	return IsEditor and "zgo2_bong_editor" or "zgo2_bong_" .. BongData.uniqueid
end

/*
	Rebuilds / Updates all materials which are used for this plant
*/
function zgo2.Bong.RebuildMaterial(BongData,IsEditor)
	zgo2.Bong.GetMaterial(BongData,GetMaterialName(BongData,IsEditor))
end

/*
	Update the plants material
*/
function zgo2.Bong.ApplyMaterial(Bong, BongData, IsEditor)
	if not IsValid(Bong) then return end
	local mat = "!" .. GetMaterialName(BongData, IsEditor)

	// NOTE SetSubMaterial doesent seem to work on a real SERVER on CLIENT
	// https://github.com/Facepunch/garrysmod-issues/issues/3362
	// For now if the bong is a client model we can use SetSubMaterial but if the weapon got dropped then just use SetMaterial, it does not look too bad so ok
	if Bong:GetClass() == "viewmodel" then
		Bong:SetSubMaterial(zgo2.Bong.Types[ BongData.type ].id, mat)
	else
		Bong:SetMaterial(mat)
	end
end

/*
	Creates / Caches / Updates the final lua material
*/
zgo2.Bong.CachedMaterials = zgo2.Bong.CachedMaterials or {}
function zgo2.Bong.GetMaterial(BongData,MatID)
	local m_material

	// Create / Cache the material
	if zgo2.Bong.CachedMaterials[MatID] == nil then
		zgo2.Print("Cached "..tostring(MatID))
		zgo2.Bong.CachedMaterials[MatID] = CreateMaterial(MatID, "VertexLitGeneric", {
			["$basetexture"] = "zerochain/props_growop2/bong/zgo2_bong_glass",

			["$color2"] = "[1 1 1]",

			["$halflambert"] = 1,
			["$model"] = 1,
			["$nodecal"] = 1,
			["$surfaceprop"] = "glass",
			["$nocull"] = 1,

			["$alphatest"] = 1,
			["$alphatestreference"] = 0.5,

			["$bumpmap"] = zgo2.Bong.Types[BongData.type].nrm or "null-bumpmap",
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
	m_material = zgo2.Bong.CachedMaterials[MatID]

	// Load imgur image
	if BongData.style.url then

		zclib.Imgur.GetMaterial(tostring(BongData.style.url), function(ImgurMat)

			local base_target = zgo2.util.PushTexture(0,0,0,255,MatID,function()

				local w,h = ScrW(), ScrH()

				zgo2.Bong.DrawTexture(w,h, BongData, ImgurMat)

				zclib.Blendmodes.Blend("Additive",false,function()
					surface.SetDrawColor(BongData.style.color)
					surface.SetMaterial(zgo2.Bong.Types[BongData.type].diff)
					surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)
				end)
			end)
			m_material:SetTexture("$basetexture", base_target)
		end)
	else
		local base_target = zgo2.util.PushTexture(0,0,0,255,MatID,function()

			local w,h = ScrW(), ScrH()

			zgo2.Bong.DrawTexture(w,h, BongData, nil)

			zclib.Blendmodes.Blend("Additive",false,function()
				surface.SetDrawColor(BongData.style.color)
				surface.SetMaterial(zgo2.Bong.Types[BongData.type].diff)
				surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)
			end)
		end)
		m_material:SetTexture("$basetexture", base_target)
	end

	m_material:SetVector("$color2", zclib.util.ColorToVector(BongData.style.color))

	m_material:SetInt("$halflambert", 1)
	m_material:SetInt("$model", 1)
	m_material:SetInt("$nocull", 1)

	local v_spec_color = zclib.util.ColorToVector(BongData.style.phongtint)
	v_spec_color = Vector(v_spec_color.x * BongData.style.fresnel,v_spec_color.y * BongData.style.fresnel,v_spec_color.z * BongData.style.fresnel)

	m_material:SetInt("$phong", 1)
	m_material:SetFloat("$phongexponent", BongData.style.phongexponent)
	m_material:SetFloat("$phongboost", BongData.style.phongboost)
	m_material:SetVector("$phongfresnelranges", Vector(1, 4, 6))
	m_material:SetVector("$phongtint", v_spec_color)

	m_material:SetFloat("$alphatestreference",0.01)

	m_material:SetVector("$envmaptint", v_spec_color)
	m_material:SetFloat("$envmapfresnel", BongData.style.fresnel)

	m_material:SetTexture("$bumpmap", zgo2.Bong.Types[BongData.type].nrm or "null-bumpmap")
	m_material:SetInt("$normalmapalphaenvmapmask", 1)

	m_material:SetInt("$rimlight", 1)
	m_material:SetFloat("$rimlightexponent", BongData.style.phongexponent)
	m_material:SetFloat("$rimlightboost", BongData.style.fresnel)

	// $model + $nodecal  + $nocull + $normalmapalphaenvmapmask
	m_material:SetInt("$flags", 2048 + 67108864 + 8192 + 256 + 536870912 + 4194304 )

	// Refresh the material
	m_material:Recompute()

	return m_material
end

/*
	Draws the final texture using multiply blend modes and gradients
*/
local BaseTexMatNoAlpha = Material("zerochain/props_growop2/bong/zgo2_bong_mat.png","ignorez smooth")
function zgo2.Bong.DrawTexture(w, h, BongData,ImgurMat,IsPreview)

	local col = BongData.style.color

	surface.SetDrawColor(col.r,col.g,col.b,255)
	surface.SetMaterial(BaseTexMatNoAlpha)
	surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)

	surface.SetDrawColor(col.r,col.g,col.b,col.a)
	surface.SetMaterial(zgo2.Bong.Types[BongData.type].diff)
	surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)

	if ImgurMat then

		local imgCol = BongData.style.img_color

		local x, y = BongData.style.pos_x or 0, BongData.style.pos_y or 0
		local u0, v0 = 0 + x, 0 + y
		local u1, v1 = 1 + x, 1 + y

		if BongData.style.blendmode == 0 then
			// Dont blend
			surface.SetDrawColor(imgCol.r,imgCol.g,imgCol.b,imgCol.a)
			surface.SetMaterial(ImgurMat)
			surface.DrawTexturedRectUV(0, 0, w, h, u0 * BongData.style.scale, v0 * BongData.style.scale, u1 * BongData.style.scale, v1 * BongData.style.scale)
		else

			// Blend according to mode
			local bm = zclib.Blendmodes.List[BongData.style.blendmode]
			render.OverrideBlend(true, bm.srcBlend, bm.destBlend, bm.blendFunc, bm.srcBlendAlpha, bm.destBlendAlpha, bm.blendFuncAlpha)
				surface.SetDrawColor(imgCol.r,imgCol.g,imgCol.b,imgCol.a)
				surface.SetMaterial(ImgurMat)
				surface.DrawTexturedRectUV(0, 0, w, h, u0 * BongData.style.scale, v0 * BongData.style.scale, u1 * BongData.style.scale, v1 * BongData.style.scale)
			render.OverrideBlend( false )
		end
	end
end
