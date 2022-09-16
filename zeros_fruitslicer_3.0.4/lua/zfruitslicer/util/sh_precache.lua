AddCSLuaFile()

util.PrecacheModel("models/zerochain/fruitslicerjob/fs_shop_glass.mdl")
util.PrecacheModel("models/zerochain/fruitslicerjob/fs_fruitpile.mdl")
util.PrecacheModel("models/zerochain/fruitslicerjob/fs_wheel.mdl")



//Sell
game.AddParticles( "particles/zfruitslicer_sell_vfx.pcf")
PrecacheParticleSystem( "zfs_sell_effect" )
PrecacheParticleSystem( "zfs_shop_trail" )



//Frezze Effect
game.AddParticles( "particles/zfruitslicer_frezze_vfx.pcf")
PrecacheParticleSystem( "zfs_frozen_effect" )


//Benefits
game.AddParticles( "particles/zfruitslicer_benefits_effects.pcf")
PrecacheParticleSystem( "zfs_money_effect" )
PrecacheParticleSystem( "zfs_energetic" )
PrecacheParticleSystem( "zfs_health_effect" )
PrecacheParticleSystem( "zfs_ghost_effect" )

//Sweetener
game.AddParticles( "particles/zfruitslicer_sweetener_vfx.pcf")
PrecacheParticleSystem( "zfs_sweetener_coffee" )
PrecacheParticleSystem( "zfs_sweetener_milk" )
PrecacheParticleSystem( "zfs_sweetener_chocolate" )

//Melon
game.AddParticles( "particles/zfruitslicer_melon_vfx.pcf")
PrecacheParticleSystem( "zfs_melon" )

//Banana
game.AddParticles( "particles/zfruitslicer_banana_vfx.pcf")
PrecacheParticleSystem( "zfs_banana" )

//Coconut
game.AddParticles( "particles/zfruitslicer_coconut_vfx.pcf")
PrecacheParticleSystem( "zfs_coconut" )

//Kiwi
game.AddParticles( "particles/zfruitslicer_kiwi_vfx.pcf")
PrecacheParticleSystem( "zfs_kiwi" )

//Strawberry
game.AddParticles( "particles/zfruitslicer_strawberry_vfx.pcf")
PrecacheParticleSystem( "zfs_strawberry" )

//Orange
game.AddParticles( "particles/zfruitslicer_orange_vfx.pcf")
PrecacheParticleSystem( "zfs_orange" )
