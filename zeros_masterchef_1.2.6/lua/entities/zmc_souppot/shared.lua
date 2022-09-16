ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_heater.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "SoupPot"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE

// This entity corresponds to this component
ENT.Component = "soup"


function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "ItemID")
	self:NetworkVar("Int", 2, "CookStart")
	self:NetworkVar("Int", 3, "Fuel")
	if (SERVER) then
		self:SetItemID(-1)
		self:SetCookStart(-1)
		self:SetFuel(0)
	end
end

function ENT:CanPickUp(ItemID)
	local ItemData = zmc.Item.GetData(self:GetItemID())
	if ItemData == nil then return end
	if ItemData.soup == nil then return end
	if ItemData.soup.items == nil then return end
	if table.HasValue(ItemData.soup.items,ItemID) == false then return end
	return true
end

function ENT:CanProperty(ply)
	return ply:IsSuperAdmin()
end
function ENT:CanTool( ply, tab, str )
	return ply:IsSuperAdmin()
end
function ENT:CanDrive(ply)
	return ply:IsSuperAdmin()
end
