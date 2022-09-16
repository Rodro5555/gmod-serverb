ENT.Base = "base_gmodentity";
ENT.Type = "anim";

ENT.PrintName		= "Olla de Fósforo Rojo";
ENT.Category 		= "EML";
ENT.Author			= "EnnX49";

ENT.Contact    		= "";
ENT.Purpose 		= "";
ENT.Instructions 	= "" ;

ENT.Spawnable			= true;
ENT.AdminSpawnable		= true;

function ENT:SetupDataTables()	
	self:NetworkVar( "Entity", 0, "owning_ent" )
end
