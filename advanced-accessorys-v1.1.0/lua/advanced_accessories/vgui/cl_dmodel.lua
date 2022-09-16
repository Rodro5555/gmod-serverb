local PANEL = {}

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.158, AAS.ScrH*0.525)
    self:SetPos(AAS.ScrW*0.441, AAS.ScrH*0.052) 
    self:SetModel(AAS.LocalPlayer:GetModel())
    self:SetFOV(23)

    for k,v in pairs(AAS.LocalPlayer:GetBodyGroups()) do
        self.Entity:SetBodygroup(k, AAS.LocalPlayer:GetBodygroup(k))
    end
    self.Entity:SetSkin(AAS.LocalPlayer:GetSkin())

    if not isnumber(self.Entity:LookupBone("ValveBiped.Bip01_Head1")) then return end
    local modelEye = self.Entity:GetBonePosition(self.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    modelEye:Add(Vector(0, 0, -25))
    self:SetLookAt(modelEye)
    self:SetCamPos(modelEye-Vector(-100, 0, 0))
    self.Entity:SetAngles(Angle(0, -20, 0))
    self.AASZoom = true

    self:DrawAccessories()
    self.DrawUniqueId = nil
    self.DrawModelAccessories = true
    self.Lerp = 0

    self.Entity:SetColor(Color(255,0,0,0))
end

function PANEL:Zoom()
    self.AASZoom = !self.AASZoom
end

local startFov, startAng, StartPosX
function PANEL:Think()
    if not self:IsHovered() and not isnumber(startFov) and not isnumber(startAng) then return end

    local CurX, CurY = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
    
    if input.IsMouseDown(MOUSE_RIGHT) then
        if not self.AASZoom then return end
        if not isnumber(startFov) then startFov = CurY end
        
        local newFov = self:GetFOV() - (((startFov - CurY)/self:GetTall())*1.5)
        if newFov >= 10 and newFov <= 30 then
            self:SetFOV(newFov)
        end
    else
        startFov = nil
    end

    if input.IsMouseDown(MOUSE_LEFT) then 
        if not isnumber(startAng) then startAng = CurX end
        
        local newAng = self.Entity:GetAngles().yaw - (((startAng - CurX)/self:GetWide())*2)
        
        self.Entity:SetAngles(Angle(0, newAng, 0))
    else
        startAng = nil
    end
end

function PANEL:LayoutEntity()
    return
end

function PANEL:RemoveDrawAccessories(uniqueId)
    if self.DrawUniqueId != uniqueId then return end

    local itemTable = AAS.GetTableById(uniqueId)
    local cat = itemTable.category

    if IsValid(self.Accessories[cat]) then 
        self.Accessories[cat]:Remove() 
        self.Accessories[cat] = nil
        self.DrawUniqueId = nil
        self:DrawAccessories()
    end
end

function PANEL:SetDrawAccessories(uniqueId)
    if isnumber(self.DrawUniqueId) and self.DrawUniqueId == uniqueId then return end
    
    local itemTable = AAS.GetTableById(uniqueId)
    local cat = itemTable.category
    
    self:createAccessory(itemTable)
    self.DrawUniqueId = uniqueId
end

function PANEL:SetDrawModelAccessories(bool)
    self.DrawModelAccessories = bool
end

function PANEL:UpdateAccessoryPosition(itemTable, ent)
    local boneName = isstring(itemTable.options.bone) and itemTable.options.bone or "ValveBiped.Bip01_Head1"

    if not isnumber(self.Entity:LookupBone(boneName)) then return end
    local matrix = self.Entity:GetBoneMatrix(self.Entity:LookupBone(boneName))
    local pos = matrix:GetTranslation()
    local ang = matrix:GetAngles()

    local tbl = AAS.ClientTable["offsetItems"] or {}
    local offsetTable = tbl[tostring(itemTable.uniqueId)] or {}

    local offsetPos = (isvector(offsetTable["pos"]) and AAS.ModifyOffset) and offsetTable["pos"] or Vector(0,0,0)
    local offsetAng = (isangle(offsetTable["ang"]) and AAS.ModifyOffset) and offsetTable["ang"] or Angle(0,0,0)
    local offsetScale = (isvector(offsetTable["scale"]) and AAS.ModifyOffset) and offsetTable["scale"] or Vector(0,0,0)
    
    pos = AAS.ConvertVector(pos, (itemTable.pos + offsetPos), ang)
    ang = AAS.ConvertAngle(ang, (itemTable.ang + offsetAng))

    if isvector(itemTable.scale) then
        local mat = Matrix()
        mat:Scale(itemTable.scale + offsetScale/50)
        ent:EnableMatrix("RenderMultiply", mat)
    end
    
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetRenderMode(RENDERMODE_GLOW)
    ent.AASTable = itemTable

    local skin = tonumber(itemTable.options.skin)
    if isnumber(skin) then
        ent:SetSkin(skin)
    end

    local color = itemTable.options.color
    if istable(color) then
        ent:SetColor(color)
    end
end

function PANEL:createAccessory(itemTable)
    local cat = itemTable.category
    if not isstring(cat) then return end
    if not istable(self.Accessories) then self.Accessories = {} end

    if IsValid(self.Accessories[cat]) then self.Accessories[cat]:Remove() else self.Accessories[cat] = nil end
    self.Accessories[cat] = ClientsideModel(itemTable.model)
    self.Accessories[cat]:SetNoDraw(true)
    self.Accessories[cat]:SetIK(false)
    self.Accessories[cat]:SetParent(self.Entity)
    self.Accessories[cat]:SetRenderMode(RENDERMODE_TRANSCOLOR)

    self:UpdateAccessoryPosition(itemTable, self.Accessories[cat])

    timer.Create("aas_refresh_accessories:"..cat, 0, 0, function()
        if istable(self.Accessories) and not IsValid(self.Accessories[cat]) or not IsValid(self.Entity) then timer.Remove("aas_refresh_accessories:"..cat) return end
        
        self:UpdateAccessoryPosition(itemTable, self.Accessories[cat])
    end)
end

function PANEL:DrawAccessories(category)
    if not istable(self.Accessories) then self.Accessories = {} end
    if not istable(AAS.ClientTable["ItemsEquiped"]) or not istable(AAS.ClientTable["ItemsEquiped"][AAS.LocalPlayer:SteamID64()]) then return end

    if isstring(category) and IsValid(self.Accessories[category]) then self.Accessories[category]:Remove() end

    for k,v in pairs(AAS.ClientTable["ItemsEquiped"][AAS.LocalPlayer:SteamID64()]) do
        local itemTable = AAS.GetTableById(v.uniqueId)

        self:createAccessory(itemTable)
    end
end

function PANEL:DoClick()
    StartAng = self.Entity:GetAngles().yaw
end

--[[ This is the DrawModel of the DModel made my gmod I ovveride it for draw my accessories]]
function PANEL:DrawModel()
	local curparent = self
	local leftx, topy = self:LocalToScreen( 0, 0 )
	local rightx, bottomy = self:LocalToScreen( self:GetWide(), self:GetTall() )
    
	while ( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen( 0, 0 )
		local x2, y2 = curparent:LocalToScreen( curparent:GetWide(), curparent:GetTall() )

		leftx = math.max( leftx, x1 )
		topy = math.max( topy, y1 )
		rightx = math.min( rightx, x2 )
		bottomy = math.min( bottomy, y2 )
		previous = curparent
	end

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	local ret = self:PreDrawModel( self.Entity )
	if ( ret != false ) then
		self.Entity:DrawModel()
        
        if self.DrawModelAccessories then
            for k,v in pairs(self.Accessories) do
                local itemTable = v.AASTable
                if not istable(itemTable) or not istable(itemTable.options) or not isstring(itemTable.options.bone) then continue end

                if self.DrawUniqueId != nil and self.DrawUniqueId != itemTable.uniqueId then continue end

                local color = itemTable["options"]["color"] or v:GetColor()
                render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)

                v:DrawModel()
            end
        end
		self:PostDrawModel(self.Entity)
	end

	render.SetScissorRect(0, 0, 0, 0, false)
end

function PANEL:Paint( w, h )
    if ( !IsValid( self.Entity ) ) then return end
    local x, y = self:LocalToScreen( 0, 0 )

    self:LayoutEntity( self.Entity )

    local ang = self.aLookAngle
    if ( !ang ) then
        ang = ( self.vLookatPos - self.vCamPos ):Angle()
    end

    cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

    if self.DrawModelAccessories then
        for k,v in pairs(self.Accessories) do
            if not istable(v.AASTable) then continue end
            if self.DrawUniqueId != nil and self.DrawUniqueId != v.AASTable.uniqueId then continue end

            if istable(v.AASTable.job) and not v.AASTable.job[team.GetName(AAS.LocalPlayer:Team())] then continue end

            local color = v.AASTable["options"]["color"] or v:GetColor()
            render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
            v:DrawModel()
        end
    end

    render.SuppressEngineLighting( true )
    render.SetLightingOrigin( self.Entity:GetPos() )
    render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
    render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
    render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )

    for i = 0, 6 do
        local col = self.DirectionalLight[ i ]
        if ( col ) then
            render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
        end
    end

    self:DrawModel()

    render.SuppressEngineLighting( false )
    cam.End3D()

    self.LastPaint = RealTime()
end

function PANEL:OnRemove()
    if not istable(self.Accessories) then return end
    for k,v in pairs(self.Accessories) do
        if IsValid(v) then v:Remove() end
    end
end

derma.DefineControl("AAS:DModel", "AAS DModel", PANEL, "DModelPanel")