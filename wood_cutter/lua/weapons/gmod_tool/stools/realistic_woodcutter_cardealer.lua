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
TOOL.Name = "Rwc-CarDealer"
TOOL.Author = "Avatik & Jhon"

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
	}
	language.Add("tool.realistic_woodcutter_cardealer.name", "WoodCutter CarDealer")
	language.Add("tool.realistic_woodcutter_cardealer.desc", "Setup entities in your server")
	language.Add("tool.realistic_woodcutter_cardealer.left", "Left-Click to place CarPosition" )
	language.Add("tool.realistic_woodcutter_cardealer.right", "Right-Click to delete CarPosition" )
end

if SERVER then 
	rwc_posents_cardealer = {}
end 

function TOOL.BuildCPanel( CPanel )
			
	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("saveParkingsText") })

	CPanel:Button(""..Realistic_Woodcutter.GetSentence("savePositions"), "woodcutter_saveposcardealer")

	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("deleteParkingsText") })

	CPanel:Button(""..Realistic_Woodcutter.GetSentence("deletePositionsFromDB"), "woodcutter_removedbposcardealer")

	CPanel:AddControl("label", {
	Text = Realistic_Woodcutter.GetSentence("deleteNoSaveParkingsText") })

	CPanel:Button(""..Realistic_Woodcutter.GetSentence("deleteNoSavingParkingPlaces"), "woodcutter_removeposcardealer")
		
end

function RwcDeletePostion()
	if SERVER then
		if table.Count(rwc_posents_cardealer) != 0 then 
		rwc_posents_cardealer[table.Count(rwc_posents_cardealer)]:Remove()
		table.remove( rwc_posents_cardealer ,table.Count(rwc_posents_cardealer))
		end 
	end
end 

function TOOL:LeftClick(trace)
	self.countdownTool = self.countdownTool or CurTime()
    if self.countdownTool > CurTime() then return end
    self.countdownTool = CurTime() + 0.1

	local ply = self:GetOwner()
	local trace = util.TraceLine(util.GetPlayerTrace(ply))
	local angle = ply:GetAngles()
	local ang = Angle(0,angle.yaw-90,0)
	local Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z+2)

	if ply:IsSuperAdmin() then 
		if SERVER then 
			local rwc_car = ents.Create( "realistic_woodcutter_carpos" )
			table.insert(rwc_posents_cardealer,rwc_car)
			rwc_car:SetModel( "models/hunter/plates/plate2x5.mdl" )
			rwc_car:SetPos( Pos )
			rwc_car:SetAngles(ang)
			rwc_car:Spawn()
		end
	end 
end 

function TOOL:RightClick()
	self.countdownTool = self.countdownTool or CurTime()
    if self.countdownTool > CurTime() then return end
    self.countdownTool = CurTime() + 0.1

	ply = self:GetOwner()
	if ply:IsSuperAdmin() then 
		RwcDeletePostion()
	end 
end 

function TOOL:CreateRWCEnt()	
	if CLIENT then
		if not IsValid(self.RWCEnt) then
 			self.RWCEnt = ClientsideModel("models/hunter/plates/plate2x5.mdl", RENDERGROUP_OPAQUE)
			self.RWCEnt:SetModel("models/hunter/plates/plate2x5.mdl")
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
	if IsValid(self.RWCEnt) then
		ply = self:GetOwner()
		trace = util.TraceLine(util.GetPlayerTrace(ply))
		angle = ply:GetAimVector():Angle()
		ang = Angle(0,angle.yaw-90,0) 
		Pos = Vector(trace.HitPos.X, trace.HitPos.Y, trace.HitPos.Z)

		self.RWCEnt:SetPos(Pos)
		self.RWCEnt:SetAngles(ang)
	else 
		self:CreateRWCEnt()
	end
end 

function TOOL:Holster()
	if IsValid(self.RWCEnt) then 
		self.RWCEnt:Remove()
	end 
end
