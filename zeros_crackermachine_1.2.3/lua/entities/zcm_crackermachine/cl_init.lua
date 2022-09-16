include("shared.lua")

function ENT:Initialize()
	self.ProductionStage01 = 0
	self.ProductionStage02 = 0
	self.LastBlackPowder = -1
	self.LastPaper = -1
	self.PaperScale = 1
	self.BlackPowderHeight = 1
	self.SoundObj = {}
	self.CurrentStageLevel = 0

	self.LastPaperRolls = 0
	zcm.f.EntList_Add(self)
end

function ENT:PlaySound(sound,speed)

	local MoveSound = CreateSound(self, sound)

	local pitch = math.Clamp(100 * speed,0,255)

	if self.SoundObj[sound] == nil then
		self.SoundObj[sound] = MoveSound
	end

	if self.SoundObj[sound]:IsPlaying() then
		self.SoundObj[sound]:Stop()
	end

	self.SoundObj[sound]:Play()
	self.SoundObj[sound]:SetSoundLevel(65)
	self.SoundObj[sound]:ChangeVolume(zcm.f.GetVolume(), 0)
	self.SoundObj[sound]:ChangePitch(pitch, 0)
end

function ENT:IngInfo(posX, posY, mat, value, HasResource)
	surface.SetDrawColor(zcm.default_colors["grey01"])
	surface.SetMaterial(zcm.default_materials["circle"])
	surface.DrawTexturedRect(posX - 60, posY - 60, 120, 120)
	draw.NoTexture()

	surface.SetDrawColor(zcm.default_colors["white01"])
	surface.SetMaterial(zcm.default_materials[mat])
	surface.DrawTexturedRect(posX - 60, posY - 60, 120, 120)
	draw.NoTexture()

	draw.DrawText(value, "zcm_font01", posX, posY + 10, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)

	if HasResource then
		surface.SetDrawColor(zcm.default_colors["white02"])
	else
		surface.SetDrawColor(zcm.default_colors["red01"])
	end

	surface.SetMaterial(zcm.default_materials["ring"])
	surface.DrawTexturedRect(posX - 60, posY - 60, 120, 120)
	draw.NoTexture()
end

function ENT:Draw()
	self:DrawModel()

	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then

		local Paper = self:GetPaper() or 0
		local BlackPowder = self:GetBlackPowder() or 0
		local PaperRolls = self:GetPaperRolls() or 0
		local level = self:GetUpgradeLevel() or 0
		local isrunning = self:GetRunning() or false

		cam.Start3D2D(self:LocalToWorld(Vector(-39.7,54.8,52.7)), self:LocalToWorldAngles(Angle(0,180,90)), 0.05)


			-- Background
			draw.RoundedBox(0, -320, -200, 640, 400, zcm.default_colors["grey02"])

			draw.RoundedBox(5, -300, -110, 600, 160, zcm.default_colors["grey01"])
			draw.RoundedBox(5, -290, -100, 580, 140, zcm.default_colors["grey02"])

			draw.DrawText(zcm.language.General["Level"] .. ": " .. level, "zcm_font02", 0, -205, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)

			self:IngInfo(-200, -35, "paper", Paper, Paper >= zcm.config.CrackerMachine.Usage_Paper)

			draw.DrawText("⇨", "zcm_font02", -100, -87, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
			self:IngInfo(0, -35, "paperroll", PaperRolls, PaperRolls > 0)
			self:IngInfo(200, -35, "blackpowder", BlackPowder, BlackPowder >= zcm.config.CrackerMachine.Usage_BlackPowder)


			self.CurrentStageLevel = self.CurrentStageLevel + (100 * self:GetSpeed()) * FrameTime()
			self.CurrentStageLevel = math.Clamp(self.CurrentStageLevel,0,(580 / 5) * self:GetFinalStage())
			draw.RoundedBox(0, -290, 30, 580, 10, zcm.default_colors["black01"])
			draw.RoundedBox(0, -290, 30, self.CurrentStageLevel, 10, zcm.default_colors["green01"])


			if isrunning then

				if self:OnSwitchButton(LocalPlayer()) then
					draw.RoundedBox(15, -300, 70, 200, 100, zcm.default_colors["red02"])
				else
					draw.RoundedBox(15, -300, 70, 200, 100, zcm.default_colors["red03"])
				end

				if string.len(zcm.language.General["Stop"]) > 5 then
					draw.DrawText(zcm.language.General["Stop"], "zcm_font03_small", -201, 97, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
				else
					draw.DrawText(zcm.language.General["Stop"], "zcm_font03", -205, 85, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
				end
			else
				if self:OnSwitchButton(LocalPlayer()) then
					draw.RoundedBox(15, -300, 70, 200, 100, zcm.default_colors["green02"])
				else
					draw.RoundedBox(15, -300, 70, 200, 100, zcm.default_colors["green03"])
				end

				if string.len(zcm.language.General["Start"]) > 5 then
					draw.DrawText(zcm.language.General["Start"], "zcm_font03_small", -201, 97, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
				else
					draw.DrawText(zcm.language.General["Start"], "zcm_font03", -205, 85, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
				end

			end

			if table.Count(zcm.config.CrackerMachine.Upgrades.Ranks) > 0 then

				if zcm.config.CrackerMachine.Upgrades.Ranks[zcm.f.GetPlayerRank(LocalPlayer())] then
					self:DrawUpgrade()
				end
			else
				self:DrawUpgrade()
			end
		cam.End3D2D()
	end
end

function ENT:DrawUpgrade()
	if self:GetUpgradeLevel() < zcm.config.CrackerMachine.Upgrades.Count then
		if self:GetUCooldDown() > CurTime() then
			draw.RoundedBox(15, -80, 70, 380, 100, zcm.default_colors["grey03"])
			draw.DrawText(math.Round(self:GetUCooldDown() - CurTime()) .. "s", "zcm_font03", 108, 85, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
		else
			if self:OnUpgradeButton(LocalPlayer()) then
				draw.RoundedBox(15, -80, 70, 380, 100, zcm.default_colors["yellow01"])
			else
				draw.RoundedBox(15, -80, 70, 380, 100, zcm.default_colors["yellow02"])
			end
			draw.DrawText("⇧ " .. zcm.config.CrackerMachine.Upgrades.Cost .. zcm.config.Currency .. " ⇧", "zcm_font03", 108, 85, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
		end
	else
		draw.RoundedBox(15, -80, 70, 380, 100, zcm.default_colors["grey03"])
		if string.len(zcm.language.General["MaxLevel"]) > 10 then
			draw.DrawText(zcm.language.General["MaxLevel"], "zcm_font03_small", 108, 100, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
		else
			draw.DrawText(zcm.language.General["MaxLevel"], "zcm_font03", 108, 85, zcm.default_colors["white01"], TEXT_ALIGN_CENTER)
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()

	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then
		self:AnimationHandler01()
		self:AnimationHandler02()
	end

	-- ClientModel
	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then

		if self.ClientProps then
			if self.LastBlackPowder ~= self:GetBlackPowder() then

				self.LastBlackPowder = self:GetBlackPowder()

				if IsValid(self.ClientProps["BlackPowder"]) then
					self.ClientProps["BlackPowder"]:SetPos(self:LocalToWorld(Vector(-79, -26, 92)))
				else
					self:SpawnClientModel_BlackPowder()
				end

				if self.LastBlackPowder > 0 then
					zcm.f.ParticleEffect("zcm_blackpowder", self:LocalToWorld(Vector(-79, -26, 92)), self:GetAngles(), NULL)
				end
			end

			if IsValid(self.ClientProps["BlackPowder"]) then
				self:UpdateBlackPowder_Visual()
			end


			if self.LastPaper ~= self:GetPaper() then

				self.LastPaper = self:GetPaper()

				if not IsValid(self.ClientProps["PaperRoll"]) then
					self:SpawnClientModel_Paper()
				end
			end

			if IsValid(self.ClientProps["PaperRoll"]) then
				self:UpdatePaper_Visual()
			end
		else
			self.ClientProps = {}
		end
	else
		self:RemoveClientModels()
		self.LastBlackPowder = -1
		self.LastPaper = -1
		self.BlackPowderHeight = -1
		self.PaperScale = -1
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:AnimationHandler01()
	-- Animation01
	if self:GetProductionStage01() ~= self.ProductionStage01 then
		self.ProductionStage01 = self:GetProductionStage01()


		local speed = self:GetSpeed()

		local _PaperRoller = self:GetPaperRoller()
		local _RollMover = self:GetRollMover()
		local _RollReleaser = self:GetRollReleaser()
		local _RollCutter = self:GetRollCutter()

		if self.ProductionStage01 == 1 then

			zcm.f.PlayClientAnimation(_PaperRoller,"run", speed)
			self:PlaySound("zcm_paperroller",speed)

			timer.Simple(3.33 / speed,function()
				if IsValid(self) and IsValid(_PaperRoller) then
					zcm.f.PlayClientAnimation(_PaperRoller,"idle", 1)
				end
			end)

		elseif self.ProductionStage01 == 2 then
			zcm.f.PlayClientAnimation(_RollMover,"move", speed)
			self:PlaySound("zcm_rollmover",speed)

		elseif self.ProductionStage01 == 3 then

			zcm.f.PlayClientAnimation(_RollCutter,"cut", speed)
			self:PlaySound("zcm_cutter",speed)

			timer.Simple(0.5 / speed,function()
				if IsValid(_RollCutter) then
					zcm.f.ParticleEffectAttach("zcm_cutting_dust", _RollCutter, 1)
				end
			end)

		elseif self.ProductionStage01 == 4 then
			if IsValid(_RollCutter) then
				_RollCutter:StopParticles()
			end

			zcm.f.PlayClientAnimation(_RollReleaser,"release", speed + 1)
			self:PlaySound("zcm_rollrelease",speed)

			timer.Simple(2 / speed,function()
				if IsValid(self) and IsValid(_RollReleaser) then
					zcm.f.PlayClientAnimation(_RollReleaser,"idle", 1)
				end
			end)
		end
	end
end

function ENT:AnimationHandler02()

	-- Animation02
	if self:GetProductionStage02() ~= self.ProductionStage02 then
		self.ProductionStage02 = self:GetProductionStage02()

		local speed = self:GetSpeed()
		local _RollPacker = self:GetRollPacker()
		local _RollBinder = self:GetRollBinder()
		local _PowderFiller = self:GetPowderFiller()

		if self.ProductionStage02 == 0 then
			if not IsValid(_RollPacker) then return end

			_RollPacker:SetBodygroup(0,0)
			_RollPacker:SetBodygroup(1,0)
			zcm.f.PlayClientAnimation(_RollPacker,"idle", 5)

		elseif self.ProductionStage02 == 1 then
			if not IsValid(_RollPacker) then return end

			if math.random(1,2) == 1 then
				_RollPacker:SetBodygroup(0,1)
				zcm.f.PlayClientAnimation(_RollPacker,"idle", 5)
				zcm.f.PlayClientAnimation(_RollPacker,"output01", speed)
			else
				_RollPacker:SetBodygroup(1,1)
				zcm.f.PlayClientAnimation(_RollPacker,"idle", 5)
				zcm.f.PlayClientAnimation(_RollPacker,"output02", speed)
			end

			self:PlaySound("zcm_rollpacker",speed)

		elseif self.ProductionStage02 == 2 then

			if not IsValid(_RollBinder) then return end

			zcm.f.PlayClientAnimation(_RollBinder,"binde", speed)
			self:PlaySound("zcm_binder",speed)

			timer.Simple(2 / speed,function()
				if IsValid(_RollBinder) then
					zcm.f.ParticleEffectAttach("zcm_warpping", _RollBinder, 1)
				end
			end)
		elseif self.ProductionStage02 == 3 then
			if not IsValid(_PowderFiller) then return end
			if not IsValid(_RollBinder) then return end

			if IsValid(_RollBinder) then
				_RollBinder:StopParticles()
			end
			zcm.f.PlayClientAnimation(_PowderFiller,"fill", speed)
			self:PlaySound("zcm_powderfiller",speed)

		    timer.Simple(6.5 / speed,function()
		        if IsValid(self) then
					zcm.f.ParticleEffect("zcm_blackpowder_burst", self:LocalToWorld(Vector(-79, -26, 28)), self:GetAngles(), NULL)
		        end
		    end)
		end
	end
end

function ENT:UpdatePaper_Visual()
	local _roller = self:GetPaperRoller()
	if not IsValid(_roller) then return end
	local attach = _roller:GetAttachment(1)

	if attach == nil then return end

	local ang = attach.Ang
	ang:RotateAroundAxis(ang:Forward(),90)
	self.ClientProps["PaperRoll"]:SetAngles(attach.Ang)

	self.ClientProps["PaperRoll"]:SetPos(attach.Pos + ang:Right() * 27)

	if self.LastPaper <= 0 then
		self.ClientProps["PaperRoll"]:SetNoDraw(true)
	else

		local newScale = ((1 / self:GetPaperCap()) * self.LastPaper) + 0.2

		if self.PaperScale ~= newScale then

			if newScale > self.PaperScale then
				self.PaperScale = self.PaperScale + 0.5 * FrameTime()
				self.PaperScale = math.Clamp(self.PaperScale, 0, 1)
			else
				self.PaperScale = self.PaperScale - 0.5 * FrameTime()
				self.PaperScale = math.Clamp(self.PaperScale, newScale, 1)
			end

			local mat = Matrix()
			mat:Scale(Vector(self.PaperScale, 1, self.PaperScale))
			self.ClientProps["PaperRoll"]:SetNoDraw(false)
			self.ClientProps["PaperRoll"]:EnableMatrix("RenderMultiply", mat)
		end
	end
end

function ENT:UpdateBlackPowder_Visual()
	if self.LastBlackPowder <= 0 then
		self.ClientProps["BlackPowder"]:SetNoDraw(true)
	else

		local newheight = (14 / self:GetBlackPowderCap()) * self.LastBlackPowder

		if self.BlackPowderHeight ~= newheight then

			if newheight > self.BlackPowderHeight then
				self.BlackPowderHeight = self.BlackPowderHeight + 15 * FrameTime()
				self.BlackPowderHeight = math.Clamp(self.BlackPowderHeight, 0, newheight)
			else
				self.BlackPowderHeight = self.BlackPowderHeight - 15 * FrameTime()
				self.BlackPowderHeight = math.Clamp(self.BlackPowderHeight, newheight, 1)
			end

			self.ClientProps["BlackPowder"]:SetNoDraw(false)
			self.ClientProps["BlackPowder"]:SetPos(self:LocalToWorld(Vector(-79, -26, 78 + self.BlackPowderHeight)))
		end
	end
end


function ENT:SpawnClientModel_Paper()
	if not IsValid(self:GetPaperRoller()) then return end
	local attach = self:GetPaperRoller():GetAttachment(1)
	if attach == nil then return end
	local ent = ents.CreateClientProp()
	ent:SetPos(attach.Pos)
	ent:SetModel("models/zerochain/props_crackermaker/zcm_paper_cyl.mdl")
	ent:SetAngles(attach.Ang)
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self,1)
	ent:SetPos(attach.Pos)

	self.ClientProps["PaperRoll"] = ent
end

function ENT:SpawnClientModel_BlackPowder()
	local ent = ents.CreateClientProp()
	ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
	ent:SetModel("models/zerochain/props_crackermaker/zcm_powder.mdl")
	ent:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self)
	ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))

	self.ClientProps["BlackPowder"] = ent
end

function ENT:RemoveClientModels()
	if (self.ClientProps and table.Count(self.ClientProps) > 0) then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end

	self.ClientProps = {}
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
