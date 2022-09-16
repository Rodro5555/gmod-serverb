include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 300) then
		self:DrawInfo()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

// UI STUFF
local size = 75
function ENT:DrawResourceItem(Info, color, offsetY)
	draw.RoundedBox(1, -2, 69 + offsetY, 4, 7, zrmine.default_colors["white01"])
	surface.SetDrawColor(zrmine.default_colors["white03"])
	surface.SetMaterial(zrmine.default_materials["Circle"])
	surface.DrawTexturedRect(-38, offsetY, size, size)

	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["MetalBar"])
	surface.DrawTexturedRect(-38, offsetY, size, size)

	draw.DrawText(Info, "zrmine_gravelcrate_font1", 1, offsetY + 32, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
end

function ENT:DrawInfo()
	local rTable = {
		["Iron"] = {a = self:GetbIron(),c = zrmine.default_colors["Iron"]},
		["Bronze"] = {a = self:GetbBronze(),c = zrmine.default_colors["Bronze"]},
		["Silver"] = {a = self:GetbSilver(),c = zrmine.default_colors["Silver"]},
		["Gold"] = {a = self:GetbGold(),c = zrmine.default_colors["Gold"]}
	}

	cam.Start3D2D(self:LocalToWorld(Vector(0,0,20)), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
		local oY = -35

		for k, v in pairs(rTable) do
			if (rTable[k].a > 0) then
				self:DrawResourceItem(rTable[k].a, rTable[k].c, oY)
				oY = oY - 70
			end
		end

	cam.End3D2D()
end

function ENT:Initialize()
	self.LastBarCount = 0
	self.LastClosed = false
end


function ENT:BarChangeUpdater()
	local iron = self:GetbIron()
	local bronze = self:GetbBronze()
	local silver = self:GetbSilver()
	local gold = self:GetbGold()
	local barCount = iron + bronze + silver + gold

	if self.LastBarCount ~= barCount then

		zrmine.f.EmitSoundENT("zrmine_addbar",self)

		self.LastBarCount = barCount
		self:UpdateClientProps()
	end
end


function ENT:Think()
	self:SetNextClientThink(CurTime())

	//Here we create or remove the client models
	if zrmine.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 500) then
		self:BarChangeUpdater()

		local closed = self:GetIsClosed()

		if self.LastClosed ~= closed then
			self.LastClosed = closed

			if closed then
				zrmine.f.Animation(self, "close", 2)
			else
				zrmine.f.Animation(self, "idle", 1)
			end
		end
	else
		self:RemoveClientModels()
		self.ClientProps = {}
		self.LastBarCount = -1
		self.LastClosed = -1
	end

	return true
end

function ENT:UpdateClientProps()
	self:RemoveClientModels()

	self.ClientProps = {}

	for i = 1, self:GetbIron() do
		self:CreateClientBar(0)
	end

	for i = 1, self:GetbBronze() do
		self:CreateClientBar(1)
	end

	for i = 1, self:GetbSilver() do
		self:CreateClientBar(2)
	end

	for i = 1, self:GetbGold() do
		self:CreateClientBar(3)
	end
end

function ENT:OnRemove()
	self:RemoveClientModels()
end

function ENT:CreateClientBar(skin)
	local y = 1.5
	local c = 4.5
	local l = -5.5
	local barCount = table.Count(self.ClientProps)

	if (barCount > 5) then
		y = 3.5
	end

	if (barCount == 1 or barCount == 7) then
		c = 0
	elseif (barCount == 2 or barCount == 8) then
		c = -4.5
	elseif (barCount == 3 or barCount == 9) then
		l = 5.5
		c = 4.5
	elseif (barCount == 4 or barCount == 10) then
		l = 5.5
		c = 0
	elseif (barCount == 5 or barCount == 11) then
		l = 5.5
		c = -4.5
	end

	local bar = ents.CreateClientProp()

	bar:SetPos(self:GetPos() + self:GetUp() * y + self:GetForward() * l + self:GetRight() * c)
	bar:SetModel("models/Zerochain/props_mining/zrms_bar.mdl")
	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetUp(), 0)
	ang:RotateAroundAxis(self:GetRight(), 180)
	bar:SetAngles(ang)

	bar:Spawn()
	bar:Activate()

	bar:SetRenderMode(RENDERMODE_NORMAL)
	bar:SetParent(self)
	bar:SetSkin(skin)

	table.insert(self.ClientProps, bar)
end

function ENT:RemoveClientModels()
	if (self.ClientProps and table.Count(self.ClientProps) > 0) then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
