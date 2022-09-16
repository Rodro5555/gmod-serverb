--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

AddCSLuaFile()
TOOL.Category = "Realistic Police"
TOOL.Name = "Plate-Setup"
TOOL.Author = "Kobralost"
TOOL.StepID = 1 

if CLIENT then 
	RPTStepID = 1 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "use" },
		{ name = "reload" },
	}
	language.Add("tool.realistic_police_plate_tool.name", "License Plate Setup")
	language.Add("tool.realistic_police_plate_tool.desc", "Create or modify License Plate in your server")
	language.Add("tool.realistic_police_plate_tool.left", "Left-Click to select the vehicle & Place the License Plate" )
	language.Add("tool.realistic_police_plate_tool.use", "Use to return to the previous step and modify the first License Plate" )
	language.Add("tool.realistic_police_plate_tool.right", "Right-Click to delete the license plate of the vehicle" )
	language.Add("tool.realistic_police_plate_tool.reload", "Reload to go to the next step & Place two License Plate" )
end 

-- Reset Variables of the Plate ( Rotation , Size , Position)
local function ResetPosition()
	RPTPosition = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	}
	RPTPosition2 = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	}
end 

function TOOL:Deploy()
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	if SERVER then 
		self.StepID = 1 
	elseif CLIENT then 
		RPTToolSetup = false 
		RPTStepID = 1 
		RPTGhostActivate = true 
		ResetPosition()
	end 
end 

function TOOL:Reload()
	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.1

	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	if CLIENT then 	
		if RPTStepID == 2 then 
			if PosPlate != nil then 
				RPTStepID = 3 
				RPTGhostActivate = true 
			end 
		end 
	end 
end 

hook.Add("KeyPress", "RealisticPolice:KeyPress", function(ply, key)
	if ( key == IN_USE ) then
		if CLIENT then 
			if IsValid(ply) && ply:IsPlayer() then 
				if Realistic_Police.AdminRank[ply:GetUserGroup()] then
					if RPTStepID == 3 then
						RPTStepID = 2 
						RPTGhostActivate = true 
					end 
				end 
			end 
		end 
	end
end )

function TOOL:RightClick() -- Remove the Plate 
	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.5

	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end

	if CLIENT then 
		if Realistic_Police.AdminRank[LocalPlayer():GetUserGroup()] then
			if RPTStepID == 2 then 
				PosPlate = nil 
				RPTGhostActivate = true 
			end 
			if RPTStepID == 3 then 
				PosPlate2 = nil
				RPTGhostActivate = true   
			end 
		end 
	elseif SERVER then 
		local EntityTrace = self:GetOwner():GetEyeTrace().Entity 
		local RealisticPoliceFil = file.Read("realistic_police/vehicles.txt", "DATA") or ""
		local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}

		if istable(RealisticPoliceTab[EntityTrace:GetModel()]) then 
			if EntityTrace:IsVehicle() then 
				RealisticPoliceTab[EntityTrace:GetModel()] = nil 
				file.Write("realistic_police/vehicles.txt", util.TableToJSON(RealisticPoliceTab))

				timer.Simple(0.1, function()
					local RealisticPoliceFil = file.Read("realistic_police/vehicles.txt", "DATA") or ""
					local RealisticPoliceTab = util.JSONToTable(RealisticPoliceFil) or {}
					local CompressTable = util.Compress(RealisticPoliceFil)
					net.Start("RealisticPolice:SendInformation")
						net.WriteInt(CompressTable:len(), 32)
						net.WriteData(CompressTable, CompressTable:len() )
					net.Broadcast()
				end )
			end 
		else 
			EntityTrace:Remove()
		end  
	end 
end 

function TOOL:Think() -- Debug 
	if SERVER then 
		if not IsValid(self.car_setup) then 
			if self.StepID > 1 then 
				net.Start("RealisticPolice:UpdateInformation")
				net.Send(self:GetOwner())
				self.StepID = 1 
			end 
		end
	end 
end 

if CLIENT then 
	net.Receive("RealisticPolice:UpdateInformation", function()
		if IsValid(RPTMain) then RPTMain:Remove() end 
		RPTStepID = 1 
		RPTToolSetup = false
		PosPlate = nil 
		RPTGhostActivate = true 
		PosPlate2 = nil
		RPTGhostActivate = true   
		ResetPosition()
	end ) 
end 

function TOOL:LeftClick(trace) -- Place the Plate 
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end 
	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.3
	
	if SERVER then 
		local EntityTrace = trace.Entity 
		if EntityTrace:IsVehicle() then 
			if IsValid(self.car_setup) then 
				self.car_setup:Remove()
				self.StepID = 2 
			end 
		end 
		if self.StepID == 2 then 
			timer.Simple(0.2, function()
				if IsValid(self:GetOwner()) then 
					net.Start("RealisticPolice:SetupVehicle")
						net.WriteEntity(self.car_setup)
					net.Send(self:GetOwner())
				end 
			end )
		end 
		if self.StepID == 1 then 
			if IsValid(EntityTrace) then
				local EntitiyLook = self:GetOwner():GetEyeTrace().Entity
				self.car_setup = ents.Create( "prop_physics" )
				self.car_setup:SetModel( EntitiyLook:GetModel() )
				self.car_setup:SetPos( EntitiyLook:GetPos() )
				self.car_setup:SetAngles( Angle(0,0,0)  )
				self.car_setup.VehicleSetupRPT = true 
				self.car_setup.Owner = self:GetOwner()
				self.car_setup:Spawn()
				local phys = self.car_setup:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:EnableMotion(false)
				end
				timer.Create("rpt_timer_setupvehicle"..self.car_setup:EntIndex(), 0.1, 0, function()
					if not IsValid(self.car_setup) then timer.Remove("rpt_timer_setupvehicle") RPTToolSetup = false end 
					if IsValid(self.car_setup) then 
						self.car_setup:SetAngles( Angle(0,0,0)  )
						local phys = self.car_setup:GetPhysicsObject()
						if phys and phys:IsValid() then
							phys:EnableMotion(false)
						end
					end 
				end )
				EntitiyLook:Remove()
				self.StepID = 2 
			end 
		end  
	elseif CLIENT then  
		ResetPosition()
		local EntityTrace = trace.Entity 
		if RPTStepID == 2 then 
			if RPTToolSetup then 
				PosPlate = LocalPlayer():GetEyeTrace().HitPos
				local ang = LocalPlayer():GetAimVector():Angle() 
				AngPlate = Angle(0, ang.Yaw + -90, 90):SnapTo( "y", 1 )
				RPTGhostActivate = false  
			end 
		end 
		if RPTStepID == 3 then 
			PosPlate2 = LocalPlayer():GetEyeTrace().HitPos
			local ang = LocalPlayer():GetAimVector():Angle() 
			AngPlate2 = Angle(0, ang.Yaw + -90, 90):SnapTo( "y", 1 )
			RPTGhostActivate = false 
		end  
		if EntityTrace:IsVehicle() then
			RPTGhostActivate = true  
			RPTToolSetup = true
			RPTStepID = 2 
		end 
	end 
end 

function TOOL:Holster()
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	if CLIENT then 
		RPTToolSetup = false
		RPTGhostActivate = false 
		PosPlate = nil 
		PosPlate2 = nil  
		if IsValid(RPTMain) then RPTMain:Remove() end  
		ResetPosition()
	else 
		if IsValid(self.car_setup) then self.car_setup:Remove() end 
	end 
end

local toolGun = {
	[1] = Realistic_Police.GetSentence("configureLicenseplate"),
	[2] = Realistic_Police.GetSentence("placeLicenseplate"),
	[3] = Realistic_Police.GetSentence("placeLicenseplate2"),
}

function TOOL:DrawToolScreen( w, h )
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	if CLIENT then
		surface.SetDrawColor( Realistic_Police.Colors["black"] )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( Realistic_Police.Colors["bluetool"] )
		surface.DrawRect( 15, 20, w-30, 70 )
		surface.SetDrawColor( Realistic_Police.Colors["white"] )
		surface.DrawRect( 15, 85 , w-30, 2 )
		surface.SetDrawColor( Realistic_Police.Colors["white"] )
		surface.DrawRect( 15, 25, w-30, 2 )
		draw.SimpleText("Step "..RPTStepID, "rpt_font_18", w/2, h/5,Realistic_Police.Colors["white"],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.DrawText(toolGun[RPTStepID], "rpt_font_18", w/2, h/2.3,Realistic_Police.Colors["white"],TEXT_ALIGN_CENTER)
	end 
end

local function RealisticPoliceGhost(pos, ang, RptTable)
	cam.Start3D2D( pos, ang, 0.02 )
		if Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["Image"] != nil then 
			surface.SetDrawColor( Realistic_Police.Colors["gray"] )
			surface.SetMaterial( Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["Image"] )
			surface.DrawTexturedRect( 0, 0, 1400 + RptTable[7], 400 + RptTable[8])
		end	
		if Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["Country"] != nil then 
			local Country = Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["Country"]
			draw.SimpleText(Country, Realistic_Police.Fonts((1400  + RptTable[7])/12 + RptTable[8]*0.05), (1400  + RptTable[7]) - (1400  + RptTable[7])/Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["CountryPos"][1], (400  + RptTable[8])/Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["CountryPos"][2], Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["CountryColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		end 
		if Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["Department"] != nil then 
			draw.SimpleText(Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["Department"], Realistic_Police.Fonts((1400  + RptTable[7])/13+ RptTable[8]*0.05), (1400  + RptTable[7])/1.06, (400  + RptTable[8])/1.4, Realistic_Police.Colors["gray"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		end 
		if not Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlateText"] then 
			draw.SimpleText("ABDS582D", Realistic_Police.Fonts((1400  + RptTable[7])/6 + RptTable[8]*0.05),(1400  + RptTable[7])/Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][1] - 5, (400  + RptTable[8])/ Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][2]+5, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			draw.SimpleText("ABDS582D", Realistic_Police.Fonts((1400  + RptTable[7])/6  + RptTable[8]*0.05), (1400  + RptTable[7])/Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][1], (400  + RptTable[8])/ Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][2], Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		else
			draw.SimpleText("AA-123-BB", Realistic_Police.Fonts((1400  + RptTable[7])/6 + RptTable[8]*0.05),(1400  + RptTable[7])/Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][1] - 5, (400  + RptTable[8])/ Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][2]+5, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			draw.SimpleText("AA-123-BB", Realistic_Police.Fonts((1400  + RptTable[7])/6 + RptTable[8]*0.05),(1400  + RptTable[7])/Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][1], (400  + RptTable[8])/ Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["PlatePos"][2], Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		end 
		if Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["ImageServer"] != nil then 
			surface.SetDrawColor( Realistic_Police.Colors["gray"] )
			surface.SetMaterial( Realistic_Police.PlateConfig[Realistic_Police.LangagePlate]["ImageServer"] )
			surface.DrawTexturedRect( (1400  + RptTable[7])/1.104, (400  + RptTable[8])/6, (1400  + RptTable[7])/14,(400  + RptTable[8])/3 )
		end 
	cam.End3D2D()
end 
if CLIENT then -- Preview of the Plate 
	hook.Add("PostDrawTranslucentRenderables", "RPT:LicensePlateTool", function() -- Draw Plate  
		if RPTToolSetup then 
			if PosPlate != nil then 
				RealisticPoliceGhost(PosPlate + Vector(RPTPosition[1],RPTPosition[2],RPTPosition[3]), AngPlate + Angle(RPTPosition[4],RPTPosition[5],RPTPosition[6]), RPTPosition)
			end 
			if PosPlate == nil or PosPlate2 == nil then 
				if RPTGhostActivate then 
					local Pos = LocalPlayer():GetEyeTrace().HitPos
					local ang = LocalPlayer():GetAimVector():Angle() 
					RPTAngSnap = Angle(0, ang.Yaw + -90, 90):SnapTo( "y", 1 ) 
					RealisticPoliceGhost(Pos, RPTAngSnap + Angle(RPTPosition[4],RPTPosition[5],RPTPosition[6]), RPTPosition)
				end 
			end 
			if PosPlate2 != nil then 
				RealisticPoliceGhost(PosPlate2 + Vector(RPTPosition2[1],RPTPosition2[2],RPTPosition2[3]), AngPlate2 + Angle(RPTPosition2[4],RPTPosition2[5],RPTPosition2[6]), RPTPosition2)
			end 
		end 
	end )
end 

