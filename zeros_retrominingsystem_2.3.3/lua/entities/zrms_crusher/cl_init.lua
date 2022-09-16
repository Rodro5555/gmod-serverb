include("shared.lua")

function ENT:Initialize()
	// The Belt material
	local params = {
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
	self:SetSubMaterial(2, "!scrollmat" .. self:EntIndex())
	self.ScrollMat:SetFloat("$myspeed", 0)

	// The Light Pixel handler
	//self.PixVis = util.GetPixelVisibleHandle()

	// Sets up stuff for the client gravel animation
	zrmine.f.Gravel_Initialize(self)

	// Adds the client ent to the list
	zrmine.f.EntList_Add(self)

	self.LastState = -1
end

function ENT:ReturnStorage()
	return self:GetCoal() + self:GetIron() + self:GetBronze() + self:GetSilver() + self:GetGold()
end

function ENT:StateChanged()
	local CurrentState = self:GetCurrentState()

	if self.LastState ~= CurrentState then
		self.LastState = CurrentState
		return true
	else
		return false
	end
end

function ENT:EffectsHandler()

	if self.LastState == 0 then
		self:StopParticlesNamed("zrms_crusher_crush")

	elseif self.LastState == 1 then

		//Creates the Crush Effect
		local attach = self:GetAttachment(self:LookupAttachment("input"))

		if attach then
			zrmine.f.ParticleEffect("zrms_crusher_crush", attach.Pos,  attach.Ang, self)
		end

		zrmine.f.EmitSoundENT("zrmine_crush",self)

		timer.Simple(zrmine.config.Crusher_Time / 2, function()
			if IsValid(self) then

				// Creates the dust effect
				zrmine.f.ParticleEffect("zrms_refiner_refine", self:GetPos() + self:GetForward() * -30 + self:GetUp() * 15, self:GetAngles(), self)
			end
		end)
	end
end

function ENT:AnimationHandler()
	if self.LastState == 1 then

		if self:GetSequenceName(self:GetSequence()) ~= "crushing" then
			local animSpeed = 2 / zrmine.config.Crusher_Time
			animSpeed = math.Clamp(animSpeed,1,2)

			zrmine.f.Animation(self, "crushing", animSpeed)

			local Belt_speed = animSpeed * 2
			self.ScrollMat:SetFloat("$myspeed", Belt_speed)
		end
	else
		// If the current state is idle and we dont have anything in the storage then we play the idle animation
		if self:ReturnStorage() <= 0 and self:GetSequenceName(self:GetSequence()) ~= "idle" then
			zrmine.f.Animation(self, "idle", 1)

			self.ScrollMat:SetFloat("$myspeed", 0)
		end
	end
end

function ENT:CrushSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_refinery_loop")

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

	if zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		// Returns true after the state changed
		if self:StateChanged() then

			// Handels the effects
			self:EffectsHandler()
		end

		// Handles the animation of the model
		self:AnimationHandler()

		// Handels the Crushing shound
		self:CrushSound()

		// Handels the gravel animation
		zrmine.f.ClientGravelAnim(self)
	end
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:IndicatorLight(id,pos,state)

	local LightPos = self:LocalToWorld(pos)

	local ViewNormal = self:GetPos() - EyePos()
	ViewNormal:Normalize()

	if self.PixelVisibleHandles == nil then
		self.PixelVisibleHandles = {}
	end

	//Create PixelVisibleHandle if nil
	if self.PixelVisibleHandles[id] == nil then
		self.PixelVisibleHandles[id] = {
			handle = util.GetPixelVisibleHandle(),
			IsVisible = 0,
		}
	end

	self.PixelVisibleHandles[id].IsVisible = util.PixelVisible(LightPos, 3,self.PixelVisibleHandles[id].handle)

	if self.PixelVisibleHandles[id].IsVisible and self.PixelVisibleHandles[id].IsVisible > 0.1 then
		local spriteColor = zrmine.default_colors["red03"]
		if state then
			spriteColor = zrmine.default_colors["green02"]
		end

		render.SetMaterial(zrmine.default_materials["light_ignorez"])
		render.DrawSprite(LightPos, 25, 25, spriteColor)
	end
end

// The Info screen
local offsetX, offsetY = 55, 18
function ENT:DrawResourceItem(OreType, xpos, ypos, size)
	local color = zrmine.f.GetOreColor(OreType)

	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)

	draw.DrawText(": " .. math.Round(zrmine.f.GetOreFromEnt(self,OreType)) .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font3", xpos + offsetX + 30, ypos + offsetY + size * 0.25, color, TEXT_ALIGN_LEFT)
end

function ENT:DrawInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(15,0,56.4)), self:LocalToWorldAngles(Angle(0,90,90)), 0.1)
		draw.RoundedBox(0, -105, -65, 210, 130, zrmine.default_colors["grey02"])
		local aBar = (100 / zrmine.config.Crusher_Capacity) * self:ReturnStorage()

		if (aBar > 100) then
			aBar = 100
		end
		draw.RoundedBox(0, -87, 50, 30,-aBar, zrmine.default_colors["brown01"])


		self:DrawResourceItem("Coal", -105, -75, 30)
		self:DrawResourceItem("Iron", -105, -55, 30)
		self:DrawResourceItem("Bronze", -105, -35, 30)
		self:DrawResourceItem("Silver", -105, -15, 30)
		self:DrawResourceItem("Gold", -105, 5, 30)

		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["Scale"])
		surface.DrawTexturedRect(-110, -53, 75, 105)
	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if (zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300)) then

		self:DrawInfo()

		if GetConVar("zrms_cl_lightsprites"):GetInt() == 1 then
			self:IndicatorLight("Default",Vector(-19,0,42),IsValid(self:GetModuleChild()))
		end
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end

	zrmine.f.RemoveClientGravel(self)
end
