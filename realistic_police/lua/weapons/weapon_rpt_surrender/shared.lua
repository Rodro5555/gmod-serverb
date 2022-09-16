AddCSLuaFile()

SWEP.PrintName = "Surrender"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Spawnable = false

SWEP.Category = "Realistic Police"

SWEP.ViewModel = Model( "models/weapons/sycreations/Kobralost/handsup.mdl" )
SWEP.WorldModel = Model("")
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

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

function SWEP:Deploy()
	local Owner = self:GetOwner()
	-- Manipulate the Bone of the Player 
	timer.Simple(0.2, function()
		for k,v in pairs(Realistic_Police.ManipulateBoneSurrender) do
			local bone = Owner:LookupBone(k)
			if bone then
				Owner:ManipulateBoneAngles(bone, v)
			end
		end
		self:SetHoldType("passive")
		Owner.RPTSurrender = true 
	end ) 
end 

if CLIENT then
	function SWEP:DrawHUD()
		draw.SimpleTextOutlined(Realistic_Police.GetSentence("youSurrender").." ( Press "..Realistic_Police.SurrenderInfoKey.." )","rpt_font_9", ScrW()/2, ScrH()/15, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,2, Realistic_Police.Colors["black"])
	end
end

function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end
