zfs = zfs or {}
zfs.util = zfs.util or {}

zfs.dist_interaction = 300

function zfs.Print(msg)
	print("[Zero´s FruitSlicer] " .. msg)
end

function zfs.UseHungermod()
	if DarkRP and DarkRP.disabledDefaults and DarkRP.disabledDefaults["modules"] and DarkRP.disabledDefaults["modules"]["hungermod"] ~= true then
		return true
	else
		return false
	end
end
