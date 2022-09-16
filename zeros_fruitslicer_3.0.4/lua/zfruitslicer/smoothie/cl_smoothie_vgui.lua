if not CLIENT then return end

local VGUI = {}
local VGUIPanel

local function OpenUI()
	if IsValid(VGUIPanel) then VGUIPanel:Remove() end
	VGUIPanel = vgui.Create("zfs_SellMenu_VGUI")
end

local function CloseUI() if IsValid(VGUIPanel) then VGUIPanel:Remove() end end

local SmoothieID
local ToppingID
local ItemEnt
local Price
net.Receive("zfs_smoothie_purchase", function(len)
	SmoothieID = net.ReadUInt(6)
	ToppingID = net.ReadUInt(6)
	ItemEnt = net.ReadEntity()

	if not IsValid(ItemEnt) then return end

	Price = ItemEnt:GetPrice()

	OpenUI()
end)

net.Receive("zfs_smoothie_close", function(len) CloseUI() end)

function VGUI:Init()
	self:SetSize(1400 * zclib.wM, 800 * zclib.hM)
	self:Center()
	self:MakePopup()

	local SmoothieData = zfs.Smoothie.GetData(SmoothieID)
	local ToppingData = zfs.Topping.GetData(ToppingID)

	local FruitColor = zfs.Smoothie.GetColor(SmoothieID)

	local hue = ColorToHSV(FruitColor)
	local indicatorColor = HSVToColor(hue, 0.7, 0.9)

	local indicator = vgui.Create("DImage", self)
	indicator:SetSize(1400 * zclib.wM, 800 * zclib.hM)
	indicator:SetPos(0 * zclib.wM, 0 * zclib.hM)
	indicator:SetMaterial(zfs.default_materials["zfs_ui_sellbox_indicator"])
	indicator:SetImageColor(indicatorColor)

	local cap = vgui.Create("DImage", self)
	cap:SetSize(1400 * zclib.wM, 800 * zclib.hM)
	cap:SetPos(0 * zclib.wM, 0 * zclib.hM)
	cap:SetImage("materials/zfruitslicer/ui/zfs_ui_sellbox_cap.png")

	local closeBtn = vgui.Create("DButton", self)
	closeBtn:SetText("")
	closeBtn:SetPos(910 * zclib.wM, 230 * zclib.hM)
	closeBtn:SetSize(50 * zclib.wM, 50 * zclib.hM)
	closeBtn.DoClick = function()
		CloseUI()
	end
	closeBtn.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["red08"])
		else
			surface.SetDrawColor(zfs.default_colors["red09"])
		end

		surface.SetMaterial(zfs.default_materials["zfs_ui_sellbox_close"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local purchaseBtn = vgui.Create("DButton", self)
	purchaseBtn:SetText(zfs.language.Shop.Item_PurchaseButton)
	purchaseBtn:SetTextColor(color_white)
	purchaseBtn:SetFont(zclib.util.FontSwitch(zfs.language.Shop.Item_PurchaseButton,175 * zclib.wM,zclib.GetFont("zclib_font_medium") ,zclib.GetFont("zclib_font_mediumsmall") ))
	purchaseBtn:SetPos(501 * zclib.wM, 600 * zclib.hM)
	purchaseBtn:SetSize(175 * zclib.wM, 50 * zclib.hM)
	purchaseBtn.Paint = function(s, w, h)
		surface.SetDrawColor(s:IsHovered() and zfs.default_colors["green05"] or zfs.default_colors["green06"])
		surface.SetMaterial(zfs.default_materials["zfs_ui_sellbox_button"])
		surface.DrawTexturedRect(0, 0, w, h)
	end
	purchaseBtn.DoClick = function()
		net.Start("zfs_smoothie_purchase")
		net.WriteEntity(ItemEnt)
		net.SendToServer()

		CloseUI()
	end

	local icon = vgui.Create("Panel", self)
	icon:SetSize(130 * zclib.wM, 130 * zclib.hM)
	icon:SetPos(515 * zclib.wM, 107 * zclib.hM)
	icon.Paint = function(s, w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(SmoothieData.Icon)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local itemName = vgui.Create("DLabel", self)
	itemName:SetPos(460 * zclib.wM, 225 * zclib.hM)
	itemName:SetSize(400 * zclib.wM, 100 * zclib.hM)
	itemName:SetFont(zclib.GetFont("zclib_font_medium"))
	itemName:SetText(SmoothieData.Name)
	itemName:SetTextColor(indicatorColor)

	local priceValue = vgui.Create("DLabel", self)
	priceValue:SetPos(470 * zclib.wM, 263 * zclib.hM)
	priceValue:SetSize(200 * zclib.wM, 100 * zclib.hM)
	priceValue:SetFont(zclib.GetFont("zclib_font_medium"))
	priceValue:SetText(zclib.Money.Display(Price))
	priceValue:SetTextColor(zfs.default_colors["green07"])

	local healthBar = vgui.Create("DImage", self)
	healthBar:SetPos(470 * zclib.wM, 345 * zclib.hM)
	healthBar:SetSize(225 * zclib.wM, 30 * zclib.hM)
	healthBar.Paint = function(s, w, h)
		surface.SetDrawColor(zfs.default_colors["black10"])
		surface.SetMaterial(zfs.default_materials["fs_ui_bar"])
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local healthText = vgui.Create("DLabel", self)
	healthText:SetPos(480 * zclib.wM, 311 * zclib.hM)
	healthText:SetSize(200 * zclib.wM, 100 * zclib.hM)
	healthText:SetFont(zclib.GetFont("zclib_font_medium"))
	healthText:SetText(zfs.language.VGUI.HealthBoni)
	healthText:SetTextColor(color_white)
	healthText:SetContentAlignment(4)

	// This gives the player the Default Health of the Fruitcup
	local extraHealth = zfs.Smoothie.GetHealth(SmoothieID)
	extraHealth = math.Round(extraHealth)

	local healthValue = vgui.Create("DLabel", self)
	healthValue:SetPos(645 * zclib.wM, 311 * zclib.hM)
	healthValue:SetSize(200 * zclib.wM, 100 * zclib.hM)
	healthValue:SetFont(zclib.GetFont("zclib_font_medium"))
	healthValue:SetText("+" .. tostring(extraHealth))
	healthValue:SetTextColor(color_white)


	local ih = ColorToHSV(FruitColor)
	local descriptionColor = HSVToColor(ih, 0, 0.2)

	local description = vgui.Create("DLabel", self)
	description:SetPos(480 * zclib.wM, 465 * zclib.hM)
	description:SetSize(225 * zclib.wM, 400 * zclib.hM)
	description:SetFont(zclib.GetFont("zclib_font_small"))
	description:SetColor(descriptionColor)
	description:SetText(SmoothieData.Info)
	description:SetWrap(true)
	description:SetAutoStretchVertical(true)

	local Topping_Name = vgui.Create("DLabel", self)
	Topping_Name:SetPos(825 * zclib.wM, 377 * zclib.hM)
	Topping_Name:SetSize(130 * zclib.wM, 60 * zclib.hM)
	Topping_Name:SetFont(zclib.GetFont("zclib_font_mediumsmall"))
	Topping_Name:SetText(tostring(ToppingData.Name))
	Topping_Name:SetContentAlignment(7)
	Topping_Name:SetTextColor(zfs.default_colors["blue03"])

	local Topping_Desc = vgui.Create("DLabel", self)
	Topping_Desc:SetPos(765 * zclib.wM, 445 * zclib.hM)
	Topping_Desc:SetSize(190 * zclib.wM, 55 * zclib.hM)
	Topping_Desc:SetFont(zclib.GetFont("zclib_font_small"))
	Topping_Desc:SetText(string.Replace(tostring(ToppingData.Info), "\n", "  "))
	Topping_Desc:SetTextColor(zfs.default_colors["black04"])
	Topping_Desc:SetContentAlignment(7)
	Topping_Desc:SetWrap(true)


	// Only create the Topping Model snapshot and Benefits List if the Selected topping item from the table is not 1 aka No Topping
	if ToppingID and ToppingID > 1 then
		local Topping_Icon = vgui.Create("DImage", self)
		Topping_Icon:SetSize(70 * zclib.wM, 70 * zclib.hM)
		Topping_Icon:SetPos(755 * zclib.wM, 374 * zclib.hM)

		local img = zclib.Snapshoter.Get({class = "prop_physics",model = ToppingData.Model}, Topping_Icon)
		Topping_Icon:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")

		local Benefitspanel = vgui.Create("Panel", self)
		Benefitspanel:SetPos(760 * zclib.wM, 505 * zclib.hM)
		Benefitspanel:SetSize(200 * zclib.wM, 140 * zclib.hM)
		Benefitspanel.Paint = function(s, w, h) end

		VGUI.Benefits(Benefitspanel, ToppingData)
	else
		local Topping_Icon = vgui.Create("DImage", self)
		Topping_Icon:SetSize(60 * zclib.wM, 60 * zclib.hM)
		Topping_Icon:SetPos(770 * zclib.wM, 378 * zclib.hM)
		Topping_Icon:SetImage("materials/zfruitslicer/ui/zfs_ui_nothing.png")
		Topping_Icon:SetImageColor(zfs.default_colors["red10"])
	end
end

function VGUI.Benefits(parent, ToppingData)

	local panel = vgui.Create("DScrollPanel", parent)
	panel:SetSize(210 * zclib.wM, 180 * zclib.hM)
	panel:DockMargin(5 * zclib.wM, 3 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	panel:Dock(FILL)
	panel.Paint = function(self, w, h) end
	panel:GetVBar().Paint = function() return true end
	panel:GetVBar().btnUp.Paint = function() return true end
	panel:GetVBar().btnDown.Paint = function() return true end
	panel:GetVBar().btnGrip.Paint = function() return true end

	local list = vgui.Create("DIconLayout", panel)
	list:SetSize(210 * zclib.wM, 180 * zclib.hM)
	list:SetPos(0 * zclib.wM, 0 * zclib.hM)
	list:SetSpaceY(5 * zclib.hM)

	if ToppingData.ToppingBenefits ~= nil then

		for k, v in pairs(ToppingData.ToppingBenefits) do

			local itm = list:Add("DPanel")
			itm:SetSize(list:GetWide(), 30 * zclib.hM)
			itm.Paint = function(self, w, h) end

			local iconBG = vgui.Create("DImage", itm)
			iconBG:SetSize(30 * zclib.wM, 30 * zclib.hM)
			iconBG:SetPos(0 * zclib.wM, -1 * zclib.hM)
			iconBG:SetImage("materials/zfruitslicer/ui/zfs_ui_toppingbg.png")
			iconBG:SetImageColor(zfs.default_colors["white06"])

			local icon = vgui.Create("DPanel", itm)
			icon:SetSize(30 * zclib.wM, 30 * zclib.hM)
			icon:SetPos(0 * zclib.wM, 1 * zclib.hM)
			icon.Paint = function(s, w, h)
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zfs.Benefit.GetIcon(k))
				surface.DrawTexturedRect(0, 0, w, h)
			end

			local BName = vgui.Create("DLabel", itm)
			BName:SetSize(140 * zclib.wM, 35 * zclib.hM)
			BName:SetPos(35 * zclib.wM, -8 * zclib.hM)
			BName:SetFont(zclib.GetFont("zclib_font_tiny"))
			BName:SetText(tostring(k))
			BName:SetTextColor(color_black)

			local bInfo
			if (k == "Health") then
				bInfo = "+" .. tostring(v)
			elseif (k == "ParticleEffect") then
				bInfo = tostring(v)
			elseif (k == "SpeedBoost") then
				bInfo = "+" .. tostring(v)
			elseif (k == "AntiGravity") then
				bInfo = "+" .. tostring(v)
			elseif (k == "Ghost") then
				bInfo = "(" .. tostring(v) .. "/255)"
			elseif (k == "Drugs") then
				bInfo = tostring(v)
			end

			local BValue = vgui.Create("DLabel", itm)
			BValue:SetSize(140 * zclib.wM, 35 * zclib.hM)
			BValue:SetPos(35 * zclib.wM, 7 * zclib.hM)
			BValue:SetFont(zclib.GetFont("zclib_font_tiny"))
			BValue:SetText(tostring(bInfo))
			BValue:SetTextColor(zfs.default_colors["green08"])
		end
	end
end

function VGUI:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(zfs.default_materials["zfs_ui_sellbox_main"])
	surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w, h)

	if input.IsKeyDown(KEY_ESCAPE) then CloseUI() end
end

vgui.Register("zfs_SellMenu_VGUI", VGUI, "Panel")
