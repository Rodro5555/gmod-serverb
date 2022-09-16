include("shared.lua")
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:Initialize()
	zgo2.Bong.Initialize(self)
end

function SWEP:DrawHUD()
	zgo2.Bong.DrawHUD(self)
end

function SWEP:Think()
	zgo2.Bong.Think(self)
	self:SetNextClientThink(CurTime() + 0.5)
	return true
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:Holster()
	zgo2.Bong.Holster(self)
end

function SWEP:Deploy()
	zgo2.Bong.Deploy(self)
end

function SWEP:OnRemove()
	zgo2.Bong.OnRemove(self)
end

function SWEP:PreDrawViewModel(vm, weapon, ply)
	zgo2.Bong.PreDrawViewModel(self,vm, weapon, ply)
end

function SWEP:DrawWorldModel(flags)
	local BongTypeData = zgo2.Bong.GetTypeData(self:GetBongID())
	self:SetModel(BongTypeData.wm)
	self:DrawModel( flags )
	zgo2.Bong.UpdateTexture(self)
end

function SWEP:DrawWorldModelTranslucent(flags)
	local BongTypeData = zgo2.Bong.GetTypeData(self:GetBongID())
	self:SetModel(BongTypeData.wm)
	self:DrawModel( flags )
	zgo2.Bong.UpdateTexture(self)
end
