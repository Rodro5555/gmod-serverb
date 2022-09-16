zmc = zmc or {}
zmc.config = zmc.config or {}


zmc.config.Items = {}
local function AddItem(data) return table.insert(zmc.config.Items, data) end

AddItem({
    uniqueid = "16c87b5937",
    name = zmc.language[ "Sugar" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_bag.mdl",
    scale = 0.62,
    fridge = {price = 10,},
})

AddItem({
    uniqueid = "b400990045",
    name = zmc.language[ "Salt" ],
    skin = 1,
    mdl = "models/zerochain/props_kitchen/food/zmc_bag.mdl",
    scale = 0.62,
    fridge = {price = 10,},
})

AddItem({
    uniqueid = "0ea4c4857e",
    name = zmc.language[ "Rice" ],
    skin = 2,
    mdl = "models/zerochain/props_kitchen/food/zmc_bag.mdl",
    scale = 0.62,
    fridge = {price = 10,},
    knead = {cycle = 3,item = "5665b79d01",amount = 1,},
})

AddItem({
    uniqueid = "d041e08a6c",
    name = zmc.language[ "Flower" ],
    skin = 3,
    mdl = "models/zerochain/props_kitchen/food/zmc_bag.mdl",
    scale = 0.62,
    fridge = {price = 10,},
})


AddItem({
    uniqueid = "1020e182a5",
    name = zmc.language[ "Milk" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_carton.mdl",
    scale = 0.5,
    fridge = {price = 10,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "da9f8cf872",
    name = zmc.language[ "Coffee" ],
    skin = 1,
    mdl = "models/zerochain/props_kitchen/food/zmc_carton.mdl",
    scale = 0.5,
    fridge = {price = 10,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "a5c7762153",
    name = zmc.language[ "Choco" ],
    skin = 2,
    mdl = "models/zerochain/props_kitchen/food/zmc_carton.mdl",
    scale = 0.5,
    fridge = {price = 10,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})



AddItem({
    uniqueid = "81212889ab",
    name = zmc.language[ "Steak - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_steak.mdl",
    scale = 0.58,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"866c7e563b",},},
    grill = {time = 50,item = "04f7f02dc4",},
})

AddItem({
    uniqueid = "04f7f02dc4",
    name = zmc.language[ "Steak - Grilled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_steak.mdl",
    scale = 0.58,
    bgs = {[0] = 1,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    grill = {time = 50,item = "8c63ddba71",},
})

AddItem({
    uniqueid = "8c63ddba71",
    name = zmc.language[ "Steak - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_steak.mdl",
    color = Color(40,40,40),scale = 0.58,
    bgs = {[0] = 1,},
    edible = {health = -5,health_cap = 100,},
})

AddItem({
    uniqueid = "9b4c95f15a",
    name = zmc.language[ "Egg" ],
    skin = 0,
    mdl = "models/props_phx/misc/egg.mdl",
    color = Color(255,255,255),scale = 0.9,
    fridge = {price = 10,},
})


AddItem({
    uniqueid = "8320529dc9",
    name = zmc.language[ "Fish01" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    scale = 0.3,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"bcd2be2f24","2e6b44054c","4bb3ddc511",},},
})

AddItem({
    uniqueid = "bcd2be2f24",
    name = zmc.language[ "Fish - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    scale = 0.46,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"8e9dbc3e11",},},
    grill = {time = 50,item = "34b37629c7",},
})

AddItem({
    uniqueid = "34b37629c7",
    name = zmc.language[ "Fish - Grilled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    scale = 0.46,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    grill = {time = 50,item = "84b838b0fe",},
})

AddItem({
    uniqueid = "84b838b0fe",
    name = zmc.language[ "Fish - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    color = Color(22,22,22),scale = 0.46,
    bgs = {[0] = 2,},
    edible = {health = -5,health_cap = 100,},
})

AddItem({
    uniqueid = "8e9dbc3e11",
    name = zmc.language[ "Fish - Stripes" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    scale = 0.46,
    bgs = {[0] = 3,},
})

AddItem({
    uniqueid = "4bb3ddc511",
    name = zmc.language[ "Fish - Tail" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    scale = 0.46,
    bgs = {[0] = 4,},
})

AddItem({
    uniqueid = "2e6b44054c",
    name = zmc.language[ "Fish - Head" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish01.mdl",
    scale = 0.46,
    bgs = {[0] = 5,},
})

AddItem({
    uniqueid = "821efb0ecc",
    name = zmc.language[ "Fish02" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish02.mdl",
    scale = 0.18,
    fridge = {price = 10,},
    grill = {time = 50,item = "9d3460cb03",},
})

AddItem({
    uniqueid = "9d3460cb03",
    name = zmc.language[ "Fish02 - Grilled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish02.mdl",
    scale = 0.18,
    bgs = {[0] = 1,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    grill = {time = 50,item = "8b3bfc164a",},
})

AddItem({
    uniqueid = "8b3bfc164a",
    name = zmc.language[ "Fish02 - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_fish02.mdl",
    color = Color(47,47,47),scale = 0.18,
    bgs = {[0] = 1,},
    edible = {health = -5,health_cap = 100,},
})


AddItem({
    uniqueid = "30e7fd51fd",
    name = zmc.language[ "Seaweed" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_seaweed.mdl",
    scale = 0.48,
    fridge = {price = 10,},
})

AddItem({
    uniqueid = "4e59caf7a3",
    name = zmc.language[ "Greens" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_greens.mdl",
    scale = 0.38,
    fridge = {price = 10,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})




AddItem({
    uniqueid = "78dfebd6ff",
    name = zmc.language[ "Spagetti - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pasta.mdl",
    scale = 0.68,
    fridge = {price = 10,},
    boil = {
        time = 50,
        item = "f4854900ea",
        temp = {start = 16,range = 42,}
    },
})

AddItem({
    uniqueid = "f4854900ea",
    name = zmc.language[ "Spagetti - Boiled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pasta.mdl",
    scale = 0.68,
    bgs = {[0] = 1,},
})

AddItem({
    uniqueid = "41ea426784",
    name = zmc.language[ "Spagetti - Veg" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pasta.mdl",
    scale = 0.68,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    wok = {
        cycle = 3,
        range = 0.25,
        amount = 3,
        appearance = {
            mdl = "models/zerochain/props_kitchen/food/zmc_pasta.mdl",
            scale = 0.69,
            skin = 0,
            color = Color(255,255,255),
            material = "",
            lpos = Vector(0.5,0.5,0.41),
            bgs = {[0] = 2,},
        },
        items = {"f4854900ea","4e59caf7a3",},
    },
})

AddItem({
    uniqueid = "eaf4422d32",
    name = zmc.language[ "Spagetti - Meat" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pasta.mdl",
    scale = 0.68,
    bgs = {[0] = 3,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    wok = {
        cycle = 3,
        range = 0.25,
        amount = 3,
        appearance = {
            mdl = "models/zerochain/props_kitchen/food/zmc_pasta.mdl",
            scale = 0.7,
            skin = 0,
            color = Color(255,255,255),
            material = "",
            lpos = Vector(0.5,0.5,0.41),
            bgs = {[0] = 3,},
        },
        items = {"f4854900ea","866c7e563b",},
    },
})



AddItem({
    uniqueid = "09e9599992",
    name = zmc.language[ "Rice - Cooked" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_rice.mdl",
    scale = 0.78,
    bgs = {[0] = 1,},
})

AddItem({
    uniqueid = "5665b79d01",
    name = zmc.language[ "Rice - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_rice.mdl",
    scale = 0.78,
    bgs = {[0] = 0,},
    boil = {
        time = 50,
        item = "09e9599992",
        temp = {start = 21,range = 25,}
    },
})

AddItem({
    uniqueid = "7d94e1772b",
    name = zmc.language[ "Maki Roll - Fish" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.48,
    cut = {cycle = 3,items = {"9277032494","9277032494","9277032494","9277032494","9277032494",},},
    craft = {
        amount = 1,
        items = {"8e9dbc3e11","30e7fd51fd","09e9599992",},
    },
})

AddItem({
    uniqueid = "28806b86d1",
    name = zmc.language[ "Maki Roll - Avocado" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.54,
    bgs = {[0] = 2,},
    cut = {cycle = 3,items = {"7a872ba507","7a872ba507","7a872ba507","7a872ba507","7a872ba507",},},
    craft = {
        amount = 1,
        items = {"30e7fd51fd","09e9599992","3b01f7a606",},
    },
})

AddItem({
    uniqueid = "0351ac5237",
    name = zmc.language[ "Maki Roll - Cucumber" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.54,
    bgs = {[0] = 6,},
    cut = {cycle = 3,items = {"86a893eaf8","86a893eaf8","86a893eaf8","86a893eaf8","86a893eaf8",},},
    craft = {
        amount = 1,
        items = {"30e7fd51fd","09e9599992","d474d26245",},
    },
})

AddItem({
    uniqueid = "9b979fcd20",
    name = zmc.language[ "Maki Roll - Takuan" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.56,
    bgs = {[0] = 4,},
    cut = {cycle = 3,items = {"4e37b88234","4e37b88234","4e37b88234","4e37b88234","4e37b88234",},},
    craft = {
        amount = 1,
        items = {"30e7fd51fd","09e9599992","372c7b284a",},
    },
})

AddItem({
    uniqueid = "9277032494",
    name = zmc.language[ "Maki - Fish" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.54,
    bgs = {[0] = 1,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "7a872ba507",
    name = zmc.language[ "Maki - Avocado" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.5,
    bgs = {[0] = 3,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "4e37b88234",
    name = zmc.language[ "Maki - Takuan" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.54,
    bgs = {[0] = 5,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "86a893eaf8",
    name = zmc.language[ "Maki - Cucumber" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_sushi_maki.mdl",
    scale = 0.54,
    bgs = {[0] = 7,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})



AddItem({
    uniqueid = "556b148d54",
    name = zmc.language[ "Baguette - Dough" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_baguette_dough.mdl",
    scale = 0.54,
    knead = {cycle = 3,item = "2e4cf6fa44",amount = 6,},
    mix = {
        time = 50,
        speed = 6,
        items = {"d041e08a6c","b400990045","9b4c95f15a",},
    },
})

AddItem({
    uniqueid = "2e4cf6fa44",
    name = zmc.language[ "Baguette - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_baguette.mdl",
    scale = 0.24,
    bake = {
        time = 50,
        item = "65c1cfef95",
        temp = {start = 60,range = 42,}
    },
})

AddItem({
    uniqueid = "65c1cfef95",
    name = zmc.language[ "Baguette - Baked" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_baguette.mdl",
    scale = 0.24,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"1545d45cc1",},},
    bake = {
        time = 50,
        item = "e9bc17ead9",
        temp = {start = 0,range = 100,}
    },
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "1545d45cc1",
    name = zmc.language[ "Baguette - Half" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_baguette.mdl",
    scale = 0.24,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "e9bc17ead9",
    name = zmc.language[ "Baguette - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_baguette.mdl",
    color = Color(0,0,0),scale = 0.24,
    bgs = {[0] = 1,},
    edible = {health = -5,health_cap = 100,},
})




AddItem({
    uniqueid = "16ccb2bdf1",
    name = zmc.language[ "Tomatos" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_tomato.mdl",
    scale = 0.56,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"b6e2aa0661","b6e2aa0661","b6e2aa0661","b6e2aa0661",},},
})

AddItem({
    uniqueid = "b6e2aa0661",
    name = zmc.language[ "Tomato" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_tomato.mdl",
    scale = 0.46,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"8398b7a744","8398b7a744","8398b7a744",},},
})

AddItem({
    uniqueid = "8398b7a744",
    name = zmc.language[ "Tomato - Slice" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_tomato.mdl",
    scale = 0.46,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "6f6a49659c",
    name = zmc.language[ "Tomato - Sauce" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_rice.mdl",
    material = "zerochain/props_kitchen/food/zmc_tomato_sauce",scale = 0.58,
    bgs = {[0] = 0,},
    craft = {
        amount = 3,
        items = {"16ccb2bdf1","4e59caf7a3","b400990045",},
    },
})





AddItem({
    uniqueid = "5084899665",
    name = zmc.language[ "Takuan" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_takuan.mdl",
    scale = 0.36,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"21f0a3bf97",},},
})

AddItem({
    uniqueid = "21f0a3bf97",
    name = zmc.language[ "Takuan - Peeled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_takuan.mdl",
    scale = 0.36,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"372c7b284a",},},
})

AddItem({
    uniqueid = "372c7b284a",
    name = zmc.language[ "Takuan - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_takuan.mdl",
    scale = 0.36,
    bgs = {[0] = 2,},
})



AddItem({
    uniqueid = "b4d90ff966",
    name = zmc.language[ "Avocado" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_avocado.mdl",
    scale = 0.54,
    fridge = {price = 10,},
    cut = {cycle = 4,items = {"e5c3faf4d7","3b01f7a606",},},
})

AddItem({
    uniqueid = "e5c3faf4d7",
    name = zmc.language[ "Avocado - Cut Half" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_avocado.mdl",
    scale = 0.54,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"3b01f7a606","752be633dc",},},
})

AddItem({
    uniqueid = "3b01f7a606",
    name = zmc.language[ "Avocado - Stripes" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_avocado.mdl",
    scale = 0.54,
    bgs = {[0] = 2,},
})

AddItem({
    uniqueid = "752be633dc",
    name = zmc.language[ "Avocado - Seed" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_avocado.mdl",
    scale = 0.54,
    bgs = {[0] = 3,},
})




AddItem({
    uniqueid = "32be271eea",
    name = zmc.language[ "Cucumber" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pickle.mdl",
    scale = 0.36,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"0d739fd555","d474d26245","d474d26245","18c8ba9e90","18c8ba9e90",},},
})

AddItem({
    uniqueid = "0d739fd555",
    name = zmc.language[ "Cucumber - Half" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pickle.mdl",
    scale = 0.36,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"d474d26245","d474d26245","18c8ba9e90","18c8ba9e90",},},
})

AddItem({
    uniqueid = "d474d26245",
    name = zmc.language[ "Cucumber - Stripe" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pickle.mdl",
    scale = 0.36,
    bgs = {[0] = 2,},
})

AddItem({
    uniqueid = "18c8ba9e90",
    name = zmc.language[ "Cucumber - Slice" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pickle.mdl",
    scale = 0.36,
    bgs = {[0] = 3,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})





AddItem({
    uniqueid = "d4ccdc4a01",
    name = zmc.language[ "Potato" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_potato.mdl",
    scale = 0.74,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"c082388442",},},
})

AddItem({
    uniqueid = "c082388442",
    name = zmc.language[ "Potato - Peeled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_potato.mdl",
    scale = 0.74,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"7b8b7b639d",},},
})

AddItem({
    uniqueid = "7b8b7b639d",
    name = zmc.language[ "Pommes - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_potato.mdl",
    scale = 0.74,
    bgs = {[0] = 2,},
})

AddItem({
    uniqueid = "3b44867a77",
    name = zmc.language[ "Pommes - Fried" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_potato.mdl",
    scale = 0.74,
    bgs = {[0] = 3,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    wok = {
        cycle = 3,
        range = 0.25,
        amount = 3,
        appearance = {
            mdl = "models/zerochain/props_kitchen/food/zmc_potato.mdl",
            scale = 0.52,
            skin = 0,
            color = Color(255,255,255),
            material = "",
            lpos = Vector(0.5,0.5,0.47),
            bgs = {[0] = 2,},
        },
        items = {"7b8b7b639d",},
    },
})




AddItem({
    uniqueid = "866c7e563b",
    name = zmc.language[ "Minced Meat" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    scale = 0.5,
    cut = {cycle = 3,items = {"ff3877268a","ff3877268a","ff3877268a","ff3877268a",},},
    knead = {cycle = 3,item = "66930222a0",amount = 5,},
})

AddItem({
    uniqueid = "66930222a0",
    name = zmc.language[ "Minced Meat - Patty" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    color = Color(255,255,255),scale = 0.38,
    bgs = {[0] = 1,},
    grill = {time = 50,item = "08f87f8949",},
})

AddItem({
    uniqueid = "ff3877268a",
    name = zmc.language[ "Chevapchichi - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    scale = 0.38,
    bgs = {[0] = 2,},
    grill = {time = 50,item = "4629ad1cd2",},
})

AddItem({
    uniqueid = "08f87f8949",
    name = zmc.language[ "Patty" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    color = Color(123,100,73),scale = 0.38,
    bgs = {[0] = 1,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    grill = {time = 50,item = "a6e44d61db",},
})

AddItem({
    uniqueid = "a6e44d61db",
    name = zmc.language[ "Patty - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    color = Color(27,27,27),scale = 0.38,
    bgs = {[0] = 1,},
    edible = {health = -5,health_cap = 100,},
})

AddItem({
    uniqueid = "4629ad1cd2",
    name = zmc.language[ "Chevapchichi" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    color = Color(141,111,83),scale = 0.38,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    grill = {time = 50,item = "653f68ea72",},
})

AddItem({
    uniqueid = "653f68ea72",
    name = zmc.language[ "Chevapchichi - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_meat_minced.mdl",
    color = Color(37,37,37),scale = 0.38,
    bgs = {[0] = 2,},
    edible = {health = -5,health_cap = 100,},
})



AddItem({
    uniqueid = "a85a14cb0c",
    name = zmc.language[ "Pizza - Dough" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.56,
    knead = {cycle = 3,item = "9ee32d6db9",amount = 3,},
    mix = {
        time = 50,
        speed = 10,
        items = {"b400990045","d041e08a6c","9b4c95f15a",},
    },
})

AddItem({
    uniqueid = "9ee32d6db9",
    name = zmc.language[ "Pizza - Dough Flat" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.36,
    bgs = {[0] = 1,},
})

AddItem({
    uniqueid = "5731a2735a",
    name = zmc.language[ "Pizza - Hawai - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.34,
    bgs = {[0] = 2,},
    bake = {
        time = 50,
        item = "2aac6d3d04",
        temp = {start = 70,range = 25,}
    },
    craft = {
        amount = 1,
        items = {"6f6a49659c","9ee32d6db9","9e4977a760",},
    },
})

AddItem({
    uniqueid = "2aac6d3d04",
    name = zmc.language[ "Pizza - Hawai" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.38,
    bgs = {[0] = 3,},
    bake = {
        time = 50,
        item = "8bd25133ae",
        temp = {start = 0,range = 100,}
    },
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "d20fcafabc",
    name = zmc.language[ "Pizza - Veg  - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.32,
    bgs = {[0] = 4,},
    bake = {
        time = 50,
        item = "840f02da26",
        temp = {start = 70,range = 25,}
    },
    craft = {
        amount = 1,
        items = {"6f6a49659c","9ee32d6db9","4e59caf7a3",},
    },
})

AddItem({
    uniqueid = "840f02da26",
    name = zmc.language[ "Pizza - Veg" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.38,
    bgs = {[0] = 5,},
    bake = {
        time = 50,
        item = "8bd25133ae",
        temp = {start = 0,range = 100,}
    },
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "99e8d42470",
    name = zmc.language[ "Pizza - Meat  - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.32,
    bgs = {[0] = 6,},
    bake = {
        time = 50,
        item = "9da14724e3",
        temp = {start = 70,range = 25,}
    },
    craft = {
        amount = 1,
        items = {"6f6a49659c","9ee32d6db9","81212889ab",},
    },
})

AddItem({
    uniqueid = "9da14724e3",
    name = zmc.language[ "Pizza - Meat" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    scale = 0.38,
    bgs = {[0] = 7,},
    bake = {
        time = 50,
        item = "8bd25133ae",
        temp = {start = 0,range = 100,}
    },
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "8bd25133ae",
    name = zmc.language[ "Pizza - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    color = Color(30,30,30),scale = 0.38,
    bgs = {[0] = 3,},
    edible = {health = -5,health_cap = 100,},
})



AddItem({
    uniqueid = "ea458ea3d8",
    name = zmc.language[ "Burger - Dough" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pizza.mdl",
    color = Color(189,170,137),scale = 0.46,
    knead = {cycle = 3,item = "3120a6f21f",amount = 3,},
    mix = {
        time = 50,
        speed = 5,
        items = {"b400990045","d041e08a6c","9b4c95f15a",},
    },
})

AddItem({
    uniqueid = "3120a6f21f",
    name = zmc.language[ "Burger - Bread - Raw" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_burger_bread.mdl",
    material = "zerochain/props_kitchen/food/zmc_pizza_dough_diff",color = Color(189,170,137),scale = 0.5,
    bake = {
        time = 50,
        item = "b32f54a2b6",
        temp = {start = 50,range = 25,}
    },
})

AddItem({
    uniqueid = "b32f54a2b6",
    name = zmc.language[ "Burger - Bread" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_burger_bread.mdl",
    material = "",color = Color(189,170,137),scale = 0.5,
    cut = {cycle = 3,items = {"c46279e450","d042cd82c9",},},
    bake = {
        time = 50,
        item = "237e49525a",
        temp = {start = 0,range = 100,}
    },
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "c46279e450",
    name = zmc.language[ "Burger - Bread - CutA" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_burger_bread.mdl",
    material = "",color = Color(189,170,137),scale = 0.5,
    bgs = {[0] = 1,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "d042cd82c9",
    name = zmc.language[ "Burger - Bread - CutB" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_burger_bread.mdl",
    material = "",color = Color(189,170,137),scale = 0.5,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "237e49525a",
    name = zmc.language[ "Burger - Bread - Burned" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_burger_bread.mdl",
    material = "",color = Color(27,26,23),scale = 0.5,
    edible = {health = -5,health_cap = 100,},
})





AddItem({
    uniqueid = "a3cecf5f71",
    name = zmc.language[ "Soup - Generic" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
    material = "zerochain/props_kitchen/food/zmc_soup_generic_diff",scale = 0.6,
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    soup = {
        time = 128,
        amount = 3,
        appearance = {
            mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
            scale = 0.44,
            skin = 0,
            color = Color(255,255,255),
            material = "zerochain/props_kitchen/food/zmc_soup_generic_diff",
            lpos = Vector(0.5,0.5,0.93),
            },
        items = {"b6e2aa0661","372c7b284a","4e59caf7a3",},
    },
})

AddItem({
    uniqueid = "6a5a74689c",
    name = zmc.language[ "Soup - Tomato" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
    material = "zerochain/props_kitchen/food/zmc_soup_red_diff",scale = 0.6,
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    soup = {
        time = 128,
        amount = 3,
        appearance = {
            mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
            scale = 0.44,
            skin = 0,
            color = Color(255,255,255),
            material = "zerochain/props_kitchen/food/zmc_soup_red_diff",
            lpos = Vector(0.5,0.5,0.93),
            },
        items = {"b6e2aa0661","4e59caf7a3","b6e2aa0661","b6e2aa0661",},
    },
})

AddItem({
    uniqueid = "5417ddb5ba",
    name = zmc.language[ "Soup - Goulash" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
    material = "zerochain/props_kitchen/food/zmc_soup_goulash_diff",scale = 0.6,
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    soup = {
        time = 145,
        amount = 3,
        appearance = {
            mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
            scale = 0.44,
            skin = 0,
            color = Color(255,255,255),
            material = "zerochain/props_kitchen/food/zmc_soup_goulash_diff",
            lpos = Vector(0.5,0.5,0.93),
            },
        items = {"b6e2aa0661","372c7b284a","4e59caf7a3","81212889ab",},
    },
})




AddItem({
    uniqueid = "745a47fc29",
    name = zmc.language[ "Coconut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_coconut.mdl",
    scale = 0.6,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"443a66df44",},},
})

AddItem({
    uniqueid = "443a66df44",
    name = zmc.language[ "Coconut - Peeled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_coconut.mdl",
    scale = 0.6,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"6efd82b86e","6efd82b86e",},},
})

AddItem({
    uniqueid = "9e4977a760",
    name = zmc.language[ "Coconut - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_coconut.mdl",
    scale = 0.6,
    bgs = {[0] = 3,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "6efd82b86e",
    name = zmc.language[ "Coconut - Half" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_coconut.mdl",
    scale = 0.6,
    bgs = {[0] = 2,},
    cut = {cycle = 3,items = {"9e4977a760",},},
})


AddItem({
    uniqueid = "fdda0db5da",
    name = zmc.language[ "Strawberry" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_strawberry.mdl",
    scale = 1,
    fridge = {price = 10,},
    cut = {cycle = 2,items = {"8d84b61517",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "8d84b61517",
    name = zmc.language[ "Strawberry - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_strawberry.mdl",
    scale = 1,
    bgs = {[0] = 2,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "ce07ee2d41",
    name = zmc.language[ "Strawberry - Pile" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_strawberry.mdl",
    scale = 1,
    bgs = {[0] = 3,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
    craft = {
        amount = 1,
        items = {"8d84b61517","8d84b61517","8d84b61517","8d84b61517",},
    },
})



AddItem({
    uniqueid = "d602991674",
    name = zmc.language[ "Banana" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_banana.mdl",
    scale = 0.56,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"8b4ba03536",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "8b4ba03536",
    name = zmc.language[ "Banana - Peeled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_banana.mdl",
    scale = 0.56,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"27f929103f",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "27f929103f",
    name = zmc.language[ "Banana - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_banana.mdl",
    scale = 0.56,
    bgs = {[0] = 3,},
    edible = {health = 5,health_cap = 100,},
})




AddItem({
    uniqueid = "d209f69599",
    name = zmc.language[ "Lemon" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_lemon.mdl",
    scale = 0.88,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"314e9fd3c9",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "314e9fd3c9",
    name = zmc.language[ "Lemon - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_lemon.mdl",
    scale = 0.88,
    bgs = {[0] = 2,},
    cut = {cycle = 3,items = {"b263649ecd","b263649ecd","b263649ecd","b263649ecd",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "b263649ecd",
    name = zmc.language[ "Lemon - Single" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_lemon.mdl",
    scale = 0.88,
    bgs = {[0] = 1,},
    edible = {health = 5,health_cap = 100,},
})



AddItem({
    uniqueid = "eeda52b2a3",
    name = zmc.language[ "Orange" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_orange.mdl",
    scale = 0.84,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"a98e7d9526",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "a98e7d9526",
    name = zmc.language[ "Orange - Peeled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_orange.mdl",
    scale = 0.84,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"375e8d09af",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "375e8d09af",
    name = zmc.language[ "Orange - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_orange.mdl",
    scale = 0.84,
    bgs = {[0] = 3,},
    cut = {cycle = 3,items = {"caa39cd60a","caa39cd60a","caa39cd60a","caa39cd60a",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "caa39cd60a",
    name = zmc.language[ "Orange - Single" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_orange.mdl",
    scale = 0.84,
    bgs = {[0] = 4,},
    edible = {health = 5,health_cap = 100,},
})




AddItem({
    uniqueid = "19b5a78493",
    name = zmc.language[ "Pomegranate" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pomegranate.mdl",
    scale = 0.88,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"7cddc8d8e7","7cddc8d8e7",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "7cddc8d8e7",
    name = zmc.language[ "Pomegranate - Half" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pomegranate.mdl",
    scale = 0.88,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"353cde661a","353cde661a",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "353cde661a",
    name = zmc.language[ "Pomegranate - Seeds" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_pomegranate.mdl",
    scale = 0.88,
    bgs = {[0] = 3,},
    edible = {health = 5,health_cap = 100,},
})



AddItem({
    uniqueid = "509406902c",
    name = zmc.language[ "Watermelon" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_watermelon.mdl",
    scale = 0.78,
    fridge = {price = 10,},
    cut = {cycle = 4,items = {"5c2086aa20","5c2086aa20","5c2086aa20","5c2086aa20",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "5c2086aa20",
    name = zmc.language[ "Watermelon - Split" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_watermelon.mdl",
    scale = 0.78,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"93084c54c9",},},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "93084c54c9",
    name = zmc.language[ "Watermelon - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_watermelon.mdl",
    scale = 0.78,
    bgs = {[0] = 2,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})




AddItem({
    uniqueid = "e29eab9e31",
    name = zmc.language[ "Kiwi" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_kiwi.mdl",
    scale = 0.92,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"a119a3845d",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "a119a3845d",
    name = zmc.language[ "Kiwi - Peeled" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_kiwi.mdl",
    scale = 0.92,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"9b34cb08bd",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "9b34cb08bd",
    name = zmc.language[ "Kiwi - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_kiwi.mdl",
    scale = 0.92,
    bgs = {[0] = 3,},
    cut = {cycle = 3,items = {"9d31cd1621","9d31cd1621","9d31cd1621","9d31cd1621",},},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "9d31cd1621",
    name = zmc.language[ "Kiwi - Single" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_kiwi.mdl",
    scale = 0.92,
    bgs = {[0] = 4,},
    sell = {price = 50,},
    edible = {health = 1,health_cap = 100,},
})




AddItem({
    uniqueid = "b0a15f8bef",
    name = zmc.language[ "Apple" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_apple.mdl",
    scale = 0.66,
    fridge = {price = 10,},
    cut = {cycle = 3,items = {"d53bb74dcc",},},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "d53bb74dcc",
    name = zmc.language[ "Apple - Cut" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_apple.mdl",
    scale = 0.54,
    bgs = {[0] = 1,},
    cut = {cycle = 3,items = {"66eedc9430","66eedc9430","66eedc9430","66eedc9430",},},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

AddItem({
    uniqueid = "66eedc9430",
    name = zmc.language[ "Apple - Single" ],
    skin = 0,
    mdl = "models/zerochain/props_kitchen/food/zmc_apple.mdl",
    scale = 0.56,
    bgs = {[0] = 2,},
    edible = {health = 5,health_cap = 100,},
})
