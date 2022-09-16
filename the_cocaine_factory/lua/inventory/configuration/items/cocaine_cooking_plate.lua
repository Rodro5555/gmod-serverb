local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(4)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/stove_upgrade.mdl")
ITEM:SetDescription("An extra cooking plate for the cocaine stove")

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
	return "Cooking Plate"
end

ITEM:Register("cocaine_cooking_plate")
