ITEM.Name = "Armor Kit +50"
ITEM.Description = "Gives 50% armor when consumed."
ITEM.Model = "models/Items/battery.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
	local desc = "Gives 50% armor when consumed."

	return self:GetData("Description", desc)
end

function ITEM:SaveData( ent )
end

function ITEM:LoadData(ent)
end