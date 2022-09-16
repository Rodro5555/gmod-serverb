zrush = zrush or {}
zrush.util = zrush.util or {}

function zrush.Print(msg)
	print("[Zero´s OilRush] " .. msg)
end

if CLIENT then
	function zrush.util.LoopedSound(ent, soundfile, shouldplay,pitch)
		if shouldplay and zclib.util.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 2000) then
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] == nil then
				ent.Sounds[soundfile] = CreateSound(ent, soundfile)
			end

			// If the sound is not playing or it should be updated then start/restart the sound
			if ent.Sounds[soundfile]:IsPlaying() == false or ent.UpdateSound then
				ent.Sounds[soundfile]:Play()
				ent.Sounds[soundfile]:ChangeVolume(1, 0)
				ent.Sounds[soundfile]:ChangePitch(pitch, 1)

				ent.UpdateSound = false
			end
		else
			if ent.Sounds == nil then
				ent.Sounds = {}
			end

			if ent.Sounds[soundfile] ~= nil and ent.Sounds[soundfile]:IsPlaying() == true then
				ent.Sounds[soundfile]:ChangeVolume(0, 0)
				ent.Sounds[soundfile]:Stop()
				ent.Sounds[soundfile] = nil
			end
		end
	end
end
