
AddCSLuaFile()

SWEP.PrintName = "Cuffed"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Spawnable = false

SWEP.Category = "Realistic Police"

SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model("models/realistic_police/handcuffs/w_deploy_handcuffs.mdl")
SWEP.ViewModelFOV = 75
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 125

SWEP.DarkRPCanLockpick = true

function SWEP:Deploy()
	local Owner = self:GetOwner()
	-- Manipulate the Bone of the Player 
	timer.Simple(0.2, function()
		for k,v in pairs(Realistic_Police.ManipulateBoneCuffed) do
			local bone = Owner:LookupBone(k)
			if bone then
				Owner:ManipulateBoneAngles(bone, v)
			end
		end
		self:SetHoldType("passive")
	end ) 
end 

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then

			local offsetVec = Vector(5, 1, -9)
			local offsetAng = Angle(190, 140, -20)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
	WorldModel:SetModelScale( WorldModel:GetModelScale() * 1.3, 0 )
end

if CLIENT then
	function SWEP:DrawHUD()
		draw.SimpleTextOutlined(Realistic_Police.GetSentence("youArrest"),"rpt_font_9", ScrW()/2, ScrH()/15, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,2, Realistic_Police.Colors["black"])
		if math.Round(LocalPlayer():GetNWInt("rpt_arrest_time") - CurTime()) > 0 then 
			draw.SimpleTextOutlined("[ "..math.Round(LocalPlayer():GetNWInt("rpt_arrest_time") - CurTime()).." ] - "..Realistic_Police.GetSentence("seconds"),"rpt_font_9", ScrW()/2, ScrH()/11, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,2, Realistic_Police.Colors["black"])
		end 
	end
end

function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end
