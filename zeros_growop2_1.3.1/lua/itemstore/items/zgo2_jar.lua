ITEM.Name = "Jar"
ITEM.Description = "A weed jar."
ITEM.Model = "models/zerochain/props_growop2/zgo2_jar.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:SaveData(ent)
	self:SetData("WeedID", zgo2.Plant.GetID(ent:GetWeedID()))
	self:SetData("WeedAmount", math.Round(ent:GetWeedAmount()))
	self:SetData("WeedTHC", math.Round(ent:GetWeedTHC()))
end

function ITEM:LoadData(ent)
	ent:SetWeedID(zgo2.Plant.GetListID(self:GetData("WeedID")))
	ent:SetWeedAmount(self:GetData("WeedAmount"))
	ent:SetWeedTHC(self:GetData("WeedTHC") or 50)
	zgo2.Jar.UpdateBodygroups(ent)
end

function ITEM:CanMerge(item)
	return false
end

function ITEM:Drop(ply, con, slot, ent)
	if not zgo2.Plant.IsValid(self:GetData("WeedID")) then
		zclib.Notify(ply, zgo2.language["InvalidPlantData"], 1)
		SafeRemoveEntity(ent)
		return
	end

	if zgo2.Jar.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language[ "Spawnlimit" ], 1)
		SafeRemoveEntity(ent)
		return
	end
	zclib.Player.SetOwner(ent, ply)
end

function ITEM:GetName()
	local name = zgo2.Plant.GetName(self:GetData("WeedID")) .. " " .. self:GetData("WeedAmount") .. zgo2.config.UoM .. " THC: ".. (self:GetData("WeedTHC") or 50) .. "%"

	return self:GetData("Name", name)
end
