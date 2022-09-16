
AddCSLuaFile()

SWEP.PrintName = "Wrench"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.Category = "Realistic Police"

SWEP.ViewModel = Model( "models/weapons/sycreations/Kobralost/v_ajustableWrench.mdl" )
SWEP.WorldModel = Model( "models/weapons/sycreations/Kobralost/w_ajustableWrench.mdl" )

SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.HitDistance = 48

function SWEP:Initialize()
	self:SetHoldType( "slam" )
end

function SWEP:PrimaryAttack()
	if ( CLIENT ) then return end
	local Owner = self:GetOwner()
	local ply = Owner:GetEyeTrace().Entity 

	-- Check if the entity trace is a camera 
	if IsValid(ply) && ply:GetClass() == "realistic_police_camera" then 

		-- Check if the player is near the entity 
		if Owner:GetPos():DistToSqr(ply:GetPos()) < 125^2 then 

			-- Check if the Camera is broke 
			if ply.DestroyCam then 

				-- Check if the Player have the correct job for repair the camera 
				if Realistic_Police.CameraWorker[team.GetName(Owner:Team())] then 

					-- Play the Primary Attack animation 
					Owner:Freeze(true)
					self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

					timer.Create("rpt_repair_camera2"..Owner:EntIndex(), 5, (Realistic_Police.CameraRepairTimer/5) - 1, function()
						if IsValid(Owner) then 
							self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
						end 
					end)

					-- Create Movement on the camera of the player 
					local Punch = { 0.1, 0.5, 1, 1.2, 0.3, -0.5, -0.9, -1.6, -0.4, -0.8 }
					timer.Create("rpt_repeat_anim"..Owner:EntIndex(), 1, Realistic_Police.CameraRepairTimer, function()
						if IsValid(Owner) then 
							Owner:ViewPunch( Angle( table.Random(Punch), table.Random(Punch), table.Random(Punch) ) )
						end 
					end)

					-- Reset Rotation , Player Active Sequence and Reset Health of the camera 
					timer.Create("rpt_camera_repair"..Owner:EntIndex(), Realistic_Police.CameraRepairTimer, 1, function()
						if IsValid(ply) then 
							-- Reset Camera Information
							ply:ResetSequence("active")
							ply:SetSequence("active")
							ply.HealthEntity = Realistic_Police.CameraHealth 
							ply:SetRptCam(false)
							ply.DestroyCam = false 

							-- Unfreeze the Player && give the money 
							Owner:Freeze(false)
							Owner:addMoney(Realistic_Police.CameraGiveMoney)
							Realistic_Police.SendNotify(Owner, Realistic_Police.GetSentence("youWon").." "..DarkRP.formatMoney(Realistic_Police.CameraGiveMoney))
						end 
					end ) 
				end 
			end
		end 
	end 
end

function SWEP:SecondaryAttack() end 

function SWEP:Holster() 
	if SERVER then 
		self:GetOwner():Freeze(false)
		timer.Remove("rpt_camera_repair"..self:GetOwner():EntIndex())
		timer.Remove("rpt_repair_camera2"..self:GetOwner():EntIndex())
		timer.Remove("rpt_repeat_anim"..self:GetOwner():EntIndex())
		self:SendWeaponAnim( ACT_VM_IDLE )
	end 
	return true 
end 