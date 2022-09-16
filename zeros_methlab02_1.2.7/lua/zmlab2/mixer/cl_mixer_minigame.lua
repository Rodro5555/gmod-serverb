if not CLIENT then return end
local MiniGameVGUI = {}

net.Receive("zmlab2_Mixer_MiniGame", function(len)
    zclib.Debug_Net("zmlab2_Mixer_MiniGame", len)
    LocalPlayer().zmlab2_Mixer = net.ReadEntity()

    if IsValid(zmlab2_Mixer_MiniGame_panel) then
        zmlab2_Mixer_MiniGame_panel:Remove()
    end

    zmlab2_Mixer_MiniGame_panel = vgui.Create("zmlab2_vgui_Mixer_MiniGame")
end)

function MiniGameVGUI:Init()
    self:SetSize(600 * zclib.wM, 750 * zclib.hM)
    self:Center()
    self:MakePopup()
    self:ShowCloseButton(false)
    self:SetTitle("")
    self:SetDraggable(true)
    self:SetSizable(false)
    self:DockPadding(0, 0, 0, 0)

    // The allowed deviation from the center point
    self.ErrorMargin = 0.1

    // The default distance to the goal
    self.DistanceToGoal = 0.25

    if IsValid(LocalPlayer().zmlab2_Mixer) and LocalPlayer().zmlab2_Mixer:GetClass() == "zmlab2_machine_mixer" then
        local difficulty = zmlab2.Meth.GetDifficulty(LocalPlayer().zmlab2_Mixer:GetMethType())

        local DiffChange = (1 / 10) * (10 - difficulty)

        self.ErrorMargin = self.ErrorMargin + (0.2 * DiffChange)

        self.DistanceToGoal = self.DistanceToGoal - (0.25 * DiffChange)
    end

    self.StartTime = CurTime()
    self.PosX = 0
    self.PosY = 0
    self.IsFalling = false
    self.IsAnimating = false
    self.FallValue = 0
    self.PlayMusic = true
end

function MiniGameVGUI:Paint(w, h)
    surface.SetDrawColor(zmlab2.colors["blue02"])
    surface.SetMaterial(zclib.Materials.Get("item_bg"))
    surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w, h)
    local size = h * 1.2
    local newX = (w * 0.5) + (w * 0.4) * self.PosX

    if self.IsFalling or self.IsAnimating then
        self.PosY = (-size * self.DistanceToGoal) + ((size * (0.325 + self.DistanceToGoal)) * self.FallValue)
    else
        self.PosY = -size * self.DistanceToGoal
    end

    surface.SetDrawColor(color_white)
    surface.SetMaterial(zclib.Materials.Get("long_pipe"))
    surface.DrawTexturedRectRotated(newX, self.PosY, size, size, 0)

    if self.IsAnimating == false then
        surface.SetDrawColor(color_white)
        local rot = 15 * math.sin(CurTime() * 6)
        rot = zclib.util.SnapValue(15, rot)

        if rot == 15 then
            surface.SetMaterial(zclib.Materials.Get("pipe_smoke02"))
        elseif rot == 0 then
            surface.SetMaterial(zclib.Materials.Get("pipe_smoke01"))
        elseif rot == -15 then
            surface.SetMaterial(zclib.Materials.Get("pipe_smoke03"))
        end

        surface.DrawTexturedRectRotated(w / 2, h - 110 * zclib.hM, 220 * zclib.wM, 220 * zclib.hM, 0)
    end

    if self.IsAnimating == false and self.IsFalling == false then
        draw.SimpleText(zmlab2.language["SPACE"], zclib.GetFont("zclib_font_big"), w / 2, h * 0.75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local barSize = w * self.ErrorMargin
        if math.abs(self.PosX) < self.ErrorMargin then
            draw.RoundedBox(5, w / 2 - barSize / 2, h - 165 * zclib.hM, barSize, 10 * zclib.hM, color_white)
        else
            draw.RoundedBox(5, w / 2 - barSize / 2, h - 165 * zclib.hM, barSize, 10 * zclib.hM, zclib.colors["black_a200"])
        end
    else
        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get("pipe_connect"))
        surface.DrawTexturedRectRotated(w / 2, h - 110 * zclib.hM, 220 * zclib.wM, 220 * zclib.hM, 0)
    end

    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
end

function MiniGameVGUI:ShowResult(WeWon)
    self.IsAnimating = true

    // Snap to center so it fits better
    if WeWon then
        self.PosX = 0
    end

    if WeWon then
        surface.PlaySound("zmlab2/minigame_won.wav")
    else
        surface.PlaySound("zmlab2/minigame_lost.wav")
    end

    local MainContainer = vgui.Create("DPanel", self)
    MainContainer:SetAlpha(0)
    MainContainer:Dock(FILL)

    MainContainer.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a200"])

        if WeWon then
            draw.SimpleText(zmlab2.language["Connected"], zclib.GetFont("zclib_font_large"), w / 2, h / 2, zmlab2.colors["green03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(zmlab2.language["Missed"], zclib.GetFont("zclib_font_large"), w / 2, h / 2, zmlab2.colors["red02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    MainContainer:AlphaTo(255, 0.25, 0, function()
        timer.Simple(1, function()
            if not IsValid(self) then return end

            net.Start("zmlab2_Mixer_MiniGame")
            net.WriteEntity(LocalPlayer().zmlab2_Mixer)
            net.WriteBool(WeWon)
            net.SendToServer()

            self:Close()
        end)
    end)
end

function MiniGameVGUI:Think()

    if self.IsFalling == false and self.IsAnimating == false and input.IsKeyDown(KEY_ESCAPE) then
        self:Close()
    end

    if self.PlayMusic == true then
        if self.Sound == nil then
			if not IsValid(LocalPlayer().zmlab2_Mixer) then return end
            self.Sound = CreateSound(LocalPlayer().zmlab2_Mixer, "zmlab2_minigame_loop")
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

    if self.IsAnimating == true then return end

    if self.IsFalling then
        local passed = CurTime() - self.StartTime
        self.FallValue = math.Clamp((1 / 0.5) * passed, 0, 1)
        self.FallValue = math.EaseInOut(self.FallValue, 1, 0)

        // If we reached the endpipe lets check if the value was correct
        if self.FallValue >= 1 then
            self.IsFalling = false

            if math.abs(self.PosX) < self.ErrorMargin then
                // We won!
                self:ShowResult(true)
            else
                // We missed!
                self:ShowResult(false)
            end
        end
    else
        self.PosX = math.sin(CurTime() * 2)
    end

    if self.IsAnimating == false and input.IsKeyDown(KEY_SPACE) then
        self.StartTime = CurTime()
        self.IsFalling = true
        surface.PlaySound("zmlab2/minigame_hit.wav")
        self.PlayMusic = false
    end
end

// Close the editor
function MiniGameVGUI:Close()

    self.PlayMusic = false
    if self.Sound and self.Sound:IsPlaying() == true then self.Sound:Stop() end
    LocalPlayer().zmlab2_Mixer = nil

    if IsValid(zmlab2_Mixer_MiniGame_panel) then
        zmlab2_Mixer_MiniGame_panel:Remove()
    end

    if self.Sound and self.Sound:IsPlaying() == true then
        self.Sound:Stop()
    end
end

vgui.Register("zmlab2_vgui_Mixer_MiniGame", MiniGameVGUI, "DFrame")
