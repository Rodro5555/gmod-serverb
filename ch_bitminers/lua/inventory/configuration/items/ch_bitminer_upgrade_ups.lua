local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(5)
ITEM:SetModel("models/craphead_scripts/bitminers/utility/ups_solo.mdl")
ITEM:SetDescription("Power supply for mining shelf")

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
	return "UPS Upgrade"
end

ITEM:Register("ch_bitminer_upgrade_ups")
