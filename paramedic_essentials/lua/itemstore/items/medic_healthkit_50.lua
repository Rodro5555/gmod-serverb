ITEM.Name = "Health Kit +50"
ITEM.Description = "Gives 50% health when consumed."
ITEM.Model = "models/craphead_scripts/paramedic_essentials/weapons/w_medpack.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
	local desc = "Gives 50% health when consumed."

	return self:GetData("Description", desc)
end

function ITEM:SaveData( ent )
end

function ITEM:LoadData(ent)
end