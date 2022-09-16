--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

local RealisticPropertiesBlur = Material("pp/blurscreen")
local function RealisticPropertiesClic()
    sound.PlayURL( "https://media.vocaroo.com/mp3/8ogmBd5Y4CA", "", 
    function( station )
        if IsValid( station ) then
            station:Play()
            station:SetVolume(1)
        end 
    end )
end 

net.Receive("RealisticProperties:ModificationNpc", function() 
    if not Realistic_Properties.AdminRank[LocalPlayer():GetUserGroup()] then return end
    local RealisticPropertiesTable = net.ReadTable() or {} 
    if #RealisticPropertiesTable == 0 then Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("noProperties"), 3 ) return end 
    local RealisticPropertiesTableEnt = net.ReadTable() or {} 
    local RealisticPropertiesEnt = net.ReadEntity()
    local RealisticPropertiesTableProperty = RealisticPropertiesTableEnt
    local RealisticPropertiesChoose = 1 
    local RpRespX, RpRespY = ScrW(), ScrH() 

    local RealisticPropertiesFrame = vgui.Create("DFrame")
    RealisticPropertiesFrame:SetSize(RpRespX*0.45, RpRespY*0.47)
    RealisticPropertiesFrame:Center()
    RealisticPropertiesFrame:MakePopup()
    RealisticPropertiesFrame:SetDraggable(false)
    RealisticPropertiesFrame:ShowCloseButton(false)
    RealisticPropertiesFrame:SetTitle("")
    RealisticPropertiesFrame.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w*0.908, h*0.963, Realistic_Properties.Colors["whitegray"])
        draw.RoundedBox(0, 0, 0, w*0.908, h*0.106, Realistic_Properties.Colors["lightblue"])
        draw.RoundedBox(0, 0, h*0.11, w*0.267, h*0.854, Realistic_Properties.Colors["white240"])
        draw.RoundedBox(8, w*0.288, h*0.125, w*0.593, h*0.81, Realistic_Properties.Colors["white240"])
        draw.SimpleText(string.upper(Realistic_Properties.GetSentence("realisticPropeties")), "rps_font_5", w*0.01, h*0.02, color_white, TEXT_ALIGN_LEFT)
    end 

    local RealisticPropertiesDScroll = vgui.Create("DScrollPanel", RealisticPropertiesFrame)
    RealisticPropertiesDScroll:SetSize(RpRespX * 0.12, RpRespY * 0.4)
    RealisticPropertiesDScroll:SetPos(0, RpRespY*0.05)
    RealisticPropertiesDScroll.Paint = function() end 
    local RealisticPropertiesBar = RealisticPropertiesDScroll:GetVBar()
    function RealisticPropertiesBar:Paint() end
    function RealisticPropertiesBar.btnUp:Paint() end
    function RealisticPropertiesBar.btnDown:Paint() end
    function RealisticPropertiesBar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors["lightblue"])
    end
    RealisticPropertiesDScroll:GetVBar():SetWide(8)
    RealisticPropertiesDScroll:GetVBar():SetHideButtons( true )
    
    local RealisticPropertiesFrameTable = {}
    for k,v in pairs(RealisticPropertiesTable) do 
        RealisticPropertiesFrameTable[k] = vgui.Create( "DButton", RealisticPropertiesDScroll)
        RealisticPropertiesFrameTable[k]:SetSize( RpRespX*0.1, RpRespY*0.05 )
        RealisticPropertiesFrameTable[k]:Dock(TOP)
        RealisticPropertiesFrameTable[k]:DockMargin(0, 0, 0, 0)
        RealisticPropertiesFrameTable[k]:SetText(" ♔ "..string.upper(RealisticPropertiesTable[k]["RealisticPropertiesName"]))
        RealisticPropertiesFrameTable[k]:SetContentAlignment(4)
        RealisticPropertiesFrameTable[k]:SetTextColor(color_black)
        RealisticPropertiesFrameTable[k]:SetFont("rps_font_11")
        RealisticPropertiesFrameTable[k].DoClick = function()
            RealisticPropertiesChoose = k 
        end 
        RealisticPropertiesFrameTable[k].Paint = function(self,w,h)
            if RealisticPropertiesChoose == k then 
                draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors["gray150"])
            end 
        end 
    end 
    
    local RealisticPropertiesFrameCam1 = vgui.Create( "DFrame", RealisticPropertiesFrame )
    RealisticPropertiesFrameCam1:SetSize( RpRespX*0.257, RpRespY*0.3 )
    RealisticPropertiesFrameCam1:SetPos( RpRespX*0.41, RpRespY*0.334 )
    RealisticPropertiesFrameCam1:SetDraggable(false)
    RealisticPropertiesFrameCam1:ShowCloseButton(false)
    RealisticPropertiesFrameCam1:SetTitle("")
    function RealisticPropertiesFrameCam1:Paint( w, h )
        local x, y = self:GetPos()
        render.RenderView( {
            origin = RealisticPropertiesTable[RealisticPropertiesChoose]["RealisticPropertiesCam"][1],
            angles = RealisticPropertiesTable[RealisticPropertiesChoose]["RealisticPropertiesCam"][2],
            x = x, y = y,
            w = w, h = h,
            drawhud = false, 
        } )
    end

    local RealisticPropertiesDButton = vgui.Create("DButton", RealisticPropertiesFrame)
    RealisticPropertiesDButton:SetSize( RpRespX*0.257, RpRespY*0.05 )
    RealisticPropertiesDButton:SetPos( RpRespX*0.135, RpRespY*0.38) 
    RealisticPropertiesDButton:SetText("")
    RealisticPropertiesDButton:SetTextColor(color_white)
    RealisticPropertiesDButton.Paint = function(self,w,h)
        if table.HasValue(RealisticPropertiesTableEnt, RealisticPropertiesTable[RealisticPropertiesChoose]["RealisticPropertiesName"]) then 
            draw.RoundedBox(8, 0, 0, w, h, Realistic_Properties.Colors["greenwhite"])
            draw.SimpleText(Realistic_Properties.GetSentence("activate"), "rps_font_5", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else 
            draw.RoundedBox(8, 0, 0, w, h, Realistic_Properties.Colors["redwhite"])
            draw.SimpleText(string.upper(Realistic_Properties.GetSentence("desactivate")), "rps_font_5", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end 
    RealisticPropertiesDButton.DoClick = function() 
        if not table.HasValue(RealisticPropertiesTableEnt, RealisticPropertiesTable[RealisticPropertiesChoose]["RealisticPropertiesName"]) then 
            RealisticPropertiesTableProperty[#RealisticPropertiesTableProperty + 1] = RealisticPropertiesTable[RealisticPropertiesChoose]["RealisticPropertiesName"]
        else 
            table.RemoveByValue(RealisticPropertiesTableProperty, RealisticPropertiesTable[RealisticPropertiesChoose]["RealisticPropertiesName"])
        end 
        net.Start("RealisticProperties:ModificationNpc")
            net.WriteTable(RealisticPropertiesTableProperty)
            net.WriteEntity(RealisticPropertiesEnt)
        net.SendToServer()
    end 

    local RealisticPropertiesDButton = vgui.Create("DButton", RealisticPropertiesFrame)
    RealisticPropertiesDButton:SetSize( RpRespX*0.02, RpRespY*0.04 )
    RealisticPropertiesDButton:SetPos( RpRespX*0.38, RpRespY*0.005)
    RealisticPropertiesDButton:SetText("✘")
    RealisticPropertiesDButton:SetFont("rps_font_5")
    RealisticPropertiesDButton:SetTextColor(color_white)
    RealisticPropertiesDButton.Paint = function() end 
    RealisticPropertiesDButton.DoClick = function()
        RealisticPropertiesFrame:Remove()
    end 
end ) 

local function CheckIfExist(tbl, name)
    local name = string.Trim(string.upper(name))
    local res = false

    for i = 1, #tbl do
        if string.Trim(string.upper(tbl[i].RealisticPropertiesName)) == name then
            res = true
            break
        end
    end
    return res
end

net.Receive("RealisticProperties:PropertiesAdd", function() -- Admin Menu 
    if not Realistic_Properties.AdminRank[LocalPlayer():GetUserGroup()] then return end 
    local RealisticPropertiesTable = net.ReadTable() or {}
    local Number = net.ReadInt(32)
    local RPSInformationDecompress = util.Decompress(net.ReadData(Number)) or {}
    RealisticPropertiesTableAll = util.JSONToTable(RPSInformationDecompress) or {}
    local RealisticPropertiesId = 1 
    local RealisticPropertiesEditProperties = false 
    local RpRespX, RpRespY = ScrW(), ScrH()
    
    if IsValid(RealisticPropertiesFrameBase) then RealisticPropertiesFrameBase:Remove() end 
    if table.Count(RealisticPropertiesTable) == 0 then 
        RealisticPropertiesTable = RealisticPropertiesTableAll[1]
        if table.Count(RealisticPropertiesTableAll) == 0 then return end 
        RealisticPropertiesEditProperties = true 
    end 

    RealisticPropertiesFrameBase = vgui.Create("DFrame")
    RealisticPropertiesFrameBase:SetSize(RpRespX*1, RpRespY*1)
    RealisticPropertiesFrameBase:SetPos(0, 0)
    RealisticPropertiesFrameBase:SetDraggable(false)
    RealisticPropertiesFrameBase:ShowCloseButton(false)
    RealisticPropertiesFrameBase:SetTitle("")
    RealisticPropertiesFrameBase.Paint = function() end  

    local RealisticPropertiesFrameCam1 = vgui.Create( "DFrame", RealisticPropertiesFrameBase )
    RealisticPropertiesFrameCam1:SetSize( RpRespX*0.25, RpRespY*0.3 )
    RealisticPropertiesFrameCam1:SetPos( RpRespX*0.128, RpRespY*0.35)
    RealisticPropertiesFrameCam1:SetDraggable(false)
    RealisticPropertiesFrameCam1:ShowCloseButton(false)
    RealisticPropertiesFrameCam1:SetTitle("")
    function RealisticPropertiesFrameCam1:Paint( w, h )
        draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors["black33"])
        local x, y = self:GetPos()
        render.RenderView( {
            origin = Vector(RealisticPropertiesTable["RealisticPropertiesCam"][RealisticPropertiesId]),
            angles = Angle(RealisticPropertiesTable["RealisticPropertiesCam"][RealisticPropertiesId + 1]),
            x = x+10, y = y+10,
            w = w-20, h = h-20
        } )
    end

    local RealisticPropertiesPanel = vgui.Create("DPanel", RealisticPropertiesFrameBase)
    RealisticPropertiesPanel:SetSize(RpRespX*0.24, RpRespY*0.05)
    RealisticPropertiesPanel:SetPos(RpRespX*0.133,RpRespY*0.591)
    RealisticPropertiesPanel.Paint = function(self,w,h)
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"])
        if RealisticPropertiesId == 1 then 
            draw.DrawText("1 / 3", "rps_font_3", RealisticPropertiesPanel:GetWide()/2, h*0.33, Realistic_Properties.Colors["white"], TEXT_ALIGN_CENTER)
        elseif RealisticPropertiesId == 3 then 
            draw.DrawText("2 / 3", "rps_font_3", RealisticPropertiesPanel:GetWide()/2, h*0.33, Realistic_Properties.Colors["white"], TEXT_ALIGN_CENTER)
        elseif RealisticPropertiesId == 5 then 
            draw.DrawText("3 / 3", "rps_font_3", RealisticPropertiesPanel:GetWide()/2, h*0.33, Realistic_Properties.Colors["white"], TEXT_ALIGN_CENTER)
        end
    end 

    local RealisticPropertiesButtonBefore = vgui.Create("DButton", RealisticPropertiesFrameBase)
    RealisticPropertiesButtonBefore:SetSize(RpRespX*0.03, RpRespY*0.05)
    RealisticPropertiesButtonBefore:SetPos(RpRespX*0.2,RpRespY*0.593)
    RealisticPropertiesButtonBefore:SetText("◄")
    RealisticPropertiesButtonBefore:SetTextColor(Realistic_Properties.Colors["gray"])
    RealisticPropertiesButtonBefore:SetFont("rps_font_2")
    RealisticPropertiesButtonBefore.Paint = function() end
    RealisticPropertiesButtonBefore.DoClick = function()
        if RealisticPropertiesId > 1 then 
            RealisticPropertiesId = RealisticPropertiesId - 2
        else 
            RealisticPropertiesId = 5
        end 
    end  

    local RealisticPropertiesButtonNext = vgui.Create("DButton", RealisticPropertiesFrameBase)
    RealisticPropertiesButtonNext:SetSize(RpRespX*0.03, RpRespY*0.05)
    RealisticPropertiesButtonNext:SetPos(RpRespX*0.274,RpRespY*0.593)
    RealisticPropertiesButtonNext:SetText("►")
    RealisticPropertiesButtonNext:SetTextColor(Realistic_Properties.Colors["gray"])
    RealisticPropertiesButtonNext:SetFont("rps_font_2")
    RealisticPropertiesButtonNext.Paint = function() end 
    RealisticPropertiesButtonNext.DoClick = function()
        if RealisticPropertiesId < 5 then 
            RealisticPropertiesId = RealisticPropertiesId + 2 
        else 
            RealisticPropertiesId = 1 
        end 
    end     

    local pos1 = RealisticPropertiesTable["RealisticPropertiesboxMins"]
    local pos2 = RealisticPropertiesTable["RealisticPropertiesboxMax"]
    local square = math.abs((pos2.x-pos1.x) * (pos2.y-pos1.y))
    square = square - square * 0.9999

    local RealisticPropertiesFrame = vgui.Create("DFrame", RealisticPropertiesFrameBase)
    RealisticPropertiesFrame:SetSize(RpRespX*0.34, RpRespY*0.3)
    RealisticPropertiesFrame:SetPos(RpRespX*0.385, RpRespY*0.35)
    RealisticPropertiesFrame:MakePopup()
    RealisticPropertiesFrame:SetDraggable(false)
    RealisticPropertiesFrame:ShowCloseButton(false)
    RealisticPropertiesFrame:SetTitle("")
    RealisticPropertiesFrame.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h*0.14, Realistic_Properties.Colors["black33"])
        draw.RoundedBox(0, 0, h*0.17, w, h, Realistic_Properties.Colors["black33"])
        draw.DrawText(string.upper(Realistic_Properties.GetSentence("realisticPropeties")), "rps_font_1", w*0.015, h*0.018, Realistic_Properties.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(Realistic_Properties.GetSentence("surface").." "..math.Round(square).." m²", "rps_font_3", w*0.015, RealisticPropertiesFrame:GetTall()*0.875, Realistic_Properties.Colors["white"], TEXT_ALIGN_LEFT)
    end 

    local RealisticPropertiesDTextEntry1 = vgui.Create("DTextEntry", RealisticPropertiesFrame)
    RealisticPropertiesDTextEntry1:SetSize(RealisticPropertiesFrame:GetWide()*0.98, RealisticPropertiesFrame:GetTall()*0.15)
    RealisticPropertiesDTextEntry1:SetPos(RealisticPropertiesFrame:GetWide()*0.01, RealisticPropertiesFrame:GetTall()*0.2)
    RealisticPropertiesDTextEntry1:SetText(" "..Realistic_Properties.GetSentence("propertyName"))
    RealisticPropertiesDTextEntry1:SetFont("rps_font_3")
    RealisticPropertiesDTextEntry1:SetDrawLanguageID( false )
    RealisticPropertiesDTextEntry1.Paint = function(self,w,h) 
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
		self:DrawTextEntryText(Realistic_Properties.Colors["white"], Realistic_Properties.Colors["gray"], Realistic_Properties.Colors["white"])
    end 
    RealisticPropertiesDTextEntry1.OnGetFocus = function(self) 
        if RealisticPropertiesDTextEntry1:GetText() == " "..Realistic_Properties.GetSentence("propertyName") then 
            RealisticPropertiesDTextEntry1:SetText("") 
        end 
    end 
    RealisticPropertiesDTextEntry1:SetEnterAllowed( false )
	RealisticPropertiesDTextEntry1.OnLoseFocus = function(self)
		if RealisticPropertiesDTextEntry1:GetText() == "" then  
			RealisticPropertiesDTextEntry1:SetText(" "..Realistic_Properties.GetSentence("propertyName"))
		end
	end 

    local RealisticPropertiesDTextEntry2 = vgui.Create("DTextEntry", RealisticPropertiesFrame)
    RealisticPropertiesDTextEntry2:SetSize(RealisticPropertiesFrame:GetWide()*0.98, RealisticPropertiesFrame:GetTall()*0.15)
    RealisticPropertiesDTextEntry2:SetPos(RealisticPropertiesFrame:GetWide()*0.01, RealisticPropertiesFrame:GetTall()*0.36)
    RealisticPropertiesDTextEntry2:SetText(" "..Realistic_Properties.GetSentence("propertyPrice"))
    RealisticPropertiesDTextEntry2:SetContentAlignment(4)
    RealisticPropertiesDTextEntry2:SetFont("rps_font_3")
    RealisticPropertiesDTextEntry2:SetNumeric(true)
    RealisticPropertiesDTextEntry2:SetTextColor(Realistic_Properties.Colors["white"])
    RealisticPropertiesDTextEntry2:SetDrawLanguageID( false )
    RealisticPropertiesDTextEntry2.Paint = function(self,w,h) 
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
		self:DrawTextEntryText(Realistic_Properties.Colors["white"], Realistic_Properties.Colors["gray"], Realistic_Properties.Colors["white"])
    end 
    RealisticPropertiesDTextEntry2:SetEnterAllowed( false )
	RealisticPropertiesDTextEntry2.OnGetFocus = function(self) 
        if RealisticPropertiesDTextEntry2:GetText() == " "..Realistic_Properties.GetSentence("propertyPrice") then 
            RealisticPropertiesDTextEntry2:SetText("") 
        end 
    end 
	RealisticPropertiesDTextEntry2.OnLoseFocus = function(self)
		if RealisticPropertiesDTextEntry2:GetText() == "" then  
			RealisticPropertiesDTextEntry2:SetText(" "..Realistic_Properties.GetSentence("propertyPrice"))
		end
	end 

    local RealisticPropertiesDCombobox1 = vgui.Create("DComboBox", RealisticPropertiesFrame)
    RealisticPropertiesDCombobox1:SetSize(RealisticPropertiesFrame:GetWide()*0.98, RealisticPropertiesFrame:GetTall()*0.15)
    RealisticPropertiesDCombobox1:SetPos(RealisticPropertiesFrame:GetWide()*0.01, RealisticPropertiesFrame:GetTall()*0.52)
    RealisticPropertiesDCombobox1:SetText(Realistic_Properties.GetSentence("propertyLocation"))
    RealisticPropertiesDCombobox1:SetFont("rps_font_3")
    RealisticPropertiesDCombobox1:SetTextColor(Realistic_Properties.Colors["white"])
    RealisticPropertiesDCombobox1:AddChoice(Realistic_Properties.GetSentence("propertiesCanRent"))
    RealisticPropertiesDCombobox1:AddChoice(Realistic_Properties.GetSentence("propertiesCantRent"))
    RealisticPropertiesDCombobox1.Paint = function(self,w,h) 
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
    end 

    local RealisticPropertiesDCombobox2 = vgui.Create("DComboBox", RealisticPropertiesFrame)
    RealisticPropertiesDCombobox2:SetSize(RealisticPropertiesFrame:GetWide()*0.98, RealisticPropertiesFrame:GetTall()*0.15)
    RealisticPropertiesDCombobox2:SetPos(RealisticPropertiesFrame:GetWide()*0.01, RealisticPropertiesFrame:GetTall()*0.68)
    RealisticPropertiesDCombobox2:SetText(Realistic_Properties.GetSentence("propertyType"))
    RealisticPropertiesDCombobox2:SetFont("rps_font_3")
    RealisticPropertiesDCombobox2:SetTextColor(Realistic_Properties.Colors["white"])
    for k,v in pairs(Realistic_Properties.TypeProperties) do
        RealisticPropertiesDCombobox2:AddChoice(v)
    end 
    RealisticPropertiesDCombobox2.Paint = function(self,w,h) 
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
    end 

    if RealisticPropertiesEditProperties then 
        RealisticPropertiesDCombobox3 = vgui.Create("DComboBox", RealisticPropertiesFrame)
        RealisticPropertiesDCombobox3:SetSize(RealisticPropertiesFrame:GetWide()*0.4, RealisticPropertiesFrame:GetTall()*0.1)
        RealisticPropertiesDCombobox3:SetPos(RealisticPropertiesFrame:GetWide()*0.58, RealisticPropertiesFrame:GetTall()*0.02)
        RealisticPropertiesDCombobox3:SetText(Realistic_Properties.GetSentence("propertiesList"))
        RealisticPropertiesDCombobox3:SetFont("rps_font_3")
        RealisticPropertiesDCombobox3:SetTextColor(Realistic_Properties.Colors["white"])
        RealisticPropertiesDCombobox3.Paint = function(self,w,h) 
            draw.RoundedBox(4, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
        end 
        for k,v in pairs(RealisticPropertiesTableAll) do 
            RealisticPropertiesDCombobox3:AddChoice(v.RealisticPropertiesName)
        end 
        RealisticPropertiesDCombobox3.OnSelect = function(index, id, data)
            if RealisticPropertiesTableAll[id]["RealisticPropertiesLocationId"] == 1 then 
                RealisticPropertiesDCombobox1:SetValue(Realistic_Properties.GetSentence("propertiesCanRent")) 
            elseif RealisticPropertiesTableAll[id]["RealisticPropertiesLocationId"] == 3 then
                RealisticPropertiesDCombobox1:SetValue(Realistic_Properties.GetSentence("propertiesCantRent")) 
            end
            RealisticPropertiesCantBuyJob = {}
            if istable(RealisticPropertiesTableAll[id]["RealisticPropertiesCantBuyJob"]) then 
                for k,v in pairs(RealisticPropertiesTableAll[id]["RealisticPropertiesCantBuyJob"]) do 
                    if not table.HasValue(RealisticPropertiesCantBuyJob, v) then 
                        RealisticPropertiesCantBuyJob[#RealisticPropertiesCantBuyJob + 1] = v 
                    else 
                        table.RemoveByValue(RealisticPropertiesCantBuyJob, v)
                    end 
                end 
            end 
            RealisticPropertiesDCombobox2:SetText(RealisticPropertiesTableAll[id]["RealisticPropertiesType"])
            RealisticPropertiesDTextEntry2:SetText(RealisticPropertiesTableAll[id]["RealisticPropertiesPrice"])
            RealisticPropertiesDTextEntry1:SetText(RealisticPropertiesTableAll[id]["RealisticPropertiesName"])
            RealisticPropertiesTable = RealisticPropertiesTableAll[id]
            RealisticPropertiesIdDelete = id 
        end 
        if RealisticPropertiesTableAll[1]["RealisticPropertiesLocationId"] == 1 then 
            RealisticPropertiesDCombobox1:SetValue(Realistic_Properties.GetSentence("propertiesCanRent")) 
        elseif RealisticPropertiesTableAll[1]["RealisticPropertiesLocationId"] == 2 then
            RealisticPropertiesDCombobox1:SetValue(Realistic_Properties.GetSentence("propertiesCantRent")) 
        end
        RealisticPropertiesDCombobox3:SetValue(RealisticPropertiesTableAll[1]["RealisticPropertiesName"])
        RealisticPropertiesDCombobox2:SetText(RealisticPropertiesTableAll[1]["RealisticPropertiesType"])
        RealisticPropertiesDTextEntry2:SetText(RealisticPropertiesTableAll[1]["RealisticPropertiesPrice"])
        RealisticPropertiesDTextEntry1:SetText(RealisticPropertiesTableAll[1]["RealisticPropertiesName"])
        RealisticPropertiesIdDelete = 1 
    end 

    
    local RealisticPropertiesFrameJob = vgui.Create("DFrame", RealisticPropertiesFrameBase)
    RealisticPropertiesFrameJob:SetSize(RpRespX*0.15, RpRespY*0.3)
    RealisticPropertiesFrameJob:SetPos(RpRespX*0.73, RpRespY*0.35)
    RealisticPropertiesFrameJob:MakePopup()
    RealisticPropertiesFrameJob:SetDraggable(false)
    RealisticPropertiesFrameJob:ShowCloseButton(false)
    RealisticPropertiesFrameJob:SetTitle("")
    RealisticPropertiesFrameJob.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h*0.14, Realistic_Properties.Colors["black33"])
        draw.RoundedBox(0, 0, h*0.17, w, h, Realistic_Properties.Colors["black33"])
        draw.DrawText("BLACKLIST", "rps_font_1", RealisticPropertiesFrameJob:GetWide()/2, h*0.018, Realistic_Properties.Colors["white"], TEXT_ALIGN_CENTER) 
    end 

    local RealisticPropertiesDscrollJob = vgui.Create("DScrollPanel", RealisticPropertiesFrameJob)
    RealisticPropertiesDscrollJob:SetSize(RpRespX*0.14, RpRespY*0.235)
    RealisticPropertiesDscrollJob:SetPos(RpRespX*0.005, RpRespY*0.06)
    RealisticPropertiesDscrollJob.Paint = function() end 
    RealisticPropertiesDscrollJob:GetVBar():SetSize(0,0)

    RealisticPropertiesCantBuyJob = {}
    if istable(RPExtraTeams) && #RPExtraTeams != 0 then 
        for k,v in pairs(RPExtraTeams) do 
            RealisticPropertiesDPanelJob = vgui.Create("DButton", RealisticPropertiesDscrollJob)
            RealisticPropertiesDPanelJob:SetSize(0,RpRespY*0.03)
            RealisticPropertiesDPanelJob:SetText(v.name)
            RealisticPropertiesDPanelJob:SetFont("rps_font_13")
            RealisticPropertiesDPanelJob:SetTextColor(Realistic_Properties.Colors["white"])
            RealisticPropertiesDPanelJob:Dock(TOP)
            RealisticPropertiesDPanelJob:DockMargin(0,1,0,0)
            RealisticPropertiesDPanelJob.Paint = function(self,w,h)
                if not table.HasValue(RealisticPropertiesCantBuyJob, v.name) then 
                    draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
                    surface.SetDrawColor( Realistic_Properties.Colors["green"])
                    surface.DrawOutlinedRect( 0, 0, w, h )
                else 
                    draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
                    surface.SetDrawColor( Realistic_Properties.Colors["red"])
                    surface.DrawOutlinedRect( 0, 0, w, h )
                end 
            end 
            RealisticPropertiesDPanelJob.DoClick = function()
                if not table.HasValue(RealisticPropertiesCantBuyJob, v.name) then 
                    RealisticPropertiesCantBuyJob[#RealisticPropertiesCantBuyJob + 1] = v.name 
                else 
                    table.RemoveByValue(RealisticPropertiesCantBuyJob, v.name)
                end 
            end 
        end 
    end 
    
    if istable(RealisticPropertiesTable["RealisticPropertiesCantBuyJob"]) then 
        for k,v in pairs(RealisticPropertiesTable["RealisticPropertiesCantBuyJob"]) do 
            RealisticPropertiesCantBuyJob[#RealisticPropertiesCantBuyJob + 1] = v
        end 
    end 

    local RealisticPropertiesButtonAccept = vgui.Create("DButton", RealisticPropertiesFrame)
    RealisticPropertiesButtonAccept:SetSize(RpRespX*0.08, RpRespY*0.03)
    RealisticPropertiesButtonAccept:SetPos(RpRespX*0.172,RpRespY*0.26)
    RealisticPropertiesButtonAccept:SetText(Realistic_Properties.GetSentence("accept"))
    RealisticPropertiesButtonAccept:SetFont("rps_font_3")
    RealisticPropertiesButtonAccept:SetTextColor(Realistic_Properties.Colors["white"])
    RealisticPropertiesButtonAccept.Paint = function(self,w,h)
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
    end 
    RealisticPropertiesButtonAccept.DoClick = function()
        local RealisticPropertiesNumber = tonumber(RealisticPropertiesDTextEntry2:GetValue())
        if RealisticPropertiesDCombobox1:GetValue() == Realistic_Properties.GetSentence("propertiesCanRent") then 
            RealisticPropertiesLocationId = 1 
        elseif RealisticPropertiesDCombobox1:GetValue() == Realistic_Properties.GetSentence("propertiesCantRent") then
            RealisticPropertiesLocationId = 2
        end 

        if isstring(RealisticPropertiesTable["RealisticPropertiesName"]) and IsValid(RealisticPropertiesDCombobox3) then
            if RealisticPropertiesDTextEntry1:GetValue() ~= RealisticPropertiesTable["RealisticPropertiesName"] and CheckIfExist(RealisticPropertiesTableAll, RealisticPropertiesDTextEntry1:GetValue()) then
                Realistic_Properties.SendNotify(Realistic_Properties.GetSentence("propertyNameAlreadyTaken"), 3)
                return
            end
        elseif CheckIfExist(RealisticPropertiesTableAll, RealisticPropertiesDTextEntry1:GetValue()) then
            Realistic_Properties.SendNotify(Realistic_Properties.GetSentence("propertyNameAlreadyTaken"), 3)
            return
        end

        if isstring(RealisticPropertiesDTextEntry1:GetValue()) && isnumber(RealisticPropertiesNumber) && istable(RealisticPropertiesTable) && isstring(RealisticPropertiesDCombobox2:GetValue()) then 
           if RealisticPropertiesDTextEntry1:GetValue() != " "..Realistic_Properties.GetSentence("propertyName") && RealisticPropertiesDCombobox2:GetValue() != Realistic_Properties.GetSentence("propertyType") && RealisticPropertiesDCombobox1:GetValue() != Realistic_Properties.GetSentence("propertyLocation") then 
                if tonumber(RealisticPropertiesDTextEntry2:GetValue()) < 999999999 then 
                    if tonumber(RealisticPropertiesDTextEntry2:GetValue()) > 0 then 
                        if string.len(string.Trim(RealisticPropertiesDTextEntry1:GetValue())) >= 3 then 
                            if string.len(string.Trim(RealisticPropertiesDTextEntry1:GetValue())) <= 20 then 
                                local RealisticPropertiesDoorId = {}
                                if not RealisticPropertiesEditProperties then 
                                    if istable(RealisticPropertiesTable["RealisticPropertiesDoors"]) then 
                                        for k, v in pairs(RealisticPropertiesTable["RealisticPropertiesDoors"]) do 
                                            table.insert(RealisticPropertiesDoorId, v:EntIndex())
                                        end 
                                    end 
                                    RealisticPropertiesDoorId = RealisticPropertiesDoorId 
                                else 
                                    RealisticPropertiesDoorId = RealisticPropertiesTable["RealisticPropertiesDoorId"]
                                end 
                                RealisticPropertiesBlacklistTable = {}
                                if istable(RealisticPropertiesTable["RealisticPropertiesBlacklist"]) && #RealisticPropertiesTable["RealisticPropertiesBlacklist"] != 0 then 
                                    RealisticPropertiesBlacklistTable = RealisticPropertiesTable["RealisticPropertiesBlacklist"] 
                                end 

                                local RealisticPropertiesTableToSave = {
                                    RealisticPropertiesName = RealisticPropertiesDTextEntry1:GetValue(),
                                    RealisticPropertiesPrice = tonumber(RealisticPropertiesDTextEntry2:GetValue()), 
                                    RealisticPropertiesDelivery = RealisticPropertiesTable["RealisticPropertiesDelivery"], 
                                    RealisticPropertiesboxMax = RealisticPropertiesTable["RealisticPropertiesboxMax"], 
                                    RealisticPropertiesboxMins = RealisticPropertiesTable["RealisticPropertiesboxMins"], 
                                    RealisticPropertiesCam = RealisticPropertiesTable["RealisticPropertiesCam"], 
                                    RealisticPropertiesDoorId = RealisticPropertiesDoorId, 
                                    RealisticPropertiesType = RealisticPropertiesDCombobox2:GetValue(), 
                                    RealisticPropertiesLocationId = RealisticPropertiesLocationId, 
                                    RealisticPropertiesBuy = false, 
                                    RealisticPropertiesLocation = 0, 
                                    RealisticPropertiesOwner = "", 
                                    RealisticPropertiesCoOwner = {}, 
                                    RealisticPropertiesOwnerName = "", 
                                    RealisticPropertiesCantBuyJob = RealisticPropertiesCantBuyJob,
                                    RealisticPropertiesBlacklist = RealisticPropertiesBlacklistTable,
                                }

                                net.Start("RealisticProperties:PropertiesAdd")
                                    net.WriteTable(RealisticPropertiesTableToSave)
                                    net.WriteTable(RealisticPropertiesBlacklistTable)
                                net.SendToServer()

                                RealisticPropertiesFrameBase:Remove()
                                if RealisticPropertiesEditProperties then 
                                    if isnumber(RealisticPropertiesIdDelete) then 
                                        timer.Simple(0.1, function()
                                            net.Start("RealisticProperties:PropertiesRemove")
                                            net.WriteUInt(RealisticPropertiesIdDelete, 32)
                                            net.SendToServer()
                                        end ) 
                                    end 
                                end 
                            else 
                                Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("textLimit"), 3 )   
                            end
                        else 
                            Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("minimalText"), 3 )   
                        end 
                    else 
                        Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("minimalPrice"), 3 )
                    end 
                else 
                    Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("priceLimit"), 3 )
                end 
            end 
        end
        timer.Simple(0.5, function()
            RunConsoleCommand("rps_reloadentities") -- Reload Table for the Configuration Menu
        end ) 
    end 

    local RealisticPropertiesButtonDelete = vgui.Create("DButton", RealisticPropertiesFrame)
    RealisticPropertiesButtonDelete:SetSize(RpRespX*0.08, RpRespY*0.03)
    RealisticPropertiesButtonDelete:SetPos(RpRespX*0.255,RpRespY*0.26)
    RealisticPropertiesButtonDelete:SetText(Realistic_Properties.GetSentence("delete"))
    RealisticPropertiesButtonDelete:SetFont("rps_font_3")
    RealisticPropertiesButtonDelete:SetTextColor(Realistic_Properties.Colors["white"])
    RealisticPropertiesButtonDelete.Paint = function(self,w,h)
        draw.RoundedBox(2, 0, 0, w, h, Realistic_Properties.Colors["black5"] )
    end 
    RealisticPropertiesButtonDelete.DoClick = function()
        RealisticPropertiesFrameBase:Remove()
        if IsValid(RealisticPropertiesDCombobox3) then 
            if RealisticPropertiesDCombobox3:GetValue() != Realistic_Properties.GetSentence("propertiesList") then 
                net.Start("RealisticProperties:PropertiesRemove")
                net.WriteUInt(RealisticPropertiesIdDelete, 32)
                net.SendToServer()
            end
        end 
        RunConsoleCommand("rps_reloadentities") -- Reload Table for the Configuration Menu
    end 
end ) 

local function RealistPropertiesComputerView(ply, pos, angles, fov)
    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true
    return view
end

net.Receive("RealisticProperties:SendTable", function()
    local Number = net.ReadInt(32)
    local RPSInformationDecompress = util.Decompress(net.ReadData(Number)) or {}
    RealisticPropertiesTable = util.JSONToTable(RPSInformationDecompress)
end ) 

local function GenerateRenderView(RealisticPropertiesId, Cam)
    local RenderTarget = GetRenderTarget( "rpscam"..Cam..RealisticPropertiesId, 1024,1024)
    render.PushRenderTarget( RenderTarget )
        cam.Start2D()
            -- Clear the RT
            render.Clear( 0, 0, 0, 0 )

            render.RenderView( {
                origin = RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesCam"][Cam],
                angles = RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesCam"][Cam + 1],
                w = w, h = h,
                drawhud = false, 
            } )

        cam.End2D()
    render.PopRenderTarget()
    RPSTexture = CreateMaterial( "rpscam"..Cam..RealisticPropertiesId, "UnlitGeneric", {
        ["$basetexture"] = RenderTarget:GetName()
    } )
    return RPSTexture 
end 

local RpRespX, RpRespY = ScrW(), ScrH()
local RPPosX, RPPosY =  0,0 
function Realistic_Properties.OpenMenu(Posx, Posy, W, H)
    RpRespX, RpRespY = W, H
    RPPosX, RPPosY = Posx,Posy
    net.Start("RealisticProperties:BuySellProperties")
        net.WriteString("OpenMenu")
    net.SendToServer()
end 

local FontTable = {}
function Realistic_Properties.Fonts(SizeId, CFont, Weight)
    if table.HasValue(FontTable, "rps_generate"..math.Round( SizeId, 0 )) then 
        return "rps_generate"..math.Round( SizeId, 0 )
    end 
    surface.CreateFont("rps_generate"..math.Round( SizeId, 0 ), {
        font = CFont, 
        size = math.Round( SizeId ), 
        weight = Weight,
        antialias = true,
        extended = true, 
    })
    table.insert(FontTable, "rps_generate"..math.Round( SizeId, 0 ))
end 

local RPSTableRender = {} 
net.Receive("RealisticProperties:BuySellProperties", function() -- Main Menu 
    if IsValid(RealisticPropertiesBaseFrame) then RealisticPropertiesBaseFrame:Remove() end 
    local RealisticPropertiesEnt = net.ReadEntity()
    local Number = net.ReadInt(32)
    local RPSInformationDecompress = util.Decompress(net.ReadData(Number)) or {}
    RealisticPropertiesTable = util.JSONToTable(RPSInformationDecompress)
    local RealisticPropertiesTableEnt = net.ReadTable() or {}
    local RealisticPropertiesInt = net.ReadInt(2) or nil
    local RealisticPropertiesCount = net.ReadInt(32) or nil
    local RPSBool = net.ReadBool()

	local RealisticPropertiesAngle = RealisticPropertiesEnt:GetAngles() + Angle(-RealisticPropertiesEnt:GetAngles().pitch * 2, 180,-RealisticPropertiesEnt:GetAngles().roll *2)
	local RealisticPropertiesAng = RealisticPropertiesEnt:GetAngles()
	local RealisticPropertiesPos = RealisticPropertiesEnt:GetPos() + RealisticPropertiesAng:Up() * 19.5 + RealisticPropertiesAng:Right() * -1 + RealisticPropertiesAng:Forward() * 8
	local RealisticPropertiesStartTime = CurTime()
    local RealisticPropertiesId = 1 
    local RealisticPropertiesIdChoose = 1  
    RealisticPropertiesTheme = Realistic_Properties.DefaultTheme 
    RealisticPropertiesPrice = 0 

    if not file.Exists("propertiestheme.txt", "DATA") then 
        file.Write("propertiestheme.txt", Realistic_Properties.DefaultTheme)
    end 

    if file.Exists("propertiestheme.txt", "DATA") then 
        if file.Read("propertiestheme.txt", "DATA") == "darktheme" or file.Read("propertiestheme.txt", "DATA") == "lighttheme" then 
            RealisticPropertiesTheme = file.Read("propertiestheme.txt", "DATA")
        end 
    else 
        RealisticPropertiesTheme = Realistic_Properties.DefaultTheme
    end 
    
    for k,v in pairs(RealisticPropertiesTable) do 
        if not table.HasValue(RealisticPropertiesTableEnt, v.RealisticPropertiesName) && not RealisticPropertiesTable[k]["RealisticPropertiesBuy"] or RealisticPropertiesTable[k]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then 
            RealisticPropertiesId = k 
            break 
        end
    end 

    LocalPlayer():SetNoDraw(true)

    hook.Add("CalcView", "RealisticPropertiesCalcView", function(ply, pos, angles, fov) 
        local FOV = 90 
        if RealisticPropertiesInt != 0 then 
            RealisticPropertiesAngleOrigin = LerpVector( math.Clamp(CurTime()-RealisticPropertiesStartTime,0,1), LocalPlayer():EyePos(), RealisticPropertiesPos)
            RealisticPropertiesAngleAngles = LerpAngle( math.Clamp(CurTime()-RealisticPropertiesStartTime,0,1), LocalPlayer():GetAngles(), RealisticPropertiesAngle)
            FOV = 90 
        else 
            RealisticPropertiesAngleOrigin = pos
            RealisticPropertiesAngleAngles = angles
            FOV = fov
        end 
        return RealistPropertiesComputerView(LocalPlayer(), RealisticPropertiesAngleOrigin, RealisticPropertiesAngleAngles, FOV)
    end )

    RPSTableRender[RealisticPropertiesId] = RPSTableRender[RealisticPropertiesId] or {}
    if not RPSTableRender[RealisticPropertiesId][1] then
        RPSTableRender[RealisticPropertiesId][1] = GenerateRenderView(RealisticPropertiesId, 1)
    end
    if not RPSTableRender[RealisticPropertiesId][2] then
        RPSTableRender[RealisticPropertiesId][2] = GenerateRenderView(RealisticPropertiesId, 2)
    end
    if not RPSTableRender[RealisticPropertiesId][3] then
        RPSTableRender[RealisticPropertiesId][3] = GenerateRenderView(RealisticPropertiesId, 3)
    end

	RealisticPropertiesPrice = RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"] 
    RealisticPropertiesBaseFrame = vgui.Create("DFrame")
	RealisticPropertiesBaseFrame:SetSize(RpRespX, RpRespY)
	RealisticPropertiesBaseFrame:MakePopup()
	RealisticPropertiesBaseFrame:ShowCloseButton(false)
	RealisticPropertiesBaseFrame:SetDraggable(false)
	RealisticPropertiesBaseFrame:SetTitle("")
    RealisticPropertiesBaseFrame.Paint = function() end 
    if not RPSBool then 
        RpRespX, RpRespY = ScrW(), ScrH() 
        RealisticPropertiesBaseFrame:SetSize(RpRespX, RpRespY)
        RealisticPropertiesBaseFrame:SetPos(0, 0)
    else 
       RealisticPropertiesBaseFrame:SetPos(RPPosX, RPPosY) 
    end     

    timer.Simple(RealisticPropertiesInt, function()
        local RealisticPropertiesFrame = vgui.Create("DPanel", RealisticPropertiesBaseFrame) 
        RealisticPropertiesFrame:SetSize(RpRespX*0.794, RpRespY*0.792)
        RealisticPropertiesFrame:SetPos(RpRespX*0.1, RpRespY*0.06)
        RealisticPropertiesFrame.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors[RealisticPropertiesTheme]["whitegray"])
            draw.RoundedBox(0, 0, h*0.05, w, h*0.09, Realistic_Properties.Colors[RealisticPropertiesTheme]["lightblue"])
            draw.RoundedBox(0, w*0.025, h*0.18, w*0.29, h*0.781, Realistic_Properties.Colors[RealisticPropertiesTheme]["white240"])
            draw.RoundedBox(0, w*0.328, h*0.18, w*0.505, h*0.781, Realistic_Properties.Colors[RealisticPropertiesTheme]["white240"])
            draw.RoundedBox(0, w*0.855, h*0.1399, w*0.5, h*0.9, Realistic_Properties.Colors[RealisticPropertiesTheme]["white240"])
            surface.SetDrawColor( Realistic_Properties.Colors[RealisticPropertiesTheme]["white"] )
            surface.SetMaterial(Material("rps_materials1.jpg"))
            surface.DrawTexturedRect( 0, 0, RealisticPropertiesFrame:GetWide(), h*0.05)
            draw.DrawText("♔ "..string.upper(Realistic_Properties.GetSentence("realisticPropeties")), Realistic_Properties.Fonts(RpRespY*0.04, "Arial Black", 500), w*0.02, h*0.069, Realistic_Properties.Colors[RealisticPropertiesTheme]["white"], TEXT_ALIGN_LEFT)
            draw.DrawText("☎ "..string.upper(RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesName"]), Realistic_Properties.Fonts(RpRespY*0.04, "Arial Black", 0), w*0.58, h*0.19, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_CENTER)    
            surface.SetDrawColor( Realistic_Properties.Colors[RealisticPropertiesTheme]["white"] )
            surface.SetMaterial(Material("rps_materials2.png"))
            surface.DrawTexturedRect( w*0.035, h*0.5425, RpRespX*0.01717, RpRespY*0.196)
            draw.DrawText(Realistic_Properties.GetSentence("price").." : "..DarkRP.formatMoney(RealisticPropertiesPrice), Realistic_Properties.Fonts(RpRespY*0.03, "Righteous", 0), w*0.065, h*0.542, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_LEFT)    
            if istable(RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"]) then 
                draw.DrawText(Realistic_Properties.GetSentence("doorAmount").." : "..table.Count(RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"]), Realistic_Properties.Fonts(RpRespY*0.03, "Righteous", 0), w*0.065, h*0.6095, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_LEFT)
            else
                draw.DrawText(Realistic_Properties.GetSentence("doorAmount").." : 1", Realistic_Properties.Fonts(RpRespY*0.03, "Righteous", 0), w*0.04, h*0.6095, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_LEFT)
            end 
            if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesLocationId"] == 1 then 
                draw.DrawText(Realistic_Properties.GetSentence("location"), Realistic_Properties.Fonts(RpRespY*0.03, "Righteous", 0), w*0.065, h*0.678, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_LEFT)
            else
                draw.DrawText(Realistic_Properties.GetSentence("noLocation"), Realistic_Properties.Fonts(RpRespY*0.03, "Righteous", 0), w*0.065, h*0.678, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_LEFT)
            end  
            draw.DrawText(Realistic_Properties.GetSentence("type").." : "..RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesType"], Realistic_Properties.Fonts(RpRespY*0.03, "Righteous", 0), w*0.065, h*0.748, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_LEFT) 
        end 

        RealisticPropertiesRent(RealisticPropertiesTable, RealisticPropertiesId, RealisticPropertiesFrame) 

        local RealisticPropertiesFrameCam1 = vgui.Create( "DFrame", RealisticPropertiesBaseFrame )
        RealisticPropertiesFrameCam1:SetSize( RpRespX*0.21, RpRespY*0.24 )
        RealisticPropertiesFrameCam1:SetPos( RpRespX*0.13, RpRespY*0.22)
        RealisticPropertiesFrameCam1:SetDraggable(false)
        RealisticPropertiesFrameCam1:ShowCloseButton(false)
        RealisticPropertiesFrameCam1:SetTitle("")
        function RealisticPropertiesFrameCam1:Paint( w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( RPSTableRender[RealisticPropertiesId][1] )
            surface.DrawTexturedRect( 0, h/2-w/2, w, w )
        end

        local RealisticPropertiesFrameCam2 = vgui.Create( "DFrame", RealisticPropertiesBaseFrame )
        RealisticPropertiesFrameCam2:SetSize( RpRespX*0.38, RpRespY*0.38 )
        RealisticPropertiesFrameCam2:SetPos( RpRespX*0.37, RpRespY*0.26)
        RealisticPropertiesFrameCam2:SetDraggable(false)
        RealisticPropertiesFrameCam2:ShowCloseButton(false)
        RealisticPropertiesFrameCam2:SetTitle("")
        function RealisticPropertiesFrameCam2:Paint( w, h )
            surface.SetDrawColor( color_white )
            surface.SetMaterial( RPSTableRender[RealisticPropertiesId][RealisticPropertiesIdChoose] )
            surface.DrawTexturedRect( 0, h/2-w/2, w, w )
        end
        
        for i=1, 3 do 
            local RealisticPropertiesFrameCam3 = vgui.Create( "DFrame", RealisticPropertiesBaseFrame )
            RealisticPropertiesFrameCam3:SetSize( RpRespX*0.12, RpRespY*0.13 )

            local RealisticPropertiesButtonImage = vgui.Create("DButton", RealisticPropertiesBaseFrame)
            RealisticPropertiesButtonImage:SetSize( RpRespX*0.12, RpRespY*0.13 )
            RealisticPropertiesButtonImage:SetText("")
            RealisticPropertiesButtonImage.Paint = function() end 
            RealisticPropertiesButtonImage.DoClick = function() 
                RealisticPropertiesClic()
                RealisticPropertiesIdChoose = i 
            end 

            if i == 1 then 
                RealisticPropertiesFrameCam3:SetPos( RpRespX*0.37, RpRespY*0.666)
                RealisticPropertiesButtonImage:SetPos( RpRespX*0.37, RpRespY*0.666)
            elseif i == 2 then 
                RealisticPropertiesFrameCam3:SetPos( RpRespX*0.5, RpRespY*0.666)
                RealisticPropertiesButtonImage:SetPos( RpRespX*0.5, RpRespY*0.666)
            elseif i == 3 then 
                RealisticPropertiesFrameCam3:SetPos( RpRespX*0.63, RpRespY*0.666)
                RealisticPropertiesButtonImage:SetPos( RpRespX*0.63, RpRespY*0.666)
            end 
            
            RealisticPropertiesFrameCam3:SetDraggable(false)
            RealisticPropertiesFrameCam3:ShowCloseButton(false)
            RealisticPropertiesFrameCam3:SetTitle("")
            
            if i == 1 then 
                function RealisticPropertiesFrameCam3:Paint( w, h )
                    surface.SetDrawColor( color_white )
                    surface.SetMaterial( RPSTableRender[RealisticPropertiesId][1] )
                    surface.DrawTexturedRect( 0, h/2-w/2, w, w )
                end
            elseif i == 2 then 
                function RealisticPropertiesFrameCam3:Paint( w, h )
                    surface.SetDrawColor( color_white )
                    surface.SetMaterial( RPSTableRender[RealisticPropertiesId][2] )
                    surface.DrawTexturedRect( 0, h/2-w/2, w, w )
                end
            elseif i == 3 then 
                function RealisticPropertiesFrameCam3:Paint( w, h )
                    surface.SetDrawColor( color_white )
                    surface.SetMaterial( RPSTableRender[RealisticPropertiesId][3] )
                    surface.DrawTexturedRect( 0, h/2-w/2, w, w )
                end
            end 
        end

        RealisticPropertiesButtonBuy = vgui.Create("DButton", RealisticPropertiesBaseFrame)
        RealisticPropertiesButtonBuy:SetSize(RpRespX*0.21, RpRespY*0.07)
        RealisticPropertiesButtonBuy:SetPos(RpRespX*0.13, RpRespY*0.726)
        RealisticPropertiesButtonBuy:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["white"])
        RealisticPropertiesButtonBuy:SetText(string.upper(Realistic_Properties.GetSentence("buy")))
        RealisticPropertiesButtonBuy:SetFont("rps_font_4")
        RealisticPropertiesButtonBuy.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors[RealisticPropertiesTheme]["lightgreen"])
        end 
        
        RealisticPropertiesButtonBuy.DoClick = function()
            if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == true then 
                if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then 
                    RealisticPropertiesClic()  
                    RealisticPropertiesBaseFrame:Remove()
                    LocalPlayer():SetNoDraw(false)
                    hook.Remove("CalcView", "RealisticPropertiesCalcView")
                    net.Start("RealisticProperties:BuySellProperties")
                    net.WriteString("SellProperties")
                    net.WriteUInt(RealisticPropertiesId, 32)
                    net.SendToServer()
                else 
                    Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("propertySold"), 3 )
                end   
                RealisticPropertiesDoor1 = nil
                RealisticPropertiesDoor2 = nil 
            elseif RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == false then 
                if istable(RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesCantBuyJob"]) then 
                    if table.HasValue(RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesCantBuyJob"], team.GetName(LocalPlayer():Team())) then Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("noGoodJobToBuyProperty"), 3 ) return end 
                end
                if RealisticPropertiesCount < Realistic_Properties.MaxProperties then 
                    if RealisticPropertiesButtonBuy:GetText() != string.upper(Realistic_Properties.GetSentence("rent")) then 
                        if LocalPlayer():getDarkRPVar("money") >= RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"] then 
                            RealisticPropertiesClic()
                            RealisticPropertiesBaseFrame:Remove()
                            LocalPlayer():SetNoDraw(false)
                            hook.Remove("CalcView", "RealisticPropertiesCalcView")
                            net.Start("RealisticProperties:BuySellProperties")
                            net.WriteString("BuyProperties")
                            net.WriteUInt(RealisticPropertiesId, 32)
                            net.SendToServer()
                            if IsValid(ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][1])) then 
                                RealisticPropertiesDoor1 = ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][1] ):WorldSpaceCenter() + Vector(0,0,20) 
                            end 
                            if #RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"] > 1 then 
                                if IsValid(ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][2])) then 
                                    RealisticPropertiesDoor2 = ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][2] ):WorldSpaceCenter() + Vector(0,0,20)
                                end 
                            end 
                        else 
                            Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("cantAfford"), 3 )
                        end
                    elseif LocalPlayer():getDarkRPVar("money") >= RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"] * ( 1 + (RealisticPropertiesDComboboxRent:GetOptionData(RealisticPropertiesDComboboxRent:GetSelectedID()) /10)) then
                        RealisticPropertiesClic()  
                        RealisticPropertiesBaseFrame:Remove()
                        LocalPlayer():SetNoDraw(false)
                        hook.Remove("CalcView", "RealisticPropertiesCalcView")
                        net.Start("RealisticProperties:BuySellProperties")
                        net.WriteString("RentProperties")
                        net.WriteUInt(RealisticPropertiesId, 32)
                        net.WriteUInt(RealisticPropertiesDComboboxRent:GetOptionData(RealisticPropertiesDComboboxRent:GetSelectedID()), 32)
                        net.SendToServer()
                        if IsValid(ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][1])) then 
                            RealisticPropertiesDoor1 = ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][1] ):WorldSpaceCenter() + Vector(0,0,20) 
                        end 
                        if #RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"] > 1 then 
                            if IsValid(ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][2])) then 
                                RealisticPropertiesDoor2 = ents.GetByIndex( RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesDoorId"][2] ):WorldSpaceCenter() + Vector(0,0,20)
                            end 
                        end 
                    else 
                        Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("cantAfford"), 3 )
                    end 
                else 
                    surface.PlaySound( "buttons/combine_button1.wav" )
                    Realistic_Properties.SendNotify( Realistic_Properties.GetSentence("canOnlyBuy").." "..Realistic_Properties.MaxProperties.." "..Realistic_Properties.GetSentence("property"), 3 )
                end  
            end 
        end   

        local RealisticPropertiesDScroll = vgui.Create("DScrollPanel", RealisticPropertiesBaseFrame)
        RealisticPropertiesDScroll:SetSize(RpRespX*0.11, RpRespY*0.66) 
        RealisticPropertiesDScroll:SetPos(RpRespX*0.782,RpRespY*0.169)
        local RealisticPropertiesBar = RealisticPropertiesDScroll:GetVBar()
        function RealisticPropertiesBar:Paint() end
        function RealisticPropertiesBar.btnUp:Paint() end
        function RealisticPropertiesBar.btnDown:Paint() end
        function RealisticPropertiesBar.btnGrip:Paint(w, h)
            draw.RoundedBox(8, w*0.5, 0, w-10, h, Realistic_Properties.Colors[RealisticPropertiesTheme]["lightblue"])
        end

        if istable(RealisticPropertiesTable) then 
            RealisticPropertiesFrameCamX = {}
            for k, v in pairs(RealisticPropertiesTable) do 
                RealisticPropertiesFrameCamX[k] = vgui.Create( "DPanel", RealisticPropertiesDScroll)
                RealisticPropertiesFrameCamX[k]:SetSize( RpRespX*0.1, RpRespY*0.1 )
                RealisticPropertiesFrameCamX[k]:Dock(TOP)
                RealisticPropertiesFrameCamX[k]:DockMargin(0, 8, 0, 0)
                RealisticPropertiesFrameCamX[k]:SetText(RealisticPropertiesTable[k]["RealisticPropertiesName"])
                RealisticPropertiesFrameCamX[k].Paint = function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w-2, h, Realistic_Properties.Colors[RealisticPropertiesTheme]["whitegray"])
                    if RealisticPropertiesTable[k]["RealisticPropertiesBuy"] == true then 
                        if RealisticPropertiesTable[k]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then  
                            surface.SetDrawColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["lightblue"])
							surface.DrawOutlinedRect( 0, 0, w, h )
                        end 
                    end 
                    draw.DrawText(string.upper(RealisticPropertiesTable[k]["RealisticPropertiesName"]), Realistic_Properties.Fonts(RpRespY*0.02, "Righteous", 0), RealisticPropertiesFrameCamX[k]:GetWide()/2, RpRespY*0.01, Realistic_Properties.Colors[RealisticPropertiesTheme]["black"], TEXT_ALIGN_CENTER)
                    draw.DrawText("•"..string.upper(Realistic_Properties.GetSentence("price")).." : "..DarkRP.formatMoney(RealisticPropertiesTable[k]["RealisticPropertiesPrice"]).." •", Realistic_Properties.Fonts(RpRespY*0.019, "Righteous", 0), RealisticPropertiesFrameCamX[k]:GetWide()/2.03, RpRespY*0.035, Realistic_Properties.Colors[RealisticPropertiesTheme]["black330"], TEXT_ALIGN_CENTER)     
                end

                if table.HasValue(RealisticPropertiesTableEnt, RealisticPropertiesTable[k]["RealisticPropertiesName"]) then 
                    RealisticPropertiesFrameCamX[k]:SetVisible(false)
                end 

                if RealisticPropertiesTable[k]["RealisticPropertiesBuy"] && RealisticPropertiesTable[k]["RealisticPropertiesOwner"] != LocalPlayer():SteamID64() then 
                    RealisticPropertiesFrameCamX[k]:SetVisible(false)
                end 
                
                local RealisticPropertiesButtonView = vgui.Create("DButton", RealisticPropertiesFrameCamX[k])
                RealisticPropertiesButtonView:SetSize(RpRespX*0.08, RpRespY*0.022)
                RealisticPropertiesButtonView:Dock(BOTTOM)
                RealisticPropertiesButtonView:DockMargin(20,0,20,10)
                RealisticPropertiesButtonView:SetText(Realistic_Properties.GetSentence("see"))
                RealisticPropertiesButtonView:SetFont("rps_font_7")
                RealisticPropertiesButtonView:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["white"])
                RealisticPropertiesButtonView.Paint = function(self,w,h)
                    draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors[RealisticPropertiesTheme]["lightgreen"])
                end 
                RealisticPropertiesButtonView.DoClick = function()
                    RealisticPropertiesId = k 
                    RealisticPropertiesIdChoose = 1
                    RealisticPropertiesPrice = RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"] 
                    RealisticPropertiesClic()
                    RealisticPropertiesRent(RealisticPropertiesTable, RealisticPropertiesId, RealisticPropertiesFrame) 
                    RealisticPropertiesOwner(RealisticPropertiesTable, RealisticPropertiesFrame, RealisticPropertiesId)
                    if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == true then 
                        if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then  
                            RealisticPropertiesButtonBuy:SetText(Realistic_Properties.GetSentence("sell"))
                        else 
                            RealisticPropertiesButtonBuy:SetText(Realistic_Properties.GetSentence("sold"))
                        end 
                    else 
                        RealisticPropertiesButtonBuy:SetText(string.upper(Realistic_Properties.GetSentence("buy")))
                    end 
                    if not istable(RPSTableRender[RealisticPropertiesId]) then 
                        RPSTableRender[RealisticPropertiesId] = {
                            [1] = GenerateRenderView(RealisticPropertiesId, 1), 
                            [2] = GenerateRenderView(RealisticPropertiesId, 3), 
                            [3] = GenerateRenderView(RealisticPropertiesId, 5), 
                        }
                    else 
                        RPSTableRender[RealisticPropertiesId] = {
                            [1] = RPSTableRender[RealisticPropertiesId][1], 
                            [2] = RPSTableRender[RealisticPropertiesId][2], 
                            [3] = RPSTableRender[RealisticPropertiesId][3], 
                        }
                    end 
                end

                local RealisticPropertiesSearch = vgui.Create("DTextEntry", RealisticPropertiesBaseFrame)
                RealisticPropertiesSearch:SetSize(ScrW()*0.11, ScrH()*0.032) 
                RealisticPropertiesSearch:SetPos(ScrW()*0.78, ScrH()*0.13)
                RealisticPropertiesSearch:SetDrawLanguageID(false)
                RealisticPropertiesSearch:SetPlaceholderColor( Realistic_Properties.Colors[RealisticPropertiesTheme]["black"] )
                RealisticPropertiesSearch:SetValue(Realistic_Properties.GetSentence("search"))
                RealisticPropertiesSearch:SetFont( "rps_font_7" )
                function RealisticPropertiesSearch:Paint( w, h )
                    RealisticPropertiesSearch:SetFont( Realistic_Properties.Fonts(RpRespY*0.024, "Righteous", 0) )
                    surface.SetDrawColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["white"])
                    surface.DrawRect( 0, 0, w, h )

                    if ( self.GetPlaceholderText && self.GetPlaceholderColor && self:GetPlaceholderText() && self:GetPlaceholderText():Trim() != "" && self:GetPlaceholderColor() && ( !self:GetText() || self:GetText() == "" ) ) then
                        local oldText = self:GetText()
                        local str = self:GetPlaceholderText()
                        if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
                        self:SetText( str )
                        self:DrawTextEntryText( self:GetPlaceholderColor(), self:GetHighlightColor(), Realistic_Properties.Colors[RealisticPropertiesTheme]["white"] )
                        self:SetText( oldText )
                        return
                    end
                    self:DrawTextEntryText( self:GetTextColor(), self:GetHighlightColor(), Realistic_Properties.Colors[RealisticPropertiesTheme]["black"] )
                end
                RealisticPropertiesSearch.OnGetFocus = function(self) 
                    if RealisticPropertiesSearch:GetText() == Realistic_Properties.GetSentence("search") then 
                        RealisticPropertiesSearch:SetText("") 
                    end 
                end 
                RealisticPropertiesSearch.OnLoseFocus = function(self)
                    if RealisticPropertiesSearch:GetText() == "" then  
                        RealisticPropertiesSearch:SetText(Realistic_Properties.GetSentence("search"))
                    end
                end 
                
                function RealisticPropertiesSearch:OnChange()
                    for k, v in pairs( RealisticPropertiesTable ) do
                        if string.StartWith( string.lower( v.RealisticPropertiesName ), string.lower( self:GetText() ) ) then
                            if not RealisticPropertiesTable[k]["RealisticPropertiesBuy"] or  RealisticPropertiesTable[k]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then 
                                RealisticPropertiesFrameCamX[k]:SetVisible( true )
                            end 
                        else
                            if not RealisticPropertiesTable[k]["RealisticPropertiesOwner"] != LocalPlayer():SteamID64() then 
                                RealisticPropertiesFrameCamX[k]:SetVisible( false )
                            end 
                        end
                    end
                    RealisticPropertiesDScroll:InvalidateChildren( true )
                end
            end 
        end
                
        RealisticPropertiesOwner(RealisticPropertiesTable, RealisticPropertiesFrame, RealisticPropertiesId)
        if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == true then 
            if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then  
                RealisticPropertiesButtonBuy:SetText(Realistic_Properties.GetSentence("sell"))
            else 
                RealisticPropertiesButtonBuy:SetText(Realistic_Properties.GetSentence("sold"))
            end 
        else 
            RealisticPropertiesButtonBuy:SetText(string.upper(Realistic_Properties.GetSentence("buy")))
        end 

        RealisticPropertiesTheme = RealisticPropertiesTheme

        local RealisticPropertiesChangeTheme = vgui.Create("DButton", RealisticPropertiesBaseFrame)
        if #RealisticPropertiesTable < 6 then 
            RealisticPropertiesChangeTheme:SetSize(RpRespX*0.108, RpRespY*0.025)
        else
            RealisticPropertiesChangeTheme:SetSize(RpRespX*0.102, RpRespY*0.025)
        end 
        RealisticPropertiesChangeTheme:SetPos(RpRespX*0.782, RpRespY*0.82)
        RealisticPropertiesChangeTheme:SetText("Change Theme")
        RealisticPropertiesChangeTheme:SetFont("rps_font_7")
        RealisticPropertiesChangeTheme:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["black"])
        RealisticPropertiesChangeTheme.DoClick = function()
            if RealisticPropertiesTheme == "lighttheme" then 
                RealisticPropertiesTheme = "darktheme"
                file.Write("propertiestheme.txt", RealisticPropertiesTheme)
            else 
                RealisticPropertiesTheme = "lighttheme"
                file.Write("propertiestheme.txt", RealisticPropertiesTheme)
            end 
            if IsValid(RealisticPropertiesDComboboxRent) then 
                RealisticPropertiesDComboboxRent:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["black"])
            end 
            RealisticPropertiesChangeTheme:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["black"])
            RealisticPropertiesTheme = RealisticPropertiesTheme 
        end
        RealisticPropertiesChangeTheme.Paint = function(self,w,h)
            RealisticPropertiesChangeTheme:SetFont( Realistic_Properties.Fonts(RpRespY*0.02, "Righteous", 0) )
            draw.RoundedBox(0,0,0,w,h,Realistic_Properties.Colors[RealisticPropertiesTheme]["whitegray"])
        end 

        if IsValid(RealisticPropertiesDComboboxRent) then 
            RealisticPropertiesDComboboxRent:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["black"])
        end 
        
        local RealisticPropertiesButtonClose = vgui.Create("DButton", RealisticPropertiesFrame)
        RealisticPropertiesButtonClose:SetSize(RpRespX*0.02, RpRespY*0.03)
        RealisticPropertiesButtonClose:SetPos(RealisticPropertiesFrame:GetWide()*0.973, RealisticPropertiesFrame:GetTall()*0.008)
        RealisticPropertiesButtonClose:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["white"])
        RealisticPropertiesButtonClose:SetText("")
        RealisticPropertiesButtonClose.Paint = function() end 
        RealisticPropertiesButtonClose.DoClick = function()
            RealisticPropertiesClic()
            RealisticPropertiesBaseFrame:Remove()
            LocalPlayer():SetNoDraw(false)
            net.Start("RealisticProperties:Halos") -- Reset FOV
            net.SendToServer()
            hook.Remove("CalcView", "RealisticPropertiesCalcView")
        end 
    end ) 
end )

net.Receive("RealisticProperties:DeliveryMenu", function() -- Delivery menu 
    local Number = net.ReadInt(32)
    local RPSInformationDecompress = util.Decompress(net.ReadData(Number)) or {}
    RealisticPropertiesBaseTable = util.JSONToTable(RPSInformationDecompress)
    local RealisticPropertiesTableInfo = net.ReadTable() or {}
    local RealisticPropertiesTableOwner = net.ReadTable() or {}
    local RpRespX, RpRespY = ScrW(), ScrH()
    
    local RealisticPropertiesBaseFrame = vgui.Create("DFrame")
    RealisticPropertiesBaseFrame:SetSize(RpRespX*0.22, RpRespY*0.44)
    RealisticPropertiesBaseFrame:Center()
    RealisticPropertiesBaseFrame:MakePopup()
    RealisticPropertiesBaseFrame:ShowCloseButton(false)
    RealisticPropertiesBaseFrame:SetTitle("")
    RealisticPropertiesBaseFrame:SetDraggable(false)
    RealisticPropertiesBaseFrame.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors["whitegray"])
        draw.RoundedBox(0, 0, 0, w, h*0.12, Realistic_Properties.Colors["lightblue"])
        draw.RoundedBox(0, 0, h*0.12, w, h, Realistic_Properties.Colors["white240"])
        draw.DrawText(Realistic_Properties.GetSentence("deliverySystem"), "rps_font_5", RealisticPropertiesBaseFrame:GetWide()/2, h*0.022, Realistic_Properties.Colors["white"], TEXT_ALIGN_CENTER)
    end 
    
    local RealisticPropertiesModel = vgui.Create( "SpawnIcon", RealisticPropertiesBaseFrame )
    RealisticPropertiesModel:SetSize(RpRespY*0.330,RpRespY*0.330)
    RealisticPropertiesModel:SetPos(RpRespX*0.015, RpRespY*0.05)
	RealisticPropertiesModel:SetModel(RealisticPropertiesTableInfo[table.Count(RealisticPropertiesTableInfo)]["RealisticPropertiesEntModel"])
    RealisticPropertiesModel:SetMouseInputEnabled( false )
	RealisticPropertiesModel:SetKeyboardInputEnabled( false )

    local RealisticPropertiesDScrollPanel = vgui.Create("DScrollPanel", RealisticPropertiesBaseFrame)
    RealisticPropertiesDScrollPanel:SetSize(RpRespX*0.21, RpRespY*0.054)
    RealisticPropertiesDScrollPanel:SetPos(RpRespX*0.005, RpRespY*0.37)
    local RealisticPropertiesBar = RealisticPropertiesDScrollPanel:GetVBar()
    function RealisticPropertiesBar:Paint() end
    function RealisticPropertiesBar.btnUp:Paint() end
    function RealisticPropertiesBar.btnDown:Paint() end
    function RealisticPropertiesBar.btnGrip:Paint(w,h)
        draw.RoundedBox(8, w*0.3, 0, w, h+100, Realistic_Properties.Colors["lightblue"])
    end
    RealisticPropertiesDScrollPanel:GetVBar():SetWide(4)

    RealisticPropertiesPanel = {}
    for k,v in pairs(RealisticPropertiesTableOwner) do
        RealisticPropertiesPanel[k] = vgui.Create("DButton", RealisticPropertiesDScrollPanel)
        RealisticPropertiesPanel[k]:SetSize(RpRespX*0.18, RpRespY*0.05)
        RealisticPropertiesPanel[k]:DockMargin(0,2,0,0)
        RealisticPropertiesPanel[k]:Dock(TOP) 
        RealisticPropertiesPanel[k]:SetText(Realistic_Properties.GetSentence("delivery").." : "..RealisticPropertiesBaseTable[v]["RealisticPropertiesName"])
        RealisticPropertiesPanel[k]:SetFont("rps_font_7")
        RealisticPropertiesPanel[k]:SetTextColor(Realistic_Properties.Colors["white"])
        RealisticPropertiesPanel[k].DoClick = function()
            RealisticPropertiesBaseFrame:Remove()
            net.Start("RealisticProperties:DeliveryMenu")
                net.WriteUInt(v, 32)
            net.SendToServer()
        end 
        RealisticPropertiesPanel[k].Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, Realistic_Properties.Colors["lightgreen"])
        end 
    end
end)

net.Receive("RealisticProperties:Halos", function()
    RealisticPropertiesEnt = net.ReadTable() or {}
end)

net.Receive("RealisticProperties:DeliveryEnt", function()
    RealisticPropertiesEntGhost = net.ReadEntity() or nil 
    local RealisticPropertiesString = net.ReadString() or ""
    RWSEnt = ClientsideModel(RealisticPropertiesString, RENDERGROUP_OPAQUE)
    RWSEnt:SetModel("")
    RWSEnt:SetMaterial("models/wireframe")
    RWSEnt:SetPos(LocalPlayer():GetEyeTrace().HitPos + Vector(0,0,RWSEnt:OBBMaxs().z))
    RWSEnt:SetAngles(Angle(0,0,0))
    RWSEnt:Spawn()
    RWSEnt:Activate()	
    RWSEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
end) 

function RealisticPropertiesRent(RealisticPropertiesTable, RealisticPropertiesId, RealisticPropertiesFrame)
    if IsValid(RealisticPropertiesDComboboxRent) then RealisticPropertiesDComboboxRent:Remove() end 
    if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesLocationId"] == 1 then 
        RealisticPropertiesDComboboxRent = vgui.Create("DComboBox", RealisticPropertiesFrame)
        RealisticPropertiesDComboboxRent:SetSize(RealisticPropertiesFrame:GetWide()*0.082, RealisticPropertiesFrame:GetTall()*0.035)
        RealisticPropertiesDComboboxRent:SetPos(RealisticPropertiesFrame:GetWide()*0.141, RealisticPropertiesFrame:GetTall()*0.685)
        RealisticPropertiesDComboboxRent:SetFont("rps_font_8")
        RealisticPropertiesDComboboxRent:SetValue(Realistic_Properties.GetSentence("buy"))
        RealisticPropertiesDComboboxRent:AddChoice(Realistic_Properties.GetSentence("buy"))
        RealisticPropertiesDComboboxRent:SetSortItems(false)
        RealisticPropertiesDComboboxRent:SetTextColor(Realistic_Properties.Colors[RealisticPropertiesTheme]["black"])
        RealisticPropertiesDComboboxRent.Paint = function(self,w,h) 
            draw.RoundedBox(4, 0, 0, w, h, Realistic_Properties.Colors[RealisticPropertiesTheme]["black5"] )
            draw.RoundedBox(4, 1, 1, w-2, h-2, Realistic_Properties.Colors[RealisticPropertiesTheme]["whitedcombobox"] )
        end 
        for i=2, Realistic_Properties.MaxRentalDay do 
            if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == false then
                RealisticPropertiesDComboboxRent:AddChoice(Realistic_Properties.GetSentence("rent").." "..i.." "..Realistic_Properties.GetSentence("day"),i)
            end 
        end
        RealisticPropertiesDComboboxRent.OnSelect = function(index, value, data)
            if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == false then
                RealisticPropertiesClic()

                if value != 1 then 
                    local valueDay = RealisticPropertiesDComboboxRent:GetOptionData(value)

                    RealisticPropertiesPrice = RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"] + (valueDay*((RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"] * Realistic_Properties.PourcentRent)/100))
                    RealisticPropertiesButtonBuy:SetText((data == Realistic_Properties.GetSentence("permanent")) and string.upper(Realistic_Properties.GetSentence("buy")) or string.upper(Realistic_Properties.GetSentence("rent")))
                else
                    RealisticPropertiesPrice = RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesPrice"]
                    RealisticPropertiesButtonBuy:SetText(string.upper(Realistic_Properties.GetSentence("buy")))
                end 
            end 
        end     
    end  
end 
 
function RealisticPropertiesOwner(RealisticPropertiesTable, RealisticPropertiesFrame, RealisticPropertiesId)
    if IsValid(RealisticPropertiesDCombobox4) then RealisticPropertiesDCombobox4:Remove() end 
    if IsValid(RealisticPropertiesButtonAcceptOwner) then RealisticPropertiesButtonAcceptOwner:Remove() end 
    if IsValid(RealisticPropertiesButtonDeleteOwner) then RealisticPropertiesButtonDeleteOwner:Remove() end 
    local RpRespX, RpRespY = ScrW(), ScrH()

    if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesBuy"] == true then 
        if RealisticPropertiesTable[RealisticPropertiesId]["RealisticPropertiesOwner"] == LocalPlayer():SteamID64() then  
            RealisticPropertiesDCombobox4 = vgui.Create("DComboBox", RealisticPropertiesFrame)
            RealisticPropertiesDCombobox4:SetSize(RpRespX*0.1, RpRespY*0.023)
            RealisticPropertiesDCombobox4:SetText(Realistic_Properties.GetSentence("addOwner"))
            RealisticPropertiesDCombobox4:SetFont("rps_font_8")
            RealisticPropertiesDCombobox4:SetPos(RealisticPropertiesFrame:GetWide()*0.025, RealisticPropertiesFrame:GetTall()*0.144)
            for k,v in pairs(player.GetAll()) do 
                if v != LocalPlayer() then 
                    RealisticPropertiesDCombobox4:AddChoice(v:Name())
                end 
            end 
            RealisticPropertiesDCombobox4.OnSelect = function(index, id, data)
                RealisticPropertiesClic()
                for k,v in pairs(player.GetAll()) do 
                    if string.Trim(v:Name()):lower() == string.Trim(RealisticPropertiesDCombobox4:GetValue()):lower() then RealisticPropertiesEntity = v break end
                end 
            end 
            RealisticPropertiesDCombobox4.Paint = function(self,w,h)
                draw.RoundedBox(6, 0, 0, w, h, Realistic_Properties.Colors["white150"])
            end 

            RealisticPropertiesButtonAcceptOwner = vgui.Create("DButton", RealisticPropertiesFrame)
            RealisticPropertiesButtonAcceptOwner:SetSize(RpRespX*0.0145, RpRespY*0.024)
            RealisticPropertiesButtonAcceptOwner:SetPos(RealisticPropertiesFrame:GetWide()*0.157, RealisticPropertiesFrame:GetTall()*0.145)
            RealisticPropertiesButtonAcceptOwner:SetText("✔")
            RealisticPropertiesButtonAcceptOwner:SetTextColor(Realistic_Properties.Colors["black"])
            RealisticPropertiesButtonAcceptOwner.Paint = function(self,w,h)
                draw.RoundedBox(6, 0, 0, w, h, Realistic_Properties.Colors["white150"])
            end 
            RealisticPropertiesButtonAcceptOwner.DoClick = function()
                RealisticPropertiesClic()
                net.Start("RealisticProperties:BuySellProperties")
                net.WriteString("AddOwner")
                net.WriteEntity(RealisticPropertiesEntity)
                net.WriteUInt(RealisticPropertiesId, 32)
                net.SendToServer()
            end 

            RealisticPropertiesButtonDeleteOwner = vgui.Create("DButton", RealisticPropertiesFrame)
            RealisticPropertiesButtonDeleteOwner:SetSize(RpRespX*0.0145, RpRespY*0.024)
            RealisticPropertiesButtonDeleteOwner:SetPos(RealisticPropertiesFrame:GetWide()*0.179, RealisticPropertiesFrame:GetTall()*0.145)
            RealisticPropertiesButtonDeleteOwner:SetTextColor(Realistic_Properties.Colors["black"])
            RealisticPropertiesButtonDeleteOwner:SetText("✘")
            RealisticPropertiesButtonDeleteOwner.Paint = function(self,w,h)
                draw.RoundedBox(6, 0, 0, w, h, Realistic_Properties.Colors["white150"])
            end 
            RealisticPropertiesButtonDeleteOwner.DoClick = function()
                RealisticPropertiesClic()
                net.Start("RealisticProperties:BuySellProperties")
                net.WriteString("RemoveOwner")
                net.WriteEntity(RealisticPropertiesEntity)
                net.WriteUInt(RealisticPropertiesId, 32)
                net.SendToServer()
            end 
        end 
    end 
end 

local RealisticPropertiesMat = Material("materials/rps_key.png")
hook.Add("HUDPaint", "RealisticProperties:HUDPaint", function()
	if not isvector(RealisticPropertiesDoor1) or not isvector(RealisticPropertiesDoor2) then return end 
    if isvector(RealisticPropertiesDoor1) then 
	    RealisticPropertiesTsScreen1 = RealisticPropertiesDoor1:ToScreen()
        RealisticPropertiesDistance = RealisticPropertiesDoor1
    end 
    if isvector(RealisticPropertiesDoor2) then 		
        RealisticPropertiesTsScreen2 = RealisticPropertiesDoor2:ToScreen()
        RealisticPropertiesDistance2 = RealisticPropertiesDoor2 
    end 
	if LocalPlayer():GetPos():DistToSqr(RealisticPropertiesDistance) > (200*200) then 		
        if isvector(RealisticPropertiesDoor1) then 
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( RealisticPropertiesMat )
            surface.DrawTexturedRect( RealisticPropertiesTsScreen1.x, RealisticPropertiesTsScreen1.y, 20, 20 )
        end 
        if isvector(RealisticPropertiesDoor2) then 	
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( RealisticPropertiesMat )
            surface.DrawTexturedRect( RealisticPropertiesTsScreen2.x, RealisticPropertiesTsScreen2.y, 20, 20 )
        end 
    else    
        RealisticPropertiesDoor1 = nil 
        RealisticPropertiesDoor2 = nil 
	end  
end)
