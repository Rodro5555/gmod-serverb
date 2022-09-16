local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(2)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/bucket.mdl")
ITEM:SetDescription("Install buckets on the cocaine extractor")

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
	return "Bucket"
end

ITEM:Register("cocaine_bucket")
