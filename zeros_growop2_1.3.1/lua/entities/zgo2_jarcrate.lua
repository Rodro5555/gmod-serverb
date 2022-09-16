AddCSLuaFile()
DEFINE_BASECLASS("zgo2_item_base")
ENT.Type                    = "anim"
ENT.Base                    = "zgo2_item_base"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Jar Crate"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_jarcrate.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end

if SERVER then
	function ENT:Initialize()
		zgo2.JarCrate.Initialize(self)
	end

	function ENT:OnRemove()
		zgo2.JarCrate.OnRemove(self)
	end

	function ENT:AcceptInput(inputName, activator, caller, data)
		if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
			zgo2.JarCrate.OnUse(self, activator)
		end
	end

	function ENT:StartTouch(other)
		zgo2.JarCrate.OnStartTouch(self, other)
	end
end
