-- Model : https://steamcommunity.com/sharedfiles/filedetails/?id=764395035
-- Code by : SlownLS

AddCSLuaFile()

SWEP.Category 				= "SlownLS | Hitman" 
SWEP.PrintName 				= "Binoculars"
SWEP.Instructions 			= ""

SWEP.Spawnable     			= true
SWEP.AdminSpawnable  		= true

SWEP.UseHands				= true
SWEP.ViewModel				= "models/weapons/c_binoculars.mdl"
SWEP.WorldModel				= "models/weapons/w_binocularsbp.mdl"

SWEP.HoldType				= "slam"
SWEP.HoldTypeRaised			= "camera"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo 		= false
SWEP.Secondary.Automatic 	= true

SWEP.strHoldType = "slam"
SWEP.strHoldTypeRaised = "camera"

--[[ Zoom ]]
SWEP.boolZ_InZoom = false
SWEP.boolZ_Zooming = false 

SWEP.intZoom_Interval = 2
SWEP.intZoomDelta = 0.2
SWEP.intZoomMin = 2
SWEP.intZoomMax = 8
SWEP.intZoom = 0

SWEP.strZoomSoundIn = "weapons/sniper/sniper_zoomin.wav"
SWEP.strZoomSoundOut = "weapons/sniper/sniper_zoomout.wav"

--[[ Night Vision ]]
SWEP.boolHasNightVision = false
SWEP.intLastReload = 0

function SWEP:PrimaryAttack()
	if( not self.boolZ_InZoom ) then return end

	if( self.intZoom >= self.intZoomMax ) then
		sound.Play(self.strZoomSoundOut, self.Owner:GetPos())
		self.intZoom = self.intZoomMin
		self.Owner:SetFOV(90 / self.intZoom, self.intZoomDelta)
	elseif( (self.intZoom + self.intZoom_Interval) >= self.intZoomMax ) then
		sound.Play(self.strZoomSoundIn, self.Owner:GetPos())
		self.intZoom = self.intZoomMax
		self.Owner:SetFOV(90 / self.intZoom, self.intZoomDelta)
	else
		sound.Play(self.strZoomSoundIn, self.Owner:GetPos())
		self.intZoom = self.intZoom + self.intZoom_Interval
		self.Owner:SetFOV(90 / self.intZoom, self.intZoomDelta)
	end	
end

function SWEP:SecondaryAttack()

end

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK2) and not self.boolZ_Zooming then
		self:setZoom()
	end
	
	if self.Owner:KeyReleased(IN_ATTACK2) and not self.boolZ_Zooming then
		self:endZoom()
	end
end

function SWEP:setZoom()
	self.boolZ_Zooming = true

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetHoldType(self.strHoldTypeRaised)
	
	local intDuration = self:SequenceDuration()

	timer.Simple(intDuration * 4/5, function()
		if( not IsValid(self) ) then return end
		
		self.boolZ_InZoom = true
		self.intZoom = self.intZoom_Interval

		self.Owner:DrawViewModel(false, 0)
		self.Owner:SetFOV(90 / self.intZoom, self.intZoomDelta)
		self.Owner:SetDSP(30, false)
	end)

	timer.Simple(intDuration, function()
		if( not IsValid(self) ) then return end

		self.boolZ_Zooming = false

		if( not self.Owner:KeyDown(IN_ATTACK2) ) then
			self:endZoom()
		end
	end)	
end

function SWEP:endZoom()
	self.boolZ_Zooming = true
	
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self:SetHoldType(self.strHoldType)

	local intDuration = self:SequenceDuration()

	timer.Simple(intDuration * 1/5, function()
		if( not IsValid(self) ) then return end

		self.boolZ_InZoom = false
		self.intZoom = self.intZoom_Interval
		
		self.Owner:DrawViewModel(true, 0)
		self.Owner:SetFOV(0, self.intZoomDelta)
		self.Owner:SetDSP(0, false)
	end)

	timer.Simple(intDuration, function()
		if( not IsValid(self) ) then return end

		self.boolZ_Zooming = false

		if( self.Owner:KeyDown(IN_ATTACK2) ) then
			self:setZoom()
		end
	end)
end

function SWEP:Holster()
	if( self.boolZ_Zooming ) then return false end

	if( self.boolZ_InZoom) then
		self.Owner:SetFOV(0, self.intZoomDelta)
	end

	self.boolZ_InZoom = false
	self.intZoom = self.intZoomMin
	self.Owner:SetDSP(0, false)
	self.Owner:DrawViewModel(true, 0)

	return true
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())

	self.intZoom = self.intZoomMin
	self.boolZ_InZoom = false
	self.boolZ_Zooming = false

	self:SetHoldType(self.strHoldType)
end

function SWEP:Initialize()
	self.intZoom = self.intZoom_Interval
	self:SetHoldType(self.strHoldType)
end

if( SERVER ) then return end

function SWEP:Reload()
	if( self.intLastReload and self.intLastReload > CurTime() ) then return end

	self.boolHasNightVision = not self.boolHasNightVision

	self.intLastReload = CurTime() + .4
end

local intLerpDistance = 0 
local tblTarget = {}

local intLastDelay = 0
local boolFinded = false

local mat_bino_overlay = Material("vgui/hud/rpw_binoculars_overlay")
local mat_color = Material("pp/colour")
local mat_noise = Material("vgui/hud/nvg_noise")

function SWEP:drawOverlay(w, h)
	local boolNightVision = self.boolHasNightVision

	if (boolNightVision) then
		render.UpdateScreenEffectTexture()
		
		mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

		mat_color:SetFloat( "$pp_colour_addr", -1 )
		mat_color:SetFloat( "$pp_colour_addg", 0 )
		mat_color:SetFloat( "$pp_colour_addb", -1 )
		mat_color:SetFloat( "$pp_colour_mulr", 0 )
		mat_color:SetFloat( "$pp_colour_mulg", 0 )
		mat_color:SetFloat( "$pp_colour_mulb", 0 )
		mat_color:SetFloat( "$pp_colour_colour", 1 )
		mat_color:SetFloat( "$pp_colour_contrast", 1 )
		mat_color:SetFloat( "$pp_colour_brightness", 0.01 )

		render.SetMaterial(mat_color)
		render.DrawScreenQuad()
		
		surface.SetMaterial(mat_noise)
		surface.SetDrawColor(0, 255, 0, 100)
		surface.DrawTexturedRect(0 + math.Rand(-128,128), 0+math.Rand(-128,128), w, h)
		
		surface.SetMaterial(mat_noise)
		surface.SetDrawColor(0, 255, 0, 100)
		surface.DrawTexturedRect(0 + math.Rand(-64,64), 0+math.Rand(-64,64), w, h)
	end

	surface.SetMaterial(mat_bino_overlay)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(0, - (w - h) / 2, w , w)
	
	if (boolNightVision) then
		DrawBloom(0.5,1,10,10,2,1,1,1,1)
	end
end

function SWEP:drawInfos(tr, w, h)
	local range = (math.ceil(100 * (tr.StartPos:Distance(tr.HitPos) * 0.024)) / 100)
	
	if tr.HitSky then
		strRange = "-"
	else
		strRange = range .. "m"
	end

	local x = (w * 0.15)

	-- Target
	local pTarget = tr.Entity
	local strInfo = "CIBLE INCONNU"

	LocalPlayer().SlownLS_Hitman_Target = LocalPlayer().SlownLS_Hitman_Target or "???"
	LocalPlayer().SlownLS_Hitman_Percent = LocalPlayer().SlownLS_Hitman_Percent or 0
	LocalPlayer().SlownLS_Hitman_Info = LocalPlayer().SlownLS_Hitman_Info or "???"

	if( pTarget and IsValid(pTarget) and pTarget:IsPlayer() ) then
		if( pTarget != LocalPlayer().SlownLS_Hitman_Target ) then
			LocalPlayer().SlownLS_Hitman_Target = pTarget
			LocalPlayer().SlownLS_Hitman_Percent = 0
			LocalPlayer().SlownLS_Hitman_Info = SlownLS.Hitman:getLanguage("targetUnknown")
			boolFinded = false
		end

		if( LocalPlayer().SlownLS_Hitman_Percent < 100 ) then
			LocalPlayer().SlownLS_Hitman_Percent = LocalPlayer().SlownLS_Hitman_Percent + 0.8
			
			if( LocalPlayer().SlownLS_Hitman_Percent >= 100 ) then
				LocalPlayer().SlownLS_Hitman_Percent = 100
				LocalPlayer():EmitSound("UI/buttonclick.wav", 0, 200)

				if( SlownLS.Hitman.CurrentContract and SlownLS.Hitman.CurrentContract.victim == pTarget and not boolFinded ) then
					LocalPlayer().SlownLS_Hitman_Info = SlownLS.Hitman:getLanguage("targetLocked")
					boolFinded = true 
				else
					LocalPlayer().SlownLS_Hitman_Info = SlownLS.Hitman:getLanguage("targetUnknown")
				end
			end
		end
	else
		LocalPlayer().SlownLS_Hitman_Target = nil 

		if( LocalPlayer().SlownLS_Hitman_Percent > 0 and LocalPlayer().SlownLS_Hitman_Percent <= 100 ) then
			LocalPlayer().SlownLS_Hitman_Percent = LocalPlayer().SlownLS_Hitman_Percent - 1

			if LocalPlayer().SlownLS_Hitman_Percent < 0 then
				LocalPlayer().SlownLS_Hitman_Percent = 0
			end

			LocalPlayer().SlownLS_Hitman_Info = SlownLS.Hitman:getLanguage("targetUnknown")
		end
	end

	draw.SimpleText(SlownLS.Hitman:getLanguage("target") .. ": " .. math.Clamp(math.Round(LocalPlayer().SlownLS_Hitman_Percent), 0, 100) .. "%", "SlownLS:Hitman:24", x, h / 2 - 30, color_white, 0, 1)

	draw.SimpleText(SlownLS.Hitman:getLanguage("info") .. ": " .. LocalPlayer().SlownLS_Hitman_Info, "SlownLS:Hitman:24", x, h / 2, color_white, 0, 1)


	local intOffset = 70
	local intZoom = math.ceil(90/self.Owner:GetFOV())
	
	draw.SimpleText("[LEFT CLICK] ZOOM : " .. intZoom .. "x", "SlownLS:Hitman:24", x, h / 2 + intOffset, color_white, 0, 1)
	draw.SimpleText("[RELOAD] " .. SlownLS.Hitman:getLanguage("night_vision"), "SlownLS:Hitman:24", x, h / 2 + intOffset + 30, color_white, 0, 1)
end

function SWEP:drawBar(tr, w, h)
	local range = (math.ceil(100 * (tr.StartPos:Distance(tr.HitPos) * 0.024)) / 100)
	
	if tr.HitSky then
		range = 0
	end

	local intHBar = 200
	local intXBar = w - (w * 0.15)
	local intYBar = h / 2 - intHBar / 2
	local intYBarMax = intYBar - intHBar
	local intVBarMax = intHBar

	local intY = intYBarMax / intVBarMax * range

	intY = math.Clamp(intY, 0, intVBarMax)

	local intYFinal = intYBar + intHBar - intY 

	intLerpDistance = Lerp(FrameTime() * 5, intLerpDistance, intYFinal)

	surface.SetDrawColor(color_white)
	surface.DrawRect(intXBar, intYBar, 1, intHBar)

	local intCurrentW =  20
	local intCurrentX = intXBar - intCurrentW

	surface.DrawRect(intCurrentX, intLerpDistance, intCurrentW, 1)

	draw.SimpleText(strRange, "SlownLS:Hitman:16", intCurrentX - 5, intLerpDistance - 10, color_white, 2, 0)

	for i = 0, intHBar, 10 do
		local w = 10

		if( i == 0 or i == intHBar ) then
			w = 20
		end

		local x = intXBar - w
		local y = intYBar + i

		surface.DrawRect(x, y, w, 1)
	end 	

	-- Cursor
	surface.SetDrawColor(SlownLS.Hitman:getColor('red'))

	surface.DrawRect(ScrW() / 2 - 5, ScrH() / 2 - 1, 10, 2) 
	surface.DrawRect(ScrW() / 2 - 1, ScrH() / 2 - 5, 2, 10) 
end

function SWEP:DrawHUD()
	if( not self.boolZ_InZoom ) then return end

	local w = ScrW()
	local h = ScrH()
	local tr = self.Owner:GetEyeTrace()

	self:drawOverlay(w, h)
	self:drawInfos(tr, w, h)
	self:drawBar(tr, w, h)
end

function SWEP:AdjustMouseSensitivity()
	if (self.boolZ_InZoom) then
		local zoom = 90 / self.Owner:GetFOV()
		local adjustedsens = 1 / zoom
		return adjustedsens
	end
end

hook.Add("PreDrawHalos", "SlownLS:Hitman:Halos", function()
	if( not LocalPlayer().SlownLS_Hitman_Target ) then return end
	if( isstring(LocalPlayer().SlownLS_Hitman_Target) ) then return end
	if( not IsValid(LocalPlayer().SlownLS_Hitman_Target) ) then return end
	if( not LocalPlayer().SlownLS_Hitman_Percent or LocalPlayer().SlownLS_Hitman_Percent < 100 ) then return end
	if( not boolFinded ) then return end

	halo.Add({LocalPlayer().SlownLS_Hitman_Target}, Color( 255, 0, 0 ), 2, 2, 2)
end)