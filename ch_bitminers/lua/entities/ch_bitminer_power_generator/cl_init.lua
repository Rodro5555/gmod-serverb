include( "shared.lua" )

function ENT:DrawTranslucent()
	self:DrawModel()
end

function ENT:Initialize()
	if CH_Bitminers.Config.GeneratorSmokeEffect then
		self.EmitTime = CurTime()
		
		self.ExhaustPos = ParticleEmitter( self:GetPos() )
	end
end

function ENT:Think()
	-- Smoke effect when generator is on
	if CH_Bitminers.Config.GeneratorSmokeEffect then
		if self:GetPowerOn() then
			if self.EmitTime < CurTime() then
				local smoke = self.ExhaustPos:Add( "particle/smokesprites_000".. math.random( 1, 9 ), self:GetAttachment( 1 ).Pos )
				smoke:SetVelocity( Vector( 0, 0, 15 ) )
				smoke:SetDieTime( 1 )
				smoke:SetStartAlpha( 70 )
				smoke:SetEndAlpha( 5 )
				smoke:SetStartSize( math.random( 1, 3 ) )
				smoke:SetEndSize( math.random( 5, 7 ) )
				smoke:SetRoll( math.Rand( 180, 480 ) )
				smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
				smoke:SetColor( 0, 0, 0, 250 )
				smoke:SetGravity( Vector( 0, math.random( -35, 35 ), 15 ) )
				smoke:SetAirResistance( 200 )
				
				self.EmitTime = CurTime() + 0.02
			end
		end
	end
	
	-- Fuel Amount
	if self:GetFuel() >= 0 then
		self:SetPoseParameter( "arrow", self:GetFuel() )
	end
	
	self:InvalidateBoneCache()
end