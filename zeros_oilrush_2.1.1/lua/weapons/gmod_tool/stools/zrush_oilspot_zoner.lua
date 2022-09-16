AddCSLuaFile()
TOOL.Category = "Zeros OilRush"
TOOL.Name = "#Oilzone Spawner"
TOOL.Command = nil

if (CLIENT) then
	language.Add("tool.zrush_oilspot_zoner.name", "Zeros OilRush - Oilspotzone")
	language.Add("tool.zrush_oilspot_zoner.desc", "LeftClick: Creates a new Oilspotzone. \nRightClick: Cancels / Removes a Oilspotzone.")
	language.Add("tool.zrush_oilspot_zoner.0", "LeftClick: Creates a new Oilspotzone.")
	language.Add("tool.zrush_oilspot_zoner.1", "RightClick: Removes the Oilspotzone.")
end

function TOOL:LeftClick(trace)
	local trEnt = trace.Entity
	if trEnt:IsPlayer() then return false end
	if IsFirstTimePredicted() == false then return end
	if trEnt:IsWorld() then
		zclib.Zone.ToolLeftClick("zrush_oilspot_zone", self, self:GetOwner(), trace, {})

		return true
	else
		return false
	end
end

function TOOL:RightClick(trace)
	if trace.Hit and trace.HitPos then
		zclib.Zone.ToolRightClick("zrush_oilspot_zone", self, self:GetOwner(), trace)

		return true
	else
		return false
	end
end

function TOOL:Deploy()
	zclib.Zone.ToolDeploy("zrush_oilspot_zone", self)
end

function TOOL:Holster()
	zclib.Zone.ToolHolster("zrush_oilspot_zone", self)
end

function TOOL:Think()
	zclib.Zone.ToolThink("zrush_oilspot_zone", self)
end
