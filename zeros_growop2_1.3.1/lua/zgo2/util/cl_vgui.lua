zgo2 = zgo2 or {}
zgo2.vgui = zgo2.vgui or {}

/*
	Creates a progress bar
*/
function zgo2.vgui.ProgressBar(w, h, x, y, fract, color01, color02)
	local barW = w
	barW = math.Clamp(barW * fract, 0, barW)
	draw.RoundedBox(0, x + 4, y + 4, math.Clamp(barW - 8, 0, w), h - 8, color01)
	zclib.util.DrawOutlinedBox(x, y, w, h, 2, color02)
end

/*
	Creates a simple text button
*/
function zgo2.vgui.Button(parent, text, font, color, OnClick)
	local btn = vgui.Create("DButton", parent)
	btn:SetTall(30 * zclib.hM)
	btn:Dock(TOP)
	btn:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
	btn.MainColor = color
	btn.HighlightColor = Color(color.r * 1.5, color.g * 1.5, color.b * 1.5)
	btn.IsLocked = false

	function btn:Lock(UnlockTime,Duration)
		btn.MainColor = zclib.colors[ "ui02_grey" ]
		btn:SetTextColor(zclib.colors[ "ui02_grey" ])
		btn.IsLocked = true
		btn.UnlockTime = UnlockTime
		btn.Duration = Duration
	end

	function btn:Unlock()
		btn.MainColor = color
		btn.IsLocked = false
		btn:SetTextColor(color)
		btn.UnlockTime = nil
		btn.Duration = nil
	end

	function btn:SetSelected(state)
		btn.m_IsSelected = state
		if btn.m_IsSelected then
			btn:SetTextColor(btn.HighlightColor)
		else
			btn:SetTextColor(btn.MainColor)
		end
	end

	btn:SetText(text)
	btn:SetFont(font)
	btn:SetTextColor(btn.IsLocked and zclib.colors[ "ui02_grey" ] or color)
	btn:SizeToContentsX(30 * zclib.wM)

	btn.Paint = function(s, w, h)
		zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2,s.m_IsSelected and s.HighlightColor or s.MainColor)

		if s.UnlockTime and s.Duration then
			if CurTime() > s.UnlockTime then s:Unlock() end

			if s.UnlockTime and s.Duration then
				local diff = math.Clamp(s.UnlockTime - CurTime(), 0, s.Duration)
				draw.RoundedBox(0, 0, 0, w / s.Duration * diff, h, zclib.colors[ "black_a100" ])
			end
		end

		if not s.UnlockTime and s:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "white_a15" ])
		end
	end

	btn.DoClick = function(s)
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		pcall(OnClick, s)
	end

	return btn
end

/*
	Adds a simple seperator panel
*/
function zgo2.vgui.AddTopSepeartor(top)
	local seperator = zclib.vgui.AddSeperator(top)
	seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
	seperator:Dock(RIGHT)
	seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
end

/*
	Creates a nummeric slider
*/
function zgo2.vgui.NumSlider(parent, default, title, OnChange, Min, Max, Decimal)
	local DermaNumSlider = vgui.Create("DNumSlider", parent)
	DermaNumSlider:SetPos(50, 50)
	DermaNumSlider:SetSize(300, 30 * zclib.hM)
	DermaNumSlider:SetMin(Min)
	DermaNumSlider:SetMax(Max)
	DermaNumSlider:SetDecimals(Decimal)
	DermaNumSlider:SetValue(default)
	DermaNumSlider:DockPadding(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

	DermaNumSlider.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zclib.colors[ "black_a100" ])
	end

	DermaNumSlider:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	DermaNumSlider:Dock(TOP)

	DermaNumSlider.OnValueChanged = function(self, value)
		pcall(OnChange, value,DermaNumSlider)
	end

	DermaNumSlider.Label:SetFont(zclib.GetFont("zclib_font_small"))
	DermaNumSlider.Label:SetTextColor(zclib.colors[ "text01" ])
	DermaNumSlider:SetText(title)

	DermaNumSlider.PerformLayout = function(self)
		self.Label:SetWide(self:GetWide() / 3)
	end

	DermaNumSlider.TextArea:SetDrawLanguageID(false)

	DermaNumSlider.TextArea.Paint = function(s, w, h)
		if s:GetText() == "" and not s:IsEditing() then
			draw.SimpleText(emptytext, zclib.GetFont("zclib_font_small"), 5 * zclib.wM, h / 2, zclib.colors[ "white_a15" ], 0, 1)
		end

		s:DrawTextEntryText(color_white, zclib.colors[ "textentry" ], color_white)
	end

	DermaNumSlider.TextArea.PerformLayout = function(s, width, height)
		s:SetFontInternal(zclib.GetFont("zclib_font_small"))
	end

	return DermaNumSlider
end

/*
    Creates a quick confirmation window
*/
function zgo2.vgui.ConfirmationWindow(Question, OnAccept, OnDecline)
	local main = vgui.Create("DPanel")
	main:MakePopup()
	main:SetSize(zclib_main_panel:GetWide(), zclib_main_panel:GetTall())
	local pnlX,pnlY = zclib_main_panel:GetPos()
    main:SetPos(pnlX,pnlY)
	main.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a200"])

		if input.IsKeyDown(KEY_ESCAPE) and IsValid(s) then
			s:Remove()
		end
	end

	local window = vgui.Create("DPanel", main)
	window:SetSize(500 * zclib.wM, 200 * zclib.hM)
	window:Center()
	window.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
		draw.SimpleText(Question, zclib.GetFont("zclib_font_big"), w / 2, 30 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local yes = zgo2.vgui.Button(window,zgo2.language[ "Yes" ], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["green01"], function()
		pcall(OnAccept)
		main:Remove()
	end)
	yes:Dock(NODOCK)
	yes:SetPos(50 * zclib.wM, 120 * zclib.hM)
	yes:SetSize(160 * zclib.wM, 50 * zclib.hM)

	local No = zgo2.vgui.Button(window,zgo2.language[ "No" ], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["red01"], function()
		if OnDecline then
			pcall(OnDecline)
		end

		main:Remove()
	end)
	No:Dock(NODOCK)
	No:SetPos(290 * zclib.wM, 120 * zclib.hM)
	No:SetSize(160 * zclib.wM, 50 * zclib.hM)
end

/*
    Creates a button with a image
*/
function zgo2.vgui.ImageButton(parent, image, color, OnClick,IsLocked,tooltip)
    local btn = zclib.vgui.ImageButton(0, 0, 50 * zclib.wM, 50 * zclib.hM, parent, image, function(s)
        pcall(OnClick,s)
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
local function ImageGallery(parent,width,height,OnImageSelected,txt)

    if IsValid(OptionPanel) then OptionPanel:Remove() end

    local main = vgui.Create( "DPanel" )
    main:MakePopup()
    main:SetSize(width,height)
    main:Center()

	parent.OnRemove = function()
		main:Remove()
	end

    local title_font = zclib.GetFont("zclib_font_big")
    local txtW = zclib.util.GetTextSize(zgo2.language[ "Cached Images" ],title_font)
    if txtW >= (480 * zclib.wM) then
        title_font = zclib.GetFont("zclib_font_medium")
    end

    main.Paint = function(s, w, h)

		local x,y = s:LocalToScreen(0,0)
		BSHADOWS.BeginShadow()
		surface.SetDrawColor(255, 255,255)
		surface.DrawRect(x, y, w, h)
		BSHADOWS.EndShadow(1,15,5,255,0,0,true)

        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
        draw.RoundedBox(10, 50 * zclib.wM,70 * zclib.hM, w, 5 * zclib.hM, zclib.colors["ui01"])
        draw.SimpleText(zgo2.language[ "Cached Images" ], title_font, 50 * zclib.wM,15 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    OptionPanel = main

    local back_btn = zclib.vgui.ImageButton(width - 60 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,main,zclib.Materials.Get("back"),function()
        main:Remove()
    end,false)
    back_btn.IconColor = zclib.colors["red01"]

    local list,scroll = zclib.vgui.List(main)
    scroll:DockMargin(50 * zclib.wM,90 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
    list:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    list:SetSpaceY( 10 * zclib.hM)
    list:SetSpaceX( 10 * zclib.wM)
    scroll.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])
    end

    local itmSize = (width - 100 * zclib.wM) / 6
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
            main:Remove()
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
function zgo2.vgui.ImgurEntry(parent,default,OnImageSelected,width,height)
    local txt = zclib.vgui.TextEntry(parent,default,OnImageSelected,false)
    txt:Dock(TOP)
    txt:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    txt.bg_color = zclib.colors["black_a100"]

    local gallery_btn = zgo2.vgui.ImageButton(txt, zclib.Materials.Get("image"), zclib.colors["blue01"], function()
        ImageGallery(parent,width or zclib_main_panel:GetWide(),height or zclib_main_panel:GetTall(),OnImageSelected,txt)
    end,function() return false end, "" )
    gallery_btn.IconColor = zclib.colors["blue01"]
    gallery_btn.NoneHover_IconColor = zclib.colors["text01"]
    gallery_btn:Dock(RIGHT)
    gallery_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

    return txt
end

function zgo2.vgui.SongLibary(parent, OnSongSelected,OnClose)
	if IsValid(parent.SongLibary) then
		parent.SongLibary:Remove()
	end

	local MainContainer = vgui.Create("DPanel", parent)
	MainContainer:SetAutoDelete(true)
	MainContainer:SetSize(500 * zclib.wM, 750 * zclib.hM)
	MainContainer:SetPos((parent:GetWide() / 2) - 250 * zclib.wM, (parent:GetTall() / 2) - 350 * zclib.hM)
	MainContainer.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zclib.colors["ui02"])

		if s.Loading == true then

			draw.SimpleText(zgo2.language[ "Loading" ], zclib.GetFont("zclib_font_medium"), w / 2, (h / 2) - (50 * zclib.hM), zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(zclib.colors["text01"])
			surface.SetMaterial(zclib.Materials.Get("icon_loading"))
			surface.DrawTexturedRectRotated(w / 2, (h / 2) + 25,50, 50, CurTime() * -90)
		end
	end
	parent.SongLibary = MainContainer
	MainContainer.IsPlaying = false
	MainContainer.PlayMusicPreview = function(s,play)

		MainContainer.IsPlaying = play

		if IsValid(MainContainer.AudioSource) then
			MainContainer.AudioSource:Stop()
			return
		end

		if play == true and MainContainer.SelectedPath and file.Exists(MainContainer.SelectedPath,"GAME") then
			sound.PlayFile(MainContainer.SelectedPath, "mono", function(source, err, errname)
				if IsValid(source) then
					MainContainer.AudioSource = source
					source:SetTime(0)
					source:Play()
					source:SetPlaybackRate(1)
					source:SetVolume(1)
				end
			end)
		end
	end

	local TopContainer = vgui.Create("DPanel", MainContainer)
	TopContainer:SetAutoDelete(true)
	TopContainer:SetSize(500 * zclib.wM, 50 * zclib.hM)
	TopContainer:Dock(TOP)
	TopContainer.Paint = function(s, w, h)
		draw.SimpleText(zgo2.language[ "Music Libary" ], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 25 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local close_btn = zgo2.vgui.ImageButton(TopContainer, zclib.Materials.Get("close"), zclib.colors["red01"], function()
		// Stop any music
		MainContainer:PlayMusicPreview(false)

        OnClose()
	end,function() return false end,zgo2.language["Close"])
	close_btn.Think = function(s)
		if input.IsKeyDown(KEY_ESCAPE) ~= s.State then
			s.State = input.IsKeyDown(KEY_ESCAPE)

			if s.State == true then
				// Stop any music
				MainContainer:PlayMusicPreview(false)

				OnClose()
			end
		end
	end
	MainContainer.close_btn = close_btn

	zgo2.vgui.ImageButton(TopContainer, zclib.Materials.Get("audio_play"), zclib.colors["green01"], function(s)
		MainContainer.IsPlaying = not MainContainer.IsPlaying
		MainContainer:PlayMusicPreview(MainContainer.IsPlaying)

		s.IconImage = MainContainer.IsPlaying and zclib.Materials.Get("audio_stop") or zclib.Materials.Get("audio_play")

	end,function() return MainContainer.SelectedPath == nil end,zgo2.language[ "Play" ])

	local TreeContainer = vgui.Create("DPanel", MainContainer)
	TreeContainer:SetAutoDelete(true)
	TreeContainer:SetSize(500 * zclib.wM,640 * zclib.hM)
	TreeContainer.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a50"])
	end
	TreeContainer:Dock(TOP)
	TreeContainer:DockMargin(5,5,5,5)
	MainContainer.TreeContainer = TreeContainer

	local Tree = vgui.Create("DTree", TreeContainer)
	Tree:Dock(FILL)
	Tree:DockMargin(5,5,5,5)
	Tree:SetClickOnDragHover(false)
	Tree.Paint = function(s, w, h) end
	Tree.OnNodeSelected = function(_, node)

		// Stop any music
		MainContainer:PlayMusicPreview(false)

		parent.SongLibary.SelectedPath = node:GetFileName()
	end
	MainContainer.Tree = Tree

	local anode = Tree:AddNode("sound","zerochain/zerolib/ui/icon_volume.png")
	anode:MakeFolder("sound", "GAME", true,"*",true)

	local sbar = Tree:GetVBar()
	sbar:SetHideButtons( true )
	function sbar:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"]) end
	function sbar.btnUp:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, zclib.colors["text01"]) end
	function sbar.btnDown:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, zclib.colors["text01"]) end
	function sbar.btnGrip:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, zclib.colors["text01"]) end

	local select_btn = zgo2.vgui.Button(MainContainer, zgo2.language[ "Choose" ], zclib.GetFont("zclib_font_medium"), zclib.colors["text01"], function()
		if parent.SongLibary.SelectedPath then

			// Stop any music
			MainContainer:PlayMusicPreview(false)

			TreeContainer:Remove()
			TopContainer:Remove()
			MainContainer.Loading = true

			pcall(OnSongSelected, parent.SongLibary.SelectedPath)
		else
			zclib.Notify(LocalPlayer(), zgo2.language[ "Invalid File" ], 1)
		end
	end)
	select_btn:SetAutoDelete(true)
	select_btn:SetSize(parent:GetWide(), 50 * zclib.hM)
	select_btn:Dock(BOTTOM)
	select_btn:DockMargin(5,5,5,5)

	return MainContainer
end

local SpliceBG = Color(152, 86, 194,8)
function zgo2.vgui.PlantPanel(list, PnlSize, PlantID, PlantData, IsSelected, OnClick, IsLocked)
	local pnlHeight = PnlSize + 50

	local itm = vgui.Create("DPanel")
	itm:SetSize(PnlSize * zclib.wM, pnlHeight * zclib.hM)
	itm.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui00" ])
		if PlantData.SplicedConfig then draw.RoundedBox(5, 0, 0, w, h, SpliceBG) end

		if PlantData.SplicedConfig then
			surface.SetDrawColor(zclib.colors[ "black_a50" ])
			surface.SetMaterial(zclib.Materials.Get("zgo2_icon_splice"))
			surface.DrawTexturedRectRotated(w/2,h/2,h,h,0)
		end

		if IsSelected() then
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a5" ])
		end
	end
	list:Add(itm)

	local imgpnl = vgui.Create("DImage", itm)
	imgpnl:SetSize(PnlSize * zclib.wM, PnlSize * zclib.hM)

	local img = zclib.Snapshoter.Get({
		class = "zgo2_plant",
		model = "models/zerochain/props_growop2/zgo2_plant_root.mdl",
		PlantID = PlantData.uniqueid,
	}, imgpnl)

	imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	imgpnl:Dock(FILL)

	local btnpnl = vgui.Create("DButton", itm)
	btnpnl:SetTall(itm:GetTall())
	btnpnl:SetWide(itm:GetWide())
	btnpnl:SetText("")
	btnpnl.Paint = function(s, w, h)

		surface.SetDrawColor(zclib.colors[ "black_a100" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, h / 2 + 50 * zclib.hM, w, h, -90)

		surface.SetDrawColor(color_black)
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, 15 * zclib.hM, w,30 * zclib.hM, 180)

		surface.SetDrawColor(color_black)
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, h - 20 * zclib.hM, w,40 * zclib.hM, 0)
	end

	btnpnl.PaintOver = function(s,w,h)
		if not IsLocked and s:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "white_a5" ])
		end

		if IsLocked then
			zclib.util.DrawBlur(s, 1, 5)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "black_a200" ])
			local size = w * 0.7
			surface.SetDrawColor(zclib.colors[ "white_a50" ])
			surface.SetMaterial(zclib.Materials.Get("icon_locked"))
			surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, 0)
		end
	end

	if not IsLocked then
		local name_font = zclib.util.FontSwitch(PlantData.name, itm:GetWide() - 10 * zclib.wM, zclib.GetFont("zclib_font_mediumsmall"), zclib.GetFont("zclib_font_small"))
		name_font = zclib.util.FontSwitch(PlantData.name, itm:GetWide() - 10 * zclib.wM, name_font, zclib.GetFont("zclib_font_tiny"))

		local lbl = vgui.Create("DLabel", btnpnl)
		lbl:SetSize(500, 30 * zclib.hM)
		lbl:Dock(TOP)
		lbl:DockMargin(5, 3, 5, 2)
		lbl:SetFont(name_font)
		lbl:SetTextColor(zclib.colors[ "orange01" ])
		lbl:SetText(PlantData.name)
		lbl:SetContentAlignment(7)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)

		if PlantData.SplicedConfig then
			local lbl = vgui.Create("DLabel", btnpnl)
			lbl:SetSize(500, 30 * zclib.hM)
			lbl:Dock(TOP)
			lbl:DockMargin(5, 3, 5, 2)
			lbl:SetFont(zclib.GetFont("zclib_font_tiny"))
			lbl:SetTextColor(color_white)
			lbl:SetText(zgo2.language[ "Created by" ] .. " " .. tostring(PlantData.creator_name))
			lbl:SetContentAlignment(7)
			lbl:SetWrap(true)
			lbl:SetAutoStretchVertical(true)
		end

		local lbl = vgui.Create("DLabel", btnpnl)
		lbl:SetSize(500, 30 * zclib.hM)
		lbl:Dock(BOTTOM)
		lbl:DockMargin(5, 3, 5, 2)
		lbl:SetFont(zclib.GetFont("zclib_font_medium"))
		lbl:SetTextColor(zclib.colors[ "green01" ])
		lbl:SetText(zclib.Money.Display(zgo2.Plant.GetTotalMoney(PlantData.uniqueid)))
		lbl:SetContentAlignment(3)
		lbl:SetAutoStretchVertical(true)
	end

	btnpnl.DoClick = function(s)
		if IsLocked then return end
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		pcall(OnClick, PlantID)
	end

	local restriction

	if PlantData.ranks and table.Count(PlantData.ranks) > 0 then
		restriction = zgo2.language[ "Ranks" ] .. ": " .. zclib.table.ToString(PlantData.ranks)
	end

	if PlantData.jobs and table.Count(PlantData.jobs) > 0 then
		if restriction then
			restriction = restriction .. "\n"
		end

		restriction = (restriction or "") .. zgo2.language[ "Jobs" ] .. ": " .. zclib.table.ToString(PlantData.jobs)
	end

	if restriction then
		btnpnl:SetTooltip(restriction)
	end
end

function zgo2.vgui.BongPanel(list, PnlSize, BongID, BongData, IsSelected, OnClick, IsLocked)
	local pnlHeight = PnlSize + 50

	local itm = vgui.Create("DPanel")
	itm:SetSize(PnlSize * zclib.wM, pnlHeight * zclib.hM)
	itm.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui00" ])
		if IsSelected() then
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a5" ])
		end

		surface.SetDrawColor(zclib.colors[ "black_a100" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, h / 2 + 50 * zclib.hM, w, h, -90)

		surface.SetDrawColor(zclib.colors[ "black_a200" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, 15 * zclib.hM, w,30 * zclib.hM, 180)

		surface.SetDrawColor(zclib.colors[ "black_a200" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, h - 20 * zclib.hM, w,40 * zclib.hM, 0)
	end
	list:Add(itm)

	local imgpnl = vgui.Create("DImage", itm)
	imgpnl:SetSize(PnlSize * zclib.wM, PnlSize * zclib.hM)

	local BongType = zgo2.Bong.Types[BongData.type]


	local img = zclib.Snapshoter.Get({
		class = "zgo2_bong",
		model = BongType.wm,
		BongID = BongData.uniqueid,
	}, imgpnl)
	imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	imgpnl:Dock(FILL)


	if not IsLocked then
		local name_font = zclib.util.FontSwitch(BongData.name, itm:GetWide() - 10 * zclib.wM, zclib.GetFont("zclib_font_mediumsmall"), zclib.GetFont("zclib_font_small"))
		name_font = zclib.util.FontSwitch(BongData.name, itm:GetWide() - 10 * zclib.wM, name_font, zclib.GetFont("zclib_font_tiny"))

		local lbl = vgui.Create("DLabel", imgpnl)
		lbl:SetSize(500, 30 * zclib.hM)
		lbl:Dock(TOP)
		lbl:DockMargin(5, 3, 5, 2)
		lbl:SetFont(name_font)
		lbl:SetTextColor(zclib.colors[ "orange01" ])
		lbl:SetText(BongData.name)
		lbl:SetContentAlignment(7)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)

		local lbl = vgui.Create("DLabel", imgpnl)
		lbl:SetSize(500, 30 * zclib.hM)
		lbl:Dock(BOTTOM)
		lbl:DockMargin(5, 3, 5, 2)
		lbl:SetFont(zclib.GetFont("zclib_font_medium"))
		lbl:SetTextColor(zclib.colors[ "green01" ])
		lbl:SetText(zclib.Money.Display(BongData.price))
		lbl:SetContentAlignment(3)
		lbl:SetAutoStretchVertical(true)
	end

	local btnpnl = vgui.Create("DButton", itm)
	btnpnl:SetTall(itm:GetTall())
	btnpnl:SetWide(itm:GetWide())
	btnpnl:SetText("")
	btnpnl.Paint = function(s, w, h)

		if not IsLocked and s:IsHovered() then
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a5" ])
		end

		if IsLocked then
			zclib.util.DrawBlur(s, 1, 5)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a200" ])
			local size = w * 0.7
			surface.SetDrawColor(zclib.colors[ "white_a50" ])
			surface.SetMaterial(zclib.Materials.Get("icon_locked"))
			surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, 0)
		end
	end
	btnpnl.DoClick = function(s)
		if IsLocked then return end
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		pcall(OnClick, BongID)
	end

	return itm
end

function zgo2.vgui.PotPanel(list, PnlSize, PotID, PotData, IsSelected, OnClick, IsLocked)
	local pnlHeight = PnlSize + 50

	local itm = vgui.Create("DPanel")
	itm:SetSize(PnlSize * zclib.wM, pnlHeight * zclib.hM)
	itm.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui00" ])
		if IsSelected() then
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a5" ])
		end

		surface.SetDrawColor(zclib.colors[ "black_a100" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, h / 2 + 50 * zclib.hM, w, h, -90)

		surface.SetDrawColor(zclib.colors[ "black_a200" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, 15 * zclib.hM, w,30 * zclib.hM, 180)

		surface.SetDrawColor(zclib.colors[ "black_a200" ])
		surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
		surface.DrawTexturedRectRotated(w / 2, h - 20 * zclib.hM, w,40 * zclib.hM, 0)
	end
	list:Add(itm)

	local imgpnl = vgui.Create("DImage", itm)
	imgpnl:SetSize(PnlSize * zclib.wM, PnlSize * zclib.hM)

	local PotType = zgo2.Pot.Types[PotData.type]

	local img = zclib.Snapshoter.Get({
		class = "zgo2_pot",
		model = PotType.mdl,
		PotID = PotData.uniqueid,
	}, imgpnl)
	imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	imgpnl:Dock(FILL)


	if not IsLocked then
		local name_font = zclib.util.FontSwitch(PotData.name, itm:GetWide() - 10 * zclib.wM, zclib.GetFont("zclib_font_mediumsmall"), zclib.GetFont("zclib_font_small"))
		name_font = zclib.util.FontSwitch(PotData.name, itm:GetWide() - 10 * zclib.wM, name_font, zclib.GetFont("zclib_font_tiny"))

		local lbl = vgui.Create("DLabel", imgpnl)
		lbl:SetSize(500, 30 * zclib.hM)
		lbl:Dock(TOP)
		lbl:DockMargin(5, 3, 5, 2)
		lbl:SetFont(name_font)
		lbl:SetTextColor(zclib.colors[ "orange01" ])
		lbl:SetText(PotData.name)
		lbl:SetContentAlignment(7)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)

		local lbl = vgui.Create("DLabel", imgpnl)
		lbl:SetSize(500, 30 * zclib.hM)
		lbl:Dock(BOTTOM)
		lbl:DockMargin(5, 3, 5, 2)
		lbl:SetFont(zclib.GetFont("zclib_font_medium"))
		lbl:SetTextColor(zclib.colors[ "green01" ])
		lbl:SetText(zclib.Money.Display(PotData.price))
		lbl:SetContentAlignment(3)
		lbl:SetAutoStretchVertical(true)
	end

	local btnpnl = vgui.Create("DButton", itm)
	btnpnl:SetTall(itm:GetTall())
	btnpnl:SetWide(itm:GetWide())
	btnpnl:SetText("")
	btnpnl.Paint = function(s, w, h)

		if not IsLocked and s:IsHovered() then
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a5" ])
		end

		if IsLocked then
			zclib.util.DrawBlur(s, 1, 5)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a200" ])
			local size = w * 0.7
			surface.SetDrawColor(zclib.colors[ "white_a50" ])
			surface.SetMaterial(zclib.Materials.Get("icon_locked"))
			surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, 0)
		end
	end
	btnpnl.DoClick = function(s)
		if IsLocked then return end
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		pcall(OnClick, PotID)
	end

	return itm
end

/*
	Lets us edit a list of jobs or ranks
*/
function zgo2.vgui.ListEditor(data,title,key,color,OnBack,OnRebuild)
	zclib.vgui.Page("       " .. title, function(main, top)

		main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)
		main:SetDraggable(true)
		main:Center()

		local suggestions = {}
		for _, v in pairs(zgo2.config.Bongs) do
			if v and v[key] then
				for itm, _ in pairs(v[key]) do
					suggestions[itm] = true
				end
			end
		end

		for _, v in pairs(zgo2.Plant.GetAll()) do
			if v and v[key] then
				for itm, _ in pairs(v[key]) do
					suggestions[itm] = true
				end
			end
		end

		for _, v in pairs(zgo2.config.Pots) do
			if v and v[key] then
				for itm, _ in pairs(v[key]) do
					suggestions[itm] = true
				end
			end
		end

		if key == "ranks" then
			for k, v in pairs(zclib.config.AdminRanks) do
				suggestions[k] = true
			end
		end

		// Get all the jobs from ExtraTeams and add their name too
		if key == "jobs" then
			for jobid, v in pairs(RPExtraTeams) do
				if v then
					suggestions[jobid] = true
				end
			end
		end

		local back = zgo2.vgui.ImageButton(top, zclib.Materials.Get("back"), zclib.colors["orange01"], function()
			pcall(OnBack)
		end, function() return false end, zgo2.language["Back"])
		back:Dock(LEFT)
		back:DockMargin(40 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local parent = vgui.Create("DPanel", main)
		parent:SetSize(1000 * zclib.wM, 1000 * zclib.hM)
		parent:Dock(FILL)
		parent:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
		parent.Paint = function(s, w, h) end

		local content
		local function RebuildList()
			if IsValid(content) then content:Remove() end
			content = vgui.Create("DPanel", parent)
			content:Dock(FILL)
			content.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
				draw.RoundedBox(5, w - 15 * zclib.wM, 0, 15 * zclib.wM, h, zclib.colors["black_a50"])
			end

			local list, scroll = zclib.vgui.List(content)
			scroll:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
			list:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
			list:SetSpaceY(10 * zclib.hM)
			list:SetSpaceX(10 * zclib.wM)

			local function AddButton(id,rcolor, OnClick)
				local txt = id
				if key == "jobs" and RPExtraTeams[id] then
					txt = RPExtraTeams[id].name
				end

				local btnpnl = zgo2.vgui.Button(scroll, txt, zclib.GetFont("zclib_font_medium"), rcolor, function()
					pcall(OnClick, id)
				end)
				btnpnl:Dock(NODOCK)
				btnpnl:SetSize(100 * zclib.wM, 50 * zclib.hM)
				btnpnl:SizeToContentsX(10)
				list:Add(btnpnl)
			end

			if data[key] == nil then data[key] = {} end

			for k, v in pairs(data[key]) do
				AddButton(k,color, function(val)
					data[key][val] = nil
					RebuildList()
				end)
			end

			for k,v in pairs(suggestions) do
				if data[key][k] == nil then

					// Adds the suggestion and rebuilds the list
					AddButton(k,zclib.colors["ui02_grey"], function(val)
						data[key][k] = true
						RebuildList()
					end)
				end
			end

			pcall(OnRebuild,data)
		end
		RebuildList()

		if key == "ranks" then
			local txt = zclib.vgui.TextEntry(top, "", function(val) end, false)
			txt:Dock(RIGHT)
			txt:SetWide(300)
			txt:DockMargin(10 * zclib.wM, 0 * zclib.hM, 40 * zclib.wM, 0 * zclib.hM)
			txt.bg_color = zclib.colors["black_a100"]
			txt.font = zclib.GetFont("zclib_font_medium")

			zgo2.vgui.ImageButton(top, zclib.Materials.Get("plus"), zclib.colors["green01"], function()
				local val = txt:GetValue()

				if val and val ~= "" and val ~= " " then
					if data[key] == nil then data[key] = {} end
					data[key][val] = true
					RebuildList()
					txt:SetValue("")
				end
			end, function() return false end, zgo2.language["Add Item"])
		end
	end)
end

/*
    Creates a page which display a loading symbol
*/
function zgo2.vgui.Wait(title,OnComplete)
    zclib.vgui.Page(title, function(main, top)
        main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)

        local ImgurImagePreview = vgui.Create("DPanel", main)
        ImgurImagePreview:Dock(FILL)
        ImgurImagePreview:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        ImgurImagePreview.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])

            surface.SetDrawColor(zclib.colors["text01"])
            surface.SetMaterial(zclib.Materials.Get("icon_loading"))
            surface.DrawTexturedRectRotated(w / 2, h / 2, 300 * zclib.wM,300 * zclib.hM, zclib.util.SnapValue(36, CurTime() * -700))
        end

        timer.Simple(1.25,function()
			pcall(OnComplete)
        end)
    end)
end

/*
	Displays a restriction info on the 3d preview of the editor
*/
function zgo2.vgui.Restriction(parent,data)
	// Display the job restriction
	if data.jobs then
		local jobs = {}
		for k,v in pairs(data.jobs) do
			if not RPExtraTeams[k] or not RPExtraTeams[k].name then continue end
			table.insert(jobs,RPExtraTeams[k].name)
		end

		local lbl = vgui.Create("DLabel", parent)
		lbl:SetSize(500,100)
		lbl:Dock(BOTTOM)
		lbl:DockMargin(10,5,0,5)
		lbl:SetFont(zclib.GetFont("zclib_font_mediumsmall"))
		lbl:SetTextColor(zclib.colors["blue02"])
		lbl:SetText(zgo2.language["Jobs"] .. ": " .. table.concat( jobs, ", " ))
		lbl:SetContentAlignment(7)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)
		lbl.Paint = function(s,w,h)
			if Randomizing then return true end
		end
	end

	// Display the ranks restriction
	if data.ranks then
		local lbl = vgui.Create("DLabel", parent)
		lbl:SetSize(500,100)
		lbl:Dock(BOTTOM)
		lbl:DockMargin(10,5,0,5)
		lbl:SetFont(zclib.GetFont("zclib_font_mediumsmall"))
		lbl:SetTextColor(zclib.colors["orange01"])
		lbl:SetText(zgo2.language["Ranks"] .. ": " .. zclib.table.ToString(data.ranks))
		lbl:SetContentAlignment(7)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)
		lbl.Paint = function(s)
			if Randomizing then return true end
		end
	end
end

/*
	Creates a interface that lets you select a piece or all of the provided c_amount
*/
local OptionWindow
function zgo2.vgui.AmountSelector(text,c_amount, OnConfirm, OnDecline,Default,AllowEmpty)
	if IsValid(OptionWindow) then OptionWindow:Remove() end

	local AmountSlider
	local AmountTextArea
	OptionWindow = vgui.Create("EditablePanel")
	OptionWindow:MakePopup()
	OptionWindow:SetText("")
	OptionWindow:SetSize(zclib_main_panel:GetWide(), zclib_main_panel:GetTall())
	local pnlX,pnlY = zclib_main_panel:GetPos()
	OptionWindow:SetPos(pnlX,pnlY)
	OptionWindow.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a200" ])

		if input.IsKeyDown(KEY_ESCAPE) and IsValid(s) then
			s:Remove()
		end

		if s:IsHovered() and IsValid(AmountSlider) and not AmountSlider:IsEditing() and IsValid(AmountTextArea) and not AmountTextArea:IsEditing() then
			s:SetCursor("hand")

			if input.IsMouseDown(MOUSE_LEFT) then
				if s.LeftClicked == nil then
					s.LeftClicked = true
					s:DoClick()
				end
			else
				s.LeftClicked = nil
			end
		end
	end
	OptionWindow.DoClick = function() OptionWindow:Remove() end

	local parentwindow = vgui.Create("DPanel", OptionWindow)
	parentwindow:SetSize(600 * zclib.wM, 300 * zclib.hM)
	parentwindow:Center()
	parentwindow.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui02" ])

		draw.SimpleText(text, zclib.GetFont("zclib_font_big"), w / 2, 30 * zclib.hM, zclib.colors[ "text01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local selectedAmount = 0

	AmountSlider = zgo2.vgui.NumSlider(parentwindow, selectedAmount, zgo2.language[ "Amount" ] .. ":", function(val)
		selectedAmount = val
		if not AmountTextArea:IsEditing() then AmountTextArea:SetText(math.Round(selectedAmount)) end
	end, 0, c_amount, 0)
	AmountSlider:Dock(TOP)
	AmountSlider:SetTall(40* zclib.hM)
	AmountSlider:DockMargin(20 * zclib.wM, 90 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
	AmountSlider.PerformLayout = function(self) self.Label:SetWide(self:GetWide() / 6.5) end
	AmountSlider:DockPadding(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
	AmountSlider.TextArea:SetNumeric(true)
	AmountSlider.TextArea.PerformLayout = function(s, width, height)
		s:SetWide(56 * zclib.wM)
		s:SetFontInternal(zclib.GetFont("zclib_font_small"))
	end

	// Sets the money amount of the text entry to this default value
	if Default then AmountSlider:SetValue(Default) end

	local MainTextArea = vgui.Create("DPanel", parentwindow)
	MainTextArea:Dock(TOP)
	MainTextArea:SetTall(40* zclib.hM)
	MainTextArea:DockMargin(20 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
	MainTextArea.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a50" ])
		draw.SimpleText(zgo2.language[ "Amount" ], zclib.GetFont("zclib_font_small"), 5 * zclib.wM, h / 2, zclib.colors[ "text01" ], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	AmountTextArea = vgui.Create("DTextEntry", MainTextArea)
	AmountTextArea:Dock(FILL)
	AmountTextArea:DockMargin(100 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	AmountTextArea:SetPaintBackground(false)
	AmountTextArea:SetNumeric(true)
	AmountTextArea:SetDrawLanguageID(false)

	AmountTextArea.Paint = function(s, w, h)
		if s:GetText() == "" and not s:IsEditing() then
			draw.SimpleText(zclib.Money.Display(0), zclib.GetFont("zclib_font_medium"), 5 * zclib.wM, h / 2, zclib.colors[ "white_a15" ], 0, 1)
		end

		s:DrawTextEntryText(color_white, zclib.colors[ "textentry" ], color_white)
	end

	AmountTextArea.PerformLayout = function(s, width, height)
		s:SetFontInternal(zclib.GetFont("zclib_font_medium"))
	end

	AmountTextArea.OnChange = function()
		local val = AmountTextArea:GetValue()
		if val == nil then return end
		val = tonumber(val, 10)
		if val == nil then return end
		val = math.Round(val)
		selectedAmount = val

		if not AmountSlider:IsEditing() then
			AmountSlider:SetValue(val)
		end
	end

	// Sets the money amount of the text entry to this default value
	if Default then AmountTextArea:SetValue(Default) end

	local yes = zgo2.vgui.Button(parentwindow, zgo2.language[ "Confirm" ], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors[ "green01" ], function()
		if not AllowEmpty and selectedAmount <= 0 then return end

		// You cant select more then what you got
		if selectedAmount > c_amount then return end

		pcall(OnConfirm, selectedAmount)
		OptionWindow:Remove()
	end)
	yes:Dock(LEFT)
	yes:SetWide(200 * zclib.wM)
	yes:DockMargin(20 * zclib.wM, 20 * zclib.hM, 0 * zclib.wM, 20 * zclib.hM)

	local No = zgo2.vgui.Button(parentwindow, zgo2.language["Cancel"], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors[ "red01" ], function()
		if OnDecline then
			pcall(OnDecline)
		end

		OptionWindow:Remove()
	end)
	No:Dock(RIGHT)
	No:SetWide(200 * zclib.wM)
	No:DockMargin(10 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 20 * zclib.hM)
end

/*
	Allows to input a name
*/
function zgo2.vgui.TextInput(text, OnConfirm, OnDecline,Default)

	local InputString = Default
	local AmountTextArea

	local main = vgui.Create("EditablePanel")
	main:MakePopup()
	main:SetText("")
	main:SetSize(zclib_main_panel:GetWide(), zclib_main_panel:GetTall())
	main:Center()
	main.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a200" ])

		if input.IsKeyDown(KEY_ESCAPE) and IsValid(s) then
			s:Remove()
		end

		if s:IsHovered() and IsValid(AmountTextArea) and not AmountTextArea:IsEditing() then
			s:SetCursor("hand")

			if input.IsMouseDown(MOUSE_LEFT) then
				if s.LeftClicked == nil then
					s.LeftClicked = true
					s:DoClick()
				end
			else
				s.LeftClicked = nil
			end
		end
	end
	main.DoClick = function() main:Remove() end

	local parentwindow = vgui.Create("DPanel", main)
	parentwindow:SetSize(600 * zclib.wM, 250 * zclib.hM)
	parentwindow:Center()
	parentwindow.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui02" ])

		draw.SimpleText(text, zclib.GetFont("zclib_font_big"), w / 2, 30 * zclib.hM, zclib.colors[ "text01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local MainTextArea = vgui.Create("DPanel", parentwindow)
	MainTextArea:Dock(TOP)
	MainTextArea:SetTall(40* zclib.hM)
	MainTextArea:DockMargin(20 * zclib.wM, 90 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
	MainTextArea.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a50" ])
	end

	AmountTextArea = vgui.Create("DTextEntry", MainTextArea)
	AmountTextArea:Dock(FILL)
	AmountTextArea:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	AmountTextArea:SetPaintBackground(false)
	AmountTextArea:SetDrawLanguageID(false)

	AmountTextArea.Paint = function(s, w, h)
		s:DrawTextEntryText(color_white, zclib.colors[ "textentry" ], color_white)
	end

	AmountTextArea.PerformLayout = function(s, width, height)
		s:SetFontInternal(zclib.GetFont("zclib_font_medium"))
	end

	AmountTextArea.OnChange = function()
		InputString = AmountTextArea:GetValue()
	end

	// Sets the money amount of the text entry to this default value
	if Default then AmountTextArea:SetValue(Default) end

	local yes = zgo2.vgui.Button(parentwindow, zgo2.language[ "Confirm" ], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors[ "green01" ], function()
		pcall(OnConfirm, InputString)
		main:Remove()
	end)
	yes:Dock(LEFT)
	yes:SetWide(200 * zclib.wM)
	yes:DockMargin(20 * zclib.wM, 20 * zclib.hM, 0 * zclib.wM, 20 * zclib.hM)

	local No = zgo2.vgui.Button(parentwindow, zgo2.language["Cancel"], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors[ "red01" ], function()
		if OnDecline then pcall(OnDecline) end
		main:Remove()
	end)
	No:Dock(RIGHT)
	No:SetWide(200 * zclib.wM)
	No:DockMargin(10 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 20 * zclib.hM)
end
