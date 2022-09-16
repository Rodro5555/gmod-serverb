local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(5)
ITEM:SetModel("models/craphead_scripts/bitminers/utility/miner_solo.mdl")
ITEM:SetDescription("A single bitminer")

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
	return "Miner Upgrade"
end

ITEM:Register("ch_bitminer_upgrade_miner")
