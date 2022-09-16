ITEM.Name = "Machinecrate"
ITEM.Description = "Holds machines for Oil drilling."
ITEM.Model = "models/zerochain/props_oilrush/zor_machinecrate.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:SaveData(ent)
	self:SetData("MachineID", ent:GetMachineID())
	self:SetData("Content", ent.InstalledModules)
end

function ITEM:LoadData(ent)
	ent:SetMachineID(self:GetData("MachineID"))

	if SERVER then
		local tbl = self:GetData("Content")
		zrush.Machinecrate.AddModules(ent,tbl)
	end
end

function ITEM:Drop(ply,con,slot,ent)
	if SERVER then
		zclib.Player.SetOwner(ent, ply)
	end
end

function ITEM:CanPickup(pl, ent)
	return zclib.Player.IsOwner(pl, ent)
end
