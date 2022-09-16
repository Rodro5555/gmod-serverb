ITEM.Name = "Life Alert"
ITEM.Description = "If equipped it will notify paramedics of your location upon death."
ITEM.Model = "models/craphead_scripts/paramedic_essentials/props/alarm.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
	local desc = "If equipped it will notify paramedics of your location upon death."

	return self:GetData("Description", desc)
end

function ITEM:SaveData( ent )
end

function ITEM:LoadData(ent)
end