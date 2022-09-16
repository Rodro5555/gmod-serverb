include("shared.lua")

function ENT:Initialize()
	self.InsertEffect = ParticleEmitter(self:GetPos())
	zrmine.f.EntList_Add(self)
end

function ENT:ReturnStorage()
	return self:GetCoal() + self:GetIron() + self:GetBronze() + self:GetSilver() + self:GetGold()
end

function ENT:SplittSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_conveyorbelt_move")

	if (self:GetCurrentState() == 1) then
		if self.SoundObj == nil then
			self.SoundObj = MoveSound
		end

		if self.SoundObj:IsPlaying() == false then
			self.SoundObj:Play()
			self.SoundObj:ChangeVolume(0, 0)
			self.SoundObj:ChangeVolume(GetConVar("zrms_cl_audiovolume"):GetFloat(), 1)
		end
	else
		if self.SoundObj == nil then
			self.SoundObj = MoveSound
		end

		if self.SoundObj:IsPlaying() == true then
			self.SoundObj:ChangeVolume(0, 1)
			if ((self.lastSoundStop or CurTime()) > CurTime()) then return end
			self.lastSoundStop = CurTime() + 5

			timer.Simple(2, function()
				if (IsValid(self)) then
					self.SoundObj:Stop()
				end
			end)
		end
	end
end

function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end
end

function ENT:Think()
	if zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		self:SplittSound()
	end
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:Draw()
	self:DrawModel()

	if self.ShowInfo then
		zrmine.f.Belt_DrawInfo(self)
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end
