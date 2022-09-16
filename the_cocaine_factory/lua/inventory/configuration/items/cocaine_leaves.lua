local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/leaves.mdl")
ITEM:SetDescription("Cocaine leaves mixes in the cocaine extractor")

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
	return "Leaf Pack"
end

ITEM:Register("cocaine_leaves")
