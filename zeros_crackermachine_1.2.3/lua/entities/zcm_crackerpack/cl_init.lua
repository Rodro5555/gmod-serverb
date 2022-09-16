include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	self.RollCount = 0
	zcm.f.EntList_Add(self)
end

function ENT:Think()
	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then
		if self.ClientProps then
			if self.RollCount ~= self:GetCrackerCount() then
				self:RemoveClientModels()
				self.RollCount = self:GetCrackerCount()
				for i = 1, math.Clamp(self.RollCount,0,37) do
					self:SpawnClientModel_Roll(i)
				end
			end
			for k, v in pairs(self.ClientProps) do
				if IsValid(v) then
					local attach = self:GetAttachment(k)
					v:SetPos(attach.Pos)
					v:SetAngles(attach.Ang)
				end
			end
		else
			self.ClientProps = {}
		end
	else
		self:RemoveClientModels()
	end

	self:SetNextClientThink(CurTime())

	return true
end

function ENT:SpawnClientModel_Roll(pos)
	local ent = ents.CreateClientProp()
	ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
	ent:SetModel("models/zerochain/props_crackermaker/zcm_crackerroll.mdl")
	ent:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
	ent:Spawn()
	ent:Activate()
	//ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	//ent:SetParent(self,pos)
	//local attach = self:GetAttachment(pos)
	//ent:SetPos(attach.Pos)
	//ent:SetAngles(attach.Ang)
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
	self.RollCount = 0
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
