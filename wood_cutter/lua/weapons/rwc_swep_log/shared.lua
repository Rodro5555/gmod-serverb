SWEP.Category = "Woodcutter_Weapons"
SWEP.PrintName = "Log"
SWEP.Author = "Kobralost & jhon Smith"
SWEP.ViewModel = "models/wasted/kobralost_rwc_swep_rodin_c.mdl"
SWEP.ViewModelFOV = 45
SWEP.UseHands = true
SWEP.WorldModel = "models/props_rwc/rwc_tree_trunk.mdl"
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

			local offsetVec = Vector(-2, 1, -8)
			local offsetAng = Angle(80, -80, -0)
			
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

			if IsValid(_Owner:GetActiveWeapon()) then
				if _Owner:GetActiveWeapon():GetNWBool("Debarked", false) then
					WorldModel:SetSubMaterial(0,"models/props_rwc/sans_ecorce")
				end
			end

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		
		WorldModel:DrawModel()
	end

	WorldModel:SetModelScale( WorldModel:GetModelScale() * 1.5, 0 )
end

function SWEP:DrawHUD()
	if not CLIENT then return end
	if not IsValid(self:GetOwner()) then return end
	if not IsValid(self:GetOwner():GetActiveWeapon()) then return end

	if self:GetOwner():GetActiveWeapon():GetNWBool("Debarked", false) then
		LocalPlayer():GetViewModel(0):SetSubMaterial(0, "models/props_rwc/sans_ecorce")
	end
end

function SWEP:OnRemove()
	if not CLIENT then return end
	LocalPlayer():GetViewModel(0):SetSubMaterial(0, "")
end