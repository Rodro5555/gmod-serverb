AddCSLuaFile()

SWEP.PrintName = "Fine Book"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.Category = "Realistic Police"

SWEP.ViewModel = Model( "models/realistic_police/finebook/c_notebook.mdl" )
SWEP.WorldModel = Model("models/realistic_police/finebook/w_notebook.mdl")
SWEP.ViewModelFOV = 75
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

	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	-- Play the idle animation next the primary attack
	timer.Create("rpt_animation"..self:GetOwner():EntIndex(), self:SequenceDuration(), 1, function()	
		if IsValid(self) && IsValid(Owner) then 		
			if Owner:GetActiveWeapon() == self then
				self:SendWeaponAnim( ACT_VM_IDLE )
			end 
		end 
	end ) 
end 

function SWEP:PrimaryAttack()
	local Owner = self:GetOwner()

	Owner.AntiSpam = Owner.AntiSpam or CurTime()
	if Owner.AntiSpam > CurTime() then return end 
	Owner.AntiSpam = CurTime() + 1 

	if SERVER then 
		Owner.WeaponRPT["Fine"] = Owner:GetEyeTrace().Entity
		if IsValid(Owner.WeaponRPT["Fine"]) then 

			-- Check if the entity is a vehicle or a player 
			if Owner.WeaponRPT["Fine"]:IsPlayer() or Owner.WeaponRPT["Fine"]:IsVehicle() then 

				-- Check if the Police Man is near the entity 
				if Owner:GetPos():DistToSqr(Owner.WeaponRPT["Fine"]:GetPos()) < 140^2 then 

					-- Check if the player can add a fine 
					if not Owner:isCP() then 
						Realistic_Police.SendNotify(Owner, Realistic_Police.GetSentence("noGoodJob"))
						return 
					end 

					-- Check if the Player can have a fine 
					if Owner.WeaponRPT["Fine"]:IsPlayer() then 
						if Owner.WeaponRPT["Fine"]:isCP() then 
							Realistic_Police.SendNotify(Owner, Realistic_Police.GetSentence("userCantReceiveFine"))
							return 
						end 
					end 

					-- Check if this type of vehicle can have a fine 
					if Owner.WeaponRPT["Fine"]:IsVehicle() then 
						if Realistic_Police.VehicleCantHaveFine[Owner.WeaponRPT["Fine"]:GetVehicleClass()] then 
							Realistic_Police.SendNotify(Owner, Realistic_Police.GetSentence("vehicleCantHaveFine"))
							return 
						end 
					end

					-- Send information about the type of the entity if it's a player or a vehicle 	
					local RPTCheck = nil 
					if Owner.WeaponRPT["Fine"]:IsPlayer() then 
						Owner.WeaponRPT["Fine"]:Freeze(true)
						RPTCheck = false 
					else 
						RPTCheck = true 
					end 

					-- Remove the Unfreeze timer of the player 
					if timer.Exists("rpt_stungun_unfreeze"..Owner.WeaponRPT["Fine"]:EntIndex()) then 
						timer.Remove("rpt_stungun_unfreeze"..Owner.WeaponRPT["Fine"]:EntIndex()) 
					end 

					net.Start("RealisticPolice:Open") 
						net.WriteString("OpenFiningMenu")
						net.WriteBool(RPTCheck)
					net.Send(Owner)
				end 
			end 
		end 
	end 
end 

function SWEP:SecondaryAttack() end 

