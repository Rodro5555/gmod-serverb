if SERVER then return end

// Stencil stuff
ZRMS_SHAFTS = ZRMS_SHAFTS or {}
hook.Add("PreDrawTranslucentRenderables", "a_zrmine_RenderShafts", function(depth, skybox)
	if GetConVar("zrms_cl_stencil"):GetInt() == 1 and skybox == false and depth == false then
		for k, s in pairs(ZRMS_SHAFTS) do
			if not IsValid(s) then continue end
			if (s:GetIsClosed() or not zrmine.f.InDistance(LocalPlayer():GetPos(), s:GetPos(), 700)) then continue end
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(57)

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)


			local angle = s:GetAngles()
			cam.Start3D2D(s:GetPos(), angle, 1)
				surface.SetDrawColor(0, 200, 255, 200)
				draw.NoTexture()
				draw.RoundedBox(0, -93, -30, 140, 60,zrmine.default_colors["white05"])
			cam.End3D2D()


			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			//render.SuppressEngineLighting(true)
			render.SetLightingOrigin(s:GetPos() + s:GetUp() * 10)
			render.DepthRange(0, 0.8)

			if (IsValid(s.csModel)) then
				s.csModel:DrawModel()
			end

			if (IsValid(s.csCartModel) and not s:GetHideCart()) then
				s.csCartModel:DrawModel()
			end

			//render.SuppressEngineLighting(false)
			render.SetStencilEnable(false)
			render.DepthRange(0, 1)
		end
	end
end)


// Stencil stuff
ZRMS_CSM_MELTER = ZRMS_CSM_MELTER or {}
hook.Add("PreDrawTranslucentRenderables", "a_zrmine_RenderMelter", function(depth, skybox)

	if GetConVar("zrms_cl_stencil"):GetInt() == 1 and skybox == false and depth == false then
		for k, s in pairs(ZRMS_CSM_MELTER) do
			if not IsValid(s) then continue end
			if not zrmine.f.InDistance(LocalPlayer():GetPos(), s:GetPos(), 400) then continue end
			if s:GetIsLowered() then continue end

			render.ClearStencil()
			render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(57)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

			local angle = s:GetAngles()
			cam.Start3D2D(s:GetPos(), angle, 1)
				surface.SetDrawColor(0, 200, 255, 255)
				draw.NoTexture()
				draw.RoundedBox(0, -23, -23, 46, 46, zrmine.default_colors["white02"])
			cam.End3D2D()

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			//render.SuppressEngineLighting(true)
			render.DepthRange(0, 0.8)

			if (IsValid(s.ClientModels["BurnChamber"]) and IsValid(s.ClientModels["BurnCoal"])) then

				if (s:GetCurrentState() == 3) then
					s.ClientModels["BurnCoal"]:DrawModel()
				end

				s.ClientModels["BurnChamber"]:DrawModel()
			end

			//render.SuppressEngineLighting(true)
			render.SetStencilEnable(false)
			render.DepthRange(0, 1)
		end
	end
end)
