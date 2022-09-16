local LANG = {
	["Tool.NotAdmin"] = "¡Tienes que ser un administrador de configuración para acceder a esto!", --You need to be a config admin to access this!
	["Tool.DeletedAll"] = "¡Has eliminado :amount: spawns!", --You deleted :amount: spawns!
	["Tool.TooClose"] = "Esta ubicación está demasiado cerca del skybox", --This location is too close to the skybox
	["Tool.Blocked"] = "¡No se puede llegar a esta ubicación directamente desde el skybox!", --This location can't be reached directly by the skybox!

	["Spawn.Commencing"] = "Un Airdrop comienza en :time: segundos", --Airdrop commencing in :time: seconds
	["Spawn.Spawned"] = "El avión se ha generado, prepárese para el pdrop de suministros entrante", --Plane has spawned, prepare for inbound care package

	["Drops.Money.Take"] = "Toma el dinero", --Take the money
	["Drops.Money.Loot"] = "Botín", --Loot
	["Drops.Weapons.Equipped"] = "Ya tienes esta arma equipada", --You already have this weapon equipped
	["Drops.Weapons.DontOwnXeninInventory"] = "Error (Addon de Inventario)", --You don't own Xenin Inventory
	["Drops.Weapons.InventoryFull"] = "Tu inventario está lleno", --Your inventory is full

	["ConCommand.PlanePos.First"] =  "Ahora ve a la otra esquina del mapa.\n",
	["ConCommand.PlanePos.Second"] = "¡Ya has guardado los bordes del avión! Podrás ver el recuadro de los bordes del avión en el cielo hasta que te vuelvas a conectar\n", --You have now saved the plane edges! You will be able to see the box of the plane edges in the sky until you reconnect\n

	["Loot.Error.Dead"] = "Estás muerto", --You are dead
	["Loot.Error.InventoryNotThere"] = "Intentó usar un comando de inventario, pero Xenin Inventory no está instalado", --You tried to use an inventory command, but Xenin Inventory isn't installed
	["Loot.Error.Invalid"] = "¡El drop de suministros no es válido!", --Care package is invalid!
	["Loot.Error.NotReady"] = "La caja no está lista.", --The crate isn't ready
	["Loot.Error.TooFarAway"] = "Estás demasiado lejos de la caja.", --You are too far away from the crate
	["Loot.Error.DoesntContainAnything"] = "La caja no contiene nada", --Crate does not contain anything
	["Loot.Error.ItemLooted"] = "El artículo ya ha sido saqueado", --Item has already been looted
	["Loot.Error.DoesntExistInConfig"] = "El artículo no existe en la configuración.", --The item does not exist in the config

	["Crate.Unopened"] = "SIN ABRIR", --UNOPENED
	["Crate.OpeningIn"] = "APERTURA EN :time: SEGUNDOS", --OPENING IN :time: SECONDS
	["Crate.Opened"] = "ABRIÓ", --OPENED
	["Crate.Name"] = "Drop de suministros", --Care Package

	["Flare.Invalid"] = "Tu bengala está demasiado cerca de algo/no está al aire libre. Inténtalo de nuevo", --Your flare is too close to something/not in the open. Please try again
	["Flare.Valid"] = "¡Tu bengala fue vista! Drop de suministros entrante", --Your flare is placed in the open! Care Package inbound
	["Flare.Plane"] = "¡Alguien ha pedido un paquete de ayuda! Avión entrante", --Somebody has called a care package in! Plane inbound
}

CarePackage:CreateLanguage("Spanish", LANG)