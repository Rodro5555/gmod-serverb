local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(3)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/pot.mdl")
ITEM:SetDescription("Pot used to mix baking soda and water to cook cocaine")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
	ent:CPPISetOwner( ply )
end)

function ITEM:GetData(ent)
    return {
        GetOwner = ent:Getowning_ent(),
    }
end

function ITEM:GetName(item)
	return "Cooking Pot"
end

ITEM:Register("cocaine_cooking_pot")
