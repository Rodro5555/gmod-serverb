ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bullet"
ENT.Category = "Investigation mod"
ENT.Author = "Venatuss"
ENT.Spawnable = false

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "WeaponName" )
	self:NetworkVar( "String", 1, "WeaponModel" )
	self:NetworkVar( "Float", 0, "WeaponAmmo" )
	self:NetworkVar( "Entity", 0, "Murder" )

end