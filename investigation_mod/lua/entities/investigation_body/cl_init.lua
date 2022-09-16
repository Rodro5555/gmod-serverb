include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

local bHasAnalyzeAction

function ENT:CreateBurnAction()
	local aAngle = Angle( 0, 45, 90 )
	local vPosition = Vector( 2, 5, 25 )
	InvestigationMod.AddAction( self:GetBody(),  vPosition, aAngle, InvestigationMod:L( "Burn" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Body" ][ "Burn" ], function( eEntity )
		net.Start( "InvestigationMod.BurnBody" )
			net.WriteEntity( self )
		net.SendToServer()
	end, true, true )
end

local DeathCauses
function ENT:CreateAnalyzeAction()
	bHasAnalyzeAction = true

	DeathCauses = DeathCauses or {
		[ DMG_GENERIC ] = InvestigationMod:L( "Wounded" ),
		[ DMG_CRUSH ] = InvestigationMod:L( "Crushed" ),
		[ DMG_BULLET ] = InvestigationMod:L( "Shot" ),
		[ DMG_BURN ] = InvestigationMod:L( "Burned" ),
		[ DMG_VEHICLE ] = InvestigationMod:L( "Vehicle hit" ),
		[ DMG_FALL ] = InvestigationMod:L( "Fall damage" ),
		[ DMG_BLAST ] = InvestigationMod:L( "Explosion damage" ),
		[ DMG_NEVERGIB ] = InvestigationMod:L( "Crossbow" ),
		[ DMG_NERVEGAS ] = InvestigationMod:L( "Neurotoxin" ),
		[ DMG_POISON ] = InvestigationMod:L( "Poison" ),
		[ DMG_RADIATION ] = InvestigationMod:L( "Radiation" ),
		[ DMG_ACID ] = InvestigationMod:L( "Acid" ),
	}

	local aAngle = Angle( 0, 45, 90 )
	local vPosition = Vector( 2, 5, 25 )
	InvestigationMod.AddAction( self:GetBody(),  vPosition, aAngle, InvestigationMod:L( "Analyze" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Body" ][ "Analyze" ], function( eEntity )
		InvestigationMod.SetView( eEntity:LocalToWorld( Vector( 25, 1, 17 ) ), eEntity:LocalToWorldAngles( Angle( 10, 180, 5 ) ), false, false, eEntity )

		local Timestamp = self:GetDeathTime()
		local TimeString = os.date( "%H:%M" , Timestamp )

		timer.Simple( 1, function()
			if not IsValid( self ) then return end

			InvestigationMod.Bloom( 1 )
			timer.Simple( 1, function()
				if IsValid( self ) then 
					InvestigationMod.Bloom( 2 )
				end
			end )
		
			local aAngle = Angle( 0, 70, 90 )
			local vPosition = Vector( 2, 0, 22 )
			InvestigationMod.AddInformations( self:GetBody(), vPosition, aAngle, InvestigationMod:L( "Information" ) .. " : " .. InvestigationMod:L( "CORPSE" ), 
				{
					string.format( "%s : %s", InvestigationMod:L( "State" ), InvestigationMod:L( "DEATH" ) ),
					string.format( "%s : %s", InvestigationMod:L( "Name" ), self:GetVictimName() ),
					string.format( "%s : %s", InvestigationMod:L( "Job" ), self:GetVictimJob() ),
					string.format( "%s : %s", InvestigationMod:L( "Death time" ), self:GetDeathTime() ~= -1 and TimeString or InvestigationMod:L( "UNKNOWN" ) ),					
					string.format( "%s : %s", InvestigationMod:L( "Death cause" ), ( ( self.GetDamageType and self:GetDamageType() ~= "" ) and self:GetDamageType() ) or ( DeathCauses ) and DeathCauses[ self:GetDamageType() ] or InvestigationMod:L( "UNKNOWN" ) ),					
				} 
			)
		end )
		
		local aAngle = Angle( 0, 110, 90 )
		local vPosition = Vector( 0, -15, 23 )
		InvestigationMod.AddAction( self:GetBody(),  vPosition, aAngle, InvestigationMod:L( "SEND TO MORGUE" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Body" ][ "Morgue" ], function( eEntity )
			InvestigationMod.ClearView()
			InvestigationMod.RemoveAction( eEntity, InvestigationMod:L( "LEAVE IT" ) )
			InvestigationMod.RemoveInformations( eEntity, InvestigationMod:L( "Information" ) .. " : " .. InvestigationMod:L( "CORPSE" ) )

			if not IsValid( self ) or not IsValid( self:GetBody() ) then return end
			net.Start( "InvestigationMod.BodyToMorgue" )
				net.WriteEntity( self:GetBody() )
			net.SendToServer()
		end )

		local aAngle = Angle( 0, 85, 90 )
		local vPosition = Vector( 0, -8, 15 )
		InvestigationMod.AddAction( self:GetBody(),  vPosition, aAngle, InvestigationMod:L( "LEAVE IT" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Body" ][ "Leave" ], function( eEntity )

			InvestigationMod.ClearView()
			InvestigationMod.RemoveAction( eEntity, InvestigationMod:L( "SEND TO MORGUE" ) )
			InvestigationMod.RemoveInformations( eEntity, InvestigationMod:L( "Information" ) .. " : " .. InvestigationMod:L( "CORPSE" ) )

			if not IsValid( self ) then return end

			self:CreateAnalyzeAction()
		end )
	end, true, true )
end


function ENT:Initialize()
	if InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then 
		self:CreateAnalyzeAction()
	elseif InvestigationMod:GetConfig( "CanBurnBody" ) and IsValid( self:GetCriminal() ) and self:GetCriminal() == LocalPlayer() then
		self:CreateBurnAction()
	end
end

function ENT:Think()
	if not bHasAnalyzeAction and InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then
		self:CreateAnalyzeAction()
	elseif bHasAnalyzeAction and not InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then
		if IsValid( self:GetBody() ) then
			InvestigationMod.RemoveAction( self:GetBody(), InvestigationMod:L( "Analyze" ) )
			InvestigationMod.RemoveAction( self:GetBody(), InvestigationMod:L( "SEND TO MORGUE" ) )
			InvestigationMod.RemoveInformations( self:GetBody(), InvestigationMod:L( "Information" ) .. " : " .. InvestigationMod:L( "CORPSE" ) )
			InvestigationMod.RemoveAction( self:GetBody(), InvestigationMod:L( "LEAVE IT" ) )
		end

		bHasAnalyzeAction = nil
	end
end