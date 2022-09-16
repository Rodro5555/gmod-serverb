ITEM.Name = "StorageCrate"
ITEM.Description = "A Bar of Metal"
ITEM.Model = "models/Zerochain/props_mining/zrms_storagecrate_closed.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

--ITEM.MaxStack = 10
function ITEM:GetDescription()
	local desc = self.Description
	local iron = self:GetData("bIron")
	local bronze = self:GetData("bBronze")
	local silver = self:GetData("bSilver")
	local gold = self:GetData("bGold")
	desc = "Iron: " .. tostring(iron) .. " | Bronze: " .. tostring(bronze) .. " | Silver: " .. tostring(silver) .. " | Gold: " .. tostring(gold)

	return self:GetData("Description", desc)
end

function ITEM:SaveData(ent)
	self:SetData("bIron", ent:GetbIron())
	self:SetData("bBronze", ent:GetbBronze())
	self:SetData("bSilver", ent:GetbSilver())
	self:SetData("bGold", ent:GetbGold())

end


function ITEM:CanPickup(pl, ent)
	if ent:GetBarCount() > 0 and zrmine.f.IsOwner(pl, ent) then
		return true
	else
		return false
	end
end

function ITEM:LoadData(ent)
	ent:SetbIron(self:GetData("bIron"))
	ent:SetbBronze(self:GetData("bBronze"))
	ent:SetbSilver(self:GetData("bSilver"))
	ent:SetbGold(self:GetData("bGold"))

	ent:SpawnFromInventory()
end

function ITEM:Drop(ply, con, slot, ent)
	zrmine.f.SetOwner(ent, ply)
end
