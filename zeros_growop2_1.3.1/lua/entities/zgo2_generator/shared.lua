ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Generator"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_generator.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

// How much fuel can it hold
ENT.Capacity = 2000

// How much power does it produce per second
ENT.PowerRate = 3


function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Fuel")
	self:NetworkVar("Int", 1, "Power")
	self:NetworkVar("Bool", 1, "TurnedOn")

	self:NetworkVar("Int", 2, "GeneratorID")

	if SERVER then
		self:SetGeneratorID(1)
		self:SetFuel(0)
		self:SetPower(0)
		self:SetTurnedOn(false)
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

local lsw_vec = Vector(7.5,0,-10)
function ENT:OnSwitch(ply)
    local trace = ply:GetEyeTrace()

	local dat = zgo2.Generator.GetData(self:GetGeneratorID())
	if not dat then return end

	local pos = dat.UIPos.vec + lsw_vec
	//debugoverlay.Sphere(self:LocalToWorld(pos),1,0.1,Color( 0, 255, 0 ),true)
    if zclib.util.InDistance(self:LocalToWorld(pos), trace.HitPos, 6) then
        return true
    else
        return false
    end
end

local lsw_vec01 = Vector(-7.5,0,-10)
function ENT:OnConnect(ply)
    local trace = ply:GetEyeTrace()

	local dat = zgo2.Generator.GetData(self:GetGeneratorID())
	if not dat then return end

	local pos = dat.UIPos.vec + lsw_vec01
	//debugoverlay.Sphere(self:LocalToWorld(pos),1,0.1,Color( 0, 255, 0 ),true)

    if zclib.util.InDistance(self:LocalToWorld(pos), trace.HitPos, 6) then
        return true
    else
        return false
    end
end
