include("shared.lua")

net.Receive("MMF_RunRecipeEffect", function(len)
    local ent = net.ReadEntity()
    ent:RunEffect(LocalPlayer())
    MMF.StartGnomeEffect()
end)