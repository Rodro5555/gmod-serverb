--[[
 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   
                                                                                                                                                                                        
--]] 

AddCSLuaFile()
TOOL.Category = "Realistic Woodcutter"
TOOL.ClientConVar["radius"] = 1000 
TOOL.Name = "Rwc-SetupVehicle"
TOOL.RWCStepId = 0
TOOL.tbl_props = {}
TOOL.tbl_save = {}
TOOL.Table = {}
TOOL.Plate = nil 
TOOL.Author = "Kobralost & Jhon"

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
	}
	language.Add("tool.realistic_woodcutter_setupvehicle.name", "WoodCutter Setup")
	language.Add("tool.realistic_woodcutter_setupvehicle.desc", "Create or modify a Vehicle trunk")
	language.Add("tool.realistic_woodcutter_setupvehicle.left", "Left-Click to configure the vehicle" )
	language.Add("tool.realistic_woodcutter_setupvehicle.right", "Right-Click for delete the vehicle of the data" )
end

net.Receive("RealisticWoodCutter:UpdateTool", function()
	local Ent = net.ReadEntity() or nil 
	local Table = net.ReadTable() or {}
	local Int = net.ReadInt(11) or 0 
	if Ent != nil then 
		Ent.Tool["realistic_woodcutter_setupvehicle"]["RWCStepId"] = Int
		if istable(Table) then 
			Ent.Tool["realistic_woodcutter_setupvehicle"]["tbl_props"] = Table 
		end 
	end 
end ) 

function TOOL:Deploy()
	if self:GetOwner().CarRwc == false or self:GetOwner().CarRwc == nil then 
		if self.Resume == nil then 
			self.tbl_props = {}
			self.tbl_save = {}
			self.Table = {}
			self.RWCStepId = 0
			self:GetOwner().CarRwc = false 
		else 
			self.RWCStepId = self.Resume
		end 
	end 

	hook.Add("PlayerDeath", "RWC:DeathDebug", function(ply)
		if IsValid(self.car_setup) then 
			self.car_setup:Remove()
			self.tbl_props = {}
			self.tbl_save = {}
			self.Table = {}
			self.RWCStepId = 0
			self:GetOwner().CarRwc = false 
			self:UpdateTool(0)
		end 	
	end )
end 

function TOOL:UpdateTool(id)
	net.Start("RealisticWoodCutter:UpdateTool")
		net.WriteEntity(self.SWEP)
		net.WriteTable(self.tbl_props)
		net.WriteInt(id, 11)
	net.Send(self:GetOwner())
end 

function TOOL:RightClick(trace)
	if trace.Entity:IsVehicle() then 
		local TableFile = file.Read("realistic_woodcutter/vehicle"..".txt", "DATA") or ""
		local Table = util.JSONToTable(TableFile) or {}	

		for k,v in pairs(Table) do 
			if v.ModelVehicle == trace.Entity:GetModel() then 
				Table[trace.Entity:GetModel()] = nil 
				file.Write("realistic_woodcutter/vehicle"..".txt", util.TableToJSON(Table,true))
				trace.Entity:Remove()
			end 
		end 
	end 
	if trace.Entity.VehicleSetupRwc then 
		self:UpdateTool(0)
		trace.Entity:Remove()
		self.RWCStepId = 0
		self.Resume = nil 
		for k,v in pairs(self.tbl_props) do
			if v:IsValid() then
				if not v.iscar then
					v:Remove()
					self.tbl_props[k] = nil
				end
			end
		end
	else 
		if SERVER then 
			if IsValid(self.tbl_props[#self.tbl_props]) then 
				self.tbl_props[#self.tbl_props]:Remove()
				self.tbl_props[#self.tbl_props] = nil 
			end 
		end 
	end 
end 

function TOOL:LeftClick(trace)
	local ply = self:GetOwner() 
	local EntityTrace = trace.Entity
	if not Realistic_Woodcutter.AdminTable[ply:GetUserGroup()] then return end 

	ply.countdownTool = ply.countdownTool or CurTime()
    if ply.countdownTool > CurTime() then return end
    ply.countdownTool = CurTime() + 0.1

	if SERVER then 
		if self.RWCStepId == 0 then 
			if istable(self.tbl_props) then 
				for k,v in pairs(self.tbl_props) do 
					if IsValid(v) then 
						v:Remove()
					end 
				end 
			end 
			if EntityTrace:IsVehicle() && IsValid(EntityTrace) then 
				self.Class = EntityTrace:GetClass()
				self.car_setup = ents.Create( "prop_physics" )
				self.car_setup:SetModel( EntityTrace:GetModel() )
				self.car_setup:SetPos( EntityTrace:GetPos() )
				self.car_setup:SetAngles( Angle(0,0,0)  )
				self.car_setup.VehicleSetupRwc = true 
				self.car_setup.Owner = self:GetOwner()
				self.car_setup:Spawn()
				self:GetOwner().CarRwc = true 
				table.insert(self.tbl_props, self.car_setup)
				timer.Simple(0.2, function() self.RWCStepId = 1 end ) 
				timer.Create("rwc_timer_setupvehicle", 0.5, 0, function()
					if not IsValid(self.car_setup) then timer.Remove("rwc_timer_setupvehicle") end 
					if IsValid(self.car_setup) && self.car_setup != NULL then 
						self.car_setup:SetAngles( Angle(0,0,0)  )
						local phys = self.car_setup:GetPhysicsObject()
						if phys and phys:IsValid() then
							phys:EnableMotion(false)
						end
					end 
				end )
				EntityTrace:Remove()
				timer.Simple(0.1,function()
					self.RWCStepId = 1 
				end ) 
				local car_setup_phys = self.car_setup:GetPhysicsObject()
				car_setup_phys:EnableMotion(false)	
			end 
		elseif self.RWCStepId > 0 &&  self.RWCStepId < 6 then 
			local rwsent = ents.Create( "prop_physics" )
			rwsent:SetModel( Realistic_Woodcutter.SetupVehc[self.RWCStepId]["model"] )
			rwsent:SetPos( ply:GetEyeTrace().HitPos )
			rwsent:Spawn()
			table.insert(self.tbl_props, rwsent) 
		end 
		if self.RWCStepId == 6 then 
			trace = util.TraceLine(util.GetPlayerTrace(ply))
			ang = ply:GetAimVector():Angle() 
			Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)
			Ang = Angle(90, ang.Yaw, 0):SnapTo( "y", 45 ) 
			if IsValid(self.plate) then 
				self.plate:Remove()
			end 
			self.plate = ents.Create( "prop_physics" )
			self.plate:SetModel( "models/hunter/plates/plate025x05.mdl" )
			self.plate:SetPos( Pos )
			self.plate:SetAngles( Ang  )
			self.plate:Spawn()
			self.plate:SetParent(trace.Entity)
		end 
	end 
	if EntityTrace:IsVehicle() && IsValid(EntityTrace) then 
		self.RWCStepId = self.RWCStepId + 1
	end 
end

function TOOL:CreateRWCEnt()	
	if CLIENT then
		if self.RWCStepId == 6 then 
			if not IsValid(self.RWCEnt) then
				self.RWCEnt = ClientsideModel("models/hunter/plates/plate025x05.mdl", RENDERGROUP_OPAQUE)
				self.RWCEnt:SetModel("models/hunter/plates/plate025x05.mdl")
				self.RWCEnt:SetMaterial("models/wireframe")
				self.RWCEnt:SetPos(Vector(0,0,0))
				self.RWCEnt:SetAngles(Angle(0,0,0))
				self.RWCEnt:Spawn()
				self.RWCEnt:Activate()	
				self.RWCEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
				self.RWCEnt:SetColor(Color( 255, 255, 255, 150))
			end
		end 
	end 
end

function TOOL:Reload()
	local ply = self:GetOwner() 
	ply.countdownTool = ply.countdownTool or CurTime()
    if ply.countdownTool > CurTime() then return end
    ply.countdownTool = CurTime() + 1
	
	if istable(self.tbl_props) then 
		if #self.tbl_props == 0 then return end 
	end 
	if self.RWCStepId > 0 && self.RWCStepId < 6 then
		if SERVER then 
			self.Table[self.RWCStepId] = {}
			for k,v in pairs(self.tbl_props) do
				if not v.VehicleSetupRwc then
					if v:IsValid() then
						local pos, ang = WorldToLocal( v:GetPos(), v:GetAngles(), self.car_setup:GetPos(), self.car_setup:GetAngles())
						table.insert(self.Table[self.RWCStepId], {
							AngleEnt = ang, 
							PosEnt = pos, 
						})
						v:Remove()
						self.tbl_props[k] = nil
					end
				end 
			end
		end 
		self.RWCStepId = self.RWCStepId + 1 
		if SERVER then 
			self:UpdateTool(self.RWCStepId)
		end 
	end 
	if self.RWCStepId == 6 then 
		if CLIENT then 
			self:CreateRWCEnt() 
		end 
	end 
	if self.RWCStepId == 6 then 
		if SERVER then 
			if IsValid(self.car_setup) && isentity(self.car_setup) then 
				local TableFile = file.Read("realistic_woodcutter/vehicle"..".txt", "DATA") or ""
				local Table = util.JSONToTable(TableFile) or {}

				if not file.Exists("realistic_woodcutter", "DATA") then
					file.CreateDir("realistic_woodcutter") 
				end

				local angplate = self.plate:GetAngles():SnapTo( "p", 45 ):SnapTo( "y", 45 ):SnapTo( "r", 45 )
				local posplate = self.car_setup:WorldToLocal(self.plate:GetPos()+angplate:Right()*-9.75+angplate:Up()*0+angplate:Forward()*-5   )
				

				self.tbl_save = {
					ModelVehicle = self.car_setup:GetModel(), 
					Class = self.Class,
					Log = self.Table[1], 
					SmallLog = self.Table[2], 
					DemiLog = self.Table[3], 
					QuartLog = self.Table[4], 
					Plank = self.Table[5],
					PlatePos = posplate + self.plate:GetAngles():Up()* -5, 
					PlateAngle = angplate, 
				}
				Table[self.car_setup:GetModel()] = self.tbl_save 

				file.Write("realistic_woodcutter/vehicle"..".txt", util.TableToJSON(Table,true))

				table_send = {}
				for k,v in pairs(Table) do 
					table_send[v.ModelVehicle] = {
						PlatePos = v.PlatePos, 
						PlateAngle = v.PlateAngle,
					}
				end 

				if istable(Table[self.car_setup:GetModel()]) then 
					Table[self.car_setup:GetModel()] = nil 
				end 

				if IsValid(self.plate) then 
					self.plate:Remove()
				end 

				if istable(self.tbl_props) then 
					for k,v in pairs(self.tbl_props) do 
						if IsValid(v) then 
							v:Remove()
						end 
					end 
				end 

				self.tbl_props = {}
				self.tbl_save = {}
				self.Table = {}
				self.RWCStepId = 0
				self:UpdateTool(0)
			end 
		end 
	end 
end 

function TOOL:Think() 
	if SERVER then 
		if not IsValid(self.car_setup) then 
			self.tbl_props = {}
			self.tbl_save = {}
			self.Table = {}
			self.RWCStepId = 0
			self:UpdateTool(0)
		end 
	end 
	if self.RWCStepId == 6 then 
		if IsValid(self.RWCEnt) then
			ply = self:GetOwner()
			trace = util.TraceLine(util.GetPlayerTrace(ply))
			ang = ply:GetAimVector():Angle() 
			Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)
			Ang = Angle(90, ang.Yaw, 0):SnapTo( "y", trace.Entity:GetAngles().Y + 0.0001 ) 
			self.RWCEnt:SetPos(Pos)
			self.RWCEnt:SetAngles(Ang)
		else 
			self:CreateRWCEnt() 
		end
	else 
		if IsValid(self.RWCEnt) then 
			self.RWCEnt:Remove()
		end 
	end 
end 

local toolTable = {
	[1] = Realistic_Woodcutter.GetSentence("startConfigurationText"),
	[2] = Realistic_Woodcutter.GetSentence("placeLog"),
	[3] = Realistic_Woodcutter.GetSentence("placeSmallLog"),
	[4] = Realistic_Woodcutter.GetSentence("placeSmallLog2"),
	[5] = Realistic_Woodcutter.GetSentence("placeQuarterLog"),
	[6] = Realistic_Woodcutter.GetSentence("placePlank"),
	[7] = Realistic_Woodcutter.GetSentence("placePlank2"),
}

function TOOL:DrawToolScreen( w, h )
	if CLIENT then
		surface.SetDrawColor(0,0,0 )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( Realistic_Woodcutter.Colors["lightblue"] )
		surface.DrawRect( 15, 20, w-30, 70 )
		surface.SetDrawColor( Realistic_Woodcutter.Colors["white"] )
		surface.DrawRect( 15, 85 , w-30, 2 )
		surface.SetDrawColor( Realistic_Woodcutter.Colors["white"] )
		surface.DrawRect( 15, 25, w-30, 2 )
		if isnumber(self.RWCStepId) && 59+self.RWCStepId <= 65 && 59+self.RWCStepId > 0 then 
			draw.SimpleText("Step "..self.RWCStepId,"DermaLarge", w/2, h/5,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.DrawText(toolTable[self.RWCStepId + 1], "rwc_font_2", w/2, h/2.3,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
		end 
	end 
end


if SERVER then 
	hook.Add("PlayerInitialSpawn", "RealisticWoodcutter:PlayerInitialSpawn", function(ply)
		timer.Simple(10, function()
			local TableFile = file.Read("realistic_woodcutter/vehicle"..".txt", "DATA") or ""
			local Table = util.JSONToTable(TableFile) or {}
			table_send = {}
			for k,v in pairs(Table) do 
				table_send[v.ModelVehicle] = {
					PlatePos = v.PlatePos, 
					PlateAngle = v.PlateAngle,
				}
			end 
		end ) 
	end ) 
end 