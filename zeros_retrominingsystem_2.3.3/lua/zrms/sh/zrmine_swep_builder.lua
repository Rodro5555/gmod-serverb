zrmine = zrmine or {}
zrmine.f = zrmine.f or {}


zrmine.Swep_BuildItems = {
	[1] = {name = "Trituradora" ,class = "zrms_crusher", model = "models/zerochain/props_mining/zrms_crusher.mdl",icon = Material("materials/entities/zrms_crusher.png", "smooth")},
	[2] = {name = "Cinta transportadora - Normal" ,class = "zrms_conveyorbelt_n", model = "models/zerochain/props_mining/zrms_conveyorbelt_normal.mdl",icon = Material("materials/entities/zrms_conveyorbelt_n.png", "smooth")},
	[3] = {name = "Cinta transportadora - Pequeña" ,class = "zrms_conveyorbelt_s", model = "models/zerochain/props_mining/zrms_conveyorbelt_small.mdl",icon = Material("materials/entities/zrms_conveyorbelt_s.png", "smooth")},
	[4] = {name = "Cinta transportadora - Izquierda" ,class = "zrms_conveyorbelt_c_left", model = "models/zerochain/props_mining/zrms_conveyorbelt_curved_left.mdl",icon = Material("materials/entities/zrms_conveyorbelt_c_left.png", "smooth")},
	[5] = {name = "Cinta transportadora - Derecha" ,class = "zrms_conveyorbelt_c_right", model = "models/zerochain/props_mining/zrms_conveyorbelt_curved.mdl",icon = Material("materials/entities/zrms_conveyorbelt_c_right.png", "smooth")},

	[6] = {name = "Banda transportadora - Insertador" ,class = "zrms_inserter", model = "models/zerochain/props_mining/zrms_inserter.mdl",icon = Material("materials/entities/zrms_inserter.png", "smooth")},
	[7] = {name = "Cinta transportadora - Divisor" ,class = "zrms_splitter", model = "models/zerochain/props_mining/zrms_conveyorbelt_splitter.mdl",icon = Material("materials/entities/zrms_splitter.png", "smooth")},

	[8] = {name = "Refinería - Carbón" ,class = "zrms_refiner_coal", model = "models/zerochain/props_mining/zrms_refiner.mdl",icon = Material("materials/entities/zrms_refiner_coal.png", "smooth")},
	[9] = {name = "Refinería - Hierro" ,class = "zrms_refiner_iron", model = "models/zerochain/props_mining/zrms_refiner.mdl",icon = Material("materials/entities/zrms_refiner_iron.png", "smooth")},
	[10] = {name = "Refinería - Bronce" ,class = "zrms_refiner_bronze", model = "models/zerochain/props_mining/zrms_refiner.mdl",icon = Material("materials/entities/zrms_refiner_bronze.png", "smooth")},
	[11] = {name = "Refinería - Plata" ,class = "zrms_refiner_silver", model = "models/zerochain/props_mining/zrms_refiner.mdl",icon = Material("materials/entities/zrms_refiner_silver.png", "smooth")},
	[12] = {name = "Refinería - Oro" ,class = "zrms_refiner_gold", model = "models/zerochain/props_mining/zrms_refiner.mdl",icon = Material("materials/entities/zrms_refiner_gold.png", "smooth")},

	[13] = {name = "Filtro - Carbón" ,class = "zrms_sorter_coal", model = "models/zerochain/props_mining/zrms_conveyorbelt_sorter.mdl",icon = Material("materials/entities/zrms_sorter_coal.png", "smooth")},
	[14] = {name = "Filtro - Hierro" ,class = "zrms_sorter_iron", model = "models/zerochain/props_mining/zrms_conveyorbelt_sorter.mdl",icon = Material("materials/entities/zrms_sorter_iron.png", "smooth")},
	[15] = {name = "Filtro - Bronce" ,class = "zrms_sorter_bronze", model = "models/zerochain/props_mining/zrms_conveyorbelt_sorter.mdl",icon = Material("materials/entities/zrms_sorter_bronze.png", "smooth")},
	[16] = {name = "Filtro - Plata" ,class = "zrms_sorter_silver", model = "models/zerochain/props_mining/zrms_conveyorbelt_sorter.mdl",icon = Material("materials/entities/zrms_sorter_silver.png", "smooth")},
	[17] = {name = "Filtro - Oro" ,class = "zrms_sorter_gold", model = "models/zerochain/props_mining/zrms_conveyorbelt_sorter.mdl",icon = Material("materials/entities/zrms_sorter_gold.png", "smooth")},
}

local AllowedDeconstruction = {
	"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right",
	"zrms_inserter", "zrms_splitter", "zrms_crusher",
	"zrms_refiner_iron", "zrms_refiner_coal", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold",
	"zrms_sorter_iron", "zrms_sorter_coal", "zrms_sorter_bronze", "zrms_sorter_silver", "zrms_sorter_gold"
}

local Allowed_Connections = {
	["zrms_crusher"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_inserter", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold"},

	["zrms_conveyorbelt_n"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_splitter", "zrms_inserter", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold","zrms_sorter_coal", "zrms_sorter_iron", "zrms_sorter_bronze", "zrms_sorter_silver", "zrms_sorter_gold"},
	["zrms_conveyorbelt_s"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_splitter", "zrms_inserter","zrms_sorter_coal", "zrms_sorter_iron", "zrms_sorter_bronze", "zrms_sorter_silver", "zrms_sorter_gold", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold"},
	["zrms_conveyorbelt_c_left"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_splitter", "zrms_inserter" , "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold"},
	["zrms_conveyorbelt_c_right"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_splitter", "zrms_inserter" , "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold"},

	["zrms_splitter"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right"},
	["zrms_inserter"] = {},

	["zrms_refiner_coal"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold", "zrms_inserter"},
	["zrms_refiner_iron"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold", "zrms_inserter"},
	["zrms_refiner_bronze"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold", "zrms_inserter"},
	["zrms_refiner_silver"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold", "zrms_inserter"},
	["zrms_refiner_gold"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right", "zrms_refiner_coal", "zrms_refiner_iron", "zrms_refiner_bronze", "zrms_refiner_silver", "zrms_refiner_gold", "zrms_inserter"},

	["zrms_sorter_coal"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right"},
	["zrms_sorter_iron"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right"},
	["zrms_sorter_bronze"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right"},
	["zrms_sorter_silver"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right"},
	["zrms_sorter_gold"] = {"zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right"},
}

local zrms_BuildOffset = {
	["zrms_crusher"] = {
		[1] = {lPos = Vector(-60,0,0), lAng = Angle(0,0,0)}
	},

	["zrms_conveyorbelt_n"] = {
		[1] = {lPos = Vector(-80,0,0), lAng = Angle(0,0,0)}
	},
	["zrms_conveyorbelt_s"] = {
		[1] = {lPos = Vector(-40,0,0), lAng = Angle(0,0,0)}
	},
	["zrms_conveyorbelt_c_left"] = {
		[1] = {lPos = Vector(-47,-45,0), lAng = Angle(0,0,0)}
	},
	["zrms_conveyorbelt_c_right"] = {
		[1] = {lPos = Vector(-47,45,0), lAng = Angle(0,0,0)}
	},

	["zrms_splitter"] = {
		[1] = {lPos = Vector(-29.5,-21,0), lAng = Angle(0,90,0)},
		[2] = {lPos = Vector(29.5,-21,0), lAng = Angle(0,90,0)},
	},
	["zrms_inserter"] = {
		[1] = {lPos = Vector(-80,0,0), lAng = Angle(0,0,0)}
	},

	["zrms_refiner_coal"] = {
		[1] = {lPos = Vector(-45,0,0), lAng = Angle(0,0,0)}
	},
	["zrms_refiner_iron"] = {
		[1] = {lPos = Vector(-45,0,0), lAng = Angle(0,0,0)}
	},
	["zrms_refiner_bronze"] = {
		[1] = {lPos = Vector(-45,0,0), lAng = Angle(0,0,0)}
	},
	["zrms_refiner_silver"] = {
		[1] = {lPos = Vector(-45,0,0), lAng = Angle(0,0,0)}
	},
	["zrms_refiner_gold"] = {
		[1] = {lPos = Vector(-45,0,0), lAng = Angle(0,0,0)}
	},

	["zrms_sorter_coal"] = {
		[1] = {lPos = Vector(0,41,0), lAng = Angle(0,90,0)},
		[2] = {lPos = Vector(-41,0,0), lAng = Angle(0,180,0)},
	},
	["zrms_sorter_iron"] = {
		[1] = {lPos = Vector(0,41,0), lAng = Angle(0,90,0)},
		[2] = {lPos = Vector(-41,0,0), lAng = Angle(0,180,0)},
	},
	["zrms_sorter_bronze"] = {
		[1] = {lPos = Vector(0,41,0), lAng = Angle(0,90,0)},
		[2] = {lPos = Vector(-41,0,0), lAng = Angle(0,180,0)},
	},
	["zrms_sorter_silver"] = {
		[1] = {lPos = Vector(0,41,0), lAng = Angle(0,90,0)},
		[2] = {lPos = Vector(-41,0,0), lAng = Angle(0,180,0)},
	},
	["zrms_sorter_gold"] = {
		[1] = {lPos = Vector(0,41,0), lAng = Angle(0,90,0)},
		[2] = {lPos = Vector(-41,0,0), lAng = Angle(0,180,0)},
	},
}

local zrms_AngleOffset = {
	["zrms_crusher"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},
	["zrms_conveyorbelt_s"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,
		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_sorter_coal"] = 0,
		["zrms_sorter_iron"] = 0,
		["zrms_sorter_bronze"] = 0,
		["zrms_sorter_silver"] = 0,
		["zrms_sorter_gold"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},
	["zrms_conveyorbelt_n"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,

		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,

		["zrms_sorter_coal"] = 0,
		["zrms_sorter_iron"] = 0,
		["zrms_sorter_bronze"] = 0,
		["zrms_sorter_silver"] = 0,
		["zrms_sorter_gold"] = 0,
	},
	["zrms_conveyorbelt_c_left"] = {
		["zrms_conveyorbelt_n"] = 90,
		["zrms_conveyorbelt_s"] = 90,
		["zrms_conveyorbelt_c_left"] = 90,
		["zrms_conveyorbelt_c_right"] = 90,
		["zrms_splitter"] = 0,
		["zrms_inserter"] = 90,

		["zrms_refiner_coal"] = 90,
		["zrms_refiner_iron"] = 90,
		["zrms_refiner_bronze"] = 90,
		["zrms_refiner_silver"] = 90,
		["zrms_refiner_gold"] = 90,
	},
	["zrms_conveyorbelt_c_right"] = {
		["zrms_conveyorbelt_n"] = -90,
		["zrms_conveyorbelt_s"] = -90,
		["zrms_conveyorbelt_c_left"] = -90,
		["zrms_conveyorbelt_c_right"] = -90,
		["zrms_splitter"] = 180,
		["zrms_inserter"] = -90,

		["zrms_refiner_coal"] = -90,
		["zrms_refiner_iron"] = -90,
		["zrms_refiner_bronze"] = -90,
		["zrms_refiner_silver"] = -90,
		["zrms_refiner_gold"] = -90,
	},

	["zrms_splitter"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,
	},
	["zrms_inserter"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,
		["zrms_splitter"] = -90,
	},

	["zrms_refiner_coal"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,

		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},
	["zrms_refiner_iron"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,

		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},
	["zrms_refiner_bronze"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,

		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},
	["zrms_refiner_silver"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,

		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},
	["zrms_refiner_gold"] = {
		["zrms_conveyorbelt_n"] = 0,
		["zrms_conveyorbelt_s"] = 0,
		["zrms_conveyorbelt_c_left"] = 0,
		["zrms_conveyorbelt_c_right"] = 0,

		["zrms_splitter"] = -90,
		["zrms_inserter"] = 0,

		["zrms_refiner_coal"] = 0,
		["zrms_refiner_iron"] = 0,
		["zrms_refiner_bronze"] = 0,
		["zrms_refiner_silver"] = 0,
		["zrms_refiner_gold"] = 0,
	},

	["zrms_sorter_coal"] = {
		["zrms_conveyorbelt_n"] = 180,
		["zrms_conveyorbelt_s"] = 180,
		["zrms_conveyorbelt_c_left"] = 180,
		["zrms_conveyorbelt_c_right"] = 180,
	},
	["zrms_sorter_iron"] = {
		["zrms_conveyorbelt_n"] = 180,
		["zrms_conveyorbelt_s"] = 180,
		["zrms_conveyorbelt_c_left"] = 180,
		["zrms_conveyorbelt_c_right"] = 180,
	},
	["zrms_sorter_bronze"] = {
		["zrms_conveyorbelt_n"] = 180,
		["zrms_conveyorbelt_s"] = 180,
		["zrms_conveyorbelt_c_left"] = 180,
		["zrms_conveyorbelt_c_right"] = 180,
	},
	["zrms_sorter_silver"] = {
		["zrms_conveyorbelt_n"] = 180,
		["zrms_conveyorbelt_s"] = 180,
		["zrms_conveyorbelt_c_left"] = 180,
		["zrms_conveyorbelt_c_right"] = 180,
	},
	["zrms_sorter_gold"] = {
		["zrms_conveyorbelt_n"] = 180,
		["zrms_conveyorbelt_s"] = 180,
		["zrms_conveyorbelt_c_left"] = 180,
		["zrms_conveyorbelt_c_right"] = 180,
	},
}

local zrms_ValidPos_Offset = {
	["zrms_conveyorbelt_n"] = Vector(-35, 0, 0),
	["zrms_conveyorbelt_s"] = Vector(-35, 0, 0),
	["zrms_conveyorbelt_c_left"] = Vector(0, -35, 0),
	["zrms_conveyorbelt_c_right"] = Vector(0, 35, 0),

	["zrms_splitter"] = Vector(0, -35, 0),
	["zrms_crusher"] = Vector(-35, 0, 0),
	["zrms_inserter"] = Vector(-35, 0, 0),

	["zrms_refiner_coal"] = Vector(-35, 0, 0),
	["zrms_refiner_iron"] = Vector(-35, 0, 0),
	["zrms_refiner_bronze"] = Vector(-35, 0, 0),
	["zrms_refiner_silver"] = Vector(-35, 0, 0),
	["zrms_refiner_gold"] = Vector(-35, 0, 0),

	["zrms_sorter_coal"] = Vector(0, 0, 0),
	["zrms_sorter_iron"] = Vector(0, 0, 0),
	["zrms_sorter_bronze"] = Vector(0, 0, 0),
	["zrms_sorter_silver"] = Vector(0, 0, 0),
	["zrms_sorter_gold"] = Vector(0, 0, 0),
}

// Tells use if the parentClass allows the connection of the childClass
function zrmine.f.AllowedConnection(parentClass,childClass)

	local tbl = Allowed_Connections[parentClass]
	local result = false

	if tbl and table.HasValue(tbl,childClass) then
		result = true
	end

	return result
end

// Tells us if the entity is allowed to be deconstructed
function zrmine.f.AllowedDeconstruction(ent)

	if table.HasValue(AllowedDeconstruction, ent:GetClass()) then

		if (ent:GetClass() == "zrms_splitter" or string.sub(ent:GetClass(), 1, 11)  == "zrms_sorter" ) then

			// If the entity is a splitter then we check if both output ports are unsused before removing
			if not zrmine.f.HasChildAtPos(ent, 1) and not zrmine.f.HasChildAtPos(ent, 2) then
				return true
			else
				return false
			end
		elseif ent:GetClass() == "zrms_inserter" then

			// If the entity is a inserter then we allow it allways and ignore the outputs
			return true
		elseif not zrmine.f.HasChildAtPos(ent, 1) then

			// If the entity is anything else then we just check output 01
			return true
		else
			return false
		end
	else
		return false
	end
end

// Tells us if the provided Parent has a child on the provided child pos
function zrmine.f.HasChildAtPos(Parent, ConnectPos)
	if IsValid(Parent) then

		local ChildModule // The Child Module we are checking

		if Parent:GetClass() == "zrms_splitter" or string.sub(Parent:GetClass(), 1, 11) == "zrms_sorter" then

			if ConnectPos == 1 then

				ChildModule = Parent:GetModuleChild01()
				if IsValid(ChildModule) then

					return true
				else
					return false
				end
			elseif ConnectPos == 2 then

				ChildModule = Parent:GetModuleChild02()
				if IsValid(ChildModule) then

					return true
				else
					return false
				end
			end

		else

			ChildModule = Parent:GetModuleChild()
			if IsValid(ChildModule) then

				return true
			else
				return false
			end
		end

	else
		//If the parent is not valid then we just tell them this position is used
		return true
	end
end

// Fixes the angle depending on Child and Parent Class
function zrmine.f.AngleFix(entClass,parentClass,ang)
	local fAng = ang
	fAng:RotateAroundAxis(fAng:Up(),zrms_AngleOffset[parentClass][entClass])
	return fAng
end

// Fixes the model position depending on parent and module class
function zrmine.f.PositionFix(lPos,tAng,itemData,parent)
	local tPos

	// If the item class is a sorter then we need to make a little position adjustment
	if string.sub(itemData.class, 1, 11) == "zrms_sorter" then

		// If the partent is a curve then it gets even more complex
		if parent:GetClass() == "zrms_conveyorbelt_c_left" or parent:GetClass() == "zrms_conveyorbelt_c_right" then
			tPos = lPos + tAng:Right() * 20
		else
			tPos = lPos + tAng:Forward() * -20
		end
	else
		tPos = lPos
	end

	return tPos
end

// Checks if the selected module class is allowed on the parents port id
function zrmine.f.PortAllowance(parent, childclass, port)
	if parent:GetClass() == "zrms_splitter" and ( childclass == "zrms_conveyorbelt_c_right" or childclass == "zrms_conveyorbelt_c_left") then

		if childclass == "zrms_conveyorbelt_c_right" and port == 1 then

			return true
		elseif childclass == "zrms_conveyorbelt_c_left" and port == 2 then

			return true
		else
			return false
		end
	else
		return true
	end
end

// Does the main logic for finding a valid connection port
function zrmine.f.ConnectionSearch(trace,itemData)

	// Check if we are having a ent in close distance that has a free child port
	local tPos // The Position of the new module
	local tAng // The Angles of the new module
	local connectID // The Connection ID fom the Parent
	local ParentModule // Parent Object we are looking at

	for k, v in pairs(zrmine.EntList) do

		if IsValid(v) and zrmine.f.InDistance(trace.HitPos,v:GetPos(), 100) and zrmine.f.AllowedConnection(v:GetClass(),itemData.class) then

			for i = 1,table.Count(zrms_BuildOffset[v:GetClass()]) do

				local conData = zrms_BuildOffset[v:GetClass()][i]

				local lPos = v:LocalToWorld(conData.lPos)
				//zrmine.f.Debug_Sphere( lPos, 1, 0.1, Color( 255, 255, 255 ), true )

				// This checks if we are close enough at the connection point of the parent and if his connection port is free
				if zrmine.f.InDistance(trace.HitPos, lPos, 25) and zrmine.f.HasChildAtPos(v, i) == false and zrmine.f.PortAllowance(v,itemData.class,i) then
					tAng = v:LocalToWorldAngles(conData.lAng)
					tPos = zrmine.f.PositionFix(lPos, tAng, itemData, v)
					connectID = i
					ParentModule = v

					// This fixes the angle depending on the parent and child class
					tAng = zrmine.f.AngleFix(itemData.class, v:GetClass(), tAng)
					break
				end
			end
		end
	end

	return tPos , tAng , connectID , ParentModule
end

// Tells use if the ChildModule has enough space to be build
function zrmine.f.IsValidPos(itemData,pos,ParentModule,ConnectionPort)

	// If the module we want to place is a inserter then we dont make the valid pos check since inserts can over overlap in some situations
	if itemData.class == "zrms_inserter" then
		return true
	end

	local c_pos = pos
	local c_size = 55

	if itemData.class == "zrms_crusher" then
		c_size = 90
	end

	if IsValid(ParentModule) then

		// Here we add the local pos offset from zrms_ValidPos_Offset to the local Pos zrms_BuildOffset
		// This gives use the exact position where we check for free space
		local lPos = zrms_BuildOffset[ParentModule:GetClass()][ConnectionPort].lPos + zrms_ValidPos_Offset[ParentModule:GetClass()]
		c_pos = ParentModule:LocalToWorld(lPos)
	end

	//zrmine.f.Debug_Sphere(c_pos, c_size, 0.1, Color(255, 125, 0, 5), true)

	local ValidPos = true
	for k, v in pairs(zrmine.EntList) do
		if IsValid(v) and zrmine.f.InDistance(v:GetPos(), c_pos, c_size) and v ~= ParentModule  then
			//zrmine.f.Debug_Sphere(v:GetPos(), 3, 0.1, Color(255, 0, 0, 100), true)
			ValidPos = false
			break
		end
	end

	return ValidPos
end

// Tells us if the current thing we are looking at:
	//can be Deconstructed,
	//is a good spot to build something
	//is not usefull for anything

function zrmine.f.Swep_ActionSwitch(ply,weapon,primarykey)
	local tr = ply:GetEyeTrace()

	if tr.Hit and zrmine.f.InDistance(ply:GetPos(), tr.HitPos, 300) then

		if IsValid(tr.Entity) and zrmine.f.InDistance(tr.Entity:GetPos(), tr.HitPos, 60) then

			if zrmine.f.AllowedDeconstruction(tr.Entity) then

				// Can be Deconstruct
				return 2 , tr.Entity:GetPos() , tr.Entity:GetAngles() , tr.Entity
			else

				if SERVER and primarykey ~= nil and primarykey == false then
					zrmine.f.Notify(ply,zrmine.language.CantBuild_ObjectHasChild, 1)
				end
				// Cant do anything, in this case it means that the entity we wanna deconstruct has a child
				return 0 , tr.HitPos
			end
		else
			local itemData = zrmine.Swep_BuildItems[weapon:GetItemSelected()]

			if itemData.class == "zrms_crusher" then

				// Check if the position is free to place the entity

				if zrmine.f.IsValidPos(itemData,tr.HitPos,nil,nil) then

					// Can build crusher
					return 1 , tr.HitPos
				else
					if SERVER and primarykey ~= nil and primarykey == true then
						zrmine.f.Notify(ply, zrmine.language.Module_NoSpace, 1)
					end
					// Something is in the way
					return 0 , tr.HitPos
				end
			else

				// We have a module part selected and now have to check if we are close enough to a Parent Module that has a free child Port
				local tPos, tAng, connectID, ParentModule = zrmine.f.ConnectionSearch(tr, itemData)

				// The Parent entity is valid and has a free port for a child
				if tPos and tAng and connectID and ParentModule then

					// Checks if the space is free to build
					if zrmine.f.IsValidPos(itemData,tPos,ParentModule,connectID) then

						return 1 , tPos, tAng , connectID , ParentModule
					else
						if SERVER  and primarykey ~= nil and primarykey == true  then
							zrmine.f.Notify(ply, zrmine.language.Module_NoSpace, 1)
						end
						// Not enough space to build ent
						return 0 , tPos, tAng , connectID , ParentModule
					end
				else

					// Something is not valid so we cant build the entity
					return 0 , tr.HitPos
				end
			end
		end

	else
		// Cant do anything
		return 0 , tr.HitPos
	end
end

// Rotates the selected item if its of type crusher
function zrmine.f.Swep_RotateItem(weapon)
	local itemData = zrmine.Swep_BuildItems[weapon:GetItemSelected()]

	if itemData and itemData.class == "zrms_crusher" then

		weapon:SetItemRotation(weapon:GetItemRotation() + 90)

		if weapon:GetItemRotation() >= 360 then

			weapon:SetItemRotation(0)

		elseif weapon:GetItemRotation() <= 0 then

			weapon:SetItemRotation(360)
		end
	end
end

if CLIENT then

	// The ClientModel
	if zrms_c_item == nil then
		zrms_c_item = nil
	end

	// The Current Selected Item
	local c_selectedItem

	// The current action switch state 0 = Cant do anything, 1 = Can build, 2 = Can deconstruct
	local c_ASwitch = 0

	local c_Trace

	local c_ActiveWeapon


	local function SpawnClientModel(weapon)
		local ent = ents.CreateClientProp()
		ent:SetPos(weapon:GetPos() + weapon:GetUp() * 25 + weapon:GetForward() * 10)
		ent:SetModel(zrmine.Swep_BuildItems[weapon:GetItemSelected()].model)
		ent:SetAngles(Angle(0, 0, 0))
		ent:Spawn()
		ent:Activate()

		ent:SetModelScale(1)
		ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ent:SetColor(Color(255,0,0,200))

		zrms_c_item = ent
	end

	hook.Add("Think", "a_zrmine_Think_builderswep", function()
		local ply = LocalPlayer()
		c_ActiveWeapon = ply:GetActiveWeapon()

		if IsValid(c_ActiveWeapon) and c_ActiveWeapon:GetClass() == "zrms_builder" then

			c_selectedItem = c_ActiveWeapon:GetItemSelected()

			if IsValid(zrms_c_item) then

				c_Trace = ply:GetEyeTrace()

				if zrmine.f.InDistance(ply:GetPos(), c_Trace.HitPos, 300) then

					zrms_c_item:SetNoDraw(false)

					local aSwitch, pos , ang, hitent = zrmine.f.Swep_ActionSwitch(ply,c_ActiveWeapon,nil)

					c_ASwitch = aSwitch

					local itemData = zrmine.Swep_BuildItems[c_selectedItem]

					if c_ASwitch == 0 then

						zrms_c_item:SetColor(Color(255,0,0,200))
						zrms_c_item:SetModel(itemData.model)
						if ang then
							zrms_c_item:SetAngles(ang)
						else
							zrms_c_item:SetAngles(Angle(0, 0, 0))
						end

						zrms_c_item:SetPos( pos )
					elseif c_ASwitch == 1 then

						zrms_c_item:SetColor(Color(0,255,0,200))
						zrms_c_item:SetModel(itemData.model)


						if itemData.class == "zrms_crusher" then
							zrms_c_item:SetAngles(Angle(0, (ply:GetAngles().y-90) + c_ActiveWeapon:GetItemRotation(), 0))
						else
							zrms_c_item:SetAngles(ang)
						end
						zrms_c_item:SetPos( pos )
					elseif c_ASwitch == 2 then

						zrms_c_item:SetColor(Color(255,0,0,200))
						zrms_c_item:SetModel(hitent:GetModel())
						zrms_c_item:SetAngles(ang)
						zrms_c_item:SetPos( pos )

					end

				else
					zrms_c_item:SetNoDraw(true)
				end

			else
				SpawnClientModel(c_ActiveWeapon)
			end
		else
			if IsValid(zrms_c_item) then
				zrms_c_item:Remove()
			end
		end
	end)

	local matBallGlow = Material("models/effects/comball_tape")
	hook.Add("PostDrawTranslucentRenderables", "a_zrmine_Draw_builderswep", function()

		// Renders the shiny glimmer over the client model preview
		if IsValid(zrms_c_item) and zrms_c_item:GetNoDraw() == false then

			render.MaterialOverride(matBallGlow)

			if c_ASwitch == 0 then
				render.SetColorModulation(1,0,0)
			elseif c_ASwitch == 1 then
				render.SetColorModulation(0,1,0)
			elseif c_ASwitch == 2 then
				render.SetColorModulation(1,0,0)
			end

			zrms_c_item:DrawModel()

			render.MaterialOverride()
			render.SetColorModulation(1,1,1)
		end

		// Creates the sphere indicators to show where the player can connect the ent
		if IsValid(c_ActiveWeapon) and c_ActiveWeapon:GetClass() == "zrms_builder" and c_ASwitch ~= 2 then

			local itemData = zrmine.Swep_BuildItems[c_ActiveWeapon:GetItemSelected()]

			if c_Trace and c_Trace.Hit then
				for k, v in pairs(zrmine.EntList) do

					if IsValid(v) and zrmine.f.InDistance(c_Trace.HitPos, v:GetPos(),200) and zrmine.f.AllowedConnection(v:GetClass(), itemData.class) then

						for i = 1, table.Count(zrms_BuildOffset[v:GetClass()]) do

							local conData = zrms_BuildOffset[v:GetClass()][i]
							local lPos = v:LocalToWorld(conData.lPos + Vector(0,0,5))

							if zrmine.f.HasChildAtPos(v, i) == false and zrmine.f.PortAllowance(v, itemData.class, i) then
								render.SetColorMaterial()
								render.DrawWireframeSphere(lPos, 10, 6, 6, zrmine.default_colors["green02"], false)
							end
						end
					end
				end
			end
		end
	end)
end

function zrmine.f.ReachedEntityLimit(ply, class)
	local entityCount = 0
	local plyID = ply:SteamID()

	for k, v in pairs(zrmine.EntList) do
		if IsValid(v) and v:GetNWString("zrmine_Owner", "nil") == plyID and v:GetClass() == class then
			entityCount = entityCount + 1
		end
	end

	local reachedLimit = false
	local limit = zrmine.config.BuilderSWEP.entity_limit[class]
	local c_limit = hook.Run("zrmine_OverrideEntityLimit", ply, class)

	if c_limit then
		limit = c_limit
	end

	if entityCount >= limit then
		reachedLimit = true
	end

	return reachedLimit
end

if SERVER then
	hook.Add("PlayerButtonDown", "a_zrmine_PlayerButtonDown_builderswep", function(ply,key)

		if IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "zrms_builder" then

			if key == zrmine.config.BuilderSWEP.keys.switch_left then

				zrmine.f.Swep_SwitchItem(ply:GetActiveWeapon(),false)

			elseif key == zrmine.config.BuilderSWEP.keys.switch_right then

				zrmine.f.Swep_SwitchItem(ply:GetActiveWeapon(),true)

			elseif key == MOUSE_MIDDLE then
				zrmine.f.Swep_RotateItem(ply:GetActiveWeapon())
			end
		end
	end)

	function zrmine.f.Swep_SwitchItem(swep,forward)
		local id = swep:GetItemSelected()

		if forward then
			id = id + 1
		else
			id = id - 1
		end

		if id > table.Count(zrmine.Swep_BuildItems) then
			id = 1
		end

		if id <= 0 then
			id = table.Count(zrmine.Swep_BuildItems)
		end

		swep:SetItemSelected(id)
	end

	function zrmine.f.Swep_Primary(ply,weapon)

		local aSwitch, pos , ang , connectID, ParentModule = zrmine.f.Swep_ActionSwitch(ply,weapon,true)

		if aSwitch == 1 then
			local itemData = zrmine.Swep_BuildItems[weapon:GetItemSelected()]
			local cost = zrmine.config.BuilderSWEP.entity_price[itemData.class]

			if IsValid(ParentModule) and zrmine.f.IsAdmin(ply) == false and zrmine.f.IsOwner(ply, ParentModule) == false  then
				zrmine.f.Notify(ply, zrmine.language.Module_DontOwn, 0)

				return
			end


			if zrmine.f.HasMoney(ply, cost) then

				if zrmine.f.ReachedEntityLimit(ply,itemData.class) then
					zrmine.f.Notify(ply, zrmine.language.EntityLimitReached, 1)
					return
				end

				zrmine.f.TakeMoney(ply, cost)

				local info = zrmine.language.BuyInfo
				info = string.Replace(info, "$ItemName", itemData.name)
				info = string.Replace(info, "$Price", zrmine.config.Currency .. cost)
				zrmine.f.Notify(ply, info, 0)

				local ent = zrmine.f.Swep_CreateEntity(ply,weapon,pos,ang)

				local tblEnt = {
					price = cost,
					name = itemData.name or "",
				}
				hook.Run("playerBoughtCustomEntity", ply, tblEnt, ent, cost)


				// Make connect logic here
				zrmine.f.Swep_ConnectModule(ent,ParentModule,connectID)
			else
				zrmine.f.Notify(ply, zrmine.language.NotEnoughMoney, 1)
			end
		else
			zrmine.f.Debug("Cant build")
		end
	end

	// Creates the conveyorbelt ent
	function zrmine.f.Swep_CreateEntity(ply,weapon,pos,ang)

		local itemData = zrmine.Swep_BuildItems[weapon:GetItemSelected()]

		local ent = ents.Create(itemData.class)

		if itemData.class == "zrms_crusher" then
			ent:SetAngles(Angle(0, (ply:GetAngles().y-90) + weapon:GetItemRotation(), 0))
		else
			ent:SetAngles(ang)
		end

		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion(false)
		end

		ent.PhysgunDisabled = true
		zrmine.f.SetOwner(ent, ply)

		zrmine.f.Debug("Build Entity!")

		return ent
	end

	// Connects the conveyorbelt ent
	function zrmine.f.Swep_ConnectModule(ent, ParentModule,ConnectPos)

		if IsValid(ParentModule) then

			// Now the parent knows what his child is
			if ParentModule:GetClass() == "zrms_splitter" or string.sub(ParentModule:GetClass(), 1, 11) == "zrms_sorter" then

				if ConnectPos == 1 then
					ParentModule:SetModuleChild01(ent)
				elseif ConnectPos == 2 then
					ParentModule:SetModuleChild02(ent)
				end

			else
				ParentModule:SetModuleChild(ent)
			end

			// Here we tell the child at what position its connected
			ent:SetConnectionPos(ConnectPos)

			// Now the child knows his parent
			ent:SetModuleParent(ParentModule)

			zrmine.f.Debug("Connected " .. ent.PrintName .. "[" .. ent:EntIndex() .. "] to " .. ParentModule.PrintName .. "[" .. ParentModule:EntIndex() .. "] on Position " .. ConnectPos)

		end

		zrmine.f.CreateNetEffect("swep_buymodule",ent)

		// Here we have to search for a zrms Enity thats close to the exit point from the inserter so we can tell the inserter that this is his child now
		if ent:GetClass() == "zrms_inserter" then
			timer.Simple(1, function()
				if IsValid(ent) then
					zrmine.f.Inserter_SearchEndPart(ent)
				end
			end)
		end


		// Since we created a new entity we need to check if this changes anything for the existing Inserters
		hook.Run("zrms_VerifyInserterConnection")
	end



	function zrmine.f.Swep_Secondary(ply,weapon)

		local aSwitch, _ , _ , ent = zrmine.f.Swep_ActionSwitch(ply,weapon,false)

		if aSwitch == 2 then

			if IsValid(ent) and zrmine.f.IsAdmin(ply) == false and zrmine.f.IsOwner(ply, ent) == false then
				zrmine.f.Notify(ply, zrmine.language.Module_DontOwn, 0)

				return
			end

			if zrmine.config.BuilderSWEP.refund_val > 0 then
				local refund = zrmine.config.BuilderSWEP.entity_price[ent:GetClass()] * zrmine.config.BuilderSWEP.refund_val
				zrmine.f.GiveMoney(ply, refund)
				zrmine.f.Notify(ply, "+" .. zrmine.config.Currency .. refund, 0)

				zrmine.f.CreateNetEffect("swep_sellmodule",ply)
			else
				zrmine.f.CreateNetEffect("object_destroy",ply)
			end

			// DeConnects the module safefly from its parent
			zrmine.f.Swep_DeConnectModule(ent)
		else
			zrmine.f.Debug("Cant Deconstruct")
		end
	end

	// Deconnects the conveyorbelt ent and also removes it
	function zrmine.f.Swep_DeConnectModule(ChildModule)

		if IsValid(ChildModule) then

			local ParentModule = ChildModule:GetModuleParent()
			local ConnectPos = ChildModule:GetConnectionPos()

			if IsValid(ParentModule) then

				// Goodbye sweet summer child
				if ParentModule:GetClass() == "zrms_splitter" or string.sub(ParentModule:GetClass(), 1, 11) == "zrms_sorter"  then

					if ConnectPos == 1 then

						ParentModule:SetModuleChild01(NULL)
					elseif ConnectPos == 2 then

						ParentModule:SetModuleChild02(NULL)
					end

				else
					ParentModule:SetModuleChild(NULL)
				end

				// Cya Parent Module
				ChildModule:SetModuleParent(NULL)

				zrmine.f.Debug("DeConnected " .. ChildModule.PrintName .. "[" .. ChildModule:EntIndex() .. "] from " .. ParentModule.PrintName .. "[" .. ParentModule:EntIndex() .. "] on Position " .. ConnectPos)
			end

			// Child *commits suicide*
			ChildModule:Remove()

			// Since we removed a entity we need to check if this changes anything for the existing Inserters
			hook.Run("zrms_VerifyInserterConnection")
		end
	end
end
