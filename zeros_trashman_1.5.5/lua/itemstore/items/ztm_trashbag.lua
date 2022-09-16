ITEM.Name = "Trashbag"
ITEM.Description = "A bag of trash."
ITEM.Model = "models/zerochain/props_trashman/ztm_trashbag.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetName()
	local name = "Trashbag " .. "[ " .. self:GetData("Trash") .. ztm.config.UoW .. " ]"

	return self:GetData("Name", name)
end

function ITEM:SaveData(ent)
	self:SetData("Trash", ent:GetTrash())
end

function ITEM:LoadData(ent)
	ent:SetTrash(self:GetData("Trash"))
end

function ITEM:Drop(ply, container,slot,ent)
	if ztm.Trashbag.GetCountByPlayer(ply) >= ztm.config.Trashbags.limit then
		ply:PickupItem( ent )
		zclib.Notify(ply, ztm.language.General["TrashbagLimit"], 1)
	else
		zclib.Player.SetOwner(ent, ply)
		ent:SetPos(ent:GetPos() + Vector(0,0,20))
	end
end
