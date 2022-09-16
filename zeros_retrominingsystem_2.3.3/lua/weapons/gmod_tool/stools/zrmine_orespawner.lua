AddCSLuaFile()
include("zrmine_config.lua")
AddCSLuaFile("zrmine_config.lua")

TOOL.Category = "Zeros RetroMiningSystem"
TOOL.Name = "#OreSpawner"
TOOL.Command = nil
TOOL.ConfigName = nil

TOOL.ClientConVar["type"] = "Random"
TOOL.ClientConVar["amount"] = 5000

if (CLIENT) then
	language.Add("tool.zrmine_orespawner.name", "Zeros Retro MiningSystem - Ore Spawner")
	language.Add("tool.zrmine_orespawner.desc", "Creates a Resource Ore")
	language.Add("tool.zrmine_orespawner.0", "LeftClick: Creates a Resource Ore.")
end


function TOOL:LeftClick(trace)
	local trEnt = trace.Entity
	if (trEnt:IsPlayer()) then return false end
	if (CLIENT) then return end
	local tool_rType = self:GetClientInfo("type")
	local tool_rAmount = self:GetClientNumber("amount", 3)

	if (tool_rType == 1) then
		if (SERVER) then
			zrmine.f.Notify(self:GetOwner(), "Select a Resource Type First!", 1)
		end

		return
	end

	if (trEnt:GetClass() == "worldspawn") then
		--This prevents the creation of Spawner that are too close to others
		local ahzdistance
		local pos = trace.HitPos

		for a, b in pairs(ents.FindByClass("zrms_ore")) do
			if not b:IsValid() then return end


			if zrmine.f.InDistance(pos, b:GetPos(), 100) then
				ahzdistance = true

				if (SERVER) then
					zrmine.f.Notify(self:GetOwner(), "Too Close to other Spawn!", 1)
				end

				break
			end
		end

		if ahzdistance then return false end

		local ent = ents.Create("zrms_ore")
		if (not ent:IsValid()) then return end
		ent:SetPos(pos + Vector(0, 0, 1))

		local ang = trace.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(),-90)

		ang:RotateAroundAxis(ang:Up(), math.random(0, 360))
		ent:SetAngles(ang)

		ent:SetResourceType(tool_rType)
		ent:SetResourceAmount(tool_rAmount)
		ent:SetMax_ResourceAmount(tool_rAmount)

		ent:Spawn()
		ent:Activate()

		undo.Create("zrms_ore")
		undo.AddEntity(ent)
		undo.SetPlayer(self:GetOwner())
		undo.Finish()

		if (SERVER) then
			zrmine.f.Notify(self:GetOwner(), "New Resource Spawn created!", 0)
		end

		return true
	else
		if (trEnt:GetClass() == "zrms_ore") then
			trEnt:SetResourceType(tool_rType)
			trEnt:SetResourceAmount(tool_rAmount)
			trEnt:SetMax_ResourceAmount(tool_rAmount)
			zrmine.f.OreSpawn_UpdateVisual(trEnt)

			if (SERVER) then
				zrmine.f.Notify(self:GetOwner(), "Resource Spawn Updated!", 0)
			end

			return true
		else
			return false
		end
	end
end

function TOOL:RightClick(trace)
	if (trace.Entity:IsPlayer()) then return false end
end

function TOOL:Deploy()
end

function TOOL:Holster()
end


function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {
		Text = "#tool.zrmine_orespawner.name",
		Description = "#tool.zrmine_orespawner.desc"
	})

	CPanel:AddControl("label", {
		Text = "-------------------------------------------------------------------"
	})

	local combobox = CPanel:ComboBox("Resource Type", "zrmine_orespawner_type")
	combobox:AddChoice("Random")
	combobox:AddChoice("Coal")
	combobox:AddChoice("Iron")
	combobox:AddChoice("Bronze")
	combobox:AddChoice("Silver")
	combobox:AddChoice("Gold")
	CPanel:NumSlider("Resource Amount", "zrmine_orespawner_amount", 25, 10000, 0)

	CPanel:AddControl("label", {
		Text = "Tip: When creating Bronze,Silver or Gold Ore´s make sure do not set the Amount too High."
		})

		CPanel:AddControl("label", {
			Text = "Recommended: 100-200"
		})

		CPanel:AddControl("label", {
			Text = "-------------------------------------------------------------------"
		})

		CPanel:AddControl("label", {
			Text = "Saves all Ore Spawners that are currently on the Map"
		})

		CPanel:Button("Save Ore Spawner", "zrms_ore_save")
	end


if CLIENT then
	-- The ClientModel
	if zrms_tool_item == nil then
		zrms_tool_item = nil
	end

	local function SpawnClientModel(weapon)
		local ent = ents.CreateClientProp()
		ent:SetPos(weapon:GetPos() + weapon:GetUp() * 25 + weapon:GetForward() * 10)
		ent:SetModel("models/zerochain/props_mining/zrms_resource_point.mdl")
		ent:SetAngles(Angle(0, 0, 0))
		ent:Spawn()
		ent:Activate()
		ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ent:SetColor(Color(0, 255, 0, 200))
		zrms_tool_item = ent
	end

	hook.Add("Think", "a_zrmine_Think_ToolGun_OreSpawner", function()
		local ply = LocalPlayer()
		local weapon = ply:GetActiveWeapon()

		if IsValid(weapon) and weapon:GetClass() == "gmod_tool" then
			local tool = ply:GetTool()

			if tool and table.Count(tool) > 0 and IsValid(tool.SWEP) and tool.Mode == "zrmine_orespawner" and tool.Name == "#OreSpawner" then
				if IsValid(zrms_tool_item) then
					local tr = ply:GetEyeTrace()

					if tr.Hit and tr.HitPos then
						zrms_tool_item:SetPos(tr.HitPos)
						local ang = tr.HitNormal:Angle()
						ang:RotateAroundAxis(ang:Right(),-90)
						zrms_tool_item:SetAngles(ang)
					end
				else
					SpawnClientModel(weapon)
				end
			else
				if IsValid(zrms_tool_item) then
					zrms_tool_item:Remove()
				end
			end
		else

			if IsValid(zrms_tool_item) then
				zrms_tool_item:Remove()
			end
		end
	end)
end
