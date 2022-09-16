zpiz = zpiz or {}
zpiz.config = zpiz.config or {}

zpiz.config.Pizza = {}
local function AddPizza(data) return table.insert(zpiz.config.Pizza,data) end

AddPizza({
    // The name of the Pizza
    name = "Magarita",

    // The Ingredients needed.
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1
    },

     // The Time in seconds the Pizza needs do be Baked
    time = 10,

    // The desciption of the Pizza
    desc = "A basic Pizza!",

    // The price of the Pizza (The ingredient cost gets later added to this value)
    price = 600,

    // How should the Pizza look when its done
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_magarita.png", "smooth"),

    // How high is the Chance that this Pizza gets choosen by a Customer (1-100)
    chance = 50,

    // How much Health gets the Player if he eats the Pizza
    health = 5,

    // Here you can define the custom health_cap
    health_cap = 100
})

AddPizza({
    name = "Pizza de espinacas",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_SPINAT] = 2,
    },
    time = 15,
    desc = "¡Una pizza realmente verde!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_spinat.png", "smooth"),
    chance = 25,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Pizza de salami",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_SALAMI] = 2,
    },
    time = 15,
    desc = "¡Una pizza de burro!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_salami.png", "smooth"),
    chance = 10,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Pizza de aceitunas",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_OLIVES] = 3,
    },
    time = 20,
    desc = "Una Pizza Italiano!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_olivia.png", "smooth"),
    chance = 10,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Grande Pizza",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_SALAMI] = 1,
        [ZPIZ_ING_OLIVES] = 1,
        [ZPIZ_ING_EGGPLANT] = 1,
        [ZPIZ_ING_SPINAT] = 1,
        [ZPIZ_ING_PICKLE] = 1,
    },
    time = 120,
    desc = "¡Una gran pizza!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_grande.png", "smooth"),
    chance = 5,
    health = 60,
    health_cap = 200
})

AddPizza({
    name = "Pizza de tocino",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_BACON] = 2,
    },
    time = 25,
    desc = "¡Tocino!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_bacon.png", "smooth"),
    chance = 10,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Pizza de huevo",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_EGG] = 1,
        [ZPIZ_ING_CHILLI] = 1,
        [ZPIZ_ING_BACON] = 1,
    },
    time = 25,
    desc = "Huevos y más Huevos.",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_egg.png", "smooth"),
    chance = 10,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Pizza de champiñones",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 1,
        [ZPIZ_ING_SPINAT] = 1,
        [ZPIZ_ING_CHILLI] = 1,
        [ZPIZ_ING_MUSHROOM] = 1,
    },
    time = 25,
    desc = "No te pone a volar.",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_mushroom.png", "smooth"),
    chance = 10,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Pizza hawaiana",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 2,
        [ZPIZ_ING_PINEAPPLE] = 1,
    },
    time = 30,
    desc = "¡Sabor tropical!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_hawai.png", "smooth"),
    chance = 10,
    health = 15,
    health_cap = 100
})

AddPizza({
    name = "Pizza de queso",
    recipe = {
        [ZPIZ_ING_TOMATO] = 1,
        [ZPIZ_ING_CHEESE] = 3,
    },
    time = 30,
    desc = "¡Una pizza de queso!",
    price = 600,
    icon = Material("materials/zerochain/zpizmak/ui/pizzas/pizza_cheese.png", "smooth"),
    chance = 10,
    health = 5,
    health_cap = 100
})
