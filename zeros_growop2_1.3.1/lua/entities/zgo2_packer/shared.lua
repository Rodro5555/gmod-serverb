ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = true
ENT.PrintName               = "Weed Packer"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_weedpacker.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "WeedID")
	self:NetworkVar("Int", 1, "Progress")
	self:NetworkVar("Int", 2, "WeedAmount")

	if SERVER then
		self:SetWeedID(0)
		self:SetProgress(0)
		self:SetWeedAmount(0)
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

local lsw_vec01 = Vector(16, 0, 21)
function ENT:OnDrop(ply)
    local trace = ply:GetEyeTrace()

	//debugoverlay.Sphere(self:LocalToWorld(lsw_vec01),1,0.1,Color( 0, 255, 0 ),true)

    if zclib.util.InDistance(self:LocalToWorld(lsw_vec01), trace.HitPos, 15) then
        return true
    else
        return false
    end
end
