if SERVER then return end

ztm = ztm or {}
ztm.Buyermachine = ztm.Buyermachine or {}
ztm.Buyermachine.Stencils = ztm.Buyermachine.Stencils or {}


function ztm.Buyermachine.Initialize(Buyermachine)
	zclib.EntityTracker.Add(Buyermachine)

	Buyermachine.LastMoney = 0

	Buyermachine.IsInserting = false

	Buyermachine.LastMoneyEnt = nil

	Buyermachine.HasMoney = false

	Buyermachine.PayoutMode = false

	Buyermachine:DrawShadow(false)
	ztm.Buyermachine.Stencils[Buyermachine:EntIndex()] = Buyermachine
end

function ztm.Buyermachine.Draw(Buyermachine)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Buyermachine:GetPos(), 300) then
		ztm.Buyermachine.DrawInfo(Buyermachine)
	end
end

function ztm.Buyermachine.DrawInfo(Buyermachine)
	cam.Start3D2D(Buyermachine:LocalToWorld(Vector(0, 10, 104)), Buyermachine:LocalToWorldAngles(Angle(0, 180, 90)), 0.1)
		draw.RoundedBox(5, -180, 85, 360, 200, ztm.default_colors["blue01"])

		if Buyermachine.PayoutMode then
			surface.SetDrawColor(ztm.default_colors["white01"])
			surface.SetMaterial(ztm.default_materials["ztm_cathead"])
			surface.DrawTexturedRect(-100, 80, 200, 200)
		elseif Buyermachine.IsInserting then
			draw.DrawText(ztm.language.General["Wait"] .. "...", zclib.GetFont("ztm_recycler_font01"), 0, 165, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
		else
			if IsValid(Buyermachine:GetMoneyEnt()) then
				local h_offset = 25 * math.abs(math.sin(CurTime()) * 1)
				draw.DrawText("⇓", zclib.GetFont("ztm_buyermachine_font02"), 150, 150 + h_offset, ztm.default_colors["white01"], TEXT_ALIGN_RIGHT)
				draw.DrawText("- " .. ztm.language.General["TakeMoney"] .. " -", zclib.GetFont("ztm_buyermachine_font01"), 0, 170, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
			else
				local modify = (1 / 100) * Buyermachine:GetPriceModify()
				local _money = Buyermachine:GetMoney() * modify

				if _money > 0 then
					if Buyermachine:OnPayoutButton(LocalPlayer()) then
						draw.RoundedBox(5, -130, 190, 260, 60, ztm.default_colors["blue02"])
					else
						draw.RoundedBox(5, -130, 190, 260, 60, ztm.default_colors["blue03"])
					end

					draw.DrawText(ztm.language.General["Payout"], zclib.GetFont("ztm_recycler_font01"), 0, 195, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
				else
					draw.DrawText("- " .. ztm.language.General["InsertRecycledTrash"] .. " -", zclib.util.FontSwitch(ztm.language.General["InsertRecycledTrash"], 25, zclib.GetFont("ztm_buyermachine_font01"), zclib.GetFont("ztm_buyermachine_font01_small")), 0, 210, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
				end

				if ztm.config.Buyermachine.DynamicBuyRate then
					local clean_profit = (100 * modify) - 100

					if clean_profit >= 0 then
						clean_profit = "+" .. clean_profit
					end

					draw.DrawText(zclib.Money.Display(_money) .. " " .. clean_profit .. "%", zclib.GetFont("ztm_recycler_font01"), 0, 115, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
				else
					draw.DrawText(zclib.Money.Display(_money), zclib.GetFont("ztm_recycler_font01"), 0, 115, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
				end
			end
		end

	cam.End3D2D()
end

function ztm.Buyermachine.Think(Buyermachine)
	zclib.util.LoopedSound(Buyermachine, "ztm_conveyorbelt_loop", true)

	if zclib.util.InDistance(LocalPlayer():GetPos(), Buyermachine:GetPos(), 1000) then
		if IsValid(Buyermachine.csModel) then
			Buyermachine.csModel:SetPos(Buyermachine:GetPos())
			Buyermachine.csModel:SetAngles(Buyermachine:GetAngles())
		end

		local _isinserting = Buyermachine:GetIsInserting()
		if Buyermachine.IsInserting ~= _isinserting then
			Buyermachine.IsInserting = _isinserting

			if Buyermachine.IsInserting then
				zclib.Animation.Play(Buyermachine, "insert", 0.5)

				if IsValid(Buyermachine.csBlockModel) then
					local _recycle_type = ztm.config.Recycler.recycle_types[Buyermachine:GetBlockType()]
					Buyermachine.csBlockModel:SetMaterial(_recycle_type.mat, true)
				end
			else
				zclib.Animation.Play(Buyermachine, "idle", 1)
			end
		end

		local _money = Buyermachine:GetMoney()
		if Buyermachine.LastMoney ~= _money then
			Buyermachine.LastMoney = _money
		end

		local _moneyent = Buyermachine:GetMoneyEnt()
		if Buyermachine.LastMoneyEnt ~= _moneyent then
			Buyermachine.LastMoneyEnt = _moneyent

			if IsValid(_moneyent) then
				Buyermachine.HasMoney = true
			end
		end

		if Buyermachine.HasMoney == true and not IsValid(Buyermachine.LastMoneyEnt) then
			Buyermachine:EmitSound("ztm_buyermachine_payout")
			Buyermachine.HasMoney = false
			Buyermachine.PayoutMode = true

			timer.Simple(1, function()
				if IsValid(Buyermachine) then
					Buyermachine.PayoutMode = false
				end
			end)
		end
	else
		Buyermachine.IsInserting = false
	end
end

function ztm.Buyermachine.OnRemove(Buyermachine)
	Buyermachine:StopSound("ztm_conveyorbelt_loop")

	if IsValid(Buyermachine.csModel) then
		Buyermachine.csModel:Remove()
	end

	if IsValid(Buyermachine.csBlockModel) then
		Buyermachine.csBlockModel:Remove()
	end
end

zclib.Hook.Add("PostDrawTranslucentRenderables", "ztm_buyermachine", function(depth, skybox, isDraw3DSkybox)
	if isDraw3DSkybox == false then
		for k, s in pairs(ztm.Buyermachine.Stencils) do
			if not IsValid(s) then continue end
			if not zclib.util.InDistance(LocalPlayer():GetPos(), s:GetPos(), 400) then continue end
			render.ClearStencil()
			render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(57)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

			cam.Start3D2D(s:LocalToWorld(Vector(0, 4, 50)), s:LocalToWorldAngles(Angle(0, 180, 90)), 1)
				surface.SetDrawColor(ztm.default_colors["black02"])
				surface.DrawRect(-18, -2, 36, 31)
			cam.End3D2D()

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.DepthRange(0, 0.5)

			if IsValid(s.csModel) then
				s.csModel:DrawModel()
			else
				s.csModel = zclib.ClientModel.Add("models/zerochain/props_trashman/ztm_buyermachine_stencil.mdl")
				s.csModel:SetPos(s:GetPos())
				s.csModel:SetAngles(s:GetAngles())
				s.csModel:SetParent(s)
				s.csModel:SetNoDraw(true)
			end

			if IsValid(s.csBlockModel) then
				local attach = s:GetAttachment(1)

				if attach then
					s.csBlockModel:SetPos(attach.Pos)
					local ang = attach.Ang
					ang:RotateAroundAxis(attach.Ang:Right(), 90)
					s.csBlockModel:SetAngles(ang)
				end

				if s:GetIsInserting() then
					s.csBlockModel:DrawModel()
				end
			else
				s.csBlockModel = zclib.ClientModel.Add("models/zerochain/props_trashman/ztm_recycleblock.mdl")
				local attach = s:GetAttachment(1)

				if IsValid(s.csBlockModel) and attach then
					s.csBlockModel:SetPos(attach.Pos)
					local ang = attach.Ang
					ang:RotateAroundAxis(attach.Ang:Up(), 90)
					s.csBlockModel:SetAngles(ang)
					s.csBlockModel:SetParent(s, 1)
					s.csBlockModel:SetNoDraw(true)
				end
			end

			render.DepthRange(0, 1)
			render.SetStencilEnable(false)
		end
	end
end)
