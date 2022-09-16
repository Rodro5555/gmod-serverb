zfs = zfs or {}
zfs.config = zfs.config or {}
zfs.config.Fruits = {}
local function AddFruit(data) return table.insert(zfs.config.Fruits,data) end

ZFS_FRUIT_APPLE = AddFruit({
	Name = "Manzana",
	Model = "models/zerochain/fruitslicerjob/fs_apple.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_apple.png", "smooth"),

	// How much Health/Energy does the fruits give the player
	Health = 3,

	CutEffect = "zfs_banana",
	CutSound = "zfs_sfx_apple",

	// How many Knife hits does it take to Finish this fruit
	PrepareAmount = 8,

	// This Sets the bodygroup of the fruit entity to a sliced form for the mixer
	SlicedBG = 8,

	// Rotates the fruit on the up axis
	AngleOffset = -90,

	// Once the fruit reaches this bodygroup we change the color of it to white
	ChangeColorAtBodygroup = -1
})

ZFS_FRUIT_BANANA = AddFruit({
	Name = "Banana",
	Model = "models/zerochain/fruitslicerjob/fs_banana.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_banana.png", "smooth"),
	Health = 5,
	CutEffect = "zfs_banana",
	CutSound = "zfs_sfx_banana",
	PrepareAmount = 5,
	SlicedBG = 3,
	AngleOffset = 0,
	ChangeColorAtBodygroup = 1,
	OnSpawn = function(ent)
		ent:SetColor(HSVToColor(math.random(45, 65), 1, 1))
	end,
})

ZFS_FRUIT_COCONUT = AddFruit({
	Name = "Coco",
	Model = "models/zerochain/fruitslicerjob/fs_coconut.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_coconut.png", "smooth"),
	Health = 10,
	CutEffect = "zfs_coconut",
	CutSound = "zfs_sfx_coconut",
	CutFinishSound = "zfs_sfx_coconut_finish",
	PrepareAmount = 6,
	SlicedBG = 2,
	AngleOffset = 90,
	ChangeColorAtBodygroup = 5,
	OnSpawn = function(ent)
		ent:SetColor(HSVToColor(math.random(70, 100), 1, 1))
	end,
})

ZFS_FRUIT_KIWI = AddFruit({
	Name = "Kiwi",
	Model = "models/zerochain/fruitslicerjob/fs_kiwi.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_kiwi.png", "smooth"),
	Health = 3,
	CutEffect = "zfs_kiwi",
	CutSound = "zfs_sfx_banana",
	PrepareAmount = 8,
	SlicedBG = 5,
	AngleOffset = -90,
	ChangeColorAtBodygroup = -1,
})

ZFS_FRUIT_LEMON = AddFruit({
	Name = "Limón",
	Model = "models/zerochain/fruitslicerjob/fs_lemon.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_lemon.png", "smooth"),
	Health = 1,
	CutEffect = "zfs_banana",
	CutSound = "zfs_sfx_banana",
	PrepareAmount = 8,
	SlicedBG = 4,
	AngleOffset = -90,
	ChangeColorAtBodygroup = -1,
})

ZFS_FRUIT_MELON = AddFruit({
	Name = "Melón",
	Model = "models/zerochain/fruitslicerjob/fs_melon.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_watermelon.png", "smooth"),
	Health = 15,
	CutEffect = "zfs_melon",
	CutSound = "zfs_sfx_melon",
	CutFinishSound = "zfs_sfx_melon_finish",
	PrepareAmount = 5,
	SlicedBG = 0,
	AngleOffset = 0,
	ChangeColorAtBodygroup = -1,
})

ZFS_FRUIT_POMEGRANATE = AddFruit({
	Name = "Granada",
	Model = "models/zerochain/fruitslicerjob/fs_pomegranate.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_pomegranate.png", "smooth"),
	Health = 7,
	CutEffect = "zfs_melon",
	CutSound = "zfs_sfx_pomegranate",
	CutFinishSound = "zfs_sfx_pomegranate_finish",
	PrepareAmount = 6,
	SlicedBG = 1,
	AngleOffset = 0,
	ChangeColorAtBodygroup = -1,
})

ZFS_FRUIT_ORANGE = AddFruit({
	Name = "Naranja",
	Model = "models/zerochain/fruitslicerjob/fs_orange.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_orange.png", "smooth"),
	Health = 1,
	CutEffect = "zfs_orange",
	CutSound = "zfs_sfx_banana",
	PrepareAmount = 8,
	SlicedBG = 6,
	AngleOffset = -90,
	ChangeColorAtBodygroup = -1,
})

ZFS_FRUIT_STRAWBERRYS = AddFruit({
	Name = "Fresas",
	Model = "models/zerochain/fruitslicerjob/fs_strawberry.mdl",
	Icon = Material("materials/zfruitslicer/ui/ingrediens/zfs_strawberry.png", "smooth"),
	Health = 2,
	CutEffect = "zfs_strawberry",
	CutSound = "zfs_sfx_banana",
	PrepareAmount = 8,
	SlicedBG = 7,
	AngleOffset = -90,
	ChangeColorAtBodygroup = -1,
})
