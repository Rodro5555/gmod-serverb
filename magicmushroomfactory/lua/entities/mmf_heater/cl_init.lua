include("shared.lua")

function ENT:Initialize()
    self:UseClientSideAnimation()
end

function ENT:DrawTranslucent()
    self:DrawModel()
end