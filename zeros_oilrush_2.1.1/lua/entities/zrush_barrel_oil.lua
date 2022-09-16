AddCSLuaFile()
DEFINE_BASECLASS("zrush_barrel")
ENT.Type = "anim"
ENT.Base = "zrush_barrel"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Oil Barrel"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_barrel.mdl"
ENT.AutomaticFrameAdvance = true
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
	self:NetworkVar("Float", 0, "Oil")
	self:NetworkVar("Float", 1, "Fuel")
	self:NetworkVar("Int", 0, "FuelTypeID")

	if (SERVER) then
		self:SetFuelTypeID(0)
		self:SetOil(zrush.config.Barrel.Storage)
		self:SetFuel(0)
	end
end
