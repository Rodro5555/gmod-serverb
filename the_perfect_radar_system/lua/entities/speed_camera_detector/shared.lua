ENT.Base = "base_entity" 
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Speed Camera Detector"
ENT.Category		= "Diablos Addon" 
ENT.Instructions	= ""
ENT.Spawnable		= false

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "ParentEnt")
end

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate2x8.mdl")
	if SERVER then
		local radius = 40
		self:PhysicsInitBox(self:OBBMins(), self:OBBMaxs())

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableCollisions(false)
			phys:EnableMotion(false)
		end

		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetTrigger(true)
		self:SetNotSolid(true)
	end
end