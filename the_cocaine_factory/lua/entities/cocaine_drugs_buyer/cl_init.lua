include( "shared.lua" )

function ENT:Initialize()
	self.m_bInitialized = true

	local Sunglasses = ents.CreateClientProp()
	Sunglasses:SetModel( "models/craphead_scripts/the_cocaine_factory/utility/sunglasses.mdl" )
	Sunglasses:SetPos( self:GetBonePosition( self:LookupBone( "ValveBiped.Bip01_Head1" ) ) + Vector( 0, 0, 2.2 ) )
	Sunglasses:SetAngles( self:GetAttachment( 1 ).Ang )
	Sunglasses:Spawn()
	Sunglasses:SetMoveType( MOVETYPE_NONE )
	Sunglasses:SetSolid( SOLID_VPHYSICS )
	self.localSunglas = Sunglasses
end

-- According to the GMod wiki the Initialize hook is not always called on the client. Thus the workaround is needed to be put in place
-- https://wiki.garrysmod.com/page/ENTITY/Initialize

function ENT:Think()
	if ( not self.m_bInitialized ) then
		self:Initialize()
	end

	if IsValid( self.localSunglas ) then
		self.localSunglas:SetPos( self:GetBonePosition( self:LookupBone( "ValveBiped.Bip01_Head1" ) ) + Vector( 0, 0, 2.2 ) )
		self.localSunglas:SetAngles( self:GetAttachment( 1 ).Ang )
	end
end

function ENT:OnRemove()
	if IsValid( self.localSunglas ) then
		self.localSunglas:Remove()
	end
end

local col_white = Color( 255, 255, 255, 255 )
local col_dark_gray = Color( 15, 15, 15, 240 )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= TCF.Config.DisplayUIDistance then
		return
	end
	
	local leng = self:GetPos():Distance( EyePos() )
	local clam = math.Clamp( leng, 0, 255 )
	local main = ( 255 - clam / 1.7 )
	
	if ( main <= 0 ) then
		return
	end
	
	local ahAngle = self:GetAngles()
	local AhEyes = LocalPlayer():EyeAngles()
	
	ahAngle:RotateAroundAxis( ahAngle:Forward(), 90 )
	ahAngle:RotateAroundAxis( ahAngle:Right(), -90 )
	
	cam.Start3D2D( self:GetPos() +self:GetUp() * 79, Angle( 0, AhEyes.y - 90, 90 ), 0.08 )
		draw.RoundedBox( 0, -130, 10, 260, 60, Color( 32, 30, 32, 70 + main ) )
		draw.RoundedBox( 0, -130, 10, 260, 28, Color( 40, 38, 40, 70 + main ) )
		
		surface.SetDrawColor( 200, 200, 200, 70 + main )
		surface.SetMaterial( Material( "materials/craphead_scripts/the_cocaine_factory/icon_cocaine.png" )	)
		surface.DrawTexturedRect( -125, 14, 21, 21 )
		
		draw.SimpleText( TCF.Config.NPCDisplayName, "TCF_Simple19", -97.5, 23, Color( 200, 200, 200, 70 + main ), 0, 1 )
		draw.SimpleText( TCF.Config.NPCDisplayDescription, "TCF_Simple17", -120, 51, Color( 175, 175, 175, 70 + main ), 0, 1 )
		
		surface.SetDrawColor( Color( 77, 75, 77, 70 + main ) )
		surface.DrawOutlinedRect( -130, 10, 260, 60 )
	cam.End3D2D()	
end

net.Receive( "TCF_SellDrugsMenu", function( length, ply )
	local DonateSellBonus = net.ReadDouble()
	local BoxCoceAmount = net.ReadDouble()
	local CocainePayout = net.ReadDouble()
	local Box = net.ReadEntity()
	
	local Cocaine_DialogMenu = vgui.Create( "DFrame" )
	Cocaine_DialogMenu:SetPos( -1, ScrH() * 0.47 )
	Cocaine_DialogMenu:SetTall( ScrH() )
	Cocaine_DialogMenu:SetWide( ScrW() + 1 )
	Cocaine_DialogMenu:SetTitle( "" )  
	Cocaine_DialogMenu:SetVisible( true )
	Cocaine_DialogMenu:SetDraggable( false ) 
	Cocaine_DialogMenu:ShowCloseButton( false )
	Cocaine_DialogMenu.Paint = function()
	end
	Cocaine_DialogMenu:MakePopup()
	Cocaine_DialogMenu:SizeToContents()   
	
	local DialogBox = vgui.Create( "DPanel", Cocaine_DialogMenu )
	DialogBox:SetPos( 0, ScreenScale( 60 ) )
	DialogBox:SetSize( Cocaine_DialogMenu:GetWide(), ScreenScale( 90 ) )
	DialogBox.Paint = function()
		draw.RoundedBoxEx( 8, 1, 1, DialogBox:GetWide(), DialogBox:GetTall(), col_dark_gray, false, false, false, false )
	end
	
	local DialogHeadText = vgui.Create( "DLabel", Cocaine_DialogMenu )
	DialogHeadText:SetPos( ScreenScale( 160 ), ScreenScale( 64 ) )
	DialogHeadText:SetSize( ScreenScale( 100 ), ScreenScale( 20 ) )
	DialogHeadText:SetTextColor( Color( 255, 255, 255, 255 ) )
	DialogHeadText:SetFont( "TCF_Trebuchet50" )
	DialogHeadText:SetText( table.Random( TCF.Config.RandomHeySentences ) )
	
	local DialogText = vgui.Create( "DLabel", Cocaine_DialogMenu )
	DialogText:SetPos( ScreenScale( 160 ), ScreenScale( 85 ) )
	DialogText:SetSize( ScreenScale( 320 ), ScreenScale( 32 ) )
	--DialogText:DockMargin( ScreenScale( 159 ), ScreenScale( 81.5 ), 10, 10 )
	--DialogText:Dock( FILL )
	DialogText:SetTextColor( Color( 255, 255, 255, 255 ) )
	DialogText:SetFont( "TCF_Trebuchet35" )
	--DialogText:SetAutoStretchVertical( true )
	if BoxCoceAmount == 1 then
		DialogText:SetText( TCF.Config.Lang["I see that you have brought me a box with just 1 package?\nThat's not a lot of cocaine, but I will still offer you a minor sum of money for your product."][TCF.Config.Language] )
	elseif BoxCoceAmount == 2 then
		DialogText:SetText( TCF.Config.Lang["I see that you have brought me a box with 2 packages?\nSo here is the deal. I'd like to offer you a fair amount of money for your product."][TCF.Config.Language] )
	elseif BoxCoceAmount == 3 then
		DialogText:SetText( TCF.Config.Lang["I see that you have brought me a box with 3 packages?\nGreat work!. I would like to offer you a large sum of money for your packages."][TCF.Config.Language] )
	elseif BoxCoceAmount == 4 then
		DialogText:SetText( TCF.Config.Lang["Ahh finally! I've been waiting for someone to bring me a full load of cocaine.\nI like your style, and would like to offer you a large sum of money for your packages."][TCF.Config.Language] )
	end
	DialogText:SetWrap( true )
	
	local NPCHead = vgui.Create( "DImage", Cocaine_DialogMenu )
	NPCHead:SetImage( "craphead_scripts/the_cocaine_factory/buyer_npc.png" )
	NPCHead:SetPos( ScreenScale( 10 ), ScreenScale( 15 ) )
	NPCHead:SetSize( ScreenScale( 135 ), ScreenScale( 135 ) )
	
	-- Cocaine Amount
	local CocaineAmountImage = vgui.Create( "DImage", Cocaine_DialogMenu )
	CocaineAmountImage:SetImage( "craphead_scripts/the_cocaine_factory/icon_cocaine.png" )
	CocaineAmountImage:SetPos( ScreenScale( 490 ), ScreenScale( 70 ) )
	CocaineAmountImage:SetSize( ScreenScale( 21.5 ), ScreenScale( 21.5 ) )
	
	local CocaineAmountText = vgui.Create( "DLabel", Cocaine_DialogMenu )
	CocaineAmountText:SetPos( ScreenScale( 515 ), ScreenScale( 70 ) )
	CocaineAmountText:SetSize( ScreenScale( 100 ), ScreenScale( 20 ) )
	CocaineAmountText:SetFont( "TCF_Trebuchet50" )
	if BoxCoceAmount == 1 then
		CocaineAmountText:SetText( BoxCoceAmount .." ".. TCF.Config.Lang["Pack"][TCF.Config.Language] )
	else
		CocaineAmountText:SetText( BoxCoceAmount .." ".. TCF.Config.Lang["Packs"][TCF.Config.Language] )
	end
	CocaineAmountText:SetColor( Color( 255, 255, 255, 255 ) )
	
	-- Rank Bonus
	local RankBonusImage = vgui.Create( "DImage", Cocaine_DialogMenu )
	RankBonusImage:SetImage( "craphead_scripts/the_cocaine_factory/icon_vip.png" )
	RankBonusImage:SetPos( ScreenScale( 490 ), ScreenScale( 95 ) )
	RankBonusImage:SetSize( ScreenScale( 21.5 ), ScreenScale( 21.5 ) )
	
	local RankBonusText = vgui.Create( "DLabel", Cocaine_DialogMenu )
	RankBonusText:SetPos( ScreenScale( 515 ), ScreenScale( 95 ) )
	RankBonusText:SetSize( ScreenScale( 100 ), ScreenScale( 20 ) )
	RankBonusText:SetFont( "TCF_Trebuchet50" )
	RankBonusText:SetColor( Color( 255, 255, 255, 255 ) )
	if LocalPlayer():GetDonatorBonus() > 1 then
		RankBonusText:SetText( TCF.Config.Lang["Rank Bonus"][TCF.Config.Language] )
	else
		RankBonusText:SetText( TCF.Config.Lang["No Bonus"][TCF.Config.Language] )
	end
	
	-- Money Reward
	local RewardImage = vgui.Create( "DImage", Cocaine_DialogMenu )
	RewardImage:SetImage( "craphead_scripts/the_cocaine_factory/icon_money.png" )
	RewardImage:SetPos( ScreenScale( 490 ), ScreenScale( 120 ) )
	RewardImage:SetSize( ScreenScale( 21.5 ), ScreenScale( 21.5 ) )
	
	local RewardText = vgui.Create( "DLabel", Cocaine_DialogMenu )
	RewardText:SetPos( ScreenScale( 515 ), ScreenScale( 120 ) )
	RewardText:SetSize( ScreenScale( 100 ), ScreenScale( 20 ) )
	RewardText:SetFont( "TCF_Trebuchet50" )
	RewardText:SetText( "+".. DarkRP.formatMoney( CocainePayout ) )
	RewardText:SetColor( Color( 255, 255, 255, 255 ) )
	
	local ConfirmButton = vgui.Create("DImageButton", Cocaine_DialogMenu)
	ConfirmButton:SetMaterial( "craphead_scripts/the_cocaine_factory/icon_blank.png" )
	ConfirmButton:SetColor( Color( 255, 255, 255, 255 ) )
	ConfirmButton:SetSize( ScreenScale( 86 ), ScreenScale( 21.5 ) )
	ConfirmButton:SetPos( ScreenScale( 160 ) , ScreenScale( 124 ) )
	ConfirmButton:SetToolTip( TCF.Config.Lang["Accepting the druggies offer will give you"][TCF.Config.Language] .." ".. DarkRP.formatMoney( CocainePayout ) )
	ConfirmButton.Paint = function()
		local struc = {}
		struc.pos = {}
		struc.pos[1] = ScreenScale( 43 ) 
		struc.pos[2] = ScreenScale( 10 )
		struc.color = col_white
		struc.text = TCF.Config.Lang["Accept"][TCF.Config.Language]
		struc.font = "TCF_Trebuchet35"
		struc.xalign = TEXT_ALIGN_CENTER
		struc.yalign = TEXT_ALIGN_CENTER
		draw.Text( struc )
	end
	ConfirmButton.DoClick = function()
		net.Start( "TCF_SellCocaine", LocalPlayer() )
			net.WriteEntity( Box )
		net.SendToServer()

		Cocaine_DialogMenu:Remove()
	end
	
	local DeclineButton = vgui.Create("DImageButton", Cocaine_DialogMenu)
	DeclineButton:SetMaterial( "craphead_scripts/the_cocaine_factory/icon_blank.png" )
	DeclineButton:SetSize( ScreenScale( 86 ), ScreenScale( 21.5 ) )
	DeclineButton:SetPos( ScreenScale( 250 ) , ScreenScale( 124 ) )
	DeclineButton:SetToolTip( TCF.Config.Lang["Decline the druggies offer and leave the shop!"][TCF.Config.Language] )
	DeclineButton.Paint = function()
		local struc = {}
		struc.pos = {}
		struc.pos[1] = ScreenScale( 43 ) 
		struc.pos[2] = ScreenScale( 10 )
		struc.color = col_white
		struc.text = TCF.Config.Lang["Decline"][TCF.Config.Language]
		struc.font = "TCF_Trebuchet35"
		struc.xalign = TEXT_ALIGN_CENTER
		struc.yalign = TEXT_ALIGN_CENTER
		draw.Text( struc )
	end
	DeclineButton.DoClick = function()
		surface.PlaySound( "vo/npc/male01/sorry01.wav" )
		Cocaine_DialogMenu:Remove()
	end
end )