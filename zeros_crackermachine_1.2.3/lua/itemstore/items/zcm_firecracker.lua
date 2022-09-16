ITEM.Name = "FireCracker"
ITEM.Description = "A Pack of Crackers!"
ITEM.Model = "models/zerochain/props_crackermaker/zcm_fireworkpack.mdl"
ITEM.Base = "base_darkrp"

function ITEM:CanPickup(pl, ent)
	if ent.Ignited == false then return true end

	return false
end
