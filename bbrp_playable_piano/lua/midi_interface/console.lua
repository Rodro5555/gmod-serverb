local MI_INVALID_DEVICE_NAME = "None"
local concommand = concommand
local deviceInUse = MI_INVALID_DEVICE_NAME
local midi

function Derma_OptionRequest(strTitle, strText, options, selectedIndex,
                             fnEnter, fnCancel,
                             strButtonText, strButtonCancelText)
    local Window = vgui.Create("DFrame")
    Window:SetTitle(strTitle or "Message Title (First Parameter)")
    Window:SetDraggable(false)
    Window:ShowCloseButton(false)
    Window:SetBackgroundBlur(true)
    Window:SetDrawOnTop(true)

    local InnerPanel = vgui.Create("DPanel", Window)
    InnerPanel:SetPaintBackground(false)

    local Text = vgui.Create("DLabel", InnerPanel)
    Text:SetText(strText or "Message Text (Second Parameter)")
    Text:SizeToContents()
    Text:SetContentAlignment(5)
    Text:SetTextColor(color_white)

    local ComboBox = vgui.Create("DComboBox", InnerPanel)
    for index, optionText in pairs(options) do
        ComboBox:AddChoice(optionText)
    end
    ComboBox:ChooseOptionID(selectedIndex or 1)
    ComboBox.OnEnter = function()
        Window:Close()
        fnEnter(ComboBox:GetSelectedID())
    end

    local ButtonPanel = vgui.Create("DPanel", Window)
    ButtonPanel:SetTall(30)
    ButtonPanel:SetPaintBackground(false)

    local Button = vgui.Create("DButton", ButtonPanel)
    Button:SetText(strButtonText or "OK")
    Button:SizeToContents()
    Button:SetTall(20)
    Button:SetWide(Button:GetWide() + 20)
    Button:SetPos(5, 5)
    Button.DoClick = function()
        Window:Close()
        fnEnter(ComboBox:GetSelectedID())
    end

    local ButtonCancel = vgui.Create("DButton", ButtonPanel)
    ButtonCancel:SetText(strButtonCancelText or "Cancel")
    ButtonCancel:SizeToContents()
    ButtonCancel:SetTall(20)
    ButtonCancel:SetWide(Button:GetWide() + 20)
    ButtonCancel:SetPos(5, 5)
    ButtonCancel:MoveRightOf(Button, 5)
    ButtonCancel.DoClick = function()
        Window:Close()
        if (fnCancel) then
            fnCancel(ComboBox:GetSelectedID())
        end
    end

    local w, h = Text:GetSize()
    w = math.max(w, 400)
    Window:SetSize(w + 50, h + 25 + 75 + 10)
    Window:Center()
    InnerPanel:StretchToParent(5, 25, 5, 45)
    Text:StretchToParent(5, 5, 5, 35)
    ComboBox:StretchToParent(5, nil, 5, nil)
    ComboBox:AlignBottom(5)
    ComboBox:RequestFocus()
    ComboBox:SelectAllText(true)
    ButtonPanel:SetWide(Button:GetWide() + 5 + ButtonCancel:GetWide() + 10)
    ButtonPanel:CenterHorizontal()
    ButtonPanel:AlignBottom(8)
    Window:MakePopup()
    Window:DoModal()
    return Window
end

local function midiClose()
    if midi.IsOpened() then
        midi.Close()
        piano_midi.print("Disconnected")
    end
end

local function midiOpen(ports, index)
    if ports[index] then
        midiClose()
        midi.Open(index)
        piano_midi.print("Connected to device " .. ports[index])
    end
end

local function midiReload(ply, cmd, args)
    piano_midi.print("Reloading...")
    piano_midi.load()
end

local function midiDevices(ply, cmd, args)
    local ports = midi.GetPorts()
    local portsCount = table.Count(ports)
    if portsCount > 0 then
        piano_midi.print("Opening menu...")
        local devices = { MI_INVALID_DEVICE_NAME }
        for index, deviceName in pairs(ports) do
            devices[index + 2] = deviceName
        end
        local deviceIndex = table.KeyFromValue(devices, deviceInUse)
        if not deviceIndex then
            deviceIndex = 1
        end
        Derma_OptionRequest("Device selection", "Which device you would like to use?",
                            devices, deviceIndex, function(index)
                                deviceInUse = devices[index]
                                if index > 1 then
                                    midiOpen(ports, index - 2)
                                else
                                    midiClose()
                                end
                            end)
    else
        piano_midi.print("No devices connected.")
    end
end

local function midiInit(_midi)
    deviceInUse = MI_INVALID_DEVICE_NAME
    midi = _midi
    -- Connect to first device if it exists for convenience
    local ports = midi.GetPorts()
    local portsCount = table.Count(ports)
    if portsCount > 0 then
        deviceInUse = ports[0]
        midiOpen(ports, 0)
    end
    -- Pop up interface to let you select a midi device
    concommand.Add("midi_devices", midiDevices)
    CreateConVar("midi_debug", "0", FCVAR_ARCHIVE,
                 "Should MIDI events be printed to chat", 0, 1)
    CreateConVar("midi_vel_clamp", "127", FCVAR_ARCHIVE,
                 "Velocity value that corresponds to the highest sound volume",
                 piano_midi.VEL_CLAMP_MIN, piano_midi.VEL_CLAMP_MAX)
end

concommand.Add("midi_reload", midiReload)
hook.Add("piano_midi_init", "piano_midi_console", midiInit)
