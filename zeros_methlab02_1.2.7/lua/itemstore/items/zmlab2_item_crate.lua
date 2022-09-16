ITEM.Name = "Crate"
ITEM.Description = "Some meth info."
ITEM.Model = "models/zerochain/props_methlab/zmlab2_crate.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetName()
	local name = "Unkown"

	local m_type = self:GetData("MethType")
	local m_qual = self:GetData("MethQuality")
	local m_amount = self:GetData("MethAmount")

	local MethData = zmlab2.config.MethTypes[m_type]
	if MethData then
		name = MethData.name .. " " .. (m_amount or 0) .. zmlab2.config.UoM .. " " .. (m_qual or 0) .. "%"
	end
	return self:GetData("Name", name)
end

function ITEM:GetDescription()

	local desc = "Unkown"
	local MethType = self:GetData("MethType")
	if zmlab2.config.MethTypes[MethType] then desc = zmlab2.config.MethTypes[MethType].desc end
	return self:GetData("Description", desc)
end

function ITEM:GetColor()

	local col = Color(255,255,255,255)
	local MethType = self:GetData("MethType")
	local MethData = zmlab2.config.MethTypes[MethType]
	if MethData then

		local m_qual = self:GetData("MethQuality")
		local qual_fract = (1 / 100) * m_qual

		col = MethData.color

		local h,s,v = ColorToHSV(col)
		s = s * qual_fract

		col = HSVToColor(h,s,v)
	end
	return self:GetData("Color", col)
end


// We save the uniqueid to be save should the ingredients config order or item count change
function ITEM:SaveData(ent)
	self:SetData("MethType", ent:GetMethType())
	self:SetData("MethQuality", ent:GetMethQuality())
	self:SetData("MethAmount", ent:GetMethAmount())
end

// Get the list id using the uniqueid and set it in the entity
function ITEM:LoadData(ent)
	local m_type = self:GetData("MethType")
	local m_qual = self:GetData("MethQuality")
	local m_amount = self:GetData("MethAmount")
	if m_type and m_qual and m_amount then
		ent:SetMethType(m_type)
		ent:SetMethQuality(m_qual)
		ent:SetMethAmount(m_amount)
	else
		SafeRemoveEntity(ent)
	end
end

function ITEM:Drop(ply,con,slot,ent)
	zclib.Player.SetOwner(ent, ply)
end
