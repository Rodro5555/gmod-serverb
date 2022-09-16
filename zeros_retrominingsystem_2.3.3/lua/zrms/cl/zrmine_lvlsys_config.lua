if not CLIENT then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080
local zrmine_ConfigMenu = {}
local zrmine_ConfigMain = {}

net.Receive("zrmine_LvlSysData_open_net", function(len)
    zrmine.f.OpenUI()
end)

function zrmine.f.OpenUI()
    if IsValid(zrmine_ConfigMenu_panel) then
        zrmine_ConfigMenu_panel:Remove()
    end

    zrmine_ConfigMenu_panel = vgui.Create("zrmine_vgui_ConfigMenu")
end

function zrmine.f.CloseUI()
    if IsValid(zrmine_ConfigMenu_panel) then
        zrmine_ConfigMenu_panel:Remove()
    end
end

function zrmine_ConfigMenu:Init()
    self:SetSize(400 * wMod, 600 * hMod)
    self:Center()
    self:MakePopup()
    self:SetSizable(false)
    self:SetTitle("")
    self:ShowCloseButton(false)

    zrmine_ConfigMain.Title = vgui.Create("DLabel", self)
    zrmine_ConfigMain.Title:SetPos(12 * wMod, 7 * hMod)
    zrmine_ConfigMain.Title:SetSize(400 * wMod, 40 * hMod)
    zrmine_ConfigMain.Title:SetFont("zrmine_vgui_font01")
    zrmine_ConfigMain.Title:SetText("LevelSystem - PlayerData")
    zrmine_ConfigMain.Title:SetColor(zrmine.default_colors["white02"])
    zrmine_ConfigMain.Title:SetWrap(true)

    zrmine_ConfigMain.close = vgui.Create("DButton", self)
    zrmine_ConfigMain.close:SetText("")
    zrmine_ConfigMain.close:SetPos(355 * wMod, 5 * hMod)
    zrmine_ConfigMain.close:SetSize(40 * wMod, 40 * hMod)
    zrmine_ConfigMain.close.DoClick = function()
        zrmine.f.CloseUI()
    end
    zrmine_ConfigMain.close.Paint = function(s, w, h)
        if zrmine_ConfigMain.close:IsHovered() then
            surface.SetDrawColor(255, 160, 160, 255)
        else
            surface.SetDrawColor(255, 125, 125, 255)
        end

        surface.DrawRect( 0, 0, w, h )
        //surface.SetMaterial(Button02Icon)
        //surface.DrawTexturedRect(0, 0, w, h)


        local text = "X"
        local tw, th = surface.GetTextSize(text)
        surface.SetFont("zrmine_vgui_font02")
        surface.SetTextPos(15 * wMod - (tw / 2), 10 * hMod - (th / 2))
        surface.SetTextColor(255, 255, 255, 255)
        surface.DrawText(text)
    end

    zrmine_PlayerList(self)
end

function zrmine_ConfigMenu:Paint(w, h)
    surface.SetDrawColor(70, 70, 70, 255)
    //surface.SetMaterial(squareIcon)
    //surface.DrawTexturedRect(0, 0, w, h)
    surface.DrawRect( 0, 0, w, h )
end

function zrmine_PlayerList(parent)
    if zrmine_ConfigMain and IsValid(zrmine_ConfigMain.PlayerDataListPanel) then
        zrmine_ConfigMain.PlayerDataListPanel:Remove()
    end

    zrmine_ConfigMain.PlayerDataListPanel = vgui.Create("DPanel", parent)
    zrmine_ConfigMain.PlayerDataListPanel:SetPos(0 * wMod, 50 * hMod)
    zrmine_ConfigMain.PlayerDataListPanel:SetSize(400 * wMod, 550 * hMod)
    zrmine_ConfigMain.PlayerDataListPanel:SetBackgroundColor(Color(0, 0, 0, 0))

    zrmine_PlayerData_Items = {}
    zrmine_PlayerData_Items.panel = vgui.Create("DScrollPanel", zrmine_ConfigMain.PlayerDataListPanel)
    zrmine_PlayerData_Items.panel:DockMargin(0 * wMod, 0 * hMod, 0 * wMod, 0 * hMod)
    zrmine_PlayerData_Items.panel:Dock(FILL)
    zrmine_PlayerData_Items.panel.Paint = function(self, w, h)
        surface.SetDrawColor(0, 0, 0, 125)
        surface.DrawRect( 0, 0, w, h )
    end

    local abar = zrmine_PlayerData_Items.panel:GetVBar()

    function abar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    function abar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
    end

    function abar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
    end

    function abar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200))
    end

    zrmine_PlayerData_Items.list = vgui.Create("DIconLayout", zrmine_PlayerData_Items.panel)
    zrmine_PlayerData_Items.list:SetSize(360 * wMod, 550 * hMod)
    zrmine_PlayerData_Items.list:SetPos(10 * wMod, 10 * hMod)
    zrmine_PlayerData_Items.list:SetSpaceY(10)

    local players = player.GetAll()
    for i = 1, table.Count(players) do

        zrmine_PlayerData_Items[i] = zrmine_PlayerData_Items.list:Add("DFrame")
        zrmine_PlayerData_Items[i]:SetSizable(false)
        zrmine_PlayerData_Items[i]:SetTitle("")
        zrmine_PlayerData_Items[i]:ShowCloseButton(false)
        zrmine_PlayerData_Items[i]:SetDraggable(false)
        zrmine_PlayerData_Items[i]:SetSize(zrmine_PlayerData_Items.list:GetWide(), 45 * hMod)
        zrmine_PlayerData_Items[i].Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60,0))
        end



        zrmine_PlayerData_Items[i].button = vgui.Create("DButton", zrmine_PlayerData_Items[i])
        zrmine_PlayerData_Items[i].button:SetPos(0 * wMod, 0 * hMod)
        zrmine_PlayerData_Items[i].button:SetSize(zrmine_PlayerData_Items[i]:GetWide(), zrmine_PlayerData_Items[i]:GetWide())
        zrmine_PlayerData_Items[i].button:SetText("")
        zrmine_PlayerData_Items[i].button.Paint = function(self, w, h)
            local dColor =  Color(60, 60, 60)
            if zrmine_PlayerData_Items[i].button:IsHovered() then
                dColor =  Color(75, 75, 75)
            end

            draw.RoundedBox(0, 0, 0, w, h, dColor)
        end

        zrmine_PlayerData_Items[i].button.DoClick = function()
            net.Start("zrmine_LvlSysData_request_net")
            net.WriteString(players[i]:SteamID())
    		net.SendToServer()

            if zrmine_ConfigMain and IsValid(zrmine_ConfigMain.PlayerDataListPanel) then
                zrmine_ConfigMain.PlayerDataListPanel:Remove()
            end

            surface.PlaySound("common/wpn_select.wav")
        end


        zrmine_PlayerData_Items[i].label = vgui.Create("DLabel", zrmine_PlayerData_Items[i])
        zrmine_PlayerData_Items[i].label:SetPos(15 * wMod, 0 * hMod)
        zrmine_PlayerData_Items[i].label:SetSize(400 * wMod, 50 * hMod)
        zrmine_PlayerData_Items[i].label:SetFont("zrmine_vgui_font03")
        zrmine_PlayerData_Items[i].label:SetText(players[i]:Nick())
        zrmine_PlayerData_Items[i].label:SetColor(zrmine.default_colors["white02"])
        zrmine_PlayerData_Items[i].label:SetWrap(true)
    end
end


net.Receive("zrmine_LvlSysData_send_net", function(len)
    local dataLength = net.ReadUInt(16)
    local boardDecompressed = util.Decompress(net.ReadData(dataLength))
    local data = util.JSONToTable(boardDecompressed)

    if IsValid(zrmine_ConfigMenu_panel) then
        zrmine.f.PlayerData(zrmine_ConfigMenu_panel, data)
    end
end)

function zrmine.f.PlayerData(parent, plyData)
    if zrmine_ConfigMain and IsValid(zrmine_ConfigMain.PlayerDataPanel) then
        zrmine_ConfigMain.PlayerDataPanel:Remove()
    end

    zrmine_ConfigMain.PlayerDataPanel = vgui.Create("DPanel", parent)
    zrmine_ConfigMain.PlayerDataPanel:SetPos(0 * wMod, 50 * hMod)
    zrmine_ConfigMain.PlayerDataPanel:SetSize(600 * wMod, 550 * hMod)
    zrmine_ConfigMain.PlayerDataPanel:SetBackgroundColor(Color(0, 0, 0, 125))
    //zrmine_ConfigMain.PlayerDataPanel:MakePopup()

    // 206725927
    local _ply = player.GetBySteamID(plyData.id)

    zrmine_ConfigMain.ply_name = vgui.Create("DLabel", zrmine_ConfigMain.PlayerDataPanel)
    zrmine_ConfigMain.ply_name:SetPos(15 * wMod, 0 * hMod)
    zrmine_ConfigMain.ply_name:SetSize(400 * wMod, 50 * hMod)
    zrmine_ConfigMain.ply_name:SetFont("zrmine_vgui_font03")
    zrmine_ConfigMain.ply_name:SetText("Name: " .. _ply:Nick())
    zrmine_ConfigMain.ply_name:SetColor(zrmine.default_colors["white02"])
    zrmine_ConfigMain.ply_name:SetWrap(true)

    zrmine_ConfigMain.ply_lvl = vgui.Create("DLabel", zrmine_ConfigMain.PlayerDataPanel)
    zrmine_ConfigMain.ply_lvl:SetPos(15 * wMod, 40 * hMod)
    zrmine_ConfigMain.ply_lvl:SetSize(300 * wMod, 50 * hMod)
    zrmine_ConfigMain.ply_lvl:SetFont("zrmine_vgui_font03")
    zrmine_ConfigMain.ply_lvl:SetText("Pickaxe Level: ")
    zrmine_ConfigMain.ply_lvl:SetColor(zrmine.default_colors["white02"])
    zrmine_ConfigMain.ply_lvl:SetWrap(true)

    zrmine_ConfigMain.ply_lvl_TextField = vgui.Create("DTextEntry",  zrmine_ConfigMain.PlayerDataPanel)
    zrmine_ConfigMain.ply_lvl_TextField:SetPos(290 * wMod, 50 * hMod)
    zrmine_ConfigMain.ply_lvl_TextField:SetSize(100 * wMod, 30 * hMod)
    zrmine_ConfigMain.ply_lvl_TextField:SetText(plyData.lvl)
    zrmine_ConfigMain.ply_lvl_TextField:SetFont("zrmine_vgui_font03")
    zrmine_ConfigMain.ply_lvl_TextField:SetTextColor(Color(0, 0, 0, 255))

    zrmine_ConfigMain.ply_xp = vgui.Create("DLabel", zrmine_ConfigMain.PlayerDataPanel)
    zrmine_ConfigMain.ply_xp:SetPos(15 * wMod, 95 * hMod)
    zrmine_ConfigMain.ply_xp:SetSize(300 * wMod, 40 * hMod)
    zrmine_ConfigMain.ply_xp:SetFont("zrmine_vgui_font03")
    zrmine_ConfigMain.ply_xp:SetText("Pickaxe XP: ")
    zrmine_ConfigMain.ply_xp:SetColor(zrmine.default_colors["white02"])
    zrmine_ConfigMain.ply_xp:SetWrap(true)

    zrmine_ConfigMain.ply_xp_TextField = vgui.Create("DTextEntry", zrmine_ConfigMain.PlayerDataPanel)
    zrmine_ConfigMain.ply_xp_TextField:SetPos(290 * wMod, 105 * hMod)
    zrmine_ConfigMain.ply_xp_TextField:SetSize(100 * wMod, 30 * hMod)
    zrmine_ConfigMain.ply_xp_TextField:SetText(plyData.xp)
    zrmine_ConfigMain.ply_xp_TextField:SetFont("zrmine_vgui_font03")
    zrmine_ConfigMain.ply_xp_TextField:SetTextColor(Color(0, 0, 0, 255))

    zrmine_ConfigMain.UpdateLvl = vgui.Create("DButton", parent)
    zrmine_ConfigMain.UpdateLvl:SetText("")
    zrmine_ConfigMain.UpdateLvl:SetPos(25 * wMod, 525 * hMod)
    zrmine_ConfigMain.UpdateLvl:SetSize(350 * wMod, 50 * hMod)
    zrmine_ConfigMain.UpdateLvl.DoClick = function()
        zrmine.f.UpdatePlayerData(plyData.id)
    end
    zrmine_ConfigMain.UpdateLvl.Paint = function(s, w, h)
        if zrmine_ConfigMain.UpdateLvl:IsHovered() then
            surface.SetDrawColor(160, 225, 160, 255)
        else
            surface.SetDrawColor(125, 170, 125, 255)
        end

        surface.DrawRect(0, 0, w, h)
        local text = "Update"
        local tw, th = surface.GetTextSize(text)
        surface.SetFont("zrmine_vgui_font02")
        surface.SetTextPos(175 * wMod - (tw / 2), 25 * hMod - (th / 2))
        surface.SetTextColor(255, 255, 255, 255)
        surface.DrawText(text)
    end
end

function zrmine.f.UpdatePlayerData(id)
    local lvl = tonumber(zrmine_ConfigMain.ply_lvl_TextField:GetValue() ,10)
    local xp = tonumber(zrmine_ConfigMain.ply_xp_TextField:GetValue() ,10)
    local steamid = id

    local newData = {}
    newData.lvl = lvl
    newData.xp = xp
    newData.steamid = steamid

    local boardCompressed = util.Compress(util.TableToJSON(newData))
    net.Start("zrmine_LvlSysData_update_net")
    net.WriteUInt(#boardCompressed, 16)
    net.WriteData(boardCompressed, #boardCompressed)
    net.SendToServer()

    zrmine.f.CloseUI()
    zrmine.f.OpenUI()
end

vgui.Register("zrmine_vgui_ConfigMenu", zrmine_ConfigMenu, "DFrame")
