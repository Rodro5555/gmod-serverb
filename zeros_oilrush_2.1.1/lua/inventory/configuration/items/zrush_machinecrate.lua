local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_oilrush/zor_machinecrate.mdl")
ITEM:SetDescription("Holds machines for Oil drilling.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetMachineID(data.MachineID)
	zrush.Machinecrate.AddModules(ent,data.Content)
	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		MachineID = ent:GetMachineID(),
		Content = ent.InstalledModules
	}
end

ITEM:Register("zrush_machinecrate")
