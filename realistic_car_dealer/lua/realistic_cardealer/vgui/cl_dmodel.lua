local PANEL = {}

function PANEL:Init()
    self:SetSize(RCD.ScrW*0.4, RCD.ScrH*0.525)
    self:SetModel("models/airboat.mdl")
    self.RCDZoom = true
    self.RCDCanRotate = true
    self.RCDFocusEnt = nil
    self.RCDLerpFOV = 43
    self.RCDFOVBase = 43
    self.RCDLerpVector = RCD.Constants["vectorOrigin"]
    self.RCDVector = RCD.Constants["vectorOrigin"]
    self.RCDStartAng = 0
    self.MinMaxLerp = {0, 0}
    
    if IsValid(self.Entity) then
        local mn, mx = self.Entity:GetRenderBounds()
        local size = 0
        size = math.max(size, math.abs(mn.x)+math.abs(mx.x))
        size = math.max(size, math.abs(mn.y)+math.abs(mx.y))
        size = math.max(size, math.abs(mn.z)+math.abs(mx.z))
    
        self:SetFOV(43)
        self:SetCamPos(Vector(size, size, 100))
        self:SetLookAt((mn+mx) * 0.3)
    end
end

function PANEL:Zoom()
    self.RCDZoom = !self.RCDZoom
end

function PANEL:CanRotateCamera(bool)
    self.RCDCanRotate = bool
end

function PANEL:SetFocusEntity(ent)
    self.RCDFocusEnt = ent
end

function PANEL:RCDSetFOV(number)
    self.RCDFOV = number
end

function PANEL:RCDSetFOVBase(number)
    self.RCDFOVBase = number
end

function PANEL:Think()
    if isnumber(self.RCDFOV) then
        self.RCDLerpFOV = Lerp(FrameTime()*3, self.RCDLerpFOV, self.RCDFOV)
        self:SetFOV(self.RCDLerpFOV)
    end

    if isvector(self.RCDVector) then
        self.RCDLerpVector = LerpVector(FrameTime()*3, self.RCDLerpVector, self.RCDVector)
    end

    if not self:IsHovered() && not isnumber(self.RCDStartAng) or not IsValid(self.RCDFocusEnt) then return end

    local CurX, CurY = self:ScreenToLocal(gui.MouseX(), gui.MouseY())

    if input.IsMouseDown(MOUSE_LEFT) && self.RCDCanRotate && LocalPlayer():RCDCanAccessVehicle(RCD.ClientTable["vehicleId"]) then 
        if not isnumber(self.RCDStartAng) then self.RCDStartAng = CurX end
        
        local ang = self.RCDFocusEnt:GetAngles()
        local newAng = ang.yaw-((self.RCDStartAng-CurX)/self:GetWide())*2
        
        self.RCDFocusEnt:SetAngles(Angle(ang.pitch, newAng, ang.roll))

    else
        self.RCDStartAng = nil
    end
end

function PANEL:DrawModel()
    if not IsValid(self.Entity) then return end
    
    self.Entity:DrawModel()
    
    for k, wheel in ipairs(self.Entity["wheels"] or {}) do
        if not IsValid(wheel) then continue end

        wheel:DrawModel()
    end
end

function PANEL:RemoveWheels()
    for k, wheel in ipairs(self.Entity["wheels"] or {}) do
        if not IsValid(wheel) then continue end

        wheel:Remove()
    end
end

function PANEL:SetParams(paramsTbl, ent, bool, withoutLerp)
    if not IsValid(ent) then return end
    if not istable(paramsTbl) then return end

    if isnumber(paramsTbl["fov"]) then
        if withoutLerp then
            self:SetFOV(self.RCDFOVBase + paramsTbl["fov"])
        else
            self:RCDSetFOV(self.RCDFOVBase + paramsTbl["fov"])
        end
    end
    if isangle(paramsTbl["angle"]) then
        ent:SetAngles(paramsTbl["angle"]+(!bool and RCD.Constants["angleParams"] or RCD.Constants["angleOrigin"]))
    end
    if isvector(paramsTbl["vector"]) then
        local vector = (paramsTbl["addon"] == "simfphys") and Vector(0, paramsTbl["vector"].y, paramsTbl["vector"].z) or paramsTbl["vector"]

        if withoutLerp then
            self:SetLookAt(vector)
        else
            self.RCDVector = vector
        end
    end
    if istable(paramsTbl["defaultColor"]) then
        ent.RCDColor = paramsTbl["defaultColor"]
        if IsValid(panel) then panel:SetColor(paramsTbl["defaultColor"]) end
    end
    if isnumber(paramsTbl["skin"]) then
        ent:SetSkin(paramsTbl["skin"])
    end

    timer.Simple(0, function()
        if not IsValid(ent) then return end
        ent.RCDVisible = true
    end)
end

function PANEL:LayoutEntity()
    return
end

function PANEL:DoClick()
    self.RCDStartAng = self.Entity:GetAngles().yaw
end

derma.DefineControl("RCD:DModel", "RCD DModel", PANEL, "DModelPanel")