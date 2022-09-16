include("shared.lua")

function ENT:Initialize()
    zgo2.Seed.Initialize(self)
end

function ENT:Think()
	zgo2.Seed.OnThink(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Seed.Draw(self)
end
