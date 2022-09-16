local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Realistic Car Dealer"
MODULE.Name = "Dealer"
MODULE.Colour = Color(54, 140, 220)

MODULE:Hook("RCD:SellVehicle", "RCD:SellVehicle:Log", function(ply, tbl, vehicleId)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " sold the vehicle "..tbl["name"].." ( "..vehicleId.." )")
end)

MODULE:Hook("RCD:BuyVehicle", "RCD:BuyVehicle:Log", function(ply, tbl, vehicleId)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " bought the vehicle "..tbl["name"].." ( "..vehicleId.." )")
end)

MODULE:Hook("RCD:CustomizeVehicle", "RCD:CustomizeVehicle:Log", function(ply, vehicleTable, vehicleId, customization, price)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " bought customizations for "..price)
end)

GAS.Logging:AddModule(MODULE)
