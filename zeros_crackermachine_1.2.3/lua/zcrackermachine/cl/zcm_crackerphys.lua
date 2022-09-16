if SERVER then return end
zcm = zcm or {}
zcm.f = zcm.f or {}

local zcm_CRACKEROBJECTS = {}

function zcm.f.CrackerPackExplode(pos)

    local delay = 0
    local ang = Angle(0,0,0)

    if zcm.config.FireCracker.CrackerCount > 0 then
        for i = 1, zcm.config.FireCracker.CrackerCount do

            timer.Simple(delay, function()

                if zcm.f.InDistance(LocalPlayer():GetPos(), pos, zcm.f.GetRenderDistance()) then

                    sound.Play(zcm.Sounds["zcm_explode01"][math.random(#zcm.Sounds["zcm_explode01"])], pos, 75, 100, zcm.f.GetVolume())
                    zcm.f.ParticleEffect("crackerpack_explosion", pos, ang, NULL)

                    if zcm.f.ParticleOverFlow_Check() then
                        zcm.f.CrackerPhysicsHandler_CreateCracker(pos, ang, i)
                    end
                end
            end)

            delay = delay + 0.05
        end
    else

        zcm.f.ParticleEffect("crackerpack_explosion", pos, ang, NULL)
    end
    zcm.f.ParticleEffect("zcm_crackermain", pos, ang, NULL)
    sound.Play(zcm.Sounds["zcm_explode01"][math.random(#zcm.Sounds["zcm_explode01"])], pos, 75, 100, zcm.f.GetVolume())
end

function zcm.f.CrackerPhysicsHandler_CreateCracker(pos, ang, numId)
    local ent = ents.CreateClientProp()
    ent:SetModel("models/zerochain/props_crackermaker/zcm_cracker.mdl")
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:Spawn()
    ent:PhysicsInit(SOLID_VPHYSICS)
    ent:SetSolid(SOLID_NONE)
    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    ent:SetMoveType(MOVETYPE_VPHYSICS)
    ent:SetRenderMode(RENDERMODE_NORMAL)
    local phys = ent:GetPhysicsObject()

    if IsValid(phys) then

        local rnd_ang = Angle(math.Rand(0, 360), math.Rand(0, 360), math.Rand(0, 360))
        phys:SetMass(25)
        phys:Wake()
        phys:EnableMotion(true)

        local tickrate = 66.6 * engine.TickInterval()
        tickrate = tickrate * 64
        tickrate = math.Clamp(tickrate, 15, 64)

        local f_force = tickrate * 4
        local f_look = ang
        f_look:RotateAroundAxis(ang:Up(), (360 / zcm.config.FireCracker.CrackerCount) * numId)

        local f_dir = ang:Up() * f_force + f_look:Right() * f_force / 3

        phys:ApplyForceCenter(phys:GetMass() * f_dir)

        local val = 2
        local angVel = (rnd_ang:Up() * math.Rand(-val, val)) * phys:GetMass() * tickrate
        phys:AddAngleVelocity(angVel)
    end

    zcm.f.ParticleEffectAttach("zcm_crackerfuse", ent, 1)
    table.insert(zcm_CRACKEROBJECTS, {
        cracker = ent,
        explodetime = CurTime() + math.Rand(0.5,1.1),
        exploded = false
    })
end


function zcm.f.CrackerPhysicsHandler()
    if table.Count(zcm_CRACKEROBJECTS) > 0 then
        local ply = LocalPlayer()

        for k, v in pairs(zcm_CRACKEROBJECTS) do
            if IsValid(v.cracker) then
                if not zcm.f.InDistance(ply:GetPos(), v.cracker:GetPos(),zcm.f.GetRenderDistance()) or v.exploded then
                    if IsValid(v.cracker) then
                        v.cracker:StopSound("zcm_fuse")
                        v.cracker:Remove()
                    end

                    table.remove(zcm_CRACKEROBJECTS, k)
                elseif (CurTime() >= v.explodetime and v.exploded == false) then

                    zcm.f.ParticleEffect("cracker_explosion01",v.cracker:GetPos(), v.cracker:GetAngles(), NULL)
                    sound.Play(zcm.Sounds["zcm_crackerexplode"][math.random(#zcm.Sounds["zcm_crackerexplode"])], v.cracker:GetPos(), 75, 100, zcm.f.GetVolume())

                    v.exploded = true
                end
            end
        end
    end
end

hook.Add("Think", "a_zcm_think_CrackerPhysicsHandler", zcm.f.CrackerPhysicsHandler)
