include("shared.lua")

function ENT:Initialize()
	zclib.EntityTracker.Add(self)
	self.LastProcess = -1
	self.HSize = 300
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()

	if zclib.util.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo()
	end
end

local pos_offset = Vector(0, 0, 4)
local ang_offset = Angle(0,0,0)

function ENT:DrawInfo()
	cam.Start3D2D(self:LocalToWorld(pos_offset), self:LocalToWorldAngles(ang_offset), 0.05)
		local _progress = self:GetProgress()
		if _progress > 0 then
			local _size = 300 - (300 / 5) * _progress
			self.HSize = math.Clamp(self.HSize + (300 / 1) * FrameTime(), 0, _size)

			draw.RoundedBox(150, -150, -150, 300, 300, zclib.colors["black_a100"])
			draw.RoundedBox(150, -self.HSize / 2, -self.HSize / 2, self.HSize, self.HSize, zvm.colors["blue02"])
		end
	cam.End3D2D()
end
