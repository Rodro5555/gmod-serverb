ENT.Base 					= "base_gmodentity"
ENT.Type 					= "anim"

ENT.PrintName 				= "Card Scanner"
ENT.Author					= "Crap-Head"
ENT.Category 				= "ATM by Crap-Head"

ENT.Spawnable				= true
ENT.AdminSpawnable			= true

ENT.RenderGroup 			= RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance 	= true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "IsReadyToScan" )
	
	self:NetworkVar( "String", 0, "TerminalPrice" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end