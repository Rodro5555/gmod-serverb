MMF.PortalState = {
    Closed = 0,
    Opening = 1,
    Open = 2
}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Portal"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.Category = "Magic Mushrooms"
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "State")
end

function ENT:Open()
    self:SetState(MMF.PortalState.Opening)

    local sound, bones

    if SERVER then
        sound = CreateSound(self, "ambient/atmosphere/cave_outdoor1.wav")
        sound:Play()

        util.ScreenShake(self:GetPos(), 1, 4, 20, 4096)

        self:SetBodygroup(1, 0)
    else
        bones = self.Void:GetBoneCount()

        self.CrazyBones = {}

        self.Void:SetBodygroup(1, 1)
        self.Void:SetupBones()

        local initialpos = Vector(0, 0, 0)
        local initialscale = Vector(1, 1, 1)

        for bone = 1, bones do
            self.Void:ManipulateBonePosition(bone, initialpos)
            self.Void:ManipulateBoneScale(bone, initialscale)

            table.insert(self.CrazyBones, false)
        end
    end

    timer.Simple(4, function()
        if not IsValid(self) then return end

        if SERVER then
            util.ScreenShake(self:GetPos(), 2, 6, 2, 4096)
            self:EmitSound("ambient/explosions/exp3.wav", 120)
        else
            self.CrazyBones[math.random(bones)] = 1
        end
    end)

    timer.Simple(7, function()
        if not IsValid(self) then return end

        if SERVER then
            util.ScreenShake(self:GetPos(), 2, 6, 2, 4096)
            self:EmitSound("ambient/explosions/exp3.wav", 120)
        else
            self.CrazyBones[math.random(bones)] = 1
        end
    end)

    timer.Simple(10, function()
        if not IsValid(self) then return end

        if SERVER then
            util.ScreenShake(self:GetPos(), 6, 12, 2, 4096)
            self:EmitSound("ambient/explosions/exp2.wav", 160)

            sound:Stop()

            self:SetState(MMF.PortalState.Open)
        else
            local ed = EffectData()
            ed:SetScale(10)
            ed:SetMagnitude(30)
            ed:SetEntity(self)
            ed:SetOrigin(self:GetPos())
            ed:SetAngles(self:GetAngles())

            util.Effect("HelicopterMegaBomb", ed)

            for bone = 1, bones do
                if not self.CrazyBones[bone] then
                    self.CrazyBones[bone] = 1
                end
            end
        end
    end)

    timer.Simple(15, function()
        if not IsValid(self) then return end

        if SERVER then
            self:ScheduleClose()
        else
            if not IsValid(self.Void) then return end

            self.Void:SetBodygroup(1, 0)
            self.CrazyBones = nil
        end
    end)
end