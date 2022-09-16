include("shared.lua")


function ENT:Draw()

    self:DrawModel()
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * 9 + angle:Up() * 4 + angle:Right() * 0
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),-90);
	angle:RotateAroundAxis(angle:Up(), 0);
		
	local encsize = 1
	local perc = math.Round(self:GetWater()/200*100)
	
	cam.Start3D2D(position, angle, 0.08)
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70, -10-encsize+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (1*20-20), 2+encsize, encsize, Color(255,255,255,255) )
		draw.RoundedBox( 0, -70, 10+ (1*20-20),  2+encsize, encsize, Color(255,255,255,255) )
		
		draw.RoundedBox( 0, -70, -10+ (1*20-20), 140, 20, Color(0,0,0,100) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Water"][FarmingMod.Config.CurrentLang].." : "..perc.."%", "Trebuchet24" ,0,(1*20-20), Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
	
	cam.End3D2D()
	
	if perc <= 0 then return end
	
	local angle = self.Entity:GetAngles()
	local position = self.Entity:GetPos() + angle:Forward() * 0 + angle:Up() * 5 * perc/100 + angle:Right() * 0

	cam.Start3D2D(position, angle, 0.1)
		local sizex = 150
		local sizey = 150
		
		draw.RoundedBox( 130,-sizex/2,-sizey/2,sizex,sizey, Color(83,197,248,200) )
	cam.End3D2D()
end
