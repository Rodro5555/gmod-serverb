zmc = zmc or {}
zmc.Item = zmc.Item or {}

zmc.Item.Components = {
    -- This means it can be bought in the fridge
    fridge = {
        name = zmc.language["comp_title_fridge"],
        desc = zmc.language["comp_desc_fridge"],

        price = 10, -- What does it cost
        ranks = {} -- Who can buy it
    },

    -- This means it can be cut
    cut = {
        icon = Material("materials/zerochain/zmc/cut.png", "smooth noclamp"),
        name = zmc.language["comp_title_cut"],
        desc = zmc.language["comp_desc_cut"],

        cycle = 3, -- How many cutting mini games need to be completted
        items = {}, -- What item will it be after it got cut
    },

    -- This means it can be knead
    knead  = {
        icon = Material("materials/zerochain/zmc/knead.png", "smooth noclamp"),
        name = zmc.language["comp_title_knead"],
        desc = zmc.language["comp_desc_knead"],

        cycle = 3, -- How many kneading mini games need to be completted
        amount = 1, -- How many items do we get
        item = "75a75dga3", -- What item will it be after it got knead
    },

    -- This means the item can be baked
    bake = {
        name = zmc.language["comp_title_bake"],
        desc = zmc.language["comp_desc_bake"],

        time = 50, -- How long does it need to bake

        -- Controlls at which Temperatur the item starts cooking
        temp = {
            start = 50, -- The Temperatur at which this item will start baking
            range = 25, -- The Range in which it will bake
        },
        item = "75a75dga3" -- What item will it be after it got baked
    },

    -- This means the item is the end product of the mixer
    mix = {
        name = zmc.language["comp_title_mix"],
        desc = zmc.language["comp_desc_mix"],

        time = 50, -- How long does it need to bake

        speed = 1, -- Which mix speed is needed for the dough to progress

        -- What items are needed to make this item
        items = {}
    },

    -- This means the item can be sold
    sell = {
        name = zmc.language["comp_title_sell"],
        desc = zmc.language["comp_desc_sell"],

        price = 50, -- How much is this food worth
    },

    -- This means the item can be eaten
    edible = {
        name = zmc.language["comp_title_edible"],
        desc = zmc.language["comp_desc_edible"],

        health = 5,
        health_cap = 100,
    },

    -- This means the item can be grilled
    grill = {
        name = zmc.language["comp_title_grill"],
        desc = zmc.language["comp_desc_grill"],

        time = 50, -- How long does it need to grill
        item = "75a75dga3" -- What item will it be after it got grilled
    },

    -- This means it can be wok
    wok  = {
        name = zmc.language["comp_title_wok"],
        desc = zmc.language["comp_desc_wok"],

        -- How the wok looks inside the pot
        appearance = {
            mdl = "models/props_debris/concrete_debris128pile001a.mdl",
            scale = 1,
            skin = 0,
            color = Color(255,255,255),
            material = "models/debug/debugwhite",
            lpos = Vector(-0.5, 0.5,0),
        },

        cycle = 3, -- How often do we need to flip the pan
        range = 0.25, -- How big is the goal range, the smaller it is the hard the game is
        amount = 3, -- How many items do we get
        items = {}, -- Whats will be needed to make this
    },

    -- This means it can be wok
    soup  = {
        name = zmc.language["comp_title_soup"],
        desc = zmc.language["comp_desc_soup"],

        -- How the soup looks inside the pot
        appearance = {
            mdl = "models/zerochain/props_kitchen/zmc_liquid.mdl",
            scale = 1,
            skin = 0,
            color = Color(255,255,255),
            material = "zerochain/props_kitchen/liquid/zmc_soup",
            lpos = Vector(-0.5, 0.5,0),
        },

        time = 15, -- How long does it take to cook the soup
        amount = 3, -- How many items do we get
        items = {}, -- Whats will be needed to make this
    },

    -- This means the item can be baked
    boil = {
        name = zmc.language["comp_title_boil"],
        desc = zmc.language["comp_desc_boil"],

        time = 50, -- How long does it need to boil

        -- Controlls at which Temperatur the item starts cooking
        temp = {
            start = 50, -- The Temperatur at which this item will start baking
            range = 25, -- The Range in which it will bake
        },
        item = "75a75dga3" -- What item will it be after it got boiled
    },

    -- This means the item can be crafted on the worktable
    craft = {
        name = zmc.language["comp_title_craft"],
        desc = zmc.language["comp_desc_craft"],
        -- What items are needed to make this item
        items = {},
        amount = 3, -- How many items do we get
    },
}

function zmc.Item.Validate(data)
    if data == nil then return false end
    if data.mdl == nil then return false end
    if data.name == nil then return false end
    return true
end


function zmc.Item.GetListID(UniqueID)
    return zmc.config.Items_ListID[UniqueID]
end

function zmc.Item.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if isnumber(UniqueID) and zmc.config.Items[UniqueID] then
        return zmc.config.Items[UniqueID]
    end

    // If its a uniqueid then lets get its list id and return the data
    local id = zmc.Item.GetListID(tostring(UniqueID))

    if UniqueID and id and zmc.config.Items[id] then
        return zmc.config.Items[id]
    end
end

function zmc.Item.GetName(UniqueID)
    local data = zmc.Item.GetData(UniqueID)
    if data and data.name then

		// If we got a translation then use it insteada
		if zmc.language[ data.name ] then return zmc.language[ data.name ] end

        return data.name
    else
        return "Unkown"
    end
end

function zmc.Item.UpdateVisual(ent,ItemData,update_scale)
    if ItemData == nil then return end

    ent:SetModel(ItemData.mdl)

    if ItemData.skin then ent:SetSkin(ItemData.skin) end
    if ItemData.color then ent:SetColor(ItemData.color) end
    if update_scale == true and ItemData.scale then ent:SetModelScale(ItemData.scale) end
    if ItemData.material then ent:SetMaterial(ItemData.material) end

    if ItemData.bgs then
        for id, val in pairs(ItemData.bgs) do
            ent:SetBodygroup(id, val)
        end
    end

    if SERVER then
        ent:Activate()

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(15)
            phys:EnableDrag(true)
            phys:SetDragCoefficient(500)
            phys:SetAngleDragCoefficient(50000)
            phys:SetDamping(5,5)
            phys:SetMaterial( "default_silent" )
        end
    end

    return ent
end

if SERVER then
    util.AddNetworkString("zmc_config_open")

    concommand.Add("zmc_config_open", function(ply, cmd, args)
        if zclib.Player.IsAdmin(ply) then
            net.Start("zmc_config_open")
            net.Send(ply)
        end
    end)
end

zmc.config.Items_ListID = zmc.config.Items_ListID or {}
file.CreateDir( "zmc" )

// Trys to append the data if it doesent already exist
function zmc.Item.LoadModule(data)
    table.insert(zmc.Modules.Append.Items,data)
end


timer.Simple(0,function()
    zclib.Data.Setup("zmc_item_config", "[Zero´s MasterCook]", "zmc/item_config.txt",function()
        return zmc.config.Items
    end, function(data)
        -- OnLoaded
        zmc.config.Items = table.Copy(data)
    end, function()
        -- OnSend
    end, function(data)
        -- OnReceived
        zmc.config.Items = table.Copy(data)
    end, function(list)
        --OnIDListRebuild
        zmc.config.Items_ListID = table.Copy(list)
    end)
end)


function zmc.Item.LimitCheck(ply)
    local class = "zmc_item"
    local limit = hook.Run("zmc_GetItemLimit",ply) or zmc.config.Item.Limit

    local count = 0
    for k, v in pairs(zclib.EntityTracker.GetList()) do
        if IsValid(v) and v:GetClass() == class and zclib.Player.IsOwner(ply, v) then
            count = count + 1
        end
    end

    if count >= limit then
        return false
    else
        return true
    end
end
