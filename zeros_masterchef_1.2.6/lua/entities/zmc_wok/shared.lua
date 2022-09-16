ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_heater.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Wok"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE
-- This entity corresponds to this component
ENT.Component = "wok"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 2, "ItemID")
	self:NetworkVar("Int", 4, "Progress")
	self:NetworkVar("Int", 1, "Fuel")

	if (SERVER) then
		self:SetItemID(-1)
		self:SetProgress(-1)
		self:SetFuel(0)
	end
end

function ENT:CanPickUp(ItemID)
	local ItemData = zmc.Item.GetData(self:GetItemID())
	if ItemData == nil then return end
	if ItemData.wok == nil then return end
	if ItemData.wok.items == nil then return end
	if table.HasValue(ItemData.wok.items,ItemID) == false then return end

	return true
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
