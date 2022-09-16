if not CLIENT then return end
zvm = zvm or {}
zvm.vgui = zvm.vgui or {}

LocalPlayer().zvm_Machine = nil
LocalPlayer().zvm_ItemData = nil

local function ItemDataIsValid()
	local machine = LocalPlayer().zvm_Machine

	if IsValid(machine) and machine.Products and machine.SelectedItem and machine.Products[machine.SelectedItem] then
		LocalPlayer().zvm_ItemData = machine.Products[machine.SelectedItem]

		return true
	else
		zvm.Warning(LocalPlayer(),"ItemData could not be found!")
		return false
	end
end

function zvm.vgui.RestrictionChanger(Machine)
	LocalPlayer().zvm_Machine = Machine
	if ItemDataIsValid() == false then return end

	zvm.vgui.OptionPage(zvm.language.General["Restrictions"], function(main)
		main:SetSize(600 * zclib.wM, 400 * zclib.hM)
		main:Center()


		zvm.vgui.Title(main, zvm.language.General["ChangeRank"], "zvm_derma_textentry01", 75)
		local ComboBoxPanel_Rank = vgui.Create("DComboBox", main)
		ComboBoxPanel_Rank:SetPos(25 * zclib.wM, 100 * zclib.hM)
		ComboBoxPanel_Rank:SetSize(550 * zclib.wM, 40 * zclib.hM)
		ComboBoxPanel_Rank:AddChoice(zvm.language.General["None"], nil)

		local _RankID = LocalPlayer().zvm_ItemData.rankid
		for i = 1, #zvm.config.Vendingmachine.RankGroups do ComboBoxPanel_Rank:AddChoice(zvm.config.Vendingmachine.RankGroups[i].name, i) end

		if zvm.Machine.HasRankRestriction(LocalPlayer().zvm_ItemData) then
			ComboBoxPanel_Rank:ChooseOption(zvm.config.Vendingmachine.RankGroups[_RankID].name, _RankID)
		else
			ComboBoxPanel_Rank:ChooseOption(zvm.language.General["None"], nil)
		end

		zvm.vgui.Title(main, zvm.language.General["ChangeJob"], "zvm_derma_textentry01", 175)
		local ComboBoxPanel_Job = vgui.Create("DComboBox", main)
		ComboBoxPanel_Job:SetPos(25 * zclib.wM, 200 * zclib.hM)
		ComboBoxPanel_Job:SetSize(550 * zclib.wM, 40 * zclib.hM)
		ComboBoxPanel_Job:AddChoice(zvm.language.General["None"], nil)

		local _JobID = LocalPlayer().zvm_ItemData.jobid
		for i = 1, #zvm.config.Vendingmachine.JobGroups do ComboBoxPanel_Job:AddChoice(zvm.config.Vendingmachine.JobGroups[i].name, i) end

		if zvm.Machine.HasJobRestriction(LocalPlayer().zvm_ItemData) then
			ComboBoxPanel_Job:ChooseOption(zvm.config.Vendingmachine.JobGroups[_JobID].name, _JobID)
		else
			ComboBoxPanel_Job:ChooseOption(zvm.language.General["None"], nil)
		end

		local Select_Button = zvm.vgui.Button(main, function()
			local _, _rank = ComboBoxPanel_Rank:GetSelected()
			local _, _job = ComboBoxPanel_Job:GetSelected()
			zvm.Actions.ChangeProductRestriction(LocalPlayer().zvm_Machine, _rank, _job)
			main:Remove()
		end)
		Select_Button:SetPos(25 * zclib.wM, 325 * zclib.hM)
		Select_Button:SetSize(550 * zclib.wM, 50 * zclib.hM)
	end)
end

function zvm.vgui.AppearanceChanger(Machine)
	LocalPlayer().zvm_Machine = Machine
	if ItemDataIsValid() == false then return end

	zvm.vgui.OptionPage(zvm.language.General["Appearance"], function(main)
		main:SetSize(600 * zclib.wM, 525 * zclib.hM)
		main:Center()
		local Elements = {}
		zvm.vgui.Title(main, zvm.language.General["ChangeName"], "zvm_derma_textentry01", 50)
		Elements.ItemName = zclib.vgui.TextEntry(main, LocalPlayer().zvm_ItemData.name, function(val) end, false)
		Elements.ItemName:SetPos(25 * zclib.wM, 75 * zclib.hM)
		Elements.ItemName:SetSize(550 * zclib.wM, 50 * zclib.hM)
		Elements.ItemName:SetValue(LocalPlayer().zvm_ItemData.name)

		// If we dont allow the change of itemnames then we disable this field
		if zclib.Player.IsAdmin(LocalPlayer()) == false and zvm.config.Vendingmachine.NameChange == false then
			Elements.ItemName:SetDisabled(true)
		end

		zvm.vgui.Title(main, zvm.language.General["ChangeBackgroundColor"], "zvm_derma_textentry01", 150)

		Elements.BGColor_Mixer = zvm.vgui.ColorMixer(main, LocalPlayer().zvm_ItemData.bg_color, function(val)
			Elements.BGColor_Display:SetColor(val)
		end)
		Elements.BGColor_Mixer:SetSize(270 * zclib.wM, 250 * zclib.hM)
		Elements.BGColor_Mixer:SetPos(25 * zclib.wM, 180 * zclib.hM)

		Elements.BGColor_Display = vgui.Create("DColorButton", main)
		Elements.BGColor_Display:SetPos(325 * zclib.wM, 180 * zclib.hM)
		Elements.BGColor_Display:SetSize(250 * zclib.wM, 250 * zclib.hM)
		Elements.BGColor_Display:SetColor(LocalPlayer().zvm_ItemData.bg_color or zvm.colors["blue03"])
		Elements.BGColor_Display.Paint = function(s, w, h)
			surface.SetDrawColor(s:GetColor())
			surface.SetMaterial(zclib.Materials.Get("item_bg"))
			surface.DrawTexturedRect(0, 0, w, h)
		end

		Elements.ItemMDLDisplay = vgui.Create("DImage", Elements.BGColor_Display)
		Elements.ItemMDLDisplay:Dock(FILL)
		Elements.ItemMDLDisplay:SetAutoDelete(true)
		local img = zclib.Snapshoter.Get(LocalPlayer().zvm_ItemData,Elements.ItemMDLDisplay)
		if img then
			Elements.ItemMDLDisplay:SetImage(img)
		else
			Elements.ItemMDLDisplay:SetImage("materials/zerochain/zerolib/ui/icon_loading.png")
		end

		//824619309

		Elements.Apply_Button = zvm.vgui.Button(main, function()
			local newColor = Elements.BGColor_Display:GetColor()
			newColor = Color(newColor.r,newColor.g,newColor.b)
			local newName = Elements.ItemName:GetValue()
			if newName == nil or newName == "" or string.len(newName) <= 1 then newName = "Item" end
			zvm.Actions.ChangeProductAppearence(LocalPlayer().zvm_Machine, newName, newColor)
			main:Remove()
		end)
		Elements.Apply_Button:SetPos(25 * zclib.wM, 450 * zclib.hM)
		Elements.Apply_Button:SetSize(550 * zclib.wM, 50 * zclib.hM)
	end)
end

function zvm.vgui.CurrencyChanger(Machine)
	LocalPlayer().zvm_Machine = Machine

	zvm.vgui.OptionPage(zvm.language.General["CurrencyType"], function(main)
		main:SetSize(600 * zclib.wM, 300 * zclib.hM)
		main:Center()
		local Elements = {}
		local _MoneyType = LocalPlayer().zvm_Machine.MoneyType

		--[[
		1 = Money
		2 = PS Points
		3 = PS2 Points
		4 = PS2 PremiumPoints
		]]
		local MoneyTypes = {
			[1] = {
				id = 1,
				name = zvm.language.General["Money"]
			},
			[2] = {
				id = 2,
				name = "PS Points (Requires Pointshop)"
			},
			[3] = {
				id = 3,
				name = "PS2 Points (Requires Pointshop 2)"
			},
			[4] = {
				id = 4,
				name = "PS2 PremiumPoints (Requires Pointshop 2)"
			}
		}

		Elements.ComboBoxPanel_Moneytype = vgui.Create("DComboBox", main)
		Elements.ComboBoxPanel_Moneytype:SetPos(25 * zclib.wM, 60 * zclib.hM)
		Elements.ComboBoxPanel_Moneytype:SetSize(550 * zclib.wM, 40 * zclib.hM)

		Elements.ComboBoxPanel_Moneytype.OnSelect = function(s, index, value)
			local _, data = Elements.ComboBoxPanel_Moneytype:GetSelected()

			if data then
				_MoneyType = data
			else
				_MoneyType = 1
			end
		end

		for i = 1, #MoneyTypes do
			Elements.ComboBoxPanel_Moneytype:AddChoice(MoneyTypes[i].name, MoneyTypes[i].id)
		end

		if _MoneyType == 1 then
			Elements.ComboBoxPanel_Moneytype:ChooseOption(zvm.language.General["Money"], 1)
		else
			Elements.ComboBoxPanel_Moneytype:ChooseOption(MoneyTypes[_MoneyType].name, _MoneyType)
		end


		Elements.Select_Button = zvm.vgui.Button(main, function()
			zvm.Actions.ChangeMachineCurrency(LocalPlayer().zvm_Machine, _MoneyType)
			main:Remove()
		end)
		Elements.Select_Button:SetPos(25 * zclib.wM, 225 * zclib.hM)
		Elements.Select_Button:SetSize(550 * zclib.wM, 50 * zclib.hM)
	end)
end

function zvm.vgui.PriceChanger(Machine)
	LocalPlayer().zvm_Machine = Machine
	if ItemDataIsValid() == false then return end

	zvm.vgui.OptionPage(zvm.language.General["ChangePrice"], function(main)
		main:SetSize(600 * zclib.wM, 110 * zclib.hM)
		main:Center()

		local TextEntryPanel = zclib.vgui.TextEntry(main, LocalPlayer().zvm_ItemData.price, function(val) end, true, function(val)
			local price = val

			if string.len(price) > 12 then
				price = "99999999999"
			end

			price = tonumber(price) or 100
			price = math.Clamp(price, 1, 99999999999)
			zvm.Actions.ChangeProductPrice(LocalPlayer().zvm_Machine, price)
			main:Remove()
		end)
		TextEntryPanel:SetNumeric(true)
		TextEntryPanel:SetPos(25 * zclib.wM, 45 * zclib.hM)
		TextEntryPanel:SetSize(550 * zclib.wM, 50 * zclib.hM)
	end)
end

function zvm.vgui.ColorChanger(Machine)
	LocalPlayer().zvm_Machine = Machine

	zvm.vgui.OptionPage(zvm.language.General["CurrencyType"], function(main)
		main:SetSize(400 * zclib.wM, 410 * zclib.hM)
		main:Center()
		local Elements = {}

		Elements.SkinColor_Mixer = zvm.vgui.ColorMixer(main, LocalPlayer().zvm_Machine:GetColor(), function(val)
			Elements.SkinColor_Display:SetColor(val)
			LocalPlayer().zvm_Machine:SetColor(val)
		end)
		Elements.SkinColor_Mixer:SetPos(25 * zclib.wM, 50 * zclib.hM)
		Elements.SkinColor_Mixer:SetSize(350 * zclib.wM, 220 * zclib.hM)

		Elements.SkinColor_Display = vgui.Create("DColorButton", main)
		Elements.SkinColor_Display:SetPos(25 * zclib.wM, 280 * zclib.hM)
		Elements.SkinColor_Display:SetSize(350 * zclib.wM, 45 * zclib.hM)
		Elements.SkinColor_Display:SetColor(LocalPlayer().zvm_Machine:GetColor())


		local Apply_Button = zvm.vgui.Button(main, function()
			zvm.Actions.ChangeColor(LocalPlayer().zvm_Machine, Elements.SkinColor_Mixer:GetColor())
			main:Remove()
		end)
		Apply_Button:SetPos(25 * zclib.wM, 337 * zclib.hM)
		Apply_Button:SetSize(350 * zclib.wM, 50 * zclib.hM)
	end)
end

function zvm.vgui.MachineNameChanger(Machine)
	LocalPlayer().zvm_Machine = Machine

	zvm.vgui.OptionPage(zvm.language.General["ChangeName"], function(main)
		main:SetSize(600 * zclib.wM, 170 * zclib.hM)
		main:Center()
		local Elements = {}

		Elements.TextEntryPanel = zclib.vgui.TextEntry(main, LocalPlayer().zvm_Machine.MachineName, function(val) end)
		Elements.TextEntryPanel:SetPos(25 * zclib.wM, 45 * zclib.hM)
		Elements.TextEntryPanel:SetSize(550 * zclib.wM, 50 * zclib.hM)
		Elements.Apply_Button = zvm.vgui.Button(main, function()
			zvm.Actions.ChangeMachineName(LocalPlayer().zvm_Machine, Elements.TextEntryPanel:GetValue())
			main:Remove()
		end)
		Elements.Apply_Button:SetPos(25 * zclib.wM, 100 * zclib.hM)
		Elements.Apply_Button:SetSize(550 * zclib.wM, 50 * zclib.hM)
	end)
end

function zvm.vgui.DisplayOrderChanger(Machine)
	LocalPlayer().zvm_Machine = Machine

	zvm.vgui.OptionPage(zvm.language.General["DisplayOrder"], function(main)
		main:SetSize(600 * zclib.wM, 800 * zclib.hM)
		main:Center()

		local SelectedItem
		local SelectedPanel

		local function OrderButton(parent,dock, rot, onclick,islocked)
			local btn_down = vgui.Create("DButton", parent)
			btn_down:SetSize(290 * zclib.hM, 40 * zclib.hM)
			//btn_down:SetPos(x, 5 * zclib.hM)
			btn_down:Dock(dock)
			btn_down:SetAutoDelete(true)
			btn_down:SetText("")
			btn_down.Paint = function(s, w, h)
				if islocked() then
					zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["black_a100"])

					surface.SetDrawColor(zclib.colors["black_a100"])
					surface.SetMaterial(zclib.Materials.Get("back"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, h, h, rot)
					return
				end
				if s.Hovered then
					zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)

					surface.SetDrawColor(color_white)
					surface.SetMaterial(zclib.Materials.Get("back"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, h, h, rot)

					draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white03"])
				else
					zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["text01"])

					surface.SetDrawColor(zclib.colors["text01"])
					surface.SetMaterial(zclib.Materials.Get("back"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, h, h, rot)
				end
			end
			btn_down.DoClick = function()
				if islocked() then
					surface.PlaySound("UI/buttonrollover.wav")
					return
				end
				surface.PlaySound("UI/buttonclick.wav")
				pcall(onclick)
			end
		end

		local bottom_pnl = vgui.Create("DPanel", main)
		bottom_pnl:SetSize(535 * zclib.wM, 40 * zclib.hM)
		bottom_pnl:SetAutoDelete(true)
		bottom_pnl:Dock(BOTTOM)
		bottom_pnl.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["text01"])
		end

		local DaList
		local function BuildList()
			if IsValid(DaList) then DaList:Remove() end

			local scroll = vgui.Create("DScrollPanel", main)
			scroll:DockMargin(10 * zclib.wM, 20 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
			scroll:Dock(FILL)
			function scroll:JumpToChild( panel )

				self:InvalidateLayout( true )

				local _, y = self.pnlCanvas:GetChildPosition( panel )
				local _, h = panel:GetSize()

				y = y + h * 0.5
				y = y - self:GetTall() * 0.5

				self.VBar:AnimateTo( y, 0.01, 0, 0.5 )
			end
			DaList = scroll

			local list = vgui.Create("DIconLayout", scroll)
			list:Dock(FILL)
			list:SetSpaceY(4 * zclib.hM)
			list:SetAutoDelete(true)
			list.Paint = function(s, w, h) end

			local count = 0
			local num = 1
			for k, v in pairs(Machine.Products) do

				local bgCol =  v.bg_color or zvm.colors["blue03"]
				local IsPublic = Machine:GetPublicMachine()
				local price = zvm.Money.Display(v.price,zvm.config.Currency[Machine.MoneyType])

				local height = 50

				local itm_pnl = list:Add("DButton")
				itm_pnl:SetSize(535 * zclib.wM, height * zclib.hM)
				itm_pnl:SetAutoDelete(true)
				itm_pnl:SetText("")
				local Anum = num
				itm_pnl.Paint = function(s, w, h)

					surface.SetDrawColor(bgCol)
					surface.SetMaterial(zclib.Materials.Get("item_bg"))
					surface.DrawTexturedRect(0, 0, w, h)

					if IsPublic then
						draw.SimpleText(v.name, zclib.GetFont("zvm_interface_item"), height + 75 * zclib.hM, 15 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					else
						draw.SimpleText(v.amount .. "x " .. v.name, zclib.GetFont("zvm_interface_item"),height + 75 * zclib.hM,15 * zclib.hM, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
					end

					draw.SimpleText(price, zclib.GetFont("zvm_interface_item"), height + 75 * zclib.hM, 25 * zclib.hM, zclib.colors["green01"], TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

					draw.SimpleText( Anum, zclib.GetFont("zvm_interface_item"), 15 * zclib.hM, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.RoundedBox(0, 50 * zclib.wM, 0, 3 * zclib.wM, h, zvm.colors["white03"])

					if zvm.Machine.HasRankRestriction(v) then
						surface.SetDrawColor(zvm.colors["yellow01"])
					else
						surface.SetDrawColor(zclib.colors["black_a100"])
					end
					surface.SetMaterial(zvm.materials["product_res_rank"])
					surface.DrawTexturedRect(height * 1.8, 5 * zclib.hM, 20 * zclib.wM, 20 * zclib.hM)

					if zvm.Machine.HasJobRestriction(v) then
						surface.SetDrawColor(zvm.colors["blue02"])
					else
						surface.SetDrawColor(zclib.colors["black_a100"])
					end
					surface.SetMaterial(zvm.materials["product_res_job"])
					surface.DrawTexturedRect(height * 1.8, 25 * zclib.hM, 20 * zclib.wM, 20 * zclib.hM)

					if SelectedItem == k then
						zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["green01"])
					end

					if s.Hovered then
						draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white03"])
					end
				end
				itm_pnl.DoClick = function()
					SelectedItem = k
					SelectedPanel = itm_pnl
				end
				if SelectedItem and k == SelectedItem then
					SelectedPanel = itm_pnl
				end

				local img_pnl = vgui.Create("DImage", itm_pnl)
				img_pnl:SetSize(height * zclib.hM, height * zclib.hM)
				img_pnl:SetPos(60 * zclib.hM, 0)
				img_pnl:SetAutoDelete(true)

				// Lets check if the panel should be modified in some other way then usual
				local CustomUpdate = hook.Run("zvm_Overwrite_ProductImage",img_pnl,v)
				if CustomUpdate == nil then
					// If no change occured then lets just give it the model image
					local img = zclib.Snapshoter.Get(v,img_pnl)
					if img then
						img_pnl:SetImage(img)
					else
						img_pnl:SetImage("materials/zerochain/zerolib/ui/icon_loading.png")
					end
				end

				count = count + 1
				num = num + 1
				if count >= zvm.Machine.PageItemLimit() then
					local MainPanel = list:Add("DPanel")
					MainPanel:SetSize(535 * zclib.wM, 5 * zclib.hM)
					MainPanel.Paint = function(s, w, h)
						draw.RoundedBox(0, 0, 0, w, h, zvm.colors["grey03"])
					end
					count = 0
				end
			end

			timer.Simple(0,function()
				if IsValid(SelectedPanel) and IsValid(scroll) and scroll.JumpToChild then
					scroll:JumpToChild(SelectedPanel)
				end
			end)
		end
		BuildList()

		// Down
		OrderButton(bottom_pnl,RIGHT,90,function()
			zvm.Actions.ChangeDisplayOrder(Machine,SelectedItem, SelectedItem + 1)
			SelectedItem = SelectedItem + 1

			// Move item down
			BuildList()
		end,function()
			return SelectedItem == nil or Machine.Products[SelectedItem + 1] == nil
		end)

		// Up
		OrderButton(bottom_pnl,LEFT,-90,function()
			zvm.Actions.ChangeDisplayOrder(Machine,SelectedItem, SelectedItem - 1)
			SelectedItem = SelectedItem - 1

			// Move Item up
			BuildList()
		end,function()
			return SelectedItem == nil or Machine.Products[SelectedItem - 1] == nil
		end)
	end)
end
