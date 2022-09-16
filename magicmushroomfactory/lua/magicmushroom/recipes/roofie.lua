local recipe = {
    Name = "Roofie",
    Description = [[
        Descubierta en 1999 en medio de la selva amazónica por un científico llamado ceifador
        este hongo tiene el poder de poner cualquier cosa a dormir, si quieres secuestrar a alguien,
        esa es la mejor opción.
    ]],
    Ingredients = {
        ["witcher"] = 2,
        ["bluesky"] = 3,
        ["amanita"] = 1
    },
    Bottles = 2,
    Price = 1000
}

if SERVER then
    function recipe:Effect(ply)
        local ragdoll = ents.Create("prop_ragdoll")
        ragdoll:SetPos(ply:GetPos())
        ragdoll:SetAngles(ply:GetAngles())
        ragdoll:SetModel(ply:GetModel())
        ragdoll:Spawn()
        ragdoll:Activate()
        ply:SetParent(ragdoll) -- So their player ent will match up (position-wise) with where their ragdoll is.
        ply:Spectate(OBS_MODE_CHASE)
        ply:SpectateEntity(ragdoll)
        ply:DisallowSpawning(true)
        ply:StripWeapons()
        ply:DrawViewModel(false)

        timer.Simple(10, function()
            if not IsValid(ply) or not IsValid(ragdoll) then return end
            ply:DrawViewModel(true)
            ply:DisallowSpawning(false)
            ply:SetParent()
            ply:UnSpectate() -- Need this for DarkRP for some reason, works fine without it in sbox
            local pos = ragdoll:GetPos()
            pos.z = pos.z + 10 -- So they don't end up in the ground
            ply:Spawn()
            ply:SetPos(pos)
            ply:SetVelocity(ragdoll:GetVelocity())
            local yaw = ragdoll:GetAngles().yaw
            ply:SetAngles(Angle(0, yaw, 0))
            ragdoll:DisallowDeleting(false)
            ragdoll:Remove()
        end)
    end
end

return recipe