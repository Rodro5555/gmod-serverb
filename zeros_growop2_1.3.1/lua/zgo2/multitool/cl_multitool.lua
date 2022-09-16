zgo2 = zgo2 or {}
zgo2.Multitool = zgo2.Multitool or {}

function zgo2.Multitool.SecondaryAttack(Multitool)
	if LocalPlayer().zgo2_LockSwep and LocalPlayer().zgo2_LockSwep > CurTime() then return end

	zgo2.Multitool.OpenMenu(nil, zgo2.Shop.List)
end

function zgo2.Multitool.Holster(Multitool)
	// BUG Does this cause the tablet to randomly close itself???
	// zclib.PointerSystem.Stop()
end
