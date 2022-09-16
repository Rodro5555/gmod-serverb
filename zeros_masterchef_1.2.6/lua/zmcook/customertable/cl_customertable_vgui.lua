if SERVER then return end
zmc = zmc or {}
zmc.Customertable = zmc.Customertable or {}


/*

    Creates a Review Notify

*/
local ReviewDisplayCooldown = 0
net.Receive("zmc_Customertable_notify", function(len)
    zclib.Debug_Net("zmc_Customertable_notify", len)

    local CustomerID = net.ReadUInt(16)
    local reward = net.ReadUInt(16)
    local DishID = net.ReadString()
    if CurTime() > ReviewDisplayCooldown then
        zmc.Customertable.Notify(CustomerID,math.Clamp(reward,0,10),DishID)
        ReviewDisplayCooldown = CurTime() + math.random(30,120)
    end
end)

local Reviews = {}
local function AddReviewData(star,msgs,anims,color,sound)
    Reviews[star] = {
        msgs = msgs,
        anims = anims,
        color = color,
        sound = sound,
    }
end

AddReviewData(0, {zmc.language["Review_0_01"], zmc.language["Review_0_02"], zmc.language["Review_0_03"]}, {"seq_throw"}, Color(221, 85, 85), "zmc/service_bad.wav")
AddReviewData(1, {zmc.language["Review_1_01"], zmc.language["Review_1_02"], zmc.language["Review_1_03"]}, {"seq_throw"}, Color(221, 85, 85), "zmc/service_bad.wav")
AddReviewData(2, {zmc.language["Review_1_01"], zmc.language["Review_1_02"], zmc.language["Review_1_03"]}, {"seq_preskewer"}, Color(221, 159, 85), "zmc/service_bad.wav")
AddReviewData(3, {zmc.language["Review_2_01"], zmc.language["Review_2_02"], zmc.language["Review_2_03"]}, {"taunt_persistence"}, Color(210, 221, 85), "zmc/service_ok.wav")
AddReviewData(4, {zmc.language["Review_3_01"], zmc.language["Review_3_02"], zmc.language["Review_3_03"]}, {"cheer1"}, Color(171, 221, 85), "zmc/service_amazing.wav")
AddReviewData(5, {zmc.language["Review_4_01"], zmc.language["Review_4_02"], zmc.language["Review_4_03"]}, {"taunt_muscle"}, Color(114, 221, 85), "zmc/service_amazing.wav")

function zmc.Customertable.Notify(CustomerID,Reward,DishID)
    if IsValid(zmc_customertable_notify_panel) then zmc_customertable_notify_panel:Remove() end

    local startCount = math.Round((5 / 10) * Reward)
    local reviewData = Reviews[startCount]
    local rating = reviewData.msgs[math.random(#reviewData.msgs)]

    local DishData = zmc.Dish.GetData(DishID)
    if DishData and DishData.name then rating = string.Replace(rating, "$FoodName", DishData.name) end

    local anim = reviewData.anims[math.random(#reviewData.anims)]

    //surface.PlaySound( "buttons/button15.wav" )
    surface.PlaySound( reviewData.sound )

    local mainframe = vgui.Create("DPanel")
    mainframe:ParentToHUD()
    mainframe:SetMouseInputEnabled(false)
    mainframe:SetKeyboardInputEnabled(false)
    mainframe:SetSize(500 * zclib.wM, 150 * zclib.hM)
    mainframe:SetPos(ScrW(), 20 * zclib.hM)
    mainframe.Paint = function(s,w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
        if input.IsKeyDown(KEY_ESCAPE) and IsValid(zmc_customertable_notify_panel) then
            zmc_customertable_notify_panel:Remove()
        end
    end
    mainframe:MoveTo(ScrW() - 520 * zclib.wM, 20 * zclib.hM, 0.5, 0, 0.5, function()

        if not IsValid(mainframe) then return end
        mainframe:MoveTo(ScrW(), 20 * zclib.hM, 0.5, 5, 0.5, function()

            if not IsValid(mainframe) then return end
            mainframe:Remove()
        end)
    end)
    zmc_customertable_notify_panel = mainframe

    local txtFrame = vgui.Create("DPanel",mainframe)
    txtFrame:SetSize(500 * zclib.wM, 150 * zclib.hM)
    txtFrame:Dock(FILL)
    txtFrame.Paint = function(s,w, h) end

    local function AddTextPanel(parent,txt,col,font,align,wrap,dock)
        local TitleBox = vgui.Create("DLabel", txtFrame)
        TitleBox:SetAutoDelete(true)
        TitleBox:SetSize(100 * zclib.wM, 200 * zclib.hM)
        TitleBox:Dock(dock)
        TitleBox:SetText(txt)
        TitleBox:SetTextColor(col)
        TitleBox:SetFont(font)
        TitleBox:SetWrap(wrap)
        TitleBox:SetContentAlignment(align)
        TitleBox:SizeToContentsX( 15 * zclib.wM )
        TitleBox:DockMargin(10 * zclib.wM, 10 * zclib.hM,10 * zclib.wM, 0 * zclib.hM)
    end

    AddTextPanel(txtFrame,rating,zclib.colors["text01"],zclib.GetFont("zclib_font_mediumsmall"),7,true,TOP)

    local rating_stars = vgui.Create("DPanel",txtFrame)
    rating_stars:SetSize(500 * zclib.wM, 60 * zclib.hM)
    rating_stars:Dock(BOTTOM)
    rating_stars:DockMargin(10 * zclib.wM, 0 * zclib.hM,10 * zclib.wM, 10 * zclib.hM)
    rating_stars.Paint = function(s,w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])

        local fieldSize = w / 5
        fieldSize = fieldSize - 10 * zclib.wM


        for i = 1, 5 do
            local starPos = (fieldSize * i) - (fieldSize / 2) + ((10 * zclib.wM) * i) - 5 * zclib.wM
            if i <= startCount then
                surface.SetDrawColor(zclib.colors["orange01"])
            else
                surface.SetDrawColor(zclib.colors["ui00"])
            end
            surface.SetMaterial(zclib.Materials.Get("star01"))
            surface.DrawTexturedRectRotated(starPos, h / 2, fieldSize, fieldSize, 0)
        end
    end

    local icon = vgui.Create( "DModelPanel", mainframe )
    icon:SetSize(150 * zclib.wM, 150 * zclib.hM)
    icon:SetModel(zmc.config.Customers[CustomerID])
    icon:Dock(LEFT)
    icon:SetFOV(20)
    icon.LayoutEntity = function(s, ent )
        icon:RunAnimation()
        local attach_eye = icon.Entity:GetAttachment(icon.Entity:LookupAttachment("eyes"))
        if attach_eye then
            icon:SetLookAt(attach_eye.Pos)
            icon:SetCamPos(attach_eye.Pos + attach_eye.Ang:Forward() * 100)
        end
        return
    end
    icon.PreDrawModel = function(s,ent)
        local w,h = s:GetWide(), s:GetTall()
        cam.Start2D()
            surface.SetDrawColor(reviewData.color)
            surface.SetMaterial(zclib.Materials.Get("item_bg"))
            surface.DrawTexturedRect(0, 0,w, h)
        cam.End2D()
    end
    icon.Entity:SetAngles(angle_zero)
    icon.Entity:SetPos(vector_origin)
    icon.Entity:SetEyeTarget(LocalPlayer():EyePos())

    if icon.Entity:LookupSequence(anim) == -1 then
        anim = "seq_wave_smg1"
    end

    if icon.Entity:LookupSequence(anim) ~= -1 then
        icon:SetAnimated(true)
        icon.Entity:SetSequence(icon.Entity:LookupSequence(anim))
    end

    icon.PostDrawModel = function(ent)
        local w,h = icon:GetWide(), icon:GetTall()
        cam.Start2D()
            zclib.util.DrawOutlinedBox(0,0, w, h, 5, zclib.colors["ui02"])
        cam.End2D()
    end
end

//zmc.Customertable.Notify(1,10,1)


/*

    Creates the Config for the Customertable

*/
net.Receive("zmc_Customertable_Open", function(len)
    zclib.Debug_Net("zmc_Customertable_Open", len)

    zmc.vgui.ActiveEntity = net.ReadEntity()

    zmc.Customertable.Appearance()
end)

local SelectedTable
local SelectedSeat
function zmc.Customertable.Appearance()
    zmc.vgui.Page(zmc.language["Appearance"],function(main,top)

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

        // Save Button
        local save_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("save"),function()

            if zmc.Table.GetData(SelectedTable) == nil then return end

            net.Start("zmc_Customertable_Update")
            net.WriteEntity(zmc.vgui.ActiveEntity)
            net.WriteUInt(SelectedTable,16)
            net.WriteInt(SelectedSeat,16)
            net.SendToServer()

            zmc_main_panel:Close()
        end,false)
        save_btn:Dock(RIGHT)
        save_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        save_btn.IconColor = zclib.colors["green01"]

        local top_pnl = vgui.Create("DPanel", main)
        top_pnl:SetSize(600 * zclib.wM, 400 * zclib.hM)
        top_pnl:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
        top_pnl:Dock(TOP)
        top_pnl.Paint = function(s, w, h)
            //draw.RoundedBox(5, 0, 0, w, h, zclib.colors["red01"])
        end

        SelectedTable = zmc.vgui.ActiveEntity:GetTableID()
        SelectedSeat = zmc.vgui.ActiveEntity:GetSeatID()

        local TableData = zmc.Table.GetData(SelectedTable)
        local SeatData = zmc.Seat.GetData(SelectedSeat)

        local Table_Preview = zmc.vgui.CustomerTable(top_pnl,TableData,SeatData)
        Table_Preview:SetTall(400 * zclib.hM)
        Table_Preview:SetWide(400 * zclib.hM)
        Table_Preview:Dock( RIGHT )


        /////////// Create Table config
        local list,scroll = zmc.vgui.List(top_pnl)
        scroll:SetTall(400 * zclib.hM)
        scroll:SetWide(500 * zclib.hM)
        scroll:Dock( FILL )
        scroll:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end

        for id, data in pairs(zmc.config.Tables) do

            local item_pnl = zmc.vgui.Slot(data,function()

                //IsSelected
                return SelectedTable == id
            end,function()

                // CanSelect
                return true
            end,function()

                // OnSelect
                SelectedTable = id
                TableData = zmc.Table.GetData(SelectedTable)
                SeatData = zmc.Seat.GetData(SelectedSeat)
                Table_Preview:SetModel(TableData.mdl)
                Table_Preview:BuildClientModels(TableData,SeatData)
            end,function()

                // PreDraw
            end,function(w,h)

                // PostDraw
            end)
            list:Add(item_pnl)
            item_pnl:SetSize(149 * zclib.wM, 149 * zclib.hM)
            item_pnl.font_name = zclib.GetFont("zclib_font_small")
        end
        ///////////


        /////////// Create Seat config
        local s_list,s_scroll = zmc.vgui.List(main)
        s_scroll:SetTall(320 * zclib.hM)
        s_scroll:Dock( FILL )
        s_scroll:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        s_scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end

        local empty_pnl_font = zclib.util.FontSwitch(zmc.language["NO SEAT"],100 * zclib.wM,zclib.GetFont("zclib_font_small"),zclib.GetFont("zclib_font_tiny"))
        local empty_pnl = zmc.vgui.Slot(nil,function()

            //IsSelected
            return SelectedSeat == -1
        end,function()

            // CanSelect
            return true
        end,function()

            // OnSelect
            SelectedSeat = -1
            TableData = zmc.Table.GetData(SelectedTable)
            SeatData = zmc.Seat.GetData(SelectedSeat)
            Table_Preview:BuildClientModels(TableData,SeatData)
        end,function()

            // PreDraw
        end,function(w,h)

            // PostDraw
            draw.SimpleText(zmc.language["NO SEAT"], empty_pnl_font, w / 2, h / 2,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end)

        s_list:Add(empty_pnl)
        empty_pnl:SetSize(100 * zclib.wM, 100 * zclib.hM)
        empty_pnl.font_name = zclib.GetFont("zclib_font_small")

        for id, data in pairs(zmc.config.Seats) do
            local item_pnl = zmc.vgui.Slot(data,function()

                //IsSelected
                return SelectedSeat == id
            end,function()

                // CanSelect
                return true
            end,function()

                // OnSelect
                SelectedSeat = id
                TableData = zmc.Table.GetData(SelectedTable)
                SeatData = zmc.Seat.GetData(SelectedSeat)
                Table_Preview:BuildClientModels(TableData,SeatData)
            end,function()

                // PreDraw
            end,function(w,h)

                // PostDraw
            end)
            s_list:Add(item_pnl)
            item_pnl:SetSize(100 * zclib.wM, 100 * zclib.hM)
            item_pnl.font_name = zclib.GetFont("zclib_font_small")
        end
        ///////////
    end)
end
