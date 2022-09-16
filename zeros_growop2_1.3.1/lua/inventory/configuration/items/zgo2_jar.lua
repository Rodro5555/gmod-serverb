local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_growop2/zgo2_jar.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	if not zgo2.Plant.IsValid(data.WeedID) then
		zclib.Notify(ply, zgo2.language["InvalidPlantData"], 1)
		SafeRemoveEntity(ent)
		return
	end

	if zgo2.Jar.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language[ "Spawnlimit" ], 1)
		SafeRemoveEntity(ent)
		return
	end

	ent:SetWeedID(zgo2.Plant.GetListID(data.WeedID))
	ent:SetWeedAmount(data.WeedAmount)
	ent:SetWeedTHC(data.WeedTHC or 50)

	zclib.Player.SetOwner(ent, ply)

	zgo2.Jar.UpdateBodygroups(ent)
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
	if not WeedData then return "Jar" end

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

function ITEM:GetClientsideModel(tbl, mdlPanel)
	local WeedData = zgo2.Plant.GetData(tbl.data.WeedID)
	if not WeedData then return end

	local weed_amount = tbl.data.WeedAmount
	local Jar = mdlPanel.Entity
	Jar:SetBodygroup(0, 0)
	Jar:SetBodygroup(1, 0)
	Jar:SetBodygroup(2, 0)
	Jar:SetBodygroup(3, 0)
	Jar:SetBodygroup(4, 0)

	if weed_amount > 0 then
		local bg = math.Clamp(math.Round((5 / zgo2.config.Jar.Capacity) * weed_amount), 1, 5)

		for i = 0, bg - 1 do
			Jar:SetBodygroup(i, 1)
		end
	end

	zgo2.Plant.UpdateMaterial(Jar, WeedData)
end

ITEM:Register("zgo2_jar")
