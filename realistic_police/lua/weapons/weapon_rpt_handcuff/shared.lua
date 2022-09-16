
AddCSLuaFile()

SWEP.PrintName = "HandCuff"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.Category = "Realistic Police"

SWEP.ViewModel = Model("models/realistic_police/handcuffs/c_handcuffs.mdl")
SWEP.WorldModel = Model("models/realistic_police/handcuffs/w_handcuffs.mdl")
SWEP.ViewModelFOV = 80
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

function SWEP:PrimaryAttack()
	local Owner = self:GetOwner()
	local ply = Owner:GetEyeTrace().Entity 

	Owner.AntiSpam = Owner.AntiSpam or CurTime()
	if Owner.AntiSpam > CurTime() then return end 
	Owner.AntiSpam = CurTime() + 1 

	-- Check if the Police Man Can Cuff the player
	if not Owner:isCP() then 
		if SERVER then 
			Realistic_Police.SendNotify(Owner, Realistic_Police.GetSentence("noGoodJobToArrestuser")) 
		end
		return 
	end 

	-- Check if the player can be cuff or not 
	if IsValid(ply) && ply:IsPlayer() then 
		if ply:isCP() then 
			if SERVER then 
				Realistic_Police.SendNotify(Owner, Realistic_Police.GetSentence("cantArrestPlayer")) 
			end 
			return
		end 
	else 
		return 
	end 

	if SERVER then 
	
		if ply.WeaponRPT["Cuff"] == nil or not ply.WeaponRPT["Cuff"] then 
			
			-- Freeze the Player and The police man
			ply:Freeze(true)
			Owner:Freeze(true)

			-- Remove the Unfreeze timer of the player 
			if timer.Exists("rpt_stungun_unfreeze"..ply:EntIndex()) then 
				timer.Remove("rpt_stungun_unfreeze"..ply:EntIndex()) 
			end 

			timer.Simple(self:SequenceDuration(), function()
				if IsValid(ply) && IsValid(Owner) then 
					Realistic_Police.Cuff(ply, Owner)

					if IsValid(ply)	then ply:Freeze(false) end 
					if IsValid(Owner) then Owner:Freeze(false) end 
				end 
			end ) 

			-- Send the Weapon Animation and the weapon sound 
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self:SetNextPrimaryFire( CurTime() + 4 )

			-- Play the idle animation next the primary attack
			timer.Create("rpt_animation"..self:GetOwner():EntIndex(), self:SequenceDuration(), 1, function()	
				if IsValid(self) && IsValid(Owner) then 		
					if Owner:GetActiveWeapon() == self then
						self:SendWeaponAnim( ACT_VM_IDLE )
					end 
				end 
			end ) 

		elseif ply.WeaponRPT["Cuff"] then 

			-- Freeze the Player and The police man
			ply:Freeze(true)
			Owner:Freeze(true)

			-- Remove the Unfreeze timer of the player 
			if timer.Exists("rpt_stungun_unfreeze"..ply:EntIndex()) then 
				timer.Remove("rpt_stungun_unfreeze"..ply:EntIndex()) 
			end 

			timer.Simple(self:SequenceDuration(), function()
				if IsValid(ply) && IsValid(Owner) then 
					Realistic_Police.UnCuff(ply, Owner)

					if IsValid(ply)	then ply:Freeze(false) end 
					if IsValid(Owner) then Owner:Freeze(false) end 
				end 
			end ) 

			-- Send the Weapon Animation and the weapon sound 
			self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			self:SetNextSecondaryFire( CurTime() + 4 )

			-- Play the idle animation next the primary attack
			timer.Create("rpt_animation"..self:GetOwner():EntIndex(), self:SequenceDuration(), 1, function()	
				if IsValid(self) && IsValid(Owner) then 		
					if Owner:GetActiveWeapon() == self then
						self:SendWeaponAnim( ACT_VM_IDLE )
					end 
				end 
			end ) 
		end 
	end 

	self.Weapon:EmitSound("rpthandcuffleftclick.mp3") 
end 

function SWEP:SecondaryAttack() 
	local Owner = self:GetOwner()
	local ply = Owner:GetEyeTrace().Entity 

	Owner.AntiSpam = Owner.AntiSpam or CurTime()
	if Owner.AntiSpam > CurTime() then return end 
	Owner.AntiSpam = CurTime() + 1 

	if SERVER then 
		-- Check if the Player is Near the Police Man 
		if IsValid(ply) && IsValid(Owner) && not ply:IsVehicle() then 

			if istable(ply.WeaponRPT) then 
				if ply.WeaponRPT["Cuff"] then 
					Realistic_Police.Drag(ply, Owner)
				end 
			end 

		elseif ply:IsVehicle() then 

			if IsValid(Owner.WeaponRPT["Drag"]) then 
				Owner.WeaponRPT["Drag"].WeaponRPT["EnterExit"] = false 
				Owner.WeaponRPT["Drag"]:EnterVehicle(Realistic_Police.PlaceVehicle(Owner, ply))
				Owner.WeaponRPT["Drag"].WeaponRPT["EnterExit"] = true
				
				-- Reset Drag Player 
				Owner.WeaponRPT["Drag"].WeaponRPT["DragedBy"] = nil 
				Owner.WeaponRPT["Drag"] = nil 
			else 
				if istable(ply:VC_getPlayers()) then 
					for k,v in pairs(ply:VC_getPlayers()) do 
						if v.WeaponRPT["Cuff"] then 
							v.WeaponRPT["EnterExit"] = false 
							v:ExitVehicle()
							v.WeaponRPT["EnterExit"] = true 
						end 
					end  
				end 
			end 
		end 
	end 
end 

function SWEP:Reload()
	local Owner = self:GetOwner()
	local ply = Owner:GetEyeTrace().Entity

	Owner.AntiSpam = Owner.AntiSpam or CurTime()
	if Owner.AntiSpam > CurTime() then return end 
	Owner.AntiSpam = CurTime() + 1 

	if SERVER then 
		if IsValid(ply) && ply.WeaponRPT["Cuff"] && istable(ply.WeaponRPT["Weapon"]) then 
			-- Open the inspect menu for confiscate weapons 
			net.Start("RealisticPolice:HandCuff")
				net.WriteString("Inspect")
				net.WriteEntity(ply)
				net.WriteTable(ply.WeaponRPT["Weapon"])
			net.Send(Owner)
		end 
	end 
end 

function SWEP:Deploy()
	local Owner = self:GetOwner()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:EmitSound("rpthandcuffdeploy.mp3")
	-- Play the idle animation next the primary attack
	timer.Create("rpt_animation"..self:GetOwner():EntIndex(), self:SequenceDuration(), 1, function()	
		if IsValid(self) && IsValid(Owner) then 		
			if Owner:GetActiveWeapon() == self then
				self:SendWeaponAnim( ACT_VM_IDLE )
			end 
		end 
	end ) 
end 

