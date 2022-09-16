PURGEMODE = true
PURGE = PURGE or {} -- If The Purge should be enabled [Default: true]
PURGE.CountdownTimer =  75 * 60 -- Time until The Purge will start [Default: 60 * 60] 60 Minutes
PURGE.EndCountdownTimer = 10 * 60 -- Time until The Purge will end [Default: 60 * 12] 12 minutes
PURGE.PlayPurgeSoundStart = 55 -- Seconds before The Purge starts, when it should play the starting sound [Default: 55] 55 Seconds
PURGE.PlayPurgeSoundEnd = 1 -- Seconds before The Purge ends, when it should play the end sound [Default: 1] 1 second
PURGE.StartSound = "purge/thepurge.mp3" -- The Sound that should play before The Purge starts [Default: "purge/thepurge.mp3"]
PURGE.EndSound = "purge/thepurgeend.mp3" -- The Sound that should play when The Purge ends [Default: "purge/thepurge.mp3"]

PURGE.RestrictedWeapons = {
  "arrest_stick", "weapon_rpt_handcuff", "weapon_rpt_stungun", "door_ram"
}

PURGE.PayPerPlace = {
  [1] = 50000,
  [2] = 25000,
  [3] = 10000
}
