local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(10)
ITEM:SetModel("models/zerochain/props_crackermaker/zcm_fireworkpack.mdl")
ITEM:SetDescription("A Pack of Crackers!")
ITEM:AddDrop(function(self, ply, ent, tbl, tr)
end)


function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 35,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, 0, 0),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local name = "FireCracker"

	return name
end



function ITEM:OnPickup(ply, ent)
	if (not IsValid(ent)) then return end
	if ent.Ignited == true then
		return
	end

	local info = {
		ent = self:GetEntityClass(ent),
		dropEnt = self:GetDropEntityClass(ent),
		amount = self:GetEntityAmount(ent),
		data = self:GetData(ent)
	}

	self:Pickup(ply, ent, info)

	return true
end


ITEM:Register("zcm_firecracker")
