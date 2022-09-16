AddCSLuaFile()
DEFINE_BASECLASS("zgo2_item_base")
ENT.Type                    = "anim"
ENT.Base                    = "zgo2_item_base"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Edible"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = false
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_food_muffin.mdl"
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
	self:NetworkVar("Int", 1, "WeedAmount")
	self:NetworkVar("Int", 2, "WeedTHC")

	self:NetworkVar("Int", 3, "EdibleID")
	if SERVER then
		self:SetWeedID(0)
		self:SetWeedAmount(0)
		self:SetWeedTHC(0)

		self:SetEdibleID(0)
	end
end

if SERVER then
	function ENT:PostInitialize()
		zgo2.Edible.Initialize(self)
	end

	function ENT:AcceptInput(inputName, activator, caller, data)
		if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
			zgo2.Edible.USE(self,activator)
		end
	end
end


if CLIENT then
	function ENT:Initialize()
		zgo2.Edible.Initialize(self)
	end

	function ENT:Think()
		zgo2.Edible.Think(self)
	end

	function ENT:Draw()
		zgo2.Edible.Draw(self)
	end
end
