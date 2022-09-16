include("shared.lua")

local imgui = include("magicmushroom/thirdparty/imgui.lua")

function ENT:Initialize()
    self:UseClientSideAnimation()
    self.SmokeParticle = Model("particle/particle_noisesphere")
    self.ParticleEmitter = ParticleEmitter(self:GetPos())

    hook.Add("PostDrawOpaqueRenderables", self, function()
        self:DrawHint()
    end)
end

local hints = {
    {
        Text = MMF.Phrases.PutOnHeater,
        Condition = function(state, ent)
            return #ent:GetChildren() == 0
        end
    },
    {
        Text = MMF.Phrases.SetOnFire,
        Condition = function(state, ent)
            return state == MMF.CaldeidomState.Idle
        end
    },
    {
        Text = MMF.Phrases.WaitFinish,
        Condition = function(state, ent)
            return state == MMF.CaldeidomState.Preparing
        end
    },
    {
        Text = MMF.Phrases.CollectOnSpigot,
        Condition = function(state, ent)
            return state == MMF.CaldeidomState.Done
        end
    },
    {
        Text = MMF.Phrases.WaitPotion,
        Condition = function(state, ent)
            return state == MMF.CaldeidomState.Collecting
        end
    },
    {
        Text = MMF.Phrases.PotionBurned,
        Condition = function(state, ent)
            return state == MMF.CaldeidomState.Burned
        end
    }
}

function ENT:GetHints(state)
    for i, hint in ipairs(hints) do
        if hint.Condition(state, self) then
            local previous = hints[i - 1] and hints[i - 1].Text
            local current = hint.Text
            local next = hints[i + 1] and hints[i + 1].Text

            return current, previous, next
        end
    end
end

-- caching
local grey = Color(41, 41, 41)
local pink = Color(216, 9, 255)
local nextcol = Color(183, 183, 183)
local prevcol = Color(89, 89, 89)
local vec = Vector(25, 0, 25)
local ang = Angle(0, 90, 90)

function ENT:DrawHint()
    local state = self:GetState()
    local current, previous, next = self:GetHints(state)

    if imgui.Entity3D2D(self, vec, ang, 0.1) then
        draw.RoundedBox(10, -120, -100, 240, 120, grey)
        draw.RoundedBox(10, -120, -100, 240, 30, pink)

        draw.DrawText(MMF.Phrases.NextStep, "DermaDefault", 0, -92, color_white, TEXT_ALIGN_CENTER)

        if previous then
            draw.DrawText(previous, "DermaDefault", 0, -60, prevcol, TEXT_ALIGN_CENTER)
        end

        draw.DrawText("-> " .. current, "DermaDefault", 0, -35, color_white, TEXT_ALIGN_CENTER)

        if next then
            draw.DrawText(next, "DermaDefault", 0, -5, nextcol, TEXT_ALIGN_CENTER)
        end

        imgui.End3D2D()
    end
end

function ENT:Think()
    local state = self:GetState()

    if state >= MMF.CaldeidomState.Preparing then
        local smoke = self.ParticleEmitter:Add(self.SmokeParticle, self:GetPos() + self:GetUp() * 10)
        smoke:SetVelocity(VectorRand() * math.random(20, 100) * Vector(0.5, 0.5, 1))
        smoke:SetDieTime(math.random(5, 20))
        smoke:SetStartAlpha(200)
        smoke:SetCollide(true)
        smoke:SetEndAlpha(0)
        smoke:SetStartSize(math.random(5, 10))
        smoke:SetEndSize(math.random(20, 30))
        smoke:SetRoll(math.random(-180, 180))
        smoke:SetRollDelta(math.Rand(-1, 1))

        if state == MMF.CaldeidomState.Burned then
            smoke:SetColor(0, 0, 0)
        else
            smoke:SetColor(255, 255, 255)
        end

        smoke:SetGravity(Vector(0, 0, 10))
        smoke:SetAirResistance(128)
    end

    self:SetNextClientThink(CurTime() + 0.5)
    return true
end