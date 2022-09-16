include("shared.lua")

XeninUI:CreateFont("CarePackage.3D", 80)
XeninUI:CreateFont("CarePackage.3D.Small", 40)

function ENT:Draw()
  self:DrawModel()

  local ply = LocalPlayer()
  local pos = self:LocalToWorld(Vector(0, 0, 45))
  local eyePos = ply:GetPos()
  local dist = pos:Distance(eyePos)
  local alpha = math.Clamp(900 - dist * 2.7, 0, 255)

  if (alpha <= 0) then return end

  local angle = Angle(0, 0, 0)
  angle:RotateAroundAxis(Vector(1, 0, 0), 90)
  angle.y = LocalPlayer():GetAngles().y + 270

  cam.Start3D2D(pos, angle, 0.04)
    local name = self.PrintName
    surface.SetFont("CarePackage.3D")
    local tw, th = surface.GetTextSize(name)
    tw = tw + 96
    th = th + 24

    local y = -180
    local dur = 0
    local maxDur = 2
    local claimed = self:GetBeenUsed()

    local colorWidth = tw * (dur / maxDur)
    draw.RoundedBox(th / 2, -tw / 2, -th / 2 - y, tw, th, ColorAlpha(XeninUI.Theme.Primary, alpha))
    draw.SimpleText(name, "CarePackage.3D", 0, -y, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    tw = tw - 64
    y = y + th / 2 - 20 / 2 + 5
    local x = -tw / 2
    draw.RoundedBoxEx(12, x, -th / 2 - y, tw, 40, ColorAlpha(XeninUI.Theme.Navbar, alpha), true, true, true, true)
    local frac = math.Clamp(self:GetProgress(), 0, 1)
    local fW = frac * tw
    local str = "UNOPENED"
    if (frac > 0 and frac < 1) then
      str = "OPENING IN " .. math.Round(CarePackage.Config.OpenTime - (frac * CarePackage.Config.OpenTime)) .. " SECONDS"
    elseif (frac >= 1) then
      str = "OPENED"
    end

    draw.RoundedBoxEx(12, x, -th / 2 - y, fW, 40, ColorAlpha(claimed and XeninUI:LerpColor(frac, XeninUI.Theme.Red, XeninUI.Theme.Green) or XeninUI.Theme.Purple, alpha), true, true, true, true)
    for i = 1, 2 do
      draw.SimpleText(str, "CarePackage.3D.Small", x + tw / 2 + i, -th / 2 - y - 2 + i, Color(0, 0, 0, i * 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    draw.SimpleText(str, "CarePackage.3D.Small", x + tw / 2, -th / 2 - y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
  cam.End3D2D()
end

function ENT:Initialize()
  hook.Add("PostDrawTranslucentRenderables", "CP." .. self:EntIndex(), function()
    if (!IsValid(self)) then return end
    local cfg = CarePackage.Config.Indicator
    if (!cfg.Enabled) then return end
    local progress = self:GetProgress()
    if (progress <= 0) then return end

    local angle = self:GetAngles()
    local pos = self:LocalToWorld(Vector(0, 0, 45))
    local radius = cfg.Radius
    pos = pos - Vector(0, 0, 72)

    cam.Start3D2D(pos, angle, 0.04)
      XeninUI:DrawCircle(0, 0, radius, 90, cfg.Color)
    cam.End3D2D()
  end)
end

function ENT:OnRemove()
  hook.Remove("PostDrawTranslucentRenderables", "CP." .. self:EntIndex())
end

function ENT:Think()
  local progress = self:GetProgress()
  if (progress >= 0.01) then return end

  self:DoSmoke()

  self:SetNextClientThink(CurTime() + 0.08)
end

function ENT:DoSmoke()
  local pos = self:LocalToWorld(Vector(-2, 0, 28))
  local emitter = ParticleEmitter(pos)

  local col = CarePackage.Config.SmokeColor
  local part = emitter:Add("particle/particle_smokegrenade", pos)
  if (part) then
    part:SetDieTime(3)
    part:SetStartAlpha(255)
    part:SetEndAlpha(100)
    part:SetStartSize(2)
    part:SetEndSize(65)
    part:SetCollide(true)
    part:SetBounce(5)
    part:SetGravity(Vector(0, 0, 25))
    part:SetColor(col.r, col.g, col.b)
    part:SetVelocity(VectorRand() * 1)
  end

  emitter:Finish()
end
