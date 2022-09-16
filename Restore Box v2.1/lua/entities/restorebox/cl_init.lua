include("shared.lua")
include("restoreboxconfig.lua")
AddCSLuaFile("restoreboxconfig.lua")

surface.CreateFont( "fontforui", {
	font = "CenterPrintText", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 100,
	blursize = 0,
	scanlines = 5,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = true,
	outline = false,
} )

surface.CreateFont( "HealthArmourFont", {
font = "CloseCaption_Bold",
size = 100,
weight = 800,
} )

surface.CreateFont( "MoneyFont", {
font = "CloseCaption_Bold",
size = 60,
weight = 800,
} )


function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")
	
	local money = "Money: $" .. self:GetMoney()
	
	surface.SetFont("HUDNumber5")
	local text = DarkRP.getPhrase("money_printer")
	local TextWidth = surface.GetTextSize("Brown Money Printer")
	local TextWidth2 = surface.GetTextSize(owner)
	local TextWidth3 = surface.GetTextSize(money)

--Shorteners

	local DrawHealth = LocalPlayer():Health() or 0
	local EchoHealth = LocalPlayer():Health() or 0
	local DrawArmor = LocalPlayer():Armor() or 0
	local EchoArmor = LocalPlayer():Armor() or 0

	Ang:RotateAroundAxis(Ang:Up(), -90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	
	cam.Start3D2D(Pos + Ang:Up() * 12.1, Ang, 0.11)
		draw.RoundedBox(0, -85, -123, 170, 123, Color(85, 0, 0, 255))
		draw.RoundedBox(0, -85, -91, 170, 32, Color(0, 85, 0, 255))
		draw.DrawText( "$"..healthboxprice, "Trebuchet24", 0, -88, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.RoundedBox(0, -85, -123, 170, 32, Color(1, 1, 1, 255))
		draw.DrawText( "Salud", "Trebuchet24", 0, -120, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.RoundedBox(0, -85, -59, 170, 32, Color(200, 0, 0, 255))
		draw.DrawText( "Restaurar a "..healthboxamount.."%", "Trebuchet24", 0, -56, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		draw.RoundedBox(0, -85, -1, 170, 123, Color(0, 0, 85, 255))
		draw.RoundedBox(0, -85, 29, 170, 32, Color(0, 85, 0, 255))
		draw.DrawText( "$"..armorboxprice, "Trebuchet24", 0, 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.RoundedBox(0, -85, -3, 170, 32, Color(1, 1, 1, 255))
		draw.DrawText( "Armadura", "Trebuchet24", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.RoundedBox(0, -85, 61, 170, 32, Color(0, 0, 200, 255))
		draw.DrawText( "Restaurar a "..armorboxamount.."%", "Trebuchet24", 0,64, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

	cam.End3D2D()

end

net.Receive("rbOpenUI", function()

	local ent = net.ReadEntity()

	rsbox = vgui.Create("DFrame")
	rsbox:SetSize( 600, 425 )
	rsbox:SetTitle("")
	rsbox:Center()
	rsbox:MakePopup()
	rsbox:ShowCloseButton(true)
	rsbox:SetDraggable(true)
	function rsbox:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 230, 230 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 0, 0, 0 ) )
	end

	local health = vgui.Create("DButton", rsbox)
	health:SetSize(600,200)
	health:SetPos(0, 25)
	health:SetText("")
	function health:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 0, 0 ) )
		draw.SimpleText( "SALUD", "HealthArmourFont", w/2, 0, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText( "$"..healthboxprice, "MoneyFont", w/2, h/2, Color(0, 180, 0, 255), TEXT_ALIGN_CENTER)
	end

	health.DoClick = function()
		net.Start("rbDoHealth")
		net.SendToServer(ply)
	end

	local armor = vgui.Create("DButton", rsbox)
	armor:SetSize(600,200)
	armor:SetPos(0, 225)
	armor:SetText("")
	function armor:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 150 ) )
		draw.SimpleText( "ARMADURA", "HealthArmourFont", w/2, 0, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		draw.SimpleText( "$"..armorboxprice, "MoneyFont", w/2, h/2, Color(0, 180, 0, 255), TEXT_ALIGN_CENTER)
	end

	armor.DoClick = function()
		net.Start("rbDoArmour")
		net.SendToServer(ply)
	end

end)
