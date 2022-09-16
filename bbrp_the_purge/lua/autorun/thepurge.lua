include("config.lua")
AddCSLuaFile("client/cl_thepurge.lua")

if SERVER then
  util.AddNetworkString("PurgeCountdown")
  util.AddNetworkString("IsPurge")
  IsPurge = false
  SetPurgeTimer = PURGE.CountdownTimer

  function StartPurgeTimer()
    if PURGEMODE then
      timer.Create("countdownpurge", 1, 1, function()
        if IsPurge == false then
          SetPurgeTimer = SetPurgeTimer - 1
          StartPurgeTimer()

          if SetPurgeTimer < 1 then
            IsPurge = true
            SetPurgeTimer = PURGE.EndCountdownTimer

            for k, v in pairs(player.GetAll()) do
              v:PrintMessage(HUD_PRINTTALK, "La purga ha iniciado!")
            end
          end
        else
          SetPurgeTimer = SetPurgeTimer - 1
          StartPurgeTimer()

          if SetPurgeTimer < 1 then
            IsPurge = false
            SetPurgeTimer = PURGE.CountdownTimer

            for k, v in pairs(player.GetAll()) do
              v:PrintMessage(HUD_PRINTTALK, "La purga ha terminado!")
            end
          end
        end
      end)

      net.Start("IsPurge")
      net.WriteBool(IsPurge)
      net.Broadcast()

      net.Start("PurgeCountdown")
      net.WriteFloat(SetPurgeTimer)
      net.Broadcast()
    end
  end

  hook.Add("PlayerSwitchWeapon", "PurgeWeaponStrict", function(ply, old, new)
    if IsPurge then
          if table.HasValue(PURGE.RestrictedWeapons, new:GetClass()) then
            return true
        end
    end
  end)

  hook.Add("PlayerInitialSpawn", "SendPurgeTimer", function(ply)
    net.Start("PurgeCountdown")
    net.WriteFloat(SetPurgeTimer)
    net.Send(ply)

    net.Start("IsPurge")
    net.WriteBool(IsPurge)
    net.Send(ply)
  end)

  timer.Simple(0, StartPurgeTimer)
end
