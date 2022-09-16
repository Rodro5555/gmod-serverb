AddCSLuaFile()
include("sh_ztm_config.lua")
AddCSLuaFile("sh_ztm_config.lua")

TOOL.Category = "Zeros Trashman"
TOOL.Name = "#TrashSpawner"
TOOL.Command = nil


if (CLIENT) then
	language.Add("tool.ztm_trashspawner.name", "Zeros Trashman - Trash Spawner")
	language.Add("tool.ztm_trashspawner.desc", "LeftClick: Creates a Trash Spawnpoint. \nRightClick: Removes a Trash Spawnpoint.")
	language.Add("tool.ztm_trashspawner.0", "LeftClick: Creates a Trash Spawn.")
end


function TOOL:LeftClick(trace)
	local trEnt = trace.Entity

	if trEnt:IsPlayer() then return false end

	if (CLIENT) then return end

	if (trEnt:GetClass() == "worldspawn") then

		if trace.Hit and trace.HitPos and zclib.util.InDistance(trace.HitPos, self:GetOwner():GetPos(), 1000) then

	       ztm.Trash.AddSpawnPos(trace.HitPos,self:GetOwner())
	    end

		return true
	else
		return false
	end
end

function TOOL:RightClick(trace)
	if (trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return end

	if trace.Hit and trace.HitPos then

		if zclib.util.InDistance(trace.HitPos, self:GetOwner():GetPos(), 1000) then

	       ztm.Trash.RemoveSpawnPos(trace.HitPos,self:GetOwner())
	    end

		return true
	else
		return false
	end
end

function TOOL:Deploy()
	if SERVER then
		if zclib.Player.IsAdmin(self:GetOwner()) == false then return end

		ztm.Trash.ShowAll(self:GetOwner())
	end
end

function TOOL:Holster()
	if SERVER then
		ztm.Trash.HideAll(self:GetOwner())
	end
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {
		Text = "#tool.ztm_trashspawner.name",
		Description = "#tool.ztm_trashspawner.desc"
	})

	CPanel:AddControl("label", {
		Text = "Saves all the Trash points that are currently on the Map"
	})

	CPanel:Button("Save Trash points", "ztm_save_trash")

	CPanel:AddControl("label", {
		Text = " "
	})
	CPanel:AddControl("label", {
		Text = "Removes all the Trash points that are currently on the Map"
	})

	CPanel:Button("Remove all Trash points", "ztm_remove_trash")
end
