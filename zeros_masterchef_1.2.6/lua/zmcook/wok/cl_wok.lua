if SERVER then return end
zmc = zmc or {}
zmc.Wok = zmc.Wok or {}

function zmc.Wok.Initialize(Wok)
    Wok.Pan_pos = Vector(0,0,22)
    Wok.Pan_rot = angle_zero

    Wok.Food_pos = vector_origin
    Wok.Food_pos_target = Vector(5,0,22)

    Wok.Food_ang = angle_zero
    Wok.Food_ang_target = angle_zero

    Wok.LastIneraction = CurTime()
end

function zmc.Wok.Interaction(Wok)
    if not IsValid(Wok) then return end

    Wok.LastHit = zmc.Wok.GetTime()

    if zmc.Wok.PointerHit(Wok) == false then return end

    Wok.LastIneraction = CurTime()
    if IsValid(Wok.PanModel) then
        Wok.Food_ang_target = Angle(0,math.random(-180,180),0)
    end

    if IsValid(Wok.FoodModel) then
        zclib.Effect.ParticleEffect("zmc_steam_burst", Wok.FoodModel:GetPos(), angle_zero, Wok.FoodModel)
    end

    Wok:EmitSound("zmc_frying_hit")
end

local heatpos = Vector(0, 0, 30)
local ui_pos = Vector(-19.7, 0, 35)
local ui_ang = Angle(0, -90, 90)
function zmc.Wok.Draw(Wok)

    zmc.Machine.DrawHeat(Wok,zmc.Machine.InProgress(Wok) and 100 or 0,"zmc_wok_light_mat_" .. Wok:EntIndex(), "zerochain/props_kitchen/heater/zmc_heater", 0, heatpos)

    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.util.InDistance(Wok:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then

        local ItemData = zmc.Item.GetData(Wok:GetItemID())

        if zmc.Machine.InProgress(Wok) and ItemData and ItemData.wok and ItemData.wok.cycle then

            cam.Start3D2D(Wok:LocalToWorld(ui_pos), Wok:LocalToWorldAngles(ui_ang), 0.05)
                local barW = (600 / ItemData.wok.cycle) * Wok:GetProgress()
                draw.RoundedBox(16, -300, -60, 600, 30, zclib.colors["ui01"])
                draw.RoundedBox(16, -300, -60, math.Clamp(barW, 0, 600), 30, zclib.colors["orange01"])

                local range = 600 * zmc.Wok.GetRange(Wok)
                draw.RoundedBox(0, -300, -25, 600, 50, zclib.colors["ui01"])

                if zmc.Wok.PointerHit(Wok) then
                    draw.RoundedBox(0, -range / 2, -25, range, 50, zclib.colors["green01"])
                else
                    draw.RoundedBox(0, -range / 2, -25, range, 50, zclib.colors["blue01"])
                end

                local pos = zmc.Wok.GetPointerPos(Wok)
                draw.RoundedBox(0, -5 + (300 * pos), -25, 10, 50, zclib.colors["orange01"])

                local hit_w = (600 / zmc.Wok.GetCooldown()) * math.Clamp(zmc.Wok.GetTime() - (Wok.LastHit or 0),0,zmc.Wok.GetCooldown())
                hit_w = 600 - hit_w
                draw.RoundedBox(16, -300, 30, 600, 30, zclib.colors["ui01"])
                draw.RoundedBox(16, -hit_w / 2, 30, hit_w, 30, zclib.colors["text01"])
            cam.End3D2D()
        else
            zmc.Machine.DrawStatus(Wok)
        end
    end
end

function zmc.Wok.BeingLookedAt(Wok)
    local tr = LocalPlayer():GetEyeTrace()
    if tr and tr.Hit and tr.Entity == Wok then
        return true
    else
        return false
    end
end

function zmc.Wok.Interact(Wok)
    if LocalPlayer():KeyDown( IN_USE ) == false then return end

    if zmc.Wok.BeingLookedAt(Wok) == false then return end

    if Wok.NextUse and CurTime() < Wok.NextUse then return end
    Wok.NextUse = CurTime() + zmc.Wok.GetCooldown()

    zmc.Wok.Interaction(Wok)

    net.Start("zmc_wok_pointercheck")
    net.WriteEntity(Wok)
    net.WriteBool(zmc.Wok.PointerHit(Wok))
    net.SendToServer()
end

local anim01_a = Vector(0,0,35.3)
local anim01_b = Vector(0, 0, 50)

local anim02_a = angle_zero
local anim02_b = Angle(-25, 0, 0)

local anim03 = Vector(0,0,15)
function zmc.Wok.Think(Wok)

    zclib.util.LoopedSound(Wok, "zmc_frying_loop", Wok:GetProgress() > -1)

    if zclib.util.InDistance(Wok:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then

        if zmc.Machine.InProgress(Wok) then
            zmc.Wok.Interact(Wok)
        end

        if IsValid(Wok.PanModel) then
            Wok.Pan_pos = zmc.Machine.AnimateValue(Wok,0,0.5,anim01_a,anim01_b,0.5,0.5)
            Wok.Pan_rot = zmc.Machine.AnimateValue(Wok,0,0.5,anim02_a,anim02_b,0.5,0.5)

            Wok.PanModel:SetPos(Wok:LocalToWorld(Wok.Pan_pos))
            Wok.PanModel:SetAngles(Wok:LocalToWorldAngles(Wok.Pan_rot))
        else
            Wok.PanModel = zclib.ClientModel.AddProp()
            if not IsValid(Wok.PanModel) then return end
            Wok.PanModel:SetModel("models/zerochain/props_kitchen/zmc_wok.mdl")
        end

        local ItemID = Wok:GetItemID()
        if ItemID ~= -1 then
            local ItemData = zmc.Item.GetData(ItemID)
            if ItemData and IsValid(Wok.PanModel) and zmc.Machine.InProgress(Wok) then
                if IsValid(Wok.FoodModel) then

                    local pos = ItemData.wok.appearance.lpos or vector_origin
                    local min,max = Wok.PanModel:GetModelBounds()
                    local mid = (max - min) / 2
                    local nPos = mid * pos
                    nPos = Wok.PanModel:LocalToWorld(nPos + Vector(-mid.x / 2,-mid.y / 2,3 + min.z))

                    Wok.Food_pos = zmc.Machine.AnimateValue(Wok,0.1,0.5,nPos,nPos + anim03,0.75,0.25)
                    Wok.Food_ang = LerpAngle(5 * FrameTime(),Wok.Food_ang,Wok.Food_ang_target)

                    Wok.FoodModel:SetPos(Wok.Food_pos)
                    Wok.FoodModel:SetAngles(Wok:LocalToWorldAngles(Wok.Food_ang))
                else
                    Wok.FoodModel = zclib.ClientModel.AddProp()
                    if not IsValid(Wok.FoodModel) then return end
                    local appearance = ItemData.wok.appearance
                    zmc.Item.UpdateVisual(Wok.FoodModel,appearance,true)

                    // Scale the food model relative to the model bounds of the wok
                    zclib.Entity.RelativeScale(Wok.FoodModel,Wok.PanModel,appearance.scale * 0.8)
                end
            else
                if IsValid(Wok.FoodModel) then
                    zclib.ClientModel.Remove(Wok.FoodModel)
                    Wok.FoodModel = nil
                end
            end
        else
            if IsValid(Wok.FoodModel) then
                zclib.ClientModel.Remove(Wok.FoodModel)
                Wok.FoodModel = nil
            end
        end
    else
        zmc.Wok.RemoveClientModels(Wok)

        Wok.InventoryChanged = true
    end
end

function zmc.Wok.RemoveClientModels(Wok)
    if IsValid(Wok.PanModel) then
        zclib.ClientModel.Remove(Wok.PanModel)
        Wok.PanModel = nil
    end

    if IsValid(Wok.FoodModel) then
        zclib.ClientModel.Remove(Wok.FoodModel)
        Wok.FoodModel = nil
    end
end

function zmc.Wok.OnRemove(Wok)
    zmc.Wok.RemoveClientModels(Wok)
    Wok:StopSound("zmc_frying_loop")
    zmc.Machine.OnRemove(Wok)
end

net.Receive("zmc_wok_pointercheck", function(len,ply)
    zclib.Debug_Net("zmc_wok_pointercheck", len)

    local Wok = net.ReadEntity()

    net.Start("zmc_wok_pointercheck")
    net.WriteEntity(Wok)
    net.WriteBool(zmc.Wok.PointerHit(Wok))
    net.SendToServer()
end)
