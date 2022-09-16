zgo2 = zgo2 or {}
zgo2.Jar = zgo2.Jar or {}

net.Receive("zgo2.Jar.Split", function(len,ply)
    zclib.Debug_Net("zgo2.Jar.Split", len)

    local Jar = net.ReadEntity()
	if not IsValid(Jar) then return end

	zgo2.Jar.Split(Jar)
end)

function zgo2.Jar.Split(Jar)
	zclib.vgui.Page(zgo2.language["Jar"], function(main, top)
        main:SetSize(800 * zclib.wM, 400 * zclib.hM)

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zgo2.language[ "Close" ])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local Machines_content = vgui.Create("DPanel", main)
        Machines_content:Dock(FILL)
        Machines_content:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
        Machines_content.Paint = function(s, w, h)
			draw.SimpleText(zgo2.language[ "Select Amount" ], zclib.GetFont("zclib_font_big"), w / 2, 20 * zclib.hM, zclib.colors[ "text01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local selectedAmount = math.Clamp(Jar:GetWeedAmount(), 0, zgo2.config.Baggy.Capacity)
		local AmountSlider = zgo2.vgui.NumSlider(Machines_content, selectedAmount, zgo2.language[ "Amount" ] .. ":", function(val)
			selectedAmount = val
		end, 0, math.Clamp(selectedAmount, 0, zgo2.config.Baggy.Capacity), 0)
		AmountSlider:Dock(TOP)
		AmountSlider:SetTall(40* zclib.hM)
		AmountSlider:DockMargin(20 * zclib.wM, 90 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
		AmountSlider.PerformLayout = function(self) self.Label:SetWide(self:GetWide() / 6.5) end
		AmountSlider:DockPadding(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
		AmountSlider:SetValue(selectedAmount)
		AmountSlider.TextArea:SetNumeric(true)
		AmountSlider.TextArea.PerformLayout = function(s, width, height)
			s:SetWide(56 * zclib.wM)
			s:SetFontInternal(zclib.GetFont("zclib_font_small"))
		end

		local yes = zgo2.vgui.Button(Machines_content, zgo2.language[ "Confirm" ], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors[ "green01" ], function()

			if selectedAmount <= 0 then return end

			main:Remove()

			// Start pointer system
			zgo2.Jar.ChooseSpawnPos(Jar,function(pos)

				zclib.PointerSystem.Stop()

				net.Start("zgo2.Jar.Split")
				net.WriteEntity(Jar)
				net.WriteUInt(math.Round(selectedAmount), 32)
				net.WriteVector(pos)
				net.SendToServer()

			end, function()
				zgo2.Jar.Split(Jar)
			end)
		end)
		yes:Dock(LEFT)
		yes:SetWide(200 * zclib.wM)
		yes:DockMargin(20 * zclib.wM, 20 * zclib.hM, 0 * zclib.wM, 20 * zclib.hM)

		local No = zgo2.vgui.Button(Machines_content, zgo2.language["Cancel"], zclib.GetFont("zclib_font_mediumsmall"), zclib.colors[ "red01" ], function()
			main:Remove()
		end)
		No:Dock(RIGHT)
		No:SetWide(200 * zclib.wM)
		No:DockMargin(10 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 20 * zclib.hM)
	end)
end

function zgo2.Jar.ChooseSpawnPos(Jar,OnSelect,OnCancel)

	if IsValid(SelectionWindow) then SelectionWindow:Remove() end

	local ply = LocalPlayer()

	zclib.PointerSystem.Start(Jar, function()
		// OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
		zclib.PointerSystem.Data.ActionName = zgo2.language["Chooseposition"]
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()
		// OnLeftClick
		local pos = zclib.PointerSystem.Data.Pos
		if not pos then return end

		if not zclib.util.InDistance(pos,ply:GetPos(), 300) then return end

		pcall(OnSelect,pos)

	end, function()

		// Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
			if zclib.PointerSystem.Data.Pos and zclib.util.InDistance(zclib.PointerSystem.Data.Pos,ply:GetPos(), 300)  then
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.colors[ "green01" ])
			else
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.colors[ "red01" ])
			end
		end
	end, nil, function()
		pcall(OnCancel)
	end)
end
