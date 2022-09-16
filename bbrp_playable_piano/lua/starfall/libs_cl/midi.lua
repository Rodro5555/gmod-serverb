-- Adds SF hook call, and ability to send key events to an instrument

return function(instance)
    SF.hookAdd("MIDI")

    local ent_unwrap = instance.Types.Entity.Unwrap
    local ent_methods = instance.Types.Entity.Methods

    local function getent(self)
        local ent = ent_unwrap(self)
        if ent:IsValid() or ent:IsWorld() then
            return ent
        else
            SF.Throw("Entity is not valid.", 3)
        end
    end

    function ent_methods:isInstrument()
        local e = getent(self)
        return e.RegisterNoteEvent and true or false
    end

    -- We want to limit playNote calls as it directly calls net.Send, and could be used to lag the server.
    -- Get limit convar, and keep it updated
    local limitCVar = GetConVar("sv_midi_sf_notes_quota")
    local limit = limitCVar:GetInt()
    cvars.AddChangeCallback("sv_midi_sf_notes_quota", function(_, newLimit)
        limit = newLimit
    end)

    -- Create timer when needed to reset the noteCount
    local noteCount = 0
    local timerActive = false
    local function createTimer()
        if not timerActive then
            timerActive = true
            timer.Create("mi_sfnotelimit", 1, 0, function()
                if noteCount == 0 then
                    timer.Remove("mi_sfnotelimit")
                    timerActive = false
                end
                noteCount = 0
            end)
        end
    end

    -- boolean Entity:playNote(number noteIdx, number velocity)
    -- Takes note index from 1 to ent.SemitonesNum and velocity value from 0 to 127
    -- Returns if successful or not
    -- Limited by sv_midi_sf_notes_quota as a maximum number of notes per second
    function ent_methods:playNote(noteIdx, velocity)
        SF.CheckLuaType(noteIdx, TYPE_NUMBER)
        local ent = getent(self)
        if not ent.RegisterNoteEvent then
            error("Entity is not an instrument.")
        end
        if FPP then
            if not FPP.canTouchEnt(ent, "Physgun") then
                error("You do not have permission to send notes to this instrument")
            end
        else
            local o = ent:GetOwner()
            if IsValid(o) and o ~= LocalPlayer() then
                error("You do not have permission to send notes to this instrument")
            end
        end
        createTimer()
        noteCount = noteCount + 1
        if noteCount > limit then
            return false -- Called too many times
        end
        piano_midi.sendNote(ent, noteIdx, velocity)
        return true
    end
end

