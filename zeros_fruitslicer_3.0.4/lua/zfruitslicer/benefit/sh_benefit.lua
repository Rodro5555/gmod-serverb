zfs = zfs or {}
zfs.Benefit = zfs.Benefit or {}
zfs.Benefit.List = zfs.Benefit.List or {}

function zfs.Benefit.Get(id)
	return zfs.Benefit.List[id]
end

function zfs.Benefit.GetIcon(id)
	local dat = zfs.Benefit.Get(id)
	return dat.icon
end

function zfs.Benefit.Execute(id,ply,ToppingID)
	local dat = zfs.Benefit.Get(id)
	dat.action(ply,ToppingID)
end

local function AddBenefit(key, data)
	zfs.Benefit.List[key] = data
end

-- Getting Health
AddBenefit("Health", {
	icon = Material("materials/zfruitslicer/ui/zfs_ui_benefit_health_icon.png", "smooth"),
	action = function(ply, ID)
		-- This is the only ability that can be from a Smoothie or Topping
		local extraHealth = zfs.config.Toppings[ID].ToppingBenefits["Health"]
		local newHealth = ply:Health() + extraHealth

		if zfs.config.Health.HealthCap and newHealth > ply:GetMaxHealth() then
			newHealth = ply:GetMaxHealth()
			zclib.Notify(ply, zfs.language.Benefit.CantAdd_ExtraHealth, 1)

			return
		end

		ply:SetHealth(newHealth)
		-- This make a nice health effect
		zfs.Benefit.Effect("zfs_health_effect", ply, 3)
	end
})

-- Creates a particle effect
AddBenefit("ParticleEffect", {
	icon = Material("materials/zfruitslicer/ui/zfs_ui_benefit_vfx_icon.png", "smooth"),
	action = function(ply, ID)
		local EffectName = zfs.config.Toppings[ID].ToppingBenefits["ParticleEffect"]
		local EffectDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration
		zfs.Benefit.Effect(EffectName, ply, EffectDuration)
	end
})

-- Gives the Player a SpeedBoost
AddBenefit("SpeedBoost", {
	icon = Material("materials/zfruitslicer/ui/zfs_ui_benefit_speedboost_icon.png", "smooth"),
	action = function(ply, ID)
		local SpeedBoost = zfs.config.Toppings[ID].ToppingBenefits["SpeedBoost"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasSpeedBoost) then
			zclib.Notify(ply, zfs.language.Benefit.CantAdd_Speedboost, 1)

			return
		end

		ply.zfs_SpeedBoostMul = SpeedBoost or 1
		ply.zfs_HasSpeedBoost = true
		zfs.Benefit.Inform(ply, BenefitDuration, "SpeedBoost")
		ply.zfs_speedboost_trail = util.SpriteTrail(ply, ply:LookupAttachment("chest"), zfs.default_colors["cyan02"], true, 100, 1, 4, 1 / (15 + 1) * 0.5, "trails/laser.vmt")
		local timerid = "zfs_player_benefit_speedboost_" .. ply:EntIndex()
		zclib.Timer.Remove(timerid)
		zclib.Timer.Create(timerid, BenefitDuration, 1, function()
			if not IsValid(ply) then return end

			if (ply.zfs_speedboost_trail and IsValid(ply.zfs_speedboost_trail)) then
				ply.zfs_speedboost_trail:Remove()
			end

			ply.zfs_HasSpeedBoost = false
			zclib.Timer.Remove(timerid)
		end)
	end
})

-- Makes the Player feel very light
AddBenefit("AntiGravity", {
	icon = Material("materials/zfruitslicer/ui/zfs_ui_benefit_antigravity_icon.png", "smooth"),
	action = function(ply, ID)
		local JumpBoost = zfs.config.Toppings[ID].ToppingBenefits["AntiGravity"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasAntiGravity) then
			zclib.Notify(ply, zfs.language.Benefit.CantAdd_AntiGravity, 1)

			return
		end

		ply.zfs_HasAntiGravity = true
		ply.zfs_old_JumpPower = ply:GetJumpPower()
		ply:SetGravity(0.5)
		ply:SetJumpPower(ply:GetJumpPower() + JumpBoost)
		zfs.Benefit.Inform(ply, BenefitDuration, "AntiGravity")
		local timerid = "zfs_player_benefit_antigravity_" .. ply:EntIndex()
		zclib.Timer.Remove(timerid)
		zclib.Timer.Create(timerid, BenefitDuration, 1, function()
			if not IsValid(ply) then return end
			ply:SetGravity(1)
			ply:SetJumpPower(ply.zfs_old_JumpPower)
			zclib.Timer.Remove(timerid)

			-- Lets make sure the Player dont gets hurt so we add 3 seconds before he can recive fall damage again
			timer.Simple(BenefitDuration + 3, function()
				if IsValid(ply) then
					ply.zfs_HasAntiGravity = false
				end
			end)
		end)
	end
})

-- Makes the Player nearly invisible
AddBenefit("Ghost", {
	icon = Material("materials/zfruitslicer/ui/zfs_ui_benefit_ghost_icon.png", "smooth"),
	action = function(ply, ID)
		local PlayerAlpha = zfs.config.Toppings[ID].ToppingBenefits["Ghost"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		if (ply.zfs_HasGhost) then
			zclib.Notify(ply, zfs.language.Benefit.CantAdd_Ghost, 1)

			return
		end

		ply.zfs_HasGhost = true
		ply.zfs_BaseColor = ply:GetColor()
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetRenderFX(kRenderFxPulseFast)
		ply:SetColor(Color(0, 255, 0, PlayerAlpha))
		zfs.Benefit.Inform(ply, BenefitDuration, "Ghost")

		local timerid = "zfs_player_benefit_ghost_" .. ply:EntIndex()
		zclib.Timer.Remove(timerid)
		zclib.Timer.Create(timerid, BenefitDuration, 1, function()
			if not IsValid(ply) then return end
			ply.zfs_HasGhost = false
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor(ply.zfs_BaseColor or Color(255, 255, 255, 255))
			ply:SetRenderFX(kRenderFxNone)
			zclib.Timer.Remove(timerid)
		end)
	end
})

-- Gives the Player a trippy ScreenEffect
AddBenefit("Drugs", {
	icon = Material("materials/zfruitslicer/ui/zfs_ui_benefit_drugs_icon.png", "smooth"),
	action = function(ply, ID)
		local ScreenEffectName = zfs.config.Toppings[ID].ToppingBenefits["Drugs"]
		local BenefitDuration = zfs.config.Toppings[ID].ToppingBenefit_Duration

		zfs.Benefit.ScreenEffect(ScreenEffectName, ply, BenefitDuration)
		zfs.Benefit.Inform(ply, BenefitDuration, "Drugs")

		local timerid = "zfs_player_benefit_drugs_" .. ply:EntIndex()
		zclib.Timer.Remove(timerid)
		zclib.Timer.Create(timerid, BenefitDuration, 1, function()
			if not IsValid(ply) then return end
			zclib.Timer.Remove(timerid)
		end)
	end
})
