--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

DarkRP.createCategory{
    name = "Staff",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 255, 13),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Ciudadanos",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Criminales",
    categorises = "jobs",
    startExpanded = true,
    color = Color(242, 127, 50, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Gobierno",
    categorises = "jobs",
    startExpanded = true,
    color = Color(150, 20, 20, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Asesinos",
    categorises = "jobs",
    startExpanded = true,
    color = Color(237, 9, 9),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

--------------------------------------------------------------------------
-------------Entidades
--------------------------------------------------------------------------

DarkRP.createCategory{
	name = "Rebanador de frutas",
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 107, 0, 255),
	canSee = function(ply) return true end,
	sortOrder = 235
}

DarkRP.createCategory{
	name = "Cocinero Profesional",
	categorises = "entities",
	startExpanded = true,
	color = Color(111, 150, 97, 255),
	canSee = function(ply) return true end,
	sortOrder = 100,
}

DarkRP.createCategory({
    name = "Hongos Magicos",
    categorises = "entities",
    startExpanded = true,
    color = Color(230, 41, 204),
    canSee = function(ply) return true end,
    sortOrder = 100,
})

DarkRP.createCategory{
    name = "Pizzero",
    categorises = "entities",
    startExpanded = true,
    color = Color(240, 180, 0),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Refinador de combustible",
    categorises = "entities",
    startExpanded = true,
    color = Color(146, 61, 0),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Fuegos Artificiales",
    categorises = "entities",
    startExpanded = true,
    color = Color(255, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
	name = "Policia", 
	categorises = "entities",
	startExpanded = true,
	color = Color(0, 75, 155),
	canSee = function(ply) return true end,
	sortOrder = 100,
}

DarkRP.createCategory{
    name = "Cocinero de Metanfetamina",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 125, 255, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Laboratorio de Metanfetamina",
    categorises = "entities",
    startExpanded = true,
    color = Color(12, 241, 187),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
	name = "Mecanico", 
	categorises = "entities",
	startExpanded = true,
	color = Color(158, 38, 228),
	canSee = function(ply) return true end,
	sortOrder = 100,
}

DarkRP.createCategory{
    name = "Fabrica de Cocaina",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Recolector de Basura",
    categorises = "entities",
    startExpanded = true,
    color = Color(255, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Minero",
    categorises = "entities",
    startExpanded = true,
    color = Color(209, 155, 7),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Granjero",
    categorises = "entities",
    startExpanded = true,
    color = Color(155, 200, 97),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
	name = "Medico",
	categorises = "entities",
	startExpanded = true,
	color = Color(107, 0, 0, 255),
	canSee = function(ply) return true end,
	sortOrder = 100,
}

DarkRP.createCategory{
    name = "Criptomineria",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Criptomineria",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Criptomineria",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Dinero",
    categorises = "entities",
    startExpanded = true,
    color = Color(242, 255, 0),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Especiales",
    categorises = "entities",
    startExpanded = true,
    color = Color(255, 218, 70),
    canSee = function(ply) return true end,
    sortOrder = 100,
}

DarkRP.createCategory{
	name = "Administrador de Camaras",
	categorises = "entities",
	startExpanded = true,
	color = Color(252, 133, 0),
	canSee = function(ply) return true end,
	sortOrder = 100,
}

--[[---------------------------------------------------------------------------
M9K
---------------------------------------------------------------------------]]--

DarkRP.createCategory{
    name = "Especiales",
    categorises = "shipments",
    startExpanded = true,
    canSee = function(ply) return true end,
    color = Color(115, 115, 112, 255),
    sortOrder = 100,
}

DarkRP.createCategory{
  name = "Pistolas",
  categorises = "shipments",
  startExpanded = true,
  canSee = function(ply) return true end,
  color = Color(115, 115, 112, 255),
  sortOrder = 100,
}

DarkRP.createCategory{
  name = "SMGs",
  categorises = "shipments",
  startExpanded = true,
  canSee = function(ply) return true end,
  color = Color(115, 115, 112, 255),
  sortOrder = 100,
}

DarkRP.createCategory{
  name = "Rifles",
  categorises = "shipments",
  startExpanded = true,
  canSee = function(ply) return true end,
  color = Color(115, 115, 112, 255),
  sortOrder = 100,
}

DarkRP.createCategory{
  name = "Escopetas",
  categorises = "shipments",
  startExpanded = true,
  canSee = function(ply) return true end,
  color = Color(115, 115, 112, 255),
  sortOrder = 100,
}

DarkRP.createCategory{
  name = "Rifles de Francotirador",
  categorises = "shipments",
  startExpanded = true,
  canSee = function(ply) return true end,
  color = Color(115, 115, 112, 255),
  sortOrder = 100,
}

DarkRP.createCategory{
  name = "Ametralladoras Ligeras",
  categorises = "shipments",
  startExpanded = true,
  canSee = function(ply) return true end,
  color = Color(115, 115, 112, 255),
  sortOrder = 100,
}

