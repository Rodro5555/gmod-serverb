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
TOOL.Name = "HandCuff-Setup"
TOOL.Author = "Kobralost"
TOOL.StepId = 1

if CLIENT then 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "use" },
		{ name = "reload" },
	}
	language.Add("tool.realistic_police_handcuff_tool.name", "HandCuff Setup")
	language.Add("tool.realistic_police_handcuff_tool.desc", "Create or modify Position of Bailor, Jailor & Jail")
	language.Add("tool.realistic_police_handcuff_tool.left", "Left-Click to place entities on the server" )
	language.Add("tool.realistic_police_handcuff_tool.right", "Right-Click to delete the last entity" )
	language.Add("tool.realistic_police_handcuff_tool.use", "USE to return to the previous step" )
	language.Add("tool.realistic_police_handcuff_tool.reload", "RELOAD to go to the next step" )
end 

function TOOL:Deploy()
	self.StepId = 1 
end 

-- Create the Entity ( Jailer , Bailer )
function Realistic_Police.CreateEntityTool(Player, model, ent)
	local angle = Player:GetAimVector():Angle()
	local ang = Angle(0,angle.yaw + 180,0) 

	local EntityT = ents.Create( ent )
	EntityT:SetModel(model)
	if ent == "realistic_police_jailpos" then 
		EntityT:SetPos( Player:GetEyeTrace().HitPos + Vector(0,0,13) )
	else 
		EntityT:SetPos( Player:GetEyeTrace().HitPos + Vector(0,0,0) )
	end 
	EntityT:SetAngles(ang)
	EntityT:Spawn()
end 

function TOOL:LeftClick(trace)
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	
	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.1

	if SERVER then 	
		if self.StepId == 1 then 
			Realistic_Police.CreateEntityTool(self:GetOwner(), "models/Humans/Group01/Female_02.mdl", "realistic_police_jailer") 
		elseif self.StepId == 2 then 
			Realistic_Police.CreateEntityTool(self:GetOwner(), "models/Humans/Group01/Female_02.mdl", "realistic_police_bailer") 
		elseif self.StepId == 3 then
			Realistic_Police.CreateEntityTool(self:GetOwner(), "models/hunter/blocks/cube05x05x05.mdl", "realistic_police_jailpos") 
		end 
	end 
end 

function TOOL:RightClick()
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end

	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.1

	if SERVER then 	
		local Ent = self:GetOwner():GetEyeTrace().Entity 
		if IsValid(Ent) then 
			if Ent:GetClass() == "realistic_police_bailer" or Ent:GetClass() == "realistic_police_jailer" or Ent:GetClass() == "realistic_police_jailpos" then 
				Ent:Remove()
			end 
		end  
	end 
end 

function TOOL:DrawToolScreen( w, h )
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	if CLIENT then 
		surface.SetDrawColor( Realistic_Police.Colors["darkblue"] )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( Color(52, 73, 94) )
		surface.DrawRect( 15, 20 + ( self.StepId * 70 ) - 70, w-30, 74 )
		surface.SetDrawColor( Realistic_Police.Colors["white"] )
		surface.DrawRect( 15, 20 + ( self.StepId * 70 ) - 70, w-30, 2 )
		surface.SetDrawColor( Realistic_Police.Colors["white"] )
		surface.DrawRect( 15,  20 + ( self.StepId * 70 ) + 5, w-30, 2 )
		draw.SimpleText( "Jailor NPC", "rpt_font_18", w / 2, h / 4.7, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Bailor NPC", "rpt_font_18", w / 2, h / 2, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Jail Position", "rpt_font_18", w / 2, h / 1.3, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end 
end

function TOOL:CreateGhostRPTEnt(Model)	
	if CLIENT then
		if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
		if not IsValid(self.RPTGhostEnt) then
 			self.RPTGhostEnt = ClientsideModel(Model, RENDERGROUP_OPAQUE)
			self.RPTGhostEnt:SetModel(Model)
			self.RPTGhostEnt:SetMaterial("models/wireframe")
			self.RPTGhostEnt:SetPos(Vector(0,0,0))
			self.RPTGhostEnt:SetAngles(self:GetOwner():GetAngles())
			self.RPTGhostEnt:Spawn()
			self.RPTGhostEnt:Activate()
			self.RPTGhostEnt.Ang = self:GetOwner():GetAngles()

			self.RPTGhostEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.RPTGhostEnt:SetColor(Realistic_Police.Colors["white"])
		end
	end 
end

function TOOL:Reload(trace)
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end

	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.1

	if self.StepId != 3 then 
		self.StepId = self.StepId + 1
		if self.StepId == 1 or self.StepId == 2 then 
			if IsValid(self.RPTGhostEnt) then 
				self.RPTGhostEnt:Remove()
			end 
			self:CreateGhostRPTEnt("models/Humans/Group01/Female_02.mdl") 
		else 
			if IsValid(self.RPTGhostEnt) then 
				self.RPTGhostEnt:Remove()
			end 
			self:CreateGhostRPTEnt("models/hunter/blocks/cube05x05x05.mdl") 
		end 
	else 
		if IsValid(self.RPTGhostEnt) then 
			self.RPTGhostEnt:Remove()
		end 
		self.StepId = 1
	end 
end 

function TOOL:Think()
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	
	if self.StepId >= 1 or self.StepId <= 3 then 
		if IsValid(self.RPTGhostEnt) then
			ply = self:GetOwner()
			trace = util.TraceLine(util.GetPlayerTrace(ply))
			angle = ply:GetAimVector():Angle()
			ang = Angle(0,angle.yaw + 180,0) 
			if self.StepId != 3 then 
				Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)
			else 
				Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z + 13)
			end 
			self.RPTGhostEnt:SetPos(Pos)
			self.RPTGhostEnt:SetAngles(ang)
		else 
			if self.StepId == 1 or self.StepId == 2 then 
				self:CreateGhostRPTEnt("models/Humans/Group01/Female_02.mdl") 
			else 
				self:CreateGhostRPTEnt("models/hunter/blocks/cube05x05x05.mdl") 
			end 
		end
	end 
end 

function TOOL:Holster()
	if IsValid(self.RPTGhostEnt) then 
		if IsValid(self.RPTGhostEnt) then 
			self.RPTGhostEnt:Remove()
		end 
	end 
end 

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl("label", {
	Text = "Save Jailer / Bailer / Jail Pos Entities" })
	CPanel:Button("Save Entities", "rpt_savejailpos")

	CPanel:AddControl("label", {
	Text = "Remove all Handcuff Entities in The Data" })
	CPanel:Button("Remove Entities Data", "rpt_removedatajail")

	CPanel:AddControl("label", {
	Text = "Remove all Handcuff Entities in The Map" })
	CPanel:Button("Remove Entities Map", "rpt_removejail")

	CPanel:AddControl("label", {
	Text = "Reload all Handcuff Entities in The Map" })
	CPanel:Button("Reload Entities Map", "rpt_reloadjailent")
end