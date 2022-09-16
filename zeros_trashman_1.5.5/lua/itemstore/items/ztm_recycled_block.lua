ITEM.Name = "Recycled Trash"
ITEM.Description = "A block of recycled trash."
ITEM.Model = "models/zerochain/props_trashman/ztm_recycleblock.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetName()
	local name = ztm.config.Recycler.recycle_types[self:GetData("RecycleType")].name

	return self:GetData("Name", name)
end

function ITEM:SaveData(ent)
	self:SetData("RecycleType", ent:GetRecycleType())
end

function ITEM:LoadData(ent)
	ent:SetRecycleType(self:GetData("RecycleType"))
	local _recycle_type = ztm.config.Recycler.recycle_types[ent:GetRecycleType()]

	ent:SetMaterial( _recycle_type.mat, true )
end
