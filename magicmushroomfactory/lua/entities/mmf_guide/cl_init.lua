include("shared.lua")

net.Receive("MMF_OpenGuideBook", function()
    SafeRemoveEntity(MMF.Guide)
    MMF.Guide = vgui.Create("MMF_Guide")
end)