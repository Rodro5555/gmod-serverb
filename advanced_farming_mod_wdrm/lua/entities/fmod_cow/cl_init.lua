include('shared.lua')
 
ENT.RenderGroup = RENDERGROUP_BOTH
 
function ENT:Draw()
	self:DrawModel()
	
	local angle = self:GetAngles()	
	
	-- local position = self.Entity:GetPos() + angle:Forward() * 57.2 * 1.3 + angle:Up() * 46 * 1.3 + angle:Right() * -3.4 * 1.3
	local boneid = self:LookupBone( "COWeye1" )
	local bonepos = (boneid and self:GetBonePosition( boneid )) or self.Entity:GetPos() + angle:Forward() * 57.2 * 1.3 + angle:Up() * 46 * 1.3 + angle:Right() * -3.4 * 1.3
	local position = bonepos
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),36);
	angle:RotateAroundAxis(angle:Up(), 0);
		
		
	cam.Start3D2D(position, angle, 0.2 * 1.3)
	
		draw.RoundedBox( 0, -9,-9,18,18, Color(0,0,0,255) )
		
	cam.End3D2D()
	
	local angle = self:GetAngles()	
	
	local boneid = self:LookupBone( "COWeye02" )
	local bonepos = self:GetBonePosition( boneid )	
	local position = bonepos
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),-36);
	angle:RotateAroundAxis(angle:Up(), 0);
		
		
	cam.Start3D2D(position, angle, 0.2 * 1.3)
	
		draw.RoundedBox( 0, -9,-9,18,18, Color(0,0,0,255) )
		
	cam.End3D2D()

	------------------------------
	local boneid = self:LookupBone( "CATRigHub003" )
	local bonepos = self:GetBonePosition( boneid )	
	local position = bonepos + Vector(0,0,60)
	local angle = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	local thirst = self:GetThirst()
	-- local hunger = self:GetHunger()
	if thirst <= 0 then
		cam.Start3D2D(position, angle, 1.0)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( "icon16/drink.png" ) )
			surface.DrawTexturedRect( -8, 0, 24, 24 )
		cam.End3D2D()
	-- elseif hunger <= 0 then
	-- 	cam.Start3D2D(position, angle, 1.0)
	-- 		surface.SetDrawColor( 255, 255, 255, 255 )
	-- 		surface.SetMaterial( Material( "rlib/modules/arivia/v3/ico/tabs/food.png" ) )
	-- 		surface.DrawTexturedRect( -8, 0, 24, 24 )
	-- 	cam.End3D2D()
	end
	------------------------------
	
	if LocalPlayer():GetEyeTrace().Entity != self then return end
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * 10 + angle:Up() * 55 + angle:Right() * 17
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),-0);
	angle:RotateAroundAxis(angle:Up(), 0);
		
	local encsize = 1
	
	local alpha = 255 *	(math.Clamp(250-self:GetPos():Distance(LocalPlayer():GetPos()),0,250)/250)
	local alpha2 = 100 *	(math.Clamp(250-self:GetPos():Distance(LocalPlayer():GetPos()),0,250)/250)
	
	cam.Start3D2D(position, angle, 0.15)
		
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (1*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, -10-encsize+ (1*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (1*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (1*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, 10+ (1*20-20),  2+encsize, encsize, Color(255,255,255,alpha) )
		
		draw.RoundedBox( 0, -70, -10+ (1*20-20), 140, 20, Color(0,0,0,alpha2) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Hunger"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetHunger()).."%", "Trebuchet24" ,0,(1*20-20), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, -10-encsize+ (2.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, -10-encsize+ (2.5*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (2.5*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (2.5*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, 10+ (2.5*20-20),  2+encsize, encsize, Color(255,255,255,alpha) )
		
		draw.RoundedBox( 0, -70, -10+ (2.5*20-20), 140, 20, Color(0,0,0,alpha2) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Thirst"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetThirst()).."%", "Trebuchet24" ,0,(2.5*20-20), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
		
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (4*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (4*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (4*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, -10-encsize+ (4*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, -10-encsize+ (4*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (4*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (4*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, 10+ (4*20-20),  2+encsize, encsize, Color(255,255,255,alpha) )
		
		draw.RoundedBox( 0, -70, -10+ (4*20-20), 140, 20, Color(0,0,0,alpha2) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Age"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetAge()).." y", "Trebuchet24" ,0,(4*20-20), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
		
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, -10-encsize+ (5.5*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, -10-encsize+ (5.5*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (5.5*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (5.5*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, 10+ (5.5*20-20),  2+encsize, encsize, Color(255,255,255,alpha) )
		
		draw.RoundedBox( 0, -70, -10+ (5.5*20-20), 140, 20, Color(0,0,0,alpha2) )
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Weight"][FarmingMod.Config.CurrentLang].." : "..math.Round(self:GetWeight()).." kg", "Trebuchet24" ,0,(5.5*20-20), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
	
		draw.RoundedBox( 0, -70-encsize, -10-encsize + (7*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, 10-encsize-2+ (7*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70-encsize, 10-encsize-2+ (7*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70, -10-encsize+ (7*20-20), encsize, 2+encsize*2, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, -10-encsize+ (7*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, -10-encsize+ (7*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, 70-encsize-2, 10+ (7*20-20), 2+encsize, encsize, Color(255,255,255,alpha) )
		draw.RoundedBox( 0, -70, 10+ (7*20-20),  2+encsize, encsize, Color(255,255,255,alpha) )
		
		draw.RoundedBox( 0, -70, -10+ (7*20-20), 140, 20, Color(0,0,0,alpha2) )
		
		local milk = math.Clamp(self:GetMilk(),0,100)
		draw.SimpleTextOutlined(FarmingMod.Config.Lang["Milk"][FarmingMod.Config.CurrentLang].." : "..milk.."%", "Trebuchet24" ,0,(7*20-20), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
	
		
	cam.End3D2D()

end
