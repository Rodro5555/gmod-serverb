zfs = zfs or {}
zfs.config = zfs.config or {}
zfs.config.Toppings = {}
local function AddTopping(data)
	if SERVER and data.Model then util.PrecacheModel(data.Model) end
	table.insert(zfs.config.Toppings,data)
end

//Available Benefits
// ["Health"] = ExtraHealth - 100
// ["ParticleEffect"] = Effectname   // In Mod Effects: zfs_health_effect,zfs_money_effect,zfs_energetic,zfs_ghost_effect
// ["SpeedBoost"] = SpeedBoost - 200
// ["AntiGravity"] = JumpBoost - 300
// ["Ghost"] = Alpha  - 0/255
// ["Drugs"] = ScreenEffectName  // In Mod ScreenEffects: MDMA,CACTI

// This is the item for NoTopping and should not be removed
AddTopping({
	Name = "Sin Adicionales",
	ExtraPrice = 0,
	Icon = Material("materials/zfruitslicer/ui/zfs_ui_nothing.png","smooth"),
	Model = nil,
	mScale = 1,
	Info = "Al menos es gratis xD",
	ToppingBenefits = {},
	ToppingBenefit_Duration = -1,
	ConsumInfo = "Tasty!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	// The Name of the Topping
	Name = "Bebé",

	// The Extra price when adding this topping
	ExtraPrice = 1000,

	// If specified we use a icon instead of the model itself
	Icon = nil,

	// The Topping Model that gets placed on the cup
	Model = "models/props_c17/doll01.mdl",

	// The Scale of the Topping Model
	mScale = 0.5,

	// The Info of the Topping
	Info = "Las Células Madre pueden curar el cáncer, ¡Así que comer esto te da más Salud!",

	// The Benefits the player gets when consuming this topping
	ToppingBenefits = {
		["Health"] = 200 // This Gives the Player extra Health
	},

	// The Duration of the Benefits, this only applys to benefits that have a length. Wont to anything on Health since its Instant
	ToppingBenefit_Duration = 0,

	// The Info the Player gets when consuming the Fruicup
	ConsumInfo = "¡Te sientes muy Saludable!",

	// This defines the Ranks who are allowed to consume the fruit cup if he has this topping, Leave empty to not Restrict it
	Ranks_consume = {},

	// This defines the Ranks who are allowed to add this topping to the fruit cup, Leave empty to not Restrict it
	Ranks_create = {},

	// This defines the Jobs who are allowed to consume the fruit cup if he has this topping, Leave empty to not Restrict it
	Job_consume = {
		//[TEAM_POLICE] = true,
		//[TEAM_GANG] = true,
	}
})

AddTopping({
	Name = "Café",
	ExtraPrice = 1000,
	Icon = nil,
	Model = "models/props_junk/garbage_metalcan002a.mdl",
	mScale = 0.5,
	Info = "¡No es bueno para la salud, pero te da un impulso de energía!",
	ToppingBenefits = {
		["ParticleEffect"] = "zfs_energetic",
		["SpeedBoost"] = 5
	},
	ToppingBenefit_Duration = 25,
	ConsumInfo = "¡Te sientes lleno de energía!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Orbe flotante",
	ExtraPrice = 5000,
	Icon = nil,
	Model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
	mScale = 0.2,
	Info = "Lo encontré en un cráter así que, ¿lo quieres?",
	ToppingBenefits = {
		["AntiGravity"] = 400
	},
	ToppingBenefit_Duration = 30,
	ConsumInfo = "¡Te sientes muy ligero!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Viejo Cráneo",
	ExtraPrice = 3000,
	Icon = nil,
	Model = "models/Gibs/HGIBS.mdl",
	mScale = 0.5,
	Info = "Algunos dicen que puedes entrar en la dimensión fantasma lamiéndola.",
	ToppingBenefits = {
		["Ghost"] = 25,
		["ParticleEffect"] = "zfs_ghost_effect"
	},
	ToppingBenefit_Duration = 30,
	ConsumInfo = "¡Te llenaste de Energía Oscura!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Mis Hulala",
	ExtraPrice = 6000,
	Icon = nil,
	Model = "models/props_lab/huladoll.mdl",
	mScale = 0.8,
	Info = "Dice Fiesta en el Fondo.",
	ToppingBenefits = {
		["Drugs"] = "MDMA"
	},
	ToppingBenefit_Duration = 45,
	ConsumInfo = "You tripping Ballz!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Jugo de Cáctus",
	ExtraPrice = 6000,
	Icon = nil,
	Model = "models/props_lab/cactus.mdl",
	mScale = 0.8,
	Info = "Bebe jugo de nopal. ¡Te saciará! ¡Es el más saciante!",
	ToppingBenefits = {
		["Drugs"] = "CACTI"
	},
	ToppingBenefit_Duration = 45,
	ConsumInfo = "¡Me siento más saciante!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Bebida energética",
	ExtraPrice = 5000,
	Icon = nil,
	Model = "models/props_junk/PopCan01a.mdl",
	mScale = 0.5,
	Info = "¡No es bueno para la salud, pero te da un impulso de energía!",
	ToppingBenefits = {
		["ParticleEffect"] = "zfs_energetic",
		["SpeedBoost"] = 10
	},
	ToppingBenefit_Duration = 25,
	ConsumInfo = "¡Te sientes lleno de energía!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Helio",
	ExtraPrice = 500,
	Icon = nil,
	Model = "models/Items/combine_rifle_ammo01.mdl",
	mScale = 0.4,
	Info = "Te hace sentir mareado y ligero.",
	ToppingBenefits = {
		["AntiGravity"] = 50
	},
	ToppingBenefit_Duration = 30,
	ConsumInfo = "¡Te sientes muy ligero!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "Jarabe para la tos",
	ExtraPrice = 100,
	Icon = nil,
	Model = "models/Items/HealthKit.mdl",
	mScale = 0.2,
	Info = "No necesita receta.",
	ToppingBenefits = {
		["Health"] = 25
	},
	ToppingBenefit_Duration = 0,
	ConsumInfo = "¡Te sientes muy Saludable!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})

AddTopping({
	Name = "DEC",
	ExtraPrice = 5000,
	Icon = nil,
	Model = "models/Items/battery.mdl",
	mScale = 0.5,
	Info = "Ese es uno de estos nuevos dispositivos de entrenamiento celular.",
	ToppingBenefits = {
		["Ghost"] = 25
	},
	ToppingBenefit_Duration = 30,
	ConsumInfo = "¡Te sientes casi invisible!",
	Ranks_consume = {},
	Ranks_create = {},
	Job_consume = {}
})
