if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Actions = zvm.Actions or {}

// The Buy Interface
function zvm.Machine.BuyInterface(Machine)
	zclib.Debug("zvm.Machine.BuyInterface")

	if Machine.VGUI and IsValid(Machine.VGUI.Content) then Machine.VGUI.Content:Remove() end

	Machine.VGUI.Content = zvm.Machine.util.Page(Machine.VGUI.Main)

	local btn_prev = zvm.Machine.util.PageButton(Machine.VGUI.Content,"back",0,function()

		// Go to left zvm.Machine.util.Page
		Machine.Page = Machine.Page - 1
		zvm.Machine.BuyInterface(Machine)
	end,function()
		// Is there a left zvm.Machine.util.Page?
		return Machine.Page <= 1
	end)
	btn_prev:SetPos(20 / zvm.Machine.util.sm, 495 / zvm.Machine.util.sm)


	local btn_next = zvm.Machine.util.PageButton(Machine.VGUI.Content,"back",180,function()

		// Go to right zvm.Machine.util.Page
		Machine.Page = Machine.Page + 1
		zvm.Machine.BuyInterface(Machine)
	end,function()
		// Is there a right zvm.Machine.util.Page?
		return Machine.Page >= zvm.Machine.util.GetPageCount(Machine)
	end)
	btn_next:SetPos(230 / zvm.Machine.util.sm, 495 / zvm.Machine.util.sm)


	local indicator = zvm.Machine.util.PageIndicator(Machine.VGUI.Content,Machine)
	indicator:SetPos(80 / zvm.Machine.util.sm, 495 / zvm.Machine.util.sm)
	indicator:SetSize(140 / zvm.Machine.util.sm, 50 / zvm.Machine.util.sm)


	local btn_buy = zvm.Machine.util.TextButton(Machine.VGUI.Content, zvm.language.General["Pay"], function()
		zvm.Actions.BuyList_CheckOut(Machine)
	end, true, zvm.colors["green01"], function() return end)
	btn_buy:SetPos(140  / zvm.Machine.util.sm, 560 / zvm.Machine.util.sm )
	btn_buy:SetSize(140  / zvm.Machine.util.sm, 50  / zvm.Machine.util.sm)
	btn_buy.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zvm.colors["green01"])
		zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zvm.colors["green02"])

		if Machine.BuyCost > 0 then
			draw.DrawText(zvm.Money.Display(Machine.BuyCost, zvm.config.Currency[Machine.MoneyType]), zclib.GetFont("zvm_interface_font01"), 70 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm, color_white, TEXT_ALIGN_CENTER)

			if s.Hovered then
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"])
			end
		else
			draw.DrawText(zvm.language.General["Pay"], zclib.GetFont("zvm_interface_font01"), 70 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm, color_white, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])
		end
	end

	local btn_cancel = zvm.Machine.util.TextButton(Machine.VGUI.Content,zvm.language.General["Back"],function()
		zvm.Actions.BuyList_Cancel(Machine)
	end)
	btn_cancel:SetPos(20  / zvm.Machine.util.sm, 560 / zvm.Machine.util.sm )
	btn_cancel:SetSize(100 / zvm.Machine.util.sm , 50 / zvm.Machine.util.sm )

	zvm.Machine.ProductList(Machine)
end

// The Product List
function zvm.Machine.ProductList(Machine)
	zclib.Debug("zvm.Machine.ProductList")
	if IsValid(Machine) and IsValid(Machine.VGUI.ProductPanel) then Machine.VGUI.ProductPanel:Remove() end

	local ProductPanel = vgui.Create("DPanel",Machine.VGUI.Content)
	ProductPanel:SetPos(0, 0)
	ProductPanel:SetSize(300 / zvm.Machine.util.sm, 480 / zvm.Machine.util.sm)
	ProductPanel.Paint = function(s, w, h) draw.RoundedBox(0, 0 , 0, w, h,  zclib.colors["black_a100"]) end
	Machine.VGUI.ProductPanel = ProductPanel

	local scroll = zvm.Machine.util.ScrollPanel(ProductPanel)

	local list = vgui.Create("DIconLayout", scroll)
	list:SetSize(300 / zvm.Machine.util.sm, 550 / zvm.Machine.util.sm)
	list:SetPos(0 , 0 )
	list:SetSpaceY(10 / zvm.Machine.util.sm)
	list:SetSpaceX(10 / zvm.Machine.util.sm)
	list:SetAutoDelete(true)
	list.Paint = function(s, w, h) end

	local count = 0
	for k, v in pairs(Machine.Products) do
		count = count + 1
		if zvm.Machine.util.PageCheck(Machine,count) then continue end

		local bgCol =  v.bg_color or zvm.colors["blue03"]
		local itm_pnl = list:Add("DPanel")
		itm_pnl:SetSize(87 / zvm.Machine.util.sm, 106 / zvm.Machine.util.sm)
		itm_pnl:SetAutoDelete(true)
		itm_pnl.Paint = function(s, w, h)
			surface.SetDrawColor(bgCol)
			surface.SetMaterial(zclib.Materials.Get("item_bg"))
			surface.DrawTexturedRect(0, 0, w, h)
		end

		local img_pnl = vgui.Create("DImage", itm_pnl)
		img_pnl:SetSize(87 / zvm.Machine.util.sm, 87 / zvm.Machine.util.sm)
		img_pnl:SetPos(0, 0)
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

		local price_pnl = vgui.Create("DPanel", itm_pnl)
		price_pnl:SetSize(87 / zvm.Machine.util.sm, 21 / zvm.Machine.util.sm)
		price_pnl:SetPos(0, 86 / zvm.Machine.util.sm)
		price_pnl:SetAutoDelete(true)
		price_pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zvm.colors["blue01"])
			draw.SimpleText(zvm.Money.Display(v.price,zvm.config.Currency[Machine.MoneyType]), zclib.GetFont("zvm_interface_item"), w / 2, h / 2, color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		price_pnl:Dock(BOTTOM)

		local p_name = v.name
		local name_font = zclib.util.FontSwitch(p_name,87 / zvm.Machine.util.sm,zclib.GetFont("zvm_interface_item"),zclib.GetFont("zvm_interface_item_small"))
		local name_pnl = vgui.Create("DLabel", itm_pnl)
		name_pnl:SetSize(87 / zvm.Machine.util.sm, 20 / zvm.Machine.util.sm)
		name_pnl:SetPos(0, 66 / zvm.Machine.util.sm)
		name_pnl:SetAutoDelete(true)
		name_pnl:SetContentAlignment(5)
		name_pnl:SetFont(name_font)
		name_pnl:SetText(p_name)
		name_pnl:SetTextColor(color_white)
		name_pnl.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white03"]) end
		name_pnl:Dock(BOTTOM)

		if zvm.Machine.HasRankRestriction(v) or zvm.Machine.HasJobRestriction(v) then
			local restriction = vgui.Create("DPanel", itm_pnl)
			restriction:SetSize(87 / zvm.Machine.util.sm, 20 / zvm.Machine.util.sm)
			restriction:SetPos(0, 50 / zvm.Machine.util.sm)
			restriction:SetAutoDelete(true)
			restriction.Paint = function(s, w, h)
				if zvm.Machine.HasRankRestriction(v) then
					surface.SetDrawColor(zvm.colors["yellow01"])
					surface.SetMaterial(zvm.materials["product_res_rank"])
					surface.DrawTexturedRect(1, 0, 15 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm)

					if zvm.Machine.HasJobRestriction(v) then
						surface.SetDrawColor(zvm.colors["blue02"])
						surface.SetMaterial(zvm.materials["product_res_job"])
						surface.DrawTexturedRect(17, 0, 15 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm)
					end
				elseif zvm.Machine.HasJobRestriction(v) then
					surface.SetDrawColor(zvm.colors["blue02"])
					surface.SetMaterial(zvm.materials["product_res_job"])
					surface.DrawTexturedRect(1, 0, 15 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm)

					if zvm.Machine.HasRankRestriction(v) then
						surface.SetDrawColor(zvm.colors["yellow01"])
						surface.SetMaterial(zvm.materials["product_res_rank"])
						surface.DrawTexturedRect(17, 0, 15 / zvm.Machine.util.sm, 15 / zvm.Machine.util.sm)
					end
				end
			end
		end

		local IncreaseButton = vgui.Create("DButton", itm_pnl)
		IncreaseButton:SetSize(87 / zvm.Machine.util.sm, 107 / zvm.Machine.util.sm)
		IncreaseButton:SetPos(0, 0)
		IncreaseButton:SetAutoDelete(true)
		IncreaseButton:SetText("")
		IncreaseButton.Paint = function(s, w, h)
			if not IsValid(Machine) then return end
			if Machine.BuyList[k] and Machine.BuyList[k] > 0 then

				if Machine:GetPublicMachine() == false then
					surface.SetDrawColor(zvm.colors["green03"])
					surface.SetMaterial(zvm.materials["product_item_amount_long"])
					surface.DrawTexturedRect(0, 0, w, h)

					draw.DrawText("[" .. v.amount .. "/" .. Machine.BuyList[k] .. "]", zclib.GetFont("zvm_interface_font02"), 85 / zvm.Machine.util.sm, 0, color_white, TEXT_ALIGN_RIGHT)
				else
					surface.SetDrawColor(zvm.colors["green03"])
					surface.SetMaterial(zvm.materials["product_item_amount"])
					surface.DrawTexturedRect(0, 0, w, h)

					draw.DrawText(Machine.BuyList[k], zclib.GetFont("zvm_interface_font02"), 85 / zvm.Machine.util.sm, 0, color_white, TEXT_ALIGN_RIGHT)
				end
			else
				if Machine:GetPublicMachine() == false then
					draw.DrawText(v.amount .. "x", zclib.GetFont("zvm_interface_font02"), 85 / zvm.Machine.util.sm, 0, color_white, TEXT_ALIGN_RIGHT)
				end
			end

			if s.Hovered then
				/*
				surface.SetDrawColor(zclib.colors["white_a100"])
				surface.SetMaterial(zvm.materials["product_item_selection"])
				surface.DrawTexturedRect(0, 0, w, h)
				*/
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white03"])
			end
		end
		IncreaseButton.DoClick = function()
			zvm.Actions.BuyList_AddItem(Machine,k)
		end

		local DecreaseButton = vgui.Create("DButton", itm_pnl)
		DecreaseButton:SetSize(30 / zvm.Machine.util.sm, 30 / zvm.Machine.util.sm)
		DecreaseButton:SetPos(2 / zvm.Machine.util.sm, 2 / zvm.Machine.util.sm)
		DecreaseButton:SetAutoDelete(true)
		DecreaseButton:SetText("")
		DecreaseButton.Paint = function(s, w, h)
			if not IsValid(Machine) then return end
			if Machine.BuyList[k] and Machine.BuyList[k] > 0 then


				surface.SetDrawColor(zvm.colors["red01"])
				surface.SetMaterial(zvm.materials["reduce_amount"])
				surface.DrawTexturedRect(0, 0, w, h)

				if s.Hovered then
					surface.SetDrawColor(zvm.colors["white02"])
					surface.SetMaterial(zvm.materials["reduce_amount"])
					surface.DrawTexturedRect(0, 0, w, h)
				end
			end
		end
		DecreaseButton.DoClick = function()
			zvm.Actions.BuyList_RemoveItem(Machine,k)
		end
	end
end

// Adds the clicked product to the shopping list
function zvm.Actions.BuyList_AddItem(Machine,productid)
	zclib.Debug("zvm.Actions.BuyList_AddItem")
	local itemdata = Machine.Products[productid]

	if hook.Run("zvm_AddItemBlock",LocalPlayer(),Machine,itemdata,productid) then return end

	if zvm.Machine.RankCheck(LocalPlayer(), itemdata) == false then
		return
	end

	if zvm.Machine.JobCheck(LocalPlayer(), itemdata) == false then
		return
	end

	if Machine:GetPublicMachine() == false then
		// Do we have enough items in stock?
		if (Machine.BuyList[productid] or 0) >= itemdata.amount then
			zvm.Warning(LocalPlayer(),zvm.language.General["BuyLimitReached"])
			return
		end
	else
		// Does the buycount excit his rank limit?
		local limit = zvm.util.GetFirstValidRank(LocalPlayer(),zvm.config.Vendingmachine.ItemLimit,zvm.config.Vendingmachine.ItemLimit["Default"])
		if Machine.BuyCount >= limit then
			zvm.Warning(LocalPlayer(),zvm.language.General["BuyLimitReached"])
			return
		end
	end

	surface.PlaySound("UI/buttonclick.wav")

	Machine.BuyList[productid] = (Machine.BuyList[productid] or 0) + 1

	Machine.BuyCount = Machine.BuyCount + 1

	Machine.BuyCost = Machine.BuyCost + Machine.Products[productid].price
end

// Removes the clicked product from the shopping list
function zvm.Actions.BuyList_RemoveItem(Machine,productid)

	if Machine.BuyList[productid] == nil then return end

	if Machine.BuyList[productid] <= 0 then return end

	surface.PlaySound("UI/buttonclick.wav")

	Machine.BuyList[productid] = math.Clamp((Machine.BuyList[productid] or 0) - 1,0,99)

	if Machine.BuyList[productid] <= 0 then
		Machine.BuyList[productid] = nil
	end

	Machine.BuyCount = math.Clamp(Machine.BuyCount - 1,0,99)

	Machine.BuyCost = Machine.BuyCost - Machine.Products[productid].price
end

// Makes the checkout and send the shopping list to the server
function zvm.Actions.BuyList_CheckOut(Machine)

	if table.Count(Machine.BuyList) <= 0 then return end

	if zclib.Money.Has(LocalPlayer(), Machine.BuyCost) == false then
		zvm.Warning(LocalPlayer(),zvm.language.General["NotEnoughMoney"])
		return
	end

	surface.PlaySound("UI/buttonclick.wav")

	local data =  util.TableToJSON(Machine.BuyList)
	local dataCompressed = util.Compress(data)

	net.Start("zvm_Machine_Buy_Request")
	net.WriteEntity(Machine)
	net.WriteUInt(#dataCompressed, 16)
	net.WriteData(dataCompressed, #dataCompressed)
	net.SendToServer()

	zvm.Actions.ResetSelections(Machine)

	zvm.Machine.IdleInterface(Machine)
end

// Go back to idle mode
function zvm.Actions.BuyList_Cancel(Machine)
	surface.PlaySound("UI/buttonclick.wav")

	net.Start("zvm_Machine_Buy_Cancel")
	net.WriteEntity(Machine)
	net.SendToServer()

	// Resets back to the buy interface
	zvm.Machine.IdleInterface(Machine)
end
