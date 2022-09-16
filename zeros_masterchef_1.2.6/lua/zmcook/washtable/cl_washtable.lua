if SERVER then return end
zmc = zmc or {}
zmc.Washtable = zmc.Washtable or {}

function zmc.Washtable.Initialize(Washtable)

end

local ui_pos = Vector(-18.5, 15, 40)
local ui_ang = Angle(0, -90, 0)
function zmc.Washtable.Draw(Washtable)
    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.util.InDistance(Washtable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then
        cam.Start3D2D(Washtable:LocalToWorld(ui_pos), Washtable:LocalToWorldAngles(ui_ang), 0.05)
            local barW = (600 / zmc.config.Washtable.progress_count) * Washtable:GetWashProgress()
            draw.RoundedBox(16, -300, -60, 600, 30, zclib.colors["ui01"])
            draw.RoundedBox(16, -300, -60, math.Clamp(barW, 0, 600), 30, zclib.colors["orange01"])
        cam.End3D2D()
    end
end


local Plates = {"models/zerochain/props_kitchen/zmc_plate01.mdl", "models/zerochain/props_kitchen/zmc_plate02.mdl", "models/zerochain/props_kitchen/zmc_plate03.mdl", "models/zerochain/props_kitchen/zmc_plate04.mdl"}
local plate_mdls = {}
for i = 1,zmc.config.Washtable.limit do plate_mdls[i] = Plates[math.random(#Plates)] end

function zmc.Washtable.Think(Washtable)
    if zclib.util.InDistance(Washtable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then
        if Washtable.LastPlateCount ~= Washtable:GetPlateCount() then
             Washtable.LastPlateCount = Washtable:GetPlateCount()

            zmc.Washtable.RemoveClientModels(Washtable)
            if Washtable.PlateModels == nil then Washtable.PlateModels = {} end

            for i = 1,  Washtable.LastPlateCount do
                local ent = zclib.ClientModel.AddProp()
                if not IsValid(ent) then continue end
                ent:SetModel(plate_mdls[i])
                ent:SetMaterial("zerochain/props_kitchen/zmc_rott_diff")
                Washtable.PlateModels[i] = ent
            end
        end

        if Washtable.PlateModels then
            local half = zmc.config.Washtable.limit / 2
            local h_mul = 1
            for k,v in pairs(Washtable.PlateModels) do
                if not IsValid(v) then continue end

                local _,max = v:GetModelBounds()
                local height = max.z * v:GetModelScale()
                local pos = Vector(0,-25,36)
                if k < half then
                    pos = pos + Vector(7,15,(h_mul * k) + height)
                else
                    pos = pos + Vector(-8,-4,(h_mul * k) - (h_mul * half) + height)
                end
                v:SetPos(Washtable:LocalToWorld(pos))
                v:SetAngles(Washtable:LocalToWorldAngles(Angle(0,0,0)))
            end
        end
    else
        Washtable.LastPlateCount = nil
        zmc.Washtable.RemoveClientModels(Washtable)
    end
end

function zmc.Washtable.RemoveClientModels(Washtable)
    if Washtable.PlateModels then
        for k, v in pairs(Washtable.PlateModels) do
            if not IsValid(v) then continue end
            zclib.ClientModel.Remove(v)
        end
        Washtable.PlateModels = nil
    end
end

function zmc.Washtable.OnRemove(Washtable)
    zmc.Washtable.RemoveClientModels(Washtable)
end
