include("shared.lua")


function ENT:Initialize()

	self.mainColor = HSVToColor(math.random(0, 360), 0.5, 0.5)
	ZRMS_SHAFTS[self:EntIndex()] = self

	self.OwnerName = ""
	timer.Simple(1,function()
		if IsValid(self) then
			local owner = zrmine.f.GetOwner(self)
			if (IsValid(owner)) then
				self.OwnerName = owner:Nick()
			end
		end
	end)
end


// UI STUFF
function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 600) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawInfo()
	local title = ""

	if (zrmine.config.Mine_CustomName) then
		title = zrmine.config.Mine_CustomName
	else
		title = self.OwnerName or ""
	end

	local info
	local cState = self:GetCurrentState()

	if (cState == 4) then
		info = zrmine.language.Mine_Mining
	elseif (cState == 1) then
		info = zrmine.language.Mine_Ready
	else
		info = zrmine.language.Mine_Wait
	end

	local rtype = self:GetMineResourceType()
	local rColor = zrmine.f.GetOreColor(rtype)


	cam.Start3D2D(self:LocalToWorld(Vector(50,0,56)), self:LocalToWorldAngles(Angle(0,90,90)), 0.07)
		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["MineBgIcon"])
		surface.DrawTexturedRect(-425, -51, 850, 160)

		draw.RoundedBox(5, -425, -51, 850, 160, zrmine.default_colors["black03"])
		draw.RoundedBox(0, -250, 65, 550, 12, zrmine.default_colors["black04"])

		if (cState == 0) then
			draw.DrawText(zrmine.language.Mine_SearchOre, "zrmine_mineentrance_font2", 0, 10, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
		else
			draw.DrawText(info, "zrmine_mineentrance_font2", 0, -15, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
			local startMineTime = self:GetStartMinningTime()
			local mineTime = self:GetMinningTime() + 5
			local moveStep
			startMineTime = (startMineTime + mineTime) - CurTime()
			local cartIcon = zrmine.default_materials["Minecart"]

			if (startMineTime > mineTime / 2) then
				moveStep = -750 + (1000 / mineTime) * startMineTime
				cartIcon = zrmine.default_materials["Minecart"]
			elseif (startMineTime > 0) then
				moveStep = 250 + (-1000 / mineTime) * startMineTime
				cartIcon = zrmine.default_materials["MinecartFull"]
			else
				moveStep = 250
			end

			draw.RoundedBox(0, -250, 75, 550, 5, zrmine.default_colors["grey03"])

			surface.SetDrawColor(zrmine.default_colors["white02"])
			surface.SetMaterial(zrmine.default_materials["MineIcon"])
			surface.DrawTexturedRect(250, -21, 110, 110)

			if (mineTime - 5 > 0) then
				surface.SetDrawColor(zrmine.default_colors["white02"])
				surface.SetMaterial(cartIcon)
				surface.DrawTexturedRect(moveStep, 32, 50, 50)
			end
		end

		if (rtype ~= "Nothing") then
			surface.SetDrawColor(rColor)
			surface.SetMaterial(zrmine.default_materials["Ore"])
			surface.DrawTexturedRect(-400, -70, 200, 200)

			if (rtype == "Random") then
				draw.DrawText("?", "zrmine_mineentrance_font3", -300, -15, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
			end
		end
	cam.End3D2D()

	cam.Start3D2D(self:LocalToWorld(Vector(55,0,56)), self:LocalToWorldAngles(Angle(0,90,90)), 0.08)
		draw.RoundedBox(0, -340, -190, 680, 120, self.mainColor)

		surface.SetDrawColor(zrmine.default_colors["grey04"])
		surface.SetMaterial(zrmine.default_materials["MineSignIcon"])
		surface.DrawTexturedRect(-360, -205, 720, 160)

		draw.DrawText(title .. "´s Mine", "zrmine_mineentrance_font1", 0, -150, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:CreateClientSideModel()
	self.csModel = ClientsideModel("models/zerochain/props_mining/mining_tunnel.mdl")

	if (IsValid(self.csModel) and IsValid(self)) then
		self.csModel:SetPos(self:GetPos())
		self.csModel:SetAngles(self:GetAngles())
		self.csModel:SetParent(self)
		self.csModel:SetNoDraw(true)
	end
end

function ENT:CreateCart()
	self.csCartModel = ClientsideModel("models/Zerochain/props_mining/me_cart.mdl")

	if (IsValid(self) and IsValid(self.csCartModel) ) then
		local attachID = self:LookupAttachment("cart")

		if (attachID == 1) then
			self.csCartModel:SetPos(self:GetAttachment(attachID).Pos)
			local ang = self:GetAttachment(attachID).Ang
			ang:RotateAroundAxis(self:GetAttachment(attachID).Ang:Up(), 90)
			self.csCartModel:SetAngles(ang)
			self.csCartModel:SetParent(self, attachID)
			self.csCartModel:SetNoDraw(true)
		end
	end
end

function ENT:Think()
	if zrmine.f.InDistance(self:GetPos(), LocalPlayer():GetPos(), 1000) then
		if (IsValid(self.csModel)) then
			self.csModel:SetPos(self:GetPos())
			self.csModel:SetAngles(self:GetAngles())
		else
			self:CreateClientSideModel()
		end


		if (IsValid(self.csCartModel)) then
			local attachID = self:LookupAttachment("cart")

			if (attachID == 1) then
				self.csCartModel:SetPos(self:GetAttachment(attachID).Pos)
				local ang = self:GetAttachment(attachID).Ang
				ang:RotateAroundAxis(self:GetAttachment(attachID).Ang:Up(), 90)
				self.csCartModel:SetAngles(ang)
			end
		else
			self:CreateCart()
		end
	end

	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	if IsValid(self.csModel) then
		self.csModel:Remove()
	end

	if IsValid(self.csCartModel) then
		self.csCartModel:Remove()
	end
end
