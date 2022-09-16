ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_ordertable.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Ordertable"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 1, "AcceptOrders")
	self:NetworkVar("Bool", 2, "CustomOrders")
	self:NetworkVar("Bool", 3, "NPCCustomer")

	self:NetworkVar("Int", 1, "CustomerRating")
	self:NetworkVar("Int", 2, "Earnings")

	if (SERVER) then
		self:SetAcceptOrders(false)
		self:SetCustomOrders(false)
		self:SetCustomerRating(50)
		self:SetEarnings(0)
		self:SetNPCCustomer(true)
	end
end

function ENT:CanProperty(ply)
	return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
	return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
	return ply:IsSuperAdmin()
end
