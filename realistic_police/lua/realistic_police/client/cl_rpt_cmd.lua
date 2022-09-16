
local Sounds = {
    [1] = "https://media.vocaroo.com/mp3/5nsksDxB4mJ",
    [2] = "https://media.vocaroo.com/mp3/hPxWgG4BJTH",
    [3] = "https://media.vocaroo.com/mp3/BgNxBllRoEE",
}

function Realistic_Police.HackKey()
    sound.PlayURL( Sounds[math.random(1, #Sounds)], "", 
    function( station )
        if IsValid( station ) then
            station:Play()
            station:SetVolume(1)
        end 
    end )
end 

local ipNumbers = {
    [1] = {min = 100, max = 999},
    [2] = {min = 100, max = 999},
    [3] = {min = 1, max = 30},
    [4] = {min = 1, max = 10}
}

local function generateIP()
    local ipAdress = ""
    for _, v in ipairs(ipNumbers) do
        if not isnumber(v.min) then continue end
        if not isnumber(v.max) then continue end
        ipAdress = ipAdress == "" and ipAdress..math.random(v.min, v.max) or ipAdress.."."..math.random(v.min, v.max)
    end
    return ipAdress
end

function Realistic_Police.Cmd(Frame, Ent)
    CoultDown = CoultDown or CurTime()
    if CoultDown > CurTime() then return end 
    CoultDown = CurTime() + 1 

    local RpRespX, RpRespY = ScrW(), ScrH()
    if not Realistic_Police.HackerJob[team.GetName(LocalPlayer():Team())] then RealisticPoliceNotify(Realistic_Police.GetSentence("cantDoThat")) return end  
    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10
    local TextHack = ""
    local TextColor = Realistic_Police.Colors["gray220"]
    local CanWrite = true  
    local FinishHack = false 
    local ipAdress = generateIP()
    local TableString = {
        [1] = ""
    }
    local RandomWord = Realistic_Police.WordHack[math.random(1, #Realistic_Police.WordHack)]
    local Progress = 1 
    
    local RPTCMDFrame = vgui.Create("DFrame", RPTFrame)
    RPTCMDFrame:SetSize(RpRespX*0.4825, RpRespY*0.486)
    RPTCMDFrame:ShowCloseButton(false)
    RPTCMDFrame:SetDraggable(true)
    RPTCMDFrame:SetTitle("")
    RPTCMDFrame:Center()
    RPTCMDFrame:SetKeyboardInputEnabled(true)
    RPTCMDFrame:RequestFocus()
    RPTCMDFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )
        
        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( 0, 0, w + 10, h*0.074)

        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText(Realistic_Police.NameOs.." CMD", "rpt_font_7", RpRespX*0.003, RpRespY*0.0038, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
        
        draw.DrawText(Realistic_Police.NameOs.." OS [Version 1.0] \n(c) "..Realistic_Police.NameOs.." Corporation 2020", "rpt_font_7", RpRespX*0.003, RpRespY*0.05, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
        draw.DrawText("C:/Users/"..Realistic_Police.NameOs.."Corporation/cmd", "rpt_font_7", RpRespX*0.003, RpRespY*0.12, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)

        for k,v in pairs(TableString) do     
            if k > 7 then table.remove(TableString, 1) end 
            if not FinishHack then 
                if TableString[k] == "" then 
                    draw.DrawText("Write this Word "..RandomWord.." : "..TextHack, "rpt_font_7", RpRespX*0.003, (RpRespY*0.16) * (k*0.25) + RpRespY*0.12, TextColor, TEXT_ALIGN_LEFT)
                elseif isstring(TableString[k]) then 
                    draw.DrawText("Write this Word "..TableString[k].." : "..TableString[k], "rpt_font_7", RpRespX*0.003, (RpRespY*0.16) * (k*0.25) + RpRespY*0.12, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
                end 
            elseif k != 7 then 
                if isstring(TableString[k]) then 
                    draw.DrawText(TableString[k], "rpt_font_7", RpRespX*0.003, (RpRespY*0.16) * (k*0.25) + RpRespY*0.12, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
                end 
            elseif k == 7 then 
                if isstring(TableString[k]) then 
                    draw.DrawText(TableString[k], "rpt_font_7", RpRespX*0.003, (RpRespY*0.16) * (k*0.25) + RpRespY*0.12, TextColor, TEXT_ALIGN_LEFT)
                end 
            end 
        end 
    end 
    function RPTCMDFrame:OnMousePressed()
        RPTCMDFrame:RequestFocus()
        local screenX, screenY = self:LocalToScreen( 0, 0 )
        if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
            self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
            self:MouseCapture( true )
            return
        end
        if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
            self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
            self:MouseCapture( true )
            return
        end
    end 

    local RPTCMDFrameP = vgui.Create( "DProgress", RPTCMDFrame )
    RPTCMDFrameP:SetPos( 0, RpRespY*0.48 )
    RPTCMDFrameP:SetSize( RpRespX*0.4825, RpRespY*0.01 )
    RPTCMDFrameP:SetFraction( 0 )
    function RPTCMDFrame:OnKeyCodePressed( key ) 
        Realistic_Police.HackKey()
        if CanWrite then 
            if input.GetKeyName( key ) != "BACKSPACE" && input.GetKeyName( key ) != "ENTER" then 
                if CanWrite then 
                    if key >= 0 && key <= 36 or key == 59 then 
                        TextHack = TextHack..input.GetKeyName( key )
                    elseif key > 36 && key <= 46 then 
                        local TableKey = {
                            [37] = 0, 
                            [38] = 1, 
                            [39] = 2, 
                            [40] = 3, 
                            [41] = 4, 
                            [42] = 5, 
                            [43] = 6, 
                            [44] = 7, 
                            [45] = 8, 
                            [46] = 9, 

                        }
                        TextHack = TextHack..TableKey[key]
                    end 
                end 
            elseif input.GetKeyName( key ) == "BACKSPACE" then 
                TextHack = string.sub(TextHack, 0, #TextHack-1)
            elseif input.GetKeyName( key ) == "ENTER" then 
                if RandomWord == TextHack then 
                    TextColor = Realistic_Police.Colors["green"]
                    CanWrite = false 
                    surface.PlaySound( "UI/buttonclick.wav" )
                    timer.Simple(0.5, function()
                        CanWrite = true 
                        TextColor = Realistic_Police.Colors["gray220"] 
                        TableString[#TableString] = TextHack
                        TableString[#TableString + 1] = ""
                        TextHack = ""
                        RPTCMDFrameP:SetFraction( Progress * ( 1 / Realistic_Police.WordCount) )
                        Progress = Progress + 1 
                        TextHack = ""
                        RandomWord = Realistic_Police.WordHack[math.random(1, #Realistic_Police.WordHack)]
                        if Progress * 0.10 > Realistic_Police.WordCount*0.10  then 
                            TableString = {}
                            local Pourcentage = "0" 
                            FinishHack = true 
                            timer.Create("rpt_access", 0.05, 101, function()
                                Pourcentage = Pourcentage + 1 
                                if Pourcentage != 101 then 
                                    TableString[#TableString + 1] = "$root@"..ipAdress.." - Hack Progress ...... "..Pourcentage.."%"
                                else 
                                    TableString[#TableString + 1] = "Access Granted to the Computer"
                                    timer.Create("rpt_clicker", 0.5, 5, function()
                                        if TextColor == Realistic_Police.Colors["gray220"] then 
                                            TextColor = Realistic_Police.Colors["green"]
                                        else 
                                            TextColor = Realistic_Police.Colors["gray220"]
                                        end 
                                    end ) 
                                end 
                            end ) 
                            timer.Simple(8, function()
                                if IsValid(RPTCMDFrame) then 
                                    RPTCMDFrame:SlideUp(0.2)
                                    net.Start("RealisticPolice:Open")
                                        net.WriteEntity(Ent)
                                    net.SendToServer()
                                end 
                            end ) 
                        end 
                    end ) 
                else 
                    if Progress > 1 then 
                        Progress = Progress - 1
                        RPTCMDFrameP:SetFraction( (Progress * ( 1 / Realistic_Police.WordCount)) - (1 * ( 1 / Realistic_Police.WordCount)) )
                    end 

                    surface.PlaySound( "buttons/combine_button1.wav" )
                    TextColor = Realistic_Police.Colors["red"]
                    CanWrite = false 
                    timer.Simple(0.5, function()
                        CanWrite = true 
                        TextColor = Realistic_Police.Colors["gray220"] 
                        TextHack = ""
                    end ) 
                end 
            end 
        end 
	end

    local RPTClose = vgui.Create("DButton", RPTCMDFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTCMDFrame:GetWide()*0.938, RPTCMDFrame:GetTall()*0.0068)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h ) 
    end 
    RPTClose.DoClick = function()
        RPTCMDFrame:Remove()
        Realistic_Police.Clic()
    end  
end 
