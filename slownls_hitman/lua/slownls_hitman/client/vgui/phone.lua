--[[  
    Addon: Hitman
    By: SlownLS
]]


local PANEL = {}

function PANEL:Init()
    self:SetSize(534,433)
    self:Center()
    self:SetDraggable(false)
    self:MakePopup()
    self:ShowCloseButton(false)

    self:fadeIn()
end

function PANEL:Paint(w,h)
    draw.RoundedBox(16, 0, 0, w, h, self:getColor("primary"))

    self:drawRect(15, 125, w / 2.5, 1, self:getColor("outline"))

    -- nav
    local intX = w / 2.5 + 30
    local intW = w - intX - 15

    self:drawOutlineRoundedboxEx(0, intX, 15, intW, 125 - 15, self:getColor("outline"), 0, 1, 0, 0)
    draw.RoundedBoxEx(0, intX, 15, intW, 125 - 15, self:getColor("secondary"), 0, 1, 0, 0)

    local intOffsetY = 33

    draw.SimpleText(self:getLanguage('firstName') .. " : " .. self.strFirstName, "SlownLS:Hitman:24", intX + 10, 25, self:getColor("text"))
    draw.SimpleText(self:getLanguage('lastName') .. " : " .. self.strSureName, "SlownLS:Hitman:24", intX + 10, 25 + ( intOffsetY * 1 ), self:getColor("text"))
    draw.SimpleText(self:getLanguage('gender') .. " : " .. self.strGender, "SlownLS:Hitman:24", intX + 10, 25 + ( intOffsetY * 2 ), self:getColor("text"))
end

-- function PANEL:setEntity(ent)
--     self.ent = ent
-- end

-- function PANEL:getEntity()
--     return self.ent
-- end

function PANEL:updateInfos(pPlayer)
    local strModel = pPlayer:GetModel()
    local strGender = self:getLanguage('male')

    if( IsValid(self.pnlModel) ) then
        self.pnlModel:SetModel(strModel)
    end
    
    if( string.find("female", strModel) ) then
        strGender = self:getLanguage('female')
    end

    local tblName = string.Explode(" ", pPlayer:Nick())

    self.strFirstName = (tblName[1] and tblName[1] or "")
    self.strSureName = (tblName[2] and tblName[2] or "")
    self.strGender = strGender
end

function PANEL:close()
    if( IsValid(self.pnlModel) ) then
        self.pnlModel.boolClosed = true 
    end

    self:fadeOut(0.2,0.3)
end

function PANEL:load()
    local intModelW = self:GetWide() / 2.5

    self.strFirstName = self:getLanguage('unknown')
    self.strSureName = self:getLanguage('unknown')
    self.strGender = self:getLanguage('unknown')

    local pChoice

    local pnlModel = vgui.Create("DModelPanel", self)
        pnlModel:SetSize(intModelW, 125 - 14)
        pnlModel:SetPos(15,15)
        pnlModel:SetModel(LocalPlayer():GetModel())
        function pnlModel:LayoutEntity(ent) return end
        function pnlModel:Think()
            self.intLerp = self.intLerp or 20
            
            if( self.boolClosed ) then
                self.intLerp = Lerp(FrameTime() * 4, self.intLerp, 20)
            else
                self.intLerp = Lerp(FrameTime() * 4, self.intLerp, 2)
            end

            if ( self:GetModel() == "models/error.mdl" ) then return end

            local intBone = pnlModel.Entity:LookupBone("ValveBiped.Bip01_Head1")

            if ( intBone ) then
                local eyepos = pnlModel.Entity:GetBonePosition(intBone)
                eyepos:Add(Vector(0, 0, self.intLerp))

                pnlModel:SetLookAt(eyepos)
                pnlModel:SetCamPos(eyepos - Vector(-20, 0, 0 ))
                pnlModel.Entity:SetEyeTarget(eyepos - Vector(-12, 0, 0))
            end            
        end

        self.pnlModel = pnlModel

    local pnlPlayer = vgui.Create("SlownLS:Hitman:DComboBox", self)
        pnlPlayer:SetSize(self:GetWide()-30, 35)
        pnlPlayer:SetPos(15, 140)
        pnlPlayer:SetValue(self:getLanguage('choosePlayer') .. "...")

        for k,v in pairs(player.GetAll()) do
            if( v == LocalPlayer() ) then continue end
            pnlPlayer:AddChoice(v:Nick(), v)
        end

        pnlPlayer.OnSelect = function(pnl, i, v, d)
            pChoice = d
            self:updateInfos(d)
        end

    local pnlPrice = vgui.Create("SlownLS:Hitman:DTextEntry", self)
        pnlPrice:SetSize(self:GetWide() - 30, 62)
        pnlPrice:SetPos(15, 140 + pnlPlayer:GetTall() + 15)
        pnlPrice:load()
        pnlPrice:setLabel(self:getLanguage('proposePrice') .. " :")
        pnlPrice:setNumeric(true)
        pnlPrice:SetText(0)
    
    local pnlDescription = vgui.Create("SlownLS:Hitman:DTextEntry", self)
        pnlDescription:SetSize(self:GetWide() - 30, 100)
        pnlDescription:SetPos(15, 140 + ( pnlPlayer:GetTall() + 15 ) + ( pnlPrice:GetTall() + 15 ) )
        pnlDescription:load()
        pnlDescription:setLabel(self:getLanguage('detailPerson') .. " :")
        pnlDescription:setMultiline(true)

    local btnSend = vgui.Create("SlownLS:Hitman:DButton", self)
        btnSend:SetSize(self:GetWide() / 2 - 20, 35)
        btnSend:SetPos(15, 140 + ( pnlPlayer:GetTall() + 15 ) + ( pnlPrice:GetTall() + 15 ) + ( pnlDescription:GetTall() + 15 ))
        btnSend:SetText(self:getLanguage('sendContract'))
        btnSend.DoClick = function()
            SlownLS.Hitman:sendEvent('send_contract', {
                player = pChoice,
                price = pnlPrice:GetValue() or 0,
                description = pnlDescription:GetValue() or "",
                -- ent = self:getEntity(),
            })

            self:close()
        end

    local btnCancel = vgui.Create("SlownLS:Hitman:DButton", self)
        btnCancel:SetSize(self:GetWide() / 2 - 20, 35)
        btnCancel:SetPos(self:GetWide() / 2 + 5, 140 + ( pnlPlayer:GetTall() + 15 ) + ( pnlPrice:GetTall() + 15 ) + ( pnlDescription:GetTall() + 15 ))
        btnCancel:SetText(self:getLanguage('cancelContract'))
        btnCancel.DoClick = function()
            self:close()
        end
end

derma.DefineControl("SlownLS:Hitman:Phone", "", PANEL, "SlownLS:Hitman:DFrame")