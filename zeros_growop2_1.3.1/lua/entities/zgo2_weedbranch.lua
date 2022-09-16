AddCSLuaFile()
DEFINE_BASECLASS("zgo2_item_base")
ENT.Type                    = "anim"
ENT.Base                    = "zgo2_item_base"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Weed Branch"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_weedstick.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE

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
	self:NetworkVar("Int", 0, "PlantID")
	self:NetworkVar("Bool", 0, "IsDried")

	if SERVER then
		self:SetPlantID(1)
		self:SetIsDried(false)
		//self:SetPlantID(zgo2.Plant.GetRandomID())
	end
end

if SERVER then
	function ENT:Initialize()
		zgo2.Weedbranch.Initialize(self)
	end

	function ENT:AcceptInput(inputName, activator, caller, data)
		if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
			zgo2.Weedbranch.OnUse(self, activator)
		end
	end
end

if CLIENT then
	function ENT:Initialize()
		self:DestroyShadow()

		timer.Simple(0.5, function()
			if IsValid(self) then
				self.m_Initialized = true
			end
		end)
	end

	function ENT:Think()
		if zgo2.Plant.UpdateMaterials[ self ] == nil then
			zgo2.Plant.UpdateMaterials[ self ] = true
		end
	end
end
