AddCSLuaFile()
DEFINE_BASECLASS("zgo2_item_base")
ENT.Type                    = "anim"
ENT.Base                    = "zgo2_item_base"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "WeedBlock"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_weedblock.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:CanProperty(ply)
	return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
	return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
	return false
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "WeedID")
	self:NetworkVar("Int", 1, "Progress")

	if SERVER then
		self:SetWeedID(1)
		self:SetProgress(0)
	end
end

if SERVER then
	function ENT:PostInitialize()
		zgo2.Weedblock.Initialize(self)
	end

	function ENT:AcceptInput(inputName, activator, caller, data)
		if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
			zgo2.Weedblock.OnUse(self, ply)
		end
	end
end

if CLIENT then
	function ENT:Initialize()
		zgo2.Weedblock.Initialize(self)
	end

	function ENT:Think()
		zgo2.Weedblock.Think(self)
	end

	function ENT:Draw()
		self:DrawModel()
		zgo2.Weedblock.Draw(self)
	end
end
