AddCSLuaFile()
DEFINE_BASECLASS("zgo2_item_base")
ENT.Type                    = "anim"
ENT.Base                    = "zgo2_item_base"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Log Book"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/props_lab/binderblue.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE

if SERVER then
	function ENT:AcceptInput(inputName, activator, caller, data)
		if inputName == "Use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
			zgo2.Logbook.OnUse(self,activator)
		end
	end
	function ENT:PostInitialize()
		zgo2.Logbook.Initialize(self)
	end
else
	function ENT:Draw()
		self:DrawModel()
		zgo2.HUD.Draw(self,function()
			draw.SimpleText("Log Book", zclib.GetFont("zclib_world_font_medium"), 0, 0, zclib.colors[ "text01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end)
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
