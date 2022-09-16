local MODULE = bLogs:Module()
MODULE.Category = "DarkRP"
MODULE.Name = "SPZones"
MODULE.Colour = Color(255, 0, 0)

MODULE:Hook("SPZoneEntered", "SPZonesEnteredLog", function(ply, type)
    MODULE:Log(bLogs:FormatPlayer(ply) .. " broke nlr and has been " .. type)
end)

bLogs:AddModule(MODULE)