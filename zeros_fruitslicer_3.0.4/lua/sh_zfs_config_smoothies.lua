zfs = zfs or {}
zfs.config = zfs.config or {}
zfs.config.Smoothies = {}

local function AddSmoothie(data) table.insert(zfs.config.Smoothies,data) end

/*

	This creates all the smoothies that can be made in the shop

*/

AddSmoothie({
	// The Name of our FruitCup
	Name = "Melón Monstruo",

	// The Base Price of the FruitCup, This value can change depending on the fruit varation if zfs.config.FruitPriceMultiplier is true
	Price = 1500,

	// The Icon of the FruitCup
	Icon = Material("materials/zfruitslicer/ui/fs_ui_monstermelon.png","smooth"),

	// The Info of the FruitCup
	Info = "Un delicioso batido de Melon con Arcoíris, Chispas y un olor a melón afrutado.",

	// The Color of the Fruitcup
	fruitColor = Color(254, 84, 78),

	// What Fruits are needed do make the Smoothie
	// Dont add more then 22 fruits max or it gets complicated
	recipe = {
		[ZFS_FRUIT_MELON] = 3,
	}
})

AddSmoothie({
	Name = "Banana General",
	Price = 1200,
	Icon = Material("materials/zfruitslicer/ui/fs_ui_generalbanana.png","smooth"),
	Info = "Un sabroso batido de plátanos lleno de arcoíris.",
	fruitColor = Color(255, 223, 126),
	recipe = {
		[ZFS_FRUIT_BANANA] = 5,
	}
})

AddSmoothie({
	Name = "Batido Chianka",
	Price = 2500,
	Icon = Material("materials/zfruitslicer/ui/fs_ui_chikichanga.png","smooth"),
	Info = "Un batido dulce yummi tropical de Hawai.",
	fruitColor = Color(221, 112, 161),
	recipe = {
		[ZFS_FRUIT_BANANA] = 1,
		[ZFS_FRUIT_COCONUT] = 3,
		[ZFS_FRUIT_POMEGRANATE] = 2,
	}
})

AddSmoothie({
	Name = "Súper Batido de Frutas",
	Price = 5000,
	Icon = Material("materials/zfruitslicer/ui/fs_ui_superfruit.png","smooth"),
	Info = "¡La bomba de vitaminas definitiva!",
	fruitColor = Color(140, 119, 219),
	recipe = {
		[ZFS_FRUIT_MELON] = 1,
		[ZFS_FRUIT_BANANA] = 3,
		[ZFS_FRUIT_COCONUT] = 1,
		[ZFS_FRUIT_POMEGRANATE] = 1,
		[ZFS_FRUIT_STRAWBERRYS] = 1,
		[ZFS_FRUIT_KIWI] = 2,
		[ZFS_FRUIT_LEMON] = 1,
		[ZFS_FRUIT_ORANGE] = 2,
		[ZFS_FRUIT_APPLE] = 2
	}
})

AddSmoothie({
	Name = "Bomba de Fresa",
	Price = 3000,
	Icon = Material("materials/zfruitslicer/ui/fs_ui_strawberrybomb.png","smooth"),
	Info = "¡Prueba la sangre de tus enemigos!",
	fruitColor = Color(174, 36, 56),
	recipe = {
		[ZFS_FRUIT_STRAWBERRYS] = 5,
	}
})

AddSmoothie({
	Name = "Delicia de explosión de lava",
	Price = 3000,
	Icon = Material("materials/zfruitslicer/ui/fs_ui_lavaburst.png","smooth"),
	Info = "¡El Poder de la Tierra combinado en una Delicia Frutal!",
	fruitColor = Color(255, 119, 0),
	recipe = {
		[ZFS_FRUIT_MELON] = 1,
		[ZFS_FRUIT_BANANA] = 2,
		[ZFS_FRUIT_STRAWBERRYS] = 2,
		[ZFS_FRUIT_APPLE] = 4
	}
})

AddSmoothie({
	Name = "Vórtice Rojo",
	Price = 4000,
	Icon = Material("materials/zfruitslicer/ui/fs_ui_fruitrougesvortex.png","smooth"),
	Info = "¡Un vórtice de sabrosos frutos rojos!",
	fruitColor = Color(199, 48, 62),
	recipe = {
		[ZFS_FRUIT_MELON] = 1,
		[ZFS_FRUIT_POMEGRANATE] = 5,
		[ZFS_FRUIT_STRAWBERRYS] = 2,
		[ZFS_FRUIT_APPLE] = 3
	}
})
