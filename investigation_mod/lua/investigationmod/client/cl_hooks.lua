local tMaterials = {
	[0] = Material( "materials/investigationmod/left-feet.png" ),
 	[1] = Material( "materials/investigationmod/right-feet.png" ),
 	[2] = Material( "materials/investigationmod/handprint.png" ),
}

local pLocalPlayer

hook.Add( "InitPostEntity", "InitPostEntity.InvestigationMod", function()
	pLocalPlayer = LocalPlayer()
end )

hook.Add( "PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.InvestigationMod", function()
	pLocalPlayer = pLocalPlayer or LocalPlayer()

	if not pLocalPlayer:Alive() then return end

	--[[
		Draw actions & interactions
	]]
	for eEntity, sActions in pairs( InvestigationMod.Actions ) do
		for sActionName, tActionInfos in pairs( sActions ) do
			if tActionInfos.data then
				InvestigationMod.DrawAction( unpack( tActionInfos.data ) )
			end
		end
	end

	--[[
		Draw informations tabs
	]]
	for eEntity, tTitles in pairs( InvestigationMod.Informations ) do
		for sTitle, tInformations in pairs( tTitles ) do
			if tInformations.data then
				InvestigationMod.DrawInformations( unpack( tInformations.data ) )
			end
		end
	end

	--[[
		Draw fingerprints & footsteps
	]]

	local tTrace = pLocalPlayer:GetEyeTrace()

	-- Draw fingerprints only if there is the flashlight OR if it has been revealed
	for sPlayer, tDoors in pairs( InvestigationMod.DoorFingerprint or {} ) do
		for iDoor, tFingerprint in pairs( tDoors ) do
			
			if not tFingerprint.Action and ( not IsValid( pLocalPlayer:GetActiveWeapon() ) or pLocalPlayer:GetActiveWeapon():GetClass() ~= "investigation_flashlight" or  not pLocalPlayer.UseInvestigationFlashlight ) then continue end

			-- GetByIndex only once
			local eDoor = tFingerprint.entity or ents.GetByIndex( iDoor ) 

			if not IsValid( eDoor ) then continue end
			tFingerprint.entity = eDoor
			local tDistance = eDoor:LocalToWorld( tFingerprint.pos ):DistToSqr( tTrace.HitPos )

			if tDistance > 12000 then continue end

			local vWorldPos = eDoor:LocalToWorld( tFingerprint.pos )
			local aAngle = eDoor:LocalToWorldAngles( tFingerprint.realAngle )
			cam.Start3D2D( vWorldPos, aAngle + Angle( 0, 90, 90 ), 0.05)
				surface.SetDrawColor( 255, 255, 255, 100 )
				surface.SetMaterial( tMaterials[ 2 ] )
				surface.DrawTexturedRect( -100, -100, 200, 200 )
			cam.End3D2D()

			if tFingerprint.Action then continue end

			if tDistance < 100 and pLocalPlayer:GetPos():DistToSqr( vWorldPos ) < 5500 then
				tFingerprint.Action = true
				InvestigationMod.RemoveAction( eDoor, InvestigationMod:L( "TAKE IT" ) )
				InvestigationMod.AddAction( eDoor, tFingerprint.pos + tFingerprint.pos:Angle():Up() * 8 + tFingerprint.pos:Angle():Right() * 1+ tFingerprint.pos:Angle():Forward() * 5, tFingerprint.realAngle + Angle( 0, 75, 90 ), InvestigationMod:L( "TAKE IT" ),  InvestigationMod:GetConfig( "KeysConfig" )[ "Fingerprint" ][ "Take" ], function()

					local tTable = {
						Type = InvestigationMod:L( "Fingerprint" ),
						Murder = player.GetBySteamID( sPlayer or 0 )
					}

					InvestigationMod.AddInventory( tTable )

					net.Start( "InvestigationMod.TakeFingerprint" )
						net.WriteString( sPlayer )
						net.WriteUInt( iDoor, 16 )
					net.SendToServer()
				end )
			end
		end
	end

	-- Draw footsteps only if there is the flashlight
	if not IsValid( pLocalPlayer:GetActiveWeapon() ) or pLocalPlayer:GetActiveWeapon():GetClass() ~= "investigation_flashlight" then return end
	if not pLocalPlayer.UseInvestigationFlashlight then return end

	for _, tFootInfo in pairs( InvestigationMod.FootSteps or {} ) do
		if tFootInfo.pos:DistToSqr( tTrace.HitPos ) > 12000 then continue end
		cam.Start3D2D( tFootInfo.pos, tFootInfo.angle, 0.05)
			surface.SetDrawColor( 255, 255, 255, 100 )
			surface.SetMaterial( tMaterials[ tFootInfo.foot or 0 ] )
			surface.DrawTexturedRect( 0, 0, 512, 345 )
		cam.End3D2D()
	end

	
end )

hook.Add( "CalcView", "CalcView.InvestigationMod", function()
	pLocalPlayer = pLocalPlayer or LocalPlayer()

	if InvestigationMod.MoveView then
		pLocalPlayer:DrawViewModel( false )
		if not pLocalPlayer:Alive() or InvestigationMod.MoveView.position:DistToSqr( pLocalPlayer:GetPos() ) > 25000 then InvestigationMod.ClearView() return end

		if InvestigationMod.MoveView.linkedEntity and ( not IsValid( InvestigationMod.MoveView.linkedEntity ) or InvestigationMod.MoveView.linkedEntity:GetPos():DistToSqr( pLocalPlayer:GetPos() ) > 25000 ) then
			InvestigationMod.ClearView()
			return
		end

		local EyePos = pLocalPlayer:EyePos()
		local EyeAngle = pLocalPlayer:GetAngles()

		if InvestigationMod.MoveView.shoudlLastView then
			if InvestigationMod.MoveView.shoudlLastView.CurrentValues then
				local oldVal = InvestigationMod.MoveView.shoudlLastView.CurrentValues
				EyePos = oldVal.pos or EyePos
				EyeAngle = oldVal.angle or EyeAngle
			end
		end

		if InvestigationMod.MoveView.shouldAnimate then
			local lerpValue = math.Clamp( CurTime() - InvestigationMod.MoveView.startTime, 0, 1 )
			local position = InvestigationMod.MoveView.position + ( math.sin( CurTime() / 5 ) ) * Vector( 0, 2, 0 )
			local angle = InvestigationMod.MoveView.angle +  ( math.sin( CurTime() / 5 ) ) * Angle( 0, 3, 0 )
			InvestigationMod.MoveView.CurrentValues = {
				pos = LerpVector( lerpValue, EyePos, position ),
				angle = LerpAngle( lerpValue, EyeAngle, angle )
			}
			return {
				origin = InvestigationMod.MoveView.CurrentValues.pos,
				angles = InvestigationMod.MoveView.CurrentValues.angle,
				fov = 85,
			}
		else
			local lerpValue = math.Clamp( CurTime() - InvestigationMod.MoveView.startTime, 0, 1 )

			InvestigationMod.MoveView.CurrentValues = {
				pos = LerpVector( lerpValue, EyePos, InvestigationMod.MoveView.position ),
				angle = LerpAngle( lerpValue, EyeAngle, InvestigationMod.MoveView.angle ),
			}

			return {
				origin = InvestigationMod.MoveView.CurrentValues.pos,
				angles = InvestigationMod.MoveView.CurrentValues.angle,
				fov = 85,
			}
		end
	end
end )

hook.Add( "HUDPaint", "HUDPaint.InvestigationMod", function()
	if InvestigationMod.MoveView then return end

	local tInventory = InvestigationMod.GetInventory()

	if not ( tInventory ) or table.IsEmpty( tInventory ) then return end

	local posx, posy = ScrH() * 0.02, ScrH() * 0.02
	local titleSize = math.ceil( ScrH() * 0.035 )
	local margin = math.ceil( ScrH() * 0.009 )
	local sTitle = string.upper( InvestigationMod:L( "FORENSIC EVIDENCE" ) )

	surface.SetFont( "InvestigationUI-30B" )
	local x, y = surface.GetTextSize( sTitle )

	local sizex, sizey = x + 2 * margin, titleSize + ( titleSize + margin / 1.5 ) * ( table.Count( tInventory ) )

	draw.RoundedBox( 0, posx, posy, sizex, sizey, Color( 40, 40, 40, 150 ) )
	draw.EdgeRectangle( posx + 1, posy + 1, sizex - 2, sizey - 2, Color( 0, 0, 0, 155 ), 3, 10 )
	draw.EdgeRectangle( posx, posy, sizex, sizey, Color( 27, 132, 196, 255 ), 3, 10 )

	draw.SimpleText( sTitle, "InvestigationUI-30B", posx + sizex / 2 + 2, posy + margin * 2 + 2, Color( 0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( sTitle, "InvestigationUI-30B", posx + sizex / 2, posy + margin * 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	local iAmountDrawn = 0
	for iID, tInfo in pairs( tInventory ) do
		local elementPosx, elementPosy = posx + margin, posy + titleSize  + ( titleSize  +  margin / 2 ) * iAmountDrawn
		draw.RoundedBox( 0, elementPosx, elementPosy, sizex - margin * 2, titleSize,  Color( 50, 50, 50, 100 ) )
		draw.EdgeRectangle( elementPosx, elementPosy, sizex - margin * 2, titleSize , color_white, 1, 5 )
		draw.SimpleText( ( tInfo.Type or "Object" ) .. " #" .. iID, "InvestigationUI-25B", 2 + elementPosx + ( sizex - margin * 2 ) / 2, 2 + elementPosy + titleSize/2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( ( tInfo.Type or "Object" ) .. " #" .. iID, "InvestigationUI-25B", elementPosx + ( sizex - margin * 2 ) / 2, elementPosy + titleSize/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		iAmountDrawn = ( iAmountDrawn or 0 ) + 1
	end
end )

local tBloomModes = {
	[ 1 ] = function()
		local fTimeBloom = 0.6

		if CurTime() - InvestigationMod.PlayBloom > fTimeBloom then
			InvestigationMod.PlayBloom = nil
			return
		end

		local lerpValue = ( CurTime() - InvestigationMod.PlayBloom ) / fTimeBloom

		if lerpValue > 0.5 then
			lerpValue = 0.5 - ( lerpValue - 0.5 )
		end

		lerpValue = lerpValue * 2
		DrawBloom( lerpValue * 0.27, lerpValue * 3.32, lerpValue * 12.84, 0, lerpValue * 1, lerpValue * 1, lerpValue * 64 / 255, lerpValue * 200 / 255, lerpValue * 255 / 255 )
	end, 
	[ 2 ] = function()
		DrawBloom( 0.27, 0.42, 22.84, 0, 1, 1, 64 / 255, 200 / 255, 255 / 255 )
	end,
}

hook.Add( "RenderScreenspaceEffects", "RenderScreenspaceEffects.InvestigationMod", function()
	if InvestigationMod.PlayBloom then
		tBloomModes[ InvestigationMod.BloomMode or 1 ]( InvestigationMod.PlayBloom )
	end
end )