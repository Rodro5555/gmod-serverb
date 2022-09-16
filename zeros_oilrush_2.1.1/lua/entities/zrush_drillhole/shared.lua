ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "DrillHole"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_drillhole.mdl"
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
	self:NetworkVar("Int", 0, "Pipes")
	self:NetworkVar("Int", 1, "State")
	self:NetworkVar("Int", 2, "HoleType")
	self:NetworkVar("Int", 3, "Gas")
	self:NetworkVar("Int", 4, "OilAmount")
	self:NetworkVar("Int", 5, "NeededPipes")

	self:NetworkVar("Float", 5, "ChaosEventBoost")

	if SERVER then
		self:SetPipes(0)
		self:SetState(-1)
		self:SetHoleType(-1)
		self:SetGas(-1)
		self:SetOilAmount(0)
		self:SetNeededPipes(0)

		self:SetChaosEventBoost(0)
	end
end

function ENT:HasBurner()
	if IsValid(self:GetParent()) and self:GetParent():GetClass() == "zrush_burner" then
		return true
	else
		return false
	end
end

function ENT:HasPump()
	if IsValid(self:GetParent()) and self:GetParent():GetClass() == "zrush_pump" then
		return true
	else
		return false
	end
end

function ENT:HasDrill()
	if IsValid(self:GetParent()) and self:GetParent():GetClass() == "zrush_drilltower" then
		return true
	else
		return false
	end
end
