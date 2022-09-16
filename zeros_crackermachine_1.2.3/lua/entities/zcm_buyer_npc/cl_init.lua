include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then
		self:DrawInfo()
	end
end

function ENT:DrawInfo()
	cam.Start3D2D(self:LocalToWorld(Vector(0,0,85 + 1 * math.abs(math.sin(CurTime()) * 1))), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
		local earning = zcm.config.NPC.SellPrice[zcm.f.GetPlayerRank(LocalPlayer())]

		if earning == nil then
			earning = zcm.config.NPC.SellPrice["Default"]
		end

		earning = earning * ((1 / 100) * self:GetPriceModifier())
		local sellInfo = earning .. zcm.config.Currency .. " / " .. zcm.language.General["Firework"]
		local aSize = 23 * string.len(sellInfo)
		draw.RoundedBox(25, -aSize / 2, 25, aSize, 50, zcm.default_colors["black02"])
		draw.SimpleText(sellInfo, "zcm_npc_font02", 0, 27, zcm.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleTextOutlined(zcm.language.General["NPCTitle"], "zcm_npc_font01", 0, -25, zcm.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, zcm.default_colors["black03"])
	cam.End3D2D()
end

function ENT:Think()
	if zcm.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), zcm.f.GetRenderDistance()) then
		if self.ClientProps then
			if IsValid(self.ClientProps["Hat"]) then
				local attach = self:GetAttachment(self:LookupAttachment("eyes"))
				self.ClientProps["Hat"]:SetPos(attach.Pos + attach.Ang:Forward() * -3.2 + attach.Ang:Up() * 1.1)
				local ang = attach.Ang
				ang:RotateAroundAxis(ang:Up(), -90)
				self.ClientProps["Hat"]:SetAngles(ang)
			else
				self:SpawnClientModel_Hat()
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

function ENT:SpawnClientModel_Hat()
	local ent = ents.CreateClientProp()
	ent:SetPos(self:LocalToWorld(Vector(0, 0, 0)))
	ent:SetModel("models/zerochain/props_crackermaker/zcm_sombreoro.mdl")
	ent:SetAngles(self:LocalToWorldAngles(Angle(0, 0, 0)))
	ent:Spawn()
	ent:Activate()
	--ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	ent:SetParent(self, pos)
	local attach = self:GetAttachment(self:LookupAttachment("eyes"))
	ent:SetPos(attach.Pos)
	ent:SetAngles(attach.Ang)
	ent:SetModelScale(0.63)
	self.ClientProps["Hat"] = ent
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
end

function ENT:OnRemove()
	self:RemoveClientModels()
end
