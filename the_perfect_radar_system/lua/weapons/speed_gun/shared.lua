SWEP.Author 			= "Diablos"
SWEP.Base				= "weapon_base"
SWEP.Contact 			= "gmodstore.com/users/view/76561197989318156"
SWEP.PrintName 			= Diablos.RS.Strings.speedgunname
SWEP.Category 			= "Diablos Addon"
SWEP.Instructions 		= Diablos.RS.Strings.speedguninstructions
SWEP.Purpose 			= ""
SWEP.Spawnable 			= true
SWEP.DrawCrosshair 		= false
SWEP.DrawAmmo 			= false
SWEP.Weight 			= 0
SWEP.SlotPos 			= 2
SWEP.Slot 				= 4
SWEP.NextAttack			= 0
SWEP.Primary.Cone		= 0.02	
--------------------------------------------------------------------------------|
SWEP.Primary.Ammo         		= "none"
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Delay 				= 1
SWEP.Primary.Automatic   		= false							
--------------------------------------------------------------------------------|
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
--------------------------------------------------------------------------------|

SWEP.HoldType = "pistol"
SWEP.UseHands = true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_speedgun.mdl"
SWEP.WorldModel = "models/weapons/w_speedgun.mdl"
SWEP.IronSightsPos = Vector(-6.85, -13.9, 3.96)
SWEP.IronSightsAng = Vector(0.5, -2, 0)

SWEP.WElements = {
	["speedgun"] = { type = "Model", model = "models/weapons/w_speedgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4, 1.2, -2.201), angle = Angle(0, 0, -174.157), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

--------------------------------------------------------------------------------|

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Ironsights")
end

function SWEP:Initialize()
	self:SetIronsights(false)
	self:SetWeaponHoldType(self.HoldType)
	
	if IsValid(self.Owner) then
		self.VM = self.Owner:GetViewModel()
		if IsValid(self.VM) then
			self.AttachLight01 = self.VM:LookupAttachment("attachement_light_01")
			self.AttachLight02 = self.VM:LookupAttachment("attachement_light_02")
		end
	end

	local curtime = CurTime()
	self.BeepSound, self.SpeedingSound, self.LastCaught, self.Refresh = curtime, curtime, curtime, curtime
	self.LastVeh = nil
	self.Veh = nil
	

	if CLIENT then
	
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)
		
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)

				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end
end
function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end
function SWEP:OnRemove()
	self:Holster()
end
if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)
		if (!self.vRenderOrder) then

			self.vRenderOrder = {}
			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				end
			end
			
		end
		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			end
		end
	end
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then
			self.wRenderOrder = {}
			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				end
			end
		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			end
			
		end
		
	end
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)
			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		
		end
		
		return pos, ang
	end
	function SWEP:CreateModels( tab )
		if (!tab) then return end
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end

			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end

				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	function table.FullCopy( tab )
		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		return res
	end
end

-- [[ End of the special code ]] --

local reddot, excessivespeed, normalspeed = Material("tprsa/red_dot.png"), Material("tprsa/excessivespeed.png"), Material("tprsa/normalspeed.png")
local colors = {
	r = Color(255, 60, 60, 255),
	r2 = Color(255, 0, 0, 255),
	r3 = Color(255, 0, 0, 20),
	g = Color(60, 255, 60, 255),
	w = Color(255, 255, 255, 255),
}


sound.Add({name = "TPRSABeepSound", channel = CHAN_STATIC, volume = 1.0, level = 80, pitch = 100, sound = "tprsa/beep.mp3"})
sound.Add({name = "TPRSASpeedingSound", channel = CHAN_STATIC, volume = 1.0, level = 80, pitch = 100, sound = "tprsa/speeding.mp3"})

function SWEP:PrimaryAttack() end

function SWEP:Deploy()
	if IsValid(self.Owner) then
		self.VM = self.Owner:GetViewModel()
		if IsValid(self.VM) then
			self.AttachLight01 = self.VM:LookupAttachment("attachement_light_01")
			self.AttachLight02 = self.VM:LookupAttachment("attachement_light_02")
		end
	end
end

local function DrawCircleButtons(x, y, radius, seg)
	local cir = {}

	table.insert(cir, { x = x, y = y, u = 0.5, v = 0.5 })
	for i = 0, seg do
		local a = math.rad(( i / seg ) * -360)
		table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0)
	table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	surface.DrawPoly(cir)
end

function SWEP:GenerateBeepSound(timeloop)
	if self.BeepSound + timeloop < CurTime() then
		self.Owner:EmitSound("TPRSABeepSound")
		self.BeepSound = CurTime()
	end
end

function SWEP:GenerateSpeedingSound()
	if self.BeepSound + 2 < CurTime() then
		self.Owner:EmitSound("TPRSASpeedingSound")
		self.SpeedingSound = CurTime()
	end
end

function SWEP:GetViewModelPosition(pos, ang)
	pos = pos + ang:Forward() * -1.5 - ang:Up()
	if !self.IronSightsPos then return pos, ang end
	local lastironsighttime = self.lastironsighttime or 0
	if lastironsighttime + .06 > RealTime() then return pos, ang end

	local ironsightstate = self:GetIronsights()
	
	local transition = math.Clamp((RealTime() - lastironsighttime) / .4, 0, 1)
	if not ironsightstate then transition = 1 - transition end

	if self.IronSightsAng then
		local irang = self.IronSightsAng
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), irang.x * transition)
		ang:RotateAroundAxis(ang:Up(), irang.y * transition)
		ang:RotateAroundAxis(ang:Forward(), irang.z * transition)
	end
	
	local offset = self.IronSightsPos

	local angright, angup, angforward = ang:Right(), ang:Up(), ang:Forward()

	pos = pos + offset.x * angright * transition + offset.y * angforward * transition + offset.z * angup * transition

	return pos, ang
end

function SWEP:SecondaryAttack()
	if !self.IronSightsPos then return end
	if self.NextAttack > CurTime() then return end
	if not IsFirstTimePredicted() then return end

	self:SetIronsights(!self:GetIronsights())
	local ironsightstate = self:GetIronsights()

	if ironsightstate != self.lastironsight then
		self.lastironsight = ironsightstate
		self.lastironsighttime = RealTime()
		
		if ironsightstate then
			self.SwayScale 	= 0.07
			self.BobScale 	= 0.07
		else
			self.SwayScale 	= 1
			self.BobScale 	= 1
		end
	end

	self.NextAttack = CurTime() + .5
end

function SWEP:OnRestore() self.NextAttack = 0 self:SetIronsights(false) end

local light_01_pos = Vector(1.6, -3.7, -3.9)
local light_02_pos = Vector(1.4, -0.8, -3.85)
local angle_null = Angle(0, 0, 0)

local plyval = 0
net.Receive("TPRSA:PersSpeed", function(len, ply)
	plyval = net.ReadUInt(8)
end)

function SWEP:PostDrawViewModel(viewmodel, weapon, ply)
	if self.Owner:InVehicle() then return end
	local speedtoshow = self.Speed
	local speedlim = Diablos.RS.SpeedLimit
	if plyval > 0 then speedlim = plyval end
	if not viewmodel:LookupBone("ValveBiped.bip01_R_Hand") then return end
	local pos_b, ang_b = viewmodel:GetBonePosition(viewmodel:LookupBone("ValveBiped.bip01_R_Hand"))
	local light_01 = LocalToWorld(light_01_pos, angle_null, pos_b, ang_b)
	local light_02 = LocalToWorld(light_02_pos, angle_null, pos_b, ang_b)
	local light1, light2 = light_01:ToScreen(), light_02:ToScreen()
	local lightdiff = light2.x - light1.x
	local Scrw, Scrh = ScrW() / 2, ScrH() / 2
	local color = colors.r2
	if self.BeepSound + 1 <= CurTime() then color = colors.r3 end
	cam.Start2D()
		if self:GetIronsights() and self.NextAttack - .2 <= CurTime() then
			if Scrw <= 640 then surface.SetFont("DiablosRSClientHUDBigFont2") else surface.SetFont("DiablosRSClientHUDBigFont1") end
			
			if self.NextAttack <= CurTime() then
				surface.SetDrawColor(colors.w)
				surface.SetMaterial(reddot)
				surface.DrawTexturedRect(Scrw - 90, Scrh - 90, 180, 180)
			end

			surface.SetDrawColor(color)
			draw.NoTexture()
			DrawCircleButtons(light1.x + 5, light1.y + 9, 30, 50)
			DrawCircleButtons(light2.x + 5, light2.y + 5, 30, 50)

			local veh = self.Veh
			if not veh then
				local text1, text2
				if veh == false then
					text1, text2 = Diablos.RS.Strings.governement, Diablos.RS.Strings.vehicle
				else
					text1, text2 = Diablos.RS.Strings.notarget, Diablos.RS.Strings.found
				end
				surface.SetTextColor(colors.w)
				local x1 = surface.GetTextSize(text1)
				surface.SetTextPos(light1.x + lightdiff * .5 - x1 / 2, light1.y - light1.y * .15)
				surface.DrawText(text1)
				local x2 = surface.GetTextSize(text2)
				surface.SetTextPos(light1.x + lightdiff * .5 - x2 / 2, light1.y - light1.y * .04)
				surface.DrawText(text2)

				self:GenerateBeepSound(2)
				return
			end

			if speedtoshow > speedlim then 
				color = colors.r
				surface.SetDrawColor(colors.w)
				surface.SetMaterial(excessivespeed)
				surface.DrawTexturedRect(light1.x + lightdiff * .68, light1.y - light1.y * .06, 70, 70)
			else 
				color = colors.g
				surface.SetDrawColor(colors.w)
				surface.SetMaterial(normalspeed)
				surface.DrawTexturedRect(light1.x + lightdiff * .68, light1.y - light1.y * .18, 70, 70)
			end

			local mphkmh if Diablos.RS.MPHCounter then mphkmh = "MPH" else mphkmh = "KMH" end

			if Scrw <= 640 then surface.SetFont("DiablosRSClientHUDBigFont2") else surface.SetFont("DiablosRSClientHUDBigFont1") end
			surface.SetTextColor(colors.w)
			surface.SetTextPos(light1.x + lightdiff * .2, light1.y - light1.y * .16)
			surface.DrawText(Diablos.RS.Strings.speed .. ":")
			surface.SetTextPos(light1.x + lightdiff * .4, light1.y - light1.y * .015)
			surface.DrawText(mphkmh)

			if Scrw <= 640 then surface.SetFont("DiablosRSClientHUDBiggerFont2") else surface.SetFont("DiablosRSClientHUDBiggerFont1") end
			if speedtoshow > speedlim then
				surface.SetTextColor(colors.r)
				self:GenerateBeepSound(.2)
				self:GenerateSpeedingSound()
			else
				surface.SetTextColor(colors.g)
				self:GenerateBeepSound(2)
			end
			surface.SetTextPos(light1.x + lightdiff * .19, light1.y - light1.y * .07)
			if speedtoshow < 10 then
				surface.DrawText("0" .. speedtoshow)
			else
				surface.DrawText(speedtoshow)
			end	
    	elseif not self:GetIronsights() then
    		if Scrw <= 640 then surface.SetFont("DiablosRSClientHUDLittleFont2") else surface.SetFont("DiablosRSClientHUDLittleFont1") end
			surface.SetTextColor(colors.w)
			local x1 = surface.GetTextSize(Diablos.RS.Strings.notarget)
			surface.SetTextPos(light1.x + lightdiff * .5 - x1 / 2, light1.y - light1.y * .045)
			surface.DrawText(Diablos.RS.Strings.notarget)
			local x2 = surface.GetTextSize(Diablos.RS.Strings.found)
			surface.SetTextPos(light1.x + lightdiff * .5 - x2 / 2, light1.y - light1.y * .017)
			surface.DrawText(Diablos.RS.Strings.found)
			surface.SetDrawColor(color)
			draw.NoTexture()
			DrawCircleButtons(light1.x, light1.y + 3, 8, 30)
			DrawCircleButtons(light2.x + 4, light2.y + 2, 8, 30)
			self:GenerateBeepSound(2)
		end
	cam.End2D()
end

function SWEP:Think()
	if self.Refresh + 1 < CurTime() then
		self:PutVehicleSpeed()
	end
	self:NextThink(CurTime())
	return true
end

function SWEP:PutVehicleSpeed()
	if not self:GetIronsights() then self.Veh = nil self.Speed = 0 return end
	local ply = self.Owner
	local veh
	
	if self.Veh and IsValid(self.Veh) and self.Veh:GetPos():DistToSqr(ply:GetEyeTrace().HitPos) <= 3000 then
		veh = self.Veh
	else
		local traceline = util.TraceLine(util.GetPlayerTrace(ply))
		if IsValid(traceline.Entity) and traceline.Entity:IsVehicle() then
			veh = traceline.Entity
		end
	end

	if not veh then self.Veh = nil self.Speed = 0 return end

	if Diablos.RS.GovernementVehicles[veh:GetVehicleClass()] then self.Veh = false self.Speed = 0 return end

	local speed
	if Diablos.RS.MPHCounter then
		speed = math.floor(veh:GetVelocity():Length() * 0.0568188)
	else
		speed = math.floor(veh:GetVelocity():Length() * 0.09144)
	end

	if not speed then self.Veh = nil self.Speed = 0 return end

	self.Veh = veh
	self.Speed = speed
	self.Refresh = CurTime() -- this value allows the fact of taking a bit of time to refresh the speedgun visual content.

	if SERVER then Diablos.RS.RadarGun(self) end
end