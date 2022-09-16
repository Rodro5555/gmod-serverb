zcm = zcm or {}
zcm.f = zcm.f or {}

if SERVER then
    util.AddNetworkString("zcm_baseanim_AnimEvent_net")

    function zcm.f.PlayAnimation(ent, anim, speed)
        //ent:ServerAnim(anim, speed)
        local animInfo = {}
        animInfo.anim = anim
        animInfo.speed = speed
        animInfo.ent = ent
        net.Start("zcm_baseanim_AnimEvent_net")
        net.WriteTable(animInfo)
        net.Broadcast()
    end
end

if CLIENT then
    net.Receive("zcm_baseanim_AnimEvent_net", function(len, ply)
        local animInfo = net.ReadTable()

        if animInfo and IsValid(animInfo.ent) and animInfo.anim and animInfo.speed then
            zcm.f.PlayClientAnimation(animInfo.ent,animInfo.anim, animInfo.speed)
        end
    end)

    function zcm.f.PlayClientAnimation(ent,anim, speed)
        if not IsValid(ent) then return end
    	local sequence = ent:LookupSequence(anim)
    	ent:SetCycle(0)
    	ent:ResetSequence(sequence)
    	ent:SetPlaybackRate(speed)
    	ent:SetCycle(0)
    end
end
