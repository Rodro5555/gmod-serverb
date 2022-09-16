include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:UpdatePitch()
	local maxSpeed = zrush.config.Machine[self.MachineID].Speed * 2
	local current_Speed = zrush.config.Machine[self.MachineID].Speed * (1 + self:GetSpeedBoost())
	self.SoundPitch = math.Clamp((140 / maxSpeed) * current_Speed, 0, 140) // Maybe replace 140 with 200 idk
end

// This Updates some of the Sound Info
function ENT:UpdateSoundInfo()
	self:UpdatePitch()
	self.UpdateSound = true
end
