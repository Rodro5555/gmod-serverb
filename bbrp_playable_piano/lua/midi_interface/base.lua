piano_midi = {}
piano_midi.releaseHold = false
piano_midi.pressedHold = false
piano_midi.releaseHoldOld = false
piano_midi.pressedHoldOld = false
piano_midi.noteOn = {}
piano_midi.noteHold = {}
piano_midi.MIDI_CC_HOLD = 64
piano_midi.MIDI_CC_SOSTENUTO = 66
piano_midi.MIDI_CC_VALUE_ON = 64
piano_midi.VEL_CLAMP_MIN = 32
piano_midi.VEL_CLAMP_MAX = 127

include("midi_interface/console.lua")

local table = table

function piano_midi.clampVelocity(velocity)
    local velClampVar = GetConVar("midi_vel_clamp")
    local velClamp = piano_midi.VEL_CLAMP_MAX
    if velClampVar then
        velClamp = velClampVar:GetInt()
    end
    if velClamp < piano_midi.VEL_CLAMP_MIN then
        velClamp = piano_midi.VEL_CLAMP_MIN
    end
    if velClamp > piano_midi.VEL_CLAMP_MAX then
        velClamp = piano_midi.VEL_CLAMP_MAX
    end
    if velocity > velClamp then
        velocity = velClamp
    end
    return velocity * 127 / velClamp
end

function piano_midi.sendNote(instrument, note, velocity)
    if not instrument.RegisterNoteEvent then
        error("Invalid instrument entity.")
    end
    if note < 1 or note > instrument.SemitonesNum then
        error("Note out of range. (1-" .. instrument.SemitonesNum .. ")")
    end
    instrument:RegisterNoteEvent(note, piano_midi.clampVelocity(velocity))
end

-- To string everything and add tabs, as normal print would
local function printPre(addNewl, ...)
    local d = {...}
    local last = #d
    local out = {}

    for k, v in ipairs(d) do
        table.insert(out, tostring(v))

        if k ~= last then
            table.insert(out, "\t")
        end
    end
    if addNewl then
        table.insert(out, "\n")
    end
    return unpack(out)
end

-- Print functions that prefix "MIDI" with colour
function piano_midi.print(...)
    MsgC(Color(0, 255, 255), "Piano MIDI: ", Color(220, 220, 220), printPre(true, ...))
end

function piano_midi.printChat(...)
    chat.AddText(Color(0, 255, 255), "Piano MIDI: ", Color(220, 220, 220), printPre(false, ...))
end

function piano_midi.eventHook(time, command, note, velocity, ...)
    if not command then return end
    local code = midi.GetCommandCode(command)
    local name = midi.GetCommandName(command)
    -- Zero velocity NOTE_ON substitutes NOTE_OFF
    if name == "NOTE_ON" and velocity == 0 then
        name = "NOTE_OFF"
    end
    -- Do debug print if enabled
    local cVar = GetConVar("midi_debug")
    if cVar and cVar:GetBool() then
        -- The code is a byte (number between 0 and 254).
        piano_midi.print(" = == EVENT = = =")
        piano_midi.print("Time:\t", time)
        piano_midi.print("Code:\t", code)
        piano_midi.print("Channel:\t", midi.GetCommandChannel(command))
        piano_midi.print("Name:\t", name)
        piano_midi.print("Parameters", note, velocity, ...)
    end
    -- Get instrument entity
    local instrument = LocalPlayer().Instrument
    if midi and IsValid(instrument) then
        if (name == "NOTE_ON") and
           (note > 35) and (note <= (35 + instrument.SemitonesNum)) then
            if not piano_midi.pressedHold then
                piano_midi.noteOn[note] = true
            end
            piano_midi.sendNote(instrument, note - 35, velocity)
        elseif (name == "NOTE_OFF") and
               (note > 35) and (note <= (35 + instrument.SemitonesNum)) then
            if not piano_midi.pressedHold then
                table.remove(piano_midi.noteOn, note)
            end
            if piano_midi.releaseHold then
                piano_midi.noteHold[note] = true
            else
                if not piano_midi.pressedHold or
                   (piano_midi.pressedHold and not piano_midi.noteOn[note]) then
                    piano_midi.sendNote(instrument, note - 35, 0)
                end
            end
        elseif (name == "CONTINUOUS_CONTROLLER") then
            if (note == piano_midi.MIDI_CC_HOLD) then
                piano_midi.releaseHoldOld = piano_midi.releaseHold
                piano_midi.releaseHold = velocity >= piano_midi.MIDI_CC_VALUE_ON
                if not piano_midi.releaseHold and piano_midi.releaseHoldOld and
                   not table.IsEmpty(piano_midi.noteHold) then
                    for noteIndex, hold in pairs(piano_midi.noteHold) do
                        piano_midi.sendNote(instrument, noteIndex - 35, 0)
                    end
                    piano_midi.noteHold = {}
                end
            elseif (note == piano_midi.MIDI_CC_SOSTENUTO) then
                piano_midi.pressedHoldOld = piano_midi.pressedHold
                piano_midi.pressedHold = velocity >= piano_midi.MIDI_CC_VALUE_ON
                if not piano_midi.pressedHold and piano_midi.pressedHoldOld and
                   not table.IsEmpty(piano_midi.noteOn) then
                    for noteIndex, active in pairs(piano_midi.noteOn) do
                        piano_midi.sendNote(instrument, noteIndex - 35, 0)
                    end
                    piano_midi.noteOn = {}
                end
            end
        end
    end
end

function piano_midi.load()
    -- If file exists (windows, macosx or linux)
    if file.Exists("lua/bin/gmcl_midi_osx.dll", "MOD") or
       file.Exists("lua/bin/gmcl_midi_osx64.dll", "MOD") or
       file.Exists("lua/bin/gmcl_midi_win32.dll", "MOD") or
       file.Exists("lua/bin/gmcl_midi_win64.dll", "MOD") or
       file.Exists("lua/bin/gmcl_midi_linux.dll", "MOD") or
       file.Exists("lua/bin/gmcl_midi_linux64.dll", "MOD") then
        piano_midi.print("GMCL MIDI module detected!")
        require("midi") -- Import the library
        if midi then -- Check it succeeded
            piano_midi.printChat("GMCL MIDI module initialised. Use console commands midi_devices and midi_debug [0|1] to use.")
            piano_midi.releaseHold = false
            piano_midi.pressedHold = false
            piano_midi.releaseHoldOld = false
            piano_midi.pressedHoldOld = false
            piano_midi.noteOn = {}
            piano_midi.noteHold = {}
            hook.Add("MIDI", "midiPlayablePiano", piano_midi.eventHook)
            -- Tell others it worked
            hook.Run("piano_midi_init", midi)
        else
            print("Failed to initialise GMCL MIDI module.")
        end
    end
end

piano_midi.load()
