game.AddParticles("particles/hen_feather.pcf")
PrecacheParticleSystem( "hen_feather" )

local VehiclesList = {}

net.Receive("UpdateVehicleList.FarmingMod", function()
	VehiclesList = net.ReadTable()	
end)

hook.Add("HUDPaint", "HUDPaint.FarmingMod", function()
	
	local trace = LocalPlayer():GetEyeTrace()
	local entAim = trace.Entity or NULL
	
	if not IsValid( entAim ) then return end

	if not entAim:IsVehicle() then return end

	if team.GetName(LocalPlayer():Team()) != "Granjero" then return end
	
	if entAim:GetOwner() != LocalPlayer() and entAim:CPPIGetOwner() != LocalPlayer() then return end
	
	if entAim:GetPos():Distance(LocalPlayer():GetPos()) > 350 then return end
	
	for index, infos in pairs( VehiclesList ) do
		
		local ent = infos.ent or NULL
		
		if not IsValid( ent ) then 
			ent = ents.GetByIndex( index ) or NULL
			
			if not IsValid( ent ) then 
				return
			end
		end 
		
		if ent == entAim then
			
			local lp = ent:WorldToLocal(trace.HitPos)
			if lp.x > -51 and lp.x < 51 and lp.y < 3 and lp.y > -210 and lp.z > 40 and lp.z < 130 then
				surface.SetFont("Trebuchet24")
				local textsizex = surface.GetTextSize( "Put animals and eggs in the truck" )
				
				local encsize = 2
		
				local alpha = 255 
				local alpha2 = 150 
				
				local sizex = 30
				local sizey = 30
				
				local posx = ScrW()/2-textsizex/2
				local posy = ScrH()/2
				
				draw.RoundedBox( 0,posx+ -sizex/2-encsize,posy+ -sizey/2-encsize + (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ sizex/2,posy+ sizey/2-encsize-2+ (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ -sizex/2-encsize,posy+ sizey/2-encsize-2+ (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ sizex/2,posy+ -sizey/2-encsize+ (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ -sizex/2,posy+ -sizey/2-encsize+ (1*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ sizex/2-encsize-2,posy+ -sizey/2-encsize+ (1*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ sizex/2-encsize-2,posy+ sizey/2+ (1*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ -sizex/2,posy+ sizey/2+ (1*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
				draw.RoundedBox( 0,posx+ -sizex/2, posy+ -sizey/2+ (1*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
				draw.SimpleTextOutlined(FarmingMod.Config.Lang["Put animals and eggs in the truck"][FarmingMod.Config.CurrentLang], "Trebuchet24" ,posx+sizex/2+10,posy, Color(255,255,255,255), 0, 1, 0.5, Color(0,0,0,2555))
				draw.SimpleTextOutlined("R", "DermaLarge" ,posx-8,posy, Color(255,255,255,255), 0, 1, 0.5, Color(0,0,0,255))
			end
		
		end
	
	end

end)


-- copy code and replace vehicle list
hook.Add("PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.FarmingMod", function()

	for index, infos in pairs( VehiclesList ) do
		
		local ent = infos.ent or NULL
		
		if not IsValid( ent ) then 
			ent = ents.GetByIndex( index ) or NULL
			
			if not IsValid( ent ) then 
				return
			end
		end 
		
		if ent:IsVehicle() then
			if ent:GetOwner() == LocalPlayer() or ent:CPPIGetOwner() == LocalPlayer() && team.GetName(LocalPlayer():Team())=="Granjero" then 
				if VehiclesList[ent:EntIndex()] then
					local angle = ent:LocalToWorldAngles(infos.infosang)	
					
					local position = ent:LocalToWorld( infos.infospos )
						
					local encsize = 2
				
					local alpha = 255 *	(math.Clamp(1000-ent:GetPos():Distance(LocalPlayer():GetPos()),0,1000)/1000)
					local alpha2 = 100 * (math.Clamp(1000-ent:GetPos():Distance(LocalPlayer():GetPos()),0,1000)/1000)
					
					local sizex = 270
					local sizey = 30
					
					cam.Start3D2D(position, angle, 0.3)
						
						draw.RoundedBox( 0, -sizex/2-encsize, -sizey/2-encsize + (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, sizey/2-encsize-2+ (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2-encsize, sizey/2-encsize-2+ (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, -sizey/2-encsize+ (1*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, -sizey/2-encsize+ (1*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, -sizey/2-encsize+ (1*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, sizey/2+ (1*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, sizey/2+ (1*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
						
						draw.RoundedBox( 0, -sizex/2, -sizey/2+ (1*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
						
						local eggs = ent:GetNWInt("Egg") or 0
						
						draw.SimpleTextOutlined(FarmingMod.Config.Lang["Eggs"][FarmingMod.Config.CurrentLang].." : "..eggs.."/96", "Trebuchet24" ,0,(1*sizey-sizey), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
					
						draw.RoundedBox( 0, -sizex/2-encsize, -sizey/2-encsize + (2.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, sizey/2-encsize-2+ (2.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2-encsize, sizey/2-encsize-2+ (2.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, -sizey/2-encsize+ (2.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, -sizey/2-encsize+ (2.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, -sizey/2-encsize+ (2.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, sizey/2+ (2.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, sizey/2+ (2.5*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
						
						draw.RoundedBox( 0, -sizex/2, -sizey/2+ (2.5*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
						
						local cow = ent:GetNWInt("Cow") or 0
						
						draw.SimpleTextOutlined(FarmingMod.Config.Lang["Cows"][FarmingMod.Config.CurrentLang].." : "..cow, "Trebuchet24" ,0,(2.5*sizey-sizey), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
						
						draw.RoundedBox( 0, -sizex/2-encsize, -sizey/2-encsize + (4*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, sizey/2-encsize-2+ (4*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2-encsize, sizey/2-encsize-2+ (4*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, -sizey/2-encsize+ (4*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, -sizey/2-encsize+ (4*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, -sizey/2-encsize+ (4*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, sizey/2+ (4*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, sizey/2+ (4*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
						
						draw.RoundedBox( 0, -sizex/2, -sizey/2+ (4*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
						
						local hen = ent:GetNWInt("Hen") or 0
						
						draw.SimpleTextOutlined(FarmingMod.Config.Lang["Hens"][FarmingMod.Config.CurrentLang].." : "..hen, "Trebuchet24" ,0,(4*sizey-sizey), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
						
						draw.RoundedBox( 0, -sizex/2-encsize, -sizey/2-encsize + (5.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, sizey/2-encsize-2+ (5.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2-encsize, sizey/2-encsize-2+ (5.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, -sizey/2-encsize+ (5.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, -sizey/2-encsize+ (5.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, -sizey/2-encsize+ (5.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, sizey/2+ (5.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, sizey/2+ (5.5*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
						
						draw.RoundedBox( 0, -sizex/2, -sizey/2+ (5.5*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
						
						local pig = ent:GetNWInt("Pig") or 0
						
						draw.SimpleTextOutlined(FarmingMod.Config.Lang["Pigs"][FarmingMod.Config.CurrentLang].." : "..pig, "Trebuchet24" ,0,(5.5*sizey-sizey), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
						
						draw.RoundedBox( 0, -sizex/2-encsize, -sizey/2-encsize + (7*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, sizey/2-encsize-2+ (7*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2-encsize, sizey/2-encsize-2+ (7*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, -sizey/2-encsize+ (7*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, -sizey/2-encsize+ (7*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, -sizey/2-encsize+ (7*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, sizey/2+ (7*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, sizey/2+ (7*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
						
						draw.RoundedBox( 0, -sizex/2, -sizey/2+ (7*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
						
						local sheep = ent:GetNWInt("Sheep") or 0
						
						draw.SimpleTextOutlined(FarmingMod.Config.Lang["Goats"][FarmingMod.Config.CurrentLang].." : "..sheep, "Trebuchet24" ,0,(7*sizey-sizey), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
					
						draw.RoundedBox( 0, -sizex/2-encsize, -sizey/2-encsize + (8.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, sizey/2-encsize-2+ (8.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2-encsize, sizey/2-encsize-2+ (8.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2, -sizey/2-encsize+ (8.5*sizey-sizey), encsize, 2+encsize*2, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, -sizey/2-encsize+ (8.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, -sizey/2-encsize+ (8.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, sizex/2-encsize-2, sizey/2+ (8.5*sizey-sizey), 2+encsize, encsize, Color(255,255,255,alpha) )
						draw.RoundedBox( 0, -sizex/2, sizey/2+ (8.5*sizey-sizey),  2+encsize, encsize, Color(255,255,255,alpha) )
						
						draw.RoundedBox( 0, -sizex/2, -sizey/2+ (8.5*sizey-sizey), sizex, sizey, Color(0,0,0,alpha2) )
						
						local weight = ent:GetNWInt("Weight") or 0
						
						draw.SimpleTextOutlined(FarmingMod.Config.Lang["Total weight"][FarmingMod.Config.CurrentLang].." : "..math.Round(weight,2).." / 1000 kg ", "Trebuchet24" ,0,(8.5*sizey-sizey), Color(255,255,255,alpha), 1, 1, 0.5, Color(0,0,0,alpha))
						
					cam.End3D2D()
				end
			end 
		end 
		
	end

end)