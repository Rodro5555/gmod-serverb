include("shared.lua")

function ENT:Initialize()
	ZRMS_CSM_MELTER[self:EntIndex()] = self

	self.ClientModels = {}

	self.LastResourceAmount = 0
	self.ResrcFill_Height = 0

	self.LastState = -1

	self.LastCoal = 0

	self.a_cycle = 0
	self.b_cycle = 0

	self.SoundStage = 0
end

function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:Draw_MainInfo()
		self:Draw_CoalInfo()
	end

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 600) then

		if GetConVar("zrms_cl_dynlight"):GetInt() == 1 then
			self:MelterLight()
		end

		if (IsValid(self) and self:GetCurrentState() == "WAITING_FOR_ORDER") then
			self:StopParticlesNamed("zrms_melter_unload")
			self:StopParticlesNamed("zrms_melter_chimney")
			self:StopParticlesNamed("zrms_melter_head")
			self:StopParticlesNamed("zrms_melter_coalpit")
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


// UI STUFF
function ENT:Draw_CoalInfo()
	local amount = tostring(math.Round(self:GetCoalAmount(), 2))
	local aBar = (100 / zrmine.config.Melter_Coal_Capacity) * amount

	if (aBar > 100) then
		aBar = 100
	end

	cam.Start3D2D(self:LocalToWorld(Vector(80,0,11)), self:LocalToWorldAngles(Angle(0,90,90)), 0.1)

		draw.RoundedBox(0, -105, -65, 210, 130, zrmine.default_colors["grey02"])
		draw.RoundedBox(0, -92, 50, 30, -aBar, zrmine.default_colors["Coal"])

		surface.SetDrawColor(zrmine.default_colors["Coal"])
		surface.SetMaterial(zrmine.default_materials["Ore"])
		surface.DrawTexturedRect(-50, -75, 100, 100)

		draw.DrawText(math.Round(amount) .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font2", 0, 10, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)

		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["Scale"])
		surface.DrawTexturedRect(-115, -53, 75, 105)
	cam.End3D2D()
end

function ENT:Draw_MainInfo()

	local status = ""
	local cState = self:GetCurrentState()

	local amount = math.Round(self:GetResourceAmount())
	local resourceType = self:GetResourceType()
	local paintColor = zrmine.f.GetOreColor(resourceType)

	if (cState == 0) then
		status = zrmine.language.Melter_InsertOre
	elseif (cState == 1 and self:GetCoalAmount() < zrmine.config.Melter_Vars[resourceType].CoalAmount) then
		status = zrmine.language.Melter_NeedCoal
	elseif (cState == 2) then
		status = zrmine.language.Melter_Melting
	end

	local aBar = 0
	if (resourceType ~= "Empty") then
		aBar = (100 / zrmine.config.Melter_Vars[resourceType].OreAmount) * amount
	end

	if (aBar > 100) then
		aBar = 100
	end


	local rtype = zrmine.language.Ore_Empty
	if (amount > 0) then
		rtype = zrmine.f.GetOreTranslation(resourceType)
	end

	cam.Start3D2D(self:LocalToWorld(Vector(0,-35.8,44.5)), self:LocalToWorldAngles(Angle(0,0,90)), 0.1)
		draw.RoundedBox(0, -105, -65, 210, 130, zrmine.default_colors["grey02"])

		draw.DrawText(rtype, "zrmine_screen_font2", 20, -50, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
		draw.DrawText(amount .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font1", 20, -10, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
		draw.DrawText(status, "zrmine_screen_font3", 20, 25, zrmine.default_colors["yellow01"], TEXT_ALIGN_CENTER)

		draw.RoundedBox(0, -92, 50, 30, -aBar, paintColor)
		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["Scale"])
		surface.DrawTexturedRect(-115, -53, 75, 105)
	cam.End3D2D()
end

// Sound
function ENT:MelterSound()
	local MeltSound = CreateSound(self, "zrmine_sfx_melter_loop")
	local CoolSound = CreateSound(self, "zrmine_sfx_meltercool_loop")

	if self.SoundStage == 1 then

		// Start Melt Sound
		if self.SoundObj01 == nil then
			self.SoundObj01 = MeltSound
		end

		if self.SoundObj01:IsPlaying() == false then
			self.SoundObj01:Play()
			self.SoundObj01:ChangeVolume(0, 0)
			self.SoundObj01:ChangeVolume(GetConVar("zrms_cl_audiovolume"):GetFloat(), 1)
		end
	elseif self.SoundStage == 2 then

		// STOP Melt Sound
		if self.SoundObj01 == nil then
			self.SoundObj01 = MeltSound
		end

		if self.SoundObj01:IsPlaying() == true then
			self.SoundObj01:ChangeVolume(0, 1)
			if ((self.lastSoundStop or CurTime()) > CurTime()) then return end
			self.lastSoundStop = CurTime() + 5

			timer.Simple(2, function()
				if (IsValid(self)) then
					self.SoundObj01:Stop()
				end
			end)
		end

		// Start Cool Sound
		if self.SoundObj02 == nil then
			self.SoundObj02 = CoolSound
		end

		if self.SoundObj02:IsPlaying() == false then
			self.SoundObj02:Play()
			self.SoundObj02:ChangeVolume(0, 0)
			self.SoundObj02:ChangeVolume(GetConVar("zrms_cl_audiovolume"):GetFloat(), 1)
		end
	elseif self.SoundStage == 3 then

		// STOP Cooling Sound
		if self.SoundObj02 == nil then
			self.SoundObj02 = CoolSound
		end

		if self.SoundObj02:IsPlaying() == true then
			self.SoundObj02:ChangeVolume(0, 1)
			if ((self.lastSoundStop or CurTime()) > CurTime()) then return end
			self.lastSoundStop = CurTime() + 5

			timer.Simple(2, function()
				if (IsValid(self)) then
					self.SoundObj02:Stop()
				end
			end)
		end
	else

		// STOP Melt Sound
		if self.SoundObj01 == nil then
			self.SoundObj01 = MeltSound
		end

		if self.SoundObj01:IsPlaying() == true then
			self.SoundObj01:ChangeVolume(0, 1)
			if ((self.lastSoundStop or CurTime()) > CurTime()) then return end
			self.lastSoundStop = CurTime() + 5

			timer.Simple(2, function()
				if (IsValid(self)) then
					self.SoundObj01:Stop()
				end
			end)
		end

		// STOP Cooling Sound
		if self.SoundObj02 == nil then
			self.SoundObj02 = CoolSound
		end

		if self.SoundObj02:IsPlaying() == true then
			self.SoundObj02:ChangeVolume(0, 1)
			if ((self.lastSoundStop or CurTime()) > CurTime()) then return end
			self.lastSoundStop = CurTime() + 5

			timer.Simple(2, function()
				if (IsValid(self)) then
					self.SoundObj02:Stop()
				end
			end)
		end
	end
end

// Light
function ENT:MelterLight()
	if GetConVar("zrms_cl_dynlight"):GetInt() == 1 and (self:GetCurrentState() == 2 or self:GetCurrentState() == 3) then
		local dlight01 = DynamicLight(self:EntIndex())

		if (dlight01) then
			dlight01.pos = self:GetPos() + self:GetUp() * 15
			dlight01.r = 255
			dlight01.g = 75
			dlight01.b = 0
			dlight01.brightness = 1
			dlight01.Decay = 1000
			dlight01.Size = 512
			dlight01.DieTime = CurTime() + 1
		end
	end
end

// Updates the Filling Model Skin
function ENT:UpdateFillingSkin(rType)
	if IsValid(self.ClientModels["Filling"]) then
		if (rType == "Dirt") then
			self.ClientModels["Filling"]:SetSkin(0)
		elseif (rType == "Iron") then
			self.ClientModels["Filling"]:SetSkin(1)
		elseif (rType == "Bronze") then
			self.ClientModels["Filling"]:SetSkin(2)
		elseif (rType == "Silver") then
			self.ClientModels["Filling"]:SetSkin(3)
		elseif (rType == "Gold") then
			self.ClientModels["Filling"]:SetSkin(4)
		end
	end
end


// This updates the height and visibility of the client coal model
function ENT:UpdateCoal()

	local coal = self:GetCoalAmount()

	if self.LastCoal ~= coal then

		if coal > self.LastCoal then
			zrmine.f.EmitSoundENT("zrmine_addgravel",self)

			zrmine.f.ParticleEffect("zrms_melter_coalfill", self:GetPos() + self:GetUp() * 25 + self:GetForward() * 70, self:GetAngles(), self)
		end

		self.CoalFill_Height = (20 / zrmine.config.Melter_Coal_Capacity) * coal
		self.ClientModels["Coal"]:SetNoDraw(false)

		if (self.CoalFill_Height > 20) then
			self.CoalFill_Height = 20
		end

		if (self.CoalFill_Height < 0 or coal <= 0) then
			self.CoalFill_Height = 0
			self.ClientModels["Coal"]:SetNoDraw(true)
		end

		self.ClientModels["Coal"]:SetPos(self:GetPos() + self:GetUp() * -23  + self.ClientModels["Coal"]:GetUp() * self.CoalFill_Height)

		self.LastCoal = coal
	end
end


function ENT:Think()
	if  zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		if self.ClientModels == nil then self.ClientModels = {} end

		if not IsValid(self.ClientModels["BurnChamber"]) then
			self.ClientModels["BurnChamber"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_burnchamber.mdl")
			self.ClientModels["BurnChamber"]:SetParent(self)
			self.ClientModels["BurnChamber"]:SetNoDraw(true)
		end

		if not IsValid(self.ClientModels["BurnCoal"]) then
			self.ClientModels["BurnCoal"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_burningcoal.mdl")
			self.ClientModels["BurnCoal"]:SetParent(self)
			self.ClientModels["BurnCoal"]:SetNoDraw(true)
		end

		if IsValid(self.ClientModels["Filling"]) then

			local attach = self:GetAttachment(self:LookupAttachment("body"))
			if attach then
				self.ClientModels["Filling"]:SetPos(attach.Pos - attach.Ang:Up() * (25 - self.ResrcFill_Height))
				self.ClientModels["Filling"]:SetAngles(attach.Ang)
			end

			local rAmount = self:GetResourceAmount()

			if self.LastResourceAmount ~= rAmount then
				self.LastResourceAmount = rAmount

				if rAmount <= 0 then
					self.ClientModels["Filling"]:SetNoDraw(true)
				else

					self.ResrcFill_Height = (25 / zrmine.config.Melter_Vars[self:GetResourceType()].OreAmount) * rAmount

					if (self.ResrcFill_Height > 25) then
						self.ResrcFill_Height = 25
					end

					self.ClientModels["Filling"]:SetNoDraw(false)

					self:UpdateFillingSkin(self:GetResourceType())
				end
			end
		else
			self.ClientModels["Filling"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_filling.mdl")
			self.ClientModels["Filling"]:SetNoDraw(true)
			self.ClientModels["Filling"]:SetPos(self:GetPos() + self:GetUp() * -2)
			self.ClientModels["Filling"]:SetAngles(self:GetAngles())
			self.ClientModels["Filling"]:SetParent(self, self:LookupAttachment("body"))
		end

		if IsValid(self.ClientModels["Lava"]) then
			self.ClientModels["Lava"]:SetPos(self:GetPos())

			local ang = self:GetAngles()
			ang:RotateAroundAxis(self:GetUp(), -90)
			self.ClientModels["Lava"]:SetAngles(ang)


			if self.ClientModels["Lava"]:GetNoDraw() == false then
				local speed = 1
				self.a_cycle = math.Clamp(self.a_cycle + (1 / speed) * FrameTime(), 0, 1)

				if self.a_cycle >= 1 then
					self.a_cycle = 0
				else

					local sequence = self.ClientModels["Lava"]:LookupSequence("fill")
					self.ClientModels["Lava"]:SetSequence(sequence)
					self.ClientModels["Lava"]:SetPlaybackRate(1)
					self.ClientModels["Lava"]:SetCycle(self.a_cycle)
				end
			end
		else
			self.ClientModels["Lava"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_lava.mdl")
			self.ClientModels["Lava"]:SetNoDraw(true)
			self.ClientModels["Lava"]:SetParent(self)
		end

		if IsValid(self.ClientModels["MoltenMetal"]) then
			// Handel animation here if normal way dont works

			local attach = self:GetAttachment(self:LookupAttachment("moltenmetal"))
			local ang = attach.Ang
			ang:RotateAroundAxis(attach.Ang:Up(),90)
			self.ClientModels["MoltenMetal"]:SetAngles(ang)
			self.ClientModels["MoltenMetal"]:SetPos(attach.Pos + self:GetForward() * 1.5 + self:GetUp() * -2)

			if self.ClientModels["MoltenMetal"]:GetNoDraw() == false then

				local speed = zrmine.config.Melter_UnloadTime
				self.b_cycle = math.Clamp(self.b_cycle + (1 / speed) * FrameTime(), 0, 1)

				if self.b_cycle >= 1 then
					self.b_cycle = 1
				else

					local sequence = self.ClientModels["MoltenMetal"]:LookupSequence("fill")
					self.ClientModels["MoltenMetal"]:SetSequence(sequence)
					self.ClientModels["MoltenMetal"]:SetPlaybackRate(1)
					self.ClientModels["MoltenMetal"]:SetCycle(self.b_cycle)
				end
			end
		else
			self.ClientModels["MoltenMetal"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_moltenmetal.mdl")
			self.ClientModels["MoltenMetal"]:SetNoDraw(true)
			self.ClientModels["MoltenMetal"]:SetAngles(self:GetAngles())

			local attach = self:GetAttachment(self:LookupAttachment("moltenmetal"))
			if attach then
				self.ClientModels["MoltenMetal"]:SetPos(attach.Pos + self:GetForward() * 1.5 + self:GetUp() * -2)
				self.ClientModels["MoltenMetal"]:SetParent(self, self:LookupAttachment("moltenmetal"))
			end
		end

		if IsValid(self.ClientModels["Coal"]) then
			self:UpdateCoal()
		else
			self.ClientModels["Coal"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_coal.mdl")
			self.ClientModels["Coal"]:SetNoDraw(true)
			self.ClientModels["Coal"]:SetPos(self:GetPos() + self:GetUp() * -23)
			self.ClientModels["Coal"]:SetAngles(self:GetAngles())
			self.ClientModels["Coal"]:SetParent(self)
		end


		if IsValid(self.ClientModels["Bars"]) then

			local attach = self:GetAttachment(self:LookupAttachment("moltenmetal"))

			local ang = attach.Ang
			ang:RotateAroundAxis(attach.Ang:Up(),90)

			self.ClientModels["Bars"]:SetPos(attach.Pos + attach.Ang:Up() * -1 + attach.Ang:Forward() * 1)
			self.ClientModels["Bars"]:SetAngles(ang)
		else
			self.ClientModels["Bars"] = self:CreateClientSideModel("models/zerochain/props_mining/zrms_melter_bars.mdl")
			self.ClientModels["Bars"]:SetNoDraw(true)
			self.ClientModels["Bars"]:SetParent(self, self:LookupAttachment("moltenmetal"))
		end

		// Handels Sound
		self:MelterSound()

		// Handels Animation and Effects
		self:StateSwitch()

	end
	self:SetNextClientThink(CurTime())
	return true
end

// State Logic Switch
function ENT:StateSwitch()
	local state = self:GetCurrentState()

	if self.LastState ~= state then

		//WAITING_FOR_ORDER
		if state == 0 then

			// Reset these values
			self.a_cycle = 0
			self.b_cycle = 0

			if self.LastState == 3 or self.LastState == -1 then
				zrmine.f.Animation(self, "open", 1)
			end
			self.ClientModels["Filling"]:SetNoDraw(true)
			self.ClientModels["Bars"]:SetNoDraw(true)
			self.ClientModels["MoltenMetal"]:SetNoDraw(true)
			self.ClientModels["Lava"]:SetNoDraw(true)

		//CHAMBER_FULL
		elseif state == 1 then

		//MELTING
		elseif state == 2 then

			zrmine.f.EmitSoundENT("zrmine_melter_move",self)

			zrmine.f.Animation(self, "close", 1)

			timer.Simple(2, function()
				if (IsValid(self)) then

					self.SoundStage = 1

					zrmine.f.ParticleEffectAttach("zrms_melter_coalpit", self, self:LookupAttachment("coalpit"))
					zrmine.f.ParticleEffectAttach("zrms_melter_head", self, self:LookupAttachment("body"))
					zrmine.f.ParticleEffectAttach("zrms_melter_chimney", self, self:LookupAttachment("chimney01"))
					zrmine.f.ParticleEffectAttach("zrms_melter_chimney", self, self:LookupAttachment("chimney02"))

					self.ClientModels["Filling"]:SetNoDraw(true)
				end
			end)

		//UNLOADING
		elseif state == 3 then

			self.SoundStage = 2

			zrmine.f.EmitSoundENT("zrmine_melter_move",self)
			self:EmitSound("doors/door_metal_rusty_move1.wav", 75, 100, 1, CHAN_AUTO)

			self:StopParticlesNamed("zrms_melter_coalpit")
			zrmine.f.Animation(self, "unload_start", 1)

			timer.Simple(2, function()
				if IsValid(self) then

					self:EmitSound("doors/door_metal_rusty_move1.wav", 75, 100, 1, CHAN_AUTO)

					zrmine.f.ParticleEffectAttach("zrms_melter_unload", self, self:LookupAttachment("effectpoint01"))

					self.ClientModels["Lava"]:SetNoDraw(false)
					self.ClientModels["MoltenMetal"]:SetNoDraw(false)

				end
			end)

			timer.Simple(zrmine.config.Melter_UnloadTime, function()
				if IsValid(self) then

					self.ClientModels["Lava"]:SetNoDraw(true)
					self:EmitSound("doors/door_metal_rusty_move1.wav", 75, 100, 1, CHAN_AUTO)
					zrmine.f.Animation(self, "unload_stop", 1)

					self:StopParticlesNamed("zrms_melter_unload")
					self:StopParticlesNamed("zrms_melter_chimney")
					self:StopParticlesNamed("zrms_melter_head")
				end
			end)

			local rType = self:GetResourceType()

			timer.Simple(zrmine.config.Melter_UnloadTime + zrmine.config.Melter_Vars[rType].CoolingTime, function()
				if (IsValid(self)) then

					self.SoundStage = 3

					self:EmitSound("doors/door_metal_rusty_move1.wav", 75, 100, 1, CHAN_AUTO)
					zrmine.f.EmitSoundENT("zrmine_melter_move",self)

					zrmine.f.Animation(self, "unload_bars", 1)

					self.ClientModels["MoltenMetal"]:SetNoDraw(true)

					local btype = self:GetResourceType()

					if (btype == "Iron") then
						self.ClientModels["Bars"]:SetSkin(0)
					elseif (btype == "Bronze") then
						self.ClientModels["Bars"]:SetSkin(1)
					elseif (btype == "Silver") then
						self.ClientModels["Bars"]:SetSkin(2)
					elseif (btype == "Gold") then
						self.ClientModels["Bars"]:SetSkin(3)
					end

					self.ClientModels["Bars"]:SetNoDraw(false)

				end
			end)

			timer.Simple(zrmine.config.Melter_UnloadTime + zrmine.config.Melter_Vars[rType].CoolingTime + 1.75, function()
				if IsValid(self) then
					self.ClientModels["Bars"]:SetNoDraw(true)
					self.ClientModels["MoltenMetal"]:SetNoDraw(true)
				end
			end)

		end

		self.LastState = state
	end
end

// Client Props
function ENT:CreateClientSideModel(model)
	local ent = ClientsideModel(model)

	if IsValid(ent) and IsValid(self) then
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
	end
	return ent
end

function ENT:RemoveClientModels()
	if (self.ClientModels and table.Count(self.ClientModels) > 0) then
		for k, v in pairs(self.ClientModels) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
