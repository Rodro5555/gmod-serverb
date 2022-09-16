if CLIENT then return end
if not SERVER then return end
 
hook.Remove( "PhysgunDrop", "ulxPlayerDrop")
local function isPlayer(ent) return (IsValid(ent) && ent.GetClass && ent:GetClass() == "player") end
 
hook.Add("PhysgunPickup", "_ply_physgungrab", function(ply, targ)
    if IsValid(ply) and isPlayer(targ) then
        if ply:query("ulx physgunplayer") then
            local allowed, _ = ULib.getUser( "@", true, ply )
            if isPlayer(allowed) then
                if allowed.frozen && ply:query( "ulx unfreeze" ) then
                    allowed.phrozen = true;
                    allowed.frozen = false;
                end
                allowed._ulx_physgun = {p=targ:GetPos(), b=true}
            end
        end
    end
end, HOOK_HIGH)
 
hook.Add("PlayerSpawn", "_ply_physgungrab", function(ply)
    if ply._ulx_physgun then
        if ply._ulx_physgun.b and ply._ulx_physgun.p then
            timer.Simple(0.001, function()
                ply:SetPos(ply._ulx_physgun.p);
                ply:SetMoveType(MOVETYPE_NONE);
            end);
        end
    end
end)
 
local function physgun_freeze( calling_ply, target_ply, should_unfreeze)
    local v = target_ply
    if v:InVehicle() then
        v:ExitVehicle()
    end
 
    if not should_unfreeze then
        v:Lock()
        v.frozen = true
        v.phrozen = true
        ulx.setExclusive( v, "frozen" )
    else
        v:UnLock()
        v.frozen = nil
        v.phrozen = nil
        ulx.clearExclusive( v )
    end
 
    v:DisallowSpawning( not should_unfreeze )
    ulx.setNoDie( v, not should_unfreeze )
 
    if v.whipped then
        v.whipcount = v.whipamt
    end
end
 
hook.Add("PhysgunDrop", "_ulx_physgunfreeze", function(pl, ent)
    if isPlayer(ent) then
        ent:SetMoveType( MOVETYPE_WALK )
        ent._ulx_physgun = {p=ent:GetPos(), b=false}
    end
 
    if IsValid(pl) and isPlayer(ent) then
        if pl:query("ulx physgunplayer") then
            local isFrozen = ( ent:IsFrozen() or ent.frozen or ent.phrozen );
            ent:SetVelocity(ent:GetVelocity()*-1);
            ent:SetMoveType(pl:KeyDown(IN_ATTACK2) and MOVETYPE_NOCLIP or MOVETYPE_WALK);
            timer.Simple(0.001, function()
                if pl:KeyDown(IN_ATTACK2) and not isFrozen then
                    if pl:query( "ulx freeze" ) then
                        ulx.freeze( pl, {ent}, false );
                        if ent.frozen then ent.phrozen = true end;
                    end
                elseif pl:query( "ulx unfreeze" ) and isFrozen then
                    if pl:KeyDown(IN_ATTACK2) and pl:query( "ulx freeze" ) then
                        physgun_freeze(pl, ent, true)
                        timer.Simple(0.001, function() physgun_freeze(pl, ent, false) end);
                    else
                        ulx.freeze( pl, {ent}, true );
                        if not ent.frozen then ent.phrozen = nil end;
                    end
                end
            end);
        else
            ent:SetMoveType( MOVETYPE_WALK )
        end
    end
end)