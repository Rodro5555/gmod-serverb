ITEM.Name = "Metal Bar"
ITEM.Description = "A Bar of Metal"
ITEM.Model = "models/Zerochain/props_mining/zrms_bar.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

--ITEM.MaxStack = 10
function ITEM:CanMerge(item)
	if (self:GetData("MetalType") == item:GetData("MetalType") and self.MaxStack >= self:GetAmount() + item:GetAmount() and item:GetData("MetalType") == self:GetData("MetalType")) then
		return true
	else
		return false
	end
end

function ITEM:GetName()
	local name = self.Name
	local MetalType = self:GetData("MetalType")
	name = MetalType .. " Bar"

	return self:GetData("Name", name)
end

function ITEM:GetSkin()
	local skin = 0
	local MetalType = self:GetData("MetalType")

	if (MetalType == "Iron") then
		skin = 0
	elseif (MetalType == "Bronze") then
		skin = 1
	elseif (MetalType == "Silver") then
		skin = 2
	elseif (MetalType == "Gold") then
		skin = 3
	end

	return self:GetData("Skin", skin)
end

function ITEM:SaveData(ent)
	local MetalType = ent:GetMetalType()

	if (MetalType == "Iron") then
		skin = 0
	elseif (MetalType == "Bronze") then
		skin = 1
	elseif (MetalType == "Silver") then
		skin = 2
	elseif (MetalType == "Gold") then
		skin = 3
	end

	self:SetData("MetalType", MetalType)

	self:SetSkin(skin)
end

function ITEM:LoadData(ent)
	ent:SetMetalType(self:GetData("MetalType"))
	ent:UpdateVisuals()
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
