if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.MiniGame = zmlab2.MiniGame or {}

///////////////////////////////////////////
///////////////////////////////////////////
local MiniGameVGUI = {}

local function OpenInterface()

    if IsValid(zmlab2_MiniGame_main_panel) then
        zmlab2_MiniGame_main_panel:Remove()
    end

    zmlab2_MiniGame_main_panel = vgui.Create("zmlab2_vgui_MiniGame")
end

net.Receive("zmlab2_MiniGame", function(len)
    zclib.Debug_Net("zmlab2_MiniGame",len)

    LocalPlayer().zmlab2_MiniGame_Ent = net.ReadEntity()
    LocalPlayer().zmlab2_MiniGame_Time = net.ReadUInt(16)

    // Open Main interface
    OpenInterface()
end)

function MiniGameVGUI:Init()
    self:SetSize(600 * zclib.wM, 200 * zclib.hM)
    self:Center()
    self:SetPos((ScrW() / 2) - 300 * zclib.wM,(ScrH() / 2) + 150 * zclib.wM)
    self:MakePopup()
    self:ShowCloseButton(false)
    self:SetTitle("")
    self:SetDraggable(true)
    self:SetSizable(false)

    self:DockMargin(0, 0, 0, 0)
    self:DockPadding( 10 * zclib.wM,10 * zclib.wM,10 * zclib.wM,10 * zclib.wM)

    self.PlayMusic = true

    local difficulty = 1
    if LocalPlayer().zmlab2_MiniGame_Ent.GetMethType then
        local dat = zmlab2.config.MethTypes[LocalPlayer().zmlab2_MiniGame_Ent:GetMethType()]
        difficulty = dat.difficulty
    end


    // At which part of the bar is the safe area
    local safe_pos = (1 / 10) * LocalPlayer().zmlab2_MiniGame_Time

    // The size of the safe area
    local safe_size = 1 - ((1 / 10) * difficulty)

    // The time in seconds
    local game_time = 1.5


    local safe_start = game_time * safe_pos
    local safe_mul = 0.05 + (0.1 * safe_size)
    local safe_end = safe_start + (game_time * safe_mul)

    local MainContainer = vgui.Create("DPanel", self)
    MainContainer:Dock(FILL)
    MainContainer:DockMargin(5,50,5,5)
    MainContainer.Paint = function(s, w, h)

        // The Size of the whole bar
        local max_length = w-10

        // The Size of the safe area, its 10% of the whole bar
        local safe_length = max_length * safe_mul

        local diff = CurTime() - MainContainer.CreationTime
        local pointer_pos = (max_length / game_time) * diff
        pointer_pos = math.Clamp(pointer_pos, 0, max_length)

        local CanWin = false
        if diff >= safe_start and diff < safe_end then
            CanWin = true
        end

        draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])

        draw.RoundedBox(0, 5, 5, w-10, h-10, zmlab2.colors["red02"])

        draw.RoundedBox(0, (max_length / game_time) * safe_start, 5 , safe_length, h - 10, zmlab2.colors["green03"])

        if CanWin then draw.RoundedBox(0, (max_length / game_time) * safe_start, 5, safe_length, h - 10, zmlab2.colors["white02"]) end

        draw.RoundedBox(0, 3 + pointer_pos, 5,6, h - 10, color_black)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get("errorgame_overlay"))
        surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w,h)
    end
    MainContainer.CreationTime = CurTime()
    MainContainer.DidAction = false
    MainContainer.Think = function(s)

        if MainContainer.DidAction == false then

            // Safe area is 10%
            local f_WinArea = game_time * safe_mul

            local f_WinTime = game_time * safe_pos

            local f_CurTime = CurTime() - MainContainer.CreationTime

            // Did we win?
            local result = false
            if f_CurTime >= f_WinTime and f_CurTime < (f_WinTime + f_WinArea) then
                result = true
            end

            if input.IsKeyDown(KEY_SPACE) == true or f_CurTime > game_time then

                MainContainer.DidAction = true

                net.Start("zmlab2_MiniGame")
                net.WriteEntity(LocalPlayer().zmlab2_MiniGame_Ent)
                net.WriteBool(result)
                net.SendToServer()

                self:Close()
            end
        end

        if self.PlayMusic == true then
            if self.Sound == nil then
                self.Sound = CreateSound(LocalPlayer().zmlab2_MiniGame_Ent, "zmlab2_errorgame_loop")
            else
                if self.Sound:IsPlaying() == false then
                    self.Sound:Play()
                    self.Sound:ChangeVolume(1, 1)
                end
            end
        end
    end
end

function MiniGameVGUI:Paint(w, h)
    surface.SetDrawColor(zmlab2.colors["blue02"])
    surface.SetMaterial(zclib.Materials.Get("item_bg"))
    surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w,h)

    draw.SimpleText(zmlab2.language["SPACE"], zclib.GetFont("zclib_font_big"), w / 2 , 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
end

// Close the editor
function MiniGameVGUI:Close()

    self.PlayMusic = false
    if self.Sound and self.Sound:IsPlaying() == true then
        self.Sound:Stop()
    end
    LocalPlayer().zmlab2_MiniGame_Ent = nil

    if IsValid(zmlab2_MiniGame_main_panel) then
        zmlab2_MiniGame_main_panel:Remove()
    end
end

vgui.Register("zmlab2_vgui_MiniGame", MiniGameVGUI, "DFrame")
