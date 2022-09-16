zmlab2 = zmlab2 or {}
zmlab2.Player = zmlab2.Player or {}

function zmlab2.Player.IsMethCook(ply)
    if BaseWars then return true end
	if zmlab2.config.Jobs == nil then return true end
	if table.Count(zmlab2.config.Jobs) <= 0 then return true end

	if zmlab2.config.Jobs[zclib.Player.GetJob(ply)] then
		return true
	else
		return false
	end
end

// Returns the dropoff point if the player has one assigned
function zmlab2.Player.GetDropoff(ply)
	return ply.zmlab2_Dropoff
end

// Does the player has meth?
function zmlab2.Player.HasMeth(ply)
	if (ply.zmlab2_MethList and #ply.zmlab2_MethList > 0) then
		return true
	else
		return false
	end
end

function zmlab2.Player.OnMeth(ply)
	if ply.zmlab2_MethDuration and ply.zmlab2_MethStart and (ply.zmlab2_MethDuration + ply.zmlab2_MethStart) > CurTime() then
		return true
	else
		return false
	end
end

// Checks if the player is allowed to interact with the entity
function zmlab2.Player.CanInteract(ply, ent)
    if zmlab2.Player.IsMethCook(ply) == false then
        zclib.Notify(ply, zmlab2.language["Interaction_Fail_Job"], 1)

        return false
    end

    if zmlab2.config.SharedEquipment == true then
        return true
    else
        // Is the entity a public entity?
        if ent.IsPublic == true then return true end

        if zclib.Player.IsOwner(ply, ent) then
            return true
        else
            zclib.Notify(ply, zmlab2.language["YouDontOwnThis"], 1)

            return false
        end
    end
end
