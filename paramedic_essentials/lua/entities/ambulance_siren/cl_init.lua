include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

local Lights = {}
Lights.Positions = {
{Vector(-25, 120, 40), Angle(0, 0, 0), Color(255,255,255,255), false};
{Vector(-32, 120, 40), Angle(0, 0, 0), Color(255,255,255,255), false};
{Vector(25, 120, 40), Angle(0, 0, 0), Color(255,255,255,255), true};
{Vector(32, 120, 40), Angle(0, 0, 0), Color(255,255,255,255), true};

{Vector(-37, -143, 92), Angle(180, -180, 0), Color(255,0,0,255), false};
{Vector(37, -143, 92), Angle(180, -180, 0), Color(255,0,0,255), true};

{Vector(25, 35, 92), Angle(0, 0, 0), Color(255,0,0,255), true};

{Vector(5, 45, 92), Angle(0, 0, 0), Color(255,0,0,255), false};

{Vector(-25, 35, 92), Angle(0, 0, 0), Color(255,0,0,255), false};

{Vector(-5, 45, 92), Angle(0, 0, 0), Color(255,0,0,255), true};
}

function ENT:Draw() 
	self:DrawTranslucent() 
end

function ENT:Initialize()
	self:SetNotSolid( true )
	self:DrawShadow( false )
	self.PixVis = util.GetPixelVisibleHandle()
	self.Parent = self:GetParent()
end

function ENT:DrawTranslucent()
	if !IsValid( self.Parent ) then
		self.Parent = self:GetParent()
	end
	
	if self:GetNWBool("LightOn") then 
		
		local LightControl = math.sin( CurTime() * 8 )
		local Light1On
		local Light2On
		
		if (LightControl > .5 and LightControl < .9) then
			Light1On = true
		elseif (LightControl > -0.9 and LightControl < -0.5) then
			Light2On = true
		end
		
		local CurLight = 0
		if Light1On then 
			CurLight = 1 
		end
		if Light2On then 
			CurLight = 2 
		end
		
		for k, v in pairs( Lights.Positions ) do	
			local LightPos = self.Parent:LocalToWorld( Vector( v[1].x, v[1].y, v[1].z ) )
			local LightAng = Angle( 0, v[2].y, v[2].r ) - Angle( -90, 90, 0 ) + self.Parent:GetAngles()
			local ViewNormal = LightPos - EyePos()
			ViewNormal:Normalize()
			
			if ViewNormal:Dot( LightAng:Up() ) >= 0 then
				render.SetMaterial( Material( "sprites/light_glow02_add" ) )
				
				local Visibile = util.PixelVisible( LightPos, 32, self.PixVis )
				if Visibile then
					if CurLight == 1 and v[4] == false then
						render.DrawSprite( LightPos + ViewNormal * -6, 50, 50, Color( v[3].r, v[3].g, v[3].b, 255 ), Visibile * ViewNormal:Dot( LightAng:Up() ) )
					elseif CurLight == 2 and v[4] == true then
						render.DrawSprite( LightPos + ViewNormal * -6, 50, 50, Color( v[3].r, v[3].g, v[3].b, 255 ), Visibile * ViewNormal:Dot( LightAng:Up() ) )
					end
				end
			end
		end
		
		local TopLight = DynamicLight( self:EntIndex() )
		if TopLight and ( CurLight == 1 ) then
			TopLight.Pos = self.Parent:LocalToWorld(Vector(0,200,20))
			TopLight.r = 255
			TopLight.g = 255
			TopLight.b = 255
			TopLight.Brightness = 6
			TopLight.Decay = 2000
			TopLight.Size = 200
			TopLight.DieTime = CurTime() + 0.1
		elseif TopLight and ( CurLight == 2 ) then
			TopLight.Pos = self.Parent:LocalToWorld( Vector(0, 50, 100) )
			TopLight.r = 255
			TopLight.g = 0
			TopLight.b = 0
			TopLight.Brightness = 6
			TopLight.Decay = 2000
			TopLight.Size = 200
			TopLight.DieTime = CurTime() + 0.1
		end
	end
	
	if not self.TheAmbulance then
		local closet
		
		for k, v in pairs( ents.FindByClass("prop_vehicle_jeep") ) do
			if v:GetPos():Distance( self:GetPos() ) < 10000 then
				closest = v
			end
		end
		
		if not closest then 
			return 
		end
		
		self.TheAmbulance = closest
		self.SirenSound = CreateSound( self.TheAmbulance, Sound( "craphead_scripts/medic_system/ambulance_siren.wav" ) )
	end
	
	if self:GetNWBool( "SirenOn", false ) then
		if ( not self.LastSirenPlay || self.LastSirenPlay <= CurTime() ) then
			self.LastSirenPlay = CurTime() + 6.7
			self.SirenSound:Stop()
			self.SirenSound:Play()
		end
	elseif self.LastSirenPlay then
		self.SirenSound:Stop()
		self.LastSirenPlay = nil
	end
end