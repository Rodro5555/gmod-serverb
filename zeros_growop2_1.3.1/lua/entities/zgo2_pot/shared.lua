ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Pot"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_pot01.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "PotID")
	self:NetworkVar("Entity", 0, "Plant")
	self:NetworkVar("Bool", 0, "HasSoil")
	self:NetworkVar("Int", 1, "Water")
	self:NetworkVar("Bool", 1, "IsCramped")
	if (SERVER) then
		self:SetPotID(1)
		self:SetPlant(NULL)
		self:SetHasSoil(false)
		self:SetWater(0)
		self:SetIsCramped(false)
	end
end

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end
