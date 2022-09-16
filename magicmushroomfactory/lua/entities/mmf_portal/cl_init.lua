include("shared.lua")

ENT.VoidEntities = {}
ENT.MaxVoidEntities = 30

net.Receive("MMF_PortalAddEntity", function(len)
    local portal = net.ReadEntity()
    local model = net.ReadString()
    local pos = net.ReadVector()
    local angles = net.ReadAngle()
    local color = net.ReadTable()

    local voidEntity = portal:SpawnEntity(model, 2)
    voidEntity:SetPos(pos)
    voidEntity:SetAngles(angles)
    voidEntity:SetColor(color)

    voidEntity.SmoothAngle = true
end)

function ENT:Initialize()
    self:UseClientSideAnimation()
    self:SetupVoidModels()

    self.Void = ClientsideModel("models/dom/magicmushroomfactory/dome.mdl")
    self.Void:SetPos(self:GetPos())
    self.Void:SetAngles(self:GetAngles())
    self.Void:SetParent(self)
    self.Void:SetupBones()
    self.Void:SetNoDraw(true)

    hook.Add("PostDrawOpaqueRenderables", self, function()
        self:PostDrawOpaqueRenderables()
    end)
end

function ENT:SetupVoidModels()
    self.VoidModels = {"models/dom/magicmushroomfactory/witcher-mushroom.mdl",
                       "models/dom/magicmushroomfactory/amanita-mushroom.mdl",
                       "models/dom/magicmushroomfactory/bluesky-mushroom.mdl",
                       "models/dom/magicmushroomfactory/candy-mushroom.mdl",
                       "models/dom/magicmushroomfactory/cubensis-mushroom.mdl", "models/Humans/Charple04.mdl",
                       "models/Lamarr.mdl", "models/vortigaunt.mdl", "models/dom/magicmushroomfactory/gnome.mdl"}

    local allowedCategories = {
        ["Construction Props"] = true,
        ["Comic Props"] = true,
        Vehicles = true
    }

    for _, category in pairs(spawnmenu.GetPropTable()) do
        if allowedCategories[category.name] then
            for _, prop in ipairs(category.contents) do
                if prop.model then
                    table.insert(self.VoidModels, prop.model)
                end
            end
        end
    end
end

function ENT:SpawnRandomEntity()
    local voidpos = self.Void:GetLocalPos()
    local pos = Vector(voidpos.x + math.random(-600, 600), voidpos.y + math.random(-600, 600), voidpos.z + 1000)

    local model = self.VoidModels[math.random(#self.VoidModels)]
    local voidEntity = self:SpawnEntity(model, math.random(2, 30))
    voidEntity:SetLocalPos(pos)
end

function ENT:SpawnEntity(model, velocity)
    local voidEntity = ClientsideModel(model)
    voidEntity:SetParent(self)
    voidEntity:SetNoDraw(true)
    voidEntity.Velocity = velocity

    table.insert(self.VoidEntities, voidEntity)

    return voidEntity
end

function ENT:Think()
    self.Void:SetPos(self:GetPos())
    self.Void:SetAngles(self:GetAngles())

    if self.CrazyBones then
        for bone = 1, self.Void:GetBoneCount() do
            local crazy = self.CrazyBones[bone]

            if crazy then
                local pos = self.Void:GetManipulateBonePosition(bone)
                if crazy == 2 then
                    self.Void:ManipulateBonePosition(bone, pos + Vector(math.random(-10, 10), 2, math.random(-10, 10)))
                elseif pos.y < -127 then
                    self.CrazyBones[bone] = 2
                else
                    self.Void:ManipulateBonePosition(bone, pos - Vector(math.random(-8, 8), 2, math.random(-8, 8)))
                end

                local scale = self.Void:GetManipulateBoneScale(bone)
                self.Void:ManipulateBoneScale(bone, scale * (1 - FrameTime()))
            end

            self.Void:ManipulateBoneAngles(bone, Angle(math.sin(CurTime() * (crazy and 50 or math.random(5, 20))),
                math.sin(CurTime() * (crazy and 50 or math.random(5, 20)))))
        end
    end

    for k, ent in ipairs(self.VoidEntities) do
        if not IsValid(ent) then
            table.remove(self.VoidEntities, k)
        else
            if ent.SmoothAngle then
                ent:SetAngles(ent:GetAngles() + Angle(math.sin(CurTime()) / 5, math.sin(CurTime()) / 5))
            else
                ent:SetAngles(Angle(math.sin(CurTime()) * 20, math.sin(CurTime()) * 20))
            end

            ent:SetLocalPos(ent:GetLocalPos() - Vector(0, 0, math.sin(1 + 1) * ent.Velocity))

            if ent:GetLocalPos().z < -5000 then
                ent:Remove()

                if #self.VoidEntities < self.MaxVoidEntities then
                    self:SpawnRandomEntity()
                end
            end
        end
    end
end

function ENT:PostDrawOpaqueRenderables()
    local state = self:GetState()

    if state == MMF.PortalState.Opening or state == MMF.PortalState.Open then
        local eyepos = EyePos()
        local client = LocalPlayer()
        local pos = self:GetPos()

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)
        render.SetStencilReferenceValue(0)
        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilFailOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.ClearStencil()

        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(1)
        render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilFailOperation(STENCIL_ZERO)
        render.SetStencilZFailOperation(STENCIL_KEEP)

        local ang = self:GetAngles()
        ang:RotateAroundAxis(self:GetRight(), 0)
        ang:RotateAroundAxis(self:GetForward(), 0)

        cam.Start3D2D(pos + self:GetUp() * 3, ang, 1)
        surface.SetDrawColor(color_black)
        local x, y, radius, seg, cir = 0, 0, 48, 32, {}

        table.insert(cir, {
            x = x,
            y = y,
            u = 0.5,
            v = 0.5
        })
        for i = 0, seg do
            local a = math.rad((i / seg) * -360)
            table.insert(cir, {
                x = x + math.sin(a) * radius,
                y = y + math.cos(a) * radius,
                u = math.sin(a) / 2 + 0.5,
                v = math.cos(a) / 2 + 0.5
            })
        end

        local a = math.rad(0) -- This is needed for non absolute segment counts
        table.insert(cir, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })

        surface.DrawPoly(cir)
        cam.End3D2D()

        render.SetStencilCompareFunction(STENCIL_EQUAL)

        render.SuppressEngineLighting(true)
        render.DepthRange(0, 0.6)

        if state == MMF.PortalState.Open then
            render.SetModelLighting(BOX_FRONT, 1, 0.2, 0.2)
            render.SetModelLighting(BOX_BACK, 1, 0.2, 0.2)
            render.SetModelLighting(BOX_LEFT, 1, 0.2, 0.2)
            render.SetModelLighting(BOX_RIGHT, 1, 0.2, 0.2)
            render.SetModelLighting(BOX_TOP, 0.6, 0.3, 0.3)
            render.SetModelLighting(BOX_BOTTOM, 0.6, 0.3, 0.3)

            local fogOffset = eyepos:DistToSqr(pos)
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(fogOffset / 1000)
            render.FogEnd(fogOffset)
            render.FogMaxDensity(0.5)
            render.FogColor(255, 80, 80)

            for k, ent in ipairs(self.VoidEntities) do
                if IsValid(ent) then
                    local color = ent:GetColor()
                    render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)

                    ent:DrawModel()
                end
            end

            render.DepthRange(0, 0.7)
        end

        self.Void:DrawModel()

        render.SuppressEngineLighting(false)
        render.SetStencilEnable(false)
        render.DepthRange(0, 1)

        if state == MMF.PortalState.Opening then
            local screen = (pos - Vector(0, 0, 10)):ToScreen()
            local distMultiplier = -math.Clamp(eyepos:DistToSqr(pos) / 30000, 0, 1) + 1
            local dotDistance = math.Clamp(client:GetAimVector():Dot((pos - eyepos):GetNormalized()) - 0.5, 0, 1)
            local multiplier = 0.03 * distMultiplier * dotDistance * 2 ^ 5

            DrawSunbeams(0, multiplier, 0.05, screen.x / ScrW(), screen.y / ScrH())

            if self.LastState == MMF.PortalState.Closed then
                self:Open()
            end
        elseif state == MMF.PortalState.Open and self.LastState == MMF.PortalState.Opening then
            local distMultiplier = -math.Clamp(eyepos:DistToSqr(pos) / 50000, 0, 1) + 1
            if distMultiplier > 0.01 then
                client:ScreenFade(SCREENFADE.IN, ColorAlpha(color_white, distMultiplier * 255), 1, 0)
            end

            for i = 1, self.MaxVoidEntities do
                self:SpawnRandomEntity()
            end
        end
    end

    self.LastState = state
end
