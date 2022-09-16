include("shared.lua")

function ENT:Initialize()
	self.Battery = 100
	self.Speed = 1
	self.PrintedMoney = 0
	self.PrintRate = 50
	self.Name = "Impresora Nivel 1"
	self.StarMaterial = Material( "icon16/star.png", "noclamp")
end

local function getOwningPlayerName(ent)
	local Player = ent:Getowning_ent()
	if IsValid(Player) and Player:Name() != nil then
		return Player:Name()
	end
	return "Unknown"
end

function ENT:Draw()
	self:DrawModel()
	if self:GetPos():Distance(LocalPlayer():GetPos()) < 500 then -- How far people can see printer UI
		
		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Up(), 90)

		cam.Start3D2D(Pos + Ang:Up() * 10.8 + Ang:Forward() * -15 + Ang:Right() * -16.1, Ang, 0.11)
			draw.RoundedBox( 0, 0, 0, 275, 275, Color(20,20,20,255) )
			draw.RoundedBox( 0, 10, 59, 255, 60, Color(40,40,40,255) )
			draw.RoundedBox( 0, 10, 127, 120, 90, Color(40,40,40,255) )
			draw.RoundedBox( 0, 139, 127, 126, 90, Color(40,40,40,255) )
			draw.RoundedBox( 0, 0, 0, 275, 50, Color(0,123,255,255) )
			surface.DrawOutlinedRect( 0, 0, 275, 275 )
			surface.DrawOutlinedRect( 1, 1, 273, 273 )
			draw.TexturedQuad
			{
				texture = surface.GetTextureID "gui/gradient_up",
				color = Color(0, 80, 200, 255),
				x = 0,
				y = 0,
				w = 275,
				h = 50
			}
			surface.SetDrawColor(Color(0,123,255,255))
			draw.RoundedBox( 0, 0, 225, 275, 50, Color(0,123,255,255) )
			draw.TexturedQuad
			{
				texture = surface.GetTextureID "gui/gradient_up",
				color = Color(0, 80, 200, 255),
				x = 0,
				y = 225,
				w = 275,
				h = 50
			}
			draw.DrawText( self.Name, "HUDNumber5", 137.5, 10, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			draw.DrawText( getOwningPlayerName(self), "HUDNumber5", 137.5, 235, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			draw.DrawText( "Velocidad:", "HUDNumber5", 25, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			
			for i=0,8 do
				if self.Speed > i then
					surface.SetMaterial( self.StarMaterial )
					surface.SetDrawColor( Color(255, 255, 255, 255) )
					surface.DrawTexturedRect( 25+20*i, 95, 16, 16 )
				else
					surface.SetMaterial( self.StarMaterial )
					surface.SetDrawColor( Color(20, 20, 20, 255) )
					surface.DrawTexturedRect( 25+20*i, 95, 16, 16 )
				end
			end
			
			draw.RoundedBox( 0, 210, 80, 46, 30, Color(0,150,0,255) )
			draw.RoundedBox( 0, 212, 82, 42, 26, Color(0,0,0,150) )
			
			draw.DrawText( "Buy", "Trebuchet24", 218, 83, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			draw.RoundedBox( 0, 17, 160, 100, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 21, 164, 92, 42, Color(60,60,60,255) )
			
			local Col2 = Color(0,140,0,255)
			local Col3 = Color(0,180,0,255)
			if self.Battery > 0 and self.Battery < 25 then
				Col2 = Color(140,0,0,255)
				Col3 = Color(180,0,0,255)
			elseif self.Battery > 25 and self.Battery < 50 then
				Col2 = Color(180,180,0,255)
				Col3 = Color(240,240,0,255)
			elseif self.Battery > 50 then
				Col2 = Color(0,180,0,255)
				Col3 = Color(0,220,0,255)
			end
			
			surface.SetDrawColor(Col3)
			surface.DrawRect(21, 164, 0.92*self.Battery, 42)
			draw.TexturedQuad
			{
				texture = surface.GetTextureID "gui/gradient_up",
				color = Col2,
				x = 21,
				y = 164,
				w = 0.92*self.Battery,
				h = 42
			}
			
			draw.RoundedBox( 0, 117, 173, 5, 25, Color(200,200,200,255) )
			
			draw.RoundedBox( 0, 40, 160, 4, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 65, 160, 4, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 90, 160, 4, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 10, 127, 120, 27, Color(0,0,0,120) )
			
			draw.DrawText( "Bateria: "..self.Battery.."%", "HudHintTextLarge",70, 132, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			
			draw.RoundedBox( 0, 139, 167, 126, 50, Color(0,123,255,255) )
			draw.RoundedBox( 0, 142, 170, 120, 44, Color(0,0,0,150) )
			draw.RoundedBox( 0, 139, 127, 126, 27, Color(0,0,0,120) )
			draw.DrawText( "Rinde: "..self.PrintRate .."$/min.", "HudHintTextLarge",200, 132, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			draw.DrawText( "$"..self.PrintedMoney, "HUDNumber5", 155, 176, Color(255,255,255,255), TEXT_ALIGN_LEFT )
		cam.End3D2D()
		-- Ang:RotateAroundAxis(Ang:Forward(), 90)
		-- cam.Start3D2D(Pos + Ang:Up() * 16.4 + Ang:Forward() * -15 + Ang:Right() * -10.2, Ang, 0.11)
		-- 	draw.RoundedBox( 0, 0, 0, 275, 90, Color(40,40,40,255) )
		-- 	surface.SetDrawColor(Color(0,123,255,255))
		-- 	surface.DrawOutlinedRect( 5, 0, 200, 86)
		-- 	surface.DrawOutlinedRect( 6, 1, 198, 84)
		-- 	draw.RoundedBox( 0, 0, 0, 275, 35, Color(0,0,0,150) )
		-- 	draw.RoundedBox( 0, 11, 41, 188, 40, Color(0,123,255,255) )
		-- 	draw.RoundedBox( 0, 16, 46, 175, 30, Color(40,40,40,255) )
		-- 	draw.TexturedQuad
		-- 	{
		-- 		texture = surface.GetTextureID "models/shadertest/shader3",
		-- 		color = Color(255,255,255,255),
		-- 		x = 16,
		-- 		y = 46,
		-- 		w = 1.78*self.Cooling,
		-- 		h = 30
		-- 	}
			
		-- 	draw.DrawText( "Refrigeración: "..self.Cooling.."%", "Trebuchet24",100, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER )
		-- cam.End3D2D()
		-- cam.Start3D2D(Pos + Ang:Up() * 16.9 + Ang:Forward() * 7.9 + Ang:Right() * -10.2, Ang, 0.11)
		-- 	draw.RoundedBox( 0, 0, 0, 70, 90, Color(40,40,40,255) )
		-- 	draw.RoundedBox( 0, 0, 0, 70, 25, Color(0,0,0,150) )
		-- 	surface.SetDrawColor(Color(0,123,255,255))
		-- 	surface.DrawOutlinedRect( 0, 0, 70, 90)
		-- 	surface.DrawOutlinedRect( 1, 1, 68, 88)
			
		-- 	draw.RoundedBox( 0, 5, 30, 15, 53, Color(200,200,200,255) )
		-- 	local Col = Color(0,0,255,255)
		-- 	if self.Heat > 0 and self.Heat < 30 then
		-- 		Col = Color(0,0,255,255)
		-- 	elseif self.Heat > 30 and self.Heat < 60 then
		-- 		Col = Color(255,255,0,255)
		-- 	elseif self.Heat > 60 then
		-- 		Col = Color(255,0,0,255)
		-- 	end
		-- 	draw.RoundedBox( 0, 6, 82, 13, -0.51*self.Heat, Col)
			
		-- 	draw.DrawText( "Calor", "HudHintTextLarge", 35,5, Color(255,255,255,255), TEXT_ALIGN_CENTER )
		-- 	draw.DrawText( "Peligro", "Default", 22,30, Color(255,255,255,255), TEXT_ALIGN_LEFT )
		-- 	draw.DrawText( "Caliente", "Default", 22,50, Color(255,255,255,255), TEXT_ALIGN_LEFT )
		-- 	draw.DrawText( "Frío", "Default", 22,70, Color(255,255,255,255), TEXT_ALIGN_LEFT )
		-- cam.End3D2D()
	end
end


net.Receive("UpdatePrinter",function() 
	local Tabl = net.ReadTable()
	local Entity = net.ReadEntity()
	
	Entity.Battery = Tabl.Battery
	Entity.Speed = Tabl.Speed
	Entity.PrintedMoney = Tabl.PrintedMoney
	Entity.PrintRate = Tabl.PrintRate
	Entity.Name = Tabl.Name
end)