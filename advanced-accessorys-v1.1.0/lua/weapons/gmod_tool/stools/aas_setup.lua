AddCSLuaFile()

TOOL.Category = "Advanced Accessory System"
TOOL.Name = "Entity-Setup"
TOOL.Author = "Kobralost"

if CLIENT then 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}
	language.Add("tool.aas_setup.name", "Entity Setup")
	language.Add("tool.aas_setup.desc", "Place Bodygroups, Models, Items entity")
	language.Add("tool.aas_setup.left", "Left-Click to place entity in your server" )
	language.Add("tool.aas_setup.right", "Right-Click to delete entity on your server" )
	language.Add("tool.aas_setup.reload", "Reload to change the step of the toolgun" )
end

local AASSwepTable = {
	[1] = {
		["model"] = AAS.BodyGroupModel,
		["class"] = "aas_bodygroup",
		["vector"] = Vector(0,0,40),
	},
	[2] = {
		["model"] = AAS.ModelChanger,
		["class"] = "aas_model",
		["vector"] = Vector(0,0,40),
	},
	[3] = {
		["model"] = AAS.ItemNpcModel,
		["class"] = "aas_npc_shop",
		["vector"] = Vector(0,0,0),
	},
}

function TOOL:Deploy()
	self:SetStage(0)
end

function TOOL:LeftClick(trace)
	if SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() or not AAS.AdminRank[ply:GetUserGroup()] then return end
		
		ply.AASSpam = ply.AASSpam or CurTime()
		if ply.AASSpam > CurTime() then return end 
		ply.AASSpam = CurTime() + 0.5

		local position = trace.HitPos
		local angle = ply:GetAngles()

		local AASEnt = ents.Create(AASSwepTable[self:GetStage() + 1]["class"])
		AASEnt:SetPos(position + AASSwepTable[self:GetStage() + 1]["vector"])
		AASEnt:SetAngles(Angle(0, angle.Yaw - 180, 0))
		AASEnt:Spawn()
		AASEnt:Activate()
	end
end 

function TOOL:RightClick()
	if SERVER then 
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() or not AAS.AdminRank[ply:GetUserGroup()] then return end
		
		local TraceEntity = self:GetOwner():GetEyeTrace().Entity
		if IsValid(TraceEntity) then 
			TraceEntity:Remove()
		end  
	end 
end 

function TOOL:CreateAASEnt()
	if CLIENT then
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() then return end  
	
		if not AAS.AdminRank[ply:GetUserGroup()] then return end

		if not IsValid(self.AASEnt) then
 			self.AASEnt = ClientsideModel(AASSwepTable[self:GetStage() + 1]["model"], RENDERGROUP_OPAQUE)
			self.AASEnt:SetModel(AASSwepTable[self:GetStage() + 1]["model"])
			self.AASEnt:SetMaterial("models/wireframe")
			self.AASEnt:Spawn()
			self.AASEnt:Activate()	
			self.AASEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.AASEnt:SetColor(AAS.Colors["white"])
		end
	end 
end

function TOOL:Think()
	if CLIENT then
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() or not AAS.AdminRank[ply:GetUserGroup()] then return end

		if IsValid(self.AASEnt) then
			local trace = util.TraceLine(util.GetPlayerTrace(ply))
			local ang = ply:GetAimVector():Angle()
			local angSet = Angle(0, ang.Yaw - 180, 0)
			local pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)

			self.AASEnt:SetPos(pos + AASSwepTable[self:GetStage() + 1]["vector"])
			self.AASEnt:SetAngles(angSet)
			self.AASEnt:SetModel(AASSwepTable[self:GetStage() + 1]["model"])
		else 
			self:CreateAASEnt() 
		end
	end
end 

function TOOL:Holster()
	if CLIENT then
		local ply = self:GetOwner()
		if not IsValid(ply) and not ply:IsPlayer() or not AAS.AdminRank[ply:GetUserGroup()] then return end

		if IsValid(self.AASEnt) then 
			self.AASEnt:Remove()
		end
	end
end

function TOOL:Reload()
	local ply = self:GetOwner()
	if not IsValid(ply) and not ply:IsPlayer() or not AAS.AdminRank[ply:GetUserGroup()] then return end

	if self:GetStage() < 2 then
		self:SetStage(self:GetStage() + 1)
	else
		self:SetStage(0)
	end
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("label", {
	Text = "Save Advanced Accessory Entities" })
	CPanel:Button("Save Entities", "aas_save_entity")

	CPanel:AddControl("label", {
	Text = "Remove all Entities in The Data" })
	CPanel:Button("Remove Entities Data", "aas_remove_entitysql")

	CPanel:AddControl("label", {
	Text = "Remove all Entities in The Map" })
	CPanel:Button("Remove Entities Map", "aas_remove_entity")

	CPanel:AddControl("label", {
	Text = "Reload all Entities in The Map" })
	CPanel:Button("Reload Entities Map", "aas_reload_entity")
end
