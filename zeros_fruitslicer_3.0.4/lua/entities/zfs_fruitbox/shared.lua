ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl"

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
	self:NetworkVar("Int", 0, "FruitID")

	if SERVER then
		self:SetFruitID(0)
	end
end
