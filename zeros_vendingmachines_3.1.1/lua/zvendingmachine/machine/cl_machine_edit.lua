if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Actions = zvm.Actions or {}

// The Config Button
function zvm.Machine.ConfigButton(Machine)
	zclib.Debug("zvm.Machine.ConfigButton")

	if IsValid(Machine) and Machine.VGUI and IsValid(Machine.VGUI.ConfigButton) then
		Machine.VGUI.ConfigButton:Remove()
	end

	Machine.VGUI.ConfigButton = vgui.Create("DButton", Machine.VGUI.Main)
	Machine.VGUI.ConfigButton:SetPos(336 / zvm.Machine.util.sm, 58 / zvm.Machine.util.sm)
	Machine.VGUI.ConfigButton:SetSize(60 / zvm.Machine.util.sm, 60 / zvm.Machine.util.sm)
	Machine.VGUI.ConfigButton:SetAutoDelete(true)
	Machine.VGUI.ConfigButton:SetText("")
	Machine.VGUI.ConfigButton.Paint = function(s, w, h)

		if s:IsEnabled() then
			if s.Hovered then
				surface.SetDrawColor(zvm.colors["green04"])
				surface.SetMaterial(zclib.Materials.Get("edit"))
				surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 45 * RealTime())
			else
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zclib.Materials.Get("edit"))
				surface.DrawTexturedRect(0, 0, w, h)
			end
		else

			surface.SetDrawColor(zvm.colors["grey02"])
			surface.SetMaterial(zclib.Materials.Get("edit"))
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	Machine.VGUI.ConfigButton.DoClick = function()

		if zclib.Player.IsOwner(LocalPlayer(), Machine) == false and zclib.Player.IsAdmin(LocalPlayer()) == false then
			return
		end

		if IsValid(Machine:GetMachineUser()) and Machine:GetMachineUser() ~= LocalPlayer() then
			zvm.Warning(LocalPlayer(),zvm.language.General["Occupied"])
			return
		end
		zvm.Actions.OpenConfigMenu(Machine)
	end
end

// The Config Interface
function zvm.Machine.ConfigInterface(Machine)
	zclib.Debug("zvm.Machine.ConfigInterface")

	if Machine.VGUI and IsValid(Machine.VGUI.Content) then Machine.VGUI.Content:Remove() end
	Machine.VGUI.Content = zvm.Machine.util.Page(Machine.VGUI.Main)

	local Title = vgui.Create("DLabel",Machine.VGUI.Content)
	Title:SetPos(0,10 / zvm.Machine.util.sm)
	Title:SetSize(300 / zvm.Machine.util.sm, 40 / zvm.Machine.util.sm)
	Title:SetContentAlignment(5)
	Title:SetFont( zclib.GetFont("zvm_interface_title") )
	Title:SetText(zvm.language.General["Edit"])

	local EditProductList = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["EditProducts"],function()
		zvm.Actions.EditProductList(Machine)
	end)
	EditProductList:SetPos(50 / zvm.Machine.util.sm, 70 / zvm.Machine.util.sm)

	local btn_order = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["DisplayOrder"],function()
		zvm.vgui.DisplayOrderChanger(Machine)
	end,nil,nil,function()
		return false
	end)
	btn_order:SetPos(50 / zvm.Machine.util.sm, 140 / zvm.Machine.util.sm)


	local Customize = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Customization"],function()
		Machine.LastMachineName = Machine.MachineName

		zvm.Machine.EditAppearance(Machine)
	end)
	Customize:SetPos(50 / zvm.Machine.util.sm, 210 / zvm.Machine.util.sm)

	if zclib.Player.IsAdmin(LocalPlayer()) then
		local preset_btn = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Presets"],function()
			// Tell the SERVER that you wanna get a list of all the presets
			zvm.Machine.RequestPresets(Machine)
		end)
		preset_btn:SetPos(50 / zvm.Machine.util.sm, 280 / zvm.Machine.util.sm)

		local Back = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Back"],function()
			zvm.Actions.ExitConfig(Machine)
		end)
		Back:SetPos(50 / zvm.Machine.util.sm, 350 / zvm.Machine.util.sm)
	else
		local Back = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Back"],function()
			zvm.Actions.ExitConfig(Machine)
		end)
		Back:SetPos(50 / zvm.Machine.util.sm, 280 / zvm.Machine.util.sm)
	end

	if Machine:GetPublicMachine() == false then
		local Earnings_Title = vgui.Create("DLabel",Machine.VGUI.Content)
		Earnings_Title:SetPos(0,500 / zvm.Machine.util.sm)
		Earnings_Title:SetSize(300 / zvm.Machine.util.sm, 40 / zvm.Machine.util.sm)
		Earnings_Title:SetContentAlignment(5)
		Earnings_Title:SetFont( zclib.GetFont("zvm_interface_title") )
		Earnings_Title:SetText(zvm.language.General["Payout"])

		// Applys the product config
		local Earnings_Payout = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.Money.Display(Machine:GetEarnings() or 0,zvm.config.Currency[Machine.MoneyType]),function(btn)
			if Machine:GetEarnings() > 0 then
				zvm.Actions.RequestPayout(Machine)
				btn.Text = zvm.Money.Display(0,zvm.config.Currency[Machine.MoneyType])
			end
		end,true,zvm.colors["green01"],function() return Machine:GetEarnings() <= 0 end)
		Earnings_Payout:SetPos(50 / zvm.Machine.util.sm, 560 / zvm.Machine.util.sm)
	else
		if zclib.Player.IsAdmin(LocalPlayer()) then


			local Global_Title = vgui.Create("DLabel",Machine.VGUI.Content)
			Global_Title:SetPos(0,460 / zvm.Machine.util.sm)
			Global_Title:SetSize(300 / zvm.Machine.util.sm, 40 / zvm.Machine.util.sm)
			Global_Title:SetContentAlignment(5)
			Global_Title:SetFont( zclib.GetFont("zvm_interface_title") )
			Global_Title:SetText(zvm.language.General["Global"])


			local save_btn = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Save All"],function()
				zvm.Actions.Save()
			end)
			save_btn:SetPos(50 / zvm.Machine.util.sm, 525 / zvm.Machine.util.sm)
		end
	end
end

// Interface for editing the products
function zvm.Machine.EditProduct(Machine)
	zclib.Debug("zvm.Machine.EditProduct")

	if Machine.VGUI and IsValid(Machine.VGUI.Content) then Machine.VGUI.Content:Remove() end
	Machine.VGUI.Content = zvm.Machine.util.Page(Machine.VGUI.Main)

	local Title = vgui.Create("DLabel",Machine.VGUI.Content)
	Title:SetPos(0,10 / zvm.Machine.util.sm)
	Title:SetSize(300 / zvm.Machine.util.sm, 40 / zvm.Machine.util.sm)
	Title:SetContentAlignment(5)
	Title:SetFont( zclib.GetFont("zvm_interface_title") )
	Title:SetText(zvm.language.General["Products"])

	// Creates the list of products
	zvm.Machine.EditProductList(Machine)

	// Creates the controlls for the selected item
	zvm.Machine.EditControlls(Machine)
end

function zvm.Machine.EditProductList(Machine)
	zclib.Debug("zvm.Machine.EditProductList")
	if IsValid(Machine) and Machine.VGUI and IsValid(Machine.VGUI.ConfigPanel) then Machine.VGUI.ConfigPanel:Remove() end

	Machine.VGUI.ConfigPanel = vgui.Create("DPanel",Machine.VGUI.Content)
	Machine.VGUI.ConfigPanel:SetPos(0, 50 / zvm.Machine.util.sm)
	Machine.VGUI.ConfigPanel:SetSize(320 / zvm.Machine.util.sm, 290 / zvm.Machine.util.sm)
	Machine.VGUI.ConfigPanel.Paint = function(s, w, h) draw.RoundedBox(0, 0 , 0, w, h,  zclib.colors["black_a100"]) end

	local scrollpanel = zvm.Machine.util.ScrollPanel(Machine.VGUI.ConfigPanel)

	local list = vgui.Create("DIconLayout", scrollpanel)
	list:SetSize(280 / zvm.Machine.util.sm, 450 / zvm.Machine.util.sm) //280 400
	list:SetPos(0 , 0 )
	list:SetSpaceY(3  / zvm.Machine.util.sm)
	list:SetAutoDelete(true)
	list.Paint = function(s, w, h) end

	local ItemHeight = 20 / zvm.Machine.util.sm

	local count = 0
	local IsPublic = Machine:GetPublicMachine()
	for k, v in pairs(Machine.Products) do
		count = count + 1
		if zvm.Machine.util.PageCheck(Machine,count) then continue end

		local itm_pnl = list:Add("DButton")
		itm_pnl:SetSize(list:GetWide(), ItemHeight)
		itm_pnl:SetAutoDelete(true)
		itm_pnl:SetText("")
		itm_pnl.Paint = function(s, w, h)

			if Machine.SelectedItem == k then
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2 / zvm.Machine.util.sm, zvm.colors["green05"])
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["green05"])
			else
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2 / zvm.Machine.util.sm, zvm.colors["grey03"])
			end

			draw.SimpleText(zvm.Money.Display(v.price,zvm.config.Currency[Machine.MoneyType]), zclib.GetFont("zvm_interface_item"), 255 / zvm.Machine.util.sm, h / 2, color_white, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)

			surface.SetDrawColor(Either(zvm.Machine.HasRankRestriction(v),zvm.colors["yellow01"],zvm.colors["grey04"]))
			surface.SetMaterial(zvm.materials["product_res_rank"])
			surface.DrawTexturedRect(ItemHeight + 8 / zvm.Machine.util.sm, 2.5 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm)

			surface.SetDrawColor(Either(zvm.Machine.HasJobRestriction(v),zvm.colors["blue02"],zvm.colors["grey04"]))
			surface.SetMaterial(zvm.materials["product_res_job"])
			surface.DrawTexturedRect(ItemHeight + 20 / zvm.Machine.util.sm, 2.5 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm)

			if s.Hovered then draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white03"]) end
		end
		itm_pnl.DoClick = function()
			// Select Product Item
			zvm.Actions.SelectedConfigItem(k,Machine)
		end

		local imgpnl = vgui.Create("DImage",itm_pnl)
		imgpnl:SetSize(ItemHeight,ItemHeight)
        imgpnl:Dock(LEFT)
		imgpnl:DockMargin(4 / zvm.Machine.util.sm, 2 / zvm.Machine.util.sm, 0 / zvm.Machine.util.sm, 2 / zvm.Machine.util.sm)

		// Lets check if the panel should be modified in some other way then usual
		local CustomUpdate = hook.Run("zvm_Overwrite_IdleImage",imgpnl,v)
		if CustomUpdate == nil then
			// If no change occured then lets just give it the model image
			local img = zclib.Snapshoter.Get(v,imgpnl)
			if img then
				imgpnl:SetImage(img)
			else
				imgpnl:SetImage("materials/zerochain/zerolib/ui/icon_loading.png")
			end
		end

		local lbl = vgui.Create("DLabel", itm_pnl)
		lbl:Dock(LEFT)
		lbl:SetSize(170 / zvm.Machine.util.sm, 40 / zvm.Machine.util.sm)
		lbl:DockMargin(35 / zvm.Machine.util.sm, 2 / zvm.Machine.util.sm, 90 / zvm.Machine.util.sm, 2 / zvm.Machine.util.sm)
		lbl:SetContentAlignment(4)
		lbl:SetFont(zclib.GetFont("zvm_interface_item"))
		lbl:SetText(Either(IsPublic, v.name, v.amount .. "x " .. v.name))
		lbl:SetTextColor(color_white)
		lbl.DoClick = function()
			// Select Product Item
			zvm.Actions.SelectedConfigItem(k,Machine)
		end

		local DeleteButton = vgui.Create("DButton", itm_pnl)
		DeleteButton:SetSize(ItemHeight,ItemHeight)
		DeleteButton:SetPos(261 / zvm.Machine.util.sm, 0 )
		DeleteButton:SetAutoDelete(true)
		DeleteButton:SetText("")
		DeleteButton.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zvm.colors["red01"])

			surface.SetDrawColor(color_white)
			surface.SetMaterial(zclib.Materials.Get("close"))
			surface.DrawTexturedRect(0, 0,w, h)

			if s.Hovered then draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"]) end
		end
		DeleteButton.DoClick = function()
			zvm.Actions.RemoveProduct(Machine,k)
		end
	end
end

function zvm.Machine.EditControlls(Machine)
	zclib.Debug("zvm.Machine.EditControlls")

	local btn_prev = zvm.Machine.util.PageButton(Machine.VGUI.Content,"back",0,function()

		// Go to left zvm.Machine.util.Page
		Machine.Page = Machine.Page - 1
		zvm.Machine.EditProductList(Machine)
		//zvm.Actions.EditProductList(Machine)
	end,function()
		// Is there a left zvm.Machine.util.Page?
		return Machine.Page <= 1
	end)
	btn_prev:SetPos(50 / zvm.Machine.util.sm, 350 / zvm.Machine.util.sm)


	local btn_next = zvm.Machine.util.PageButton(Machine.VGUI.Content,"back",180,function()

		// Go to right zvm.Machine.util.Page
		Machine.Page = Machine.Page + 1
		zvm.Machine.EditProductList(Machine)
		//zvm.Actions.EditProductList(Machine)
	end,function()
		// Is there a right zvm.Machine.util.Page?
		return Machine.Page >= zvm.Machine.util.GetPageCount(Machine)
	end)
	btn_next:SetPos(200 / zvm.Machine.util.sm, 350 / zvm.Machine.util.sm)


	local indicator = zvm.Machine.util.PageIndicator(Machine.VGUI.Content,Machine)
	indicator:SetPos(110 / zvm.Machine.util.sm, 350 / zvm.Machine.util.sm)
	indicator:SetSize(80 / zvm.Machine.util.sm, 50 / zvm.Machine.util.sm)

	//824619309
	if Machine:GetPublicMachine() or zclib.Player.IsAdmin(LocalPlayer()) then
		// Opens the restrictions derma interface
		local btn_restrict = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Restrictions"],function()
			zvm.vgui.RestrictionChanger(Machine)
		end,nil,nil,function()
			return Machine.SelectedItem == -1 or hook.Run("zvm_BlockRestrictionsEditor",Machine)
		end)
		btn_restrict:SetPos(50 / zvm.Machine.util.sm, 410 / zvm.Machine.util.sm)
		btn_restrict:SetTall(40 / zvm.Machine.util.sm)
	end

	// Opens the Appearence derma interface
	local btn_appearance = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Appearance"],function()
		zvm.vgui.AppearanceChanger(Machine)
	end,nil,nil,function()
		return Machine.SelectedItem == -1 or hook.Run("zvm_BlockAppearanceEditor",Machine)
	end)
	btn_appearance:SetPos(50 / zvm.Machine.util.sm, 460 / zvm.Machine.util.sm)
	btn_appearance:SetTall(40 / zvm.Machine.util.sm)

	// Opens the Price derma Interface
	local btn_price = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["ChangePrice"],function()
		zvm.vgui.PriceChanger(Machine)
	end,nil,nil,function()
		return Machine.SelectedItem == -1 or hook.Run("zvm_BlockPriceEditor",Machine)
	end)
	btn_price:SetPos(50 / zvm.Machine.util.sm, 510 / zvm.Machine.util.sm)
	btn_price:SetTall(40 / zvm.Machine.util.sm)

	// Applys the product config
	local ApplyConfig = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Apply"],function()
		zvm.Actions.ApplyProductList(Machine)
	end,true,zvm.colors["green01"])
	ApplyConfig:SetPos(50 / zvm.Machine.util.sm, 560 / zvm.Machine.util.sm)
end


////////////////////////////////////////////


// Creates the entity Customization menu
function zvm.Machine.EditAppearance(Machine)
	zclib.Debug("zvm.Machine.EditAppearance")

	if Machine.VGUI and IsValid(Machine.VGUI.Content) then Machine.VGUI.Content:Remove() end

	Machine.VGUI.Content = zvm.Machine.util.Page(Machine.VGUI.Main)

	local Title = vgui.Create("DLabel",Machine.VGUI.Content)
	Title:SetPos(0,25 / zvm.Machine.util.sm)
	Title:SetSize(300 / zvm.Machine.util.sm, 40 / zvm.Machine.util.sm)
	Title:SetContentAlignment(5)
	Title:SetFont( zclib.GetFont("zvm_interface_title") )
	Title:SetText(zvm.language.General["Customization"])

	// Display the current machine style
	local imgpnl = vgui.Create("DImage", Machine.VGUI.Content)
	imgpnl:SetSize(180 / zvm.Machine.util.sm, 180 / zvm.Machine.util.sm)
	local img = zclib.Snapshoter.Get({
		class = "zvm_machine",
		model = "models/zerochain/props_vendingmachine/zvm_machine.mdl",
		StyleID = zvm.Machine.GetUniqueStyleID(Machine:GetStyleID())
	}, imgpnl)
	imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	imgpnl:SetPos(60 / zvm.Machine.util.sm, 55 / zvm.Machine.util.sm)

	local line = vgui.Create("DImage", Machine.VGUI.Content)
	line:SetSize(150 / zvm.Machine.util.sm, 3 / zvm.Machine.util.sm)
	line:SetPos(75 / zvm.Machine.util.sm, 315 / zvm.Machine.util.sm)
	line.Paint = function(s, w, h)
		draw.RoundedBox(0, 0 , 0, w, h,  color_white)
	end

	// Add change color button
	local AppearanceEditor = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["AppearanceEditor"],function()
		zvm.Machine.Editor.MainMenu(Machine)
	end)
	AppearanceEditor:SetPos(50 / zvm.Machine.util.sm, 250 / zvm.Machine.util.sm)

	local ChangeMachineName = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["ChangeName"],function()
		zvm.vgui.MachineNameChanger(Machine)
	end)
	ChangeMachineName:SetPos(50 / zvm.Machine.util.sm, 335 / zvm.Machine.util.sm)

	// If the player is a admin then we allow to change the moneytype
	if zclib.Player.IsAdmin(LocalPlayer()) then
		local ChangeMachineMoneyType = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["ChangeCurrency"],function()
			zvm.vgui.CurrencyChanger(Machine)
		end)
		ChangeMachineMoneyType:SetPos(50 / zvm.Machine.util.sm, 395 / zvm.Machine.util.sm)
	end

	local ApplyConfig = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Apply"],function()
		zvm.Actions.ApplyAppearance(Machine)
	end,true,zvm.colors["green01"])
	ApplyConfig:SetPos(50 / zvm.Machine.util.sm, 465 / zvm.Machine.util.sm)

	local Back = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Back"],function()
		zvm.Actions.CloseEditAppearance(Machine)
	end)
	Back:SetPos(50 / zvm.Machine.util.sm, 525 / zvm.Machine.util.sm)
end

// Sends a net msg to server that the machine appearance got changed
function zvm.Actions.ApplyAppearance(Machine)
	zclib.Debug("zvm.Actions.ApplyAppearance")
	surface.PlaySound("UI/buttonclick.wav")

	net.Start("zvm_Machine_Appearance_Update")
	net.WriteEntity(Machine)
	net.WriteString(Machine.MachineName)
	net.WriteUInt(Machine.MoneyType,32)
	net.SendToServer()

	zvm.Machine.ConfigInterface(Machine)
end

// Closes the appearance interface
function zvm.Actions.CloseEditAppearance(Machine)
	zclib.Debug("zvm.Actions.CloseEditAppearance")
	surface.PlaySound("UI/buttonclick.wav")

	// Revert Appearance
	Machine.MachineName = Machine.LastMachineName

	zvm.Machine.ConfigInterface(Machine)
end

// Change machine name
function zvm.Actions.ChangeMachineName(Machine,name)
	zclib.Debug("zvm.Actions.ChangeProductName")
	if isstring(name) == false then return end
	surface.PlaySound("UI/buttonclick.wav")

	Machine.MachineName = name
end

// Change machine currency
function zvm.Actions.ChangeMachineCurrency(Machine,moneytype)
	zclib.Debug("zvm.Actions.ChangeMachineCurrency: " .. moneytype)
	surface.PlaySound("UI/buttonclick.wav")

	Machine.MoneyType = moneytype
end

function zvm.Actions.ChangeDisplayOrder(Machine,id01,id02)
	surface.PlaySound("UI/buttonclick.wav")

	zvm.Machine.SwitchProducts(Machine, id01,id02)

	net.Start("zvm_Machine_ProductList_ChangeOrder")
	net.WriteEntity(Machine)
	net.WriteUInt(id01, 16)
	net.WriteUInt(id02, 16)
	net.SendToServer()
end

// Changes machines skin
function zvm.Actions.ChangeSkin(Machine,skin)
	zclib.Debug("zvm.Actions.ChangeSkin")
	surface.PlaySound("UI/buttonclick.wav")

	Machine:SetSkin(skin-1)
end

// Changes machine color
function zvm.Actions.ChangeColor(Machine,color)
	zclib.Debug("zvm.Actions.ChangeColor")
	surface.PlaySound("UI/buttonclick.wav")

	Machine:SetColor(color)
end


////////////////////////////////////////////


// Changes the buy menu to the config menu
function zvm.Actions.OpenConfigMenu(Machine)
	zclib.Debug("zvm.Actions.OpenConfigMenu")
	surface.PlaySound("UI/buttonclick.wav")

	Machine.VGUI.ConfigButton:SetEnabled(false)

	// Calls NW Msg to set entity in to editing mode
	net.Start("zvm_Machine_EditMode_Request")
	net.WriteEntity(Machine)
	net.SendToServer()

	zvm.Machine.ConfigInterface(Machine)
end

// Changes the config menu to the buy menu
function zvm.Actions.CloseConfigMenu(Machine)
	zclib.Debug("zvm.Actions.CloseConfigMenu")
	surface.PlaySound("UI/buttonclick.wav")

	Machine.VGUI.ConfigButton:SetEnabled(true)

	zvm.Machine.IdleInterface(Machine)
end

// Tell the server that this machine is being edited
function zvm.Actions.EditProductList(Machine)
	zclib.Debug("zvm.Actions.EditProductList")

	// Calls NW Msg to set entity in to editing mode
	net.Start("zvm_Machine_AllowCollision_Request")
	net.WriteEntity(Machine)
	net.WriteBool(true)
	net.SendToServer()

	zvm.Machine.EditProduct(Machine)
end


// Sends a net msg to server that the machine productlist got changed
function zvm.Actions.ApplyProductList(Machine)
	zclib.Debug("zvm.Actions.ApplyProductList")
	surface.PlaySound("UI/buttonclick.wav")

	net.Start("zvm_Machine_ProductList_Finished")
	net.WriteEntity(Machine)
	net.SendToServer()

	zvm.Machine.ConfigInterface(Machine)
end

// Selects a item from the config product list
function zvm.Actions.SelectedConfigItem(itemid,Machine)
	zclib.Debug("zvm.Actions.SelectedConfigItem: " .. itemid)
	surface.PlaySound("UI/buttonclick.wav")

	if Machine.SelectedItem and Machine.SelectedItem == itemid then
		Machine.SelectedItem = -1
		return
	end

	Machine.SelectedItem = itemid
end


////////////////////////////////////////////


// Changes a product buy restriction
function zvm.Actions.ChangeProductRestriction(Machine,rankid,jobid)
	zclib.Debug("zvm.Actions.ChangeProductRestriction")
	surface.PlaySound("UI/buttonclick.wav")

	// Updates the productlist on the server
	net.Start("zvm_Machine_ProductList_ChangeRestriction")
	net.WriteEntity(Machine)
	net.WriteUInt(Machine.SelectedItem, 16)
	net.WriteInt(rankid or -1, 16)
	net.WriteInt(jobid or -1, 16)
	net.SendToServer()
end

// Changes a product name or bg color
function zvm.Actions.ChangeProductAppearence(Machine,name,bg_color)
	zclib.Debug("zvm.Actions.ChangeProductAppearence")
	surface.PlaySound("UI/buttonclick.wav")

	net.Start("zvm_Machine_ProductList_ChangeAppearance")
	net.WriteEntity(Machine)
	net.WriteUInt(Machine.SelectedItem, 16)
	net.WriteString(name)
	net.WriteColor(bg_color)
	net.SendToServer()
end

// Changes a product price
function zvm.Actions.ChangeProductPrice(Machine,price)
	zclib.Debug("zvm.Actions.ChangeProductPrice")
	if isnumber(price) == false then return end
	surface.PlaySound("UI/buttonclick.wav")

	net.Start("zvm_Machine_ProductList_ChangePrice")
	net.WriteEntity(Machine)
	net.WriteUInt(Machine.SelectedItem, 16)
	net.WriteUInt(price, 32)
	net.SendToServer()
end

// Removes the product from the list
function zvm.Actions.RemoveProduct(Machine,productid)
	zclib.Debug("zvm.Actions.RemoveProduct")
	surface.PlaySound("UI/buttonclick.wav")

	net.Start("zvm_Machine_ProductList_RemoveItem")
	net.WriteEntity(Machine)
	net.WriteUInt(productid, 16)
	net.SendToServer()

	// Resets the selection
	zvm.Actions.ResetSelections(Machine)
end

// Sends the config to the server
function zvm.Actions.ExitConfig(Machine)
	zclib.Debug("zvm.Actions.ExitConfig")

	net.Start("zvm_Machine_Edit_Finished")
	net.WriteEntity(Machine)
	net.SendToServer()

	zvm.Actions.ResetSelections(Machine)

	// Close config
	zvm.Actions.CloseConfigMenu(Machine)

	// Switch to idle interface
	zvm.Machine.IdleInterface(Machine)
end

// Sends the config to the server
function zvm.Actions.Save()
	zclib.Debug("zvm.Actions.Save")

	net.Start("zvm_Machine_Save")
	net.SendToServer()
end
