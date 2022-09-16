if SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.PollutionSystem = zmlab2.PollutionSystem or {}
zmlab2.PollutionSystem.PolutedAreas = zmlab2.PollutionSystem.PolutedAreas or {}

net.Receive("zmlab2_PollutionSystem_Update", function(len, ply)
    //zclib.Debug_Net("zmlab2_PollutionSystem_AddPollution", len)
	local id = net.ReadUInt(32)
    local pos = net.ReadVector()
    local amount = net.ReadUInt(16)
    if pos == nil then return end
    if amount == nil then return end

	zmlab2.PollutionSystem.Update(id,pos,amount)
end)
function zmlab2.PollutionSystem.Update(id,pos,amount)

	if amount > 0 then
		zmlab2.PollutionSystem.PolutedAreas[id] = {
			pos = pos,
            amount = amount
		}
	else
		zmlab2.PollutionSystem.PolutedAreas[id] = nil
	end

    zmlab2.PollutionSystem.TimeCheck()
end

function zmlab2.PollutionSystem.TimeCheck()
    local timerid = "zmlab2_PollutionSystem_timer"
    if timer.Exists(timerid) == true then return end
    zclib.Timer.Remove(timerid)

    zclib.Timer.Create(timerid,1,0,function()

        if zmlab2.PollutionSystem.PolutedAreas == nil or table.Count(zmlab2.PollutionSystem.PolutedAreas) <= 0 then
            zclib.Debug("Pollution Timer Removed")
            zclib.Timer.Remove(timerid)
        else
            for area_id,pollution_amount in pairs(zmlab2.PollutionSystem.PolutedAreas) do

                local area_data = zmlab2.PollutionSystem.PolutedAreas[area_id]

                area_data.amount = math.Clamp(area_data.amount - zmlab2.config.PollutionSystem.EvaporationAmount,0,9999999)

                if area_data.amount <= 0 then
                    zmlab2.PollutionSystem.PolutedAreas[area_id] = nil
                else

                    if zclib.util.InDistance(LocalPlayer():GetPos(), area_data.pos, 2000) then
                        zmlab2.PollutionSystem.Visualize(area_data)
                    end
                end
            end
        end
    end)
    zclib.Debug("Pollution Timer Created")
end

// Keeps track on when the player last was inside a pollution area
function zmlab2.PollutionSystem.Visualize(polution_data)
    local count = math.Clamp(math.Round(polution_data.amount / 10),1,10)
    local rad = 30 * count
    local impact_dist = zmlab2.PollutionSystem.GetSize() + rad

    for i = 0, count-1 do
        local ang = (360 / count) * i
        local circlePos = Vector(math.cos(ang) * rad, math.sin(ang) * rad, 1)

        if zmlab2.config.PollutionSystem.UseTraces == true then
            local c_trace = zclib.util.TraceLine({
                start = polution_data.pos + circlePos + Vector(0,0,50),
                endpos = polution_data.pos + circlePos - Vector(0,0,5000),
                mask = MASK_SOLID_BRUSHONLY,
            }, "PollutionSystem")

            if c_trace and c_trace.Hit and c_trace.HitPos then
                zclib.Effect.ParticleEffect("zmlab2_poison_gas", c_trace.HitPos, angle_zero)
            end
        else
            zclib.Effect.ParticleEffect("zmlab2_poison_gas", polution_data.pos + circlePos, angle_zero)
        end
    end

    zclib.Effect.ParticleEffect("zmlab2_poison_gas", polution_data.pos, angle_zero)

    if zclib.util.InDistance(LocalPlayer():GetPos(), polution_data.pos, impact_dist) and zmlab2.config.PollutionSystem.ImmunityCheck(LocalPlayer()) ~= true then

        if zmlab2.config.PollutionSystem.UseTraces == true then
            local c_trace = zclib.util.TraceLine({
                start = polution_data.pos + Vector(0,0,50),
                endpos = LocalPlayer():GetPos() + Vector(0,0,10),
                mask = MASK_SOLID_BRUSHONLY,
            }, "PollutionSystem")

            if c_trace and c_trace.Fraction >= 0.9 then
                zmlab2.PollutionSystem.ScreenEffect_Add()
            end
        else
            zmlab2.PollutionSystem.ScreenEffect_Add()
        end
    end
end

local LastImpact = 0
local ScreenEffectAmount = 0
function zmlab2.PollutionSystem.ScreenEffect()

    if not IsValid(LocalPlayer()) or LocalPlayer():Alive() == false then
        zmlab2.PollutionSystem.ScreenEffect_Remove()
        return
    end

    if CurTime() <= (LastImpact + 1.1) then
        ScreenEffectAmount = math.Clamp(ScreenEffectAmount + (100 * FrameTime()),0,100)
    else
        ScreenEffectAmount = math.Clamp(ScreenEffectAmount - (100 * FrameTime()),0,100)
    end

    if ScreenEffectAmount > 0 then

        local alpha = (1 / 100) * ScreenEffectAmount

        DrawBloom(0.2, 2 * alpha, alpha * 8, alpha * 8, 15, 1, 0, 0.5, 0.3)

        DrawMotionBlur(0.05, alpha, 0)

        DrawMaterialOverlay("effects/tp_eyefx/tpeye3", 1 * alpha)
        DrawMaterialOverlay("effects/water_warp01", 0.01 * alpha)

        local tab = {}
        tab["$pp_colour_colour"] = 1
        tab["$pp_colour_contrast"] = 0.5
        tab["$pp_colour_brightness"] = 0.1

        tab["$pp_colour_addg"] = 0.1 * alpha
        tab["$pp_colour_addr"] = 0
        tab["$pp_colour_addb"] = 0

        tab["$pp_colour_mulg"] = 1 * alpha
        tab["$pp_colour_mulr"] = 0
        tab["$pp_colour_mulb"] = 0
        DrawColorModify(tab)
    else
        zmlab2.PollutionSystem.ScreenEffect_Remove()
    end
end
function zmlab2.PollutionSystem.ScreenEffect_Add()
    LocalPlayer():SetDSP(3)
    LastImpact = CurTime()
    LocalPlayer():EmitSound("zmlab2_gas_indicator")
    // Creates the hook if it doesent exists yet
    zclib.Hook.Add("RenderScreenspaceEffects", "zmlab2_PollutionSystem", zmlab2.PollutionSystem.ScreenEffect)
end
function zmlab2.PollutionSystem.ScreenEffect_Remove()
    ScreenEffectAmount = 0
    LastImpact = 0
    LocalPlayer():SetDSP(0)
    zclib.Hook.Remove("RenderScreenspaceEffects", "zmlab2_PollutionSystem")
end
