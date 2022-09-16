ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Lamp"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_sodium_lamp01.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:OnLightSwitch(ply)
    local trace = ply:GetEyeTrace()

	local switch_vec , switch_ang = zgo2.Lamp.GetUI_Switch(self)

    if zclib.util.InDistance(self:LocalToWorld(switch_vec), trace.HitPos, 4) then
        return true
    else
        return false
    end
end

function ENT:OnColorChange(ply)
    local trace = ply:GetEyeTrace()

	local color_vec , color_ang = zgo2.Lamp.GetUI_Color(self)

    if zclib.util.InDistance(self:LocalToWorld(color_vec), trace.HitPos, 4) then
        return true
    else
        return false
    end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Power")
	self:NetworkVar("Bool", 0, "LightSwitch")

	self:NetworkVar("Int", 1, "LampID")
	self:NetworkVar("Vector", 0, "LampColor")

	self:NetworkVarNotify("LampColor", self.UpdateLightColorVar)

	if SERVER then
		self:SetPower(0)
		self:SetLightSwitch(false)
		self:SetLampID(1)
		local col = Color(255,220,150)
		self:SetLampColor(Vector(col.r, col.g, col.b))
	end
end

function ENT:UpdateLightColorVar( name, old, new )
	if name == "LampColor" then
		zgo2.Lamp.UpdateLightColorVar(self,new)
	end
end

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end

/*
	How much power does this machine need
*/
function ENT:GetPowerNeed()
	return zgo2.Lamp.GetPowerUsage(self)
end
