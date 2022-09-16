include("shared.lua")

function ENT:DrawButtons()
	cam.Start3D2D(self:LocalToWorld(Vector(0, -15, 23)), self:LocalToWorldAngles(Angle(0,0,0)), 0.05)

		local atext = zcm.language.General["Collect"]

		local aSize = 60 * string.len(atext)

		if self:OnSellButton(LocalPlayer()) then
			draw.RoundedBox(20, -aSize / 2 , -60, aSize, 100,  zcm.default_colors["yellow03"])
		else
			draw.RoundedBox(20, -aSize / 2 , -60, aSize, 100, zcm.default_colors["black02"])
		end

		draw.SimpleText(atext, "zcm_font02", 0, -60, zcm.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) and self.IsOpen == false and zcm.f.IsCrackerMaker(LocalPlayer()) then
		self:DrawButtons()
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.FireworkCount = 0
	self.IsOpen = true
	self.IsAnimating = false
	zcm.f.EntList_Add(self)
end

function ENT:Think()
	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then

		if self.IsOpen then
			if self.ClientProps then
				if self.FireworkCount ~= self:GetFireworkCount() then
					self:RemoveClientModels()
					self.FireworkCount = self:GetFireworkCount()

					for i = 1, math.Clamp(self.FireworkCount, 0, 8) do
						self:SpawnClientModel_Firework(i)
					end
				end
			else
				self.ClientProps = {}
			end
		end

		if self.IsAnimating == false and self.IsOpen ~= self:GetIsOpen() then
			self.IsAnimating = true
			self.IsOpen = self:GetIsOpen()

			if self.IsOpen then
				self:SetBodygroup(0, 0)
				zcm.f.PlayClientAnimation(self, "open", 2)
			else
				zcm.f.PlayClientAnimation(self, "close", 2)
				self:EmitSound("zcm_box_close")
				timer.Simple(0.75, function()
					if IsValid(self) then
						self:SetBodygroup(0, 1)
						self:RemoveClientModels()
					end
				end)
			end

			timer.Simple(1, function()
				if IsValid(self) then
					self.IsAnimating = false
				end
			end)
		end
	else
		self.IsOpen = -1
		self.FireworkCount = -1
		self:RemoveClientModels()
	end

	self:SetNextClientThink(CurTime())

	return true
end

local f_pos = {
	[1] = Vector(10, -10, 5),
	[2] = Vector(10, 10, 5),
	[3] = Vector(-10, -10, 5),
	[4] = Vector(-10, 10, 5),
	[5] = Vector(10, -10, 15),
	[6] = Vector(10, 10, 15),
	[7] = Vector(-10, -10, 15),
	[8] = Vector(-10, 10, 15)
}

function ENT:SpawnClientModel_Firework(pos)
	local ent = ents.CreateClientProp()
	ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
	ent:SetModel("models/zerochain/props_crackermaker/zcm_fireworkpack.mdl")
	ent:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
	ent:Spawn()
	ent:Activate()
	ent:SetParent(self)

	ent:SetPos(self:LocalToWorld(f_pos[pos]))

	self.ClientProps[pos] = ent
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
	self.FireworkCount = 0
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
