local PANEL = {}

function PANEL:Init()
    local sbar = self:GetVBar()
    sbar:SetWide(RCD.ScrW*0.003)

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["grey30"])
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["grey30"])
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["grey30"])
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["grey30"])
    end
end

derma.DefineControl("RCD:DScroll", "RCD DScroll", PANEL, "DScrollPanel")