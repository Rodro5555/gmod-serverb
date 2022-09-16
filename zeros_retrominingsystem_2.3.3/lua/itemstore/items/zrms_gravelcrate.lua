ITEM.Name = "GravelCrate"
ITEM.Description = "Contains ores."
ITEM.Model = "models/Zerochain/props_mining/zrms_gravelcrate.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
    local desc = self.Description
    local iron = self:GetData("cIron")
    local bronze = self:GetData("cBronze")
    local silver = self:GetData("cSilver")
    local gold = self:GetData("cGold")
    local coal = self:GetData("cCoal")
    desc = "Iron: " .. tostring(iron) .. " | Bronze: " .. tostring(bronze) .. " | Silver: " .. tostring(silver) .. " | Gold: " .. tostring(gold) .. " | Coal: " .. tostring(coal)

    return self:GetData("Description", desc)
end

function ITEM:SaveData(ent)
    self:SetData("cIron", math.Round(ent:GetIron(), 1))
    self:SetData("cBronze", math.Round(ent:GetBronze(), 1))
    self:SetData("cSilver", math.Round(ent:GetSilver(), 1))
    self:SetData("cGold", math.Round(ent:GetGold(), 1))
    self:SetData("cCoal", math.Round(ent:GetCoal(), 1))
end

function ITEM:LoadData(ent)
    ent:SetIron(math.Round(self:GetData("cIron"), 1))
    ent:SetBronze(math.Round(self:GetData("cBronze"), 1))
    ent:SetSilver(math.Round(self:GetData("cSilver"), 1))
    ent:SetGold(math.Round(self:GetData("cGold"), 1))
    ent:SetCoal(math.Round(self:GetData("cCoal"), 1))
end

function ITEM:Drop(ply, con, slot, ent)
    zrmine.f.SetOwner(ent, ply)
end

function ITEM:CanPickup(pl, ent)
	if zrmine.f.IsOwner(pl, ent) then
		return true
	else
		return false
	end
end
