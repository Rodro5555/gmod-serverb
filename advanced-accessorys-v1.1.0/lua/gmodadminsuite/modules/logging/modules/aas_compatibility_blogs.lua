local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Advanced Accessory System"
MODULE.Name = "Bought / Sold Item"
MODULE.Colour = Color(54, 140, 220)

MODULE:Hook("AAS:SoldItem", "AAS:SoldItem", function(ply, tbl)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " sold the item with the uniqueId "..tbl["uniqueId"].." for "..tbl["price"])
end)

MODULE:Hook("AAS:BoughtItem", "AAS:BoughtItem", function(ply, tbl)
    MODULE:Log(GAS.Logging:FormatPlayer(ply) .. " bought the item "..tbl["name"].." ( uniqueId : "..tbl["uniqueId"].." )")
end)

GAS.Logging:AddModule(MODULE)
