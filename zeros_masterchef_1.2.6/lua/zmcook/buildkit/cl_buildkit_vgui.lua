if not CLIENT then return end
zmc = zmc or {}
zmc.Buildkit = zmc.Buildkit or {}

net.Receive("zmc_Buildkit_OpenInterface", function(len)
    zclib.Debug_Net("zmc_Buildkit_OpenInterface",len)

    zmc.vgui.ActiveEntity = net.ReadEntity()

    // If we currently removing / placing something then stop
    zclib.PointerSystem.Stop()

    zmc.Buildkit.OpenInterface()
end)

function zmc.Buildkit.OpenInterface()
    zmc.vgui.Page("Buildkit",function(main,top)

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local delete_btn = zclib.vgui.ImageButton(900 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("delete"),function()
            zmc.Buildkit.Deconstruct(zmc.vgui.ActiveEntity)
            zmc_main_panel:Close()
        end,false)
        delete_btn:Dock(RIGHT)
        delete_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        delete_btn.IconColor = zclib.colors["red01"]
        delete_btn:SetTooltip(zmc.language["Equipment_Remove"])

        local move_btn = zclib.vgui.ImageButton(900 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("move"),function()
            zmc.Buildkit.Move(zmc.vgui.ActiveEntity)
            zmc_main_panel:Close()
        end,false)
        move_btn:Dock(RIGHT)
        move_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        move_btn.IconColor = zclib.colors["blue01"]
        move_btn:SetTooltip(zmc.language["Equipment_Move"])

        local repair_btn = zclib.vgui.ImageButton(900 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("repair"),function()
            zmc.Buildkit.Repair(zmc.vgui.ActiveEntity)
            zmc_main_panel:Close()
        end,false)
        repair_btn:Dock(RIGHT)
        repair_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        repair_btn.IconColor = zclib.colors["green01"]
        repair_btn:SetTooltip(zmc.language["Equipment_Repair"])


        local list,scroll = zmc.vgui.List(main)
        scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        scroll.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        end
        main.ItemList = scroll

        for id, data in pairs(zmc.config.Buildkit.List) do

            local money = zclib.Money.Display(data.price)

            local item_pnl = zmc.vgui.Slot(data,function()

                //IsSelected
                return false
            end,function()

                // CanSelect
                return true
            end,function()

                // OnSelect
                zmc.Buildkit.Place(zmc.vgui.ActiveEntity,id)
                if IsValid(zmc_main_panel) then zmc_main_panel:Remove() end
            end,function(w,h,s)

                // PreDraw
            end,function(w,h,s,dat)

                // PostDraw

                if s:IsHovered() then

                    draw.RoundedBox(5, 0, 0, w, h, zclib.colors["green01"])
                    draw.RoundedBox(5, w * 0.02, h * 0.02, w * 0.96, h * 0.96, zclib.colors["ui01"])

                    draw.SimpleText(zmc.language["Buy"], zclib.GetFont("zclib_font_big"), w / 2, h / 2,zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


                    draw.RoundedBox(5, 0, h * 0.8, w, h * 0.2, zclib.colors["black_a100"])

                    local txtW = zclib.util.GetTextSize(dat.name, s.font_name)
                    if txtW > w * 0.9 then
                        if s.font_name == zclib.GetFont("zclib_font_mediumsmall") then
                            s.font_name = zclib.GetFont("zclib_font_small")
                        elseif s.font_name == zclib.GetFont("zclib_font_small") then
                            s.font_name = zclib.GetFont("zclib_font_tiny")
                        elseif s.font_name == zclib.GetFont("zclib_font_tiny") then
                            s.font_name = zclib.GetFont("zclib_font_nano")
                        end
                    end
                    draw.SimpleText(dat.name, s.font_name, w / 2, h * 0.9,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(money, zclib.GetFont("zclib_font_mediumsmall"), w - 10 * zclib.hM, 10 * zclib.hM,zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
            end)
            list:Add(item_pnl)
            item_pnl:SetSize(168 * zclib.wM, 168 * zclib.hM)
            item_pnl.font_name = zclib.GetFont("zclib_font_small")
            item_pnl.Entity:SetAngles(Angle(0,200,0))
            item_pnl:SetFOV(50)
        end
    end)
end
