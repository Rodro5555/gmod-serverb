AddCSLuaFile()
TOOL.Category = "Zeros GrowOP 2"
TOOL.Name = "#DropZone"
TOOL.Command = nil

if (CLIENT) then
	language.Add("tool.zgo2_dropzone.name", "Zeros GrowOP 2 - DropZone")
	language.Add("tool.zgo2_dropzone.desc", "LeftClick: Creates a new DropZone. \nRightClick: Cancels / Removes a DropZone.")
	language.Add("tool.zgo2_dropzone.0", "LeftClick: Creates a new DropZone.")
	language.Add("tool.zgo2_dropzone.1", "RightClick: Removes the DropZone.")
end

function TOOL:LeftClick(trace)
	local trEnt = trace.Entity

	if trEnt:IsPlayer() then return false end
	if IsFirstTimePredicted() == false then return end

	if trEnt:IsWorld() then
		zclib.Zone.ToolLeftClick("zgo2_drop_zone", self, self:GetOwner(), trace, {})

		return true
	else
		return false
	end
end

function TOOL:RightClick(trace)
	if trace.Hit and trace.HitPos then
		zclib.Zone.ToolRightClick("zgo2_drop_zone", self, self:GetOwner(), trace)

		return true
	else
		return false
	end
end

function TOOL:Deploy()
	zclib.Zone.ToolDeploy("zgo2_drop_zone", self)
end

function TOOL:Holster()
	zclib.Zone.ToolHolster("zgo2_drop_zone", self)
end

function TOOL:Think()
	zclib.Zone.ToolThink("zgo2_drop_zone", self)
end
