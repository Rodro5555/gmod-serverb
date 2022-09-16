if SERVER then return end
zmc = zmc or {}
zmc.SoupPot = zmc.SoupPot or {}

function zmc.SoupPot.Initialize(SoupPot)
    SoupPot.Spoon_rot = angle_zero
    SoupPot.Spoon_rot_target = Angle(0,180,0)
end

local ui_pos = Vector(-19.7,0, 35)
local ui_ang = Angle(0, -90, 90)
local heat_pos = Vector(0, 0, 33)
function zmc.SoupPot.Draw(SoupPot)

    zmc.Machine.DrawEffect(SoupPot,"zmc_steam_only",zmc.Machine.InProgress(SoupPot) and 1 or 0,SoupPot.PotModel,1)
    zmc.Machine.DrawHeat(SoupPot, zmc.Machine.InProgress(SoupPot) and 100 or 0,"zmc_souppot_light_mat_" .. SoupPot:EntIndex(), "zerochain/props_kitchen/heater/zmc_heater", 0, heat_pos)

    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.util.InDistance(SoupPot:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then
        local ItemData = zmc.Item.GetData(SoupPot:GetItemID())
        if zmc.Machine.InProgress(SoupPot) and ItemData and ItemData.soup and ItemData.soup.time then

            cam.Start3D2D(SoupPot:LocalToWorld(ui_pos), SoupPot:LocalToWorldAngles(ui_ang), 0.05)
                draw.RoundedBox(5, -250, -50, 500, 100, zclib.colors["ui01"])
                local barW = (500 / ItemData.soup.time) * (CurTime() - SoupPot:GetCookStart())
                draw.RoundedBox(5, -250, -50, math.Clamp(barW, 0, 500), 100, zclib.colors["orange01"])
            cam.End3D2D()
        else
            zmc.Machine.DrawStatus(SoupPot)
        end
    end
end

local soup_pos = Vector(0,0,35)
function zmc.SoupPot.Think(SoupPot)

    zclib.util.LoopedSound(SoupPot, "zmc_cooking_loop", zmc.Machine.InProgress(SoupPot))

    if zclib.util.InDistance(SoupPot:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then

        if IsValid(SoupPot.PotModel) then

            SoupPot.PotModel:SetPos(SoupPot:LocalToWorld(soup_pos))
            SoupPot.PotModel:SetAngles(SoupPot:LocalToWorldAngles(angle_zero))

            if zmc.Machine.InProgress(SoupPot) then

                local ItemID = SoupPot:GetItemID()
                if ItemID > 0 and IsValid(SoupPot.PotModel) then
                    local ItemData = zmc.Item.GetData(ItemID)
                    if ItemData == nil then return end

                    if IsValid(SoupPot.FoodModel) then

                        local pos = ItemData.soup.appearance.lpos or vector_origin
                        local min,max = SoupPot.PotModel:GetModelBounds()
                        local mid = (max - min)
                        local nPos = mid * pos
                        nPos = SoupPot.PotModel:LocalToWorld(nPos + Vector(-mid.x / 2,-mid.y / 2,0))

                        SoupPot.FoodModel:SetPos(nPos)
                        SoupPot.FoodModel:SetAngles(SoupPot:LocalToWorldAngles(angle_zero))
                    else
                        SoupPot.FoodModel = zclib.ClientModel.AddProp()
                        if IsValid(SoupPot.FoodModel) then
                            local appearance = ItemData.soup.appearance
                            zmc.Item.UpdateVisual(SoupPot.FoodModel,appearance,true)

                            // Scale the food model relative to the model bounds of the wok
                            zclib.Entity.RelativeScale(SoupPot.FoodModel,SoupPot.PotModel,appearance.scale)
                        end
                    end
                else
                    if IsValid(SoupPot.FoodModel) then
                        zclib.ClientModel.Remove(SoupPot.FoodModel)
                        SoupPot.FoodModel = nil
                    end
                end
            else
                if IsValid(SoupPot.FoodModel) then
                    zclib.ClientModel.Remove(SoupPot.FoodModel)
                    SoupPot.FoodModel = nil
                end
            end
        else
            SoupPot.PotModel = zclib.ClientModel.AddProp()
            if not IsValid(SoupPot.PotModel) then return end
            SoupPot.PotModel:SetModel("models/zerochain/props_kitchen/zmc_souppot.mdl")
        end
    else
        zmc.SoupPot.RemoveClientModels(SoupPot)

        SoupPot.InventoryChanged = true
    end
end

function zmc.SoupPot.RemoveClientModels(SoupPot)
    if IsValid(SoupPot.PotModel) then
        zclib.ClientModel.Remove(SoupPot.PotModel)
        SoupPot.PotModel = nil
    end

    if IsValid(SoupPot.FoodModel) then
        zclib.ClientModel.Remove(SoupPot.FoodModel)
        SoupPot.FoodModel = nil
    end
end

function zmc.SoupPot.OnRemove(SoupPot)
    zmc.Machine.KillEffect(SoupPot,"zmc_steam_only",SoupPot.PotModel)
    zmc.SoupPot.RemoveClientModels(SoupPot)
    SoupPot:StopSound("zmc_cooking_loop")
    zmc.Machine.OnRemove(SoupPot)
end

function zmc.SoupPot.OnReDraw(SoupPot)
    zmc.Machine.KillEffect(SoupPot,"zmc_steam_only",SoupPot.PotModel)
    zmc.Machine.CreateEffect(SoupPot,"zmc_steam_only",zmc.Machine.InProgress(SoupPot) and 1 or 0,SoupPot.PotModel,1)
end
