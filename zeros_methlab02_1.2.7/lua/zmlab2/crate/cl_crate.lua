if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Crate = zmlab2.Crate or {}

function zmlab2.Crate.Initialize(Crate)
    timer.Simple(0.1,function()
        if not IsValid(Crate) then return end
        Crate.Initialized = true
    end)
end

function zmlab2.Crate.Draw(Crate)

    if Crate.Initialized and zclib.util.InDistance(Crate:GetPos(), LocalPlayer():GetPos(), 500) then

        if zclib.Convar.Get("zmlab2_cl_drawui") == 1 then zmlab2.Meth.DrawHUD(Crate:GetPos() + Vector(0,0,25),0.1,Crate:GetMethType(),Crate:GetMethAmount(),Crate:GetMethQuality()) end

        if Crate:GetMethAmount() ~= Crate.CurMethAmount then
            Crate.CurMethAmount = Crate:GetMethAmount()
            zmlab2.Crate.UpdateMethMaterial(Crate)
        end

        // Update the material once it gets drawn
        if Crate.LastDraw and CurTime() > (Crate.LastDraw + 0.1) then
            zmlab2.Crate.UpdateMethMaterial(Crate)
        end

        Crate.LastDraw = CurTime()
    end
end

function zmlab2.Crate.UpdateMethMaterial(Crate)
    //zclib.Debug("zmlab2.Crate.UpdateMethMaterial")

    if Crate:GetMethAmount() <= 0 then return end
    if Crate:GetMethType() <= 0 then return end
    local MethMat = zmlab2.Meth.GetMaterial(Crate:GetMethType(),Crate:GetMethQuality())
    Crate:SetSubMaterial(0, "!" .. MethMat)
end
