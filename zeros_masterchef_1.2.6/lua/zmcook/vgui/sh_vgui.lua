zmc = zmc or {}
zmc.vgui = zmc.vgui or {}

if SERVER then
    util.AddNetworkString("zmc_vgui_ForceClose")

    function zmc.vgui.ForceCloseAll(ent)
        net.Start("zmc_vgui_ForceClose")
        net.WriteEntity(ent)
        net.Broadcast()
    end
else
    // The entity which interface we are currently having open
    zmc.vgui.ActiveEntity = nil
    net.Receive("zmc_vgui_ForceClose", function(len)
        zclib.Debug_Net("zmc_vgui_ForceClose", len)
        local ent = net.ReadEntity()

        if ent == zmc.vgui.ActiveEntity and IsValid(zmc_main_panel) then
            zmc_main_panel:Remove()
        end
    end)
end
