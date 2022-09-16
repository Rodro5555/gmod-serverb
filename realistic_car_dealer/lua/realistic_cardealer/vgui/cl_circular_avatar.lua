local PANEL = {}

function PANEL:Init()
    self.RCDAvatar = vgui.Create("AvatarImage", self)
    self.RCDAvatar:Dock(FILL)
    self.RCDAvatar:SetPaintedManually(true)
end

function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    RCD.DrawCircle(w/2, h/2, w/2, 0, 380, RCD.Colors["white"])

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.RCDAvatar:PaintManual()

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("RCD:CircularAvatar", PANEL)