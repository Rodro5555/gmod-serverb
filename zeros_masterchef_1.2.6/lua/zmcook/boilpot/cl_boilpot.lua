if SERVER then return end
zmc = zmc or {}
zmc.BoilPot = zmc.BoilPot or {}


function zmc.BoilPot.Initialize(BoilPot)
    BoilPot.SmoothWater = 0
end

local water_color01 = Vector(0.9, 0.9, 1)
local water_color02 = Vector(1, 0.9, 0.9)
function zmc.BoilPot.UpdateWaterMaterial(BoilPot,temp)
    local matID = "zmc_water_mat_" .. BoilPot:EntIndex() .. 466

    if BoilPot.WaterMaterial == nil then
        BoilPot.WaterMaterial = CreateMaterial(matID, "Refract", {
            ["$nocull"] = 1,
            ["$model"] = 1,
            ["$nowritez"] = 1,
            ["$bluramount"] = 2,
            ["$refractamount"] = 0.05,
            ["$refracttint"] = Vector(0.9, 0.9, 1),
            ["$normalmap"] = "zerochain/props_kitchen/liquid/zmc_water_nrm",
            ["$envmap"] = "env_cubemap",
            ["$envmaptint"] = Vector(0.9, 0.9, 1),
            ["$fadeoutonsilhouette"] = 1,
            Proxies = {
                AnimatedTexture = {
                    animatedTextureVar = "$normalmap",
                    animatedTextureFrameNumVar = "$bumpframe",
                    animatedTextureFrameRate = 30
                }
            }
        })
    end
    local _mat = BoilPot.WaterMaterial


    BoilPot.SmoothWater = Lerp(0.2 * FrameTime(),BoilPot.SmoothWater or 0,temp)

    _mat:SetFloat("$refractamount", (0.2 / 100) * BoilPot.SmoothWater)
    _mat:SetFloat("$bluramount", (2 / 100) * BoilPot.SmoothWater)

    // $model + $envmapmode
    _mat:SetInt("$flags", 2048 + 8192 + 33554432)

    local water_color = LerpVector((1 / 100) * BoilPot.SmoothWater,water_color01,water_color02)
    _mat:SetVector("$refracttint", water_color)
    _mat:SetVector("$envmaptint", water_color)


    BoilPot.WaterModel:SetMaterial("!" .. matID)
end

local heat_pos = Vector(0, 0, 33)
function zmc.BoilPot.Draw(BoilPot)
    zmc.Machine.DrawTemperatur(BoilPot)
    zmc.Machine.DrawHeat(BoilPot, BoilPot:GetTemperatur(),"zmc_boilpot_light_mat_" .. BoilPot:EntIndex(), "zerochain/props_kitchen/heater/zmc_heater", 0, heat_pos)
    zmc.Machine.DrawEffect(BoilPot,"zmc_steam",math.Clamp(math.Round((5 / 100) * BoilPot.LastTemperatur),BoilPot.LastTemperatur <= 0 and 0 or 1,5),BoilPot.PotModel,0)
end

function zmc.BoilPot.OnTemperaturChange(BoilPot, newTemp)
    zmc.Machine.KillEffect(BoilPot,"zmc_steam",BoilPot.PotModel)
    zmc.Machine.CreateEffect(BoilPot,"zmc_steam",math.Clamp(math.Round((5 / 100) * BoilPot.LastTemperatur),BoilPot.LastTemperatur <= 0 and 0 or 1,5),BoilPot.PotModel,0)
end

function zmc.BoilPot.OnReDraw(BoilPot)
    zmc.Machine.KillEffect(BoilPot,"zmc_steam",BoilPot.PotModel)
    zmc.Machine.CreateEffect(BoilPot,"zmc_steam",math.Clamp(math.Round((5 / 100) * BoilPot.LastTemperatur),BoilPot.LastTemperatur <= 0 and 0 or 1,5),BoilPot.PotModel,0)
end

local Boilpot_pos = Vector(0,0,39)
local pot_pos = Vector(0,0,50)
local pot_ang = Angle(0,90,0)
function zmc.BoilPot.Think(BoilPot)

    zclib.util.LoopedSound(BoilPot, "zmc_cooking_loop", zmc.Machine.InProgress(BoilPot))

    if zclib.util.InDistance(BoilPot:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then

        if IsValid(BoilPot.PotModel) then
            BoilPot.PotModel:SetPos(BoilPot:LocalToWorld(Boilpot_pos))
            BoilPot.PotModel:SetAngles(BoilPot:LocalToWorldAngles(angle_zero))
        else
            BoilPot.PotModel = zclib.ClientModel.AddProp()
            if not IsValid(BoilPot.PotModel) then return end
            BoilPot.PotModel:SetModel("models/zerochain/props_kitchen/zmc_boilpot.mdl")
        end

        if IsValid(BoilPot.WaterModel) then
            BoilPot.WaterModel:SetPos(BoilPot:LocalToWorld(pot_pos))
            BoilPot.WaterModel:SetAngles(BoilPot:LocalToWorldAngles(pot_ang))

            zmc.BoilPot.UpdateWaterMaterial(BoilPot,BoilPot:GetTemperatur())
        else
            BoilPot.WaterModel = zclib.ClientModel.AddProp()
            if not IsValid(BoilPot.WaterModel) then return end
            BoilPot.WaterModel:SetModel("models/zerochain/props_kitchen/zmc_liquid.mdl")
        end

        if BoilPot.OnTableDummys == nil or BoilPot.InventoryChanged == true then

            if BoilPot.OnTableDummys == nil then BoilPot.OnTableDummys = {} end

            for slot_id,slot_data in pairs(zmc.Inventory.Get(BoilPot)) do
                if slot_data == nil then continue end

                local ItemData = zmc.Item.GetData(slot_data.itm)
                if ItemData == nil then
                    if IsValid(BoilPot.OnTableDummys[slot_id]) then zclib.ClientModel.Remove(BoilPot.OnTableDummys[slot_id]) end
                    continue
                end

                local ent
                if IsValid(BoilPot.OnTableDummys[slot_id]) then
                    ent = BoilPot.OnTableDummys[slot_id]
                else
                    ent = zclib.ClientModel.AddProp()
                end
                if not IsValid(ent) then continue end

                zmc.Item.UpdateVisual(ent,ItemData,true)

                BoilPot.OnTableDummys[slot_id] = ent

                zclib.Entity.RelativeScale(ent,BoilPot,0.15)

                if ItemData.boil == nil then continue end

                local ResultItemData = zmc.Item.GetData(ItemData.boil.item)

                local fract = (1 / ItemData.boil.time) * (slot_data.boil_prog or 0)

                // Change color depending on progress
                local col = zclib.util.LerpColor(fract, ItemData.color or color_white, ResultItemData.color or color_white)
                ent:SetColor(col)
            end

            BoilPot.InventoryChanged = nil
        end

        if BoilPot.OnTableDummys then
            for k, v in pairs(BoilPot.OnTableDummys) do
                if IsValid(v) then
                    if v.rndval == nil then v.rndval = math.random(100) end
                    if v.rndrad == nil then v.rndrad = math.Rand(1,10) end
                    if v.rndheight == nil then v.rndheight = math.Rand(5,10) end
                    local seg = k * 1.5
                    local pos_x = math.sin((seg + CurTime()) * 0.5)
                    local pos_y = math.cos((seg + CurTime()) * 0.5)
                    v:SetPos(BoilPot.PotModel:LocalToWorld(Vector(pos_x * v.rndrad,pos_y * v.rndrad,v.rndheight)))

                    local ang = (CurTime() * 25) + (5 * k) + v.rndval
                    v:SetAngles(BoilPot.PotModel:LocalToWorldAngles(Angle(ang, ang,ang)))
                end
            end
        end
    else
        zmc.BoilPot.RemoveClientModels(BoilPot)

        BoilPot.InventoryChanged = true
    end
end

function zmc.BoilPot.RemoveClientModels(BoilPot)
    if IsValid(BoilPot.PotModel) then
        zclib.ClientModel.Remove(BoilPot.PotModel)
        BoilPot.PotModel = nil
    end

    if IsValid(BoilPot.WaterModel) then
        zclib.ClientModel.Remove(BoilPot.WaterModel)
        BoilPot.WaterModel = nil
    end

    if BoilPot.OnTableDummys then
        for k,v in pairs(BoilPot.OnTableDummys) do
            if IsValid(v) then
                zclib.ClientModel.Remove(v)
            end
        end
        BoilPot.OnTableDummys = nil
    end
end

function zmc.BoilPot.OnRemove(BoilPot)
    zmc.Machine.KillEffect(BoilPot,"zmc_steam",BoilPot.PotModel)
    zmc.BoilPot.RemoveClientModels(BoilPot)
    BoilPot:StopSound("zmc_cooking_loop")
    zmc.Machine.OnRemove(BoilPot)
end
