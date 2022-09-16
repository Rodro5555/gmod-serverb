ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "MachineBase"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "model/path"
ENT.AutomaticFrameAdvance = true
function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end

// Called to get a specific boost value
function ENT:GetBoostValue(boosttype)
	local boostValue = zrush.ModuleDefinitions[boosttype].getvalue(self) or 0
	boostValue = math.Round(boostValue, 2)
	return boostValue
end

function ENT:HasChaosEvent()
	return self:IsJammed() or self:IsOverHeating()
end

// Asks if the machine is running
function ENT:IsRunning()
end

// Called to check if the entity is ready for a chaos event
function ENT:ReadyForEvent()
end

// Is the machine jammed?
function ENT:IsJammed()
	return self:GetState() == ZRUSH_STATE_JAMMED
end

// Is the machine overheating?
function ENT:IsOverHeating()
	return self:GetState() == ZRUSH_STATE_OVERHEAT
end

function ENT:ModulesChanged()

end


if SERVER then
	// Called after the machine got build
	function ENT:PostBuild(ply,BuildOnEntity)
	end

	// Called to jam the machine
	function ENT:OnJamEvent()
	end

	// Called after the machine got fixed
	function ENT:OnJamFixed()
	end

	// Called to start a machine to overheat
	function ENT:OnHeatEvent()
	end

	// Called after the machine got cooled
	function ENT:OnHeatFixed()
	end

	// Called right before the machine explodes
	function ENT:OnHeatFailed()
	end

	// Toggles the machine on or off
	function ENT:Toggle(ply)
	end

	// Called when the machine gets Deconstructed
	function ENT:Deconstruct(ply)
	end
else
	// Creats a table with all the machines current statistics
	function ENT:GetStats()

	end
end
