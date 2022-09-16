zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

local vmAnims = {ACT_VM_HITCENTER, ACT_VM_HITKILL}


function zrmine.f.Pickaxe_ReturnStorage(swep)
	local amount = swep:GetIron() + swep:GetBronze() + swep:GetSilver() + swep:GetGold() + swep:GetCoal()

	return amount
end


function zrmine.f.Pickaxe_HasStorageSpace(swep)
	local amount = zrmine.f.Pickaxe_ReturnStorage(swep)

	if (amount < swep:GetOreInv()) then
		return true
	else
		return false
	end
end




function zrmine.f.Pickaxe_ResourceCap(amount, cap)
	if (amount > cap) then
		amount = cap
	end

	return amount
end

function zrmine.f.Pickaxe_CalcNeedAmount(swep,hAmount, nAmount)
	local famount

	if (hAmount > nAmount) then
		famount = zrmine.f.Pickaxe_ResourceCap(nAmount, swep:GetFillCap())
	else
		famount = zrmine.f.Pickaxe_ResourceCap(hAmount, swep:GetFillCap())
	end

	return famount
end

if SERVER then

	//Init
	function zrmine.f.Pickaxe_Initialize(swep)
		swep.HitCounter = 0
		swep.NextXP = math.random(zrmine.config.Pickaxe_MinNextXP, zrmine.config.Pickaxe_MaxNextXP)
	end


	// LeftClick Input
	function zrmine.f.Pickaxe_Primary(ply, swep)
		local tr = ply:GetEyeTrace()
		local trEnt = tr.Entity

		if (swep:GetCoolDown() - CurTime()) < 0 then

			if IsValid(trEnt) and trEnt:GetClass() == "zrms_ore" then

				zrmine.f.Pickaxe_HitOre(ply, swep, trEnt, tr)
			else

				swep:SetNextCoolDown(1)
				swep:SetCoolDown(CurTime() + swep:GetNextCoolDown())
				swep:SendWeaponAnim(ACT_VM_MISSCENTER)
				ply:SetAnimation(PLAYER_ATTACK1)
				ply:ViewPunch(Angle(-1, 0, 0))
			end
		end
	end

	// Player Hit a Ore Entity
	function zrmine.f.Pickaxe_HitOre(ply,swep,ore,trace)

		// Is the player close enough to the ore entity
		if zrmine.f.InDistance(ply:GetPos(), ore:GetPos(), 100) then

			// If the pickaxe invenotry dont has space anymore then we stop
			if not zrmine.f.Pickaxe_HasStorageSpace(swep) then

				zrmine.f.Notify(ply, zrmine.language.Pickaxe_InvFull, 1)
				return
			end

			if not zrmine.f.OreSpawn_HasResource(ore) then return end

			local harvestType = ore:GetResourceType()

			// The required pickaxe level
			local ReqLvl = zrmine.config.Pickaxe_OreRestriction[harvestType]


			local harvestMul = zrmine.config.Pickaxe_HarvestMul[harvestType]

			// Generate new cooldown
			local harvestIntervalMul = swep:GetHarvestInterval() * harvestMul.Speed
			swep:SetNextCoolDown(harvestIntervalMul)
			swep:SetCoolDown(CurTime() + swep:GetNextCoolDown())

			// If we dont have a high enough level for that ore then we stop
			if swep:GetPlayerLVL() < ReqLvl then
				local str = zrmine.language.OreRestriction
				str = string.Replace(str,"$OreType",harvestType)
				zrmine.f.Notify(ply, str .. " [Level " .. ReqLvl .. "]", 1)
				return
			end

			local harvestamount = swep:GetHarvestAmount() * harvestMul.Amount
			local harvestedResourceType = zrmine.f.OreSpawn_Harvest(ore, harvestamount)

			// Add harvested ressource type to pickaxe
			for k, v in pairs(harvestedResourceType) do
				if (k == "Iron") then
					swep:SetIron(swep:GetIron() + v)
				elseif (k == "Bronze") then
					swep:SetBronze(swep:GetBronze() + v)
				elseif (k == "Silver") then
					swep:SetSilver(swep:GetSilver() + v)
				elseif (k == "Gold") then
					swep:SetGold(swep:GetGold() + v)
				elseif (k == "Coal") then
					swep:SetCoal(swep:GetCoal() + v)
				end
			end

			// If the player pickaxe level has not reached max then we call the xp logic
			zrmine.f.Pickaxe_LevelSystem(swep,ply,harvestMul)

			// Custom Hook
			hook.Run("zrmine_OnPickaxeHit", ply, trace.HitPos,ore)

			// If we harvested something then we create the harvest effect
			if (harvestedResourceType[1] ~= "Nothing") then
				zrmine.f.CreateNetEffect("pickaxe_hit",trace.HitPos)
			end

			// Play the Hit Animation on View & World Model
			swep:SendWeaponAnim(vmAnims[math.random(#vmAnims)])
			ply:SetAnimation(PLAYER_ATTACK1)
			ply:ViewPunch(Angle(-1, 0, 0))
		end
	end

	function zrmine.f.Pickaxe_LevelSystem(swep,ply,HarvestMul)

		zrmine.data.PlayerVarCheck(ply)

		if (ply.zrms.lvl < (table.Count(zrmine.config.Pickaxe_Lvl) - 1)) then
			swep.HitCounter = swep.HitCounter + 1

			if (swep.HitCounter > swep.NextXP) then
				swep.HitCounter = 0

				local finalXP = hook.Run("zrmine_XPModify",ply, HarvestMul.XP)

				zrmine.lvlsys.AddXP(ply, finalXP)
				swep.NextXP = math.random(zrmine.config.Pickaxe_MinNextXP, zrmine.config.Pickaxe_MaxNextXP)

				zrmine.f.Pickaxe_UpdateLvlVar(swep,ply)
			end
		end
	end

	// Updates our Pickaxe LevelSystem Vars
	function zrmine.f.Pickaxe_UpdateLvlVar(swep,ply)

		zrmine.data.PlayerVarCheck(ply)

		local plyLvl = zrmine.lvlsys.ReturnLvl(ply)

		swep:SetPlayerXP(zrmine.lvlsys.HasXP(ply))
		swep:SetPlayerLVL(plyLvl)
		swep:SetHarvestAmount(zrmine.config.Pickaxe_Lvl[plyLvl].HarvestAmount)
		swep:SetHarvestInterval(zrmine.config.Pickaxe_Lvl[plyLvl].HarvestInterval)
		swep:SetOreInv(zrmine.config.Pickaxe_Lvl[plyLvl].OreInv)
		swep:SetFillCap(zrmine.config.Pickaxe_Lvl[plyLvl].FillCap)

		// Has to happen on server for now
		// Changes the skin of the world model
		local maxLvl = table.Count(zrmine.config.Pickaxe_Lvl)
		if (plyLvl >= math.Round(maxLvl * 0.8)) then
			swep:SetSkin(2)
		elseif (plyLvl >= math.Round(maxLvl * 0.3)) then
			swep:SetSkin(1)
		else
			swep:SetSkin(0)
		end

		// Updates the viewmodel skin
		zrmine.f.Pickaxe_UpdateVMSkin(swep,ply)
	end

	// Updates the viewmodel skin of pickaxe
	function zrmine.f.Pickaxe_UpdateVMSkin(swep,ply)
		if not IsValid(swep) then return end
		if not IsValid(ply) then return end

		local vm = ply:GetViewModel()
		local plyLvl = swep:GetPlayerLVL()
		local maxLvl = table.Count(zrmine.config.Pickaxe_Lvl)

		if (plyLvl >= math.Round(maxLvl * 0.8)) then
			// Gold
			vm:SetSkin(2)

		elseif (plyLvl >= math.Round(maxLvl * 0.3)) then
			// Bronze
			vm:SetSkin(1)
		else
			// Iron
			vm:SetSkin(0)
		end

		zrmine.f.Debug("VM Skin Updated!")
	end



	// RightClick Input
	function zrmine.f.Pickaxe_Secondary(ply, swep)
		local tr = ply:GetEyeTrace()
		local trEnt = tr.Entity

		if IsValid(trEnt) and zrmine.f.InDistance(ply:GetPos(), trEnt:GetPos(), 100) and (trEnt:GetClass() == "zrms_crusher" or trEnt:GetClass() == "zrms_gravelcrate") then
			// Is the Crusher Full?
			if (trEnt:GetClass() == "zrms_crusher" and zrmine.f.General_ReturnStorage(trEnt) >= zrmine.config.Crusher_Capacity) then
				zrmine.f.Notify(ply, zrmine.language.Crusher_Full, 1)
				return
			end

			// Is the Gravel Crate full?
			if (trEnt:GetClass() == "zrms_gravelcrate" and zrmine.f.Gravelcrate_ReturnStoredAmount(trEnt) >= zrmine.config.GravelCrates_Capacity) then
				zrmine.f.Notify(ply, zrmine.language.Crate_Full, 1)

				return
			end

			local rTable = {}
			rTable["Iron"] = swep:GetIron() or 0
			rTable["Bronze"] = swep:GetBronze() or 0
			rTable["Silver"] = swep:GetSilver() or 0
			rTable["Gold"] = swep:GetGold() or 0
			rTable["Coal"] = swep:GetCoal() or 0

			local iron = 0
			local bronze = 0
			local silver = 0
			local gold = 0
			local coal = 0

			// Generate the Exact ressource amount that fit in to the Crusher or gravelCrate
			for k, v in pairs(rTable) do
				if (v > 0) then
					local needAmount

					if (trEnt:GetClass() == "zrms_crusher") then
						needAmount = zrmine.config.Crusher_Capacity - zrmine.f.General_ReturnStorage(trEnt)
					elseif (trEnt:GetClass() == "zrms_gravelcrate") then
						needAmount = zrmine.config.GravelCrates_Capacity - zrmine.f.Gravelcrate_ReturnStoredAmount(trEnt)
					end

					local capAmount = zrmine.f.Pickaxe_CalcNeedAmount(swep,v, needAmount)

					if (k == "Iron") then
						iron = capAmount
						swep:SetIron(swep:GetIron() - iron)
					elseif (k == "Bronze") then
						bronze = capAmount
						swep:SetBronze(swep:GetBronze() - bronze)
					elseif (k == "Silver") then
						silver = capAmount
						swep:SetSilver(swep:GetSilver() - silver)
					elseif (k == "Gold") then
						gold = capAmount
						swep:SetGold(swep:GetGold() - gold)
					elseif (k == "Coal") then
						coal = capAmount
						swep:SetCoal(swep:GetCoal() - coal)
					end

					break
				end
			end

			local gTable = {}
			gTable["Iron"] = iron
			gTable["Bronze"] = bronze
			gTable["Silver"] = silver
			gTable["Gold"] = gold
			gTable["Coal"] = coal
			local amount = iron + bronze + silver + gold + coal

			if (amount > 0) then
				if (trEnt:GetClass() == "zrms_crusher") then
					zrmine.f.Crusher_AddResource_SWEP(trEnt, gTable, ply)
				elseif (trEnt:GetClass() == "zrms_gravelcrate") then
					zrmine.f.Gravelcrate_AddResource(trEnt, gTable, ply)
				end

				zrmine.f.CreateNetEffect("pickaxe_empty",tr.HitPos)
			end
		end
	end



	// Not used at the moment
	function zrmine.f.Pickaxe_CreateDecal(tr)
		local Pos1 = tr.HitPos + tr.HitNormal
		local Pos2 = tr.HitPos - tr.HitNormal
		util.Decal("Dark", Pos1, Pos2)
	end
end
