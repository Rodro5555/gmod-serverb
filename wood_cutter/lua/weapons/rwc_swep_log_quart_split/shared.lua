SWEP.Category = "Woodcutter_Weapons"
SWEP.PrintName = "Quart Log"
SWEP.Author = "Kobralost and jhon Smithw"
SWEP.ViewModel = "models/wasted/kobralost_rwc_swep_split_log_x_c.mdl"
SWEP.ViewModelFOV = 45
SWEP.WorldModel = "models/props_rwc/rwc_split_log_quart.mdl"
SWEP.HoldType = "grenade"
SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then

			local offsetVec = Vector(-2, 10, -8)
			local offsetAng = Angle(180, 180, -90)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

			local mat = Matrix()
			mat:Scale(Vector(0.5,0.5,0.5))
			WorldModel:EnableMatrix("RenderMultiply", mat)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
	WorldModel:SetModelScale( WorldModel:GetModelScale() * 1.5, 0 )
end