local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(5)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/water.mdl")
ITEM:SetDescription("Water used in the cocaine mixture")

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
	return "Water"
end

ITEM:Register("cocaine_water")
