AAS = AAS or {}

--fr, en, pl, de, tr, ru
--[[ You can choose between this langages fr, en, de, ru, es, tr, pl ]]
AAS.Lang = "es"

--[[ Here you can change the title of the main menu ( "WELCOME, WHAT ARE YOU BUYING?" )]]
--[[ Don't touch if you want to get the basic text ]]
AAS.TitleMenu = ""

--[[ Set to true if you want to activate the download of all materials ]]
AAS.FastDL = false

--[[ If you use mysql you have to activate this and configure the mysql information and restart your server !! ]]
AAS.Mysql = false

--[[ How long the new tag remains when an object is added 1 = 1 day, 2 = 2 days, 0.5 = 12 hours ... ]]
AAS.NewTime = 1

--[[ Set to true if you want to use the notification of the addon ]]
AAS.ActivateNotification = true

--[[ If you want to open the menu with a key you need to set to true this variable ]]
AAS.OpenShopWithKey = false

--[[ Here you can modify key for open the shop menu https://wiki.facepunch.com/gmod/Enums/KEY ]]
AAS.ShopKey = KEY_F8

--[[ If you want to open the menu with a key you need to set to true this variable ]]
AAS.OpenBodyGroupWithKey = false

--[[ Here you can modify key for open the bodygroup menu https://wiki.facepunch.com/gmod/Enums/KEY ]]
AAS.BodyGroupKey = KEY_F5

--[[ If you want to open the menu with a key you need to set to true this variable ]]
AAS.OpenModelChangerWithKey = false

--[[ Here you can modify key for open the model changer menu https://wiki.facepunch.com/gmod/Enums/KEY ]]
AAS.ModelChangerKey = KEY_F9

--[[ If you want to reload item when you come back to the server ]]
AAS.LoadItemsSaved = true

--[[ If you want to reload the model when you come back to the server ]]
AAS.LoadModelSaved = true

--[[ Refund pourcentage of the accessory ]]
AAS.SellValue = 50

--[[ If the player can modify the offset of items bought ]]
AAS.ModifyOffset = false

--[[
    You need to restart the server when you add a new content into this table

    This is the table where you can load the default id of content who was configured for you
    572310302 = https://steamcommunity.com/sharedfiles/filedetails/?id=572310302 
    148215278 = https://steamcommunity.com/sharedfiles/filedetails/?id=148215278
    282958377 = https://steamcommunity.com/sharedfiles/filedetails/?id=282958377
    158532239 = https://steamcommunity.com/sharedfiles/filedetails/?id=158532239
    551144079 = https://steamcommunity.com/sharedfiles/filedetails/?id=551144079
    826536617 = https://steamcommunity.com/sharedfiles/filedetails/?id=826536617
    166177187 = https://steamcommunity.com/sharedfiles/filedetails/?id=166177187
    354739227 = https://steamcommunity.com/sharedfiles/filedetails/?id=354739227
]]

AAS.LoadWorkshop = {
    ["572310302"] = true,
    ["148215278"] = true,
    ["282958377"] = false,
    ["158532239"] = false,
    ["551144079"] = false,
    ["826536617"] = false,
    ["166177187"] = true,
    ["354739227"] = false,
}

--[[ Time to wear the accessory when you use the swep ]]
AAS.WearTimeAccessory = 2

--[[ Whitch rank can add, modify and configure items ]]
AAS.AdminRank = {
    ["superadmin"] = true,
    ["desarrollador"] = true,
}

--[[ Which job can't have accessory equiped ]]
AAS.BlackListJobAccessory = {
    ["Medico"] = true,
    ["Policia"] = true,
    ["Presidente"] = true,
    ["SWAT"] = true,
    ["F.B.I (Investigacion)"] = true,
    ["Comisario"] = true,
    ["Coalition Operative"] = true,
    ["Policia Antidrogas"] = true,
    ["Policia de Transito"] = true,
}

--[[ Which command for open the admin menu ]]
AAS.AdminCommand = "/aasconfig"

--[[ Can open item menu with a command ]]
AAS.OpenItemMenuCommand = false

AAS.ItemsMenuCommand = "/aas"

--[[ Here you can modify gradient colors]]
AAS.Gradient = {
    ["upColor"] = Color(18, 30, 42, 200), 
    ["midleColor"] = Color(27, 59, 89, 200),
    ["downColor"] = Color(54, 140, 220), 
}

--[[ The name of the swep ]]
AAS.SwepName = "Inventory Swep"

--[[ If you want to be able to buy, sell item when you open the menu with the swep ]]
AAS.BuyItemWithSwep = true

--[[ If you want to activate the weight module ]]
AAS.WeightActivate = false

--[[ All can have 10 items and Vip can have 30 items in his inventory ]]
AAS.WeightInventory = {
    ["all"] = 4, -- don't touch to the name of the category !!!!
    ["vipinicial"] = 5,
    ["vipgiant"] = 7,
    ["viplegend"] = 9,
    ["vipblackblood"] = 12,
}

AAS.ItemNpcModel = "models/Humans/Group01/Female_02.mdl"

AAS.ItemNpcName = "Vendedor de accesorios"

AAS.BodyGroupModel = "models/props_c17/FurnitureDresser001a.mdl"

AAS.BodyGroupsName = "Cambiador de grupos corporales"

AAS.ModelChanger = "models/props_c17/FurnitureDresser001a.mdl"

AAS.ModelName = "Cambiador de modelos"

--[[ Whitch job can't change his bodygroups and can't open the bodygroups armory ]]
AAS.BlackListBodyGroup = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ Whitch job can't choose, buy, sell accessory and can't access to the menu ]]
AAS.BlackListItemsMenu = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ Whitch job can't change his models ]]
AAS.BlackListModelsMenu = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ If you want to use darkrp model when you try to change your model ]]
AAS.UseDarkRPModel = true

--[[ Here you can add your model]]
AAS.CustomModelTable = {
}

--[[ Here you can modify all color used by the addon ]]
AAS.Colors = {
    ["whiteConfig"] = Color(255,255,255),
    ["white"] = Color(240,240,240),
    ["black"] = Color(0,0,0),
    ["black100"] = Color(0,0,0,100),
    ["black150"] = Color(0,0,0,150),
    ["black18"] = Color(18, 30, 42),
    ["black18230"] = Color(18, 30, 42, 230),
    ["black18200"] = Color(18, 30, 42, 200),
    ["black18100"] = Color(18, 30, 42, 100),
    ["background"] = Color(25, 40, 55),
    ["selectedBlue"] = Color(53, 139, 219),
    ["white200"] = Color(255,255,255,200),
    ["white50"] = Color(255,255,255,50),
    ["yellow"] = Color(255, 198, 57),
    ["darkBlue"] = Color(49, 98, 255),
    ["dark34"] = Color(34,34,34),
    ["blue77"] = Color(77, 128, 255),
    ["red49"] = Color(255, 49, 84), 
    ["grey"] = Color(189,190,191,255),
    ["blue75"] = Color(75, 168, 255),
    ["grey53"] = Color(53, 139, 219),
    ["grey165"] = Color(165, 165, 165),
    ["notifycolor"] = Color(54, 140, 220),
    ["white200"] = Color(240,240,240),
    ["bought"] = Color(252, 186, 3),
}

--[[ Actually you can just set € and $ but if you know what you do you can add more currencies]]
AAS.CurrentCurrency = "$"

--[[ You can add more currency here ]]
AAS.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end
}

--[[ This number define the max vector offset modification ( don't touch if you don't know what you do !! )]]
AAS.MaxVectorOffset = 5

--[[ This number define the max angle offset modification ( don't touch if you don't know what you do !! )]]
AAS.MaxAngleOffset = 30

// Reload item language if the language was changed
if SERVER then 
    if isfunction(AAS.ChangeLangage) then
        AAS.ChangeLangage() 
    end
end