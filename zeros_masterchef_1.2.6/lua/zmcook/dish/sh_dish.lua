zmc = zmc or {}
zmc.Dish = zmc.Dish or {}

zmc.Dish.Structure = {
    uniqueid = "47247wwhf",
    name = "Cooked Ham",
    mdl = "models/props_borealis/bluebarrel001.mdl",
    items = {
        [1] = {
            uniqueid = "dgsdgs",
            lpos = vector_origin,
            lang = angle_zero
        }
    }
}

zmc.config.Dishs_ListID = zmc.config.Dishs_ListID or {}
file.CreateDir( "zmc" )

// Trys to append the data if it doesent already exist
function zmc.Dish.LoadModule(data)
    table.insert(zmc.Modules.Append.Dishs,data)
end

timer.Simple(0,function()
    zclib.Data.Setup("zmc_dish_config", "[Zero´s MasterCook]", "zmc/dish_config.txt",function()
        return zmc.config.Dishs
    end, function(data)
        // OnLoaded
        zmc.config.Dishs = table.Copy(data)
    end, function()
        // OnSend
    end, function(data)
        // OnReceived
        zmc.config.Dishs = table.Copy(data)
    end, function(list)
        //OnIDListRebuild
        zmc.config.Dishs_ListID = table.Copy(list)
    end)
end)

function zmc.Dish.GetUniqueID(id)
    local dat = zmc.Dish.GetData(id)
    if dat == nil then return false end
    return tostring(dat.uniqueid)
end


function zmc.Dish.GetListID(UniqueID)
    return zmc.config.Dishs_ListID[UniqueID]
end

function zmc.Dish.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if isnumber(UniqueID) and zmc.config.Dishs[UniqueID] then
        return zmc.config.Dishs[UniqueID]
    end

    // If its a uniqueid then lets get its list id and return the data
    local id = zmc.Dish.GetListID(tostring(UniqueID))
    if id and zmc.config.Dishs[id] then
        return zmc.config.Dishs[id]
    end
end

// Returns how much health the player would get from eating this Dish
function zmc.Dish.GetHealth(Dish)
    local Health, Health_Cap
    local Cap_Count = 0
    local DishData = zmc.Dish.GetData(Dish:GetDishID())
    if DishData == nil then return end

    for k, v in pairs(DishData.items) do
        if v and v.uniqueid then
            local itemData = zmc.Item.GetData(v.uniqueid)

            if itemData and itemData.edible and itemData.edible.health then
                Health = (Health or 0) + itemData.edible.health
                Health_Cap = (Health_Cap or 0) + itemData.edible.health_cap
                Cap_Count = (Cap_Count or 0) + 1
            end
        end
    end

    if Health_Cap and Cap_Count then
        Health_Cap = Health_Cap / Cap_Count
    end

    return Health, Health_Cap
end

// Returns the money value of this Dish, depending on a the used items with the Sell Components
function zmc.Dish.GetPrice(DishID)
    local Money = 0
    local DishData = zmc.Dish.GetData(DishID)
    if DishData == nil then return end

    // If a custom price is defined then use it instead
    if DishData.price and DishData.price > 0 then return DishData.price end

    for k, v in pairs(DishData.items) do
        if v and v.uniqueid then
            local itemData = zmc.Item.GetData(v.uniqueid)

            if itemData and itemData.sell and itemData.sell.price then
                Money = Money + itemData.sell.price
            end
        end
    end

    // Multiply with the profit multiplier
    Money = Money * zmc.config.Profit_Multiplier

    return Money
end

// Returns how long it takes to make this Dish
function zmc.Dish.GetOrderTime(DishID)
    local Time = 60
    local DishData = zmc.Dish.GetData(DishID)

    if DishData and DishData.time then
        Time = DishData.time
    end

    return Time
end

function zmc.Dish.GetName(DishID)
    local DishData = zmc.Dish.GetData(DishID)
    if DishData and DishData.name then

		// If we got a translation then use it insteada
		if zmc.language[ DishData.name ] then return zmc.language[ DishData.name ] end

        return DishData.name
    else
        return "Unkown"
    end
end
