include("shared.lua")


function ENT:Draw()

    self:DrawModel()
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * 12 + angle:Up() * 30 + angle:Right() * 0
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),-90);
	angle:RotateAroundAxis(angle:Up(), 0);
		
	local encsize = 1
	local litr = self:GetMilk()
	
	cam.Start3D2D(position, angle, 0.1)
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, -10-encsize+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, 10+ (1*20-20),  2+encsize, encsize, Color(255,255,255,255) )
		
		draw.RoundedBox( 0, -70, -10+ (1*20-20), 140, 20, Color(0,0,0,100) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Milk"][FarmingMod.Config.CurrentLang].." : "..litr.." L", "Trebuchet24" ,0,(1*20-20), Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
	
	cam.End3D2D()
	
end
