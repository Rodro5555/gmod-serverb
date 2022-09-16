include("shared.lua")

function ENT:Initialize()
    zrush.Barrel.Initialize(self)
end

function ENT:OnRemove()
    zrush.Barrel.OnRemove(self)
end

function ENT:Draw()
    self:DrawModel()
    zrush.Barrel.Draw(self)
end

function ENT:DrawTranslucent()
    self:Draw()
end
