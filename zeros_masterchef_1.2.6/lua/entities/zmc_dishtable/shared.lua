ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_dishtable.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Dishtable"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "DishID")

	if (SERVER) then
		self:SetDishID(-1)
	end
end

function ENT:CanPickUp(ItemID)

	if self:GetDishID() <= 0 then return end

	local ItemData = zmc.Item.GetData(ItemID)
    if ItemData == nil then return end
    if ItemData.sell == nil then return end

	// If we dont need this item then stop
    local missing = zmc.Dishtable.GetMissingIngredients(self)
    local IsNeeded = false
    for k,v in pairs(missing) do
        if v.itm == ItemID then
            IsNeeded = true
            break
        end
    end
    if IsNeeded == false then return end

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
