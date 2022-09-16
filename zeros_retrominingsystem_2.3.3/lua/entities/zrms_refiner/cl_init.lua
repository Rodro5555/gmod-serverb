include("shared.lua")

function ENT:Initialize()
	self:Setup_Conveyorbelt_Material()
	self:Setup_PaintLack_Material()

	self.InsertEffect = ParticleEmitter(self:GetPos())

	zrmine.f.EntList_Add(self)

	// Sets up stuff for the client gravel animation
	zrmine.f.Gravel_Initialize(self)

	// The refined gravel animation cycle
	self.rg_cycle = 0

	self.State = -1

	self.RefineStart = -1
end

// Animated Belt
function ENT:Setup_Conveyorbelt_Material()
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

	self.ScrollMat = CreateMaterial("Refiner_ScrollMat" .. self:EntIndex(), "VertexLitGeneric", params)
	self:SetSubMaterial(1, "!Refiner_ScrollMat" .. self:EntIndex())
end

// Color painted Lack
function ENT:Setup_PaintLack_Material()
	local paintColor = zrmine.f.ColorToVector(zrmine.f.GetOreColor(self.RefinerType))

	local params = {
		["$basetexture"] = "zerochain/props_mining/refinery/zrms_refiner_diff",
		["$color2"] = paintColor,
		["$blendTintByBaseAlpha"] = 1,
		["$blendTintColorOverBase"] = 0,
		["$bumpMap"] = "zerochain/props_mining/refinery/zrms_refiner_nrm",
		["$normalmapalphaenvmapmask"] = 1,
		["$surfaceprop"] = "metal",
		["$halflambert"] = 1,
		["$model"] = 1,
		["$envmap"] = "env_cubemap",
		["$envmaptint"] = paintColor,
		["$envmapfresnel"] = 1,
		["$phong"] = 1,
		["$phongexponenttexture"] = "zerochain/props_mining/refinery/zrms_refiner_phong",
		["$phongtint"] = paintColor,
		["$phongboost"] = 15,
		["$phongfresnelranges"] = Vector(0.05, 0.5, 1)
	}

	self.PaintMat = CreateMaterial("RefinerPaint" .. self:EntIndex(), "VertexLitGeneric", params)
	self.PaintMat:SetVector("$color2", paintColor)
	self.PaintMat:SetFloat("$blendTintColorOverBase", 0.1)
	self:SetSubMaterial(5, "!RefinerPaint" .. self:EntIndex())
end


function ENT:UpdateState()
	local CurrentState = self:GetCurrentState()

	if self.State ~= CurrentState then
		self.State = CurrentState

		if CurrentState == 2 then

			self.ScrollMat:SetFloat("$myspeed", 2)

			self.RefineStart = CurTime()

			//Plays the crush sound
			zrmine.f.EmitSoundENT("zrmine_crush",self)

			//Plays the REFINING animation
			if self:GetSequenceName(self:GetSequence()) ~= "refine" then

				local animSpeed = 2 / self.RefiningTime
				animSpeed = math.Clamp(animSpeed,1,2)

				zrmine.f.Animation(self, "refine", animSpeed)
			end
		elseif CurrentState == 1 then

			self.ScrollMat:SetFloat("$myspeed", 2)

			zrmine.f.EmitSoundENT("zrmine_crush",self)
		else

			self.RefineStart = -1

			self.ScrollMat:SetFloat("$myspeed", 0)

			if self:GetSequenceName(self:GetSequence()) ~= "idle" then
				zrmine.f.Animation(self, "idle", 1)
			end
		end
	end
end

function ENT:RefineSound()
	local MoveSound = CreateSound(self, "zrmine_sfx_refinery_loop")

	if self.State == 2 then
		if self.SoundObj == nil then
			self.SoundObj = MoveSound
		end

		if self.SoundObj:IsPlaying() == false then
			//self:EmitSound("zms_drill_start")
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
		self:UpdateState()

		self:RefineSound()

		// Handels the gravel animation
		zrmine.f.ClientGravelAnim(self)

		// Handels the refine gravel anim
		self:ClientRefinedGravelAnim()
	end
	self:SetNextClientThink(CurTime())
	return true
end





// 2D Light Sprites
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

function ENT:Draw()
	self:DrawModel()

	zrmine.f.UpdateEntityVisuals(self)

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then

		if GetConVar("zrms_cl_lightsprites"):GetInt() == 1 then
			self:IndicatorLight("Refinery",Vector(-21,0,44),IsValid(self:GetModuleChild()))
			self:IndicatorLight("Basket",Vector(0,-15,28),IsValid(self:GetBasket()))
		end

		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end


function ENT:UpdateVisuals()

	if (self:GetSubMaterial(1) ~= "!Refiner_ScrollMat" .. self:EntIndex()) then
		self:SetSubMaterial(1, "!Refiner_ScrollMat" .. self:EntIndex())
	end

	if (self:GetSubMaterial(5) ~= "!RefinerPaint" .. self:EntIndex()) then
		self:SetSubMaterial(5, "!RefinerPaint" .. self:EntIndex())
	end

	// This Sets the belt scroll speed of the mat
	if (self.State == 2 or self.State == 1) then
		self.ScrollMat:SetFloat("$myspeed", 2)
	else
		self.ScrollMat:SetFloat("$myspeed", 0)
	end
end


// UI Stuff
local offsetX, offsetY = 15, 10
function ENT:DrawResourceItem(Info, color, xpos, ypos, size)
	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)

	draw.DrawText(Info, "zrmine_screen_font1", xpos + offsetX + 50, ypos + offsetY + size * 0.22, color, TEXT_ALIGN_LEFT)
end

function ENT:DrawInfo()
	local status = ""
	if (self.State == 2) then
		status = zrmine.language.Refiner_Refining
	elseif (self.State == 0) then
		status = zrmine.language.Refiner_Waiting
	elseif (self.State == 1) then
		status = zrmine.language.Refiner_Moving
	end

	cam.Start3D2D(self:LocalToWorld(Vector(0,-15.4,39.4)), self:LocalToWorldAngles(Angle(0,0,90)), 0.1)
		draw.RoundedBox(0, -105, -65, 210, 130, zrmine.default_colors["grey02"])
		self:Draw_ResourceBar("Coal", 0)
		self:Draw_ResourceBar("Iron", 6)
		self:Draw_ResourceBar("Bronze", 12)
		self:Draw_ResourceBar("Silver", 18)
		self:Draw_ResourceBar("Gold", 24)

		if self.State == 2 then
			local refineTimeEnd = self.RefineStart +  self.RefiningTime
			local barSize = 130 / self.RefiningTime
			barSize = barSize * (refineTimeEnd - CurTime())
			barSize = math.Clamp(barSize,0,130)
			draw.RoundedBox(5, -50, -15, 130, 20, zrmine.default_colors["grey07"])
			draw.RoundedBox(5, -50, -15,barSize, 20, zrmine.default_colors["grey06"])
		end

		draw.DrawText(status, "zrmine_screen_font3", 15, -15,zrmine.default_colors["yellow01"], TEXT_ALIGN_CENTER)

		local amount = zrmine.f.GetOreFromEnt(self,self.RefinerType)

		self:Draw_ResourceAmount(amount,  zrmine.f.GetOreTranslation(self.RefinerType),zrmine.f.GetOreColor(self.RefinerType))
	cam.End3D2D()
end

function ENT:Draw_ResourceAmount(amount, name,OreColor)

	amount = ": " .. math.Round(amount) .. zrmine.config.BuyerNPC_Mass
	self:DrawResourceItem(amount, OreColor, -60, 0, 50)

	draw.DrawText(name, "zrmine_screen_font2", 15, -55, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)

	surface.SetDrawColor(zrmine.default_colors["white02"])
	surface.SetMaterial(zrmine.default_materials["Scale"])
	surface.DrawTexturedRect(-110, -53, 75, 105)
end

function ENT:Draw_ResourceBar(rtype, xOffset)
	local ramount = zrmine.f.GetOreFromEnt(self,rtype)
	local rpaintColor = zrmine.f.GetOreColor(rtype)

	local refCap = zrmine.config.Refiner_Capacity
	local r_Bar = (100 / refCap) * ramount

	if (r_Bar > 100) then
		r_Bar = 100
	end

	draw.RoundedBox(0, -87 + xOffset, 50, 5, -r_Bar, rpaintColor)
end


// Refine Gravel Anim
function ENT:ClientRefinedGravelAnim()
	if self.ClientProps == nil then
		self.ClientProps = {}
	end

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then

		if IsValid(self.ClientProps["RefineGravel"]) then

			// The requested animation type aka skin
			local r_type = self:GetRefineAnim_Type()

			if r_type == -1 then
				self.ClientProps["RefineGravel"]:SetNoDraw(true)
				self.rg_cycle = 0
			else

				local speed = 1.5

				self.rg_cycle = math.Clamp(self.rg_cycle + (1 / speed) * FrameTime(), 0, 1)

				if self.rg_cycle >= 1 then

					self.ClientProps["RefineGravel"]:SetNoDraw(true)
				else
					self.ClientProps["RefineGravel"]:SetPos(self:LocalToWorld(Vector(0,5,0)))
					self.ClientProps["RefineGravel"]:SetSkin(r_type)
					self.ClientProps["RefineGravel"]:SetNoDraw(false)

					local sequence = self.ClientProps["RefineGravel"]:LookupSequence("refined")
					self.ClientProps["RefineGravel"]:SetSequence(sequence)
					self.ClientProps["RefineGravel"]:SetPlaybackRate(1)
					self.ClientProps["RefineGravel"]:SetCycle(self.rg_cycle)
				end
			end
		else
			self:CreateClientGravel()
		end
	else

		if IsValid(self.ClientProps["RefineGravel"]) then
			self.ClientProps["RefineGravel"]:Remove()
		end

		self.rg_cycle = 0
	end
end

function ENT:CreateClientGravel()
	local gravel = ents.CreateClientProp()

	gravel:SetPos(self:LocalToWorld(Vector(0,0,0)))
	gravel:SetModel("models/zerochain/props_mining/zrms_refinedgravel01.mdl")
	gravel:SetAngles(self:GetAngles())

	gravel:Spawn()
	gravel:Activate()

	gravel:SetRenderMode(RENDERMODE_NORMAL)
	gravel:SetParent(self)
	gravel:SetNoDraw(true)

	self.ClientProps["RefineGravel"] = gravel
end


function ENT:OnRemove()
	if (self.SoundObj ~= nil and self.SoundObj:IsPlaying()) then
		self.SoundObj:Stop()
	end
end
