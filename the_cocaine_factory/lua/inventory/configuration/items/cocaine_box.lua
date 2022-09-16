local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl")
ITEM:SetDescription( function( self, item, ent )
	local tbl = {}
	
	local health = item.data.Health
	local isclosed = item.data.IsClosed
	local cocaine_amount = item.data.CocaineAmount
	
	tbl[#tbl + 1] = "Box of cocaine packs"
	
	if health then
		tbl[#tbl + 1] = "Health: ".. health .."%"
	end
	
	if isclosed then
		tbl[#tbl + 1] = "Box Closed: Yes"
	else
		tbl[#tbl + 1] = "Box Closed: No"
	end
	
	if cocaine_amount then
		tbl[#tbl + 1] = "Cocaine Packs: ".. cocaine_amount
	end
	
	return tbl
end )
	

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
	ent:CPPISetOwner( ply )
	--ent.BoxOwner = ply
	
	-- Set default values
	ent:SetHP( data.Health )
	ent.IsClosed = data.IsClosed
	ent.BoxCocaineAmount = data.CocaineAmount
	
	-- Initialize bodygroups and skin
	if data.IsClosed then
		ent:SetBodygroup( 1, 1 )
	else
		ent:SetBodygroup( 1, 0 )
	end
	
	ent:SetBodygroup( 2, data.CocaineAmount )
end)

function ITEM:GetData(ent)
    return {
		Health = ent:GetHP(),
		IsClosed = ent.IsClosed,
		CocaineAmount = ent.BoxCocaineAmount,
    }
end

function ITEM:GetName(item)
	return "Cocaine Box"
end

ITEM:Register("cocaine_box")
