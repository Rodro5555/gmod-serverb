local LANG = {
	["Tool.NotAdmin"] = "You need to be a config admin to access this!",
	["Tool.DeletedAll"] = "You deleted :amount: spawns!",
	["Tool.TooClose"] = "This location is too close to the skybox",
	["Tool.Blocked"] = "This location can't be reached directly by the skybox!",

	["Spawn.Commencing"] = "Airdrop commencing in :time: seconds",
	["Spawn.Spawned"] = "Plane has spawned, prepare for inbound care package",

	["Drops.Money.Take"] = "Take the money",
	["Drops.Money.Loot"] = "Loot",
	["Drops.Weapons.Equipped"] = "You already have this weapon equipped",
	["Drops.Weapons.DontOwnXeninInventory"] = "You don't own Xenin Inventory",
	["Drops.Weapons.InventoryFull"] = "Your inventory is full",

	["ConCommand.PlanePos.First"] =  "Now go to other corner of the map\n",
	["ConCommand.PlanePos.Second"] = "You have now saved the plane edges! You will be able to see the box of the plane edges in the sky until you reconnect\n",

	["Loot.Error.Dead"] = "You are dead",
	["Loot.Error.InventoryNotThere"] = "You tried to use an inventory command, but Xenin Inventory isn't installed",
	["Loot.Error.Invalid"] = "Care package is invalid!",
	["Loot.Error.NotReady"] = "The crate isn't ready",
	["Loot.Error.TooFarAway"] = "You are too far away from the crate",
	["Loot.Error.DoesntContainAnything"] = "Crate does not contain anything",
	["Loot.Error.ItemLooted"] = "Item has already been looted",
	["Loot.Error.DoesntExistInConfig"] = "The item does not exist in the config",

	["Crate.Unopened"] = "UNOPENED",
	["Crate.OpeningIn"] = "OPENING IN :time: SECONDS",
	["Crate.Opened"] = "OPENED",
	["Crate.Name"] = "Care Package",

	["Flare.Invalid"] = "Your flare is too close to something/not in the open. Please try again",
	["Flare.Valid"] = "Your flare is placed in the open! Care Package inbound",
	["Flare.Plane"] = "Somebody has called a care package in! Plane inbound",
}

CarePackage:CreateLanguage("English", LANG)