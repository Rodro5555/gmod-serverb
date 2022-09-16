ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName		= "NPC Radar"
ENT.Category		= "Diablos Addon" 
ENT.Instructions	= ""
ENT.Spawnable		= true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end