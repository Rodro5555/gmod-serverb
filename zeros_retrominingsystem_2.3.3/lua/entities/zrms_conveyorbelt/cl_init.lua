include("shared.lua")

function ENT:Initialize()
	// Creates particle emitter
	self.InsertEffect = ParticleEmitter(self:GetPos())

	// Sets up belt material
	self:Setup_BeltMaterial()

	// Sets up stuff for the client gravel animation
	zrmine.f.Gravel_Initialize(self)

	self.LastState = -1

	zrmine.f.EntList_Add(self)
end

function ENT:Setup_BeltMaterial()
	local params = {
		["$color2"] = Vector(1, 0, 0),
		["$basetexture"] = "zerochain/props_mining/conveyorbelt/zrms_conveyorbelt_belt_diff",
		["$bumpMap"] = "zerochain/props_mining/conveyorbelt/zrms_conveyorbelt_belt_nrm",
		["$normalmapalphaenvmapmask"] = 1,
		["$surfaceprop"] = "metal",
		["$halflambert"] = 1,
		["$model"] = 1,
		["$envmap"] = "env_cubemap",
		["$envmaptint"] = Vector(0.01, 0.01, 0.01),
		["$envmapfresnel"] = 1,
		["$phong"] = 1,
		["$phongexponenttexture"] = "zerochain/props_mining/conveyorbelt/zrms_conveyorbelt_belt_phong",
		["$phongtint"] = Vector(1, 1, 1),
		["$phongboost"] = 25,
		["$phongfresnelranges"] = Vector(0.05, 0.5, 1),
		["$myspeed"] = 0,

		Proxies = {
			TextureScroll = {
				texturescrollvar = "$baseTexturetransform",
				texturescrollrate = "$myspeed",
				texturescrollangle = -90
			}
		}
	}

	self.ScrollMat = CreateMaterial("scrollmat" .. self:EntIndex(), "VertexLitGeneric", params)
	local id

	if (self:GetClass() == "zrms_conveyorbelt_n") then
		id = 0
	elseif (self:GetClass() == "zrms_conveyorbelt_s") then
		id = 0
	else
		id = 3
	end

	self:SetSubMaterial(id, "!scrollmat" .. self:EntIndex())

	zrmine.f.Debug("Created Material")
end

function ENT:ReturnStorage()
	return self:GetCoal() + self:GetIron() + self:GetBronze() + self:GetSilver() + self:GetGold()
end

function ENT:UpdateState()
	local CurrentState = self:GetCurrentState()

	if CurrentState ~= self.LastState then

		self.LastState = CurrentState

		if self.LastState == 1 then

			zrmine.f.Animation(self, "output", 0.25)

			local Belt_speed = 10 / self.TransportSpeed
			self.ScrollMat:SetFloat("$myspeed", Belt_speed)


			if self:GetClass() == "zrms_inserter" then

				timer.Simple(self.TransportSpeed - 1.8, function()
					if IsValid(self) then
						self:Mode_Inserter_OUPUT()
					end
				end)

				timer.Simple(self.TransportSpeed + 0.3, function()
					if IsValid(self) and self:ReturnStorage() <= 0 then
						self:Mode_IDLE()
					end
				end)
			else

				timer.Simple(self.TransportSpeed + 0.1, function()
					if IsValid(self) and self:ReturnStorage() <= 0 then
						self:Mode_IDLE()
					end
				end)
			end
		else
			self:Mode_IDLE()
		end
	end
end

function ENT:Mode_IDLE()
	zrmine.f.Animation(self, "idle", 1)

	local Belt_speed = 0
	self.ScrollMat:SetFloat("$myspeed", Belt_speed)
end

function ENT:Mode_Inserter_OUPUT()

	// Here we send the resources or show the discard gravel effect
	local attach = self:GetAttachment(self:LookupAttachment("output"))

	if attach == nil then return end

	local effectPos03 = attach.Pos + self:GetUp() * 24 + self:GetForward() * 5
	local effectAng03 = self:GetAngles()

	zrmine.f.EmitSoundENT("zrmine_refinerdirt",self)
	zrmine.f.ParticleEffect("zrms_refiner_dirt02", effectPos03, effectAng03, self)
end

function ENT:MoveSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_conveyorbelt_move")

	if (self.LastState == 1) then
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

function ENT:Think()
	if  zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		self:UpdateState()

		// Handels the move sound
		self:MoveSound()

		// Handels the gravel animation
		zrmine.f.ClientGravelAnim(self)
	end
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:Draw()
	self:DrawModel()

	zrmine.f.UpdateEntityVisuals(self)

	// Displays the infomations if the players looks at the ent
	if self.ShowInfo then
		self:DrawInfo()
	end
end

function ENT:UpdateVisuals()
	local id

	if (self:GetClass() == "zrms_conveyorbelt_n") then
		id = 0
	elseif (self:GetClass() == "zrms_conveyorbelt_s") then
		id = 0
	else
		id = 3
	end

	if (self:GetSubMaterial(id) ~= "!scrollmat" .. self:EntIndex()) then
		self:SetSubMaterial(id, "!scrollmat" .. self:EntIndex())

		zrmine.f.Debug("Applyied Material")
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

// Draw Info
local offsetX, offsetY = -3, 10
function ENT:DrawResourceItem(OreType, xpos, ypos, size)
	local color = zrmine.f.GetOreColor(OreType)

	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)

	draw.DrawText( math.Round(zrmine.f.GetOreFromEnt(self,OreType)) .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font3", xpos + offsetX + 30, ypos + offsetY + size * 0.25, color, TEXT_ALIGN_LEFT)
end

function ENT:DrawInfo()
	/*
	local Pos = self:LocalToWorld(Vector(0,0,17))

	local aAng = self:GetAngles()
	aAng:RotateAroundAxis(self:GetUp(), 180)
	cam.Start3D2D(Pos, aAng, 0.1)
		draw.RoundedBox(0, -65, -75, 130, 150, zrmine.default_colors["grey01"])
		draw.RoundedBox(0, -60, -70, 120, 140, zrmine.default_colors["grey02"])

		local amount = math.Round(self:ReturnStorage(), 2)
		local aBar = (120 / zrmine.config.Belt_Capacity) * amount

		if (aBar > 120) then
			aBar = 120
		end

		draw.RoundedBox(0, -52, -60, 20, aBar, zrmine.default_colors["brown01"])
	cam.End3D2D()

	cam.Start3D2D(Pos, self:GetAngles(), 0.1)
		self:DrawResourceItem("Coal", -55, -75, 30)
		self:DrawResourceItem("Iron", -55, -50, 30)
		self:DrawResourceItem("Bronze", -55, -25, 30)
		self:DrawResourceItem("Silver", -55, 0, 30)
		self:DrawResourceItem("Gold", -55, 25, 30)

		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["Scale"])
		surface.DrawTexturedRect(17, -62, 50, 125)
	cam.End3D2D()
	*/

	zrmine.f.Belt_DrawInfo(self)
end

function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end
	zrmine.f.RemoveClientGravel(self)
end
