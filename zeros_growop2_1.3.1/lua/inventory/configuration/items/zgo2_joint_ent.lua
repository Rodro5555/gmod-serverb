local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_growop2/zgo2_joint.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	if not zgo2.Plant.IsValid(data.WeedID) then
		zclib.Notify(ply, zgo2.language["InvalidPlantData"], 1)
		SafeRemoveEntity(ent)
		return
	end

	ent:SetWeedID(zgo2.Plant.GetListID(data.WeedID))
	ent:SetWeedAmount(data.WeedAmount)
	ent:SetWeedTHC(data.WeedTHC or 50)

	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		WeedID = zgo2.Plant.GetID(ent:GetWeedID()),
		WeedAmount = math.Round(ent:GetWeedAmount()),
		WeedTHC = math.Round(ent:GetWeedTHC())
	}
end

function ITEM:GetVisualAmount(item)
	return item.data.WeedAmount
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local WeedID = ent and item:GetWeedID() or item.data.WeedID
	local WeedTHC = ent and item:GetWeedTHC() or ( item.data.WeedTHC or 50 )

	local WeedData = zgo2.Plant.GetData(WeedID)
	if not WeedData then return "Joint" end

	return zgo2.Plant.GetName(WeedID) .. " THC: " .. WeedTHC .. "%"
end

function ITEM:GetDisplayName(item)
    return self:GetName(item)
end

local ang = Angle(0, 45, 0)
function ITEM:GetCameraModifiers(tbl)
    return {
        FOV = 30,
        X = 0,
        Y = 0,
        Z = 50,
        Angles = ang,
        Pos = vector_origin
    }
end

ITEM:Register("zgo2_joint_ent")
