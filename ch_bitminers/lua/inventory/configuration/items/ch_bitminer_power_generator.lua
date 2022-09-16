local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/craphead_scripts/bitminers/power/generator.mdl")
ITEM:SetDescription("A fuel powered generator")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
	ent:CPPISetOwner( ply )
	
	ent:SetFuel( data.GetFuel )
end)

function ITEM:GetData(ent)
    return {
        GetOwner = ent:Getowning_ent(),
		GetFuel = ent:GetFuel(),
    }
end

function ITEM:GetName(item)
	local name = "Generator"
	
	local ent = isentity(item)
    local FuelAmt = ent and item:GetFuel() or item.data.GetFuel
	
	name = name .." [" ..FuelAmt .."%]"
	return name
end

ITEM:Register("ch_bitminer_power_generator")
