MMF.CaldeidomState = {
    Idle = 0,
    Preparing = 1,
    Collecting = 2,
    Done = 3,
    Burned = 4
}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Caldeidom"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.Category = "Magic Mushrooms"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.MaxLiquid = 32

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "State")
	self:NetworkVar( "Entity", 0, "owning_ent" )
end