if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Machine.Editor = zvm.Machine.Editor or {}

local StyleData

/*
    Creates a simple TextButton
*/
local function TextButton(parent,x,y,txt,color,OnClick)
    local btn = vgui.Create("DButton",parent)
    btn:SetPos(x * zclib.wM, y * zclib.hM)
    btn:SetSize(150 * zclib.wM, 40 * zclib.hM)
    btn:SetAutoDelete(true)
    btn:SetText("")
    btn.Text = txt
    btn.Paint = function(s, w, h)

        draw.RoundedBox(0, 0, 0, w, h, color)
        draw.SimpleText(s.Text, zclib.GetFont("zclib_font_medium"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, zclib.colors["white_a15"])
        end
    end
    btn.DoClick = function()
        surface.PlaySound("UI/buttonclick.wav")
        pcall(OnClick,btn)
    end
end

/*
    Creates a quick confirmation window
*/
local function ConfirmationWindow(Question,OnAccept,OnDecline)

    local main = vgui.Create( "DPanel" )
    main:MakePopup()
    main:SetSize(zclib_main_panel:GetWide(),zclib_main_panel:GetTall())
    main:Center()
    main.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a200"])
    end

    local window = vgui.Create( "DPanel" ,main)
    window:SetSize(500 * zclib.wM,200 * zclib.hM)
    window:Center()
    window.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
        //draw.RoundedBox(10, 50 * zclib.wM,70 * zclib.hM, w, 5 * zclib.hM, zclib.colors["ui01"])
        draw.SimpleText(Question, zclib.GetFont("zclib_font_big"), w / 2,30 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end


    TextButton(window,50,120, zvm.language.General["Yes"], zvm.colors["green01"], function()
        pcall(OnAccept)
        main:Remove()
    end)

    TextButton(window,300,120, zvm.language.General["No"], zvm.colors["red01"], function()
        if OnDecline then pcall(OnDecline) end
        main:Remove()
    end)
end

/*
    Creates a button with a image
*/
local function AddImageButton(parent, image, color, OnClick,IsLocked,tooltip)
    local btn = zclib.vgui.ImageButton(0, 0, 50 * zclib.wM, 50 * zclib.hM, parent, image, function()
        pcall(OnClick)
    end,function()
        return IsLocked()
    end)
    btn:Dock(RIGHT)
    btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
    btn.IconColor = color
    btn:SetTooltip(tooltip)
    return btn
end

/*
    Creates a TextEntry with a Button to open a list of cached Imgur images
*/
local OptionPanel
local function ImageGallery(OnImageSelected,txt)

    if IsValid(OptionPanel) then OptionPanel:Remove() end

    local main = vgui.Create( "DPanel" )
    main:MakePopup()
    main:SetSize(zclib_main_panel:GetWide(),zclib_main_panel:GetTall())
    main:Center()

    local title_font = zclib.GetFont("zclib_font_big")
    local txtW = zclib.util.GetTextSize(zvm.language.General["CachedImages"],title_font)
    if txtW >= (480 * zclib.wM) then
        title_font = zclib.GetFont("zclib_font_medium")
    end

    main.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
        draw.RoundedBox(10, 50 * zclib.wM,70 * zclib.hM, w, 5 * zclib.hM, zclib.colors["ui01"])
        draw.SimpleText(zvm.language.General["CachedImages"], title_font, 50 * zclib.wM,15 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    OptionPanel = main


    local function GoBack()
        main:Remove()
    end

    local back_btn = zclib.vgui.ImageButton(zclib_main_panel:GetWide() - 60 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,main,zclib.Materials.Get("back"),function()
        GoBack()
    end,false)
    back_btn.IconColor = zclib.colors["red01"]

    local list,scroll = zclib.vgui.List(main)
    scroll:DockMargin(50 * zclib.wM,90 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
    list:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    list:SetSpaceY( 10 * zclib.hM)
    list:SetSpaceX( 10 * zclib.wM)
    scroll.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a50"])
    end

    local itmSize = (zclib_main_panel:GetWide() - 100 * zclib.wM) / 6
    itmSize = itmSize - 28 * zclib.wM
    for imgurid,img_mat in pairs(zclib.Imgur.CachedMaterials) do
        if img_mat == nil then continue end
        if imgurid == nil then continue end
        local b = vgui.Create("DButton",list)
        list:Add(b)
        b:SetText("")
        b:SetSize(itmSize * zclib.wM, itmSize * zclib.hM )
        b.DoClick = function()
            OnImageSelected(imgurid,txt)
            GoBack()
        end
        b.mat = img_mat
        b.Paint = function(s, w, h)
            if s.mat then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(s.mat)
                surface.DrawTexturedRect(0,0,w,h)
            end
        end
    end
end
local function ImgurEntry(parent,default,OnImageSelected)
    local txt = zclib.vgui.TextEntry(parent,default,OnImageSelected,false)
    txt:Dock(TOP)
    txt:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    txt.bg_color = zclib.colors["black_a50"]

    local gallery_btn = AddImageButton(txt, zclib.Materials.Get("clipboard"), zclib.colors["blue01"], function()
        ImageGallery(OnImageSelected,txt)
    end,function() return false end,zvm.language.General["OpenCachedImages"])
    gallery_btn.IconColor = zclib.colors["blue01"]
    gallery_btn.NoneHover_IconColor = zclib.colors["text01"]
    gallery_btn:Dock(RIGHT)
    gallery_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


    return txt
end

/*
    Updates the provided models lua material
*/
local function UpdateModel(Machine_ent)
    // Builds / updates the material
    zvm.Machine.GetMaterial("zvm_Machine_paint_mat_editor",StyleData)

    // Reset all materials
    Machine_ent:SetSubMaterial()

    Machine_ent:SetSubMaterial(1, "!" .. "zvm_Machine_paint_mat_editor")
end

/*
    Creates a generic NumSlider
*/
local function NumSlider(parent,default, title, OnChange, Min, Max, Decimal)
    local DermaNumSlider = vgui.Create("DNumSlider", parent)
    DermaNumSlider:SetPos(50, 50)
    DermaNumSlider:SetSize(300, 30 * zclib.hM)
    DermaNumSlider:SetMin(Min)
    DermaNumSlider:SetMax(Max)
    DermaNumSlider:SetDecimals(Decimal)
    DermaNumSlider:SetValue(default)
    DermaNumSlider:DockPadding(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
    DermaNumSlider.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, zclib.colors["black_a50"])
    end
    DermaNumSlider:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    DermaNumSlider:Dock(TOP)
    DermaNumSlider.OnValueChanged = function(self, value) pcall(OnChange, value) end

    DermaNumSlider.Label:SetFont(zclib.GetFont("zclib_font_small"))
    DermaNumSlider.Label:SetTextColor(zclib.colors["text01"])
    DermaNumSlider:SetText(title)
    DermaNumSlider.PerformLayout = function(self) self.Label:SetWide( self:GetWide() / 3 ) end
    DermaNumSlider.TextArea:SetDrawLanguageID(false)
    DermaNumSlider.TextArea.Paint = function(s, w, h)
        if s:GetText() == "" and not s:IsEditing() then draw.SimpleText(emptytext, zclib.GetFont("zclib_font_small"), 5 * zclib.wM, h / 2, zclib.colors["white_a15"], 0, 1) end
        s:DrawTextEntryText(color_white, zclib.colors["textentry"], color_white)
    end
    DermaNumSlider.TextArea.PerformLayout = function(s,width, height) s:SetFontInternal(zclib.GetFont("zclib_font_small")) end

    return DermaNumSlider
end

/*
    Creates a generic CategoryBox
*/
local function CategoryBox(list,name,content)

    local cat_itm = list:Add( name )
    cat_itm:SetTall( 100 )
    cat_itm:SetHeaderHeight(30 * zclib.hM)
    cat_itm.Header:SetTextColor(zclib.colors["orange01"])
    cat_itm.Header:SetFont(zclib.GetFont("zclib_font_mediumsmall"))
    cat_itm:SetExpanded(false)
    cat_itm.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
    end

    local container = vgui.Create("DPanel", list)
    container.Paint = function(s, w, h) end
    container:DockPadding(0, 0 * zclib.hM, 0, 10 * zclib.hM)
    list:AddItem(container)

    pcall(content,container,cat_itm)

    // Add DPanelList to our Collapsible Category
    cat_itm:SetContents( container )

    container:InvalidateLayout(true)
    container:SizeToChildren(false,true)
end

/*
    Creates a titled ColorMixer
*/
local function ColorMixer(parent,default,title,alpha,OnChange)
    local pnl = zclib.vgui.Panel(parent, title)
    pnl:SetSize(245 * zclib.wM, 120 * zclib.hM)
    pnl:Dock(TOP)
    pnl:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    pnl:DockPadding(0, -10 * zclib.hM, 0, 10 * zclib.hM)

    pnl.Title_font = zclib.GetFont("zclib_font_small")
    pnl.Title_color = zclib.colors["text01"]
    pnl.BG_color = zclib.colors["black_a50"]

    local paint_color = zclib.vgui.Colormixer(pnl,default,function(col)
    end,function(col)
        pcall(OnChange,col)
    end)

    paint_color:Dock(FILL)
    paint_color:SetWangs(false)
    paint_color:SetAlphaBar(alpha)
end

/*
    Creates a ComboBox to select a Image Processing Blendmode
*/
local function BlendMode(parent,default,OnChange)
    local pnl = zclib.vgui.Panel(parent, "BlendMode")
    pnl:SetSize(245 * zclib.wM, 70 * zclib.hM)
    pnl:Dock(TOP)
    pnl:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    pnl:DockPadding(0, 10 * zclib.hM, 0, 10 * zclib.hM)

    pnl.Title_font = zclib.GetFont("zclib_font_small")
    pnl.Title_color = zclib.colors["text01"]
    pnl.BG_color = zclib.colors["black_a50"]

    local blendmode_DComboBox = zclib.vgui.ComboBox(pnl,zvm.Machine.BlendModes[default].name,function(index, value,apnl)
        pcall(OnChange,index, value,apnl)
    end)
    blendmode_DComboBox:SetTall(30 * zclib.hM)
    blendmode_DComboBox:SetSortItems( false )
    blendmode_DComboBox:DockMargin(10 * zclib.wM,20 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    blendmode_DComboBox:Dock(TOP)

    for i,v in pairs(zvm.Machine.BlendModes) do blendmode_DComboBox:AddChoice(v.name, i) end
end

/*
    Opens the style selection menu
*/
function zvm.Machine.Editor.MainMenu(Machine)
    zclib.vgui.Page(zvm.language.General["StyleSelection"], function(main, top)
        main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)

        AddImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zvm.language.General["Close"])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

        local SelectedID = Machine:GetStyleID() or -1

        local function InvalidStyle() return not zvm.Machine.GetStyleData(SelectedID) end

        // Only admins can edit the skins
        if zclib.Player.IsAdmin(LocalPlayer()) then

            AddImageButton(top, zclib.Materials.Get("delete"), zclib.colors["red01"], function()
                if SelectedID and zvm.Machine.GetStyleData(SelectedID) then

                    ConfirmationWindow(zvm.language.General["DeleteStyle"],function()
                        zvm.Machine.Styles[SelectedID] = nil
                        SelectedID = nil
                        zvm.Machine.Editor.UpdateServer()
                        zvm.Machine.Editor.Wait(Machine)
                    end)
                end
            end, function() return InvalidStyle() end, zvm.language.General["DeleteStyle"])

            AddImageButton(top, zclib.Materials.Get("edit"), zclib.colors["orange01"], function()
                if SelectedID and zvm.Machine.GetStyleData(SelectedID) then
                    zvm.Machine.Editor.Appearance(SelectedID,Machine)
                end
            end,function() return InvalidStyle() end,zvm.language.General["EditStyle"])

            AddImageButton(top, zclib.Materials.Get("duplicate"), zclib.colors["blue02"], function()
                if SelectedID and zvm.Machine.GetStyleData(SelectedID) then

                    ConfirmationWindow(zvm.language.General["DuplicateStyle"],function()
                        local bStyle = table.Copy(zvm.Machine.GetStyleData(SelectedID))
                        bStyle.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
                        table.insert(zvm.Machine.Styles,bStyle)

                        zvm.Machine.Editor.UpdateServer()

                        // NOTE We need to build the material before the snapshoter is gonna use it in the next frame to render the thumbnail
                        // Its something about the Imgur material not being present in the current frame
                        zvm.Machine.GetMaterial("zvm_machine_style_mat_" .. bStyle.uniqueid,bStyle)

                        zvm.Machine.Editor.Wait(Machine)
                    end)
                end
            end,function() return InvalidStyle() end,zvm.language.General["DuplicateStyle"])

            AddImageButton(top, zclib.Materials.Get("plus"), zclib.colors["green01"], function()
                zvm.Machine.Editor.Appearance(nil,Machine)
            end,function() return false end,zvm.language.General["CreateStyle"])

            local seperator = zclib.vgui.AddSeperator(top)
            seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
            seperator:Dock(RIGHT)
            seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
        end

        // Assign selected style to machine
        AddImageButton(top, zclib.Materials.Get("accept"), zclib.colors["green01"], function()
            if SelectedID and zvm.Machine.GetStyleData(SelectedID) and IsValid(Machine) then

                net.Start("zvm_Machine_Style_Update")
            	net.WriteEntity(Machine)
            	net.WriteUInt(SelectedID, 32)
            	net.SendToServer()

                main:Close()

                timer.Simple(0.25,function()
                    if IsValid(Machine) then
                        zvm.Machine.EditAppearance(Machine)
                    end
                end)
            end
        end,function() return InvalidStyle() end,zvm.language.General["ApplyStyle"])

        local Machines_content = vgui.Create("DPanel", main)
        Machines_content:SetSize(1000 * zclib.wM, 1000 * zclib.hM)
        Machines_content:Dock(FILL)
        Machines_content:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
        Machines_content.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
            draw.RoundedBox(5, w - 15 * zclib.wM, 0, 15 * zclib.wM, h, zclib.colors["black_a50"])
        end

        local list,scroll = zclib.vgui.List(Machines_content)
        scroll:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        list:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        list:SetSpaceY( 10 * zclib.hM)
        list:SetSpaceX( 10 * zclib.wM)

        local PnlSize = 207
        for k,v in pairs(zvm.Machine.Styles) do
            local itm = vgui.Create("DPanel")
            itm:SetSize(PnlSize * zclib.wM, PnlSize * zclib.hM)
            itm.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, SelectedID == k and zclib.colors["ui_highlight"] or zclib.colors["ui00"])
            end
            list:Add(itm)

            local imgpnl = vgui.Create("DImage",itm)
            imgpnl:Dock(FILL)
            local img = zclib.Snapshoter.Get({class = "zvm_machine",model = "models/zerochain/props_vendingmachine/zvm_machine.mdl",StyleID = v.uniqueid}, imgpnl)
            imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")

            local btnpnl = vgui.Create("DButton",itm)
            btnpnl:Dock(FILL)
            btnpnl:SetText("")
            btnpnl.Paint = function(s, w, h)
                if s:IsHovered() then
                    draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
                end
            end
            btnpnl.DoClick = function(s)
                SelectedID = k
                zclib.vgui.PlaySound("UI/buttonclick.wav")
            end
        end
    end)
end

/*
    Opens the style editor
*/
function zvm.Machine.Editor.Appearance(id,Machine)
    zclib.vgui.Page(zvm.language.General["StyleEditor"], function(main, top)
        main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)

        local FoundStyle = zvm.Machine.GetStyleData(id)
        if FoundStyle == nil then
            StyleData = {}
            StyleData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
        else
            StyleData = table.Copy(FoundStyle)
        end

        // Verify Data integrity
        StyleData = zvm.Machine.VerifyStyleData(StyleData)

        AddImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zvm.language.General["Close"])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

        AddImageButton(top, zclib.Materials.Get("back"), zclib.colors["orange01"], function()
            zvm.Machine.Editor.MainMenu(Machine)
        end,function() return false end, zvm.language.General["Back"])

        AddImageButton(top, zclib.Materials.Get("save"), zclib.colors["green01"], function()

            if id then
                // Overwrite existing one
                StyleData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
                zvm.Machine.Styles[id] = table.Copy(StyleData)
            else
                // Create new
                table.insert(zvm.Machine.Styles,StyleData)
            end

            zvm.Machine.Editor.UpdateServer()

            // NOTE We need to build the material before the snapshoter is gonna use it in the next frame to render the thumbnail
            // Its something about the Imgur material not being present in the current frame
            zvm.Machine.GetMaterial("zvm_machine_style_mat_" .. StyleData.uniqueid,StyleData)

            zvm.Machine.Editor.Wait(Machine)
        end,function() return false end, zvm.language.General["SaveStyle"])



        local PageContent = vgui.Create("DPanel", main)
        PageContent:SetSize(1000 * zclib.wM, 800 * zclib.hM)
        PageContent:Dock(FILL)
        PageContent:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
        PageContent.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
        end

        local mdl = zclib.vgui.DAdjustableModelPanel({model = "models/zerochain/props_vendingmachine/zvm_machine.mdl"})
        mdl:SetParent(PageContent)
        mdl:Dock(FILL)
        mdl:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
        mdl:SetDirectionalLight(BOX_TOP, color_white)
        mdl:SetDirectionalLight(BOX_FRONT, color_white)
        mdl:SetDirectionalLight(BOX_BACK, color_white)
        mdl:SetDirectionalLight(BOX_LEFT, color_black)
        mdl:SetDirectionalLight(BOX_RIGHT, color_white)

        function mdl:PreDrawModel(ent)
            cam.Start2D()

                surface.SetDrawColor(zclib.colors["text01"])
                surface.SetMaterial(zclib.Materials.Get("item_bg"))
                surface.DrawTexturedRect(0,0,mdl:GetWide(),mdl:GetTall())

                draw.SimpleText(zvm.language.General["Touch"], zclib.GetFont("zclib_font_giant"), mdl:GetWide() / 2, mdl:GetTall() / 2, zclib.colors["black_a50"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End2D()
        end

		mdl:OnMousePressed(MOUSE_LEFT)
		timer.Simple(0, function()
			if IsValid(mdl) then
				mdl:OnMouseReleased(MOUSE_LEFT)
			end
		end)

        local OptionsPnl = vgui.Create("DPanel", PageContent)
        OptionsPnl:SetSize(410 * zclib.wM, 800 * zclib.hM)
        OptionsPnl:Dock(LEFT)
        OptionsPnl:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
        OptionsPnl:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
        OptionsPnl.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"]) end

        local cat_list = vgui.Create("DCategoryList", OptionsPnl)
        cat_list:SetSize(300 * zclib.wM, 200 * zclib.hM)
        cat_list:DockPadding(0, 0 * zclib.hM, 0, 0 * zclib.hM)
        cat_list:Dock(FILL)
        cat_list.Paint = function(s, w, h) end
        local sbar = cat_list:GetVBar()
    	sbar:SetHideButtons(true)
    	function sbar:Paint(w, h) draw.RoundedBox(5, w * 0.1, 0, w * 0.8, h, zclib.colors["black_a50"]) end
    	function sbar.btnUp:Paint(w, h) end
    	function sbar.btnDown:Paint(w, h) end
        function sbar.btnGrip:Paint(w, h) draw.RoundedBox(5, w * 0.1, 0, w * 0.8, h, zclib.colors["text01"]) end


        local ImgurMat
        local LogoMat
        local EmissveMat

        local LastFrame = CurTime()

        CategoryBox(cat_list,zvm.language.General["Material"],function(parent)

            // Select which model
            local skin_DComboBox = zclib.vgui.ComboBox(parent,zvm.Machine.GetSkinData(StyleData.skin).name,function(index, value,pnl)
                StyleData.skin = pnl:GetOptionData( index )
                UpdateModel(mdl.Entity)
            end)
            skin_DComboBox:SetTall(40 * zclib.hM)
            skin_DComboBox:SetSortItems( false )
            skin_DComboBox:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
            skin_DComboBox:Dock(TOP)
            for k, v in pairs(zvm.Machine.Skins) do skin_DComboBox:AddChoice(v.name, k) end

            // Base color
            ColorMixer(parent,StyleData.color,zvm.language.General["Base Color"],false,function(col)
                StyleData.color = Color(col.r,col.g,col.b,255)
                UpdateModel(mdl.Entity)
            end)

            // Reflection color
            ColorMixer(parent,StyleData.spec_color,zvm.language.General["Reflection Color"],false,function(col)
                StyleData.spec_color = Color(col.r,col.g,col.b,255)
                UpdateModel(mdl.Entity)
            end)


            NumSlider(parent,StyleData.fresnel,zvm.language.General["Fresnel"],function(val)
                StyleData.fresnel = val
                UpdateModel(mdl.Entity)
            end,0,15,1)

            NumSlider(parent,StyleData.reflection,zvm.language.General["Reflection"],function(val)
                StyleData.reflection = val
                UpdateModel(mdl.Entity)
            end,0,15,1)
        end)

        CategoryBox(cat_list,zvm.language.General["Imgur"],function(parent)

            // Imgur color
            ColorMixer(parent,StyleData.imgur_color,zvm.language.General["Image Color"],true,function(col)
                StyleData.imgur_color = Color(col.r,col.g,col.b,col.a)
                UpdateModel(mdl.Entity)
            end)

            // Blendmode
            BlendMode(parent, StyleData.imgur_blendmode or 0, function(index, value, pnl)
                local val = pnl:GetOptionData(index)
                StyleData.imgur_blendmode = val
                UpdateModel(mdl.Entity)
            end)

            local Entry = ImgurEntry(parent,zvm.language.General["ImgurID"],function(val,txt)
                StyleData.imgur_url = val
                ImgurMat = nil
                zclib.Imgur.GetMaterial(tostring(StyleData.imgur_url), function(result)
                    if result then
                        ImgurMat = result
                    else
                        StyleData.imgur_url = nil
                    end

                    UpdateModel(mdl.Entity)
                end)

                if LastFrame ~= CurTime() then
                    txt:SetValue(StyleData.imgur_url)
                    LastFrame = CurTime()
                end
            end)
            if StyleData.imgur_url then
                Entry:SetValue(StyleData.imgur_url)
            end

            NumSlider(parent,StyleData.imgur_x,zvm.language.General["PositionX"],function(val)
                StyleData.imgur_x = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            NumSlider(parent,StyleData.imgur_y,zvm.language.General["PositionY"],function(val)
                StyleData.imgur_y = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            NumSlider(parent,StyleData.imgur_scale,zvm.language.General["Scale"],function(val)
                StyleData.imgur_scale = val
                UpdateModel(mdl.Entity)
            end,0.1,15,2)

            if StyleData and StyleData.imgur_url then
                zclib.Imgur.GetMaterial(tostring(StyleData.imgur_url), function(result)
                    if result then
                        ImgurMat = result
                        UpdateModel(mdl.Entity)
                    end
                end)
            end
        end)

        CategoryBox(cat_list,zvm.language.General["Logo"],function(parent)

            // Imgur color
            ColorMixer(parent,StyleData.logo_color,zvm.language.General["Image Color"],true,function(col)
                StyleData.logo_color = Color(col.r,col.g,col.b,col.a)
                UpdateModel(mdl.Entity)
            end)

            // Blendmode
            BlendMode(parent, StyleData.logo_blendmode or 0, function(index, value, pnl)
                local val = pnl:GetOptionData(index)
                StyleData.logo_blendmode = val
                UpdateModel(mdl.Entity)
            end)

            local Entry = ImgurEntry(parent,zvm.language.General["ImgurID"],function(val,txt)
                StyleData.logo_url = val
                LogoMat = nil
                zclib.Imgur.GetMaterial(tostring(StyleData.logo_url), function(result)
                    if result then
                        LogoMat = result
                    else
                        StyleData.logo_url = nil
                    end

                    UpdateModel(mdl.Entity)
                end)

                if LastFrame ~= CurTime() then
                    txt:SetValue(StyleData.logo_url)
                    LastFrame = CurTime()
                end
            end)
            if StyleData.logo_url then Entry:SetValue(StyleData.logo_url) end

            NumSlider(parent,StyleData.logo_x or 0.5,zvm.language.General["PositionX"],function(val)
                StyleData.logo_x = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            NumSlider(parent,StyleData.logo_y or 0.5,zvm.language.General["PositionY"],function(val)
                StyleData.logo_y = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            NumSlider(parent,StyleData.logo_scale or 1,zvm.language.General["Scale"],function(val)
                StyleData.logo_scale = val
                UpdateModel(mdl.Entity)
            end,0.05,1,2)

            NumSlider(parent,StyleData.logo_rotation or 0,zvm.language.General["Rotation"],function(val)
                StyleData.logo_rotation = val
                UpdateModel(mdl.Entity)
            end,0,360,0)

            if StyleData and StyleData.logo_url then
                zclib.Imgur.GetMaterial(tostring(StyleData.logo_url), function(result)
                    if result then
                        LogoMat = result
                        UpdateModel(mdl.Entity)
                    end
                end)
            end
        end)

        CategoryBox(cat_list,zvm.language.General["Emissive"],function(parent)

            NumSlider(parent,StyleData.em_strength,zvm.language.General["Strength"],function(val)
                StyleData.em_strength = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            // Imgur color
            ColorMixer(parent,StyleData.em_color,zvm.language.General["Emissive Color"],false,function(col)
                StyleData.em_color = Color(col.r,col.g,col.b,255)
                UpdateModel(mdl.Entity)
            end)

            local Entry = ImgurEntry(parent,zvm.language.General["ImgurID"],function(val,txt)
                StyleData.em_url = val
                EmissveMat = nil
                zclib.Imgur.GetMaterial(tostring(StyleData.em_url), function(result)
                    if result then
                        EmissveMat = result
                    else
                        StyleData.em_url = nil
                    end

                    UpdateModel(mdl.Entity)
                end)

                if LastFrame ~= CurTime() then
                    txt:SetValue(StyleData.em_url)
                    LastFrame = CurTime()
                end
            end)
            if StyleData.em_url then
                Entry:SetValue(StyleData.em_url)
            end

            NumSlider(parent,StyleData.em_x,zvm.language.General["PositionX"],function(val)
                StyleData.em_x = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            NumSlider(parent,StyleData.em_y,zvm.language.General["PositionY"],function(val)
                StyleData.em_y = val
                UpdateModel(mdl.Entity)
            end,0,1,2)

            NumSlider(parent,StyleData.em_scale,zvm.language.General["Scale"],function(val)
                StyleData.em_scale = val
                UpdateModel(mdl.Entity)
            end,0.1,15,2)

            if StyleData and StyleData.em_url then
                zclib.Imgur.GetMaterial(tostring(StyleData.em_url), function(result)
                    if result then
                        EmissveMat = result
                        UpdateModel(mdl.Entity)
                    end
                end)
            end
        end)

        local ImgurImagePreview = vgui.Create("DButton", OptionsPnl)
        ImgurImagePreview:SetText("")
        ImgurImagePreview:SetSize(350 * zclib.wM, 350 * zclib.hM)
        ImgurImagePreview:Dock(BOTTOM)
        ImgurImagePreview:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        ImgurImagePreview.ToggledOpen = true
        ImgurImagePreview.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
            if ImgurImagePreview.ToggledOpen then

                zvm.Machine.DrawMaterial(w,h,StyleData,ImgurMat,LogoMat)

            	if EmissveMat then
                    local lastMul = surface.GetAlphaMultiplier()
                    surface.SetAlphaMultiplier(StyleData.em_strength)
                    local bm = zvm.Machine.BlendModes[1]
        			render.OverrideBlend(true, bm.srcBlend, bm.destBlend, bm.blendFunc, bm.srcBlendAlpha, bm.destBlendAlpha, bm.blendFuncAlpha)
        				zvm.Machine.DrawEmissive(StyleData, EmissveMat, w,h)
        			render.OverrideBlend( false )
                    surface.SetAlphaMultiplier(lastMul)
            	end

                if s:IsHovered() then
                    draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a200"])
                    draw.SimpleText(zvm.language.General["Close"], zclib.GetFont("zclib_font_big"), w / 2, h / 2, zclib.colors["orange01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            else
                draw.SimpleText(zvm.language.General["2D Preview"], zclib.GetFont("zclib_font_mediumsmall"), w / 2, h / 2, zclib.colors["orange01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        ImgurImagePreview.DoClick = function()
            if ImgurImagePreview.Animating then return end
            //surface.PlaySound("zerolib/upgrade.wav")
            zclib.vgui.PlayEffectAtPanel("Magic",ImgurImagePreview,0,0)

            ImgurImagePreview.Animating = true

            ImgurImagePreview:SizeTo(ImgurImagePreview:GetWide(), (not ImgurImagePreview.ToggledOpen) and 350 * zclib.hM or 30 * zclib.hM, 0.15, 0, -1, function()
                ImgurImagePreview.ToggledOpen = not ImgurImagePreview.ToggledOpen
                ImgurImagePreview.Animating = false
            end)
        end

        UpdateModel(mdl.Entity)
    end)
end

/*
    Creates a page which display a loading symbol
*/
function zvm.Machine.Editor.Wait(Machine)
    zclib.vgui.Page(zvm.language.General["StyleEditor"], function(main, top)
        main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)

        local ImgurImagePreview = vgui.Create("DPanel", main)
        ImgurImagePreview:Dock(FILL)
        ImgurImagePreview:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        ImgurImagePreview.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])

            surface.SetDrawColor(zclib.colors["text01"])
            surface.SetMaterial(zclib.Materials.Get("icon_loading"))
            surface.DrawTexturedRectRotated(w / 2, h / 2, 300 * zclib.wM,300 * zclib.hM, CurTime() * 100)
        end

        timer.Simple(0.25,function()
            zvm.Machine.Editor.MainMenu(Machine)
        end)
    end)
end

/*
    Tell zcLib Data system to send net msg to SERVER
*/
function zvm.Machine.Editor.UpdateServer()
    // Send net msg to server
    zclib.Data.UpdateConfig("zvm_machine_styles")
end
