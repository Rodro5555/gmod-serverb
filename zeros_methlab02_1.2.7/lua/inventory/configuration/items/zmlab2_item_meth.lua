local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_methlab/zmlab2_bag.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	ent:SetMethType(data.MethType)
	ent:SetMethAmount(data.MethAmount)
	ent:SetMethQuality(data.MethQuality)

	zclib.Player.SetOwner(ent, ply)
end)

ITEM:SetDescription(function(self, tbl)

	local MethType = tbl.data.MethType
	local desc = ""
	if zmlab2.config.MethTypes[MethType] and zmlab2.config.MethTypes[MethType].desc then
		desc = zmlab2.config.MethTypes[MethType].desc
	end

	return {
		"Quality: " .. tbl.data.MethQuality .. "%",
		"Info: " .. desc,
	}
end)

function ITEM:GetData(ent)
	return {
		MethType = ent:GetMethType(),
		MethAmount = ent:GetMethAmount(),
		MethQuality = ent:GetMethQuality(),
	}
end

function ITEM:GetVisualAmount(item)
	return item.data.MethAmount
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local name = "Unkown"

	local ent = isentity(item)
	local MethType = ent and item:GetMethType() or item.data.MethType

	if zmlab2.config.MethTypes[MethType] and zmlab2.config.MethTypes[MethType].name then
		name = zmlab2.config.MethTypes[MethType].name //.. " " .. (MethQuality or 0) .. "%"
	end

	return name
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, 0, -90),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	if tbl.data.MethAmount and tbl.data.MethAmount > 0 then
		local MethMat = zmlab2.Meth.GetMaterial(tbl.data.MethType,tbl.data.MethQuality)
		if MethMat then
			mdlPanel.Entity:SetSubMaterial(0, "!" .. MethMat)
		end
	end
end

ITEM:Register("zmlab2_item_meth")
