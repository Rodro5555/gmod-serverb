include("shared.lua")

function ENT:Initialize()
    zgo2.Pot.Initialize(self)
end

function ENT:Draw()
	zgo2.Pot.OnDraw(self)
end

function ENT:Think()
    zgo2.Pot.Think(self)
end
