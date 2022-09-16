local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(4)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/cocaine_pack.mdl")
ITEM:SetDescription("A pack of finished cocaine ready to be packed in the box")

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
	return "Cocaine Pack"
end

ITEM:Register("cocaine_pack")
