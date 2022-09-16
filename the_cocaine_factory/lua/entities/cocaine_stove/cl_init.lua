include( "shared.lua" )

function ENT:Initialize()
	if TCF.Config.StoveSmokeEffect then
		self.emitTime = CurTime()
		
		self.potpos1 = ParticleEmitter( self:GetPos() )
		self.potpos2 = ParticleEmitter( self:GetPos() )
		self.potpos3 = ParticleEmitter( self:GetPos() )
		self.potpos4 = ParticleEmitter( self:GetPos() )
	end
end

local col_white_text = Color( 255, 255, 255, 150 )
local col_white_trans = Color( 255, 255, 255, 75 )
local col_white = Color( 255, 255, 255, 255 )
local col_black_outline = Color( 0, 0, 0, 255 )

function ENT:DrawTranslucent()
    self:DrawModel()
	
	if TCF.Config.ShowStoveHealth then
		local pos = self:GetPos()
		local ang = self:GetAngles()	
		
		ang:RotateAroundAxis( ang:Up(), 90 )
		ang:RotateAroundAxis( ang:Forward(), 90 )
		
		cam.Start3D2D( pos + ang:Up() * 16, ang, 0.09 )
			surface.SetDrawColor( col_white )
			surface.SetMaterial( Material( "craphead_scripts/the_cocaine_factory/bg_stripes.png") )
			surface.DrawTexturedRect( -100, -143, 200, 24 )
			
			surface.SetDrawColor( col_white_trans )
			surface.SetMaterial( Material( "craphead_scripts/the_cocaine_factory/bg_red.png") )
			surface.DrawTexturedRect( -100, -143, math.Clamp( self:GetHP(), 0, 200 ), 24 )
			
			draw.SimpleTextOutlined( self:GetHP() .." HP", "TCF_HealthDisplay", 0, -132, col_white_text, 1, 1, 1.4, col_black_outline )
		cam.End3D2D()
	end
end

function ENT:Think()
	if TCF.Config.StoveSmokeEffect then
		if self:GetGasAmount() > 0 then
			if self.emitTime < CurTime() then
				if self:GetPlate1() then
					if self:GetBodygroup( 11 ) == 1 then
						if self:GetCelious1() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos1:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 1 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, math.random( 115, 180 ) ) )
							smoke:SetDieTime( math.Rand( 1, 1 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
				if self:GetPlate2() then
					if self:GetBodygroup( 12 ) == 1 then
						if self:GetCelious2() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos2:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 2 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, math.random( 115, 180 ) ) )
							smoke:SetDieTime( math.Rand( 1, 1 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
				if self:GetPlate3() then
					if self:GetBodygroup( 13 ) == 1 then
						if self:GetCelious3() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos3:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 3 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, math.random( 115, 180 ) ) )
							smoke:SetDieTime( math.Rand( 1, 2 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
				if self:GetPlate4() then
					if self:GetBodygroup( 14 ) == 1 then
						if self:GetCelious4() >= TCF.Config.MinTemperatureForSmoke then
							local smoke = self.potpos4:Add( "particle/smokesprites_000"..math.random( 1, 9 ), self:GetAttachment( 4 ).Pos )
							smoke:SetVelocity( Vector( 0, 0, math.random( 115, 180 ) ) )
							smoke:SetDieTime( math.Rand( 1, 2 ) )
							smoke:SetStartAlpha( 5 )
							smoke:SetEndAlpha( 0 )
							smoke:SetStartSize( math.random( 5, 10 ) )
							smoke:SetEndSize( math.random( 20, 30 ) )
							smoke:SetRoll( math.Rand( 180, 480 ) )
							smoke:SetRollDelta( math.Rand( -3, 3 ) ) 
							smoke:SetColor( 255, 255, 255, 5 ) -- smoke:SetColor( math.random( 50, 100 ), math.random( 50, 100 ), math.random( 50, 100 ), 255 )
							smoke:SetGravity( Vector( 0, 0, 10 ) )
							smoke:SetAirResistance( 256 )
							
							self.emitTime = CurTime() + 0.1
						end
					end
				end
			end
		end
	end
	-- Plate Temperature 
	if self:GetCelious1() >= 0 then
		self:SetPoseParameter( "thermometer_1", self:GetCelious1() )
	end
	
	if self:GetCelious2() >= 0 then
		self:SetPoseParameter( "thermometer_2", self:GetCelious2() )
	end
	
	if self:GetCelious3() >= 0 then
		self:SetPoseParameter( "thermometer_3", self:GetCelious3() )
	end
	
	if self:GetCelious4() >= 0 then
		self:SetPoseParameter( "thermometer_4", self:GetCelious4() )
	end
	
	-- Gas Amount
	if self:GetGasAmount() >= 0 then
		self:SetPoseParameter( "arrow", self:GetGasAmount() )
	end
	
	if self:GetPlate1() then
		self:SetPoseParameter( "button_1", 100 )
	elseif not self:GetPlate1() then
		self:SetPoseParameter( "button_1", 0 )
	end
		
	if self:GetPlate2() then
		self:SetPoseParameter( "button_2", 100 )
	elseif not self:GetPlate2() then
		self:SetPoseParameter( "button_2", 0 )
	end
		
	if self:GetPlate3() then
		self:SetPoseParameter( "button_3", 100 )
	elseif not self:GetPlate3() then
		self:SetPoseParameter( "button_3", 0 )
	end
		
	if self:GetPlate4() then
		self:SetPoseParameter( "button_4", 100 )
	elseif not self:GetPlate4() then
		self:SetPoseParameter( "button_4", 0 )
	end
	
	self:InvalidateBoneCache()
end