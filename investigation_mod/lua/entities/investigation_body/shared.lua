ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Death body"
ENT.Category = "Investigation mod"
ENT.Author = "Venatuss"
ENT.Spawnable = false

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Body" )
	self:NetworkVar( "Entity", 1, "Criminal" )
	self:NetworkVar( "String", 0, "VictimName" )
	self:NetworkVar( "String", 1, "VictimJob" )
	self:NetworkVar( "Float", 0, "DeathTime" )
	self:NetworkVar( "String", 2, "DamageType" )

end