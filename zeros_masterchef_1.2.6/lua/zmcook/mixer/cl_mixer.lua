if SERVER then return end
zmc = zmc or {}
zmc.Mixer = zmc.Mixer or {}

function zmc.Mixer.Initialize(Mixer)
    Mixer.SmoothAnim = 0
    Mixer.SmoothAnim_run = 0
    Mixer.SmoothAnim_hebel = 0
end

function zmc.Mixer.DrawButton(x,y,text,OnHover)
    if OnHover then
        draw.RoundedBox(5, x-25, y-25, 50, 50, zclib.colors["ui_highlight"])
    else
        draw.RoundedBox(5, x-25, y-25, 50, 50, zclib.colors["ui01"])
    end
    draw.SimpleText(text, zclib.GetFont("zclib_font_huge"), x,y,zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function zmc.Mixer.DrawLoadingBar(Mixer, ItemData, w, h)
    draw.RoundedBox(5, -w / 2, -h / 2, w, h, zclib.colors["ui01"])
    local barW = (w / ItemData.mix.time) * Mixer:GetProgress()

    if Mixer:GetMixLevel() ~= ItemData.mix.speed then
        draw.RoundedBox(5, -w / 2, -h / 2, math.Clamp(barW, 0, w), h, zclib.colors["text01"])
    else
        draw.RoundedBox(5, -w / 2, -h / 2, math.Clamp(barW, 0, w), h, zclib.colors["orange01"])
    end
end

local ui01_pos = Vector(-2.5, 14.7, 40)
local ui01_ang = Angle(0, 180, 90)

local ui02_pos = Vector(-2.35, 14.7, 40)
local ui02_ang = Angle(0, 180, 90)
function zmc.Mixer.Draw(Mixer)
    if zclib.util.InDistance(Mixer:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then
        if zmc.Machine.InProgress(Mixer) then

            local ItemData
            if Mixer:GetItemID() ~= -1 then
                ItemData = zmc.Item.GetData(Mixer:GetItemID())
                if ItemData and ItemData.mix then
                    cam.Start3D2D(Mixer:LocalToWorld(ui01_pos), Mixer:LocalToWorldAngles(ui01_ang), 0.05)
                        zmc.Mixer.DrawLoadingBar(Mixer,ItemData,400,100)
                    cam.End3D2D()
                end
            end

            local pos,ang = Mixer:GetBonePosition(Mixer:LookupBone("neck_jnt"))
            ang:RotateAroundAxis(ang:Right(),-90)
            pos = pos + ang:Right() * 6.7
            pos = pos + ang:Up() * 13.5
            pos = pos - ang:Forward() * 20.5

            cam.Start3D2D(pos, ang, 0.05)
                zmc.Mixer.DrawButton(260,0,">",Mixer:OnDecrease(LocalPlayer()))
                zmc.Mixer.DrawButton(-200,0,"<",Mixer:OnIncrease(LocalPlayer()))


                if ItemData and ItemData.mix then
                    local arrow_pos = (280 / 9) * ItemData.mix.speed
                    draw.SimpleText("▲", zclib.GetFont("zclib_font_huge"), 185 - arrow_pos,50,zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            cam.End3D2D()
        else
            zmc.Machine.DrawStatus(Mixer,ui02_pos,ui02_ang)
        end
    end
end

function zmc.Mixer.Think(Mixer)

    local speed = (1 / 10) * Mixer:GetMixLevel()
    local level = (1 / 10) * Mixer:GetMixLevel()

    zclib.util.LoopedSound(Mixer, "zmc_mixer", zmc.Machine.InProgress(Mixer) and speed > 0)

    if zclib.util.InDistance(Mixer:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_generic) then

        if zmc.Machine.InProgress(Mixer) then
            //Mixer:ResetSequence(Mixer:LookupSequence("run"))
            Mixer.SmoothAnim = Lerp(1 * FrameTime(),Mixer.SmoothAnim,0)

            Mixer.SmoothAnim_run = Mixer.SmoothAnim_run + (speed * FrameTime())
            if Mixer.SmoothAnim_run > 1 then Mixer.SmoothAnim_run = 0 end
        else
            Mixer:ResetSequence(Mixer:LookupSequence("idle"))
            Mixer.SmoothAnim = Lerp(1 * FrameTime(),Mixer.SmoothAnim,1)
        end
        Mixer:SetPoseParameter("run_switch",zmc.Machine.InProgress(Mixer) and Mixer.SmoothAnim_run or 0)
        Mixer:SetPoseParameter("neck_up",Mixer.SmoothAnim)

        Mixer.SmoothAnim_hebel = Lerp(5 * FrameTime(),Mixer.SmoothAnim_hebel,level)
        Mixer:SetPoseParameter("hebel_switch",Mixer.SmoothAnim_hebel)

        if Mixer:GetItemID() ~= -1 then
            local ItemData = zmc.Item.GetData(Mixer:GetItemID())

            if zmc.Machine.InProgress(Mixer) and ItemData then
                if IsValid(Mixer.DoughModel) then
                    local _sin = math.sin(CurTime()) * speed
                    local _cos = math.cos(CurTime()) * speed
                    local pos = Mixer:GetBonePosition(Mixer:LookupBone("arm_jnt"))
                    pos = pos + Vector(_sin * 2, _cos * 2, 2 * _sin) + Mixer:GetUp() * 25 + Mixer:GetForward() * -30
                    Mixer.DoughModel:SetPos(pos)

                    local ang = (CurTime() * 360) * speed
                    Mixer.DoughModel:SetAngles(Mixer:LocalToWorldAngles(Angle(ang, ang, ang)))
                else
                    Mixer.DoughModel = zclib.ClientModel.AddProp()
                    if not IsValid(Mixer.DoughModel) then return end
                    Mixer.DoughModel:SetModel(ItemData.mdl)
                    zmc.Item.UpdateVisual(Mixer.DoughModel, ItemData, true)
                    zclib.Entity.RelativeScale(Mixer.DoughModel, Mixer, 0.5)
                end
            else
                zmc.Mixer.RemoveClientModels(Mixer)
            end
        else
            zmc.Mixer.RemoveClientModels(Mixer)
        end
    else
        zmc.Mixer.RemoveClientModels(Mixer)
    end
end

function zmc.Mixer.RemoveClientModels(Mixer)
    if IsValid(Mixer.DoughModel) then
        zclib.ClientModel.Remove(Mixer.DoughModel)
        Mixer.DoughModel = nil
    end
end

function zmc.Mixer.OnRemove(Mixer)
    zmc.Mixer.RemoveClientModels(Mixer)
    Mixer:StopSound("zmc_cooking_loop")
end
