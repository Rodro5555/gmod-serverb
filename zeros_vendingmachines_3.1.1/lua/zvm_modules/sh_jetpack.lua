/////////////////////////
// Jetpack script
//https://steamcommunity.com/sharedfiles/filedetails/?id=931376012&searchtext=jetpack

zvm.AllowedItems.Add("sent_jetpack") // Has CustomData

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_sent_jetpack", function(data, ent, itemclass)
    if itemclass == "sent_jetpack" then

		data.color = ent:GetColor()

        data.GoneApeshit = ent:GetGoneApeshit()
        data.InfiniteFuel = ent:GetInfiniteFuel()
        data.Fuel = ent:GetFuel()
        data.MaxFuel = ent:GetMaxFuel()
        data.FuelDrain = ent:GetFuelDrain()
        data.FuelRecharge = ent:GetFuelRecharge()
        data.AirResistance = ent:GetAirResistance()
        data.JetpackSpeed = ent:GetJetpackSpeed()
        data.JetpackStrafeSpeed = ent:GetJetpackStrafeSpeed()
        data.JetpackVelocity = ent:GetJetpackVelocity()
        data.JetpackStrafeVelocity = ent:GetJetpackStrafeVelocity()
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_sent_jetpack", function(itemclass, ent, extraData)
    if itemclass == "sent_jetpack" then

		if extraData.color then ent:SetColor(extraData.color) end

        ent:SetGoneApeshit(extraData.GoneApeshit)
        ent:SetInfiniteFuel(extraData.InfiniteFuel)
        ent:SetFuel(extraData.Fuel)
        ent:SetMaxFuel(extraData.MaxFuel)
        ent:SetFuelDrain(extraData.FuelDrain)
        ent:SetFuelRecharge(extraData.FuelRecharge)
        ent:SetAirResistance(extraData.AirResistance)
        ent:SetJetpackSpeed(extraData.JetpackSpeed)
        ent:SetJetpackStrafeSpeed(extraData.JetpackStrafeSpeed)
        ent:SetJetpackVelocity(extraData.JetpackVelocity)
        ent:SetJetpackStrafeVelocity(extraData.JetpackStrafeVelocity)
    end
end)

hook.Add("zvm_OnItemDataApplyPreSpawn", "zvm_OnItemDataApplyPreSpawn_sent_jetpack", function(itemclass, ent, extraData)
    if itemclass == "sent_jetpack" then
		ent:SetSlotName(itemclass)
    end
end)



hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_sent_jetpack", function(ent)
    local itemclass = ent:GetClass()
    if itemclass == "sent_jetpack" and ent:GetActive() then
        return true
    end
end)

zclib.Snapshoter.SetPath("sent_jetpack",function(ItemData)
    if ItemData.model_color then
        return "jetpack/" .. ItemData.class .. "_" .. ItemData.model_color.r .. "_" .. ItemData.model_color.g .. "_" .. ItemData.model_color.b
    end
end)
