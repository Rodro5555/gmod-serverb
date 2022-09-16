include("shared.lua")

function ENT:Initialize()
	
	Jewelry_Robbery.ListGlass = Jewelry_Robbery.ListGlass or {}
	table.insert(Jewelry_Robbery.ListGlass, self)
	
end

function ENT:Draw()
	self:DrawModel()
end