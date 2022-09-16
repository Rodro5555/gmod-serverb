zgo2 = zgo2 or {}
zgo2.Editor = zgo2.Editor or {}

local UpdateTracker = {
	//[pnl] = default
}

/*
	Updates every single slider / ComboBox / colormixer to dislay the current data values
*/
function zgo2.Editor.UpdateControlls()
	local delay = 0
	for k,v in pairs(UpdateTracker) do
		if not IsValid(k) then continue end

		timer.Simple(delay,function()
			if IsValid(k) then
				k:OnUpdate()
			end
		end)
		delay = delay + 0.005
	end
	return table.Count(UpdateTracker) * 0.005
end

/*
    Creates a CategoryBox
*/
function zgo2.Editor.CategoryBox(list,name,content)

    local cat_itm = list:Add( name )
    cat_itm:SetTall( 100 )
    cat_itm:SetHeaderHeight(30 * zclib.hM)
    cat_itm.Header:SetTextColor(zclib.colors["orange01"])
    cat_itm.Header:SetFont(zclib.GetFont("zclib_font_mediumsmall"))
    cat_itm:SetExpanded(false)
    cat_itm.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
    end
	cat_itm:DockMargin(0 * zclib.wM, 5 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

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
    Creates a ColorMixer
*/
function zgo2.Editor.ColorMixer(parent,default,title,alpha,OnChange,OnUpdate)
    local pnl = zclib.vgui.Panel(parent, title)
    pnl:SetSize(245 * zclib.wM, 110 * zclib.hM)
    pnl:Dock(TOP)
    pnl:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    pnl:DockPadding(0, -5 * zclib.hM, 0, 10 * zclib.hM)

    pnl.Title_font = zclib.GetFont("zclib_font_small")
    pnl.Title_color = zclib.colors["text01"]
    pnl.BG_color = zclib.colors["black_a100"]

	local paint_color

	local tpnl = vgui.Create("DPanel",pnl)
	tpnl:Dock(RIGHT)
	tpnl:SetSize(80 * zclib.wM, 200 * zclib.hM)
	tpnl:DockMargin(10 * zclib.wM,40 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
	tpnl.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, paint_color:GetColor())
	end

    paint_color = zclib.vgui.Colormixer(pnl,default,function(col)
    end,function(col,s)
        pcall(OnChange,col)
    end)

    paint_color:Dock(FILL)
    paint_color:SetWangs(true)
    paint_color:SetAlphaBar(alpha)

	paint_color.OnUpdate = function(s)
		pcall(OnUpdate,s)
	end

	UpdateTracker[paint_color] = true
	return pnl
end

/*
	Creates a Numslider
*/
function zgo2.Editor.Numslider(parent, default, title, OnChange, Min, Max, Decimal,OnUpdate)

	local slider = zgo2.vgui.NumSlider(parent, default,title, function(val,pnl)
		pcall(OnChange,val,pnl)
	end,  Min, Max, Decimal)

	slider.OnUpdate = function(s)
		pcall(OnUpdate,s)
	end

	UpdateTracker[slider] = true

	return slider
end

/*
	Creates a CheckBox
*/
function zgo2.Editor.CheckBox(parent,default,title,OnChange,OnUpdate)

	local pnl = vgui.Create("DPanel", parent)
    pnl:SetTall(30 * zclib.hM)
    pnl:Dock(TOP)
    pnl:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
    pnl:DockPadding(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
    pnl.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])
    end

    local lbl = vgui.Create("DLabel", pnl)
	lbl:SetWide(300 * zclib.wM)
    lbl:Dock(LEFT)
    lbl:SetMouseInputEnabled(true)
    lbl:SetFont(zclib.GetFont("zclib_font_small"))
    lbl:SetTextColor(zclib.colors["text01"])
    lbl:SetText(title)

    local p = vgui.Create("DButton", pnl)
    p:Dock(FILL)
	p:DockMargin(5 * zclib.wM, 5 * zclib.hM, 5 * zclib.wM, 5 * zclib.hM)
    p.locked = false
    p.state = default
    p.slideValue = 0
    p:SetAutoDelete(true)
    p:SetText("")
    p.Paint = function(s, w, h)

        local BoxWidth = w
        local BoxHeight = h
        local BoxPosY = 0
        local BoxPosX = 0

        draw.RoundedBox(4, BoxPosX, BoxPosY, BoxWidth, BoxHeight, zclib.colors["black_a100"])

        if s.state then
            s.slideValue = Lerp(5 * FrameTime(), s.slideValue, 1)
        else
            s.slideValue = Lerp(5 * FrameTime(), s.slideValue, 0)
        end

        local col = zclib.util.LerpColor(s.slideValue, zclib.colors["red01"], zclib.colors["green01"])
        draw.RoundedBox(4, BoxPosX + (BoxWidth - BoxHeight) * s.slideValue, BoxPosY, BoxHeight, BoxHeight, col)

        if p.locked == true then
            draw.RoundedBox(4, BoxPosX, BoxPosY, BoxWidth, BoxHeight, zclib.colors["black_a100"])
        end
    end
    p.DoClick = function(s)
        if p.locked == true then return end
        zclib.vgui.PlaySound("UI/buttonclick.wav")
        s.state = not s.state
        pcall(OnChange,s.state)
    end

	p.OnUpdate = function(s)
		pcall(OnUpdate,s)
	end
	UpdateTracker[p] = true

    return p , pnl , lbl
end

/*
	Creates a ComboBox
*/
function zgo2.Editor.ComboBox(parent, default, OnChange, OnUpdate)
	local cbox = zclib.vgui.ComboBox(parent, default, function(index, value, pnl)
		pcall(OnChange, index, value, pnl)
	end)

	cbox:SetTall(40 * zclib.hM)
	cbox:SetSortItems(false)
	cbox:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	cbox:Dock(TOP)

	cbox.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zclib.colors[ "black_a100" ])
	end

	cbox.OnUpdate = function(s)
		pcall(OnUpdate,s)
	end

	UpdateTracker[ cbox ] = true

	return cbox
end

/*
	Creates a category seperator line
*/
function zgo2.Editor.CategorySeperator(parent)
	local container = vgui.Create("DPanel", parent)
	container:SetTall(4)
	container:Dock(TOP)
	container:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
    container.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui02"])
	end
end

/*
	Creates a TextBox Entry
*/
function zgo2.Editor.TextEntry(parent, title, default, OnChange , OnUpdate)

    local pnl = vgui.Create("DPanel", parent)
    pnl:SetTall(30 * zclib.hM)
    pnl:Dock(TOP)
    pnl:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
    pnl:DockPadding(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
    pnl.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])
    end

    local lbl = vgui.Create("DLabel", pnl)
    lbl:Dock(LEFT)
    lbl:SetMouseInputEnabled(true)
    lbl:SetFont(zclib.GetFont("zclib_font_small"))
    lbl:SetTextColor(zclib.colors["text01"])
    lbl:SetText(title)

    local entry = zclib.vgui.TextEntry(pnl, default, OnChange, false)
    entry:Dock(FILL)
    entry.font = zclib.GetFont("zclib_font_small")
    entry.bg_color = zclib.colors["black_a100"]
    entry:SetValue(default)

    pnl.PerformLayout = function(self)
        lbl:SetWide(self:GetWide() / 3)
    end

	entry.OnUpdate = function(s)
		pcall(OnUpdate,s)
	end

	UpdateTracker[entry] = true

	return entry
end

/*
	Creates a image gallery
*/
function zgo2.Editor.ImageGallery(parent,default,OnChange,OnUpdate,width,height)
	local Entry = zgo2.vgui.ImgurEntry(parent,zgo2.language["ImgurID"],function(val,txt)
		pcall(OnChange,val,txt)
	end,width,height)

	Entry.OnUpdate = function(s)
		pcall(OnUpdate,s)
	end

	UpdateTracker[Entry] = true

	if default then Entry:SetValue(default) end
end

/*
    Creates a ComboBox to select a Image Processing Blendmode
*/
function zgo2.Editor.BlendMode(parent,default,OnChange)
    local pnl = zclib.vgui.Panel(parent,zgo2.language[ "BlendMode" ])
    pnl:SetSize(245 * zclib.wM, 70 * zclib.hM)
    pnl:Dock(TOP)
    pnl:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    pnl:DockPadding(0, 10 * zclib.hM, 0, 10 * zclib.hM)

    pnl.Title_font = zclib.GetFont("zclib_font_small")
    pnl.Title_color = zclib.colors["text01"]
    pnl.BG_color = zclib.colors["black_a50"]

    local blendmode_DComboBox = zclib.vgui.ComboBox(pnl,zclib.Blendmodes.List[default].name,function(index, value,apnl)
        pcall(OnChange,index, value,apnl)
    end)
    blendmode_DComboBox:SetTall(30 * zclib.hM)
    blendmode_DComboBox:SetSortItems( false )
    blendmode_DComboBox:DockMargin(10 * zclib.wM,20 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    blendmode_DComboBox:Dock(TOP)

    for k,v in pairs(zclib.Blendmodes.List) do blendmode_DComboBox:AddChoice(v.name, k) end
end


local function BuildValue(key,val)

	if isbool(val) then
		return [[ ["]] .. tostring(key) .. [["] ]] .. [[ = ]] .. tostring(val) .. [[,
		]]
	end

	if isangle( val ) and val.p then
		return tostring(key) .. [[ = Angle( ]] .. math.Round(val.p,2) .. [[ , ]] .. math.Round(val.y,2) .. [[ , ]] .. math.Round(val.r,2) .. [[ ),
		]]
	end

	if istable( val ) and val.r then
		return tostring(key) .. [[ = Color( ]] .. math.Round(val.r) .. [[ , ]] .. math.Round(val.g) .. [[ , ]] .. math.Round(val.b) .. [[ , ]] .. math.Round(val.a or 255) .. [[ ),
		]]
	end

	if isstring(val) then
		return tostring(key) .. [[ = "]] .. tostring(val) .. [[",
		]]
	end

	if istable(val) then
		if table.Count(val) <= 0 then
			return tostring(key) .. [[ = {},
	]]
		end
		local txt = tostring(key) .. [[ = {
		]]
			for k, v in pairs(val) do
				if not v then continue end
				txt = txt .. BuildValue(k,v)
			end
		txt = txt .. [[
			},
	]]
		return txt
	end

	return tostring(key) .. [[= ]] .. tostring(math.Round(val,2)) .. [[,
	]]
end

/*
	Builds the config data and stores it in the clipboard
*/
function zgo2.Editor.BuildClipboard(dat,name)
	if dat == nil then return end

	local text = name .. [[({
	]]

	for k,v in pairs(dat) do
		if not v then continue end
		text = text .. BuildValue(k,v)
	end

	text = text .. [[
})
]]
	text = string.Replace(text,[[\]],[[/]])

	return text
end
