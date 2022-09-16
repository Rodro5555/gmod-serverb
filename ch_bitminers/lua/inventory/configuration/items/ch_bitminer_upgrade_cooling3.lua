local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/craphead_scripts/bitminers/utility/cooling_upgrade_3.mdl")
ITEM:SetDescription("Highest level of cooling upgrade for mining shelf")

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
	return "Cooling Upgrade #3"
end

ITEM:Register("ch_bitminer_upgrade_cooling3")
