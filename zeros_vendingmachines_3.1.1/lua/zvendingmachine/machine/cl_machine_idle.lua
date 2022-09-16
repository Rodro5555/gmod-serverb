if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Actions = zvm.Actions or {}

function zvm.Machine.IdleInterface(Machine)
	zclib.Debug("zvm.Machine.IdleInterface")

	// Resets the selected item
	zvm.Actions.ResetSelections(Machine)

	local NextTransition = CurTime() + 5
	Machine.VGUI.FadeIn = 1

	if Machine.VGUI and IsValid(Machine.VGUI.Content) then Machine.VGUI.Content:Remove() end

	local font02 = zclib.util.FontSwitch(zvm.language.General["PressToStart"],300 / zvm.Machine.util.sm,zclib.GetFont("zvm_interface_title"),zclib.GetFont("zvm_interface_title_small"))
	local font03 = zclib.util.FontSwitch(zvm.language.General["OutofOrder"], 300 / zvm.Machine.util.sm, zclib.GetFont("zvm_interface_title"), zclib.GetFont("zvm_interface_title_small"))

	Machine.VGUI.Content = zvm.Machine.util.Page(Machine.VGUI.Main)
	Machine.VGUI.Content.Paint = function(s, w, h)
		if not IsValid(Machine) then return end

		if Machine.Idle_ProductData and Machine.Idle_ProductData.bg_color then
			surface.SetDrawColor(Machine.Idle_ProductData.bg_color)
			surface.SetMaterial(zclib.Materials.Get("item_bg"))
			surface.DrawTexturedRect(0, 0, w, h)
		end

		// Create Transition stuff here
		if Machine.ProductCarousel and table.Count(Machine.ProductCarousel) > 0 then

			if NextTransition < CurTime() then
				NextTransition = CurTime() + zvm.config.Vendingmachine.Visuals.Shuffle_Interval

				// Changes the displayed model
				zvm.Machine.ChangeDisplayedProduct(Machine)
			end


			if Machine.Idle_ProductData then
				local m_ypos = math.sin(CurTime() * 2) * 25
				surface.SetDrawColor(Color(0, 0, 0, 100 - (100 / 1) * Machine.VGUI.FadeIn))
				surface.SetMaterial(zvm.materials["product_item_bg"])
				surface.DrawTexturedRectRotated(150 / zvm.Machine.util.sm, (280 + m_ypos)  / zvm.Machine.util.sm, 380 / zvm.Machine.util.sm, 380 / zvm.Machine.util.sm, 15 * RealTime())


				draw.RoundedBox(0, 0, 440 / zvm.Machine.util.sm, w, h / 10, Color(255, 255, 255, 25 - (25 / 1) * Machine.VGUI.FadeIn))

				draw.SimpleText(Machine.Idle_ProductData.name, Machine.Idle_ProductData.font, w / 2, 470 / zvm.Machine.util.sm, Color(255, 255, 255, 255 - (255 / 1) * Machine.VGUI.FadeIn), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

				draw.RoundedBox(0, 0, 500 / zvm.Machine.util.sm, w, h / 10, Color(0, 7, 36, 255 - (255 / 1) * Machine.VGUI.FadeIn))
				draw.SimpleText(Machine.Idle_ProductData.money, zclib.GetFont("zvm_interface_title"), w / 2, 530 / zvm.Machine.util.sm, Color(255, 255, 255, 255 - (255 / 1) * Machine.VGUI.FadeIn), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

				if IsValid(Machine.VGUI.ProductImage) then
					Machine.VGUI.ProductImage:SetPos(25 / zvm.Machine.util.sm, (150 + m_ypos) / zvm.Machine.util.sm)
				end

				local f_scale = (380 / zvm.Machine.util.sm) - ((380 / zvm.Machine.util.sm) / 2) * Machine.VGUI.FadeIn
				surface.SetDrawColor(Color(255, 255, 255,(100 / 1) * Machine.VGUI.FadeIn))
				surface.SetMaterial(zvm.materials["product_item_bg"])
				surface.DrawTexturedRect((150 / zvm.Machine.util.sm) - (f_scale / 2), (280 / zvm.Machine.util.sm) - (f_scale / 2), f_scale, f_scale)
			end

			local glow = math.abs(math.sin(CurTime() * 1) * 255) // Math stuff for flashing.
			draw.DrawText(zvm.language.General["PressToStart"],font02, 150 / zvm.Machine.util.sm, 60 / zvm.Machine.util.sm, Color(255, 255, 255,glow), TEXT_ALIGN_CENTER)

			if Machine.VGUI.FadeIn > 0 then Machine.VGUI.FadeIn = math.Clamp(Machine.VGUI.FadeIn - 0.6 * FrameTime(), 0, 1) end
		else
			local glow = math.abs(math.sin(CurTime() * 1) * 255) // Math stuff for flashing.
			draw.DrawText("- " .. zvm.language.General["OutofOrder"] .. " -",font03 , w / 2, h / 2, Color(255, 255, 255, glow), TEXT_ALIGN_CENTER)
		end
	end

	zvm.Machine.ChangeDisplayedProduct(Machine)
end

function zvm.Machine.ChangeDisplayedProduct(Machine)
	if zvm.config.Vendingmachine.Visuals.Shuffle_Sound then
		Machine:EmitSound("zvm_change_product")
	end

	local productCount = table.Count(Machine.Products)

	Machine.Idle_ProductID =  Machine.Idle_ProductID + 1
	if Machine.Idle_ProductID > productCount then Machine.Idle_ProductID = 1 end

	Machine.Idle_ProductData = Machine.ProductCarousel[Machine.Idle_ProductID]

	if Machine.Idle_ProductData then
		Machine.Idle_ProductData.font = zclib.util.FontSwitch(Machine.Idle_ProductData.name,300 / zvm.Machine.util.sm,zclib.GetFont("zvm_interface_title"),zclib.GetFont("zvm_interface_title_small"))
		Machine.Idle_ProductData.money = zvm.Money.Display(Machine.Idle_ProductData.price,zvm.config.Currency[Machine.MoneyType])
		Machine.Idle_ProductData.bg_color = Machine.Idle_ProductData.bg_color or zvm.colors["blue03"]

		zvm.Machine.ProductImage(Machine)

		Machine.VGUI.ProductImage:SetVisible(true)
		Machine.VGUI.FadeIn = 1
	end
end

// Creates the product image either as ModelIcon or DImage
function zvm.Machine.ProductImage(Machine)

	if IsValid(Machine.VGUI.ProductImage) then Machine.VGUI.ProductImage:Remove() end

	Machine.VGUI.ProductImage = vgui.Create("DImage", Machine.VGUI.Content)
	Machine.VGUI.ProductImage:SetSize(250 / zvm.Machine.util.sm, 250 / zvm.Machine.util.sm)
	Machine.VGUI.ProductImage:SetPos(25 / zvm.Machine.util.sm, 150 / zvm.Machine.util.sm)
	Machine.VGUI.ProductImage:SetAutoDelete(true)
	Machine.VGUI.ProductImage:SetVisible(false)
	Machine.VGUI.ProductImage.Paint = function(s, w, h)

		local mat = s:GetMaterial()
		if mat then

			local rot = 0
			if zvm.config.Vendingmachine.Visuals.AnimateIdleImage == true or zvm.config.Vendingmachine.Visuals.AnimateIdleImage == nil then
				rot = 15 * math.sin(CurTime() * 4)
			    rot = zclib.util.SnapValue(15,rot)
			end

			surface.SetDrawColor(color_white)
			surface.SetMaterial(mat)
			surface.DrawTexturedRectRotated(w / 2, h / 2, w, h,rot)
		end
	end

	// Lets check if the panel should be modified in some other way then usual
	local CustomUpdate = hook.Run("zvm_Overwrite_IdleImage",Machine.VGUI.ProductImage,Machine.Idle_ProductData)
	if CustomUpdate == nil then
		// If no change occured then lets just give it the model image
		local img = zclib.Snapshoter.Get(Machine.Idle_ProductData,Machine.VGUI.ProductImage)
		if img then
			Machine.VGUI.ProductImage:SetImage(img)
		else
			Machine.VGUI.ProductImage:SetImage("materials/zerochain/zerolib/ui/icon_loading.png")
		end
	end
end

function zvm.Machine.UpdateProductCarousel(Machine)
	Machine.Idle_ProductID = 1

	Machine.ProductCarousel = {}
	// Creates the Product carousel so we can switch trough the items sequencialy
	for k, v in pairs(Machine.Products) do table.insert(Machine.ProductCarousel,v) end

	if Machine.VGUI and IsValid(Machine.VGUI.ProductImage) then
		if table.Count(Machine.ProductCarousel) <= 0 then
			Machine.VGUI.ProductImage:SetVisible(false)
		else
			Machine.VGUI.ProductImage:SetVisible(true)
		end
	end
end
