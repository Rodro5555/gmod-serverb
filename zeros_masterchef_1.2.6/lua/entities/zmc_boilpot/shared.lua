ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_heater.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "BoilPot"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE

// This entity corresponds to this component
ENT.Component = "boil"


function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "Temperatur")
	self:NetworkVar("Int", 2, "Fuel")

	if (SERVER) then
		self:SetTemperatur(0)
		self:SetFuel(0)
	end
end

function ENT:CanPickUp(ItemID)
	local ItemData = zmc.Item.GetData(ItemID)
	if ItemData == nil then return false end
	if ItemData.boil == nil then return false end
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
