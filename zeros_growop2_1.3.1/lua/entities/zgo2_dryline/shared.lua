ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Dryline"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_dryline.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "EndPoint")
	self:NetworkVar("Angle", 0, "WallAngle")
	self:NetworkVar("Angle", 1, "WallEndAngle")

	if SERVER then

		self:SetEndPoint(self:GetPos())
		timer.Simple(0.5,function() if IsValid(self) then self:SetEndPoint(self:GetPos()) end end)

		self:SetWallAngle(angle_zero)
		self:SetWallEndAngle(angle_zero)
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

function ENT:GravGunPickupAllowed( ply )
	return false
end

function ENT:GravGunPunt( ply )
	return false
end
