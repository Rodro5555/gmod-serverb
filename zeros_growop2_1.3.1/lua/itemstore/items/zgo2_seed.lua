ITEM.Name = "Weed Seeds"
ITEM.Description = "Seeds of weed."
ITEM.Model = "models/zerochain/props_growop2/zgo2_weedseeds.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:SaveData(ent)
	self:SetData("WeedID", zgo2.Plant.GetID(ent:GetPlantID()))
	self:SetData("Count", math.Round(ent:GetCount()))
end

function ITEM:LoadData(ent)
	ent:SetPlantID(zgo2.Plant.GetListID(self:GetData("WeedID")))
	ent:SetCount(self:GetData("Count"))
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
	zclib.Player.SetOwner(ent, ply)
end

function ITEM:GetName()
	local name = zgo2.Plant.GetName(self:GetData("WeedID")) .. " " .. (self:GetData("Count") or 1) .. "x"
	return self:GetData("Name", name)
end
