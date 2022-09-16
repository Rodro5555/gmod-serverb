include("shared.lua")
local mushrooms = {}

function ENT:Initialize()
    if self:GetModel() == "models/error.mdl" then
        self:SetModel("models/dom/magicmushroomfactory/amanita-mushroom.mdl")
    end

    self:SetModelScale(0.1, 0)

    timer.Simple(1, function()
        if IsValid(self) then
            self:SetModelScale(1, MMF.MushroomGrowTimeSeconds)
        end
    end)

    self:SetNextClientThink(CurTime() + MMF.MushroomGrowTimeSeconds - 1)

    timer.Simple(MMF.MushroomGrowTimeSeconds, function()
        if IsValid(self) then
            self.IsGrown = true
            self:SetHalo(true)
        end
    end)
end

function ENT:OnRemove()
    self:SetHalo(false)
end

function ENT:SetHalo(value)
    if value then
        table.insert(mushrooms, self)
    else
        table.RemoveByValue(mushrooms, self)
    end
end

function ENT:Think()
    if self.IsGrown and not IsValid(self:GetParent()) then
        self:SetHalo(false)
        return true
    end

    self:SetNextClientThink(CurTime() + 0.5)
    return true
end

local halo_color = Color(132, 66, 245)

hook.Add("PreDrawHalos", "MMF_MushroomHalos", function()
    halo.Add(mushrooms, halo_color, 4, 4, 1)
end)