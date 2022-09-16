if SERVER then
    util.AddNetworkString("MMF_RunSequence")
else
    net.Receive("MMF_RunSequence", function()
        local ent = net.ReadEntity()
        local sequence = net.ReadString()
        MMF.RunSequence(ent, sequence)
    end)
end

function MMF.RunSequence(ent, sequence)
    if CLIENT then
        ent:SetCycle(0)
        ent:SetSequence(sequence)
        ent:ResetSequence(sequence)
    else
        net.Start("MMF_RunSequence")
            net.WriteEntity(ent)
            net.WriteString(sequence)
        net.SendPVS(ent:GetPos())
    end
end