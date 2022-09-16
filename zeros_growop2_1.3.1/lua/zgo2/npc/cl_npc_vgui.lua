zgo2 = zgo2 or {}
zgo2.NPC = zgo2.NPC or {}
zgo2.NPC.List = zgo2.NPC.List or {}

/*

	Players can buy bongs and sell weed at the npc

*/

local function Button(main,txt,tooltip,color,func)
	local btn = zgo2.vgui.Button(main,txt,zclib.GetFont("zclib_font_mediumsmall"),color,func)
	btn:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
	btn:SetTall(50 * zclib.hM)
	btn:SetTooltip(tooltip)
end
net.Receive("zgo2.NPC.Open", function(len,ply)
    zclib.Debug_Net("zgo2.NPC.Open", len)

    local NPC = net.ReadEntity()
	if not IsValid(NPC) then return end
	NPC.NextQuickSell = net.ReadUInt(32) or 0
	zgo2.NPC.Open(NPC)
end)

local NPCWindow
function zgo2.NPC.Open(NPC)
	NPCWindow = zclib.vgui.Page(NPC:GetClass() == "zgo2_npc" and zgo2.language[ "Weed Dealer" ] or zgo2.language[ "Export Manager" ], function(main, top)
        main:SetSize(600 * zclib.wM, 600 * zclib.hM)

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zgo2.language[ "Close" ])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		if NPC:GetClass() == "zgo2_npc_export" then

			Button(main,zgo2.language[ "Cargo Info" ],zgo2.language[ "Cargo Info Tooltip" ],zclib.colors["orange01"],function()
				// Display a list of all the cargo the player can sell
				zgo2.NPC.CargoInfo(NPC)
			end)

			Button(main,zgo2.language[ "Request Pickup" ],zgo2.language[ "Request Pickup Tooltip" ],zclib.colors["orange01"],function()
				// Send net message to ask for a free dropzone
				net.Start("zgo2.NPC.RequestDropZone")
				net.WriteEntity(NPC)
				net.SendToServer()
			end)

			Button(main,zgo2.language[ "Marketplace" ],zgo2.language[ "Marketplace Tooltip" ],zclib.colors["orange01"],function()
				zgo2.Marketplace.OpenMap(nil,NPC)
			end)
			return
		end

		Button(main,zgo2.language[ "Buy Bongs" ],zgo2.language[ "Buy Bongs Tooltip" ],zclib.colors["orange01"],function()
			zgo2.NPC.Bongs(NPC)
		end)

		if not zgo2.NPC.IsCustomer(LocalPlayer()) then return end

		Button(main,zgo2.language[ "Quick Sell" ],zgo2.language[ "Quick Sell Tooltip" ],zclib.colors["orange01"],function()
			zgo2.NPC.QuickSell(NPC)
		end)
    end)
end

function zgo2.NPC.Bongs(NPC)
	zclib.vgui.Page(zgo2.language[ "Bongs" ], function(main, top)
        main:SetSize(500 * zclib.wM, 600 * zclib.hM)

		top.Title_font = zclib.util.FontSwitch(zgo2.language[ "Bongs" ],400 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zgo2.language[ "Close" ])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("back"), zclib.colors["orange01"], function()
			zgo2.NPC.Open(NPC)
		end,function() return false end,"back")

		local Machines_content = vgui.Create("DPanel", main)
        Machines_content:Dock(FILL)
        Machines_content:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
        Machines_content.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
        end

		local BongID = 1
		local BongPreview
		local function Rebuild(id)
			if IsValid(BongPreview) then
				BongPreview:Remove()
			end

			local BongData = zgo2.config.Bongs[ id ]
			local BongType = zgo2.Bong.Types[ BongData.type ]

			local CanBuy = zgo2.NPC.CanBuyBong(LocalPlayer(),BongID)

			BongPreview = vgui.Create("DPanel", Machines_content)
	        BongPreview:Dock(FILL)
	        BongPreview.Paint = function(s, w, h)
				if CanBuy then
					draw.SimpleTextOutlined(BongData.name, zclib.GetFont("zclib_font_big"), w / 2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)

					draw.RoundedBox(0, 0, h * 0.75, w, 40 * zclib.hM, zclib.colors["black_a50"])
					draw.SimpleTextOutlined(zclib.Money.Display(BongData.price or 0), zclib.GetFont("zclib_font_medium"), w / 2, h * 0.76, zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
				end
		    end
			BongPreview.PaintOver = function(s,w,h)
				if not CanBuy then
					draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a150"])
					zclib.util.DrawBlur(s, 1, 6)

					surface.SetDrawColor(zclib.colors["white_a100"])
					surface.SetMaterial(zclib.Materials.Get("icon_locked"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, w * 0.5, w * 0.5, 0)
				end
			end

			local function AddButton(txt,dock,func)
				local btn = vgui.Create("DButton", BongPreview)
				btn:SetText("")
				btn:SetWide(60 * zclib.wM)
				btn:Dock(dock)
				btn.Paint = function(s, w, h)
					draw.SimpleTextOutlined(txt, zclib.GetFont("zclib_font_giant"), w / 2, h / 2, s:IsHovered() and zclib.colors["orange01"] or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end
				btn.DoClick = function(s)
					zclib.vgui.PlaySound("UI/buttonclick.wav")
					pcall(func)
					Rebuild(BongID)
				end
			end

			AddButton("<",LEFT,function()
				BongID = BongID - 1
				if not zgo2.config.Bongs[ BongID ] then BongID = #zgo2.config.Bongs end
			end)

			AddButton(">",RIGHT,function()
				BongID = BongID + 1
				if not zgo2.config.Bongs[ BongID ] then BongID = 1 end
			end)

			if CanBuy then
				local purchaseBtn = zgo2.vgui.Button(BongPreview,zgo2.language[ "Purchase" ],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["green01"],function()

					if not zgo2.NPC.CanBuyBong(LocalPlayer(),BongID) then return end

					// Send net message to purchase this bong
					net.Start("zgo2.NPC.PurchaseBong")
					net.WriteUInt(BongID,32)
					net.SendToServer()
				end)
				purchaseBtn:Dock(BOTTOM)
				purchaseBtn:SetTall(50 * zclib.hM)
				purchaseBtn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
			end

			local img_pnl = vgui.Create("DImage", BongPreview)
			img_pnl:DockMargin(0 * zclib.wM, 20 * zclib.hM, 0 * zclib.wM, 50 * zclib.hM)
			local img = zclib.Snapshoter.Get({
				class = "zgo2_bong",
				model = BongType.wm,
				BongID = BongData.uniqueid,
			}, img_pnl)
			img_pnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			img_pnl:Dock(FILL)
		end

		Rebuild(BongID)
	end)
end

net.Receive("zgo2.NPC.QuickSell", function(len,ply)
    zclib.Debug_Net("zgo2.NPC.QuickSell", len)

    local NPC = net.ReadEntity()
	if not IsValid(NPC) then return end
	NPC.NextQuickSell = net.ReadUInt(32) or 0

	zgo2.NPC.QuickSell(NPC)
end)
function zgo2.NPC.QuickSell(NPC)
	zclib.vgui.Page(zgo2.language[ "Quick Sell" ], function(main, top)
		main:SetSize(600 * zclib.wM, 600 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
			main:Close()
		end,function() return false end,zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("back"), zclib.colors["orange01"], function()
            zgo2.NPC.Open(NPC)
        end,function() return false end,zgo2.language[ "Back" ])

		local function GetNearWeedValue()

			local WeedJarList = {}
			for k,v in ipairs(ents.FindInSphere(NPC:GetPos(),200)) do
				if not IsValid(v) then continue end
				if v:GetClass() ~= "zgo2_jar" then continue end

				local id = v:GetWeedID()
				if id <= 0 then continue end

				table.insert(WeedJarList,{id = id,amount = v:GetWeedAmount()})
			end

			local Added = 0
			local SoldList = {}
			for _,data in pairs(WeedJarList) do

				if Added >= zgo2.config.NPC.QuickSell.Amount then break end

				if data.amount <= 0 then continue end

				local add = 0
				if data.amount >= zgo2.config.NPC.QuickSell.Amount then
					add = zgo2.config.NPC.QuickSell.Amount
				else
					add = data.amount
				end

				Added = Added + add
				SoldList[ data.id ] = (SoldList[ data.id ] or 0) + add
			end

			// Add the weed jars from the backpack
			local backpack = LocalPlayer():GetWeapon("zgo2_backpack")
			if backpack and IsValid(backpack) and backpack.Inventory then
				for k, v in pairs(backpack.Inventory) do
					if v and v.class == "zgo2_jar" and v.weed_id and v.weed_amount then
						SoldList[ v.weed_id ] = (SoldList[ v.weed_id ] or 0) + v.weed_amount
					end
				end
			end

			local Value = 0
			local Amount = 0
			for weed_id,weed_amount in pairs(SoldList) do

				local WeedData = zgo2.Plant.GetData(weed_id)
				if not WeedData then continue end

				local WeedValue = ((zgo2.Plant.GetSellValue(weed_id) * weed_amount) / 100) * zgo2.config.NPC.QuickSell.Rate

				Amount = Amount + weed_amount
				Value = Value + WeedValue
			end

			return Value , Amount
		end

		local value,amount = GetNearWeedValue()

		local lbl = vgui.Create("DLabel", main)
		lbl:SetTall(80 * zclib.hM)
		lbl:Dock(TOP)
		lbl:SetFont(zclib.GetFont("zclib_font_large"))
		lbl:SetTextColor(zclib.colors[ "text01" ])
		lbl:SetText(amount .. zgo2.config.UoM)
		lbl:SetContentAlignment(5)

		local lbl_money = vgui.Create("DLabel", main)
		lbl_money:SetTall(50 * zclib.hM)
		lbl_money:Dock(TOP)
		lbl_money:SetFont(zclib.GetFont("zclib_font_big"))
		lbl_money:SetTextColor(zclib.colors[ "green01" ])
		lbl_money:SetText(zclib.Money.Display(value))
		lbl_money:SetContentAlignment(5)


		local btn = vgui.Create("DButton", main)
		btn:Dock(TOP)
		btn:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
		btn:SetTall(50 * zclib.hM)

		btn:SetTooltip(zgo2.language[ "Quick Sell Tooltip" ])
		btn:SetFont(zclib.GetFont("zclib_font_mediumsmall"))
		btn:SetText(zgo2.language[ "Sell" ])
		btn:SetTextColor(zclib.colors[ "green01" ])
		btn:SizeToContentsX(30 * zclib.wM)

		btn.Paint = function(s, w, h)

			local diff = math.Clamp(NPC.NextQuickSell - CurTime(), 0, zgo2.config.NPC.QuickSell.Cooldown)
			if diff > 0 then
				s:SetText(string.FormattedTime(math.Round(diff), "%02i:%02i"))
				s:SetTextColor(zclib.colors[ "text01" ])
				draw.RoundedBox(0, 0, 0, w / zgo2.config.NPC.QuickSell.Cooldown * diff, h, zclib.colors[ "black_a100" ])
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors[ "text01" ])
			else
				zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors[ "green01" ])
				s:SetText(zgo2.language[ "Sell" ])
				s:SetTextColor(zclib.colors[ "green01" ])

				value,amount = GetNearWeedValue()
				lbl:SetText(amount .. zgo2.config.UoM)
				lbl_money:SetText(zclib.Money.Display(value))

				if s:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, zclib.colors[ "white_a15" ])
				end
			end
		end

		btn.DoClick = function(s)
			if math.Clamp(NPC.NextQuickSell - CurTime(), 0, zgo2.config.NPC.QuickSell.Cooldown) > 0 then
				zclib.Notify(LocalPlayer(), zgo2.language[ "Quick Sell Cooldown" ], 1)

				return
			end
			zclib.vgui.PlaySound("UI/buttonclick.wav")

			net.Start("zgo2.NPC.QuickSell")
			net.WriteEntity(NPC)
			net.SendToServer()

			main:Close()
		end

		btn.OnRemove = function() zclib.Hook.Remove("PostDrawOpaqueRenderables", "zgo2.NPC.QuickSell") end

		zclib.Hook.Remove("PostDrawOpaqueRenderables", "zgo2.NPC.QuickSell")
		zclib.Hook.Add("PostDrawOpaqueRenderables", "zgo2.NPC.QuickSell", function()
			for k, v in ipairs(ents.FindInSphere(NPC:GetPos(), 200)) do
				if not IsValid(v) then continue end
				if v:GetClass() ~= "zgo2_jar" then continue end
				local id = v:GetWeedID()
				if id <= 0 then continue end
				zgo2.HUD.Draw(v,function()
					draw.SimpleText(zclib.config.Currency, zclib.GetFont("zclib_world_font_giant"), 0, -70, zclib.colors[ "green01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("▼", zclib.GetFont("zclib_world_font_medium"), 0, 0, zclib.colors[ "green01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end)
			end
		end)
	end)
end

function zgo2.NPC.CargoInfo(NPC)
	zclib.vgui.Page(zgo2.language[ "Cargo Info" ], function(main, top)
		main:SetSize(600 * zclib.wM, 700 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
			main:Close()
		end,function() return false end,zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("back"), zclib.colors["orange01"], function()
            zgo2.NPC.Open(NPC)
        end,function() return false end,zgo2.language[ "Back" ])

		local mainPanel = vgui.Create( "DPanel" ,main)
		mainPanel:Dock(FILL)
		mainPanel:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		mainPanel.Paint = function(s, w, h) end
		mainPanel:InvalidateLayout(true)
		mainPanel:InvalidateParent(true)

		// Get a list of all the cargo types the player is allowed to sell
		local CargoList = zgo2.Cargo.GetAllowed(LocalPlayer())

		local list, scroll = zclib.vgui.List(mainPanel)
		list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
		list:SetSpaceY(5 * zclib.hM)
		scroll:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])
		end
		scroll.PaintOver = function(s,w,h)
			surface.SetDrawColor(zclib.colors["black_a100"])
			surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
			surface.DrawTexturedRectRotated(w/2, h - 30 * zclib.hM, 60 * zclib.hM, w,-90)

			surface.SetDrawColor(zclib.colors["black_a100"])
			surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
			surface.DrawTexturedRectRotated(w/2,30 * zclib.hM, 60 * zclib.hM, w,90)

			if CargoList == nil or table.Count(CargoList) <= 0 then
				draw.SimpleText(zgo2.language[ "NoCargoToSell" ], zclib.GetFont("zclib_font_big"), w / 2, h / 2, zclib.colors["white_a50"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local Size = 50

		for _, cargo_data in pairs(CargoList) do
			local itm = list:Add("DPanel")
			itm:SetSize(mainPanel:GetWide() - 35 * zclib.wM, Size * zclib.hM)
			itm.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui00" ]) end
			itm:InvalidateLayout(true)
			itm:InvalidateParent(true)
			local CargoConfig = zgo2.Cargo.Get(cargo_data[ 1 ])
			if not CargoConfig then continue end

			local Thumbnail = CargoConfig.GetThumbnailData(cargo_data)

			local imgpnl
			if Thumbnail then

				imgpnl = vgui.Create("DImage", itm)
				local img = zclib.Snapshoter.Get(Thumbnail, imgpnl)
				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			else
				// Check if some icon was provided so we use that instead
				if CargoConfig.GetIcon then

					imgpnl = vgui.Create("DPanel", itm)
					imgpnl.Paint = function(s, w, h)
						surface.SetDrawColor(color_white)
						surface.SetMaterial(CargoConfig.GetIcon)
						surface.DrawTexturedRect(0, 0, w, h)
					end
				end
			end
			imgpnl:SetSize(Size * zclib.wM, Size * zclib.hM)
			imgpnl:Dock(LEFT)

			local cargo_name = CargoConfig.GetName(cargo_data)
			local infopnl = vgui.Create("DPanel", itm)
			infopnl:SetSize(130 * zclib.wM, 80 * zclib.hM)
			infopnl:Dock(FILL)
			infopnl.Paint = function(s, w, h) draw.SimpleText(cargo_name, zclib.GetFont("zclib_font_medium"), 5 * zclib.wM, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
		end
	end)
end
net.Receive("zgo2.NPC.RequestDropZone", function(len,ply)
    zclib.Debug_Net("zgo2.NPC.RequestDropZone", len)

    local NPC = net.ReadEntity()
	if not IsValid(NPC) then return end
	local ZoneID = net.ReadUInt(32) or 0
	local time = net.ReadUInt(32)

	local entry = zclib.Zone.GetEntry("zgo2_drop_zone")
    if entry == nil then return end

    local zonelist = entry.GetData()
    if zonelist == nil then return end

    local zoneData = zonelist[ZoneID]
    if zoneData == nil then return end

	LocalPlayer():EmitSound("ambient/alarms/warningbell1.wav")

	local RemovalTime = CurTime() + time
	zclib.Hook.Remove("HUDPaint", "zgo2.NPC.RequestDropZone")
	zclib.Hook.Add("HUDPaint", "zgo2.NPC.RequestDropZone", function()

		local asize = Vector(zoneData.size.x,zoneData.size.y,entry.BaseHeight + (entry.ExtraHeight or 200))
		cam.Start3D()
			render.DrawWireframeBox(zoneData.pos +  Vector(0,0,entry.BaseHeight), angle_zero, vector_origin, asize, zclib.colors["green01"], false)
		cam.End3D()

		local pos2d = (zoneData.pos + (zoneData.size / 2) + Vector(0, 0, entry.BaseHeight or 200)):ToScreen()
		draw.SimpleText(string.FormattedTime(RemovalTime - CurTime(), "%02i:%02i"), zclib.GetFont("zclib_font_medium"), pos2d.x, pos2d.y + 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if CurTime() > RemovalTime then
			zclib.Hook.Remove("HUDPaint", "zgo2.NPC.RequestDropZone")
		end
	end)

	if IsValid(NPCWindow) then NPCWindow:Remove() end
end)
