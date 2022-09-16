if SERVER then return end

surface.CreateFont("UiBold", {
	font = "Tahoma", 
	size = 14, 
	weight = 600
})

surface.CreateFont("UiSmallerThanBold", {
	font = "Tahoma", 
	size = 11, 
	weight = 600
})

surface.CreateFont("Trebuchet24", {
	font = "Trebuchet MS", 
	size = 24, 
	weight = 900
})
	
surface.CreateFont("Trebuchet22", {
	font = "Trebuchet MS", 
	size = 22, 
	weight = 900
})

surface.CreateFont("Trebuchet20", {
	font = "Trebuchet MS", 
	size = 20, 
	weight = 900
})

surface.CreateFont("ARMORY_ScreenText", {
    font = "coolvetica", 
    size = 30, 
    weight = 400
})

surface.CreateFont("ARMORY_ScreenTextHeader", {
    font = "coolvetica", 
    size = 100, 
    weight = 600
})

surface.CreateFont("ARMORY_ScreenTextBig", {
    font = "coolvetica", 
    size = 80, 
    weight = 600
})

function ARMORY_WeaponMenu()

	local GUI_Armory_Frame = vgui.Create("DFrame")
	GUI_Armory_Frame:SetSize(600 , 365)
	GUI_Armory_Frame:Center()

    GUI_Armory_Frame:MakePopup()
    GUI_Armory_Frame:ShowCloseButton(false)
    GUI_Armory_Frame:SetTitle("")
    GUI_Armory_Frame:SetDraggable(true)
    GUI_Armory_Frame:SetSizable(false)

    GUI_Armory_Frame:DockMargin(0, 0, 0, 0)
    GUI_Armory_Frame:DockPadding( 10,10,10,10)

	local TopContainer = vgui.Create("DPanel", GUI_Armory_Frame)
    TopContainer:SetAutoDelete(true)
    TopContainer:SetSize(GUI_Armory_Frame:GetWide(), 50)
    TopContainer.Paint = function(s, w, h)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0, 0, w * 2, h * 2)
		surface.DrawOutlinedRect(1, 1, w - 1 * 2, h - 1 * 2)
    end
    TopContainer:Dock(TOP)


    local close_btn = vgui.Create("DButton", TopContainer)
    close_btn:SetPos(GUI_Armory_Frame:GetWide() - 49, 0)
    close_btn:SetSize(50, 50)
    close_btn:SetText("")
    close_btn.Paint = function(s, w, h)
		surface.DrawOutlinedRect(0, 0, w * 2, h * 2)
		surface.DrawOutlinedRect(0 + 1, 0 + 1, w - 1 * 2, h - 1 * 2)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Material("materials/zerochain/zerolib/ui/icon_close.png", "noclamp smooth"))
        surface.DrawTexturedRect(0, 0, w, h)

        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 100))
        end
    end
    close_btn.DoClick = function(s)
        surface.PlaySound("UI/buttonclick.wav")
        s:SetEnabled(false)

        timer.Simple(0.25, function()
            if IsValid(s) then
                s:SetEnabled(true)
            end
        end)

		if IsValid(GUI_Armory_Frame) then
			GUI_Armory_Frame:Remove()
		end
    end
    close_btn:Dock(RIGHT)

    local TitleBox = vgui.Create("DLabel", TopContainer)
    TitleBox:SetAutoDelete(true)
    TitleBox:SetSize(500, 50)
    TitleBox:SetPos(0, 0)
    TitleBox:Dock(LEFT)
    TitleBox:SetText("Armería de la Policia")
    TitleBox:SetTextColor(color_white)
    TitleBox:SetFont("ARMORY_ScreenText")
    TitleBox:SetContentAlignment(5)
    GUI_Armory_Frame.Title = TitleBox

	GUI_Armory_Frame.Paint = function(s, w, h)
		surface.SetDrawColor(0, 61, 230, 254)
		surface.SetMaterial(Material("materials/zerochain/zerolib/ui/item_bg.png"))
		surface.DrawTexturedRect(0, 0, w,h)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0, 0, w * 2, h * 2)
		surface.DrawOutlinedRect(1, 1, w - 1 * 2, h - 1 * 2)
    end
	ItemContainer = vgui.Create("DIconLayout", GUI_Armory_Frame)
	ItemContainer:Dock(FILL)
	ItemContainer:DockMargin(0, 10, 0, 0)
	ItemContainer:SetSpaceX(10)
	ItemContainer:SetSpaceY(10)
	ItemContainer.Paint = function(s, w, h)
		//draw.RoundedBox(0, 0, 0, w, h, color_white)
	end

	// for each item
	for i, currentWep in ipairs(ARMORY_WEAPONS_LIST) do
		local item_size = GUI_Armory_Frame:GetWide() / 3
		item_size = item_size - 14

		local itm =  ItemContainer:Add("DPanel")
		itm:SetAutoDelete(true)
		itm:SetSize(item_size, item_size)
		itm.Paint = function(s, w, h)
			surface.SetDrawColor(0, 61, 230, 254)
			surface.SetMaterial(Material("models/airboat/airboat_blur02"))
			surface.DrawTexturedRect(0, 0, w,h)

			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		end

		local model_pnl = vgui.Create("DModelPanel")
		model_pnl:SetPos( 0, 0 )
		model_pnl:SetSize( 50, 50 )
		model_pnl:SetVisible(false)
		model_pnl:SetAutoDelete(true)
		model_pnl:SetModel(currentWep["model"])
		if not IsValid(model_pnl.Entity) then
			model_pnl:SetVisible(true)
		else
			local modmin, modmax = model_pnl.Entity:GetRenderBounds()
			local modsize = 0
			modsize = math.max(modsize, math.abs(modmin.x) + math.abs(modmax.x))
			modsize = math.max(modsize, math.abs(modmin.y) + math.abs(modmax.y))
			modsize = math.max(modsize, math.abs(modmin.z) + math.abs(modmax.z))
			// Force the model to look good, aka no lod reduction
			model_pnl.Entity:SetLOD( 0 )
			local modFOV = 35
			local modx = 0
			local mody = 0
			local modz = 0
			local modang = Angle(0, 25, 0)
			local modpos = vector_origin
			model_pnl:SetFOV(modFOV)
			model_pnl:SetCamPos(Vector(modsize + modx, modsize + 0 + mody, modsize + 5 + modz))
			model_pnl:SetLookAt((modmin + modmax) * 0.5)
			model_pnl.Entity:SetAngles(modang)
			model_pnl.Entity:SetPos(modpos)
			model_pnl:SetVisible(true)
		end

		model_pnl:SetParent(itm)
		model_pnl:SetAutoDelete(true)
		model_pnl:Dock(FILL)
		model_pnl:DockMargin( 5, 5, 5, 5 )
		
		local GUI_WeaponDeposit = vgui.Create("DButton", itm)
		GUI_WeaponDeposit:Dock(BOTTOM)
		GUI_WeaponDeposit:SetText("")
		GUI_WeaponDeposit.Paint = function()
			draw.RoundedBox(8,1,1,GUI_WeaponDeposit:GetWide()-2,GUI_WeaponDeposit:GetTall()-2,Color(158, 32, 32))

			local struc = {}
			struc.pos = {}
			struc.pos[1] = 95 -- x pos
			struc.pos[2] = 10 -- y pos
			struc.color = Color(255,255,255,255) -- Red
			struc.text = "Depositar ".. currentWep["name"] -- Text
			struc.font = "UiBold" -- Font
			struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
			struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
			draw.Text( struc )
		end
		GUI_WeaponDeposit.DoClick = function()
			net.Start("ARMORY_StripWeapon")
				net.WriteInt(i, 5)
			net.SendToServer()
			
			GUI_Armory_Frame:Remove()
		end
		
		local GUI_WeaponTake = vgui.Create("DButton", itm)
		GUI_WeaponTake:Dock(BOTTOM)
		GUI_WeaponTake:SetText("")
		GUI_WeaponTake.Paint = function()
			draw.RoundedBox(8,1,1,GUI_WeaponTake:GetWide()-2,GUI_WeaponTake:GetTall()-2,Color(38, 191, 21))

			local struc = {}
			struc.pos = {}
			struc.pos[1] = 95 -- x pos
			struc.pos[2] = 10 -- y pos
			struc.color = Color(255,255,255,255) -- Red
			struc.text = "Retirar ".. currentWep["name"] -- Text
			struc.font = "UiBold" -- Font
			struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
			struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
			draw.Text( struc )
		end
		GUI_WeaponTake.DoClick = function()
			net.Start("ARMORY_RetrieveWeapon")
				net.WriteInt(i, 5)
			net.SendToServer()
			
			GUI_Armory_Frame:Remove()
		end
	end

	ItemContainer:Center()
end
usermessage.Hook("ARMORY_Weapon_Menu", ARMORY_WeaponMenu)