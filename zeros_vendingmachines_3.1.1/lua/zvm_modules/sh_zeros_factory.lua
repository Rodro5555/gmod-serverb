/////////////////////////
//Zeros Factory
//https://www.gmodstore.com/market/view/zero-s-factory-crafting-space

zvm.AllowedItems.Add("zpf_item") // Has CustomData
zvm.AllowedItems.Add("zpf_hive") // Make sure to set the default bot count to 0, so they dont cheat
zvm.AllowedItems.Add("zpf_scafold")
zvm.AllowedItems.Add("zpf_upgradekit") // Has CustomData

zvm.AllowedItems.Add("zpf_beltkit_extrem") // Has CustomData
zvm.AllowedItems.Add("zpf_beltkit_fast") // Has CustomData
zvm.AllowedItems.Add("zpf_beltkit_slow") // Has CustomData

zvm.AllowedItems.Add("zpf_assembler")
zvm.AllowedItems.Add("zpf_cannon")
zvm.AllowedItems.Add("zpf_drill")
zvm.AllowedItems.Add("zpf_lab")
zvm.AllowedItems.Add("zpf_melter")
zvm.AllowedItems.Add("zpf_refiner")
zvm.AllowedItems.Add("zpf_recycler")
zvm.AllowedItems.Add("zpf_silo")
zvm.AllowedItems.Add("zpf_workbench")

zvm.AllowedItems.Add("zpf_chest_storage")
zvm.AllowedItems.Add("zpf_chest_provide")
zvm.AllowedItems.Add("zpf_chest_request")
zvm.AllowedItems.Add("zpf_chest_magneto")

zvm.AllowedItems.Add("zpf_constructor")


zclib.RenderData.Add("zpf_assembler", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_drill", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_hive", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_cannon", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_melter", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_recycler", {ang = Angle(0, 0, 0)})
zclib.RenderData.Add("zpf_refiner", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_silo", {ang = Angle(0, 90, 0)})
zclib.RenderData.Add("zpf_lab", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zpf_workbench", {ang = Angle(0, 180, 0)})


zvm.config.PredefinedNames["zpf_hive"] = "Hive"
zvm.config.PredefinedNames["zpf_scafold"] = "Foundation"
zvm.config.PredefinedNames["zpf_assembler"] = "Assembler"
zvm.config.PredefinedNames["zpf_cannon"] = "Item Cannon"
zvm.config.PredefinedNames["zpf_drill"] = "Drill"
zvm.config.PredefinedNames["zpf_lab"] = "Laboratory"
zvm.config.PredefinedNames["zpf_melter"] = "Melter"
zvm.config.PredefinedNames["zpf_refiner"] = "Refiner"
zvm.config.PredefinedNames["zpf_recycler"] = "Recycler"
zvm.config.PredefinedNames["zpf_silo"] = "Rocket Silo"
zvm.config.PredefinedNames["zpf_workbench"] = "Workbench"

zvm.config.PredefinedNames["zpf_beltkit_extrem"] = "Beltkit - Extrem"
zvm.config.PredefinedNames["zpf_beltkit_fast"] = "Beltkit - Fast"
zvm.config.PredefinedNames["zpf_beltkit_slow"] = "Beltkit - Slow"

local zpf_Ents = {
    ["zpf_hive"] = true,
    ["zpf_scafold"] = true,
    ["zpf_upgradekit"] = true,
    ["zpf_assembler"] = true,
    ["zpf_beltkit_extrem"] = true,
    ["zpf_beltkit_fast"] = true,
    ["zpf_beltkit_slow"] = true,
    ["zpf_cannon"] = true,
    ["zpf_chest_storage"] = true,
    ["zpf_chest_provide"] = true,
    ["zpf_chest_request"] = true,
    ["zpf_chest_magneto"] = true,
    ["zpf_drill"] = true,
    ["zpf_lab"] = true,
    ["zpf_melter"] = true,
    ["zpf_refiner"] = true,
    ["zpf_recycler"] = true,
    ["zpf_silo"] = true,
    ["zpf_workbench"] = true
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosFactory", function(ply, ent, extradata)
    if zpf and zpf_Ents[ent:GetClass()] then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosFactory", function(data, ent, itemclass)
    if zpf then
        if itemclass == "zpf_item" then
            data.ItemID = ent:GetItemID()
            data.ItemAmount = ent:GetItemAmount()
        elseif itemclass == "zpf_upgradekit" then
            data.ItemID = ent:GetItemID()
            data.ItemAmount = ent:GetItemAmount()
        elseif string.sub(itemclass,1,11) == "zpf_beltkit" then
            data.BeltCount = ent:GetBeltCount()
        end
    end
end)

local function SpawnItem(ent,ItemID,ItemAmount)

    local itemData = zpf.config.Items[ItemID]
    ent.Model = itemData.model

    ent:SetModel(ent.Model)
    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetSolid(SOLID_VPHYSICS )
    ent:SetMoveType(MOVETYPE_VPHYSICS)
    ent:SetUseType(SIMPLE_USE)
    ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    local bound_min, bound_max = ent:GetModelBounds()
    local size = bound_max - bound_min
    size = size:Length()
    local scale = 24 / size
    ent:SetModelScale(scale,0)
    ent:Activate()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(true)
        phys:SetMaterial( "default_silent" )
    end

    ent:SetItemID(ItemID)
    ent:SetItemAmount(ItemAmount)

    if itemData.color then
        ent:SetColor(itemData.color)
    end
    if itemData.material then
        ent:SetMaterial(itemData.material)
    end
    if itemData.skin then
        ent:SetSkin(itemData.skin)
    end
end

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosFactory", function(itemclass, ent, extraData)
    if zpf then
        if itemclass == "zpf_item" then
            ent:SetItemID(extraData.ItemID)
            ent:SetItemAmount(extraData.ItemAmount)

            SpawnItem(ent,extraData.ItemID,extraData.ItemAmount)
        elseif itemclass == "zpf_upgradekit" then
            ent:SetItemID(extraData.ItemID)
            ent:SetItemAmount(extraData.ItemAmount)
        elseif string.sub(itemclass,1,11) == "zpf_beltkit" then
            ent:SetBeltCount(extraData.BeltCount)
        elseif itemclass == "zpf_hive" then
            // Resets the inventory so no bots will be there
            zpf.Inventory.Initialize(ent,8)
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosFactory", function(ent, extraData)
    if zpf then
        local itemclass = ent:GetClass()
        if itemclass == "zpf_item" then
            return zpf.config.Items[extraData.ItemID].name .. " x" .. extraData.ItemAmount
        elseif itemclass == "zpf_upgradekit" then
            return zpf.config.Items[extraData.ItemID].name .. " x" .. extraData.ItemAmount
        elseif string.sub(itemclass, 1, 11) == "zpf_beltkit" then
            return zvm.config.PredefinedNames[itemclass] .. " x" .. extraData.BeltCount
        end
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosFactory", function(itemclass,compared_item,extraData)
    if zpf and itemclass == "zpf_item" then
        return true , compared_item.extraData.ItemID == extraData.ItemID and compared_item.extraData.ItemAmount == extraData.ItemAmount
    end
end)


zclib.Snapshoter.SetPath("zpf_item",function(ItemData) return "zpf/item_" .. ItemData.extraData.ItemID end)
zclib.Snapshoter.SetPath("zpf_upgradekit",function(ItemData) return "zpf/upgradekit_" .. ItemData.extraData.ItemID end)
zclib.Snapshoter.SetPath("zpf_chest_storage",function(ItemData) return "zpf/zpf_chest_storage" end)
zclib.Snapshoter.SetPath("zpf_chest_provide",function(ItemData) return "zpf/zpf_chest_provide" end)
zclib.Snapshoter.SetPath("zpf_chest_request",function(ItemData) return "zpf/zpf_chest_request" end)
zclib.Snapshoter.SetPath("zpf_chest_magneto",function(ItemData) return "zpf/zpf_chest_magneto" end)
zclib.Snapshoter.SetPath("zpf_beltkit_slow",function(ItemData) return "zpf/zpf_beltkit_slow" end)
zclib.Snapshoter.SetPath("zpf_beltkit_fast",function(ItemData) return "zpf/zpf_beltkit_fast" end)
zclib.Snapshoter.SetPath("zpf_beltkit_extrem",function(ItemData) return "zpf/zpf_beltkit_extrem" end)
