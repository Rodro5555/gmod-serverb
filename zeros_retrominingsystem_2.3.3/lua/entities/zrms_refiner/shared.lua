ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.PrintName = "Refiner"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"

ENT.Model = "models/zerochain/props_mining/zrms_refiner.mdl"
ENT.GravelModel = "models/zerochain/props_mining/zrms_crushedgravel01.mdl"

ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

ENT.RefinerType = "Iron"

ENT.WorkAmount = 5
ENT.RefineAmount = zrmine.config.RefiningAmount
ENT.RefiningTime = zrmine.config.Iron_RefiningTime
ENT.HoldAmount = zrmine.config.Refiner_Capacity

function ENT:SetupDataTables()

	self:NetworkVar("Entity", 1, "Basket")

	self:NetworkVar("Int", 0, "CurrentState")
	self:NetworkVar("Entity", 0, "ModuleChild")
	self:NetworkVar("Entity", 2, "ModuleParent")
	self:NetworkVar("Int", 2, "ConnectionPos")

	if (SERVER) then
		self:SetBasket(NULL)

		self:SetModuleChild(NULL)
		self:SetModuleParent(NULL)
		self:SetConnectionPos(-1)
		self:SetCurrentState(0)
	end

	self:NetworkVar("Float", 4, "Coal")
	self:NetworkVar("Float", 0, "Iron")
	self:NetworkVar("Float", 1, "Bronze")
	self:NetworkVar("Float", 2, "Silver")
	self:NetworkVar("Float", 3, "Gold")

	if SERVER then
		self:SetCoal(0)
		self:SetIron(0)
		self:SetBronze(0)
		self:SetSilver(0)
		self:SetGold(0)
	end

	// NW SETUP STUFF FOR GRAVEL ANIM
	zrmine.f.Gravel_SetupDataTables(self)

	self:NetworkVar("Int", 10, "RefineAnim_Type")

	if (SERVER) then
		self:SetRefineAnim_Type(-1)
	end
end
