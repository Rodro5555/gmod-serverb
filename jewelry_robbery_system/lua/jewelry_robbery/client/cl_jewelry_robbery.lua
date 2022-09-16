surface.CreateFont( "JewelryFont1", {
	font = "Rajdhani Bold",
	extended = true,
	size = 30,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "JewelryFont4", {
	font = "Rajdhani Bold",
	extended = true,
	size = 30,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "JewelryFont3", {
	font = "Rajdhani Bold",
	extended = true,
	size = 20,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "JewelryFont2", {
	font = "Rajdhani Regular",
	extended = true,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "JewelryFont5", {
	font = "Rajdhani Regular",
	extended = true,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "JewelryFont6", {
	font = "Rajdhani Regular",
	extended = true,
	size = 20,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


local lang = Jewelry_Robbery.Config.Language
local sentences = Jewelry_Robbery.Config.Lang

local blur = Material("pp/blurscreen")

local function DrawBlur( p, a, d )


	local x, y = p:LocalToScreen(0, 0)
	
	surface.SetDrawColor( 255, 255, 255 )
	
	surface.SetMaterial( blur )
	
	for i = 1, d do
	
	
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		
		
	end
	
	
end

net.Receive("OpenBlackMarketMenu.Jewelry", function()
	local ent = net.ReadEntity() or NULL
	
	if not IsValid( ent ) then return end
	if not LocalPlayer():HasWeapon("jewelry_robbery_bag") then return end
	
	local sizex,sizey = 400,240
	
	local ty = 24
	
	local value = 0
	for k, v in pairs( LocalPlayer().ListJewelry or {}  ) do
			
		value = value + Jewelry_Robbery.Config.ListJewelry[k].price_blackmarket * v
		
	end
	
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()-sizex)/2, (ScrH()-sizey)/2 )
	DermaPanel:SetSize( sizex, sizey )
	DermaPanel:SetTitle( "" )
	DermaPanel:SetDraggable( false )
	DermaPanel:ShowCloseButton( false )
	DermaPanel:MakePopup()
	DermaPanel.Paint = function( pnl, w, h )
		DrawBlur( pnl, 3, 15 )
		
		local coloraround = Color(0,0,0,150)
		draw.RoundedBox(0,0,0, w, h, Color(0, 0, 0,150))
		draw.RoundedBox(0,0,0, w, 24+10+10, Color(0, 0, 0,150))
		draw.RoundedBox(0,0,0, 2, h,coloraround)
		draw.RoundedBox(0,0,0, w, 2,coloraround)
		draw.RoundedBox(0,0,h-2, w, 2,coloraround)
		draw.RoundedBox(0,w-2,0, 2, h,coloraround)
		
		tx, ty = draw.SimpleText( sentences[4][lang], "JewelryFont1", 10,10, Color(255,255,255) )
	end
	
	local DermaButtonClose = vgui.Create( "DButton", DermaPanel )
	DermaButtonClose:SetText( "" )
	-- DermaButtonClose:SetSize( ty, ty )
	DermaButtonClose:SetSize( 25, 25 )
	-- DermaButtonClose:SetPos( sizex-60, 10 )
	DermaButtonClose:SetPos( DermaPanel:GetWide() - 35, 0 )
	function DermaButtonClose:Paint( w, h )
		if self:IsHovered() then
			draw.SimpleText( "X", "JewelryFont2", w / 2, h / 2, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "X", "JewelryFont2", w / 2, h / 2, Color( 200, 200, 200, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	function DermaButtonClose:DoClick( w, h )
		DermaPanel:Close() 
	end
	-- DermaButtonClose.DoClick = function()
	-- 	DermaPanel:Close()
	-- end	
	-- DermaButtonClose.Paint = function( pnl, w , h )
		
	-- 	surface.SetDrawColor( 255, 255, 255, 255 )
	-- 	surface.SetMaterial( closebutton )
	-- 	surface.DrawTexturedRect( 0,0,w,h )
		
	-- end
	
	local DermaNumSlider
	
	local DPanel = vgui.Create( "DScrollPanel", DermaPanel )
	DPanel:SetPos( 20, 54 )
	DPanel:SetSize( sizex-40, 200-44-20 )
	DPanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0, 150) )
		
		if not DermaNumSlider then return end
		draw.SimpleText( sentences[5][lang].." : $"..math.Round(value), "JewelryFont6", 10,10, Color(255,255,255) )
		draw.SimpleText( sentences[6][lang].." : $"..math.Round(value*DermaNumSlider:GetValue()/100), "JewelryFont6", 10,35, Color(255,255,255) )
		draw.SimpleText( sentences[7][lang].." : $"..math.Round(value*(1-DermaNumSlider:GetValue()/100)), "JewelryFont6", 10,60, Color(255,255,255) )
	end
	
	local nb = 0
	
	local sbar = DPanel:GetVBar()
	
	function sbar:Paint( w, h )
		draw.RoundedBox( 3, 0, 0, w, h, Color(0,0,0,100) )
	end
	
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 3, 1, 1, w-2, h-2, Color(0,0,0,200) )
	end
	
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 3, 1, 1, w-2, h-2, Color(0,0,0,200) )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 3, 1, 1, w-3, h-3, Color(0,0,0,200) )
	end
	
	DermaNumSlider = vgui.Create( "DNumSlider", DPanel )
	DermaNumSlider:SetPos( 10-100, 60+40 )
	DermaNumSlider:SetSize( 400, 20 )
	DermaNumSlider:SetText( sentences[8][lang].." :" )
	DermaNumSlider:SetMin( 0 )
	DermaNumSlider:SetMax( 100 )
	DermaNumSlider:SetValue( 50 )
	DermaNumSlider:SetDecimals( 0 )
	
	-- DermaNumSlider.Label:SetColor(Color(255,255,255,255))
	DermaNumSlider.TextArea:SetTextColor(Color(255,255,255))
	
	DermaNumSlider.Slider.Knob.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0,0, w,h, Color(70,95,90))
	end
	DermaNumSlider.Slider.Paint = function( self, w, h )
		draw.RoundedBox( 10, 0,0, w,h, Color(50,50,50))
	end
	
	local ButtonOffer = vgui.Create( "DButton", DermaPanel )
	ButtonOffer:SetText( "" )
	ButtonOffer:SetPos( 2, sizey-32 )
	ButtonOffer:SetSize( sizex-4, 30 )
	ButtonOffer.DoClick = function()
		DermaPanel:Close()
		net.Start("SellJewelry.Jewelry")
			net.WriteEntity(ent)
			net.WriteInt( DermaNumSlider:GetValue(), 32 )
		net.SendToServer()
	end	
	ButtonOffer.Paint = function( pnl, w , h )
		
		draw.RoundedBox( 0, 0,0, w,h, Color(216,0,39))
		draw.SimpleText( sentences[9][lang], "JewelryFont3", w/2,h/2, Color(255,255,255),1,1 )
		
	end
end)

net.Receive("NetworkNPCPosition.Jewelry", function()
	Jewelry_Robbery.NPCInfos = net.ReadTable() or {}
end)

net.Receive("NetworkRobbery.Jewelry", function()
	Jewelry_Robbery.RobberyHasStarted = net.ReadBool()
	Jewelry_Robbery.TimeStart = net.ReadInt(32)
	if not IsValid(LocalPlayer()) or not LocalPlayer():IsPlayer() then
		return
	end
	if Jewelry_Robbery.RobberyHasStarted and LocalPlayer():isCP() then
		surface.PlaySound("ambient/alarms/manhack_alert_pass1.wav")
		JEWNOTIF(sentences[13][lang])
	end
end)

net.Receive("NetworkInfos.Jewelry", function()
	LocalPlayer().ListJewelry = net.ReadTable() or {}
	surface.PlaySound("buttons/button9.wav")
end)

net.Receive("NetworkIconAlarm.Jewelry", function()
	Jewelry_Robbery.ListAlarm = net.ReadTable() or {}
end)

-- draw the backpack
Jewelry_Robbery.Backpacks = Jewelry_Robbery.Backpacks or {}

hook.Add("PreRender", "PreRender.Jewelry", function()
	--At first we search if players have no backpacks
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) and v:IsPlayer() and v:HasWeapon("jewelry_robbery_bag") and v:Alive() 
		and (v != LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer()) and not IsValid(v.BackpackJewelryModel) then
			local backpack = ClientsideModel( "models/sterling/ajr_backpack.mdl" )

			backpack:SetSkin(1)

			backpack:SetModelScale(0.85)

			local boneid = v:LookupBone( "ValveBiped.Bip01_Neck1" ) or 0
			local bonepos = v:GetBonePosition(boneid)

			backpack:SetPos( bonepos )

			backpack.owner = v

			v.BackpackJewelryModel = backpack

			table.insert(Jewelry_Robbery.Backpacks, backpack)
		end
	end

	for k,v in pairs(Jewelry_Robbery.Backpacks) do
		if not IsValid(v) or not IsValid(v.owner) or not v.owner:IsPlayer()
		or not v.owner:Alive() or not v.owner:HasWeapon( "jewelry_robbery_bag" ) 
		or (v.owner == LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer()) then
			SafeRemoveEntity(v)
			Jewelry_Robbery.Backpacks[k] = nil
		else
			--Everything's ok here, backpack is created and owner is ok

			local boneid = v.owner:LookupBone( "ValveBiped.Bip01_Neck1" ) or 0
			local bonepos, boneang = v.owner:GetBonePosition(boneid)

			local pos, ang = LocalToWorld( Vector( -10.5, 0,0 ), Angle( 0, 120, 90 ), bonepos, boneang)

			v:SetPos( pos )
			v:SetAngles( ang )
		end
	end
end)


local jewelrylogo1 = Material( "materials/advancedrobbery/alarm.png" )
local jewelrylogo2 = Material( "materials/advancedrobbery/steal.png" )
local jewelrylogo3 = Material( "materials/advancedrobbery/suspicious-man.png" )

local lastPress = 0
local isPressed = false
local lastEnt = NULL

Jewelry_Robbery.ListAlarm = Jewelry_Robbery.ListAlarm or {}
local JewelryRobberySavedEnts = {
    ["jewelryrobbery_alarm_base"] = true,
    ["jewelryrobbery_glass_base"] = true,
}


hook.Add("HUDPaint", "HUDPaint.Jewelry", function()
	
	-- draw.RoundedBox(0,0,0,200,100,Color(0,0,0))
	-- if Jewelry_Robbery.RobberyHasStarted then
		-- draw.SimpleText("Robbery : oui","Trebuchet24",0,0,Color(255,0,0))
		-- draw.SimpleText(Jewelry_Robbery.TimeStart-CurTime(),"Trebuchet24",0,20,Color(255,0,0))
	-- else
		-- draw.SimpleText("Robbery : non","Trebuchet24",0,0,Color(255,0,0))
	-- en
	
	if Jewelry_Robbery.Config.DrawHUD["robber_icon_npc"] and Jewelry_Robbery.NPCInfos and  not Jewelry_Robbery.NPCInfos.free and CurTime()-Jewelry_Robbery.NPCInfos.lastCall <= Jewelry_Robbery.Config.TimeNPCWait and Jewelry_Robbery.NPCInfos.caller == LocalPlayer() then
		
		local pos = Jewelry_Robbery.NPCInfos.pos + Vector(0,0,80)
		local logo = jewelrylogo3
		
		local dist = math.Round(pos:Distance(LocalPlayer():GetPos())/30)
		
		if dist < 5 then return end
		
		local tscreen = pos:ToScreen()
		
		local alpha = math.Clamp(1-( 15-(dist-5))/15,0,1)
	
		surface.SetDrawColor( 255, 255, 255, 255 * alpha )
		surface.SetMaterial( logo )
		surface.DrawTexturedRect( tscreen.x-32/2, tscreen.y-32/2 - 15, 32, 32 )
	
		local time = math.Round(Jewelry_Robbery.Config.TimeNPCWait-(CurTime()-Jewelry_Robbery.NPCInfos.lastCall)) 
	
		draw.SimpleText( dist.." m" , "JewelryFont6", tscreen.x, tscreen.y-32/2 + 15, Color(255,255,255,255* alpha),1)
		draw.SimpleText( time..sentences[10][lang] , "JewelryFont6", tscreen.x, tscreen.y-32/2 + 30, Color(255,255,255,255* alpha),1)
		
	end
	
	if not LocalPlayer():isCP() then
		return
	end
	
	for	k, v in pairs( Jewelry_Robbery.ListAlarm ) do
		
		if not Jewelry_Robbery.Config.DrawHUD["police_icon_alarm"] and v.type == "alarm" then continue end
		if not Jewelry_Robbery.Config.DrawHUD["police_icon_glass"] and v.type == "glass" then continue end
		
		local pos = v.pos + Vector(0,0,20)
		local logo
		
		local dist = math.Round(pos:Distance(LocalPlayer():GetPos())/30)
		
		if dist < 5 then continue end
		
		if v.type == "alarm" then
			logo = jewelrylogo1
		elseif v.type == "glass" then
			logo = jewelrylogo2
		end
		
		local tscreen = pos:ToScreen()
		
		local alpha = math.Clamp(1-( 15-(dist-5))/15,0,1)
	
		surface.SetDrawColor( 255, 255, 255, 255 * alpha )
		surface.SetMaterial( logo )
		surface.DrawTexturedRect( tscreen.x-32/2, tscreen.y-32/2 - 15, 32, 32 )

		draw.SimpleText( dist.." m" , "JewelryFont6", tscreen.x-32/2, tscreen.y-32/2 + 15, Color(255,255,255,255* alpha),0)
		
	end

end)


local lastPress = 0
local isPressed = false
local lastEnt = NULL
local AllowedEntities = {
    -- ["jewelryrobbery_alarm"] = true,
    ["jewelryrobbery_glass_base"] = true,
}


hook.Add("Think", "Think.JewelryPolice", function()
	
	if not Jewelry_Robbery.RobberyHasStarted or not LocalPlayer():isCP() then
		return
	end
	
	local ent = LocalPlayer():GetEyeTrace().Entity 
	
	if input.IsKeyDown( KEY_E ) and not isPressed then
		-- if not (ent:GetClass() == "jewelryrobbery_alarm" and ent:Health() >= Jewelry_Robbery.Config.HealthAlarm) and not ( ent:GetClass() == "jewelryrobbery_glass" and ent:Health() >= Jewelry_Robbery.Config.HealthGlass) then
		if IsValid(ent) and (AllowedEntities[ent:GetClass()] or ent.Base and AllowedEntities[ent.Base]) and ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 150^2 then
			lastPress = CurTime()
			isPressed = true
			lastEnt = ent
		
		end
	
		-- end
		
	end
	
	
	
	if lastEnt != ent or !input.IsKeyDown( KEY_E )  or not IsValid(ent) or ent:GetPos():Distance(LocalPlayer():GetPos())>150 or not (AllowedEntities[ent:GetClass()] or ent.Base and AllowedEntities[ent.Base]) then
	
		isPressed = false
		
	end
	

end)

hook.Add( "PostDrawOpaqueRenderables", "PostDrawOpaqueRenderables.Jewelry", function()
	
	if LocalPlayer():isCP() then
		
		if not Jewelry_Robbery.RobberyHasStarted then return end
		if not Jewelry_Robbery.Config.DrawHUD["3D2D_glass_police"] then return end
		
		for k, v in pairs( Jewelry_Robbery.ListGlass or {} ) do
		
			
			if not IsValid( v ) then  continue end
			
			local dist = LocalPlayer():GetPos():Distance(v:GetPos())
						
			if dist > 750 then continue end
			
			local angle = v:LocalToWorldAngles(v.displayAngles or Angle(0, 90, 90))
			local position = v:LocalToWorld(v.displayPos or Vector(18, 0, 17.5)) //GetPos() + angle:Up()*17.5 + angle:Forward()*18
			/*angle:RotateAroundAxis(angle:Forward(), 0);
			angle:RotateAroundAxis(angle:Right(),-90);
			angle:RotateAroundAxis(angle:Up(), 90);*/

			cam.Start3D2D(position,angle, 0.1)
				
				local alpha = (300-dist+150)/300
				-- draw.RoundedBox(10,-280/2,0,280,110,Color(200,200,200,20*alpha))
				
				draw.SimpleText(sentences[11][lang], "JewelryFont4", 0,0,Color(255,255,255,255*alpha),1,0)
				
				local policemin = Jewelry_Robbery.Config.NumberPoliceMin or 0
				
				draw.SimpleText(sentences[12][lang], "JewelryFont5", 0,30,Color(255,255,255,255*alpha),1,0)

				draw.RoundedBox(10,-280/2+130/2,70,150,20,Color(150,150,150,150*alpha))
				
				local sizebox = 0
				
				if lastEnt == v and isPressed then
					sizebox = math.Clamp((CurTime()-lastPress)/30,0,1)
				end
				
				if sizebox >= 1 then
					net.Start("PoliceStop.Jewelry")
						net.WriteEntity(lastEnt)
					net.SendToServer()
				end
				
				draw.RoundedBox(10,-280/2+130/2,70,150*sizebox,20,Color(255,255,255,255*alpha))
				
			cam.End3D2D()
		end
	else
		
		if Jewelry_Robbery.Config.LimitedToJob and not table.HasValue(Jewelry_Robbery.Config.Jobs or {}, LocalPlayer():Team()) then return end
		
		if not Jewelry_Robbery.Config.DrawHUD["3D2D_glass_robber"] then return end
		
		for k, v in pairs( Jewelry_Robbery.ListGlass or {} ) do
		
			if not IsValid( v ) then continue end
					
			if v:Health() <= 0 then continue end
		
			local dist = LocalPlayer():GetPos():Distance(v:GetPos())
					
			if dist > 750 then continue end
			
			local angle = v:LocalToWorldAngles(v.displayAngles or Angle(0, 90, 90))
			local position = v:LocalToWorld(v.displayPos or Vector(18, 0, 17.5))
			
			/*angle:RotateAroundAxis(angle:Forward(), 0);
			angle:RotateAroundAxis(angle:Right(),-90);
			angle:RotateAroundAxis(angle:Up(), 90);*/

			cam.Start3D2D(position,angle, 0.1)
				
				local alpha = (300-dist+150)/300
				-- draw.RoundedBox(10,-280/2,0,280,110,Color(200,200,200,20*alpha))
				
				draw.SimpleText(sentences[11][lang], "JewelryFont4", 0,0,Color(255,255,255,255*alpha),1,0)
				
				if Jewelry_Robbery.RobberyHasStarted then
					draw.SimpleText(sentences[14][lang], "JewelryFont5", 0,30,Color(255,255,255,255*alpha),1,0)
					draw.SimpleText(sentences[15][lang], "JewelryFont5", 0,60,Color(255,255,255,255*alpha),1,0)
				
				else
					local police = 0
			
					for k,v in pairs (player.GetAll()) do 
						
						if v:isCP() then
							police = police + 1
						end
						
					end
					
					local policemin = Jewelry_Robbery.Config.NumberPoliceMin or 0
					
					draw.SimpleText(sentences[16][lang].." : "..police.."/"..policemin, "JewelryFont5", 0,30,Color(255,255,255,255*alpha),1,0)
					
					local timing = 0
					timing = Jewelry_Robbery.Config.TimeBetween2Robbery-(CurTime()-(Jewelry_Robbery.TimeStart or -Jewelry_Robbery.Config.TimeBetween2Robbery ))
					timing = math.Clamp(math.Round(timing),0,Jewelry_Robbery.Config.TimeBetween2Robbery)
					draw.SimpleText(sentences[17][lang].." : "..timing.." "..sentences[2][lang], "JewelryFont5", 0,60,Color(255,255,255,255*alpha),1,0)
				
				end
				
			cam.End3D2D()
		end
	end
end)