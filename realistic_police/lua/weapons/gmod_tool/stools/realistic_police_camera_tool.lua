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
TOOL.Name = "Camera-Setup"
TOOL.Author = "Kobralost"
RPTDeployTool = false  

if CLIENT then 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
	}
	language.Add("tool.realistic_police_camera_tool.name", "Camera Setup")
	language.Add("tool.realistic_police_camera_tool.desc", "Create or modify Position of your Camera")
	language.Add("tool.realistic_police_camera_tool.left", "Left-Click to place the camera in your server" )
	language.Add("tool.realistic_police_camera_tool.right", "Right-Click to delete the camera on your server" )
end 

function TOOL:Deploy()
	RPTDeployTool = true 
end

function TOOL:LeftClick(trace)
	if not Realistic_Police.AdminRank[self:GetOwner():GetUserGroup()] then return end
	
	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.5

	local ply = self:GetOwner()
	if SERVER then
		if not IsValid( ply ) && not ply:IsPlayer() then return end  
		local trace = ply:GetEyeTrace()
		local position = trace.HitPos
		local angle = ply:GetAngles()
		
		local rpt_createent = ents.Create( "realistic_police_camera" ) 
		rpt_createent:SetPos(position + Vector(0, 0, 0))
		rpt_createent:SetAngles(Angle(0, angle.Yaw - 90, 0))
		rpt_createent:Spawn()
		rpt_createent:Activate()
		rpt_createent.RPTCam = true 

		timer.Simple(0.1, function()
			net.Start("RealisticPolice:NameCamera")	
				net.WriteEntity(rpt_createent)
			net.Send(self:GetOwner())
		end ) 
	else 
		if not RPTDeployTool then RPTDeployTool = true end 		
	end
end 

function TOOL:RightClick()	
	self:GetOwner().AntiSpam = self:GetOwner().AntiSpam or CurTime()
	if self:GetOwner().AntiSpam > CurTime() then return end 
	self:GetOwner().AntiSpam = CurTime() + 0.01

	if SERVER then 
		local TraceEntity = self:GetOwner():GetEyeTrace().Entity 
		if IsValid(TraceEntity) && TraceEntity:GetClass() == "realistic_police_camera" then 
			TraceEntity:Remove()
		else 
			if IsValid(ents.FindByClass("realistic_police_camera")[#ents.FindByClass("realistic_police_camera")]) then 
				ents.FindByClass("realistic_police_camera")[#ents.FindByClass("realistic_police_camera")]:Remove()
			end 
		end  
		Realistic_Police.SaveEntity() 		 
	end 
end 

function TOOL:CreateRPTEnt()	
	if CLIENT then
		if IsValid(self.RPTEnt) then else
 			self.RPTEnt = ClientsideModel("models/wasted/wasted_kobralost_camera.mdl", RENDERGROUP_OPAQUE)
			self.RPTEnt:SetModel("models/wasted/wasted_kobralost_camera.mdl")
			self.RPTEnt:SetMaterial("models/wireframe")
			self.RPTEnt:SetPos(Vector(0,0,0))
			self.RPTEnt:SetAngles(Angle(0,0,0))
			self.RPTEnt:Spawn()
			self.RPTEnt:Activate()	
			self.RPTEnt.Ang = Angle(0,0,0)
			self.RPTEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
			self.RPTEnt:SetColor(Realistic_Police.Colors["white"])
		end
	end 
end

function TOOL:Think() 
	if IsValid(self.RPTEnt) then
		ply = self:GetOwner()
		trace = util.TraceLine(util.GetPlayerTrace(ply))
		ang = ply:GetAimVector():Angle() 
		Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)
		Ang = Angle(0, ang.Yaw - 90, 0) + self.RPTEnt.Ang
		self.RPTEnt:SetPos(Pos)
		self.RPTEnt:SetAngles(Ang)
	else 
		self:CreateRPTEnt() 
	end 
end 

function TOOL:Holster()
	if IsValid(self.RPTEnt) then 
		self.RPTEnt:Remove()
	end 
	RPTDeployTool = false 
end

hook.Add("HUDPaint", "RPT:HUDPaint", function()
	if RPTDeployTool then 
		for k,v in pairs(ents.FindByClass("realistic_police_camera")) do 
			local tscreen = v:GetPos():ToScreen()		
			draw.SimpleText( k, "rpt_font_2", tscreen.x, tscreen.y + 20, Realistic_Police.Colors["white"],1,1) 	
			draw.SimpleText( "☑" , "rpt_font_2", tscreen.x, tscreen.y, Realistic_Police.Colors["white"],1,1)  
		end 
	end 
end)

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl("label", {
	Text = "Save Realistic Police Entities" })
	CPanel:Button("Save Entities", "rpt_save")

	CPanel:AddControl("label", {
	Text = "Remove all Entities in The Data" })
	CPanel:Button("Remove Entities Data", "rpt_removedata")

	CPanel:AddControl("label", {
	Text = "Remove all Entities in The Map" })
	CPanel:Button("Remove Entities Map", "rpt_cleaupentities")

	CPanel:AddControl("label", {
	Text = "Reload all Entities in The Map" })
	CPanel:Button("Reload Entities Map", "rpt_reloadentities")
end

