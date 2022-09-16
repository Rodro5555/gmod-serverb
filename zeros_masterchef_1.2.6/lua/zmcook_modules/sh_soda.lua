
// This way you can append Items / Dishes after the main config has loaded

zmc.Item.LoadModule({
    uniqueid = "e83baad1cf",
    name = "Soda",
    skin = 2,
    mdl = "models/props_junk/PopCan01a.mdl",
    scale = 1,
    fridge = {price = 10,},
    sell = {price = 50,},
    edible = {health = 5,health_cap = 100,},
})

zmc.Dish.LoadModule({
    uniqueid = "7349296f4d",
    name = "Soda",
    mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
    time = 60,
    items = {
       {uniqueid = "e83baad1cf", lpos = Vector(0.5,0.5,0.22), lang = Angle(0,0,0),scale = 1},
    }
})
