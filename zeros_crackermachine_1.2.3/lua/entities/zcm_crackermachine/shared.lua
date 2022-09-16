ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_crackermaker/zcm_base.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Crackermachine"
ENT.Category = "Zeros Crackermachine"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "ProductionStage01")
    self:NetworkVar("Int", 1, "ProductionStage02")

    self:NetworkVar("Int", 2, "Paper")
    self:NetworkVar("Int", 3, "BlackPowder")
    self:NetworkVar("Int", 4, "PaperRolls")

    self:NetworkVar("Int", 5, "FinalStage")

    self:NetworkVar("Int", 6, "UpgradeLevel")


    self:NetworkVar("Bool", 0, "Running")
    self:NetworkVar("Float",0, "Speed")

    self:NetworkVar("Float",1, "UCooldDown")

    self:NetworkVar("Entity", 0, "PaperRoller")
    self:NetworkVar("Entity", 1, "RollMover")
    self:NetworkVar("Entity", 2, "RollCutter")
    self:NetworkVar("Entity", 3, "RollReleaser")
    self:NetworkVar("Entity", 4, "RollPacker")
    self:NetworkVar("Entity", 5, "RollBinder")
    self:NetworkVar("Entity", 6, "PowderFiller")

    if (SERVER) then
        self:SetProductionStage01(0)
        self:SetProductionStage02(0)
        self:SetSpeed(1)
        self:SetPaper(0)
        self:SetBlackPowder(0)
        self:SetPaperRolls(0)
        self:SetRunning(false)
        self:SetFinalStage(0)
        self:SetUpgradeLevel(0)
        self:SetUCooldDown(-1)
    end
end

function ENT:OnSwitchButton(ply)
    local trace = ply:GetEyeTrace()
    //debugoverlay.Sphere(self:LocalToWorld(Vector(-40, 55, 53)), 1, 0.1, Color( 255, 255, 255 ), true )
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.z > 44.7 and lp.z < 49.7 and lp.x < -24.8 and lp.x > -34.6 then
        return true
    else
        return false
    end
end

function ENT:OnUpgradeButton(ply)
    local trace = ply:GetEyeTrace()
    //debugoverlay.Sphere(self:LocalToWorld(Vector(-40, 55, 53)), 1, 0.1, Color( 255, 255, 255 ), true )
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.z > 44.7 and lp.z < 49.7 and lp.x < -35.9 and lp.x > -54.4 then
        return true
    else
        return false
    end
end

function ENT:GetPaperCap()
    return zcm.config.CrackerMachine.Paper_Cap + (zcm.config.CrackerMachine.Upgrades.Paper_Cap_Upgrade * self:GetUpgradeLevel())
end

function ENT:GetBlackPowderCap()
    return zcm.config.CrackerMachine.BlackPowder_Cap + (zcm.config.CrackerMachine.Upgrades.BlackPowder_Cap_Upgrade * self:GetUpgradeLevel())
end
