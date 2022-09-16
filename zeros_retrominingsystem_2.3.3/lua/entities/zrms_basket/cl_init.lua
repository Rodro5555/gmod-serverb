include("shared.lua")

function ENT:Initialize()
	self.InsertEffect = ParticleEmitter(self:GetPos())
	self.LastStorage = 0

	timer.Simple(0.25,function()
		if IsValid(self) then self.Initialized = true end
	end)
end

function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 200) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

// UI STUFF
function ENT:DrawInfo()
	local Pos = self:GetPos() + Vector(0, 0, 20)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	local amount = math.Round(self:GetResourceAmount(), 2)
	local Text = math.Round(amount) .. zrmine.config.BuyerNPC_Mass

	local rtype = self:GetResourceType()

	if (amount >= zrmine.config.ResourceCrates_Capacity) then
		info = "- " .. zrmine.language.Basket_Full .. " -"
	end

	local size = 200
	local cSize = math.Round(200 / zrmine.config.ResourceCrates_Capacity)
	cSize = math.Round(cSize * amount)

	if (amount > 0) then
		cam.Start3D2D(Pos, Ang, 0.1)
			surface.SetDrawColor(zrmine.default_colors["white01"])
			surface.SetMaterial(zrmine.default_materials["Circle"])
			surface.DrawTexturedRect(-100, -100, size, size)

			if (amount >= zrmine.config.ResourceCrates_Capacity) then
				surface.SetDrawColor(zrmine.default_colors["red01"])
				surface.SetMaterial(zrmine.default_materials["Circle"])
				surface.DrawTexturedRect((-cSize - cSize * 0.1) / 2, (-cSize - cSize * 0.1) / 2, cSize + cSize * 0.1, cSize + cSize * 0.1)
			end

			surface.SetDrawColor(zrmine.f.GetOreColor(rtype))
			surface.SetMaterial(zrmine.default_materials["Circle"])
			surface.DrawTexturedRect(-cSize / 2, -cSize / 2, cSize, cSize)

			draw.DrawText(zrmine.f.GetOreTranslation(rtype), "zrmine_resource_font1", 0, -50, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
			draw.DrawText(Text, "zrmine_resource_font1", 0, 0, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end



local basket_skins = {
	["Empty"] = function(x)
		x:SetSkin(0)
	end,
	["Iron"] = function(x)
		x:SetSkin(1)
	end,
	["Bronze"] = function(x)
		x:SetSkin(2)
	end,
	["Silver"] = function(x)
		x:SetSkin(3)
	end,
	["Gold"] = function(x)
		x:SetSkin(4)
	end,
	["Coal"] = function(x)
		x:SetSkin(5)
	end
}

function ENT:Think()
	if self.Initialized == true and zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then
		local r_amount = self:GetResourceAmount()

		if self.LastStorage ~= r_amount then
			self.LastStorage = r_amount
			local r_type = self:GetResourceType()
			basket_skins[r_type](self)

			if (r_amount >= zrmine.config.ResourceCrates_Capacity) then
				self:SetBodygroup(0, 3)
			elseif (r_amount >= zrmine.config.ResourceCrates_Capacity / 2) then
				self:SetBodygroup(0, 2)
			elseif (r_amount > 0) then
				self:SetBodygroup(0, 1)
			else
				self:SetBodygroup(0, 0)
			end
		end
	else
		self.LastStorage = -1
	end
end
