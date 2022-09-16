local materials = {
	[ "dna" ] = Material( "materials/investigationmod/dna.png" ),
	[ "handprint" ] = Material( "materials/investigationmod/handprint.png" ),
	[ "previous" ] = Material( "materials/investigationmod/previous.png" ),
	[ "next" ] = Material( "materials/investigationmod/next.png" ),
	[ "fbi" ] = Material( "materials/investigationmod/fbi.png" ),
	[ "loader_static" ] = Material( "materials/investigationmod/loader/loader_static.png")
}

local colors = {
	[ 1 ] = Color( 100, 100, 100, 30 ),
	[ 2 ] = Color( 27, 132, 196, 255 ),
	[ 3 ] = Color( 20, 20, 20, 100 ),
	[ 4 ] = Color( 50, 50, 50, 150 )
}


local matLoader = {}
for i = 1, 8 do
	matLoader[ i ] = Material( "materials/investigationmod/loader/loader_0" .. i .. ".png" )
end

include("shared.lua")

local iBulletID = 0

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 250000 then 
		if self:DrawOffScreen( 1 ):IsVisible() then
			self:DrawOffScreen( 1 ):SetVisible( false )
		end
		return
	end

	if not self:DrawOffScreen( 1 ):IsVisible() then
		self:DrawOffScreen( 1 ):SetVisible( true )
	end

	local aAngle = self:LocalToWorldAngles( Angle( 0, 90, 17 ) )
	local vPosition = self:LocalToWorld( Vector( -5.15, -4.95, 15.95 ) )
	cam.Start3D2D( vPosition, aAngle, 0.01 )
		self:DrawOffScreen( 1 ):PaintManual3D( vPosition, aAngle, 0.01 )
	cam.End3D2D()
end

function ENT:Think()
	if not self.IsPlayingAnimation then return end

	self.Animation = self.Animation or {}
	local startTime = self.Animation.startTime or 0
	-- 0.5 secs
	local lerpValue = math.Clamp( ( CurTime() - startTime ) / 0.3, 0, 1 )

	if lerpValue > 1 then
		self.IsPlayingAnimation = false
		return
	end

	if not self.Animation.startBonePos then
		self.Animation.startBonePos = self:GetManipulateBonePosition( self:LookupBone( self.Animation.boneName ) )
	end

	self:ManipulateBonePosition( self:LookupBone( self.Animation.boneName ), LerpVector( lerpValue, self.Animation.startBonePos, self.Animation.boneEndPos ) )

end

function ENT:PaperSound()
	sound.PlayFile( "sound/investigationmod/paper_enter.wav", "", function( station ) 
		if ( IsValid( station ) ) then
			station:Play()

			timer.Simple( 1, function()
				if ( IsValid( station ) ) then
					station:Stop()
				end
			end )
		end
	end )
end 

function ENT:MakePaperEnter()
	local iIndex = self:EntIndex()

	hook.Remove( "PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.InvestigationMod.Paper" .. iIndex )

	local startTime = CurTime() + 1

	timer.Simple( 1, function()
		if IsValid( self ) then
			self:PaperSound()
		end
	end )
	hook.Add( "PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.InvestigationMod.Paper" .. iIndex, function()
		if not IsValid( self ) then hook.Remove( "PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.InvestigationMod.Paper" .. iIndex ) end
	
		local lerp = math.max( ( CurTime() - startTime ) / 1, 0 )

		if lerp > 2 then
			hook.Remove( "PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.InvestigationMod.Paper" .. iIndex )
		end

		local aAngle = self:LocalToWorldAngles( Angle( 0, 90, 0 ) )
		local vPosition = self:LocalToWorld( LerpVector( lerp, Vector( 8, -4, 6 ), Vector( -2, -4, 6 ) ) )
		cam.Start3D2D( vPosition, aAngle, 1 )
			draw.RoundedBox( 0, 0, 0, 8, 8, ColorAlpha( color_white, 100 * lerp ) )
			surface.SetDrawColor( 255, 255, 255, 255 * lerp )
			surface.SetMaterial( materials[ "handprint" ] )
			surface.DrawTexturedRect( 1, 1, 6, 6 )
		cam.End3D2D()

		local aAngle = self:LocalToWorldAngles( Angle( 0, 90, 90 ) )
		local vPosition = self:LocalToWorld( Vector( 6, -6, 8 ) )
		cam.Start3D2D( vPosition, aAngle, 1 )
			draw.RoundedBox( 0, 0, 0, 12, 12, Color( 10, 10, 10 ) )
		cam.End3D2D()
	end )
end

function ENT:OpenBullet()
	self.IsPlayingAnimation = true
	self.Animation = {
		startTime = CurTime(),
		boneName = "Compartiment balle",
		boneEndPos = Vector( 0, 4.8, 0 )
	}
end

function ENT:CloseBullet()
	self.IsPlayingAnimation = true
	self.Animation = {
		startTime = CurTime(),
		boneName = "Compartiment balle",
		boneEndPos = Vector( 0, 0, 0 )
	}
end

function ENT:OpenPaper()
	self.IsPlayingAnimation = true
	self.Animation = {
		startTime = CurTime(),
		boneName = "Compartiment Feuille",
		boneEndPos = Vector( 0, 0, 1 )
	}
end

function ENT:ClosePaper()
	self.IsPlayingAnimation = true
	self.Animation = {
		startTime = CurTime(),
		boneName = "Compartiment Feuille",
		boneEndPos = Vector( 0, 0, 0 )
	}
end

local size_x, size_y = 985, 940

local function GetSign( iNumber )
	iNumber = iNumber or 0
    return iNumber % 2 == 0 and 1 or -1
end

function ENT:DisplaySuspect( dFrame, tInfo )
	local this = self

	if IsValid( dFrame.CurrentDisplay ) then dFrame.CurrentDisplay:Remove() end

	local dCurrentDisplay = vgui.Create( "DPanel", dFrame )
	dCurrentDisplay:Dock( FILL )
	function dCurrentDisplay:Paint( w, h )
		surface.SetDrawColor( colors[ 1 ] )
		surface.SetMaterial( materials[ "fbi" ] )
		surface.DrawTexturedRect( w * 0.2, h * 0.2, w * 0.6, h * 0.6 )
	end
	dCurrentDisplay:SetAlpha( 0 )
	dCurrentDisplay:AlphaTo( 255, 1 )


	dFrame.CurrentDisplay = dCurrentDisplay

	this:ClearButtons()
	timer.Simple( 1, function()
		if not IsValid( this ) then InvestigationMod.ClearView() return end

		InvestigationMod.AddAction( this,  Vector( -10, 10, 25 ), Angle( 0, 70, 90 ), InvestigationMod:L( "LEAVE" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Scanner" ][ "Leave" ], function()
			InvestigationMod.ClearView()
			if IsValid( this ) then
				this:ClearButtons( true )
				this.Screen:Remove()
			end
		end )

	end )

	local dTitle = vgui.Create( "DLabel", dCurrentDisplay )
	dTitle:Dock( TOP )
	dTitle:SetTall( 150 )
	dTitle:SetFont( "Investigation3D2D15" )
	-- dTitle:SetTextColor( colors[ 2 ] )
	dTitle:SetText( string.upper( InvestigationMod:L( "SUSPECT" ) ) )
	dTitle:SetContentAlignment( 5 )
	local dSuspect = vgui.Create( "DPanel", dCurrentDisplay )
	dSuspect:Dock( FILL )
	dSuspect.Paint = nil

	if not IsValid( tInfo.Murder ) then
		surface.PlaySound( "investigationmod/fail.mp3" )

		local dEmpty = vgui.Create( "DLabel", dSuspect )
		dEmpty:Dock( FILL )
		dEmpty:SetFont( "Investigation3D2D10" )
		dEmpty:SetText( string.upper( InvestigationMod:L( "NO SUSPECT" ) ) )
		dEmpty:SetContentAlignment( 5 )

		if tInfo.InventoryID then
			InvestigationMod.GetInventory()[ tInfo.InventoryID ] = nil
		end
	else
		surface.PlaySound( "investigationmod/success.mp3" )

		local contentPanelWide, contentPanelTall = size_x - 120, size_y - 150 - 120 - 100 - 30 - 30 - 60 - 60

		local dContentPanel = vgui.Create( "DScrollPanel", dCurrentDisplay )
		dContentPanel:Dock( TOP )
		dContentPanel:DockMargin( 60, 60, 60, 0 )
		dContentPanel:SetTall( contentPanelTall )
		function dContentPanel:Paint( w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, color_white )
		end
		dContentPanel:GetVBar():SetWide( 0 )

		local dSpawnIcon = vgui.Create( "SpawnIcon", dContentPanel )
		dSpawnIcon:SetModel( tInfo.Murder:GetModel() )
		dSpawnIcon:SetPos( 0, 0 )
		dSpawnIcon:SetSize( contentPanelTall, contentPanelTall )

		function dSpawnIcon:PaintOver( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ] )
			draw.EdgeRectangle( 0, 0, w, h, color_white, 30, 4 )
		end

		local dInfo = vgui.Create( "DPanel", dContentPanel )
		dInfo:SetPos( contentPanelTall + 60, 0 )
		dInfo:SetSize( contentPanelWide - contentPanelTall - 60, contentPanelTall )
		function dInfo:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ] )
			draw.EdgeRectangle( 0, 0, w, h, color_white, 30, 4 )
		end

		local tMurderInfo = {
			[ InvestigationMod:L( "Age" ) ] = function( pPlayer )
				local SteamID = pPlayer:SteamID64() or ""
				SteamID = SteamID ~= "" and SteamID or 768
				local sAge = string.sub( SteamID, 1, 2 )
				local iAge = math.Clamp( math.floor( tonumber( sAge ) / 2 ), 18, 46 )
				return iAge
			end,
			[ InvestigationMod:L( "Size" ) ] = function( pPlayer )
				local SteamID = pPlayer:SteamID64() or ""
				SteamID = SteamID ~= "" and SteamID or 768
				local sCentimeters = tonumber( string.sub( SteamID, 1, 2 ) ) + tonumber( string.sub( SteamID, 3, 3 ) ) 
				return "1." .. sCentimeters .. "m"
			end,
			[ InvestigationMod:L( "Wanted" ) ] = function( pPlayer )
				return pPlayer:getDarkRPVar("wanted") and InvestigationMod:L( "Yes" ) or InvestigationMod:L( "No" )
			end,
		}


		local dDisplayMurderInfo = vgui.Create( "DPanel", dInfo )
		dDisplayMurderInfo:Dock( TOP )
		dDisplayMurderInfo:SetTall( 100 )
		function dDisplayMurderInfo:Paint( w, h )
			draw.SimpleText( tInfo.Murder:Name(),  "Investigation3D2D7B", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		for sInfo, fDis in pairs( tMurderInfo ) do
			local dDisplayMurderInfo = vgui.Create( "DPanel", dInfo )
			dDisplayMurderInfo:Dock( TOP )
			dDisplayMurderInfo:SetTall( 100 )
			function dDisplayMurderInfo:Paint( w, h )
				local x, y = draw.SimpleText( sInfo .. " : ",  "Investigation3D2D10B", 30, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( fDis( tInfo.Murder ),  "Investigation3D2D7", 30 + x, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			end
		end
		
		local dOptions = vgui.Create( "DPanel", dCurrentDisplay )
		dOptions:Dock( TOP )
		dOptions:DockMargin( 60, 30, 60, 0 )
		dOptions:SetTall( 100 )
		dOptions.Paint = nil

		local dRemoveEv = vgui.Create( "DButton", dOptions )
		dRemoveEv:Dock( LEFT )
		dRemoveEv:DockMargin( 0, 0, 15, 30 )
		dRemoveEv:SetWide( contentPanelWide / 2 - 15 )
		dRemoveEv:SetText( "" )
		function dRemoveEv:DoClick()
			surface.PlaySound( "investigationmod/clic.mp3")

			if tInfo.InventoryID then
				InvestigationMod.GetInventory()[ tInfo.InventoryID ] = nil
			end
			this:DisplayEvidenceList( dFrame )
		end

		local sRemoveEvidence = string.upper( InvestigationMod:L( "REMOVE EVIDENCE" ) )
		function dRemoveEv:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ] )
			draw.EdgeRectangle( 0, 0, w, h, color_white, 20, 4 )
			draw.SimpleText( sRemoveEvidence, "Investigation3D2D8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		local dMakeWanted = vgui.Create( "DButton", dOptions )
		dMakeWanted:Dock( RIGHT )
		dMakeWanted:DockMargin( 15, 0, 0, 30 )
		dMakeWanted:SetWide( contentPanelWide / 2 - 15 )
		dMakeWanted:SetText( "" )
		local sSuspectedMurderer = string.upper( InvestigationMod:L( "SUSPECTED MURDERER" ) )
		function dMakeWanted:DoClick()
			surface.PlaySound( "investigationmod/clic.mp3")

			local eMurder = tInfo.Murder

			if not IsValid( eMurder ) then return end

			LocalPlayer():ConCommand("darkrp wanted " .. eMurder:UserID() .. " " .. sSuspectedMurderer )
		end
		local sMakeWanted = string.upper( InvestigationMod:L( "MAKE WANTED" ) )
		function dMakeWanted:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ] )
			draw.EdgeRectangle( 0, 0, w, h, color_white, 20, 4 )
			draw.SimpleText( sMakeWanted, "Investigation3D2D8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end

	local dBack = vgui.Create( "DButton", dCurrentDisplay )
	dBack:Dock( BOTTOM )
	dBack:DockMargin( 60, 30, 60, 60 )
	dBack:SetTall( 120 )
	dBack:SetText( "" )
	function dBack:DoClick()
		surface.PlaySound( "investigationmod/clic.mp3")
		this:DisplayEvidenceList( dFrame )
	end
	local sBack = string.upper( InvestigationMod:L( "BACK" ) )
	function dBack:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ])
		draw.EdgeRectangle( 0, 0, w, h, color_white, 30, 8)
		draw.SimpleText( sBack, "Investigation3D2D13", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	dFrame:UpdateChildren()

end

function ENT:DisplayLoading( dFrame, endTime, fCallback )
	local this = self

	if IsValid( dFrame.CurrentDisplay ) then
		dFrame.CurrentDisplay:Remove()
	end

	local dCurrentDisplay = vgui.Create( "DPanel", dFrame )
	dCurrentDisplay:Dock( FILL )
	function dCurrentDisplay:Paint( w, h )
	end

	dCurrentDisplay:AlphaTo( 0, 1, endTime, fCallback )

	dFrame.CurrentDisplay = dCurrentDisplay

	local startTime = CurTime()
	endTime = CurTime() + ( endTime or 10 )

	surface.PlaySound( "investigationmod/scanning.mp3" )

	local dTitle = vgui.Create( "DLabel", dCurrentDisplay )
	dTitle:Dock( TOP )
	dTitle:SetTall( 150 )
	dTitle:SetFont( "Investigation3D2D15" )
	-- dTitle:SetTextColor( colors[ 2 ] )
	dTitle:SetText( string.upper( InvestigationMod:L( "Scanning" ) ) )
	dTitle:SetContentAlignment( 5 )
	dTitle:SetAlpha( 0 )
	dTitle:AlphaTo( 255, 1 )

	local dLoaderContent = vgui.Create( "DPanel", dCurrentDisplay )
	dLoaderContent:Dock( FILL )
	function dLoaderContent:Paint( w, h )
		local animationLevel =  math.Clamp( ( math.abs( math.sin( CurTime() ) ) ), 0, 1 )

		-- 2 sec
		local lerpStart = ( CurTime() - startTime ) / 2

		if endTime - CurTime() <= 2 then
			lerpStart = ( endTime - CurTime() ) / 2
		end

		local lerpSize = Lerp( lerpStart, 0, 720 )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( materials[ "loader_static" ] )
		surface.DrawTexturedRectRotated( w / 2, h / 2, 720, 720, Lerp( lerpStart, 180, 0 ) )

		for iID, mMat in pairs( matLoader ) do	
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( mMat )
			surface.DrawTexturedRectRotated( w / 2, h / 2, lerpSize, lerpSize, CurTime() * GetSign( iID ) * ( 8 - iID ) * 3 )
		end
	end
end 

function ENT:ClearButtons( isLeave )
	InvestigationMod.RemoveInformations( self, InvestigationMod:L( "SCANNER" ) )
	if not isLeave then
		InvestigationMod.RemoveAction( self, InvestigationMod:L( "LEAVE" ) )
	end
end

function ENT:ClearDisplay( dFrame )
	if IsValid( dFrame ) and IsValid( dFrame.CurrentDisplay ) then dFrame.CurrentDisplay:Remove() end
end

function ENT:DisplayEvidenceList( dFrame )
	local this = self

	if IsValid( dFrame.CurrentDisplay ) then dFrame.CurrentDisplay:Remove() end

	local dCurrentDisplay = vgui.Create( "DPanel", dFrame )
	dCurrentDisplay:Dock( FILL )
	function dCurrentDisplay:Paint( w, h )
		surface.SetDrawColor( colors[ 1 ] )
		surface.SetMaterial( materials[ "fbi" ] )
		surface.DrawTexturedRect( w * 0.2, h * 0.2, w * 0.6, h * 0.6 )
	end

	dFrame.CurrentDisplay = dCurrentDisplay

	this:ClearButtons()
	timer.Simple( 1, function()
		if not IsValid( this ) then InvestigationMod.ClearView() return end

		InvestigationMod.AddAction( this,  Vector( -10, 10, 25 ), Angle( 0, 70, 90 ), InvestigationMod:L( "LEAVE" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Scanner" ][ "Leave" ], function()
			InvestigationMod.ClearView()
			if IsValid( this ) then
				this:ClearButtons( true )
				this.Screen:Remove()
			end
		end )

		local sScannerText = InvestigationMod:L( "ScannerDesc" ) 
		local explodedText = string.Explode( " ", sScannerText )
		local tScannerText = {}
		
		local it = 0
		local currentSentence = ""
		for _, sWord in pairs( explodedText ) do
			it = it + 1
			currentSentence = currentSentence .. " " .. sWord

			if it > 5 then
				it = 0
				table.insert( tScannerText, currentSentence )
				currentSentence = ""
			end
		end

		if currentSentence ~= "" then
			table.insert( tScannerText, currentSentence )
			currentSentence = ""
		end

		InvestigationMod.Bloom( 1 )
		timer.Simple( 1, function()
			if IsValid( dFrame ) then 
				InvestigationMod.Bloom( 2 )
			end
		end )
		InvestigationMod.AddInformations( this, Vector( -8, -20, 28 ), Angle( 0, 110, 90 ),
			InvestigationMod:L( "SCANNER" ), 
			tScannerText,
			false )
	end )

	local dTitle = vgui.Create( "DLabel", dCurrentDisplay )
	dTitle:Dock( TOP )
	dTitle:SetTall( 150 )
	dTitle:SetFont( "Investigation3D2D15" )
	-- dTitle:SetTextColor( colors[ 2 ] )
	dTitle:SetText( string.upper( InvestigationMod:L( "Evidence Scanner" ) ) )
	dTitle:SetContentAlignment( 5 )
	dTitle:SetAlpha( 0 )
	dTitle:AlphaTo( 255, 1 )

	local tInventory = InvestigationMod.GetInventory()

	if not tInventory or table.IsEmpty( tInventory ) then
		local dEmpty = vgui.Create( "DLabel", dCurrentDisplay )
		dEmpty:Dock( FILL )
		dEmpty:SetFont( "Investigation3D2D10" )
		dEmpty:SetText( string.upper( InvestigationMod:L( "No evidence" ) ) )
		dEmpty:SetContentAlignment( 5 )
		return
	end

	local contentPanelWide, contentPanelTall = size_x - 120, size_y - 150 - 120 - 100 - 30 - 30 - 60 - 60
	local dContentPanel = vgui.Create( "DScrollPanel", dCurrentDisplay )
	dContentPanel:Dock( TOP )
	dContentPanel:DockMargin( 60, 60, 60, 0 )
	dContentPanel:SetTall( contentPanelTall )
	dContentPanel.Paint = nil
	dContentPanel.ClicEffects = {}
	function dContentPanel:Paint( w, h )
		for iID, tData in pairs( self.ClicEffects or {} ) do
			if not IsValid( tData.panel ) then self.ClicEffects[ iID ] = nil continue end

			local animationTime = 0.3

			local minSizeX, minSizeY = tData.panel:GetSize()
			local maxSizeX, maxSizeY = minSizeX * 1.5, minSizeY * 1.5
			local basePosX, basePosY = tData.panel:GetPos()

			local currentPercentage = (CurTime() - tData.startTime) / animationTime
			local lerpX, lerpY = Lerp( currentPercentage, minSizeX, maxSizeX ),  Lerp( currentPercentage, minSizeY, maxSizeY )

			surface.SetDrawColor( ColorAlpha( color_white, math.max( 50 - 50 * currentPercentage, 0 ) ) )
			surface.SetMaterial( materials[ tData.mat ] )
			surface.DrawTexturedRect( basePosX - ( lerpX - minSizeX ) / 2, basePosY - ( lerpY - minSizeY ) / 2, lerpX, lerpY )

			if CurTime() - tData.startTime > animationTime then
				self.ClicEffects[ iID ] = nil
			end
		end
	end
	dContentPanel:GetVBar():SetWide( 0 )
	function dContentPanel:DrawClicEffect( dPanel, sTexture )
		table.insert( self.ClicEffects, {
			panel = dPanel,
			mat = sTexture,
			startTime = CurTime()
		} )
	end

	local newStart = 0
	local iSelectedID

	function dContentPanel:SelectNewElement( iID )
		newStart = SysTime()

		iSelectedID = iID
		dContentPanel:ScrollToChild( tElements[ iID ] )
	end


	tElements = {}
	for iID, tInfo in pairs( tInventory ) do
		tElements[ iID ] = vgui.Create( "DPanel", dContentPanel )
		local dElement = tElements[ iID ]
		dElement.ID = iID
		dElement.InventoryID = iID

		if not iSelectedID then
			iSelectedID = dElement.ID
		end

		dElement:Dock( TOP )
		dElement:SetTall( contentPanelTall / 3 - 20 )
		dElement:DockMargin( 0, 0, 0, 20 )
		function dElement:Paint( w, h )

			self.CurrentValues = self.CurrentValues or {
				sizex = w * 0.8,
				sizey = h * 0.8,
				posx = ( w * 0.2 ) / 2,
				posy = ( h * 0.2 ) / 2,
				alpha = 0.03
			}

			if self.ID == iSelectedID then
				self.NewValues = {
					alpha = 1,
					sizex = w,
					sizey = h,
					posx = 0,
					posy = 0
				}
			elseif math.abs( self.ID - iSelectedID ) == 1 then
				self.NewValues = {
					alpha = 0.1,
					sizex = w * 0.8,
					sizey = h * 0.8,
					posx = ( w * 0.2 ) / 2,
					posy = ( h * 0.2 ) / 2
				}
			else
				self.CurrentValues = {
					sizex = w * 0.8,
					sizey = h * 0.8,
					posx = ( w * 0.2 ) / 2,
					posy = ( h * 0.2 ) / 2,
					alpha = 0.03
				}
				self.NewValues = {
					sizex = w * 0.8,
					sizey = h * 0.8,
					posx = ( w * 0.2 ) / 2,
					posy = ( h * 0.2 ) / 2,
					alpha = 0.03
				}
			end

			local currentLerp = ( SysTime() - newStart ) * 5

			self.LerpedValues = {}

			if currentLerp >= 1 then 
				self.CurrentValues = self.NewValues or self.CurrentValues
				self.LerpedValues = self.CurrentValues
			else
				for sType, fValue in pairs( self.NewValues ) do
					self.LerpedValues[ sType ] = Lerp( currentLerp, self.CurrentValues[ sType ], fValue )
				end
			end

			draw.RoundedBox( 0, self.LerpedValues.posx, self.LerpedValues.posy, self.LerpedValues.sizex, self.LerpedValues.sizey, ColorAlpha( colors[ 3 ], 100 * self.LerpedValues.alpha ) )
			draw.EdgeRectangle( self.LerpedValues.posx, self.LerpedValues.posy, self.LerpedValues.sizex, self.LerpedValues.sizey, ColorAlpha( color_white, 255 * self.LerpedValues.alpha ), 20, 4)
			draw.SimpleText( ( tInfo.Type or InvestigationMod:L( "Bullet" ) ) .. " #" .. ( iID or 0 ) , "Investigation3D2D10", self.LerpedValues.posx + self.LerpedValues.sizex / 2, self.LerpedValues.posy + self.LerpedValues.sizey / 2, ColorAlpha( color_white, 255 * self.LerpedValues.alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	local dSwitch = vgui.Create( "DPanel", dCurrentDisplay )
	dSwitch:Dock( TOP )
	dSwitch:DockMargin( 60, 30, 60, 0 )
	dSwitch:SetTall( 100 )
	dSwitch.Paint = nil

	local dPrevious = vgui.Create( "DButton", dSwitch )
	dPrevious:Dock( LEFT )
	dPrevious:DockMargin( 0, 0, 15, 0 )
	dPrevious:SetWide( contentPanelWide / 2 - 15 )
	dPrevious:SetText( "" )
	function dPrevious:DoClick()
		local iToDisplay

		surface.PlaySound( "investigationmod/clicsimple.mp3")

		for k, v in pairs( tInventory ) do
			if k < iSelectedID then
				iToDisplay = k
			else
				break
			end
		end

		dContentPanel:SelectNewElement( iToDisplay or table.maxn( tInventory) )
	end
	function dPrevious:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ] )
		draw.EdgeRectangle( 0, 0, w, h, color_white, 20, 4 )
		draw.SimpleText( string.upper( InvestigationMod:L( "PREVIOUS" ) ), "Investigation3D2D10", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local dNext = vgui.Create( "DButton", dSwitch )
	dNext:Dock( RIGHT )
	dNext:DockMargin( 15, 0, 0, 0 )
	dNext:SetWide( contentPanelWide / 2 - 15 )
	dNext:SetText( "" )
	function dNext:DoClick()
		local iToDisplay

		surface.PlaySound( "investigationmod/clicsimple.mp3")

		for k, v in pairs( tInventory ) do
			if k > iSelectedID then
				iToDisplay = k
				break
			elseif not iToDisplay then
				iToDisplay = k
			end
		end

		dContentPanel:SelectNewElement( iToDisplay )
	end
	local sNext = string.upper( InvestigationMod:L( "NEXT" ) )
	function dNext:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ] )
		draw.EdgeRectangle( 0, 0, w, h, color_white, 20, 4 )
		draw.SimpleText( sNext, "Investigation3D2D10", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end


	local dAnalyze = vgui.Create( "DButton", dCurrentDisplay )
	dAnalyze:Dock( TOP )
	dAnalyze:DockMargin( 60, 30, 60, 60 )
	dAnalyze:SetTall( 120 )
	dAnalyze:SetText( "" )

	local tFunc = {
		[ InvestigationMod:L( "Fingerprint" ) ] = {
			Animation = function( tInfo )
				if IsValid( this ) then
					this:ClearButtons()
					this:ClearDisplay( dFrame )

					InvestigationMod.SetView( this:LocalToWorld( Vector( 13, -15, 10 ) ), this:LocalToWorldAngles( Angle( 0, 100, 0 ) ), false, true )
				end

				timer.Simple( 1.5, function()
					if IsValid( this ) then
						this:ClearButtons()
						this:OpenPaper()
						this:MakePaperEnter()
					end
				end )

				timer.Simple( 3.3, function()
					if IsValid( this ) then
						this:ClosePaper()
					end
				end )

				timer.Simple( 4.5, function()
					if IsValid( this ) then
						InvestigationMod.SetView( this:LocalToWorld( Vector( 15.404737, -7.234979, 27.714403 ) ), this:LocalToWorldAngles( Angle( 30.903, 156.974, 0 ) ), false, true )
					end
				end )

				timer.Simple( 5.5, function()
					if IsValid( this ) and IsValid( dFrame ) then
						this:DisplayLoading( dFrame, 10, function()
							if IsValid( this )  and IsValid( dFrame ) then
								this:DisplaySuspect( dFrame, tInfo )
							end
						end )
					end
				end )

				timer.Simple( 15.5, function()
					if IsValid( this ) then
						InvestigationMod.SetView( this:LocalToWorld( Vector( 13.404737, 10.234979, 27.714403 ) ), this:LocalToWorldAngles( Angle( 30.903, -156.974, 0 ) ), true, true )
					else
						InvestigationMod.ClearView()
					end
				end )
			end
		},
		[ InvestigationMod:L( "Bullet" ) ] = {
			Animation = function( tInfo )
				local eBullet

				if IsValid( this ) then
					this:ClearButtons()
					this:ClearDisplay( dFrame )
					InvestigationMod.SetView( this:LocalToWorld( Vector( -4, 15, 15 ) ), this:LocalToWorldAngles( Angle( 30, -40, 0 ) ), false, true )					
				end

				timer.Simple( 1.5, function()
					if IsValid( this ) then
						this:ClearButtons()
						this:OpenBullet()
						this:EmitSound( "investigationmod/bullet_oc.wav", 30 )
					end
				end )

				timer.Simple( 2.2, function()
					if not IsValid( this ) then return end

					eBullet = ents.CreateClientProp()
					eBullet:SetRenderMode( RENDERMODE_TRANSALPHA )
					eBullet:SetModel( "models/venatuss/bullet/bullet.mdl" )
					eBullet:SetModelScale( 0.95, 0 )
					eBullet:Spawn()

					iBulletID = iBulletID + 1

					eBullet.StartTime = CurTime()
					hook.Add( "Think", "Think.MoveBullet." .. iBulletID, function()
						if not this or not IsValid( this ) or not eBullet or not IsValid( eBullet ) then hook.Remove( "Think", "Think.MoveBullet." .. iBulletID ) return end 

						local boneId = this:LookupBone( "Compartiment balle" ) or 0
						local bonePos, boneAngle = this:GetBonePosition( boneId )

						-- 1 sec
						local lerpValue = math.Clamp( ( CurTime() - eBullet.StartTime ) / 0.3 , 0, 1 )

						eBullet:SetPos( bonePos + this:GetAngles():Right() * -2.25 + this:GetAngles():Up() * Lerp( lerpValue, 5, 0 ) )
						eBullet:SetAngles( boneAngle )

						eBullet:SetColor( ColorAlpha( color_white, Lerp( lerpValue, 0, 255 ) ) )
					end )
				end )

				timer.Simple( 3.5, function()
					if IsValid( this ) then
						this:CloseBullet()
						this:EmitSound( "investigationmod/bullet_oc.wav", 30 )
					end 
				end )

				timer.Simple( 4.5, function()
					if IsValid( eBullet ) then
						eBullet:Remove()
					end

					if IsValid( this ) then
						InvestigationMod.SetView( this:LocalToWorld( Vector( 15.404737, -7.234979, 27.714403 ) ), this:LocalToWorldAngles( Angle( 30.903, 156.974, 0 ) ), false, true )
					end
				end )

				timer.Simple( 5.5, function()
					if IsValid( this ) and IsValid( dFrame ) then
						this:DisplayLoading( dFrame, 10, function()
							if IsValid( this )  and IsValid( dFrame ) then
								this:DisplaySuspect( dFrame, tInfo )
							end
						end )
					end
				end )

				timer.Simple( 15.5, function()
					if IsValid( this ) then
						InvestigationMod.SetView( this:LocalToWorld( Vector( 13.404737, 10.234979, 27.714403 ) ), this:LocalToWorldAngles( Angle( 30.903, -156.974, 0 ) ), true, true, this )
					else
						InvestigationMod.ClearView()
					end
				end )
			end
		}
	}

	function dAnalyze:DoClick()
		if not IsValid( tElements[ iSelectedID ] ) or not tElements[ iSelectedID ].InventoryID then return end
		local tInfo = tInventory[ tElements[ iSelectedID ].InventoryID ]

		if not tInfo then return end

		if not tInfo.Type or not tFunc[ tInfo.Type ] then return end

		tInfo.InventoryID = tElements[ iSelectedID ].InventoryID

		surface.PlaySound( "investigationmod/clic.mp3")

		tFunc[ tInfo.Type or InvestigationMod:L( "Bullet" ) ].Animation( tInfo )
	end
	local sScan = string.upper( InvestigationMod:L( "SCAN" ) )
	function dAnalyze:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, colors[ 3 ])
		draw.EdgeRectangle( 0, 0, w, h, color_white, 30, 8)
		draw.SimpleText( sScan, "Investigation3D2D13", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	dFrame:UpdateChildren()
end

function ENT:OnRemove()
	if IsValid( self.Screen ) then
		self.Screen:Remove()
	end
end

function ENT:DrawOffScreen()
	if IsValid( self.Screen ) then return self.Screen end

	local this = self

	self.Screen = vgui.Create( "InvestigationMod.3DFrame" )
	local dFrame = self.Screen
	dFrame:SetSize( size_x , size_y )
	dFrame:SetDrawCursor( false )
	dFrame:SetCursorColor( Color( 0, 255, 0 ) )
	dFrame:SetCursorRadius( 10 )
	dFrame:SetPaintedManually( true )
	dFrame:ParentToHUD()
	dFrame:ShowCloseButton( false )
	dFrame:SetTitle( "" )
	function dFrame:Paint( w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, colors[ 4 ] )
	end
	function dFrame:OnRemove()
		InvestigationMod.StopBloom()
		InvestigationMod.ClearView()
		if IsValid( dFrame.dBlockFrame ) then
			dFrame.dBlockFrame:Remove()
		end
	end

	local dTurnPower = vgui.Create( "DButton", dFrame )
	dTurnPower:Dock( FILL )
	dTurnPower:SetText( "" )
	function dTurnPower:DoClick()
		if not IsValid( this ) then return end

		if not InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then return end

		InvestigationMod.SetView( this:LocalToWorld( Vector( 13.404737, 10.234979, 27.714403 ) ), this:LocalToWorldAngles( Angle( 30.903, -156.974, 0 ) ), true, false, this )

		dFrame.dBlockFrame = vgui.Create( "DFrame" )
		dFrame.dBlockFrame:Dock( FILL )
		dFrame.dBlockFrame:SetTitle( "" )
		dFrame.dBlockFrame:ShowCloseButton( false )
		dFrame.dBlockFrame.Paint = nil 

		this:DisplayEvidenceList( dFrame )
		self:Remove()
	end
	function dTurnPower:Paint( w, h )
		draw.RoundedBox( 0, w / 2 - 300, h / 2 - 300, 600, 600, colors[ 3 ] )
		draw.EdgeRectangle( w / 2 - 300, h / 2 - 300, 600, 600, color_white, 50, 10 )

		surface.SetDrawColor( color_white )
		surface.SetMaterial( materials[ "dna" ] )
		surface.DrawTexturedRect( w / 2 - 200, h / 2 - 200, 400, 400 )
	end

	dFrame:UpdateChildren()
	return dFrame
end
