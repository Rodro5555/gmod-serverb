ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_methlab/zmlab2_tentkit.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Tent"
ENT.Category = "Zeros Methlab 2"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()

    self:NetworkVar("Int", 1, "BuildState")
    self:NetworkVar("Int", 2, "BuildCompletion")

    self:NetworkVar("Int", 3, "TentID")

    self:NetworkVar("Int", 4, "ColorID")

    self:NetworkVar("Bool", 1, "IsPublic")

    self:NetworkVar("Int", 5, "LastExtinguish")


    if (SERVER) then
        self:SetTentID(-1)
        self:SetColorID(1)

        // Unfolded
        self:SetBuildState(-1)
        self:SetBuildCompletion(-1)

        self:SetIsPublic(false)

        self:SetLastExtinguish(0)
    end
end

function ENT:OnControllPanel(ply)
    if self:GetAttachment(1) == nil then return false end
    local trace = ply:GetEyeTrace()

    if trace.HitPos:Distance(self:GetAttachment(1).Pos) < 5 then
        return true
    else
        return false
    end
end

function ENT:OnLightButton(ply)
    if self:GetAttachment(1) == nil then return false end
    local attach = self:GetAttachment(1)
    local trace = ply:GetEyeTrace()
    if zclib.util.InDistance(attach.Pos - attach.Ang:Forward() * 5, trace.HitPos, 2) then
        return true
    else
        return false
    end
end

function ENT:OnExtinquisher(ply)
    if self:GetAttachment(1) == nil then return false end
    local attach = self:GetAttachment(1)
    local trace = ply:GetEyeTrace()
    if zclib.util.InDistance(attach.Pos, trace.HitPos, 2) then
        return true
    else
        return false
    end
end

function ENT:OnFoldButton(ply)
    if self:GetAttachment(1) == nil then return false end
    local attach = self:GetAttachment(1)
    local trace = ply:GetEyeTrace()

    //debugoverlay.Sphere(attach.Pos - attach.Ang:Forward() * 5,2,0.1,Color( 255, 255, 255 ),true)

    if zclib.util.InDistance(attach.Pos + attach.Ang:Forward() * 5, trace.HitPos, 2) then
        return true
    else
        return false
    end
end

function ENT:CanProperty(ply)
    return zclib.Player.IsAdmin(ply)
end

function ENT:CanTool(ply, tab, str)
    return str == "colour" or zclib.Player.IsAdmin(ply)
end

function ENT:CanDrive(ply)
    return zclib.Player.IsAdmin(ply)
end
