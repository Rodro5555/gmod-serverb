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
TOOL.Name = "Rwc-Configuration"
TOOL.Author = "Avatik & Jhon"
TOOL.rwc_id_construction = 1
if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
	}
	language.Add("tool.realistic_woodcutter_tools.name", "WoodCutter Configuration")
	language.Add("tool.realistic_woodcutter_tools.desc", "Setup entities in your server")
	language.Add("tool.realistic_woodcutter_tools.left", "Left-Click for spawn entities" )
	language.Add("tool.realistic_woodcutter_tools.right", "Right-Click for remove the entity" )
end

local angle_rotation = 0
function TOOL:Reload(trace)
	self.countdownRwc = self.countdownRwc or CurTime()
	if self.countdownRwc > CurTime() then return end
	self.countdownRwc = CurTime() + 0.1

	if CLIENT then
		angle_rotation = angle_rotation + 45
	end
end

if SERVER then
	net.Receive("RealisticWoodCutter:CreateEnt",function(lengh,ply)
		local args = net.ReadInt(20)
		local ang = net.ReadAngle()
		local trace = ply:GetEyeTrace()
		local position = trace.HitPos
		local angle = ply:GetAngles()
		local team = ply:GetUserGroup()
		if ply:IsSuperAdmin() then
			rwc_createent = ents.Create( Realistic_Woodcutter.ToolsEnts[args]["rwc_ent"])
			if ( !IsValid( rwc_createent ) ) then return end
			if args == 1 then
				rwc_createent:SetAngles(Angle(0,angle.Yaw+90, 0))
			else
				rwc_createent:SetAngles(ang)
			end
			if args == 1 or args == 6 then
				rwc_createent:SetPos(position + Vector(0, 0, 0))
			else
				rwc_createent:SetPos(position + Vector(0, 0, 7))
			end
			rwc_createent:Spawn()
			rwc_createent:Activate() 
			local phys = rwc_createent:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion(false)
			end
		end
	end)
end

function TOOL:RightClick(trace)
	local ply = self:GetOwner()
	self.countdownRwc = self.countdownRwc or CurTime()
	if self.countdownRwc > CurTime() then return end
	self.countdownRwc = CurTime() + 0.1
	if SERVER then
		if (Realistic_Woodcutter.Entities[trace.Entity:GetClass()]) then 
			trace.Entity:Remove() 
			if self:GetOwner():IsSuperAdmin() then
				concommand.Run(self:GetOwner(),"wood_cutter_save")	
				DarkRP.notify(self:GetOwner(), 3, 2, Realistic_Woodcutter.GetSentence("saved_2"))
			end  
		end 
	else
		if not (Realistic_Woodcutter.Entities[trace.Entity:GetClass()]) then 
			if IsValid(self.RWCEnt) then
				self.RWCEnt:Remove()
				self.rwc_id_construction = self.rwc_id_construction + 1
				if self.rwc_id_construction > 6 then
					self.rwc_id_construction = 1
				end 
			end
		end
	end   
end  

function TOOL:LeftClick(trace)
	if CLIENT then
		self.countdownRwc = self.countdownRwc or CurTime()
		if self.countdownRwc > CurTime() then return end
		self.countdownRwc = CurTime() + 0.1
		net.Start("RealisticWoodCutter:CreateEnt")
		net.WriteInt(self.rwc_id_construction,20)
		net.WriteAngle(self.RWCEnt:GetAngles())
		net.SendToServer()
	end
end 

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("buttonSaveAllTreesPosititions") })
		
	CPanel:Button(Realistic_Woodcutter.GetSentence("saveAllRWCEntities"), "woodcutter_save")

	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("deleteTreesFromDB") })

	CPanel:Button(Realistic_Woodcutter.GetSentence("deleteRWCDB"), "woodcutter_savedelete")
		
	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("deleteAllMapEntities") })
		
	CPanel:Button(Realistic_Woodcutter.GetSentence("deleteAllEntitiesofMap"), "woodcutter_cleaupentities")
		
	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("reloadAllEntitiesButton") })
		
	CPanel:Button(Realistic_Woodcutter.GetSentence("reloadAllRWCEntities"), "woodcutter_entitiesreload")
end

function TOOL:CreateRWCEnt()	
	if CLIENT then
		if not IsValid(self.RWCEnt) then
 			self.RWCEnt = ClientsideModel(Realistic_Woodcutter.ToolsEnts[self.rwc_id_construction]["rwc_model"], RENDERGROUP_OPAQUE)
			self.RWCEnt:SetModel(Realistic_Woodcutter.ToolsEnts[self.rwc_id_construction]["rwc_model"])
			self.RWCEnt:SetMaterial("models/wireframe")
			self.RWCEnt:SetPos(Vector(0,0,0))
			self.RWCEnt:SetAngles(Angle(0,0,0))
			self.RWCEnt:Spawn()
			self.RWCEnt:Activate()	
			self.RWCEnt.Ang = Angle(0,0,0)

			self.RWCEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.RWCEnt:SetColor(Color( 255, 255, 255, 150))
		end
	end 
end

function TOOL:Think() 
	if self.rwc_id_construction == 1 then 
		if IsValid(self.RWCEnt) then
			ply = self:GetOwner()
			trace = util.TraceLine(util.GetPlayerTrace(ply))
			ang = ply:GetAimVector():Angle() 
			Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)
			timer_rwcang = timer_rwcang - 0.005
			if timer_rwcang <= -1.5 then
			timer_rwcang = 1.5
			end
			Ang = Angle(0, ang.Yaw+90, math.cos(timer_rwcang)*90) + self.RWCEnt.Ang

			self.RWCEnt:SetPos(Pos)
			self.RWCEnt:SetAngles(Ang)
		else 
			self:CreateRWCEnt() 
			timer_rwcang = 1.5	
		end 
	elseif self.rwc_id_construction > 1 and self.rwc_id_construction < 7 then  
		if IsValid(self.RWCEnt) then
			ply = self:GetOwner()
			trace = util.TraceLine(util.GetPlayerTrace(ply))
			ang = ply:GetAimVector():Angle() 
			Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z+10)
			Ang = Angle(0, ang.Yaw + angle_rotation, 0)

			self.RWCEnt:SetPos(Pos)
			self.RWCEnt:SetAngles(Ang)
		else 
			self:CreateRWCEnt()	
		end 
	end 
end 

function TOOL:Holster()
	if IsValid(self.RWCEnt) then 
		self.RWCEnt:Remove()
	end 
end
