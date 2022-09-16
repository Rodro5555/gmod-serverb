include("shared.lua")

function ENT:Initialize()
  self.Created = CurTime()
end

function ENT:Draw()
  self:DrawModel()

  -- Enable for debugging reasons if you need it
  --local size = 37.5
  --render.SetColorMaterial()
  --local min = Vector(-size, -size, 0)
  --local max = Vector(size, size, size * 2)
  --render.DrawBox(self:GetPos(), Angle(0, 0, 0), min, max, ColorAlpha(XeninUI.Theme.Blue, 150))
end

function ENT:Think()
  -- The check here prevents smoke from being created in the first 1-2 frames
  if (self:IsStill() and self.Created < (CurTime() - 0.1)) then
   self:DoSmoke()
  end

  self:SetNextClientThink(CurTime() + 0.03)
end

function ENT:DoSmoke()
  local pos = self:LocalToWorld(Vector(0, 0, 0))
  local emitter = ParticleEmitter(pos)

  local col = CarePackage.Config.SmokeColor or XeninUI.Theme.Red
  local part = emitter:Add("particle/particle_smokegrenade", pos)
  if (part) then
    part:SetDieTime(3)
    part:SetStartAlpha(255)
    part:SetEndAlpha(100)
    part:SetStartSize(2)
    part:SetEndSize(65)
    part:SetCollide(true)
    part:SetBounce(5)
    part:SetGravity(Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(10, 40)))
    part:SetColor(col.r, col.g, col.b)
    part:SetVelocity(VectorRand() * 1)
  end

  emitter:Finish()
end
