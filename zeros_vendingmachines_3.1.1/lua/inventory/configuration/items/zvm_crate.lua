local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_vendingmachine/zvm_package.mdl")
//ITEM:SetDescription("Holds Items from a Vendingmachine.")

ITEM:SetDescription(function(self, tbl)
	local data = tbl.data
	local _content = data.Content
	local desc = ""
	for k, v in pairs(_content) do
		desc = desc .. v.name .. ", "
	end


	return  desc
end)

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	zvm.Player.AddPackage(ply,ent)

	ent.Content = {}
	table.CopyFromTo(data.Content, ent.Content)
	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		Content = ent.Content,
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	return "Vendingmachine Package"
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, -190, 0),
		Pos = Vector(0, 0, -1)
	}
end

ITEM:Register("zvm_crate")
