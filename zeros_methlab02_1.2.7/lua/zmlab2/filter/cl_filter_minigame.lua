if not CLIENT then return end
local MiniGameVGUI = {}

net.Receive("zmlab2_Filter_MiniGame", function(len)
    zclib.Debug_Net("zmlab2_Filter_MiniGame", len)
    LocalPlayer().zmlab2_Filter = net.ReadEntity()

    if IsValid(zmlab2_Filter_MiniGame_panel) then
        zmlab2_Filter_MiniGame_panel:Remove()
    end

    zmlab2_Filter_MiniGame_panel = vgui.Create("zmlab2_vgui_Filter_MiniGame")
end)

function MiniGameVGUI:Init()
    self:SetSize(600 * zclib.wM, 300 * zclib.hM)
    self:Center()
    self:MakePopup()
    self:ShowCloseButton(false)
    self:SetTitle("")
    self:SetDraggable(true)
    self:SetSizable(false)
    self:DockPadding(0, 0, 0, 0)

    self.GamePhase = 0
    /*
        0 = Wait
        1 = PreviewSequence
        2 = Player repeats the sequence
    */
    self.StartTime = CurTime()
    self.PlayMusic = true
    self.ActiveSequenceID = 1

    // Generate the button sequence
    self.Sequence_Length = 4
    if IsValid(LocalPlayer().zmlab2_Filter) and LocalPlayer().zmlab2_Filter:GetClass() == "zmlab2_machine_filter" then
        local difficulty = zmlab2.Meth.GetDifficulty(LocalPlayer().zmlab2_Filter:GetMethType())
        local extraCount = (3 / 10) * difficulty
        self.Sequence_Length = 2 + math.Round(extraCount)
    end
    self.ButtonSequence = {}
    for i = 1, self.Sequence_Length do table.insert(self.ButtonSequence, math.random(1, 3)) end

    // Lets create the buttons
    self.ActionButtons = {}
    local ButtonCount = 3
    local size = 580 / 3
    local BtnContainer = vgui.Create("DPanel", self)
    BtnContainer:Dock(FILL)
    BtnContainer:DockMargin(10 * zclib.wM,120 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    BtnContainer.Paint = function(s, w, h) end
    self.BtnContainer = BtnContainer
    local function AddButton(id,color)
        local btn = vgui.Create("DButton", BtnContainer)
        btn:SetAutoDelete(true)
        btn:SetSize(size * zclib.wM, size * zclib.hM)
        btn:SetText("")
        btn.Paint = function(s, w, h)
            //draw.RoundedBox(0, 0, 0, w, h, color)

            surface.SetDrawColor(color)
            surface.SetMaterial(zclib.Materials.Get("item_bg"))
            surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w, h)

            if btn.Preview then
                local Pulse = 1 - math.Clamp((1 / 0.5) * (btn.Preview - CurTime()),0,1)
                surface.SetDrawColor(255,255,255,255 * (1-Pulse))
                surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
                surface.DrawTexturedRectRotated(w / 2, h / 2, w * Pulse, h * Pulse, 0)
                zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 6, zmlab2.colors["orange01"])

                if btn.Preview - CurTime() <= 0 then
                    btn.Preview = nil
                end
            else
                zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 6, color_white)
                if self.GamePhase < 2 then
                    draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a200"])
                else
                    if s:IsHovered() then
                        draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
                    end
                end
            end
        end
        btn.DoClick = function(s)
            if self.GamePhase < 2 then return end
            self:OnButtonPress(s.ButtonID)
        end

        if id == 1 then
            btn:Dock(LEFT)
        elseif id == 2 then
            btn:Dock(FILL)
            btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
        else
            btn:Dock(RIGHT)
        end

        btn.ButtonID = id
        self.ActionButtons[id] = btn
    end
    for i = 1, ButtonCount do AddButton(i, HSVToColor((360 / ButtonCount) * i, 1, 1)) end

    timer.Simple(3,function()
        if not IsValid(self) then return end
        self:PreviewSequence()
    end)
end

// Shows the player which button to press and in which order
function MiniGameVGUI:PreviewSequence()
    self.GamePhase = 1
    local timerid = "zmlab2_Filter_MiniGame_PreviewSequence_Timer"
    zclib.Timer.Remove(timerid)

    local PreviewID = 1
    zclib.Timer.Create(timerid,1,0,function()
        if PreviewID > table.Count(self.ButtonSequence) then
            zclib.Timer.Remove(timerid)
            self:StartGame()
        end

        local NextButtonID = self.ButtonSequence[PreviewID]
        if IsValid(self.ActionButtons[NextButtonID]) then
            self:PlayButtonSound(NextButtonID)
        end

        PreviewID = PreviewID + 1
    end)
end

function MiniGameVGUI:StartGame()
    self.GamePhase = 2
end

function MiniGameVGUI:PlayButtonSound(ButtonID)
    self.ActionButtons[ButtonID].Preview = CurTime() + 0.5
    if ButtonID == 1 then
        surface.PlaySound("zmlab2/minigame_filter_button01.wav")
    elseif ButtonID == 2 then
        surface.PlaySound("zmlab2/minigame_filter_button02.wav")
    elseif ButtonID == 3 then
        surface.PlaySound("zmlab2/minigame_filter_button03.wav")
    end
end

function MiniGameVGUI:OnButtonPress(ButtonID)
    local WantedID = self.ButtonSequence[self.ActiveSequenceID]

    self:PlayButtonSound(ButtonID)

    if WantedID == ButtonID then

        // Next!
        self.ActiveSequenceID = self.ActiveSequenceID + 1

        if self.ActiveSequenceID > table.Count(self.ButtonSequence) then
            // We are done here, you won!
            self:OnGameWon()
        end
    else
        // Abort, You failed!
        self:OnGameFailed()
    end
end

function MiniGameVGUI:OnGameWon()
    self:EndGame(true)
end

function MiniGameVGUI:OnGameFailed()
    self:EndGame(false)
end

function MiniGameVGUI:EndGame(result)
    self.GamePhase = 3
    if IsValid(self.BtnContainer) then
        self.BtnContainer:Remove()
    end

    if result then
        surface.PlaySound("zmlab2/minigame_won.wav")
    else
        surface.PlaySound("zmlab2/minigame_lost.wav")
    end

    local MainContainer = vgui.Create("DPanel", self)
    MainContainer:SetAlpha(0)
    MainContainer:Dock(FILL)
    MainContainer.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a200"])

        if result then
            draw.SimpleText("Won", zclib.GetFont("zclib_font_large"), w / 2, h / 2, zmlab2.colors["green03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Lost", zclib.GetFont("zclib_font_large"), w / 2, h / 2, zmlab2.colors["red02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    MainContainer:AlphaTo(255, 0.25, 0, function()
        timer.Simple(1, function()
            if not IsValid(self) then return end

            net.Start("zmlab2_Filter_MiniGame")
            net.WriteEntity(LocalPlayer().zmlab2_Filter)
            net.WriteBool(result)
            net.SendToServer()

            self:Close()
        end)
    end)

end



function MiniGameVGUI:Paint(w, h)
    surface.SetDrawColor(zmlab2.colors["blue02"])
    surface.SetMaterial(zclib.Materials.Get("item_bg"))
    surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w, h)

    local CountDown = math.Clamp((self.StartTime + 3) - CurTime(),0,3)
    if CountDown <= 0 then
        if self.GamePhase == 1 then
            draw.SimpleText("Remember!", zclib.GetFont("zclib_font_big"), w / 2, 60 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif self.GamePhase == 2 then
            draw.SimpleText("Repeat!", zclib.GetFont("zclib_font_big"), w / 2, 60 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    else
        draw.SimpleText(math.Round(CountDown), zclib.GetFont("zclib_font_big"), w / 2, 60 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
end

function MiniGameVGUI:Think()

    if self.GamePhase == 2 and input.IsKeyDown(KEY_ESCAPE) then
        self:Close()
    end

    if self.PlayMusic == true then
        if self.Sound == nil then
            self.Sound = CreateSound(LocalPlayer().zmlab2_Filter, "zmlab2_minigame_loop")
        else
            if self.Sound:IsPlaying() == false then
                self.Sound:Play()
                self.Sound:ChangeVolume(1, 1)
            end
        end
    else
        if self.Sound and self.Sound:IsPlaying() == true then
            self.Sound:Stop()
        end
    end
end

function MiniGameVGUI:Close()

    zclib.Timer.Remove("zmlab2_Filter_MiniGame_PreviewSequence_Timer")

    self.PlayMusic = false
    if self.Sound and self.Sound:IsPlaying() == true then self.Sound:Stop() end
    LocalPlayer().zmlab2_Filter = nil

    if IsValid(zmlab2_Filter_MiniGame_panel) then
        zmlab2_Filter_MiniGame_panel:Remove()
    end

    if self.Sound and self.Sound:IsPlaying() == true then
        self.Sound:Stop()
    end
end

vgui.Register("zmlab2_vgui_Filter_MiniGame", MiniGameVGUI, "DFrame")
