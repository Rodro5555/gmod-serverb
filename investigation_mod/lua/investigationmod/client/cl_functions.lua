surface.CreateFont( "InvestigationUI-30B", {
	font = "Rajdhani",
	extended = false,
	size = math.ceil( ScrH() * 0.035 ),
	weight = 1000,
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
})
surface.CreateFont( "InvestigationUI-25B", {
	font = "Rajdhani",
	extended = false,
	size = math.ceil( ScrH() * 0.025 ),
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
})

surface.CreateFont( "Investigation3D2D28", {
	font = "Rajdhani",
	extended = false,
	size = 280,
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
})


surface.CreateFont( "Investigation3D2D20", {
	font = "Rajdhani",
	extended = false,
	size = 200,
	weight = 1000,
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
})

surface.CreateFont( "Investigation3D2D17", {
	font = "Rajdhani",
	extended = false,
	size = 170,
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
})

surface.CreateFont( "Investigation3D2D15", {
	font = "Rajdhani",
	extended = false,
	size = 150,
	weight = 1000,
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
})

surface.CreateFont( "Investigation3D2D13", {
	font = "Rajdhani",
	extended = false,
	size = 130,
	weight = 1000,
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
})

surface.CreateFont( "Investigation3D2D10", {
	font = "Rajdhani",
	extended = false,
	size = 100,
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
})
surface.CreateFont( "Investigation3D2D10B", {
	font = "Rajdhani",
	extended = false,
	size = 60,
	weight = 1000,
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
})
surface.CreateFont( "Investigation3D2D11", {
	font = "Rajdhani",
	extended = false,
	size = 110,
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
})
surface.CreateFont( "Investigation3D2D8", {
	font = "Rajdhani",
	extended = false,
	size = 65,
	weight = 700,
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
})
surface.CreateFont( "Investigation3D2D7", {
	font = "Rajdhani",
	extended = false,
	size = 70,
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
})
surface.CreateFont( "Investigation3D2D7B", {
	font = "Rajdhani",
	extended = false,
	size = 70,
	weight = 1000,
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
})

local tColors = {
	[1] = Color( 27, 132, 196, 255 ),
	[2] = Color( 25, 25, 25 ),
	[3] = Color( 100, 100, 100 ),
	[4] = Color( 240, 240, 240 ),
	[5] = Color( 0, 0, 0 )
}

function draw.EdgeRectangle( fPosX, fPosY, fSizeX, fSizeY, oColor, fHeight, fThickness)
	local fPosX = fPosX or 0
	local fPosY = fPosY or 0
	local fSizeX = fSizeX or 100
	local fSizeY = fSizeY or 100
	local fThickness = fThickness or 2
	local fHeight = fHeight or 7
	local oColor = oColor or tColors[ 1 ]

	--[[
		TOP LEFT
	]]
	draw.RoundedBox( 0, fPosX, fPosY, fThickness, fHeight, oColor )
	draw.RoundedBox( 0, fPosX, fPosY, fHeight, fThickness, oColor )

	--[[
		TOP RIGHT
	]]
	draw.RoundedBox( 0, fPosX + fSizeX - fThickness, fPosY, fThickness, fHeight, oColor )
	draw.RoundedBox( 0, fPosX + fSizeX - fHeight, fPosY, fHeight, fThickness, oColor )

	--[[
		BOTTOM LEFT
	]]
	draw.RoundedBox( 0, fPosX, fPosY + fSizeY - fHeight, fThickness, fHeight, oColor )
	draw.RoundedBox( 0, fPosX, fPosY + fSizeY - fThickness, fHeight, fThickness, oColor )

	--[[
		BOTTOM LEFT
	]]
	draw.RoundedBox( 0, fPosX + fSizeX - fThickness, fPosY + fSizeY - fHeight, fThickness, fHeight, oColor )
	draw.RoundedBox( 0, fPosX + fSizeX - fHeight, fPosY + fSizeY - fThickness, fHeight, fThickness, oColor )
end

function InvestigationMod.DrawInformations( eEntity, vPosition, aAngle, sTitle, tText, bRelative )
	if not IsValid( eEntity ) then InvestigationMod.Informations[ eEntity ][ sTitle ] = nil return end
	if not InvestigationMod.Informations[ eEntity ] or not InvestigationMod.Informations[ eEntity ][ sTitle ] then return end	

	local fDistance = LocalPlayer():GetPos():DistToSqr( eEntity:GetPos() )

	if fDistance > 20000 then 
		return
	end

	local fScale = 0.01
	local sFontTitle = "Investigation3D2D20"
	local sFont = "Investigation3D2D17"

	local aAngle = bRelative and aAngle or eEntity:LocalToWorldAngles( aAngle )

	local _PositionAlign = aAngle:Up() * 3
	local _PositonLayer2 = bRelative and ( eEntity:GetPos() + vPosition ) or eEntity:LocalToWorld( vPosition )
	local _PositonLayer1 = _PositonLayer2 + aAngle:Up() * -0.4
	local _PositonLayer3 = _PositonLayer2 + aAngle:Up() * .4

	local fPercentageAlpha = math.Clamp( ( CurTime() - InvestigationMod.Informations[ eEntity ][ sTitle ].startTime ) / 0.4, 0, 1 )
	local fPercentageText = math.Clamp( ( CurTime() - InvestigationMod.Informations[ eEntity ][ sTitle ].startTime ), 0, 1 )

	surface.SetFont( sFontTitle )
	local size_x, size_y = surface.GetTextSize( sTitle )
	size_x = size_x + 100
	surface.SetFont( sFont )
	for _, sText in pairs( tText ) do
		local x, y = surface.GetTextSize( sText )
		size_x = math.max( size_x, x + 100 )
		size_y = size_y + y
	end

	cam.Start3D2D( _PositonLayer1, aAngle, fScale )
		draw.RoundedBox( 0, 0, 0, size_x, size_y, ColorAlpha( tColors[ 2 ], 180 * fPercentageAlpha) )
	cam.End3D2D()

	cam.Start3D2D( _PositonLayer2, aAngle, fScale )
		draw.RoundedBox( 0, 0, 0, size_x, size_y, ColorAlpha( tColors[ 3 ], 75 * fPercentageAlpha ) )

		draw.SimpleText( string.sub( sTitle, 1, string.len( sTitle ) * fPercentageText ), sFontTitle, 50, 0, ColorAlpha( color_white, 255 * fPercentageAlpha ) )
		for _, sText in pairs( tText ) do
			draw.SimpleText( string.sub( sText, 1, string.len( sText ) * fPercentageText ), sFont, 50, 180 * _, ColorAlpha( color_white, 255 * fPercentageAlpha ) )
		end
	cam.End3D2D()

	cam.Start3D2D( _PositonLayer3, aAngle, fScale )
		draw.EdgeRectangle( 0, 0, size_x, size_y, ColorAlpha( tColors[ 4 ], 255 * fPercentageAlpha ), 70, 5 )
	cam.End3D2D()
end

function InvestigationMod.DrawAction( eEntity, vPosition, aAngle, sAction, iKey, fPostAction, bRelative, bFollowPlayerAngle )
	if not IsValid( eEntity ) then InvestigationMod.Actions[ eEntity ][ sAction ] = nil return end
	if not InvestigationMod.Actions[ eEntity ] or not InvestigationMod.Actions[ eEntity ][ sAction ] then return end

	local fDistance = LocalPlayer():GetPos():DistToSqr( eEntity:GetPos() )

	if fDistance > 20000 then 
		if InvestigationMod.Actions[ eEntity ] then
			InvestigationMod.Actions[ eEntity ][ sAction ] = {
				startTime = CurTime(),
				actionClic = 0,
				data = { eEntity, vPosition, aAngle, sAction, iKey, fPostAction, bRelative, bFollowPlayerAngle }
			}
			return
		end 
	end

	local fScale = .01
	local sAction = sAction
	local sFont = "Investigation3D2D28"
	local startTime = InvestigationMod.Actions[ eEntity ][ sAction ].startTime or CurTime()
	local actionClic = InvestigationMod.Actions[ eEntity ][ sAction ].actionClic

	local vShootPos = LocalPlayer():GetShootPos()
    local vAimVector = LocalPlayer():GetAimVector()
    local vPos = eEntity:LocalToWorld( vPosition ) - vShootPos
    local vUnitPos = vPos:GetNormalized()
    local fDistanceAim =  vUnitPos:Dot( vAimVector )

    local actionFocused = InvestigationMod.HasActionFocused
    if not ( actionFocused and IsValid( actionFocused.Entity ) and actionFocused.Action and InvestigationMod.Actions[ actionFocused.Entity ][ actionFocused.Action ] and ( actionFocused.Entity ~= eEntity or sAction ~= actionFocused.Action) ) then
		if not InvestigationMod.Actions[ eEntity ][ sAction ].stopTime and ( fDistanceAim > 0.95 or LocalPlayer().IsFocused  ) and fDistance < 15000 and input.IsKeyDown( iKey ) then
			if math.min( actionClic + 0.005, 1 ) >= 1 then
				InvestigationMod.Actions[ eEntity ][ sAction ].stopTime = CurTime()
				fPostAction( eEntity )
				surface.PlaySound( "investigationmod/press.mp3")
				InvestigationMod.HasActionFocused = nil
			else
				InvestigationMod.HasActionFocused = InvestigationMod.HasActionFocused or {
					Entity = eEntity,
					Action = sAction
				}
				InvestigationMod.Actions[ eEntity ][ sAction ].actionClic = math.min( actionClic + 0.005, 1 )
			end
		else
			InvestigationMod.HasActionFocused = nil
			InvestigationMod.Actions[ eEntity ][ sAction ].actionClic = math.max( actionClic - 0.01, 0 )
		end
	end 

	local fPercentageMove = math.Clamp( ( CurTime() - ( InvestigationMod.Actions[ eEntity ][ sAction ].stopTime or InvestigationMod.Actions[ eEntity ][ sAction ].startTime ) ) / 0.4, 0, 1 )

	-- Remove once the animation is done
	if InvestigationMod.Actions[ eEntity ][ sAction ].stopTime then
		if fPercentageMove >= 1 then 
			InvestigationMod.Actions[ eEntity ][ sAction ] = nil
		else
			fPercentageMove = 1 - fPercentageMove
		end
	end

	local fPercentageDistance = math.Clamp( ( fPercentageMove < 1 and fPercentageMove or 1 - ( ( fDistance - 6000) / 20000 ) ), 0, 1 )
	if fDistanceAim < 0.99 then
    	fPercentageDistance = fPercentageDistance * math.Clamp( fDistanceAim / 0.99, 0, 1 )
    end

	local aAngle = bRelative and Angle( aAngle.p, bFollowPlayerAngle and LocalPlayer():GetAngles().y - 90 or aAngle.y, aAngle.r ) or eEntity:LocalToWorldAngles( aAngle )

	-- Allow to do a small move in front when we approach
	local _PositionAlign = aAngle:Up() * 3 + ( bFollowPlayerAngle and aAngle:Forward() * -2.5 or Vector() )
	local _PositonLayer2 = bRelative and eEntity:GetPos() + vPosition or eEntity:LocalToWorld( vPosition )
	local _PositonLayer1 = _PositonLayer2 + aAngle:Up() * -.5
	local _PositonLayer3 = _PositonLayer2 + aAngle:Up() * .5

	local fMoveBottom = 300
	local fBoxSize = 500
	local fBorder = 50

	cam.Start3D2D( _PositonLayer1 + _PositionAlign * fPercentageMove, aAngle, fScale )
		draw.RoundedBox( 0, 0, fMoveBottom, fBoxSize, fBoxSize, ColorAlpha( tColors[ 2 ], 180 * fPercentageDistance ) )
	cam.End3D2D()

	cam.Start3D2D( _PositonLayer2 + _PositionAlign * math.Clamp( fPercentageMove * 1.5, 0, 1 ), aAngle, fScale )
		surface.SetFont( sFont )
		surface.SetTextColor( 255, 255, 255, 255 * fPercentageDistance )
		local x, y = surface.GetTextSize( sAction )
		draw.RoundedBox( 0, ( fBoxSize - x ) / 2 - fBorder, 0, fBorder * 2 + x, y, ColorAlpha( tColors[ 2 ], 200 * fPercentageDistance ) )
		surface.SetTextPos( ( fBoxSize - x ) / 2, 0 )
		surface.DrawText( sAction )

		draw.RoundedBox( 0, 0, fMoveBottom, fBoxSize, fBoxSize, ColorAlpha( tColors[ 3 ], 75 * fPercentageDistance ) )
		draw.RoundedBox( 0, 0, fMoveBottom + ( fBoxSize - actionClic * fBoxSize ), fBoxSize, fBoxSize * actionClic, ColorAlpha( tColors[ 1 ], 75 * fPercentageDistance ) )
		draw.SimpleText( "+" .. string.upper( input.GetKeyName( iKey ) ), sFont, 245, fMoveBottom + 255, ColorAlpha( tColors[ 5 ], 255 * fPercentageDistance ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "+" .. string.upper( input.GetKeyName( iKey ) ), sFont, 250, fMoveBottom + 250, ColorAlpha( color_white, 255 * fPercentageDistance ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()

	cam.Start3D2D( _PositonLayer3 + _PositionAlign * math.Clamp( fPercentageMove * 2, 0, 1 ), aAngle, fScale )
		draw.EdgeRectangle( 0, fMoveBottom, fBoxSize, fBoxSize, ColorAlpha( tColors[ 1 ], 255 * fPercentageDistance ), 70 + actionClic * 180, 20 + actionClic * 10 )
	cam.End3D2D()
end

function InvestigationMod.AddAction( eEntity, vPosition, aAngle, sAction, iKey, fPostAction, bRelative, bFollowPlayerAngle )
	InvestigationMod.Actions[ eEntity ] = InvestigationMod.Actions[ eEntity ] or {}
	sAction = string.upper( sAction )
	InvestigationMod.Actions[ eEntity ][ sAction ] = InvestigationMod.Actions[ eEntity ][ sAction ] or {
		startTime = CurTime(),
		actionClic = 0,
		data = { eEntity, vPosition, aAngle, sAction, iKey, fPostAction, bRelative, bFollowPlayerAngle }
	}

	return InvestigationMod.Actions[ eEntity ][ sAction ]
end

function InvestigationMod.AddInformations( eEntity, vPosition, aAngle, sTitle, tText, bRelative )
	InvestigationMod.Informations[ eEntity ] = InvestigationMod.Informations[ eEntity ] or {}
	InvestigationMod.Informations[ eEntity ][ sTitle ] = InvestigationMod.Informations[ eEntity ][ sTitle ] or {
		startTime = CurTime(),
		data = { eEntity, vPosition, aAngle, sTitle, tText, bRelative }
	}

	sound.PlayFile( "sound/investigationmod/beepbeep.wav", "", function( station ) 
		if ( IsValid( station ) ) then
			station:Play()

			timer.Simple( 1, function()
				if ( IsValid( station ) ) then
					station:Stop()
				end
			end )
		end
	end )

	return InvestigationMod.Informations[ eEntity ][ sTitle ]
end

function InvestigationMod.RemoveInformations( eEntity, sTitle )
	if not InvestigationMod.Informations[ eEntity ] then return end
	InvestigationMod.Informations[ eEntity ][ sTitle ] = nil
end

function InvestigationMod.RemoveAction( eEntity, sAction )
	sAction = string.upper( sAction )
	if not InvestigationMod.Actions[ eEntity ] then return end
	InvestigationMod.Actions[ eEntity ][ sAction ] = nil
end

function InvestigationMod.SetView( vPosition, aAngle, bPreventAnimation, bShouldUseLastView, eLinkedEntity )
	LocalPlayer():DrawViewModel( false )
	LocalPlayer():IM_Lock()
	LocalPlayer().IsFocused = true
	local oldView = InvestigationMod.MoveView

	InvestigationMod.PlayAmbiantSound()

	InvestigationMod.MoveView = {
		startTime = CurTime(),
		position = vPosition,
		angle = aAngle,
		shouldAnimate = not bPreventAnimation,
		shoudlLastView = bShouldUseLastView and oldView ,
		linkedEntity = eLinkedEntity
	}


	hook.Run( "InvestigationMod:OnViewChanged" )
end

function InvestigationMod.ClearView()
	LocalPlayer():DrawViewModel( true )
	LocalPlayer():IM_UnLock()
	LocalPlayer().IsFocused = false
	InvestigationMod.MoveView = nil

	InvestigationMod.StopAmbiantSound()
	InvestigationMod.StopBloom()

	hook.Run( "InvestigationMod:OnViewCleared" )
end

function InvestigationMod.AddInventory( tTable )
	InvestigationMod.LocalPlayerInventory = InvestigationMod.LocalPlayerInventory or {}

	InvestigationMod.LocalPlayerInventory[ #InvestigationMod.LocalPlayerInventory + 1 ] = tTable
	
	hook.Run( "InvestigationMod:OnObjectTaken", tTable )
end

function InvestigationMod.GetInventory()
	if not InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then
		InvestigationMod.LocalPlayerInventory = nil
		return {}
	end
	return InvestigationMod.LocalPlayerInventory or {}
end

function InvestigationMod.PlayAmbiantSound()
	if IsValid( InvestigationMod.AmbiantSound ) then return end

	sound.PlayFile( "sound/investigationmod/ambiance.wav", "", function( station ) 
		if IsValid( InvestigationMod.AmbiantSound ) then
			return
		end
		
		if ( IsValid( station ) ) then
			InvestigationMod.AmbiantSound = station
			station:SetVolume( 1 )
			station:Play()
			station:EnableLooping( true )
		end
	end )
end

function InvestigationMod.FormatFootsteps( tFootsteps )
	if not tFootsteps then return {} end

	-- In clientside, there is no need to keep the SteamID of the owner.
	-- Footsteps can't be analyzed.
	local tFormattedTable = {}

	for pPlayer, tFoots in pairs( tFootsteps ) do
		for iFoot, tFoot in pairs( tFoots ) do
			for _, tFootInfo in pairs( tFoot ) do
				tFootInfo.foot = iFoot
				table.insert( tFormattedTable, tFootInfo )
			end
		end
	end

	return tFormattedTable
end

local RemoveAmbiantStart
function InvestigationMod.StopAmbiantSound()
	if RemoveAmbiantStart then return end

	RemoveAmbiantStart = CurTime()
	hook.Add( "Think", "Think.InvestigationMod.RemoveAmbiantSound", function()
		if not RemoveAmbiantStart or not isnumber( RemoveAmbiantStart ) or not IsValid( InvestigationMod.AmbiantSound ) then hook.Remove( "Think", "Think.InvestigationMod.RemoveAmbiantSound" ) return end

		local lerpSoundVolume = math.Clamp( CurTime() - RemoveAmbiantStart, 0, 1 )

		if 1 - lerpSoundVolume <= 0 then
			InvestigationMod.AmbiantSound:Stop()
			RemoveAmbiantStart = nil
			return
		end

		InvestigationMod.AmbiantSound:SetVolume( 1 - lerpSoundVolume )
	end )
end

function InvestigationMod.Bloom( iMode )
	InvestigationMod.PlayBloom = CurTime()
	InvestigationMod.BloomMode = iMode
end

function InvestigationMod.StopBloom()
	InvestigationMod.PlayBloom = nil
	InvestigationMod.BloomMode = nil
end

--[[
	META PLAYER
]]

local metaPlayer = FindMetaTable( "Player" )

function metaPlayer:IM_AskPrints()
	net.Start( "InvestigationMod.AskPrints" )
	net.SendToServer()
end

function metaPlayer:IM_Lock()
	self.IM_IsLocked = true
end

function metaPlayer:IM_UnLock()
	self.IM_IsLocked = false
end

hook.Add( "CreateMove", "InvestigationMod.CreateMove", function( oCmd )
	if LocalPlayer().IM_IsLocked then
		oCmd:ClearButtons()
		oCmd:ClearMovement()

		oCmd:SetMouseX( 0 )
		oCmd:SetMouseY( 0 )
	end
end )

hook.Add( "InputMouseApply", "InvestigationMod.InputMouseApply", function( oCmd )
	if LocalPlayer().IM_IsLocked then
		oCmd:SetMouseX(0)
		oCmd:SetMouseY(0)
		return true
	end
end )
