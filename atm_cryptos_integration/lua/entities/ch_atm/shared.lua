ENT.Base 					= "base_gmodentity"
ENT.Type 					= "anim"

ENT.PrintName 				= "ATM"
ENT.Author					= "Crap-Head"
ENT.Category 				= "ATM by Crap-Head"

ENT.Spawnable				= true
ENT.AdminSpawnable			= true

ENT.RenderGroup 			= RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance 	= true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "IsBeingHacked" )
	self:NetworkVar( "Bool", 1, "IsHackCooldown" )
	self:NetworkVar( "Bool", 2, "IsEmergencyLockdown" )
end