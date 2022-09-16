AddCSLuaFile()

game.AddParticles("particles/ztm_trashburner_vfx.pcf")
PrecacheParticleSystem("ztm_burn")
PrecacheParticleSystem("ztm_smoke")

game.AddParticles("particles/ztm_trash_vfx.pcf")
PrecacheParticleSystem("ztm_trash_break")
PrecacheParticleSystem("ztm_trash_break01")
PrecacheParticleSystem("ztm_trash_break02")
PrecacheParticleSystem("ztm_trash_break03")


game.AddParticles("particles/ztm_trashcollector_vfx.pcf")
PrecacheParticleSystem("ztm_air_burst")
PrecacheParticleSystem("ztm_airsuck")
PrecacheParticleSystem("ztm_airsuck_trash")

game.AddParticles("particles/ztm_leafpile_vfx.pcf")
PrecacheParticleSystem("ztm_leafpile_explode")

game.AddParticles("particles/ztm_recycler_vfx.pcf")
PrecacheParticleSystem("ztm_trashfall")


util.PrecacheModel("models/zerochain/props_trashman/ztm_manhole_stencil.mdl")
util.PrecacheModel("models/zerochain/props_trashman/ztm_buyermachine_stencil.mdl")
util.PrecacheModel("models/zerochain/props_trashman/ztm_recycleblock.mdl")
