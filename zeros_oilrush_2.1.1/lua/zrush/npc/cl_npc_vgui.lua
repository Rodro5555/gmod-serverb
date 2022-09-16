if not CLIENT then return end
zrush = zrush or {}
zrush.FuelBuyer = zrush.FuelBuyer or {}

local FuelInventory = {}

// This opens the machine ui for a user
net.Receive("zrush_npc_open", function(len)
	zrush.vgui.ActiveEntity = net.ReadEntity()
	if not IsValid(zrush.vgui.ActiveEntity) then return end
	FuelInventory = net.ReadTable()
	zrush.FuelBuyer.Open()
end)

local function CustomNotify(msg, dur)
	if IsValid(zrush_main_panel.NotifyPanel) then
		zrush_main_panel.NotifyPanel:Remove()
	end

	zclib.vgui.PlaySound("buttons/button15.wav")
	local x, y = zrush_main_panel:GetPos()
	local p = vgui.Create("DPanel")
	p:SetPos(x, y)
	p:SetSize(220 * zclib.wM, 350 * zclib.hM)
	p:MoveTo(x - p:GetWide() - 5 * zclib.wM, y, 0.25, 0, 1, function()
		if IsValid(p) then
			p:AlphaTo(0, 1, dur, function()
				if IsValid(p) then
					p:Remove()
				end
			end)
		end
	end)


	p:SetAutoDelete(true)
	p:ParentToHUD()
	p:SetDrawOnTop(false)

	p.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
	end

	p:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	local img = vgui.Create("DImage", p)
	img:SetSize(200 * zclib.wM, 200 * zclib.hM)
	img:SetImage(zrush.config.FuelBuyer.NotifyImage)
	img:Dock(TOP)
	img:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)

	local p_lbl = vgui.Create("DLabel", p)
	p_lbl:SetPos(0 * zclib.wM, 0 * zclib.hM)
	p_lbl:SetSize(1200 * zclib.wM, 50 * zclib.hM)
	p_lbl.Paint = function(s, w, h) end
	p_lbl:SetText(msg)
	p_lbl:SetTextColor(zclib.colors["text01"])
	p_lbl:SetFont(zclib.GetFont("zclib_font_mediumsmall_thin"))
	p_lbl:SetWrap(true)
	p_lbl:SetContentAlignment(7)
	p_lbl:SizeToContentsX(15 * zclib.wM)
	p_lbl:Dock(FILL)

	zrush_main_panel.NotifyPanel = p

	// Here we attach the notify to the on remove function, so it gets cleaned up
	if zrush_main_panel.NotifyCleanup == nil then
		zrush_main_panel.NotifyCleanup = function()
			local oldRemove = zrush_main_panel.OnRemove

			function zrush_main_panel:OnRemove()
				pcall(oldRemove)

				if IsValid(self.NotifyPanel) then
					self.NotifyPanel:Remove()
				end
			end
		end

		zrush_main_panel.NotifyCleanup()
	end
end

function zrush.FuelBuyer.Open()

	local hasBarrels = false
	for k, v in pairs(FuelInventory) do
		if (v > 0) then
			hasBarrels = true
			break
		end
	end

	local SELECTED_FUEL
	local InfoContent

	zrush.vgui.Page(zrush.language["FuelBuyer"], function(main, top)
		main:SetSize(800 * zclib.wM, 600 * zclib.hM)

		local close_btn = zclib.vgui.ImageButton(940 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 50 * zclib.hM, top, zclib.Materials.Get("close"), function()
			zrush.vgui.Close()
		end, false)
		close_btn:Dock(RIGHT)
		close_btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		close_btn.IconColor = zclib.colors["red01"]

		local seperator = zrush.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local LeftPanel = vgui.Create("DPanel", main)
		LeftPanel:SetSize(345 * zclib.wM, 300 * zclib.hM)
		LeftPanel:Dock(LEFT)
		LeftPanel:DockMargin(50 * zclib.wM, 5 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
		LeftPanel:DockPadding(0 * zclib.wM, 40 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		LeftPanel.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
			draw.SimpleText(zrush.language["YourFuelInv"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 25 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local Info = vgui.Create("DLabel", LeftPanel)
		Info:SetSize(345 * zclib.wM, 60 * zclib.hM)
		Info:Dock(BOTTOM)
		Info:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
		Info:SetFont(zclib.GetFont("zclib_font_small_thin"))
		Info:SetText(zrush.language["SaveInfo"])
		Info:SetColor(zclib.colors["text01"])
		Info:SetContentAlignment(7)
		Info:SetWrap(true)

		local RightPanel = vgui.Create("DPanel", main)
		RightPanel:SetSize(345 * zclib.wM, 300 * zclib.hM)
		RightPanel:Dock(RIGHT)
		RightPanel:DockMargin(10 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		RightPanel.Paint = function(s, w, h)
			if FuelInventory == nil or table.Count(FuelInventory) <= 0 then
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
			end
		end

		local list, scroll = zrush.vgui.List(LeftPanel)
		list:DockPadding(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
		list:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
		scroll:SetSize(250 * zclib.wM, 50 * zclib.hM)
		scroll:Dock(FILL)
		scroll:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h)
			draw.RoundedBox(5, w - 17 * zclib.wM, 0, 17 * zclib.wM, h, zclib.colors["black_a50"])
		end

		local function UpdateInfoPanel(parent,id)

			local fuelData = zrush.Fuel.GetData(id)

			if IsValid(InfoContent) then InfoContent:Remove() end
			local amain = vgui.Create("DPanel",parent)
			amain:Dock(FILL)
			amain.Paint = function(s, w, h) end
			InfoContent = amain

			if fuelData == nil then return end

			local purchase = zrush.vgui.Button(amain,zrush.language["Sell"],zclib.colors["red01"],function()

				if SELECTED_FUEL == nil  then return end

				if not IsValid(zrush.vgui.ActiveEntity) then return end

				net.Start("zrush_npc_sell")
				net.WriteEntity(zrush.vgui.ActiveEntity)
				net.WriteInt(SELECTED_FUEL, 16)
				net.SendToServer()

				// Creates a welcome notification
				CustomNotify(zrush.language["DialogTransactionComplete"], 5)

			end)
			purchase:Dock(BOTTOM)
			purchase:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

			local mdl = zclib.vgui.ModelPanel({model = "models/zerochain/props_oilrush/zor_barrel.mdl", render = {FOV = 45}})
			mdl:SetSize(400 * zclib.wM, 600 * zclib.hM)
			mdl:SetParent(amain)
			mdl:Dock(FILL)
			mdl:SetColor(fuelData.color)
			mdl.LayoutEntity = function(self)
				self.Entity:SetAngles(Angle(0, RealTime() * 30, 0))
			end
			mdl.PreDrawModel = function(s, ent)
				local w, h = s:GetWide(), s:GetTall()
				cam.Start2D()
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
				cam.End2D()
			end


			local amount = FuelInventory[id] or 0
			local sellProfit = zrush.vgui.ActiveEntity:GetPrice_Mul() / 100
			local money = zclib.Money.Display(fuelData.price * amount * sellProfit)
			mdl.PostDrawModel = function(s)
				local w, h = s:GetWide(), s:GetTall()
				cam.Start2D()
					surface.SetDrawColor(zclib.colors["black_a200"])
					surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
					surface.DrawTexturedRectRotated(w / 2, 25 * zclib.hM, w, 50 * zclib.hM, 180)

					draw.SimpleText(money, zclib.GetFont("zclib_font_medium"), w - 10 * zclib.wM, h - 25 * zclib.hM, zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

					draw.SimpleText(fuelData.name, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 25 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				cam.End2D()
			end
		end

		for fuel_id, fuel_amount in pairs(FuelInventory) do

			if fuel_amount == nil or fuel_amount <= 0 then continue end

			local fuelData = zrush.Fuel.GetData(fuel_id)
			if fuelData == nil then continue end

			if SELECTED_FUEL == nil then SELECTED_FUEL = fuel_id end

			local itm = list:Add("DButton")
			itm:SetSize(310 * zclib.wM, 44 * zclib.hM)
			itm:SetAutoDelete(true)
			itm:SetText("")
			itm.Paint = function(s, w, h)

				if fuel_id == SELECTED_FUEL then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
				else
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
				end


				local panelcolor = fuelData.color
				if (fuel_id == SELECTED_FUEL) then
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.75)
				else
					surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.05)
				end
				surface.SetMaterial(zrush.default_materials["barrel_icon"])
				surface.DrawTexturedRect(w - h * 0.88, h * 0.1, h * 0.8, h * 0.8)

				draw.SimpleText(fuelData.name, zclib.GetFont("zclib_font_small"), 10 * zclib.wM, h / 2, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(fuel_amount .. zrush.config.UoM, zclib.GetFont("zclib_font_small"), w - h - 5 * zclib.wM, h / 2, zclib.colors["text01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

				if s:IsHovered() then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
				end
			end
			itm.DoClick = function()
				surface.PlaySound("zrush/zrush_command.wav")
				SELECTED_FUEL = fuel_id
				UpdateInfoPanel(RightPanel,fuel_id)
			end
		end


		if SELECTED_FUEL then
			UpdateInfoPanel(RightPanel,SELECTED_FUEL)
		end
	end)

	if (hasBarrels) then
		CustomNotify(zrush.language["Dialog0" .. math.random(0, 9)], 6)
	else
		CustomNotify(zrush.language["NoFuel"], 5)
	end
end
