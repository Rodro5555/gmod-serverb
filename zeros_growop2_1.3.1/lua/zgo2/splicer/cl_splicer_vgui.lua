zgo2 = zgo2 or {}
zgo2.Splicer = zgo2.Splicer or {}
zgo2.Splicer.List = zgo2.Splicer.List or {}

/*

	Splicers are used to create new weedseeds from existing one

*/

net.Receive("zgo2.Splicer.Open", function(len,ply)
    zclib.Debug_Net("zgo2SplicerNPC.Open", len)

    local Splicer = net.ReadEntity()
	if not IsValid(Splicer) then return end

	zgo2.Splicer.Open(Splicer)
end)

function zgo2.Splicer.Open(Splicer)
	zclib.vgui.Page(zgo2.language["Splicer"], function(main, top)
        main:SetSize(1100 * zclib.wM, 400 * zclib.hM)

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
        Machines_content.Paint = function(s, w, h) end

		for i = 1, zgo2.Splicer.ItemLimit do

			local PlantData = zgo2.Plant.GetData(Splicer.DataSets[ i ])

			local itm = vgui.Create("DButton", Machines_content)
			itm:SetWide((700 / zgo2.Splicer.ItemLimit) * zclib.wM)
			itm:Dock(LEFT)
			itm:DockMargin(0,0,5 * zclib.wM,0)
			itm:SetText("")
			itm.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "black_a50" ])
				if PlantData then
					draw.SimpleTextOutlined(PlantData.name, zclib.GetFont("zclib_font_small"), w / 2, 25 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
				else
					surface.SetDrawColor(zclib.colors[ "black_a50" ])
					surface.SetMaterial(zclib.Materials.Get("zgo2_icon_weed"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, w, w, 0)
				end
			end
			itm.DoClick = function()
				zclib.vgui.PlaySound("UI/buttonclick.wav")

				if not Splicer.DataSets[ i ] then return end

				net.Start("zgo2.Splicer.Clear")
				net.WriteEntity(Splicer)
				net.WriteUInt(i,8)
				net.SendToServer()

				timer.Simple(0.35,function() if IsValid(main) then zgo2.Splicer.Open(Splicer) end end)
			end

			local CanSplice , WrongJob, WrongRank = zgo2.Splicer.CanSplice(Splicer,LocalPlayer(),i)
			if not CanSplice then
				if WrongJob then
					itm:SetTooltip(zgo2.language[ "WrongJob" ])
				elseif WrongRank then
					itm:SetTooltip(zgo2.language[ "WrongRank" ])
				end
			else
				itm:SetTooltip(zgo2.language[ "confirm_delete" ])
			end

			itm.PaintOver = function(s,w,h)

				if not CanSplice then
					zclib.util.DrawBlur(s, 1, 5)
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a200" ])

					local size = w * 0.7
					surface.SetDrawColor(zclib.colors[ "white_a50" ])
					surface.SetMaterial(zclib.Materials.Get("icon_locked"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, 0)
				end

				if PlantData and s:IsHovered() then
					draw.RoundedBox(0, 0, (h / 2) - 20 * zclib.hM, w, 40 * zclib.hM , zclib.colors[ "black_a200" ])
					draw.SimpleTextOutlined(zgo2.language[ "Delete" ], zclib.GetFont("zclib_font_small"), w / 2, h / 2, zclib.colors[ "red01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end

				zclib.util.DrawOutlinedBox(0,0,w,h, 7, zclib.colors["ui04"])
			end

			if PlantData then

				local imgpnl = vgui.Create("DImage", itm)
				imgpnl:SetSize(300 * zclib.wM, 300 * zclib.hM)

				timer.Simple(0.15,function() if IsValid(imgpnl) then imgpnl:Center() end end)

				local img = zclib.Snapshoter.Get({
					class = "zgo2_plant",
					model = "models/zerochain/props_growop2/zgo2_plant_root.mdl",
					PlantID = PlantData.uniqueid,
				}, imgpnl)
				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			end
		end

		local Info = vgui.Create("DPanel", Machines_content)
		Info:Dock(FILL)
		Info.Paint = function(s, w, h)
			draw.RoundedBox(5, 45 * zclib.wM, 0, w - 45 * zclib.wM, h, zclib.colors[ "black_a50" ])
			draw.SimpleText(">", zclib.GetFont("zclib_font_giant"), 20 * zclib.wM,h/2, zclib.colors["black_a50"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = zgo2.vgui.Button(Info,zgo2.language["Splice"],zclib.GetFont("zclib_font_mediumsmall"),zclib.colors["green01"],function()

			if not zgo2.Splicer.CanUse(Splicer) then
				zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "ToomanyPlants" ] .. " " .. table.Count(zgo2.config.Plants), 1)

				timer.Simple(1.5, function()
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "Tryagainlater" ], 1)
				end)

				return
			end

			if not zgo2.Splicer.HasEnoughSpliceData(Splicer,LocalPlayer()) then
				zclib.PanelNotify.Create(LocalPlayer(), zgo2.language["SplicerNotEnoughData"], 1)
				return
			end

			local cost = zgo2.Splicer.GetCost(Splicer)
			if not zclib.Money.Has(LocalPlayer(), cost) then
				zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "NotEnoughMoney" ], 1)
				return
			end

			zgo2.vgui.TextInput(zgo2.language["EnterPlantName"], function(name)

				if not name then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language["InvalidName"], 1)
					return
				end

				if string.len(name) < 3 then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language["NameToShort"], 1)
					return
				end

				if string.len(name) > 20 then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language["NameToLong"], 1)
					return
				end

				if not zgo2.Splicer.CanUse(Splicer) then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "ToomanyPlants" ] .. " " .. table.Count(zgo2.config.Plants), 1)

					timer.Simple(1.5, function()
						zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "Tryagainlater" ], 1)
					end)

					return
				end

				if not zgo2.Splicer.HasEnoughSpliceData(Splicer,LocalPlayer()) then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language["SplicerNotEnoughData"], 1)
					return
				end

				local cost = zgo2.Splicer.GetCost(Splicer)
				if not zclib.Money.Has(LocalPlayer(), cost) then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "NotEnoughMoney" ], 1)
					return
				end

				net.Start("zgo2.Splicer.Start")
				net.WriteEntity(Splicer)
				net.WriteString(name)
				net.SendToServer()

				main:Close()
			end, function()

			end,zgo2.language[ "Plant" ])
		end)
		btn:Dock(BOTTOM)
		btn:DockMargin(50 * zclib.wM, 5 * zclib.hM, 5 * zclib.wM, 5 * zclib.hM)
		btn:SetTall(40 * zclib.hM)

		local cost = zgo2.Splicer.GetCost(Splicer)

		local extraInfo = vgui.Create("DPanel", Info)
		extraInfo:Dock(FILL)
		extraInfo:DockMargin(45 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		extraInfo.Paint = function(s, w, h)
			draw.SimpleText("?", zclib.GetFont("zclib_font_giant"), w / 2, h / 2.2, zclib.colors[ "black_a50" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			zclib.util.DrawOutlinedBox(5 * zclib.wM, 5 * zclib.hM, w - (10 * zclib.wM), h - (50 * zclib.hM), 2, zclib.colors["black_a50"])
			zclib.util.DrawOutlinedBox(5 * zclib.wM, h - 40 * zclib.hM, w - (10 * zclib.wM), 40 * zclib.hM, 2, zclib.colors["black_a50"])
			draw.SimpleText(zclib.Money.Display(cost,true), zclib.GetFont("zclib_font_medium"), w / 2, h - 20 * zclib.hM, zclib.colors[ "red01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end)
end
