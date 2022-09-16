zrush = zrush or {}
zrush.DrillHole = zrush.DrillHole or {}


// Is the DrillHole ready for the machine?
function zrush.DrillHole.ReadyForMachine(DrillHole, MachineID, ply)
    local m_state = DrillHole:GetState()
    if (m_state == ZRUSH_STATE_NEEDPIPES and not DrillHole:HasDrill()) then
        if (MachineID ~= ZRUSH_DRILL) then
            if (SERVER) then
                zclib.Notify(ply, zrush.language["Needsdrilledfirst"], 1)
            end
        else
            return true
        end
    elseif (m_state == ZRUSH_STATE_NEEDBURNER and not DrillHole:HasBurner()) then
        if (MachineID ~= ZRUSH_BURNER) then
            if (SERVER) then
                zclib.Notify(ply, zrush.language["NeedsBurnerquick"], 1)
            end
        else
            return true
        end
    elseif (m_state == ZRUSH_STATE_PUMPREADY and not DrillHole:HasPump()) then
        if (MachineID ~= ZRUSH_PUMP) then
            if (SERVER) then
                zclib.Notify(ply, zrush.language["NeedsPump"], 1)
            end
        else
            return true
        end
    else
        if (SERVER) then
            zclib.Notify(ply, zrush.language["NotValidSpace"], 1)
        end
    end
end
