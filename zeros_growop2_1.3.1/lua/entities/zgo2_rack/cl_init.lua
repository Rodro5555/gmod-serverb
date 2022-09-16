include("shared.lua")

function ENT:Initialize()

end

function ENT:Draw()
	self:DrawModel()
	/*
	// NOTE For debugging
	local dat = zgo2.Rack.GetData(self:GetRackID())
	for k,v in pairs(dat.PotPositions) do
		debugoverlay.Sphere(self:LocalToWorld(v),5,0.1,Color( 0, 255, 0 ),true)
	end
	*/
end

function ENT:OnRemove()

end
