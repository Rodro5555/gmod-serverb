include("shared.lua")

function ENT:Initialize()
	zclib.EntityTracker.Add(self)
	self.Last_IsBurning = false

	timer.Simple(0.5, function()
		if IsValid(self) then
			self.m_Initialized = true
		end
	end)
end

function ENT:Draw()
	self:DrawModel()
	self:DrawInfo()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	if not LocalPlayer().zgo2_Initialized then return end
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(self:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	if zclib.Entity.GetLookTarget() ~= self then return end

	local id = self:GetWeedID()
	if id and id > 0 then
		zgo2.HUD.Draw(self,function()
			local name = zgo2.Plant.GetName(id)
			local boxSize = zclib.util.GetTextSize(name, zclib.GetFont("zclib_world_font_medium")) * 1.2
			draw.RoundedBox(20, -boxSize/2,-90, boxSize, 210, zclib.colors["black_a200"])
			draw.SimpleText(name, zclib.GetFont("zclib_world_font_medium"), 0, -45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self:GetWeedAmount() .. zgo2.config.UoM, zclib.GetFont("zclib_world_font_medium"), 0, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self:GetWeedTHC() .. "%", zclib.GetFont("zclib_world_font_medium"), 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText("▼", zclib.GetFont("zclib_world_font_large"), 0, 150, zclib.colors["black_a200"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end,0.05)
	end
end


function ENT:Think()
	if not self.m_Initialized then return end
	if not LocalPlayer().zgo2_Initialized then return end

	if zclib.util.InDistance(self:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) then
		local _IsBurning = self:GetIsBurning()

		if self.Last_IsBurning ~= _IsBurning then
			self.Last_IsBurning = _IsBurning

			if self.Last_IsBurning then
				self:SetSkin(1)
				zclib.Effect.ParticleEffectAttach("zgo2_ent_fire", PATTACH_POINT_FOLLOW, self, 1)
			else
				self:StopParticles()
			end
		end
	else
		if self.Last_IsBurning == true then
			self.Last_IsBurning = false
			self:StopParticles()
		end
	end
end
