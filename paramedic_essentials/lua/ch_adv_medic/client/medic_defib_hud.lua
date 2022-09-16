local alpha = 0

net.Receive( "ADV_MEDIC_DEFIB_UpdateSeconds", function()
    CH_AdvMedic.NextRespawn = net.ReadInt( 32 )
end )

local function ADV_MEDIC_PlayerWithinBounds( ply, otherPly, dist )
	return ply:GetPos():DistToSqr( otherPly ) < ( dist*dist )
end

function ADV_MEDIC_DEFIB_HUDPaint()
	if LocalPlayer():getDarkRPVar( "AFK" ) then -- DarkRP kills you when AFK, so if AFK we don't want to draw this shit show on their screen
		return
	end
	
	if LocalPlayer():Alive() then
		if alpha != 0 then
			if alpha >= CH_AdvMedic.Config.DarkestAlpha then
				alpha = 0
			end
		end
	end
	
	if not LocalPlayer():Alive() and CH_AdvMedic.NextRespawn then
		if CH_AdvMedic.Config.BecomeDarkerWhenDead then
			alpha = math.Clamp( alpha + 0.1, 0, CH_AdvMedic.Config.DarkestAlpha )
			
			surface.SetDrawColor( 0, 0, 0, alpha )
			surface.DrawRect( 0, 0, ScrW(), ScrH() )
		end
		
		if CH_AdvMedic.NextRespawn - CurTime() > 0 then
			draw.SimpleText( CH_AdvMedic.Config.Lang["You have died"][CH_AdvMedic.Config.Language], "MEDIC_UIFontTitle", ScrW() / 2, (ScrH() / 2) - ScrH() * 0.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( CH_AdvMedic.Config.Lang["Paramedics can rescue you using defibrillators"][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() / 2, (ScrH() / 2) - ScrH() * 0.06, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( CH_AdvMedic.Config.Lang["Please wait"][CH_AdvMedic.Config.Language] .." ".. math.Round( CH_AdvMedic.NextRespawn - CurTime() ) .." ".. CH_AdvMedic.Config.Lang["seconds to respawn"][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() / 2, (ScrH() / 2) - ScrH() * 0.04, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			if CH_AdvMedic.Config.ClickToRespawn then 
				draw.SimpleText( CH_AdvMedic.Config.Lang["Click to respawn"][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
        end
	end
end
hook.Add( "HUDPaint", "ADV_MEDIC_DEFIB_HUDPaint", ADV_MEDIC_DEFIB_HUDPaint )

function ADV_MEDIC_DrawLifeAlert()
	if not CH_AdvMedic.Config.LifeAlertDistance then
		return
	end
	
	if not table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( LocalPlayer():Team() ) ) then
		return
	end
	
	if not LocalPlayer():Alive() then
		return
	end

	for k, corpse in ipairs( ents.FindByClass( "prop_ragdoll" ) ) do
		if corpse:GetNWBool( "RagdollIsCorpse" ) and corpse:GetNWBool( "HasLifeAlert" ) then
			local npcpos = corpse:GetPos()
			local pos = npcpos:ToScreen()
			
			if not ADV_MEDIC_PlayerWithinBounds( LocalPlayer(), corpse:GetPos(), 150 ) then
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_AdvMedic.Config.LifeAlertIcon )
				surface.DrawTexturedRect( pos.x, pos.y, 16, 16 )
				
				surface.SetFont( "MEDIC_UITextSmall" )
				local x, y = surface.GetTextSize( CH_AdvMedic.Config.Lang["Distance"][CH_AdvMedic.Config.Language] .." : ".. math.Round( npcpos:Distance( LocalPlayer():GetPos() ) ) )
				draw.SimpleText( CH_AdvMedic.Config.Lang["Distance"][CH_AdvMedic.Config.Language] .." : ".. math.Round( npcpos:Distance( LocalPlayer():GetPos() ) ), "MEDIC_UITextSmall", pos.x - 35, pos.y + 20, color_white )
			end
		end
	end
end
hook.Add( "HUDDrawTargetID", "ADV_MEDIC_DrawLifeAlert", ADV_MEDIC_DrawLifeAlert )

function ADV_MEDIC_DrawLifeAlert_Halo()
	if not CH_AdvMedic.Config.LifeAlertHalo then
		return
	end
	
	if not table.HasValue( CH_AdvMedic.Config.AllowedTeams, team.GetName( LocalPlayer():Team() ) ) then
		return
	end
	
	if not LocalPlayer():Alive() then
		return
	end
	
	local halo_corpse = {}
	local count = 0
	
	for k, corpse in ipairs( ents.FindByClass( "prop_ragdoll" ) ) do
		if corpse:GetNWBool( "RagdollIsCorpse" ) and corpse:GetNWBool( "HasLifeAlert" ) then
			count = count + 1
			halo_corpse[ count ] = corpse
		end
	end
	
	halo.Add( halo_corpse, CH_AdvMedic.Config.LifeAlertHaloColor, 1, 1, 2, true, true )
end
hook.Add( "PreDrawHalos", "ADV_MEDIC_DrawLifeAlert_Halo", ADV_MEDIC_DrawLifeAlert_Halo )