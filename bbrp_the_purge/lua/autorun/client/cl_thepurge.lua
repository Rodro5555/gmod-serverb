include("autorun/config.lua")
local Fonts = {}
Fonts["William_Bebas"] = "BebasNeue"

for a, b in pairs(Fonts) do
	for k = 10, 70 do
		surface.CreateFont(a .. "_S" .. k, {
			font = b,
			size = k,
			weight = 300,
			antialias = true
		})

		surface.CreateFont(a .. "Out_S" .. k, {
			font = b,
			size = k,
			weight = 300,
			antialias = true,
			outline = true
		})
	end
end

--[[function GetIsPurge(um)
	IsPurge = um:ReadBool() or false
end

usermessage.Hook("IsPurge", GetIsPurge)]]--
	IsPurge = false
net.Receive("IsPurge", function()
	IsPurge = net.ReadBool()
end)

function PurgeClient()
	if PURGEMODE then
		net.Receive("PurgeCountdown", function()
			PURGEtime = net.ReadFloat() or 1
		end)

		PURGEtime = PURGEtime or 1
		--local time = SetPurgeTimer
		local minutes = math.floor(PURGEtime / 60)
		local sec = PURGEtime - (minutes * 60)
		local dots = ":"

		if sec < 10 then
			dots = ":0"
		end

		local actualtime = tonumber(minutes) .. dots .. tonumber(sec)
		local cin = (math.sin(CurTime()) + 1) / 2

		local col = Color(255,0,0,255)
		puls = math.abs( math.sin( CurTime() * 1 ) )
		local colpuls = Color(255, 255, 255, 255)

		if PURGEtime <= PURGE.PlayPurgeSoundStart or IsPurge then
			 colpuls = Color(  col.r - (puls*130), col.g - (puls*130), col.b  - (puls*130))
			 outcol = Color(0, 0, 0, 255)
		else
		 	 colpuls = Color(255, 255, 255, 255)
			 outcol = Color(100, 0, 0, 180)
		end

		if IsPurge then
			draw.SimpleTextOutlined("La Purga termina en", "William_Bebas_S27", ScrW() / 2, 5, colpuls, TEXT_ALIGN_CENTER, 0, 1, outcol)

			if PURGEtime == PURGE.PlayPurgeSoundEnd then
				timer.Create("PurgeSoundDelay", 0.2, 1, function()
					surface.PlaySound(PURGE.EndSound)
				end)
			end
		else
			draw.SimpleTextOutlined("La Purga empieza en", "William_Bebas_S27", ScrW() / 2, 5, colpuls, TEXT_ALIGN_CENTER, 0, 1, outcol)

			if PURGEtime == PURGE.PlayPurgeSoundStart then
				timer.Create("PurgeSoundDelay", 0.2, 1, function()
					surface.PlaySound(PURGE.StartSound)
				end)
			end
		end

		draw.SimpleTextOutlined(actualtime, "William_Bebas_S27", ScrW() / 2, 30, colpuls, TEXT_ALIGN_CENTER, 0, 1, outcol)
	end
end

hook.Add("HUDPaint", "PurgeTimerStuff", PurgeClient)
timer.Simple(1, PurgeClient)
hook.Add("PlayerInitialSpawn", "ShowPurgeOnJoin", PurgeClient)
