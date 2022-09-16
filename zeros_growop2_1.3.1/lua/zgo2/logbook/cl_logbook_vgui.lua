zgo2 = zgo2 or {}
zgo2.Logbook = zgo2.Logbook or {}
zgo2.Logbook.List = zgo2.Logbook.List or {}

--[[

Players can buy bongs and sell weed at the Logbook

]]
net.Receive("zgo2.Logbook.Open", function(len, ply)
	zclib.Debug_Net("zgo2.Logbook.Open", len)
	zgo2.Logbook.List = {}
	local earnings = {}
	local expenses = {}
	local count = net.ReadUInt(32)

	for i = 1, count do
		local data = {
			name = net.ReadString(),
			money = net.ReadUInt(32),
			expense = net.ReadBool(),
			count = net.ReadUInt(32),
			class = net.ReadString()
		}

		table.insert(data.expense and expenses or earnings, data)
	end

	zgo2.Logbook.List = table.Add(zgo2.Logbook.List, expenses)
	zgo2.Logbook.List = table.Add(zgo2.Logbook.List, earnings)
	zgo2.Logbook.Open()
end)

function zgo2.Logbook.Open()
	zclib.vgui.Page(zgo2.language["Logbook"], function(main, top)
		main:SetSize(700 * zclib.wM, 900 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors[ "red01" ], function()
			main:Close()
		end, function() return false end, zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("share"), zclib.colors[ "blue02" ], function()
			zgo2.Logbook.ShareList()
		end, function() return false end, zgo2.language["Logbook_share_tooltip"])

		// Add a reset button for your log data
		zgo2.vgui.ImageButton(top, zclib.Materials.Get("refresh"), zclib.colors[ "red01" ], function()
			net.Start("zgo2.Logbook.Reset")
			net.SendToServer()
		end, function() return false end, zgo2.language["Logbook_reset_tooltip"])

		local content = vgui.Create("DPanel", main)
		content:Dock(FILL)
		content:DockMargin(50 * zclib.wM, 0 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		content.Paint = function(s, w, h) end
		content:InvalidateLayout(true)
		content:InvalidateParent(true)


		local list, scroll = zclib.vgui.List(content)
		list:DockMargin(10 * zclib.wM, 30 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		list:SetSpaceY(0)
		scroll:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		scroll.Paint = function(s, w, h)

		end

		scroll.PaintOver = function(s, w, h)

			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a100" ])

			draw.RoundedBox(5, 0, 0, w - 20 * zclib.wM, 27 * zclib.hM, zclib.colors["ui04"])

			draw.RoundedBox(0, w - 130 * zclib.wM, 0, 4 * zclib.wM, h, zclib.colors[ "black_a100" ])
			draw.RoundedBox(0, 310 * zclib.wM, 0, 4 * zclib.wM, h, zclib.colors[ "black_a100" ])

			draw.SimpleText(zgo2.language["Amount"], zclib.GetFont("zclib_font_small"), w / 2 - 15 * zclib.wM, 10 * zclib.hM, zclib.colors[ "text01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText(zgo2.language["Expenses"], zclib.GetFont("zclib_font_small"), w - 61 * zclib.wM, 10 * zclib.hM, zclib.colors[ "text01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(zgo2.language["Earnings"], zclib.GetFont("zclib_font_small"), w - 140 * zclib.wM, 10 * zclib.hM, zclib.colors[ "text01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end

		local TotalEarning = 0
		local TotalExpense = 0

		for k, data in pairs(zgo2.Logbook.List) do
			local col = data.expense and zclib.colors[ "red01" ] or zclib.colors[ "green01" ]
			local money = zclib.Money.Display(data.money)

			if data.expense then
				money = "-" .. money
			else
				money = "+" .. money
			end

			local name = data.name

			if data.expense then
				TotalExpense = TotalExpense + data.money
			else
				TotalEarning = TotalEarning + data.money
			end

			local itm = list:Add("DPanel")
			itm:SetSize(content:GetWide() - 35 * zclib.wM, 30 * zclib.hM)

			local CargoConfig = zgo2.Cargo.Get(data.class)

			local Amount = "x" .. data.count
			if data.count then
				if data.expense then
					Amount = "x" .. data.count
				else
					if CargoConfig and CargoConfig.DisplayAmount then
						Amount = CargoConfig.DisplayAmount(data.count)
					else
						Amount = "x" .. data.count
					end
				end
			end

			itm.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, h - 2 * zclib.hM, w, 2 * zclib.hM, zclib.colors[ "black_a100" ])
				draw.SimpleText(Amount, zclib.GetFont("zclib_font_small"), 290 * zclib.wM, h / 2, zclib.colors[ "text01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				draw.SimpleText(name, zclib.GetFont("zclib_font_small"), 0 * zclib.wM, h / 2, zclib.colors[ "text01" ], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(money, zclib.GetFont("zclib_font_small"), data.expense and w or w - 130 * zclib.wM, h / 2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end

		local diff = zclib.Money.Display(TotalEarning - TotalExpense)
		local result_col = zclib.colors[ "text01" ]

		if TotalEarning - TotalExpense < 0 then
			result_col = zclib.colors[ "red01" ]
		else
			diff = "+" .. diff
			result_col = zclib.colors[ "green01" ]
		end

		TotalEarning = "+" .. zclib.Money.Display(TotalEarning)
		TotalExpense = "-" .. zclib.Money.Display(TotalExpense)

		local result = vgui.Create("DPanel", main)
		result:SetTall(40 * zclib.hM)
		result:Dock(BOTTOM)
		result:DockMargin(50 * zclib.wM, 0 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)

		result.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a100" ])
			draw.SimpleText(diff, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, h / 2, result_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(TotalExpense, zclib.GetFont("zclib_font_small"), w - 10 * zclib.wM, h / 2, zclib.colors[ "red01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(TotalEarning, zclib.GetFont("zclib_font_small"), w - 140 * zclib.wM, h / 2, zclib.colors[ "green01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end)
end

function zgo2.Logbook.ShareList()
	zclib.vgui.Page(zgo2.language["Share"], function(main, top)
		main:SetSize(700 * zclib.wM, 900 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors[ "red01" ], function()
			main:Close()
		end, function() return false end, zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("back"), zclib.colors[ "orange01" ], function()
			zgo2.Logbook.Open()
		end, function() return false end, zgo2.language[ "Back" ])

		local content = vgui.Create("DPanel", main)
		content:Dock(FILL)
		content:DockMargin(50 * zclib.wM, 0 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		content.Paint = function(s, w, h) end
		content:InvalidateLayout(true)
		content:InvalidateParent(true)

		local list, scroll = zclib.vgui.List(content)
		list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		list:SetSpaceY(2)
		scroll:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a100" ])
		end

		for _, pl in pairs(player.GetAll()) do
			if not IsValid(pl) then continue end

			// Dont display yourself
			if pl == LocalPlayer() then continue end

			local name = pl:Nick()
			local sid64 = pl:SteamID64()
			local CanAccess = zgo2.Logbook.Share[sid64] == true

			local itm = list:Add("DButton")
			itm:SetSize(content:GetWide() - 20 * zclib.wM, 30 * zclib.hM)
			itm:SetText("")
			itm.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a100" ])
				draw.RoundedBox(5, 0, 0, 10 * zclib.wM, h, CanAccess and zclib.colors[ "green01" ] or zclib.colors[ "red01" ])

				draw.SimpleText(name, zclib.GetFont("zclib_font_small"), 15 * zclib.wM, h / 2, zclib.colors[ "text01" ], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				if s:IsHovered() then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a15" ])
				end
			end

			itm.DoClick = function()
				zclib.vgui.PlaySound("UI/buttonclick.wav")

				// Send a net message to the SERVER telling him you share/toggle your data with this player
				zgo2.Logbook.RequestShare(pl)
			end
		end
	end)
end
