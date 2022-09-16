ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Smoothie Stand"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros FruitSlicer"

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
	self:NetworkVar("Int", 0, "CurrentState")
	self:NetworkVar("Int", 1, "SmoothieID")
	self:NetworkVar("Int", 2, "ToppingID")
	self:NetworkVar("Int", 3, "CustomPrice")
	self:NetworkVar("Bool", 0, "IsBusy")
	self:NetworkVar("Bool", 1, "PublicEntity")
	self:NetworkVar("Entity", 1, "OccupiedPlayer")
	self:NetworkVar("Entity", 2, "PushPlayer")

	if SERVER then

		self:SetCurrentState(-1)
		self:SetSmoothieID(0)
		self:SetToppingID(0)
		self:SetCustomPrice(0)
		self:SetIsBusy(false)
		self:SetPublicEntity(false)

		self:SetOccupiedPlayer(NULL)
		self:SetPushPlayer(NULL)
	end
end
