--[[  
    Addon: Hitman
    By: SlownLS
]]


local PANEL = {}

function PANEL:Init()
    self:Center()
    self:SetDraggable(false)
    self:MakePopup()
    self:ShowCloseButton(false)

    self:fadeIn() 
end

function PANEL:fadeIn(int)
    int = int or 0.2
    
    self:SetAlpha(0)
    self:AlphaTo(150,int)
end 


function PANEL:fadeOut(int, intDelay)
    int = int or 0.2

    self:SetMouseInputEnabled(false)
    self:SetKeyBoardInputEnabled(false)

    self:SetAlpha(150)
    self:AlphaTo(0, int, intDelay,function()
        self:Remove()
    end)
end

function PANEL:Paint(w,h)
    draw.RoundedBox(6, 0, 0, w, h, color_black)
end

function PANEL:wrap(strText,intW,intH)
    local str = ""

    for i = 1, string.len(strText) do
        str = str .. strText[i]

        surface.SetFont("SlownLS:Hitman:18")
        local w, h = surface.GetTextSize(str)

        if( w >= intW ) then
            break
        end
    end

    local intL = string.len(str)

    surface.SetFont("SlownLS:Hitman:18")
    local w, h = surface.GetTextSize(str)

    return intL, w >= intW
end

function PANEL:load()
    local pnlContent = vgui.Create("DPanel", self)
        pnlContent:SetSize(self:GetWide() - 30, self:GetTall() - 25)
        pnlContent:SetPos(15,15)
        pnlContent.Paint = function(pnl, w, h)
            self:drawOutline(0, 0, w, 50, self:getColor("green2"))
            draw.SimpleText("List of contracts", "SlownLS:Hitman:24", 15, 50 / 2, color_white, 0, 1)

            local y = h

            self:drawRect(0, h - 30, w, 1, self:getColor("green2"))
            
            draw.SimpleText("VPN : Activated", "SlownLS:Hitman:18", 0, y, color_white, 0, 4)

            draw.SimpleText("Logged in : Anonymous", "SlownLS:Hitman:18", w / 2, y, color_white, 1, 4)

            draw.SimpleText("IP : " .. game.GetIPAddress(), "SlownLS:Hitman:18", w, y, color_white, 2, 4)
        end

    local btnClose = vgui.Create("DButton", pnlContent)
        btnClose:SetSize(32,32)
        btnClose:SetPos(pnlContent:GetWide() - btnClose:GetWide() - 10, 50 / 2 - btnClose:GetTall() / 2)
        btnClose:SetText('')
        btnClose:SetFont('SlownLS:Hitman:24')
        btnClose.Paint = function(pnl, w, h)
            draw.SimpleText("✕", pnl:GetFont(), w / 2, h / 2 - 1, color_white, 1, 1)
        end
        btnClose.DoClick = function()
            self:fadeOut()
        end

    local pnlList = vgui.Create("DScrollPanel", pnlContent)
        pnlList:SetSize(pnlContent:GetWide(), pnlContent:GetTall() - 70 - 30 - 20)
        pnlList:SetPos(0,70)
        local pVBar = pnlList:GetVBar()
        pVBar:SetHideButtons(true)
        pVBar:SetWide(10)
        pVBar.Paint = nil
        pVBar.btnGrip.Paint = function(pnl, w, h)
            self:drawRect(8, 0, w - 8, h, self:getColor("green2"))
        end    

    local intFirst = table.GetFirstKey(SlownLS.Hitman.Contracts)

    for k,v in pairs(SlownLS.Hitman.Contracts or {}) do
        if( not IsValid(v.victim) ) then continue end

        local x = 120
        local str = v.description
        local intMaxLength = pnlList:GetWide() - 100
        intMaxLength = intMaxLength * 1.89

        local intWrap, boolLength = self:wrap(v.description, intMaxLength, 45)

        local boolHoveredTooltip = false 
        local boolHoveredModel = false 

        local pnl = vgui.Create("DButton", pnlList)
            pnl:SetSize(pnlList:GetWide(), 110)
            pnl:SetText('')
            pnl:Dock(TOP)
            pnl:DockMargin(0,( k == intFirst and 0 or 10),0,0)
            pnl.Paint = function(pnl, w, h)
                if( not SlownLS.Hitman.Contracts[k] ) then
                    pnl:Remove()
                    return 
                end

                if( not v.victim or not IsValid(v.victim) ) then
                    pnl:Remove()    
                    return 
                end

                pnl.intLerp = pnl.intLerp or 0


                if( pnl:IsHovered() or boolHoveredTooltip or boolHoveredModel ) then
                    pnl.intLerp = Lerp(FrameTime() * 20, pnl.intLerp, 10)
                else
                    pnl.intLerp = Lerp(FrameTime() * 20, pnl.intLerp, 0)
                end

                self:drawRect(0, 0, w, h, Color(50,150,50,pnl.intLerp))
                self:drawOutline(0, 0, w, h, self:getColor("green2"))
                
                local str = self:getLanguage('award') .. ":"
                local strFont = "SlownLS:Hitman:18"
                local intW, intH = self:getTextSize(str,strFont)

                draw.SimpleText(self:getLanguage('target') .. ": " .. v.victim:Nick(), "SlownLS:Hitman:24", x, 10, color_white)
                draw.SimpleText(str, strFont, x, 40, color_white)
                draw.SimpleText(DarkRP.formatMoney(v.price), strFont, x + (intW + 5), 40, self:getColor('green2'))

                if( SlownLS.Hitman.Contracts[k] ) then                
                    if(not SlownLS.Hitman.Contracts[k].taken_by) then
                        draw.SimpleText(self:getLanguage('contractAvailable'), strFont, w - 10, 10, self:getColor('green2'), 2)
                    else
                        draw.SimpleText(self:getLanguage('onGoingContract'), strFont, w - 10, 10, self:getColor('red2'), 2)
                    end
                end
            end
            pnl.DoClick = function()
                SlownLS.Hitman:sendEvent('take_contract', {
                    key = k
                })
            end

        local pnlDescription = vgui.Create("RichText", pnl)
            pnlDescription:SetSize(pnl:GetWide() - 100, 45)
            pnlDescription:SetPos(x-1,63)
            pnlDescription:InsertColorChange(255, 255, 255, 255)
            pnlDescription:SetText(string.sub(str, 0, intWrap) .. ( boolLength and "..." or "" ) )
            pnlDescription.Paint = function()
                pnlDescription.m_FontName = "SlownLS:Hitman:18"
                pnlDescription:SetFontInternal( "SlownLS:Hitman:18" )	
                pnlDescription.Paint = nil
            end

        local pnlTooltip = vgui.Create("DPanel", pnl)
            pnlTooltip:SetSize(pnl:GetWide() - 100, 45)
            pnlTooltip:SetPos(x-1,65)
            if( boolLength ) then
                    pnlTooltip:SetToolTip(str)
            end
            pnlTooltip:SetCursor("hand")
            pnlTooltip.Paint = nil
            pnlTooltip.Think = function(s)
                boolHoveredTooltip = s:IsHovered()
            end
            pnlTooltip.OnMousePressed = function()
                pnl:DoClick()
            end

        local pnlModel = vgui.Create("DModelPanel", pnl)
                pnlModel:SetSize(pnl:GetTall(), pnl:GetTall() - 1)
                pnlModel:SetPos(0, 0)
                pnlModel:SetModel(v.victim:GetModel())
                pnlModel:SetColor(v.victim:GetColor())
                pnlModel:SetCursor("hand")
                function pnlModel:LayoutEntity(ent) return end

                local intBone = pnlModel.Entity:LookupBone("ValveBiped.Bip01_Head1")

                if ( intBone ) then
                    local eyepos = pnlModel.Entity:GetBonePosition(intBone)
                    eyepos:Add(Vector(0, 0, 2))

                    pnlModel:SetLookAt(eyepos)
                    pnlModel:SetCamPos(eyepos - Vector(-20, 0, 0 ))
                    pnlModel.Entity:SetEyeTarget(eyepos - Vector(-12, 0, 0))
                end

                pnlModel.Think = function(s)
                    boolHoveredModel = s:IsHovered()
                end
                pnlModel.OnMousePressed = function()
                    pnl:DoClick()
                end
    end
end

function PANEL:OnRemove()
    SlownLS.Hitman:sendEvent('close_tablet',{})
end

derma.DefineControl("SlownLS:Hitman:Tablet", "", PANEL, "SlownLS:Hitman:DFrame")