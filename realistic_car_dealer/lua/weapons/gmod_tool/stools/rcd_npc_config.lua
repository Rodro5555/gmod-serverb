AddCSLuaFile()

TOOL.Category = "Realistic Car Dealer"
TOOL.Name = "Setup NPC"
TOOL.Author = "Kobralost"

if CLIENT then 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}

	language.Add("tool.rcd_npc_config.name", RCD.GetSentence("toolName"))
	language.Add("tool.rcd_npc_config.desc", RCD.GetSentence("toolDesc"))
end

local function paintCPanel(CPanel)
	CPanel.Paint = function(self,w,h)
		draw.RoundedBox(4, 0, 0, w, h, color_black)
		
		surface.SetDrawColor(RCD.Colors["white"])
		surface.SetMaterial(RCD.Materials["background"])
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(RCD.Colors["white100"])
		surface.SetMaterial(RCD.Materials["logo"])
		surface.DrawTexturedRect(w/2-RCD.ScrH*0.1, h*0.1, RCD.ScrH*0.2, RCD.ScrH*0.2)
	end
	
	local mainPanel = vgui.Create("DPanel")
	mainPanel:SetSize(RCD.ScrW*0.3, RCD.ScrH*0.3)
	mainPanel:SetPos(0,0)
	mainPanel.Paint = function(self,w,h) end

	CPanel:AddPanel(mainPanel)

    local openMenu = vgui.Create("RCD:SlideButton", mainPanel)
    openMenu:SetText(RCD.GetSentence("openAdminConfiguration"))
    openMenu:SetFont("RCD:Font:12")
    openMenu:SetTextColor(RCD.Colors["white"])
    openMenu:InclineButton(0)
    openMenu.MinMaxLerp = {100, 200}
    openMenu:SetIconMaterial(nil)
    openMenu:SetButtonColor(RCD.Colors["purple"])
	openMenu.Think = function()
		openMenu:SetPos(0, RCD.ScrH*0.22)
		openMenu:SetSize(CPanel:GetWide(), RCD.ScrH*0.041)
	end
    openMenu.DoClick = function()
		RCD.Settings()
    end
end

function TOOL.BuildCPanel(CPanel)
	if CLIENT then
		CPanel:AddControl("Header", {
			Text = "#tool.rcd_npc_config.name",
			Description = ""
		})

		paintCPanel(CPanel)
	end
end

function TOOL:LeftClick(trace)
	local ply = self:GetOwner()
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not RCD.AdminRank[ply:GetUserGroup()] then return end

	ply.RCD = ply.RCD or {}

	local curTime = CurTime()

	ply.RCD["toolSpam"] = ply.RCD["toolSpam"] or 0
    if ply.RCD["toolSpam"] > curTime then return end
    ply.RCD["toolSpam"] = curTime + 0.5

	local trace = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 300,
		filter = function(ent) if ent:GetClass() == "prop_physics" then return true end end
	})
	local pos = trace.HitPos

	if SERVER then
		local angSet = Angle(0, ply:GetAimVector():Angle().Yaw - 180, 0)
		local placePlateform = RCD.GetNWVariables("rcd_place_plateform", ply)

		if not placePlateform then
			local ent = ply:GetEyeTrace().Entity
			local npcId
			if IsValid(ent) && ent:GetClass() == "rcd_cardealer" then
				npcId = ent.NPCId
			else
				RCD.CreateNPC(nil, "Sin Nombre", "models/breen.mdl", pos, angSet, {}, {}, string.lower(game.GetMap()))
			end

			local npcInfo = RCD.GetNPCInfo(ent)
			if not istable(npcInfo) then return end
			
			ply:RCDSendAllGroups()

			net.Start("RCD:Admin:Configuration")
				net.WriteUInt(8, 4)
				net.WriteUInt(npcId, 32)
				net.WriteString(npcInfo["model"])
				net.WriteString(npcInfo["name"])
				net.WriteUInt(table.Count(npcInfo["groups"]), 12)
				for k, v in pairs(npcInfo["groups"]) do
					if not v then continue end

					net.WriteUInt(k, 32)
				end
				net.WriteUInt(#npcInfo["plateforms"], 12)
				for k, v in pairs(npcInfo["plateforms"]) do
					net.WriteVector(v.pos)
					net.WriteAngle(v.ang)
				end
			net.Send(ply)
		end
	else 
		local placePlateform = RCD.GetNWVariables("rcd_place_plateform", LocalPlayer())
		if placePlateform then
			local angSet = Angle(0, ply:GetAimVector():Angle().Yaw - 90, 0)

			RCD.CreateRCDPlateform(pos, angSet)
		end
	end
end

function TOOL:RightClick(trace)
	if SERVER then
		local placePlateform = RCD.GetNWVariables("rcd_place_plateform", self:GetOwner())
		if placePlateform then return end

		local ply = self:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if not RCD.AdminRank[ply:GetUserGroup()] then return end

		local curTime = CurTime()

		ply.RCD["toolSpam"] = ply.RCD["toolSpam"] or 0
		if ply.RCD["toolSpam"] > curTime then return end
		ply.RCD["toolSpam"] = curTime + 0.5

		local ent = ply:GetEyeTrace().Entity
		RCD.RemoveNPC(ent.NPCId, true)
	else
		local curTime = CurTime()

		RCD["toolSpam"] = RCD["toolSpam"] or 0
		if RCD["toolSpam"] > curTime then return end
		RCD["toolSpam"] = curTime + 0.5

		local placePlateform = RCD.GetNWVariables("rcd_place_plateform", LocalPlayer())
		if not placePlateform then return end

		RCD["plateforms"] = RCD["plateforms"] or {}

		local ent = RCD["plateforms"][#RCD["plateforms"]]
		if IsValid(ent) then
			ent:Remove()
			RCD["plateforms"][#RCD["plateforms"]] = nil
		end
	end
end 

function TOOL:CreateRCDEnt()
	if CLIENT then
		if not IsValid(self.RCDEnt) then
 			self.RCDEnt = ClientsideModel("models/breen.mdl", RENDERGROUP_OPAQUE)
			self.RCDEnt:SetModel("models/breen.mdl")
			self.RCDEnt:Spawn()
			self.RCDEnt:Activate()	
			self.RCDEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
		end
	end 
end

function RCD.CreateRCDPlateform(pos, angSet)
	if CLIENT then
		RCD["plateforms"] = RCD["plateforms"] or {}
		RCD["plateforms"][#RCD["plateforms"] + 1] = ClientsideModel("models/dimitri/kobralost/spawn.mdl", RENDERGROUP_OPAQUE)
		
		local ent = RCD["plateforms"][#RCD["plateforms"]]
		ent:SetModel("models/dimitri/kobralost/spawn.mdl")
		ent:SetPos(pos)
		ent:SetAngles(angSet)
		ent:Spawn()
		ent:Activate()
		ent:SetRenderMode(RENDERMODE_TRANSALPHA)
	end 
end

function TOOL:RemoveAllPlateforms()
	if CLIENT then
		if istable(RCD["plateforms"]) then
			for k, v in ipairs(RCD["plateforms"]) do
				if IsValid(v) then v:Remove() end
			end
			RCD["plateforms"] = {}
		end
	end
end

function TOOL:Reload()
	if CLIENT then
		local curTime = CurTime()

		RCD["toolSpam"] = RCD["toolSpam"] or 0
		if RCD["toolSpam"] > curTime then return end
		RCD["toolSpam"] = curTime + 0.5

		local plateforms = {}
		if not istable(RCD["plateforms"]) then return end

		for k,v in ipairs(RCD["plateforms"]) do
			if not IsValid(v) then continue end

			plateforms[#plateforms + 1] = {
				["pos"] = v:GetPos(),
				["ang"] = v:GetAngles(),
			}
		end

		net.Start("RCD:Admin:Configuration")
			net.WriteUInt(8, 4)
			net.WriteUInt(#RCD["plateforms"], 8)
			for k, v in ipairs(RCD["plateforms"]) do
				net.WriteVector(v:GetPos())
				net.WriteAngle(v:GetAngles())
			end
		net.SendToServer()

		self:RemoveAllPlateforms()
	end
end

function TOOL:Think()
	if CLIENT then
		local trace = util.TraceLine({
			start = LocalPlayer():EyePos(),
			endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 300,
			filter = function(ent) if ent:GetClass() == "prop_physics" then return true end end
		})
		local ent = LocalPlayer():GetEyeTrace().Entity
		local class = IsValid(ent) and ent:GetClass() or ""
		
		if class != "rcd_cardealer" then
			if IsValid(self.RCDEnt) then
				if not isvector(self.RCDLerpPos) then self.RCDLerpPos = RCD.Constants["vectorOrigin"] end
				self.RCDLerpPos = Lerp(RealFrameTime()*40, self.RCDLerpPos, trace.HitPos)

				local placePlateform = RCD.GetNWVariables("rcd_place_plateform", LocalPlayer())
				local angSet = Angle(0, LocalPlayer():GetAimVector():Angle().Yaw - (placePlateform and 90 or 180), 0)
				
				self.RCDEnt:SetPos(self.RCDLerpPos)
				self.RCDEnt:SetAngles(Angle(angSet, 0, 0))
				self.RCDEnt:SetModel(placePlateform and "models/dimitri/kobralost/spawn.mdl" or "models/breen.mdl")
			else 
				self:CreateRCDEnt() 
			end
		else
			if IsValid(self.RCDEnt) then 
				self.RCDEnt:Remove()
			end
		end

		local placePlateform = RCD.GetNWVariables("rcd_place_plateform", LocalPlayer())

		language.Add("tool.rcd_npc_config.left", RCD.GetSentence((placePlateform and "toolLeft1" or "toolLeft2")))
		language.Add("tool.rcd_npc_config.right", RCD.GetSentence((placePlateform and "toolRight1" or "toolRight2")))
		language.Add("tool.rcd_npc_config.reload", RCD.GetSentence((placePlateform and "toolReload1" or "toolReload2")))
	end
end 

function TOOL:Holster()
	local ply = self:GetOwner()
	if not IsValid(ply) and not ply:IsPlayer() then return end
	if not RCD.AdminRank[ply:GetUserGroup()] then return end

	if CLIENT then
		if IsValid(self.RCDEnt) then 
			self.RCDEnt:Remove()
		end
		self:RemoveAllPlateforms()
	else
		RCD.SetNWVariable("rcd_place_plateform", false, ply, true, ply)
		RCD.SetNWVariable("rcd_npc_id", false, ply, true, ply)
	end
end

function TOOL:DrawToolScreen(w, h)
	surface.SetDrawColor(RCD.Colors["white"])
	surface.SetMaterial(RCD.Materials["toolgun"])
	surface.DrawTexturedRect(0, 0, w, h)
end

hook.Add("CanTool", "RCD:CanTool:PNJ", function(ply, tr, toolname, tool, button)
	if not RCD.AdminRank[ply:GetUserGroup()] then return end

	local ent = tr.Entity
	if not IsValid(ent) then return end

	if toolname == "rcd_npc_config" && string.StartWith(ent:GetClass(), "rcd_") then
	   return true
	end
end)