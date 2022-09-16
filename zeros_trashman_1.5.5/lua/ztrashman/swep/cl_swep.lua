if SERVER then return end
ztm.TrashCollector = ztm.TrashCollector or {}

// A custom loop sound function with a pitch parameter
local function LoopPitchedSound(ent,soundfile, shouldplay,pitch)

	if ent.Sounds == nil then
		ent.Sounds = {}
	end

	if shouldplay then
		if ent.Sounds[soundfile] == nil then
			ent.Sounds[soundfile] = CreateSound(ent, soundfile)
		end

		if ent.Sounds[soundfile]:IsPlaying() == false then
			ent.Sounds[soundfile]:Play()
			ent.Sounds[soundfile]:ChangeVolume(0.4, 0)
			ent.Sounds[soundfile]:ChangePitch(pitch,0)

			local ply = ent:GetOwner()
			local timerID = "ztm_swep_stoploopsounds_" .. ent:EntIndex()
			zclib.Timer.Remove(timerID)
			zclib.Timer.Create(timerID, 3, 0, function()
				if IsValid(ply) and ply:GetActiveWeapon() ~= ent and IsValid(ent) then
					ztm.TrashCollector.StopAirSound(ent)
					zclib.Timer.Remove(timerID)
				end
			end)
		end
	else
		if ent.Sounds[soundfile] ~= nil and ent.Sounds[soundfile]:IsPlaying() == true then
			ent.Sounds[soundfile]:ChangeVolume(0, 0)
			ent.Sounds[soundfile]:Stop()
			ent.Sounds[soundfile] = nil
		end
	end
end

function ztm.TrashCollector.Initialize(weapon)
	weapon:SetHoldType(weapon.HoldType)
	weapon.LastEffect = 1

	weapon.TrashIncrease = false
	weapon.LastTrash = 0
end

function ztm.TrashCollector.DrawHUD(viewmodel,player,weapon)

	if not IsValid(player) then
		ztm.TrashCollector.StopAirSound(weapon)
		zclib.Hook.Remove("PostDrawViewModel", "ztm_trashcollector")
		return
	end

	if not player:Alive() then
		ztm.TrashCollector.StopAirSound(weapon)
		zclib.Hook.Remove("PostDrawViewModel", "ztm_trashcollector")
		return
	end

	if weapon:GetClass() ~= "ztm_trashcollector" then
		ztm.TrashCollector.StopAirSound(weapon)
		zclib.Hook.Remove("PostDrawViewModel", "ztm_trashcollector")
		return
	end

	local attach = viewmodel:GetAttachment(1)
	if attach == nil then return end

	local Ang = attach.Ang
	local Pos = attach.Pos

	Ang:RotateAroundAxis(Ang:Forward(),-90)

	local _playerlevel = weapon:GetPlayerLevel()
	local _playerxp =  weapon:GetPlayerXP()
	local _playerlvldata = ztm.config.TrashSWEP.level[_playerlevel]
	local _trash = weapon:GetTrash() or 0

	cam.Start3D2D(Pos, Ang, 0.02)

		surface.SetDrawColor(ztm.default_colors["blue04"])
		surface.SetMaterial(ztm.default_materials["ztm_trashgun_interface"])
		surface.DrawTexturedRect(-200 ,-205 ,400 , 400)


		draw.DrawText(ztm.language.General["Level"] .. ":", zclib.util.FontSwitch(ztm.language.General["Level"],8,zclib.GetFont("ztm_gun_font01"),zclib.GetFont("ztm_gun_font01_small")), -150, -100, ztm.default_colors["white01"], TEXT_ALIGN_LEFT)
		draw.DrawText(ztm.language.General["Trash"] .. ":", zclib.util.FontSwitch(ztm.language.General["Level"],8,zclib.GetFont("ztm_gun_font01"),zclib.GetFont("ztm_gun_font01_small")), -150, -50, ztm.default_colors["white01"], TEXT_ALIGN_LEFT)

		draw.RoundedBox( 5, 0,-100,150,40, ztm.default_colors["black01"] )
		if _playerlevel >= table.Count(ztm.config.TrashSWEP.level) then
			draw.RoundedBox( 5, 0,-100,150,40, ztm.default_colors["blue02"] )
			draw.DrawText(ztm.language.General["Max"], zclib.GetFont("ztm_gun_font01"), 75, -100, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
		else

			local l_size = (150 / _playerlvldata.next_xp) * _playerxp
			l_size = math.Clamp(l_size,0,150)
			draw.RoundedBox( 5, 0,-100,l_size,40,ztm.default_colors["blue02"] )

			draw.DrawText(_playerlevel, zclib.GetFont("ztm_gun_font01"), 75, -100, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
		end

		draw.RoundedBox( 5, 0,-50,150,40, ztm.default_colors["black01"] )
		local t_size = (150 / _playerlvldata.inv_cap) * _trash
		t_size = math.Clamp(t_size,0,150)
		draw.RoundedBox( 5, 0,-50,t_size,40, ztm.default_colors["blue02"] )
		draw.DrawText(_trash .. ztm.config.UoW, zclib.GetFont("ztm_gun_font02"), 75, -45, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)


		local p_interval = _playerlvldata.primaty_interval
		local p_time = (weapon:GetLast_Primary() + p_interval) - CurTime()
		p_time = math.Clamp(p_time,0,99)
		local p_size = (150 / p_interval) * p_time
		p_size = math.Clamp(p_size,0,150)
		draw.RoundedBox( 5, 0,0,150,40, ztm.default_colors["black01"] )
		draw.RoundedBox(5, 0, 0, p_size, 40, zclib.util.LerpColor((1 / p_interval) * p_time, ztm.default_colors["blue02"], ztm.default_colors["red01"]))
		draw.DrawText("LMB", zclib.GetFont("ztm_gun_font02"), 75, 5, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
		draw.DrawText(ztm.language.General["Blast"] .. ":", zclib.util.FontSwitch(ztm.language.General["Blast"],9,zclib.GetFont("ztm_gun_font01"),zclib.GetFont("ztm_gun_font01_small")), -150, 0, ztm.default_colors["white01"], TEXT_ALIGN_LEFT)


		local s_interval = _playerlvldata.secondary_interval
		local s_time = (weapon:GetLast_Secondary() + s_interval) - CurTime()
		s_time = math.Clamp(s_time,0,99)
		local s_size = (150 / s_interval) * s_time
		s_size = math.Clamp(s_size,0,150)
		draw.RoundedBox( 5, 0,50,150,40, ztm.default_colors["black01"] )
		draw.RoundedBox( 5, 0,50,s_size,40, zclib.util.LerpColor((1 / s_interval) * s_time, ztm.default_colors["blue02"], ztm.default_colors["red01"]) )

		draw.DrawText("RMB", zclib.GetFont("ztm_gun_font02"), 75, 55, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
		draw.DrawText(ztm.language.General["Suck"] .. ":",  zclib.util.FontSwitch(ztm.language.General["Suck"],8,zclib.GetFont("ztm_gun_font01"),zclib.GetFont("ztm_gun_font01_small")), -150, 50, ztm.default_colors["white01"], TEXT_ALIGN_LEFT)


		surface.SetDrawColor(ztm.default_colors["white02"])
		surface.SetMaterial(ztm.default_materials["ztm_trashgun_interface"])
		surface.DrawTexturedRect(-200 ,-205 ,400 , 400)
	cam.End3D2D()
end

function ztm.TrashCollector.Think(weapon)
	local interval = ztm.config.TrashSWEP.level[weapon:GetPlayerLevel()].primaty_interval
	local pitch = 90 + ((10 / 3) * (3 - interval))
	pitch = math.Clamp(pitch, 85, 115)

	LoopPitchedSound(weapon, "ztm_airsuck_loop", weapon:GetIsCollectingTrash() and weapon.TrashIncrease == false, pitch)
	LoopPitchedSound(weapon, "ztm_trashsuck_loop", weapon.TrashIncrease, 100)

	if CurTime() > weapon.LastEffect then
		local _trash = weapon:GetTrash()

		if _trash > weapon.LastTrash then
			weapon.TrashIncrease = true
		else
			weapon.TrashIncrease = false
		end

		weapon.LastTrash = _trash

		if weapon:GetIsCollectingTrash() then
			local ve = GetViewEntity()

			if ve:GetClass() == "player" then
				local vm = LocalPlayer():GetViewModel(0)

				if weapon.TrashIncrease then
					zclib.Effect.ParticleEffectAttach("ztm_airsuck_trash", PATTACH_POINT_FOLLOW, vm, 2)
				else
					zclib.Effect.ParticleEffectAttach("ztm_airsuck", PATTACH_POINT_FOLLOW, vm, 2)
				end
			else
				if weapon.TrashIncrease then
					zclib.Effect.ParticleEffectAttach("ztm_airsuck_trash", PATTACH_POINT_FOLLOW, weapon, 1)
				else
					zclib.Effect.ParticleEffectAttach("ztm_airsuck", PATTACH_POINT_FOLLOW, weapon, 1)
				end
			end
		end

		weapon.LastEffect = CurTime() + 0.5
	end

	local m_owner = weapon:GetOwner()
	if not IsValid(m_owner) then return end

	if LocalPlayer() == m_owner and zclib.Hook.Exist("PostDrawViewModel", "ztm_trashcollector") == false then
		zclib.Hook.Add("PostDrawViewModel", "ztm_trashcollector", function(viewmodel, player, swep)
			ztm.TrashCollector.DrawHUD(viewmodel, player, swep)
		end)
	end
end

function ztm.TrashCollector.Holster(weapon)
	zclib.Hook.Remove("PostDrawViewModel", "ztm_trashcollector")
	ztm.TrashCollector.StopAirSound(weapon)
end

function ztm.TrashCollector.StopAirSound(weapon)
	weapon:StopSound("ztm_airsuck_loop")
	weapon:StopSound("ztm_trashsuck_loop")

	if weapon.Sounds == nil then return end

	for k, v in pairs(weapon.Sounds) do
		if v and v:IsPlaying() then
			v:Stop()
		end
	end
end

function ztm.TrashCollector.OnRemove(weapon)
	zclib.Timer.Remove("ztm_swep_stoploopsounds_" .. weapon:EntIndex())
	ztm.TrashCollector.StopAirSound(weapon)
end

function ztm.TrashCollector.PrimaryAttack(weapon)
	local ve = GetViewEntity()
	if ve:GetClass() == "player" then
		zclib.Effect.ParticleEffect("ztm_air_burst", ve:EyePos() + ve:EyeAngles():Forward() * 5, ve:EyeAngles())
	end
end
