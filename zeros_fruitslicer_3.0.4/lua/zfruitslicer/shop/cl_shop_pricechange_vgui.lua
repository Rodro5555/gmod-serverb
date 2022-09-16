if not CLIENT then return end

local VGUI = {}
local VGUIPanel

zfs = zfs or {}
zfs.Shop = zfs.Shop or {}

local function CloseUI()
	if IsValid(VGUIPanel) then
		VGUIPanel:Remove()
	end
end

local ShopEntity
local ProductPrice
function zfs.Shop.OpenPriceEditor(Shop,price)
	ShopEntity = Shop
	ProductPrice = price

	CloseUI()

	VGUIPanel = vgui.Create("zfs_PriceChanger_VGUI")
end

function VGUI:Init()
	self:SetSize(600 * zclib.wM, 200 * zclib.hM)
	self:Center()
	self:MakePopup()

	local closeBtn = vgui.Create("DButton", self)
	closeBtn:SetText("")
	closeBtn:SetPos(503.5 * zclib.wM, 0.8 * zclib.hM)
	closeBtn:SetSize(100 * zclib.wM, 26.8 * zclib.hM)
	closeBtn.DoClick = function()
		CloseUI()
	end
	closeBtn.Paint = function(s, w, h)

		if s:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["white02"])
			surface.DrawRect(0, 0, w, h)
		end
		draw.SimpleText(zfs.language.Shop.ChangePrice_Cancel, zclib.util.FontSwitch(zfs.language.Shop.ChangePrice_Cancel,w,zclib.GetFont("zclib_font_mediumsmall"),zclib.GetFont("zclib_font_small")) ,w / 2, h / 2, color_white, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
	end

	local PriceField = vgui.Create("DTextEntry", self)
	PriceField:SetPos(142 * zclib.wM, 88 * zclib.hM)
	PriceField:SetSize(320 * zclib.wM, 50 * zclib.hM)
	PriceField:SetNumeric(true)
	PriceField:SetFont(zclib.GetFont("zclib_font_bigger"))
	PriceField:SetTextColor(zfs.default_colors["green01"])
	PriceField:SetValue(ProductPrice)

	local ChangePrice = vgui.Create("DButton", self)
	ChangePrice:SetText("")
	ChangePrice:SetPos(0 * zclib.wM, 0 * zclib.hM)
	ChangePrice:SetSize(107 * zclib.wM, 27 * zclib.hM)
	ChangePrice.DoClick = function()
		if not IsValid(PriceField) then return end
		if not IsValid(ShopEntity) then return end

		local inputval = PriceField:GetValue()
		if inputval == nil then return end

		net.Start("zfs_shop_changeprice")
		net.WriteEntity(ShopEntity)
		net.WriteUInt(inputval,32)
		net.SendToServer()

		CloseUI()
	end
	ChangePrice.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(zfs.default_colors["white02"])
			surface.DrawRect(0, 0, w, h)
		end
		draw.SimpleText(zfs.language.Shop.ChangePrice_Confirm, zclib.util.FontSwitch(zfs.language.Shop.ChangePrice_Confirm,w,zclib.GetFont("zclib_font_mediumsmall"),zclib.GetFont("zclib_font_small")) ,w / 2, h / 2, color_white, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)
	end
end

function VGUI:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(zfs.default_materials["zfs_ui_changeprice"])
	surface.DrawTexturedRect(0, 0, w, h)

	draw.SimpleText(zclib.config.Currency, zclib.GetFont("zclib_font_giant"), 69 * zclib.wM,113 * zclib.hM, zfs.default_colors["yellow01"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	draw.SimpleText(zclib.config.Currency, zclib.GetFont("zclib_font_giant"), w - 70 * zclib.wM,113 * zclib.hM, zfs.default_colors["yellow01"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	if input.IsKeyDown(KEY_ESCAPE) then CloseUI() end
end

vgui.Register("zfs_PriceChanger_VGUI", VGUI, "EditablePanel")
