if SERVER then return end
ztm = ztm or {}
ztm.Trashbag = ztm.Trashbag or {}

function ztm.Trashbag.Initialize(Trashbag)
    zclib.EntityTracker.Add(Trashbag)
end

function ztm.Trashbag.Draw(Trashbag)
    if zclib.Convar.Get("zclib_cl_drawui") == 1 and zclib.util.InDistance(LocalPlayer():GetPos(), Trashbag:GetPos(), 300) and ztm.Player.IsTrashman(LocalPlayer()) then
        ztm.HUD.DrawTrash(Trashbag:GetTrash(),Trashbag:GetPos() + Vector(0, 0, 35))
    end
end


function ztm.Trashbag.OnRemove(Trashbag)
    ztm.Effects.Trash(Trashbag:GetPos())
    ztm.Effects.Trash(Trashbag:GetPos())
    ztm.Effects.Trash(Trashbag:GetPos())
end
