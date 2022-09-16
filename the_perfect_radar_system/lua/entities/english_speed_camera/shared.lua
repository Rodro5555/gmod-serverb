ENT.Base = "base_entity" 
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "English Speed Camera"
ENT.Category		= "Diablos Addon" 
ENT.Instructions	= ""
ENT.Spawnable		= false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "IDRadar")
	self:NetworkVar("Int", 1, "SpeedLimit")
	self:NetworkVar("Int", 2, "FinePrice")
	self:NetworkVar("Int", 3, "LengthRadar")
	self:NetworkVar("Bool", 0, "RoadRadar")
	self:NetworkVar("Entity", 0, "owning_ent")
end

function ENT:RefreshLength()
	for k,v in pairs(self.parent) do if IsValid(v) then v:Remove() end end
	for i = 1, self:GetLengthRadar() do
		local ent = ents.Create("speed_camera_detector")
		if not IsValid(ent) then return end
		if self:GetRoadRadar() then
			ent:SetPos(self:LocalToWorld(Vector(250 + 330 * (i - 1), 30, 13)))
			ent:SetAngles(self:GetAngles() + Angle(90, 90, 0))
		else
			ent:SetPos(self:LocalToWorld(Vector(30, 250 + 330 * (i - 1), 13)))
			ent:SetAngles(self:GetAngles() + Angle(90, 0, 0))
		end
		ent:SetModel("models/hunter/plates/plate2x8.mdl")
		ent:SetNoDraw(true)
		ent:Spawn()
		ent:Activate()
		ent:SetParentEnt(self)
	
		ent.radar = self
		table.insert(self.parent, ent)
	end
end

function ENT:Initialize()
	self:SetModel("models/speed_camera/speed_camera.mdl")
	if SERVER then
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysWake()
		self:CPPISetOwner( self:Getowning_ent() )

		self:SetUseType(SIMPLE_USE)

		self.LastCaught = CurTime()
		self.LastVeh = nil
		self.Veh = nil
		self.parent = {}

		if self:GetLengthRadar() == 0 then self:SetLengthRadar(1) end
		if self:GetIDRadar() == 0 then self:SetIDRadar(Diablos.RS.RadarOwnerID) Diablos.RS.RadarOwnerID = Diablos.RS.RadarOwnerID + 1 end

		self:RefreshLength()

		self.Owner = nil -- WHAT IS THIS

		-- INTERET DE TOUS LES SELF. AU DESSUS
	end
end

if SERVER then
	hook.Add("playerBoughtCustomEntity", "RadarSpawn:SENTSpawn", function(ply, entTab, ent, price)
		if Diablos.RS.SpeedCameraList[ent:GetClass()] then
			table.insert(Diablos.RS.RadarTable, ent)
		end
	end)

	hook.Add("EntityRemoved", "RadarSpawn:SENTRemoved", function(ent)
		if Diablos.RS.SpeedCameraList[ent:GetClass()] then
			table.RemoveByValue(Diablos.RS.RadarTable, ent)
		end
	end)
end