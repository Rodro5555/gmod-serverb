include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	local Text = math.Round(self:GetResourceAmount()) .. zrmine.config.BuyerNPC_Mass
	cam.Start3D2D(self:GetPos() + Vector(0, 0, 10), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
		draw.DrawText(Text, "zrmine_resource_font1", 0, 15, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:OnRemove()
	zrmine.f.EmitSoundENT("zrmine_resourcedespawn", self)
	zrmine.f.ParticleEffect("zrms_resource_despawn", self:GetPos(), self:GetAngles(), self)
end
