include('shared.lua')
 
ENT.RenderGroup = RENDERGROUP_BOTH
 
function ENT:Draw()
	self:DrawModel()

	------------------------------
	local boneid = self:LookupBone( "Bone" )
	local bonepos = self:GetBonePosition( boneid )	
	local position = bonepos + Vector(0,0,40)
	local angle = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	local thirst = self:GetThirst()
	local hunger = self:GetHunger()
	if thirst <= 0 then
		cam.Start3D2D(position, angle, 1.0)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( "icon16/drink.png" ) )
			surface.DrawTexturedRect( -8, 0, 24, 24 )
		cam.End3D2D()
	elseif hunger <= 0 then
		cam.Start3D2D(position, angle, 1.0)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( "rlib/modules/arivia/v3/ico/tabs/food.png" ) )
			surface.DrawTexturedRect( -8, 0, 24, 24 )
		cam.End3D2D()
	end
	------------------------------
	
	if LocalPlayer():GetEyeTrace().Entity != self then return end
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * -2 + angle:Up() * 33 + angle:Right() * 12.5
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),-0);
	angle:RotateAroundAxis(angle:Up(), 0);
		
	local encsize = 1
		
	cam.Start3D2D(position, angle, 0.12)
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, -10-encsize+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, 10+ (1*20-20),  2+encsize, encsize, Color(255,255,255,255) )
		
		draw.RoundedBox( 0, -70, -10+ (1*20-20), 140, 20, Color(0,0,0,100) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Hunger"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetHunger()).."%", "Trebuchet24" ,0,(1*20-20), Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, -10-encsize+ (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, -10-encsize+ (2.5*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (2.5*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (2.5*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, 10+ (2.5*20-20),  2+encsize, encsize, Color(255,255,255,255) )
		
		draw.RoundedBox( 0, -70, -10+ (2.5*20-20), 140, 20, Color(0,0,0,100) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Thirst"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetThirst()).."%", "Trebuchet24" ,0,(2.5*20-20), Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
		
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (4*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (4*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (4*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, -10-encsize+ (4*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, -10-encsize+ (4*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (4*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (4*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, 10+ (4*20-20),  2+encsize, encsize, Color(255,255,255,255) )
		
		draw.RoundedBox( 0, -70, -10+ (4*20-20), 140, 20, Color(0,0,0,100) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Age"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetAge()).." y", "Trebuchet24" ,0,(4*20-20), Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, -10-encsize+ (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, -10-encsize+ (5.5*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (5.5*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (5.5*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, 10+ (5.5*20-20),  2+encsize, encsize, Color(255,255,255,255) )
		
		draw.RoundedBox( 0, -70, -10+ (5.5*20-20), 140, 20, Color(0,0,0,100) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Weight"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetWeight()).." kg", "Trebuchet24" ,0,(5.5*20-20), Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
	
	cam.End3D2D()
end
