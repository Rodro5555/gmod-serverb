include("shared.lua")

ENT.DEBUG = false
ENT.VELOCITY_MAX = 127
ENT.NOTE_FADEOUT_TIME = 0.2
ENT.NOTE_PLAY_TIME_MAX = 1.87

ENT.KeysDown = {}
ENT.KeysWasDown = {}

ENT.AllowAdvancedMode = false
ENT.AdvancedMode = false
ENT.ShiftModeOld = false
ENT.ShiftMode = false

ENT.Sounds = {}
ENT.IsSoundPlaying = {}
ENT.IsSoundRequested = {}
ENT.PageTurnSound = Sound("generic/inventory/move_paper.wav")
surface.CreateFont("InstrumentKeyLabel", {
    size = 22, weight = 400, antialias = true, font = "Impact"
})
surface.CreateFont("InstrumentNotice", {
    size = 30, weight = 400, antialias = true, font = "Impact"
})

// For drawing purposes
// Override by adding MatWidth/MatHeight to key data
ENT.DefaultMatWidth = 128
ENT.DefaultMatHeight = 128
// Override by adding TextX/TextY to key data
ENT.DefaultTextX = 5
ENT.DefaultTextY = 10
ENT.DefaultTextColor = Color( 150, 150, 150, 255 )
ENT.DefaultTextColorActive = Color( 80, 80, 80, 255 )
ENT.DefaultTextInfoColor = Color( 120, 120, 120, 150 )

ENT.MaterialDir = ""
ENT.KeyMaterials = {}

ENT.MainHUD = {
    Material = nil,
    X = 0,
    Y = 0,
    TextureWidth = 128,
    TextureHeight = 128,
    Width = 128,
    Height = 128,
}

ENT.AdvMainHUD = {
    Material = nil,
    X = 0,
    Y = 0,
    TextureWidth = 128,
    TextureHeight = 128,
    Width = 128,
    Height = 128,
}

ENT.BrowserHUD = {
    URL = "http://www.gmtower.org/apps/instruments/piano.php",
    Show = true, // display the sheet music?
    X = 0,
    Y = 0,
    Width = 1024,
    Height = 768,
}

function ENT:InitSounds()
    if self.SoundNames then
        for semitone, soundName in pairs(self.SoundNames) do
            self.Sounds[semitone] = CreateSound(self, self:GetSoundPath(soundName))
            self.IsSoundRequested[semitone] = false
            self.IsSoundPlaying[semitone] = false
        end
    end
end

function ENT:GetSound(semitone)
    if not self.Sounds[semitone] then
        self.Sounds[semitone] = CreateSound(self, self:GetSoundPath(self.SoundNames[semitone]))
        self.IsSoundRequested[semitone] = false
        self.IsSoundPlaying[semitone] = false
    end
    return self.Sounds[semitone]
end

function ENT:PlayNoteSound(semitone, volume)
    local sound = self:GetSound(semitone)

    self.IsSoundRequested[semitone] = true
    if sound then
        if sound:IsPlaying() then
            sound:Stop()
        end
        self.IsSoundPlaying[semitone] = true
        sound:PlayEx(volume, 100)
        timer.Simple(self.NOTE_PLAY_TIME_MAX, function()
            if self and self.IsSoundPlaying then
                self.IsSoundPlaying[semitone] = false
            end
        end)
    end
end

function ENT:StopNoteSound(semitone)
    local sound = self:GetSound(semitone)

    self.IsSoundRequested[semitone] = false
    if sound then
        if self.IsSoundPlaying[semitone] then
            self.IsSoundPlaying[semitone] = false
            sound:ChangeVolume(0, self.NOTE_FADEOUT_TIME)
            timer.Simple(self.NOTE_FADEOUT_TIME, function()
                if not self.IsSoundRequested[semitone] then
                    sound:Stop()
                end
                sound = nil
            end)
        else
            sound:Stop()
        end
    end
end

function ENT:PlayNote(semitone, velocity)
    if velocity > 0 then
        self:PlayNoteSound(semitone, velocity / self.VELOCITY_MAX)
    else
        self:StopNoteSound(semitone)
    end
end

function ENT:RegisterNoteEvent(semitone, velocity)
    // Play on the client first
    self:PlayNote(semitone, velocity)

    // Network it
    net.Start("KeyboardInstrumentNetwork")
        net.WriteEntity(self)
        net.WriteInt(INSTNET_PLAY, 3)
        net.WriteUInt(semitone, 8)
        net.WriteUInt(velocity, 8)
    net.SendToServer()
end

function ENT:InitKeys()
    for key, keyData in pairs(self.ControlKeys) do
        self.KeysDown[key] = false
        self.KeysWasDown[key] = false
    end
    for key, keyData in pairs(self.AdvancedKeys) do
        self.KeysDown[key] = false
        self.KeysWasDown[key] = false
    end
end

function ENT:IsKeyTriggered(key)
    return self.KeysDown[key] and not self.KeysWasDown[key]
end

function ENT:IsKeyHeld(key)
    return self.KeysDown[key] and self.KeysWasDown[key]
end

function ENT:IsKeyReleased(key)
    return self.KeysWasDown[key] and not self.KeysDown[key]
end

function ENT:ProcessNoteKey(key, keyData, shift, pressed)
    local velocity = 0

    if pressed then
        velocity = self.VELOCITY_MAX
    end
    if shift then
        if keyData.Shift then
            semitone = keyData.Shift.Semitone
            self:RegisterNoteEvent(semitone, velocity)
        end
    else
        semitone = keyData.Semitone
        self:RegisterNoteEvent(semitone, velocity)
    end
end

function ENT:ProcessKeys()
    if self.DelayKey and (self.DelayKey > CurTime()) then return end
    local shiftMode = self.ShiftMode
    local shiftModeSwitched = shiftMode ~= self.ShiftModeOld

    // Update last pressed
    for key, keyData in pairs(self.KeysDown) do
        self.KeysWasDown[key] = self.KeysDown[key]
    end
    // Get keys
    for key, keyData in pairs(self.Keys) do
        // Update key status
        self.KeysDown[key] = input.IsKeyDown(key) and
                             not gui.IsGameUIVisible()
        // Check for note keys
        if self:IsKeyTriggered(key) then
            self:ProcessNoteKey(key, keyData, shiftMode, true)
        end
        if shiftModeSwitched then
            if self:IsKeyHeld(key) then
                self:ProcessNoteKey(key, keyData, not shiftMode, false)
                self:ProcessNoteKey(key, keyData, shiftMode, true)
            end
            if self:IsKeyReleased(key) then
                self:ProcessNoteKey(key, keyData, not shiftMode, false)
            end
        else
            if self:IsKeyReleased(key) then
                self:ProcessNoteKey(key, keyData, shiftMode, false)
            end
        end
    end
    if shiftModeSwitched and (shiftMode == self.ShiftMode) then
        self.ShiftModeOld = shiftMode
    end
    // Get control keys
    for key, keyData in pairs(self.ControlKeys) do
        // Update key status
        self.KeysDown[key] = input.IsKeyDown(key) and
                             not gui.IsGameUIVisible()
        // Check for control keys
        if self:IsKeyTriggered(key) then
            keyData(self, true)
        end
        // was a control key released?
        if self:IsKeyReleased(key) then
            keyData(self, false)
        end
    end
end

function ENT:DrawKey( mainX, mainY, key, keyData, bShiftMode )

    if keyData.Material then
        if ( self.ShiftMode && bShiftMode && input.IsKeyDown( key ) ) ||
           ( !self.ShiftMode && !bShiftMode && input.IsKeyDown( key ) ) then

            surface.SetTexture( self.KeyMaterialIDs[ keyData.Material ] )
            surface.DrawTexturedRect( mainX + keyData.X, mainY + keyData.Y, 
                                      self.DefaultMatWidth, self.DefaultMatHeight )
        end
        
    end

    // Draw keys
    if keyData.Label then

        local offsetX = self.DefaultTextX
        local offsetY = self.DefaultTextY
        local color = self.DefaultTextColor

        if ( self.ShiftMode && bShiftMode && input.IsKeyDown( key ) ) ||
           ( !self.ShiftMode && !bShiftMode && input.IsKeyDown( key ) ) then
           
            color = self.DefaultTextColorActive
            if keyData.AColor then color = keyData.AColor end
        else
            if keyData.Color then color = keyData.Color end
        end

        // Override positions, if needed
        if keyData.TextX then offsetX = keyData.TextX end
        if keyData.TextY then offsetY = keyData.TextY end
        
        draw.DrawText( keyData.Label, "InstrumentKeyLabel", 
                        mainX + keyData.X + offsetX,
                        mainY + keyData.Y + offsetY,
                        color, TEXT_ALIGN_CENTER )
    end
end

function ENT:DrawHUD()

    surface.SetDrawColor( 255, 255, 255, 255 )

    local mainX, mainY, mainWidth, mainHeight

    // Draw main
    if self.MainHUD.Material && !self.AdvancedMode then

        mainX, mainY, mainWidth, mainHeight = self.MainHUD.X, self.MainHUD.Y, self.MainHUD.Width, self.MainHUD.Height

        surface.SetTexture( self.MainHUD.MatID )
        surface.DrawTexturedRect( mainX, mainY, self.MainHUD.TextureWidth, self.MainHUD.TextureHeight )

    end

    // Advanced main
    if self.AdvMainHUD.Material && self.AdvancedMode then

        mainX, mainY, mainWidth, mainHeight = self.AdvMainHUD.X, self.AdvMainHUD.Y, self.AdvMainHUD.Width, self.AdvMainHUD.Height

        surface.SetTexture( self.AdvMainHUD.MatID )
        surface.DrawTexturedRect( mainX, mainY, self.AdvMainHUD.TextureWidth, self.AdvMainHUD.TextureHeight )

    end

    // Draw keys (over top of main)
    for key, keyData in pairs( self.Keys ) do
    
        self:DrawKey( mainX, mainY, key, keyData, false )
        
        if keyData.Shift then
            self:DrawKey( mainX, mainY, key, keyData.Shift, true )
        end
    end

    // Sheet music help
    if !ValidPanel( self.Browser ) && self.BrowserHUD.Show then

        draw.DrawText( "ESPACIO PARA PARTITURAS", "InstrumentKeyLabel", 
                        mainX + ( mainWidth / 2 ), mainY + 60, 
                        self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )

    end

    // Advanced mode
    if self.AllowAdvancedMode && !self.AdvancedMode then

        draw.DrawText( "CONTROL PARA MODO AVANZADO", "InstrumentKeyLabel", 
                        mainX + ( mainWidth / 2 ), mainY + mainHeight + 30, 
                        self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )
                        
    elseif self.AllowAdvancedMode && self.AdvancedMode then
    
        draw.DrawText( "CONTROL PARA MODO BÁSICO", "InstrumentKeyLabel", 
                        mainX + ( mainWidth / 2 ), mainY + mainHeight + 30, 
                        self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )
    end

end

// This is so I don't have to do GetTextureID in the table EACH TIME, ugh
function ENT:PrecacheMaterials()

    if !self.Keys then return end

    self.KeyMaterialIDs = {}

    for name, keyMaterial in pairs( self.KeyMaterials ) do
        if type( keyMaterial ) == "string" then // TODO: what the fuck, this table is randomly created
            self.KeyMaterialIDs[name] = surface.GetTextureID( keyMaterial )
        end
    end

    if self.MainHUD.Material then
        self.MainHUD.MatID = surface.GetTextureID( self.MainHUD.Material )
    end

    if self.AdvMainHUD.Material then
        self.AdvMainHUD.MatID = surface.GetTextureID( self.AdvMainHUD.Material )
    end

end

function ENT:OpenSheetMusic()

    if ValidPanel( self.Browser ) || !self.BrowserHUD.Show then return end

    self.Browser = vgui.Create( "HTML" )
    self.Browser:SetVisible( false )

    local width = self.BrowserHUD.Width

    if self.BrowserHUD.AdvWidth && self.AdvancedMode then
        width = self.BrowserHUD.AdvWidth
    end

    local url = self.BrowserHUD.URL
    
    if self.AdvancedMode then
        url = self.BrowserHUD.URL .. "?&adv=1"
    end
    
    local x = self.BrowserHUD.X - ( width / 2 )

    self.Browser:OpenURL( url )

    // This is delayed because otherwise it won't load at all
    // for some silly reason...
    timer.Simple( .1, function()

        if ValidPanel( self.Browser ) then
            self.Browser:SetVisible( true )
            self.Browser:SetPos( x, self.BrowserHUD.Y )
            self.Browser:SetSize( width, self.BrowserHUD.Height )
        end

    end )

end

function ENT:CloseSheetMusic()

    if !ValidPanel( self.Browser ) then return end

    self.Browser:Remove()
    self.Browser = nil

end

function ENT:ToggleSheetMusic()

    if ValidPanel( self.Browser ) then
        self:CloseSheetMusic()
    else
        self:OpenSheetMusic()
    end

end

function ENT:SheetMusicForward()

    if !ValidPanel( self.Browser ) then return end

    self.Browser:Exec( "pageForward()" )
    self:EmitSound( self.PageTurnSound, 100, math.random( 120, 150 ) )

end

function ENT:SheetMusicBack()

    if !ValidPanel( self.Browser ) then return end

    self.Browser:Exec( "pageBack()" )
    self:EmitSound( self.PageTurnSound, 100, math.random( 100, 120 ) )

end

function ENT:ToggleAdvancedMode()
    self.AdvancedMode = not self.AdvancedMode
    if ValidPanel(self.Browser) then
        self:CloseSheetMusic()
        self:OpenSheetMusic()
    end
end

function ENT:ToggleShiftMode()
    self.ShiftModeOld = self.ShiftMode
    self.ShiftMode = not self.ShiftMode
end

function ENT:Initialize()
    self:PrecacheMaterials()
    self:InitSounds()
    self:InitKeys()
end

function ENT:Think()
    if IsValid(LocalPlayer().Instrument) and (LocalPlayer().Instrument == self) then
        if not LocalPlayer():Alive() then
            RunConsoleCommand("instrument_leave", LocalPlayer().Instrument:EntIndex())
            LocalPlayer().Instrument = nil
        else
            self:ProcessKeys()
        end
    end
end

function ENT:OnRemove()
    self:CloseSheetMusic()
end

function ENT:Shutdown()
    self:CloseSheetMusic()
    self.AdvancedMode = false
    self.ShiftMode = false
    if self.OldKeys then
        self.Keys = self.OldKeys
        self.OldKeys = nil
    end
end

function ENT:ShiftMod() end // Called when they press shift
function ENT:CtrlMod() end // Called when they press cntrl

hook.Add( "HUDPaint", "InstrumentPaint", function()
    if IsValid(LocalPlayer().Instrument) then
        // HUD
        local inst = LocalPlayer().Instrument
        inst:DrawHUD()
        // Notice bar
        local name = inst.PrintName or "INSTRUMENTO"
        name = string.upper(name)
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, ScrH() - 60, ScrW(), 60)
        draw.SimpleText("PULSA TAB PARA SALIR DEL " .. name, "InstrumentNotice", ScrW() / 2, ScrH() - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1)
    end
end)

// Override regular keys
hook.Add("PlayerBindPress", "InstrumentHook", function(ply, bind, pressed)
    if IsValid(ply.Instrument) then
        return true
    end
end)

net.Receive("KeyboardInstrumentNetwork", function(length, client)
    local ent = net.ReadEntity()
    local cmd = net.ReadInt(3)

    // When the player uses it or leaves it
    if cmd == INSTNET_USE then
        if IsValid(LocalPlayer().Instrument) then
            LocalPlayer().Instrument:Shutdown()
        end
        if IsValid(ent) then
            ent.DelayKey = CurTime() + .1 // delay to the key a bit so they don't play on use key
        end
        LocalPlayer().Instrument = ent
    // Play the notes for everyone else
    elseif cmd == INSTNET_HEAR then
        if IsValid(ent) then
            // Don't play for the owner, they've already heard it!
            if not IsValid(LocalPlayer().Instrument) or (LocalPlayer().Instrument ~= ent) then
                // Gather note
                local semitone = net.ReadUInt(8)
                local velocity = net.ReadUInt(8)
                ent:PlayNote(semitone, velocity)
            end
        end
    end
end)