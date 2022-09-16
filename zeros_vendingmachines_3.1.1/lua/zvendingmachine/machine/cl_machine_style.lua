if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}

/*
	You might ask why am I using a "draw HUD" hook here
	instead of using ENT:Draw from the screen entity itself.

	The answer is: HDR does not affect stuff drawn on this hook.
	In some occasions it was very hard to see the screen on dark/bright rooms...

	Of course, this means I had to keep track of
	all machines in existence, but hey, it works.
*/
local vec01 = Vector(0,0,70)
zclib.Hook.Remove("PreDrawHUD", "zvm_machine_drawpaint")
zclib.Hook.Add("PreDrawHUD", "zvm_machine_drawpaint", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local curDraw = CurTime()
	cam.Start3D()

	for machine, _ in pairs(zvm.Machines) do
		if not IsValid(machine) then continue end
		if machine.Wait then continue end

		// If we cant see the machine then skip
		if zclib.util.IsInsideViewCone(machine:LocalToWorld(vec01), EyePos(), EyeAngles(), 2000, 4000) == false then continue end

		// Update everything if it wasnt drawn for a long period
		if machine.LastDraw == nil or machine.LastDraw < (curDraw - 0.25) then
			machine.UpdatedPaint = nil
		end
		machine.LastDraw = curDraw

		if machine:GetStyleID() ~= machine.LastStyleID then
			machine.LastStyleID = machine:GetStyleID()
			machine.UpdatedPaint = nil
		end

		if machine.UpdatedPaint == nil then

			// Update some UI visual stuff
			zvm.Machine.UpdateVisuals(machine)

			// Update the style of the machine
			zvm.Machine.UpdatePaint(machine)

			machine.UpdatedPaint = true
		end
	end

	cam.End3D()
end)

/*

    This system creates the custom machine lua material

*/
function zvm.Machine.InitMaterial(Machine) end

function zvm.Machine.UpdatePaint(Machine)
	local StyleID = Machine:GetStyleID()

	local dat = zvm.Machine.Styles[StyleID]
	if dat == nil then
		zvm.Print("StyleID " .. tostring(StyleID) .. " not found!")
		return
	end
	local matID = "zvm_machine_style_mat_" .. dat.uniqueid

	// Builds / Updates / Caches the material
	zvm.Machine.GetMaterial(matID, dat)

	Machine:SetSubMaterial(1, "!" .. matID)
end

local CachedMaterials = {}

function zvm.Machine.GetCachedMaterial(MatID, StyleID)
	if CachedMaterials[ MatID ] then
		return CachedMaterials[ MatID ]
	else
		return zvm.Machine.GetMaterial(MatID, zvm.Machine.GetStyleData(StyleID))
	end
end

function zvm.Machine.DrawImgur(StyleData, ImgurMat, w, h)
	local x, y = StyleData.imgur_x, StyleData.imgur_y
	local u0, v0 = 0 * StyleData.imgur_scale + x, 0 * StyleData.imgur_scale + y
	local u1, v1 = 1 * StyleData.imgur_scale + x, 1 * StyleData.imgur_scale + y
	surface.SetDrawColor(StyleData.imgur_color)
	surface.SetMaterial(ImgurMat)
	surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
end

function zvm.Machine.DrawLogo(StyleData, LogoMat, w, h)

	local x, y = StyleData.logo_x, StyleData.logo_y
	local img_w, img_h = w * StyleData.logo_scale, h * StyleData.logo_scale

	x = (w * x) - (img_w / 2)
	y = (h * y) - (img_h / 2)

	surface.SetDrawColor(StyleData.logo_color)
	surface.SetMaterial(LogoMat)
	surface.DrawTexturedRectRotated((img_w / 2) + x, (img_h / 2) + y, img_w,img_h, StyleData.logo_rotation or 0)
end

function zvm.Machine.DrawBaseTexture(StyleData, w, h)
	local BaseTexMat = zvm.Machine.GetBasetexture(StyleData)
	if not BaseTexMat then return end


	local x, y = 0,0
	local u0, v0 = 0 + x, 0 + y
	local u1, v1 = 1 + x, 1 + y

	// Draw the basetexture
	// TODO Maybe lets set the base color to this and make a custom color value for mask color
	surface.SetDrawColor(color_white)
	surface.SetMaterial(BaseTexMat)
	surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
end

function zvm.Machine.DrawColorMask(StyleData, w, h)
	local MaskMat = zvm.Machine.GetMaskTexture(StyleData)
	if not MaskMat then return end

	local x, y = 0,0
	local u0, v0 = 0 + x, 0 + y
	local u1, v1 = 1 + x, 1 + y

	// Draw the parts of the texture that should be colored
	surface.SetDrawColor(StyleData.color)
	surface.SetMaterial(MaskMat)
	surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
end

function zvm.Machine.DrawEmissive(StyleData, EmissveMat, w, h)
	local x, y = StyleData.em_x, StyleData.em_y
	local u0, v0 = 0 * StyleData.em_scale + x, 0 * StyleData.em_scale + y
	local u1, v1 = 1 * StyleData.em_scale + x, 1 * StyleData.em_scale + y
	surface.SetDrawColor(StyleData.em_color)
	surface.SetMaterial(EmissveMat)
	surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
end


/*
	In order to simulate a blend mode we change the color src and dest
	BlendModes:
		Additive:[srcBlend = BLEND_SRC_ALPHA, destBlend = BLEND_ONE, blendFunc = BLENDFUNC_ADD]
		Multiply:[srcBlend = BLEND_DST_COLOR, destBlend = BLEND_ZERO, blendFunc = BLENDFUNC_ADD]
*/
zvm.Machine.BlendModes = {
	[0] = {
		name = "Normal"
	},
	[1] = {
		name = "Additive",
		srcBlend = BLEND_SRC_ALPHA,
		destBlend = BLEND_ONE,
		blendFunc = BLENDFUNC_ADD,
		srcBlendAlpha = BLEND_ONE,
		destBlendAlpha = BLEND_ZERO,
		blendFuncAlpha = BLENDFUNC_ADD
	},
	[2] = {
		name = "Multiply",
		srcBlend = BLEND_DST_COLOR,//BLEND_DST_COLOR
		destBlend = BLEND_ONE_MINUS_SRC_ALPHA, // BLEND_ZERO
		blendFunc = BLENDFUNC_ADD,
		srcBlendAlpha = BLEND_ONE,
		destBlendAlpha = BLEND_ZERO,
		blendFuncAlpha = BLENDFUNC_ADD
	}
}

/*
	Draws the diffuse map of our material
*/
function zvm.Machine.DrawMaterial(w,h,StyleData,ImgurMat,LogoMat)

	// Draw diff basetexture
	zvm.Machine.DrawBaseTexture(StyleData, w, h)

	// Draw color mask
	zvm.Machine.DrawColorMask(StyleData,w,h)

	// Draw default imgur image
	if ImgurMat then
		if StyleData.imgur_blendmode == 0 then
			// Dont blend
			zvm.Machine.DrawImgur(StyleData,ImgurMat, w, h)
		else

			// Blend according to mode
			local bm = zvm.Machine.BlendModes[StyleData.imgur_blendmode]
			render.OverrideBlend(true, bm.srcBlend, bm.destBlend, bm.blendFunc, bm.srcBlendAlpha, bm.destBlendAlpha, bm.blendFuncAlpha)
				zvm.Machine.DrawImgur(StyleData,ImgurMat, w, h)
			render.OverrideBlend( false )
		end
	end

	// Draw logo imgur image
	if LogoMat then
		if StyleData.logo_blendmode == 0 then
			// Dont blend
			zvm.Machine.DrawLogo(StyleData, LogoMat, w, h)
		else
			// Blend according to mode
			local bm = zvm.Machine.BlendModes[StyleData.logo_blendmode]
			render.OverrideBlend(true, bm.srcBlend, bm.destBlend, bm.blendFunc, bm.srcBlendAlpha, bm.destBlendAlpha, bm.blendFuncAlpha)
				zvm.Machine.DrawLogo(StyleData, LogoMat, w, h)
			render.OverrideBlend( false )
		end
	end
end

/*
	Creates / Caches the base diffuse map as lua material and also its color mask png
*/
local CachedJPGTextures = {}
function zvm.Machine.GetBasetexture(StyleData)
	local SkinData = zvm.Machine.GetSkinData(StyleData.skin)

	if CachedJPGTextures[SkinData.diff] == nil then
		CachedJPGTextures[SkinData.diff] = Material(SkinData.diff .. ".jpg","ignorez smooth")
	end
	return CachedJPGTextures[SkinData.diff]
end

local CachedMaskTextures = {}
function zvm.Machine.GetMaskTexture(StyleData)

	local SkinData = zvm.Machine.GetSkinData(StyleData.skin)

	if CachedMaskTextures[SkinData.diff] == nil then
		if SkinData.mask then
			CachedMaskTextures[SkinData.diff] = Material(SkinData.mask, "alphatest ignorez smooth")
		else
			CachedMaskTextures[SkinData.diff] = Material(SkinData.diff .. ".jpg","ignorez smooth")
		end
	end

	return CachedMaskTextures[SkinData.diff]
end

function zvm.Machine.PushTexture(r,g,b,a,MatID,OnPush)
	local rt_target = GetRenderTarget(MatID, zvm.config.RenderTargetSize or 512, zvm.config.RenderTargetSize or 512, false)
	local mat = Matrix()
	render.SuppressEngineLighting(true)

	render.PushRenderTarget(rt_target)
		//NOTE Try that? > render.Clear(r, g, b, a)
		render.Clear(r, g, b, a, true, true)
		render.OverrideAlphaWriteEnable(true, true)

			cam.Start2D()
				cam.PushModelMatrix(mat)
					pcall(OnPush)
				cam.PopModelMatrix()
			cam.End2D()

		render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()

	render.SuppressEngineLighting(false)

	return rt_target
end

/*
	Creates / Caches / Updates the final lua material
*/
function zvm.Machine.GetMaterial(MatID, StyleData)
	local m_material

	// Verify Data integrity
	StyleData = zvm.Machine.VerifyStyleData(StyleData)

	//local v_color = zclib.util.ColorToVector(StyleData.color)
	local v_spec_color = zclib.util.ColorToVector(StyleData.spec_color)
	v_spec_color = Vector(v_spec_color.r * StyleData.reflection, v_spec_color.g * StyleData.reflection, v_spec_color.b * StyleData.reflection)

	local SkinData = zvm.Machine.GetSkinData(StyleData.skin)

	local em_color = zclib.util.ColorToVector(StyleData.em_color or color_black)

	if CachedMaterials[MatID] == nil then
		zvm.Print("Cached "..tostring(MatID))
		CachedMaterials[MatID] = CreateMaterial(MatID, "VertexLitGeneric", {
			["$basetexture"] = SkinData.diff,
			["$halflambert"] = 1,
			["$model"] = 1,

			["$bumpmap"] = SkinData.nrm,
			["$normalmapalphaenvmapmask"] = 1,

			["$envmap"] = "env_cubemap",
			["$envmaptint"] = v_spec_color,
			["$envmapfresnel"] = StyleData.fresnel,
			["$fresnelreflection"] = StyleData.fresnel,
			["$envmapfresnelminmaxexp"] = Vector(1 * StyleData.fresnel, 4 * StyleData.fresnel, 6 * StyleData.fresnel),

			["$phong"] = 1,
			["$phongexponent"] = 1,
			["$phongboost"] = StyleData.fresnel,
			["$phongfresnelranges"] = Vector(1 * StyleData.fresnel, 4 * StyleData.fresnel, 6 * StyleData.fresnel),
			["$phongtint"] = v_spec_color,

			["$rimlight"] = 1,
			["$rimlightexponent"] = 5,
			["$rimlightboost"] = 1,

			["$emissiveBlendEnabled"] = 1,
			["$emissiveBlendTexture"] = "zerochain/props_vendingmachine/vendingmachine/null",
			["$emissiveBlendBaseTexture"] = "zerochain/props_vendingmachine/vendingmachine/null", // Change this to emissive map
			["$emissiveBlendFlowTexture"] = "zerochain/props_vendingmachine/vendingmachine/null",
			["$emissiveBlendTint"] = em_color,
			["$emissiveBlendStrength"] = StyleData.em_strength,
		})
	end
	m_material = CachedMaterials[MatID]

	m_material:SetTexture("$basetexture", SkinData.diff)
	m_material:SetInt("$halflambert", 1)
	m_material:SetInt("$model", 1)

	m_material:SetTexture("$bumpmap", SkinData.nrm)
	m_material:SetInt("$normalmapalphaenvmapmask", 1)

	m_material:SetVector("$envmaptint", v_spec_color)
	m_material:SetFloat("$envmapfresnel", StyleData.fresnel)
	m_material:SetFloat("$fresnelreflection", StyleData.fresnel)
	m_material:SetVector("$envmapfresnelminmaxexp", Vector(1 * StyleData.fresnel, 4 * StyleData.fresnel, 6 * StyleData.fresnel))

	m_material:SetInt("$phong", 1)
	m_material:SetFloat("$phongexponent", 2)
	m_material:SetFloat("$phongboost", StyleData.fresnel)
	m_material:SetVector("$phongfresnelranges", Vector(1 * StyleData.fresnel, 4 * StyleData.fresnel, 6 * StyleData.fresnel))
	m_material:SetVector("$phongtint", v_spec_color)

	m_material:SetInt("$rimlight", 1)
	m_material:SetFloat("$rimlightexponent", 1)
	m_material:SetFloat("$rimlightboost", 0.1)

	// $model + $normalmapalphaenvmapmask + $opaquetexture + $vertexalpha
	m_material:SetInt("$flags", 2048 + 4194304 + 16777216 /*+ 32*/)

	///////////////////////////////
	local ImgurMat
	if StyleData.imgur_url then
		zclib.Imgur.GetMaterial(tostring(StyleData.imgur_url), function(result)
			if result then
				ImgurMat = result
			end
		end)
	end

	local LogoMat
	if StyleData.logo_url then
		zclib.Imgur.GetMaterial(tostring(StyleData.logo_url), function(result)
			if result then
				LogoMat = result
			end
		end)
	end

	local base_target = zvm.Machine.PushTexture(255,255,255,255,MatID,function()
		zvm.Machine.DrawMaterial(ScrW(),ScrH(),StyleData,ImgurMat,LogoMat)
	end)

	m_material:SetTexture("$basetexture", base_target)
	///////////////////////////////


	///////////////////////////////
	m_material:SetVector("$emissiveBlendTint", em_color)
	m_material:SetFloat("$emissiveBlendStrength", StyleData.em_strength)

	local EmissveMat
	if StyleData.em_url then
		zclib.Imgur.GetMaterial(tostring(StyleData.em_url), function(result)
			if result then
				EmissveMat = result
			end
		end)
	end

	if EmissveMat then
		local em_target = zvm.Machine.PushTexture(0,0,0,255,MatID .. "_em",function()
			zvm.Machine.DrawEmissive(StyleData, EmissveMat, ScrW(),ScrH())
		end)
		m_material:SetTexture("$emissiveBlendBaseTexture", em_target)
	end
	///////////////////////////////

	// Refresh the material
	m_material:Recompute()
	return m_material
end

if CLIENT then
	zclib.Snapshoter.SetPath("zvm_machine", function(ItemData)
		if ItemData.StyleID then return "zvm/machine_style_" .. ItemData.StyleID end
	end)

	zclib.Hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosVendingmachine", function(cEnt, ItemData)
		if ItemData.class == "zvm_machine" and ItemData and ItemData.StyleID then

			local data = zvm.Machine.GetStyleData(ItemData.StyleID)

			if data then
				local mat = zvm.Machine.GetCachedMaterial("zvm_machine_style_mat_" .. ItemData.StyleID,ItemData.StyleID)

				if not mat then

					mat = zvm.Machine.GetMaterial("zvm_machine_style_mat_" .. ItemData.StyleID, data)

					if mat then
						render.MaterialOverrideByIndex(1, mat)
					end
				else
					render.MaterialOverrideByIndex(1, mat)
				end
			else
				zvm.Print("Could not find any StyleData for " .. tostring(ItemData.StyleID) .. "!")
			end
		end
	end)
end
