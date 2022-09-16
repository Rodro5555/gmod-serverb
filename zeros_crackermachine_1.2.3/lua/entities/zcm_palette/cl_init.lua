include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.fireworkCount_Y = 0
	self.fireworkCount_X = 0
	self.fireworkCount_Z = 0
end

function ENT:CrateChangeUpdater()
	local fireworkCount = self:GetFireworkCount()

	if self.LastFireworkCount ~= fireworkCount then
		self.LastFireworkCount = fireworkCount
		self:UpdateClientProps()
	end
end

function ENT:Think()
	--Here we create or remove the client models
	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then
		self:CrateChangeUpdater()
	else
		self:RemoveClientModels()
		self.ClientProps = {}
		self.LastFireworkCount = -1
	end
end

function ENT:UpdateClientProps()
	self:RemoveClientModels()
	self.ClientProps = {}

	for i = 1, self:GetFireworkCount() do
		self:CreateClientCrate(i)
	end
end

function ENT:OnRemove()
	self:RemoveClientModels()
end

function ENT:CreateClientCrate(f_pos)
	local pos = self:GetPos() - self:GetRight() * 20 - self:GetForward() * 40 + self:GetUp() * 9
	local ang = self:GetAngles()

	if self.fireworkCount_X >= 3 then
		self.fireworkCount_X = 1
		self.fireworkCount_Y = self.fireworkCount_Y + 1
	else
		self.fireworkCount_X = self.fireworkCount_X + 1
	end

	if self.fireworkCount_Y >= 3 then
		self.fireworkCount_Y = 0
		self.fireworkCount_Z = self.fireworkCount_Z + 1
	end



	pos = pos + self:GetForward() * 20 * self.fireworkCount_X
	pos = pos + self:GetRight() * 20 * self.fireworkCount_Y
	pos = pos + self:GetUp() * 11 * self.fireworkCount_Z

	local crate = ents.CreateClientProp()
	crate:SetModel("models/zerochain/props_crackermaker/zcm_fireworkpack.mdl")
	crate:SetAngles(ang)
	crate:SetPos(pos)
	crate:Spawn()
	crate:Activate()
	//crate:SetRenderMode(RENDERMODE_NORMAL)
	crate:SetParent(self)

	table.insert(self.ClientProps, crate)
end

function ENT:RemoveClientModels()
	self.fireworkCount_Y = 0
	self.fireworkCount_X = 0
	self.fireworkCount_Z = 0

	if (self.ClientProps and table.Count(self.ClientProps) > 0) then
		for k, v in pairs(self.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end
