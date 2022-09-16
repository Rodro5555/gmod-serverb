include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Pack()
	if not InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then return end
	
	local tTable = {
		Type = InvestigationMod:L( "Bullet" ),
		WeaponName = self:GetWeaponName(),
		WeaponModel = self:GetWeaponModel(),
		WeaponAmmo = self:GetWeaponAmmo(),
		Murder = self:GetMurder()
	}

	InvestigationMod.AddInventory( tTable )

	net.Start( "InvestigationMod.Pack" )
		net.WriteEntity( self )
	net.SendToServer()
end

local bHasAnalyzeAction

function ENT:CreateAnalyzeAction()
	bHasAnalyzeAction = true

	local aAngle = Angle( 0, 45, 90 )
	local vPosition = Vector( 0, 0, 15 )
	InvestigationMod.AddAction( self,  vPosition, aAngle, InvestigationMod:L( "Analyze" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Bullet" ][ "Analyze" ], function( eEntity )
		InvestigationMod.SetView( eEntity:GetPos() + Vector( 22.258112, 1, 16.744186 ), Angle( 10, 180, 5 ), false, false, eEntity )

		timer.Simple( 1, function()
			if not IsValid( self ) then return end

			InvestigationMod.Bloom( 1 )
			timer.Simple( 1, function()
				if IsValid( self ) then 
					InvestigationMod.Bloom( 2 )
				end
			end )

			local aAngle = Angle( 0, 85, 90 )
			local vPosition = Vector( 0, -6, 22 )
			InvestigationMod.AddInformations( self, vPosition, aAngle, InvestigationMod:L( "New clue" ) .. " : " .. string.upper( InvestigationMod:L( "Bullet" ) ),
				{ 
					string.format( InvestigationMod:L( "Weapon" ) .. " : %s",
						self:GetWeaponName() and list.Get( "Weapon" )[ self:GetWeaponName() ] and language.GetPhrase( list.Get( "Weapon" )[ self:GetWeaponName() ].PrintName ) or "UNKNOWN" ), 
					string.format( InvestigationMod:L( "Ammo" ) .. " : %s", game.GetAmmoName( self:GetWeaponAmmo() or 0 ) or "UNKNOWN" ) 
				} 
			, true )

			local aAngle = Angle( 0, 45, 90 )
			local vPosition = Vector( 2, 12, 15 )
			InvestigationMod.AddAction( self,  vPosition, aAngle, InvestigationMod:L( "TAKE IT" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Bullet" ][ "Take" ], function( eEntity )
				InvestigationMod.ClearView()
				InvestigationMod.RemoveAction( eEntity, InvestigationMod:L( "LEAVE IT" ) )
				InvestigationMod.RemoveInformations( eEntity, InvestigationMod:L( "New clue" ) .. " : " .. string.upper( InvestigationMod:L( "Bullet" ) ) )

				eEntity:Pack()
			end, true )

			local aAngle = Angle( 0, 110, 90 )
			local vPosition = Vector( 0, -15, 20 )
			InvestigationMod.AddAction( self,  vPosition, aAngle, InvestigationMod:L( "LEAVE IT" ), InvestigationMod:GetConfig( "KeysConfig" )[ "Bullet" ][ "Leave" ], function( eEntity )
				InvestigationMod.ClearView()
				InvestigationMod.RemoveAction( eEntity, InvestigationMod:L( "TAKE IT" ) )
				InvestigationMod.RemoveInformations( eEntity, InvestigationMod:L( "New clue" ) .. " : " .. string.upper( InvestigationMod:L( "Bullet" ) ) )

				eEntity:CreateAnalyzeAction()
			end, true )
		end )
		
	end, true, true )
end

function ENT:Initialize()
	if not InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then return end

	self:CreateAnalyzeAction()
end

function ENT:Think()
	if not bHasAnalyzeAction and InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then
		self:CreateAnalyzeAction()
	elseif bHasAnalyzeAction and not InvestigationMod:IsAllowedToInvestigate( LocalPlayer() ) then
		InvestigationMod.RemoveAction( self, InvestigationMod:L( "Analyze" ) )
		InvestigationMod.RemoveAction( self, InvestigationMod:L( "TAKE IT" ) )
		InvestigationMod.RemoveInformations( self, InvestigationMod:L( "New clue" ) .. " : " .. string.upper( InvestigationMod:L( "Bullet" ) ) )
		InvestigationMod.RemoveAction( self, InvestigationMod:L( "LEAVE IT" ) )
		bHasAnalyzeAction = nil
	end
end