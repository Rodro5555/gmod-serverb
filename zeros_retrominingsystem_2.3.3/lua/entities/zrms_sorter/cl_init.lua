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

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 400) then
		self:DrawInfo()
	end

	if self.ShowInfo then
		zrmine.f.Belt_DrawInfo(self)
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


// UI STUFF
function ENT:DrawInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(0,0,18.9)), self:LocalToWorldAngles(Angle(0,0,0)), 0.1)
		draw.RoundedBox(0, -55, -55, 110, 110, zrmine.default_colors["grey05"])

		surface.SetDrawColor(zrmine.f.GetOreColor(self.FilterType))
		surface.SetMaterial(zrmine.default_materials["Ore"])
		surface.DrawTexturedRect(-50, -50, 100, 100)
	cam.End3D2D()
end
