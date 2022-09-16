zrush = zrush or {}
zrush.vgui = zrush.vgui or {}

if SERVER then
    // Forces the interface to be closed
    util.AddNetworkString("zrush_vgui_forceclose")
    function zrush.vgui.ForceClose(ply)
    	net.Start("zrush_vgui_forceclose")
    	net.Send(ply)
    end
else

    // This closes the machine ui for a user
    net.Receive("zrush_vgui_forceclose", function(len)
        zrush.vgui.Close()
    end)
end
