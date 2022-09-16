include( "shared.lua" )

function ENT:DrawTranslucent()
	self:DrawModel()
end

function ENT:Initialize()
	if TCF.Config.StoveSmokeEffect then
		self.emitTime = CurTime()
		
		self.pipepos1 = ParticleEmitter( self:GetPos() )
		self.pipepos2 = ParticleEmitter( self:GetPos() )
	end
end

local CurNumber = 0
local LastThink = 0
local SwitchSpeed = 300

local GaugeNumber = 0
local GaugeSpeed = ( 100 / TCF.Config.ExtractionTime )

net.Receive( "COCAINE_ExtractorGaugeBucketFill", function( length, ply )
	local extractor = net.ReadEntity()
	cocaine_bucket = net.ReadEntity()
	local gauge_on = net.ReadBool()
	
	extractor.GaugeOn = gauge_on
	if gauge_on then
		GaugeNumber = 0
	else
		GaugeNumber = 100
	end
end )

net.Receive( "COCAINE_ExtractorSwitch", function( length, ply )
	local extractor = net.ReadEntity()
	local switch_value = net.ReadBool()
	
	extractor.SwitchOn = switch_value
	if switch_value then
		CurNumber = 0
	else
		CurNumber = 100
	end
end )

function ENT:Think()
	-- Smoke effect when activated
	if TCF.Config.StoveSmokeEffect then
		if GaugeNumber > 0 then
			if self.emitTime < CurTime() then
				local smoke = self.pipepos1:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 8 ).Pos )
				smoke:SetVelocity( Vector( 0, 0, 125 ) )
				smoke:SetDieTime( math.Rand( 1, 1 ) )
				smoke:SetStartAlpha( 50 )
				smoke:SetEndAlpha( 5 )
				smoke:SetStartSize( math.random( 1, 3 ) )
				smoke:SetEndSize( math.random( 7, 15 ) )
				smoke:SetRoll( math.Rand( 180, 480 ) )
				smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
				smoke:SetColor( 200, 200, 200, 200 )
				smoke:SetGravity( Vector( -15, -35, 12 ) )
				smoke:SetAirResistance( 200 )

				local smoke2 = self.pipepos2:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 9 ).Pos )
				smoke2:SetVelocity( Vector( 0, 0, 125 ) )
				smoke2:SetDieTime( math.Rand( 1, 1 ) )
				smoke2:SetStartAlpha( 50 )
				smoke2:SetEndAlpha( 5 )
				smoke2:SetStartSize( math.random( 1, 3 ) )
				smoke2:SetEndSize( math.random( 7, 15 ) )
				smoke2:SetRoll( math.Rand( 180, 480 ) )
				smoke2:SetRollDelta( math.Rand( -3, 3 ) ) 
				smoke2:SetColor( 200, 200, 200, 200 )
				smoke2:SetGravity( Vector( -15, 35, 12 ) )
				smoke2:SetAirResistance( 200 )
				
				self.emitTime = CurTime() + 0.02
			end
		end
	end

	local now = CurTime()
	local timepassed = now - LastThink
	LastThink = now
	
	if self.SwitchOn then
		CurNumber = math.Approach( CurNumber, 100, SwitchSpeed * timepassed )
		
		self:SetPoseParameter( "switch", CurNumber )
	else
		CurNumber = math.Approach( CurNumber, 0, SwitchSpeed * timepassed )
		
		self:SetPoseParameter( "switch", CurNumber )
	end
	
	-- Leafs Amount
	if self:GetLeafs() >= 0 then
		self:SetPoseParameter( "arrow_1", self:GetLeafs() )
	end
		
	-- Baking Soda Amount
	if self:GetBakingSoda() >= 0 then
		self:SetPoseParameter( "arrow_2", self:GetBakingSoda() )
	end
	
	if IsValid( cocaine_bucket ) then
		if self.GaugeOn then
			GaugeNumber = math.Approach( GaugeNumber, 100, GaugeSpeed * timepassed )
			
			self:SetPoseParameter( "gauge", GaugeNumber )
			cocaine_bucket:SetPoseParameter( "cocaine", GaugeNumber )
		else
			GaugeNumber = math.Approach( GaugeNumber, 0, 20 * timepassed )
			
			self:SetPoseParameter( "gauge", GaugeNumber )
			cocaine_bucket:SetPoseParameter( "cocaine", 100 )
		end
	end
	
	self:InvalidateBoneCache()
end