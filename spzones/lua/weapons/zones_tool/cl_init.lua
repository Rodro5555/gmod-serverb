include("shared.lua")
SPZones = SPZones or {}

local drawTexts = {"Left click: Select position", "Right click: Saves once 2 locations has been chosen", "R click: Resets positions", "!spmenu to change modes"}

local stageMsg = {"Step 1: Create your first point with left click", "Step 2: Create your second point", "Step 3: Now you can save with right click or reset by pressing r", "Step 4: Now you can change the mode in !spmenu"}

function SWEP:Initialize()
    zonesSwep = self -- Does so self elements can be used outside SWEP functions
    self.display = true
    self.stage = 1
    self:Reload()
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end -- Prevents this from being triggered more than once

    if timer.Exists("SPZones.ResetSWEP") then
        timer.Remove("SPZones.ResetSWEP")
        self:Reload()
    end

    local tr = LocalPlayer():GetEyeTrace()
    if not tr.Entity:IsWorld() or self.stage == 3 then return end
    self:DoShootEffect(tr.HitPos, tr.HitNormal, tr.Entity, tr.PhysicsBone)

    if self.stage == 1 then
        self.locationOne = tr.HitPos
        self.stage = 2

        return true
    end

    if self.stage == 2 then
        self.locationTwo = tr.HitPos
        self.stage = 3

        return true
    end
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() or not self.stage then return end -- Prevents this from being triggered more than once

    if self.stage == 3 then
        self.stage = 4
        self:EmitSound(self.ShootSound)
        self.tempLocationOne = Vector(math.max(self.locationOne.x, self.locationTwo.x), math.max(self.locationOne.y, self.locationTwo.y), math.max(self.locationOne.z, self.locationTwo.z))
        self.tempLocationTwo = Vector(math.min(self.locationOne.x, self.locationTwo.x), math.min(self.locationOne.y, self.locationTwo.y), math.min(self.locationOne.z, self.locationTwo.z))
        net.Start("SPZones.SendToServer")
        net.WriteVector(self.tempLocationOne)
        net.WriteVector(self.tempLocationTwo)
        net.SendToServer()

        timer.Create("SPZones.ResetSWEP", 5, 1, function()
            if not self then return end
            self:Reload()
        end)
    end
end

function SWEP:DoShootEffect(hitpos, hitnormal, entity, physbone)
    self:EmitSound(self.ShootSound)
    local effectdata = EffectData()
    effectdata:SetOrigin(hitpos)
    effectdata:SetNormal(hitnormal)
    effectdata:SetEntity(entity)
    effectdata:SetAttachment(physbone)
    util.Effect("selection_indicator", effectdata)
    local effectdata2 = EffectData()
    effectdata2:SetOrigin(hitpos)
    effectdata2:SetStart(self:GetOwner():GetShootPos())
    effectdata2:SetAttachment(1)
    effectdata2:SetEntity(self)
    util.Effect("ToolTracer", effectdata2)
end

function SWEP:Reload()
    if self.stage == 1 then return end
    self.locationOne = nil
    self.locationTwo = nil
    self.stage = 1

    if timer.Exists("SPZones.ResetSWEP") then
        timer.Remove("SPZones.ResetSWEP")
    end
end

function SWEP:DrawHUD()
    if not self.display then return end
    self.lastDraw = CurTime()
    surface.SetFont("Trebuchet24")

    for k, v in pairs(drawTexts) do
        local message = v
        local width, height = surface.GetTextSize(message)
        draw.SimpleText(message, "Trebuchet24", width / 2 + 50, 50 + height * (k - 1), Color(255, 255, 255, 255), 1, 1)
    end

    local _, height = surface.GetTextSize(stageMsg[self.stage])
    draw.SimpleText(stageMsg[self.stage], "DermaLarge", ScrW() / 2, ScrH() - height, Color(255, 255, 255, 255), 1, 1)

    if SPZones.Restricted then
        for k, v in pairs(SPZones.Restricted) do
            if isvector(v[1]) and isvector(v[2]) then
                render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), v[1], v[2], Color(52, 152, 219, 255), true)
            end
        end
    end

    if self.stage == 1 then return end

    if self.stage == 2 then
        draw.SimpleText("[SPZones] First position added", "Trebuchet24", ScrW() / 2, ScrH() / 3, Color(255, 255, 255, 255), 1, 1)
    elseif self.stage == 3 then
        draw.SimpleText("[SPZones] Second position added", "Trebuchet24", ScrW() / 2, ScrH() / 3, Color(255, 255, 255, 255), 1, 1)
    elseif self.stage == 4 then
        draw.SimpleText("[SPZones] Saved zone", "Trebuchet24", ScrW() / 2, ScrH() / 3, Color(255, 255, 255, 255), 1, 1)
    end
end

function SP.Draw3D()
    if not zonesSwep or not zonesSwep.display then return end

    if zonesSwep.lastDraw then
        if CurTime() - zonesSwep.lastDraw > 0.1 then
            firstTickEquip = nil
            -- Ensures that when DrawHUD stops being called this stops too

            return
        end

        if not firstTickEquip then
            firstTickEquip = true
            net.Start("SPZones.Request")
            net.SendToServer()
        end
    end

    if SPZones.Restricted then
        for k, v in pairs(SPZones.Restricted) do
            if isvector(v[1]) and isvector(v[2]) then
                render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), v[1], v[2], Color(52, 152, 219, 255), true)
                local x = (v[1][1] + v[2][1]) / 2
                local y = (v[1][2] + v[2][2]) / 2
                local z = (v[1][3] + v[2][3]) / 2
                local centerPos = Vector(x, y, z)
                local ang = LocalPlayer():EyeAngles()
                cam.Start3D2D(centerPos, Angle(0, ang.y - 90, 90), 1)
                draw.SimpleText("Zone: " .. k, "Trebuchet24", 0, 0, Color(255, 255, 255, 255), 1, 1)
                cam.End3D2D()
            end
        end
    end

    if zonesSwep.stage == 2 then
        render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), zonesSwep.locationOne, LocalPlayer():GetEyeTrace().HitPos, Color(52, 152, 219, 255), true)
    elseif zonesSwep.stage == 3 then
        render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), zonesSwep.locationOne, zonesSwep.locationTwo, Color(52, 152, 219, 255), true)
    end
end

hook.Add("PostDrawTranslucentRenderables", "SP.Draw3D", SP.Draw3D)

function SP.SwitchWeapon(ply, oldWeapon, newWeapon)
    if not IsValid(zonesSwep) then return end

    -- Switch in other methods than weapons makes this useless
    if newWeapon:GetClass() == zonesSwep:GetClass() then
        zonesSwep.display = true
    else
        zonesSwep.display = false
    end
end

hook.Add("PlayerSwitchWeapon", "SP.SwitchWeapon", SP.SwitchWeapon)