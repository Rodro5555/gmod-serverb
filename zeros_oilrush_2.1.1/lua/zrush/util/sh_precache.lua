AddCSLuaFile()

game.AddParticles("particles/zrush_burner_vfx.pcf")
PrecacheParticleSystem("zrush_burner")
PrecacheParticleSystem("zrush_burner_overheat")
PrecacheParticleSystem("zrush_butangas")

game.AddParticles("particles/zrush_drill_vfx.pcf")
PrecacheParticleSystem("zrush_drillgas")
game.AddParticles("particles/zrush_refinery_vfx.pcf")
PrecacheParticleSystem("zrush_refinery_overheat")

game.AddParticles("particles/zrush_oil_vfx.pcf")
PrecacheParticleSystem("zrush_barrel_oil_fill")
PrecacheParticleSystem("zrush_barrel_fuel_fill")
PrecacheParticleSystem("zrush_barrel_oil_splash")
PrecacheParticleSystem("zrush_drillhole_splash")


util.PrecacheModel( "models/zerochain/props_oilrush/zor_drillpipe.mdl" )
util.PrecacheModel( "models/zerochain/props_oilrush/zor_barrel.mdl" )


util.PrecacheSound("zrush/zrush_ui_hover.wav")
util.PrecacheSound("zrush/zrush_command.wav")
