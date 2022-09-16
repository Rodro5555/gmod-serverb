zgo2 = zgo2 or {}
zgo2.Marketplace = zgo2.Marketplace or {}

/*

	The Marketplace manages which players has what weed in which Marketplace in the world
	Players can sell large amounts of weed from here and also other registered entities

*/

// Create the mask for the sun fade
zclib.BMASKS.CreateMask("zgo2_sun_mask", "materials/zerochain/zgo2/sun_mask.png", "smooth noclamp")
zclib.BMASKS.CreateMask("zgo2_cloud_mask", "materials/zerochain/zgo2/map_clouds.png", "smooth noclamp")

local WorldMapWindow

// The window of the marketplace thats currently open
local MarketplaceWindow

local MarketplaceID

// A list of items which are currently selected
local CargoList = {}

/*
	Build a 2d map of the world with some locations to click on
*/
local function BuildMap(parent,OnLocationSelect,OnLocationDraw,OnDraw)
	local map = vgui.Create( "DPanel" ,parent)
	map:Dock(FILL)
	map:DockMargin(50 * zclib.wM, 0 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
	map:NoClipping(true)

	map.OnRemove = function()
		//LocalPlayer():StopSound("zgo2_map_background_ambient")
		zclib.util.LoopedSound(LocalPlayer(), "zgo2_map_background_ambient",false)
		zclib.util.LoopedSound(LocalPlayer(), "zgo2_map_marketplace_ambient",false)
	end

	map.Paint = function(s, w, h)

		// Play ambient music
		zclib.util.LoopedSound(LocalPlayer(), "zgo2_map_background_ambient", not IsValid(MarketplaceWindow))
		zclib.util.LoopedSound(LocalPlayer(), "zgo2_map_marketplace_ambient", IsValid(MarketplaceWindow))

		surface.SetDrawColor(color_white)
		surface.SetMaterial(zclib.Materials.Get("zgo2_map"))
		surface.DrawTexturedRect(0, 0, w, h)

		// Why the fuck do i even add that, just because it looks nice?
		zclib.BMASKS.BeginMask("zgo2_sun_mask")

			zclib.Blendmodes.Blend("Additive",false,function()
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zclib.Materials.Get("zgo2_map_night"))
				surface.DrawTexturedRect(0, 0, w, h)
			end)
		zclib.BMASKS.EndMask("zgo2_sun_mask",-CurTime() / zgo2.config.Marketplace.Sell.Interval, 0, w, h, 240, 0 , false,true)


		zclib.BMASKS.BeginMask("zgo2_cloud_mask")

			zclib.Blendmodes.Blend("Additive",false,function()
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zclib.Materials.Get("zgo2_sun_mask"))
				local move = -CurTime() / (zgo2.config.Marketplace.Sell.Interval / 2)
				move = move * 10
				local u0, v0 = 0 + move, 0
				local u1, v1 = 1 + move, 1
				surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)
			end)
		zclib.BMASKS.EndMask("zgo2_cloud_mask",CurTime() / zgo2.config.Marketplace.Sell.Interval, 0, w, h, 50, 0 , false,true)

		if OnDraw then pcall(OnDraw,s,w,h) end

		// TODO I wanna show other players avatars on the map when they move cargo from one marketplace to another

		if IsValid(MarketplaceWindow) then
			return
		end

		// Display your Transfer Limit and how many are currently active (Planes)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(zclib.Materials.Get("zgo2_icon_plane"))
		surface.DrawTexturedRectRotated(w - 35 * zclib.wM,35 * zclib.hM, 60 * zclib.wM, 60 * zclib.hM, 45)

		draw.SimpleText(table.Count(zgo2.Marketplace.Transfers) .. "/" .. zgo2.Marketplace.GetTransferLimit(LocalPlayer()), zclib.GetFont("zclib_font_big"), w - 60 * zclib.wM, 37 * zclib.hM, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


		//NOTE Used for debugging to find the correct cordinates
		local x, y = input.GetCursorPos()
		x, y = s:ScreenToLocal(x, y)
		x = math.Clamp(x, 0, w)
		y = math.Clamp(y, 0, h)
		draw.SimpleText("X: " .. math.Round(x / zclib.wM), zclib.GetFont("zclib_font_small"), 9 * zclib.wM, 5 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("Y: " .. math.Round(y / zclib.hM), zclib.GetFont("zclib_font_small"), 9 * zclib.wM, 25 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	map.PaintOver = function(s, w, h)
		if IsValid(MarketplaceWindow) then
			return
		end

		/*
		// Displays when the next marketplace update will be send
		local remain = math.Clamp((1 / zgo2.config.Marketplace.Sell.Interval) * (CurTime() - zgo2.Marketplace.LastUpdateRate),0,1)
		draw.RoundedBox(0, w * remain, 0, 2 * zclib.wM, h * 0.99, zclib.colors[ "blue02" ])
		*/

		zclib.util.DrawOutlinedBox(0, 0, w , h , 4, zclib.colors[ "ui01" ])

		/*
		local box = 40
		draw.RoundedBox(5, w * remain - (box/2) * zclib.wM, h - 25 * zclib.hM, box * zclib.wM, 20 * zclib.hM, zclib.colors[ "blue02" ])
		draw.SimpleText("%", zclib.GetFont("zclib_font_mediumsmall"),w * remain,h - 15 * zclib.hM, zclib.colors[ "black_a200" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		*/

		// Draw all the out going cargo transfers
		if zgo2.Marketplace.Transfers then
			for transfer_id,data in pairs(zgo2.Marketplace.Transfers) do

				// Draw the travel path
				zgo2.Marketplace.DrawPath(zclib.colors[ "text01" ],data.StartID,data.DestinationID)

				// Draw the travel plane
				zgo2.Marketplace.DrawPlane(transfer_id, data.StartID, data.DestinationID, data.TravelDuration, data.TravelStart, data.MuleID)

				if CurTime() > (data.TravelStart + data.TravelDuration) then
					zgo2.Marketplace.Transfers[transfer_id] = nil
				end
			end
		end
	end


	local function AddButton(name,pos,id)

		local x = pos.x * zclib.wM
		local y = pos.y * zclib.hM

		local btn = vgui.Create("DButton", map)
		btn:SetText("")
		btn:NoClipping(true)
		btn:SetWide(10 * zclib.wM)
		btn:SetTall(10 * zclib.hM)
		btn:SetPos(x - (5 * zclib.wM),y - (5 * zclib.hM))
		btn.Paint = function(s, w, h)

			if IsValid(MarketplaceWindow) then return end

			if s:IsHovered() then

				surface.SetDrawColor(color_black)
				surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
				surface.DrawTexturedRectRotated(w/2, h/2, 200 * zclib.wM,200 * zclib.hM, 0)

				surface.SetDrawColor(zclib.colors["blue02"])
				surface.SetMaterial(zclib.Materials.Get("circle_48"))
				surface.DrawTexturedRectRotated(w/2, h/2, w, h,0)

				draw.RoundedBox(0, w / 2 - 1 * zclib.wM, -20 * zclib.hM, 2 * zclib.wM, 16 * zclib.hM, color_white)
				draw.SimpleTextOutlined(name, zclib.GetFont("zclib_font_small"), w / 2, -20 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)

				if zgo2.config.Marketplace.Sell.Enabled then
					// Display how much the buy % is currently on this marketplace
					local NiceRate, NiceColor = zgo2.Marketplace.GetNiceRate(id)
					draw.SimpleTextOutlined(NiceRate, zclib.GetFont("zclib_font_medium"), w / 2, -40 * zclib.hM, NiceColor , TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
				end
			else
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zclib.Materials.Get("circle_48"))
				surface.DrawTexturedRectRotated(w/2, h/2, w, h,0)

				/*
				if zgo2.config.Marketplace.Sell.Enabled then
					// Display how much the buy % is currently on this marketplace
					local NiceRate, NiceColor = zgo2.Marketplace.GetNiceRate(id)
					draw.SimpleTextOutlined(NiceRate, zclib.GetFont("zclib_font_small"), w / 2, -5 * zclib.hM, NiceColor , TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
				end
				*/
			end

			if OnLocationDraw then pcall(OnLocationDraw,id,s,w,h) end
		end
		btn.DoClick = function(s)
			zclib.vgui.PlaySound("UI/buttonclick.wav")
			pcall(OnLocationSelect,id,map)
		end
	end
	for k, v in pairs(zgo2.Marketplace.List) do
		AddButton(v.name,v.pos,k)
	end

	return map
end

/*
	Creates the Mule Selection window
*/
local function SelectMule(pnl,OnSelect)

	pnl:Remove()

	local pnl = vgui.Create("DPanel", MarketplaceWindow)
	pnl:SetSize(700 * zclib.wM, 600 * zclib.hM)
	pnl:NoClipping(true)
	pnl:Center()
	pnl:DockPadding(0, 40 * zclib.hM, 0, 0)
	pnl.Paint = function(s, w, h)

		local x,y = s:LocalToScreen(0,0)
		BSHADOWS.BeginShadow()
		surface.SetDrawColor(255, 255,255)
		surface.DrawRect(x, y, w, h)
		BSHADOWS.EndShadow(1,15,1,255,0,0,true)

		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
		draw.SimpleText(zgo2.language[ "Choose Mule" ], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 10 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	pnl:InvalidateLayout(true)
	pnl:InvalidateParent(true)

	local SelectedMule = 1

	local Muleimage = vgui.Create( "DPanel" ,pnl)
	Muleimage:SetWide(300 * zclib.wM)
	Muleimage:Dock(LEFT)
	Muleimage:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	Muleimage.Paint = function(s, w, h)
		local MuleData = zgo2.config.Mules[SelectedMule]
		if MuleData.img then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(MuleData.img)
			surface.DrawTexturedRect(0, 0, w, h)
		else
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a50" ])
		end
	end

	local Mulelist = vgui.Create( "DPanel" ,pnl)
	Mulelist:Dock(FILL)
	Mulelist:DockMargin(0 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	Mulelist.Paint = function(s, w, h) end
	Mulelist:InvalidateLayout(true)
	Mulelist:InvalidateParent(true)

	// Build a list of all the available Mule provider
	local list, scroll = zclib.vgui.List(Mulelist)
	list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
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
	end

	local FreightWeight = zgo2.Marketplace.GetShippingCost(zgo2.Marketplace.List[MarketplaceID].Cargo,CargoList)

	for k,data in pairs(zgo2.config.Mules) do

		// Multiply by the mules transport cost
		local cost = zclib.Money.Display(data.cost * FreightWeight)

		local itm = list:Add("DButton")
		itm:SetText("")
		itm:SetSize(Mulelist:GetWide() - 20 * zclib.wM,80 * zclib.hM)
		itm.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, k == SelectedMule and zclib.colors[ "ui_highlight" ] or zclib.colors[ "ui00" ])
			draw.SimpleText(data.name, zclib.GetFont("zclib_font_medium"),10 * zclib.wM,5 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			draw.SimpleText(zgo2.language[ "Speed" ] .. ": " .. data.speed, zclib.GetFont("zclib_font_tiny"), 10 * zclib.wM, h - 9 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(zgo2.language[ "Spillage" ] .. ": " .. data.spillage .. "%", zclib.GetFont("zclib_font_tiny"), w / 2, h - 9 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(cost, zclib.GetFont("zclib_font_mediumsmall"), w - 10 * zclib.wM, h - 5 * zclib.hM, zclib.colors[ "red01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

			if data.ranks and table.Count(data.ranks) > 0 then
				surface.SetDrawColor(zclib.colors["orange01"])
				surface.SetMaterial(zclib.Materials.Get("rank"))
				surface.DrawTexturedRect(w - 30 * zclib.wM,5 * zclib.hM,25 * zclib.wM,25 * zclib.hM)
			end

			if data.jobs and table.Count(data.jobs) > 0 then
				surface.SetDrawColor(zclib.colors["blue02"])
				surface.SetMaterial(zclib.Materials.Get("job"))
				surface.DrawTexturedRect(w - 60 * zclib.wM,5 * zclib.hM,25 * zclib.wM,25 * zclib.hM)
			end

			if s:IsHovered() then
				draw.RoundedBox(5, 0, 0, w, h,zclib.colors[ "white_a15" ])
			end
		end
		itm.DoClick = function(s)
			zclib.vgui.PlaySound("UI/buttonclick.wav")
			SelectedMule = k
		end
		itm:InvalidateLayout(true)
		itm:InvalidateParent(true)
	end

	local send = zgo2.vgui.Button(Mulelist,zgo2.language[ "Choose" ],zclib.GetFont("zclib_font_mediumsmall"),zclib.colors[ "orange01" ],function()
		if not zgo2.Mule.CanUse(SelectedMule,LocalPlayer()) then
			return
		end

		// Check if the player has money
		local ShippingCost =  FreightWeight * zgo2.Mule.GetCost(SelectedMule)

		if not zclib.Money.Has(LocalPlayer(), ShippingCost) then
			zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "NotEnoughMoney" ], 1)
			return
		end

		pcall(OnSelect,SelectedMule)
	end)
	send:Dock(BOTTOM)
	send:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	send:SetTall(40 * zclib.hM)
	send:SetTooltip(zgo2.language[ "Export_tooltip" ])
end

/*
	Creates the Destination Selection window
*/
local function SelectDestination(StartID,MuleID,OnSelect,OnCancel)
	zclib.vgui.Page(zgo2.language[ "Select Destination" ], function(main, top)
		main:SetSize(1600 * zclib.wM, 800 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
			main:Close()
		end,function() return false end,zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		// Build the world map
		local Map = BuildMap(main,OnSelect,function(LocationID,s,w,h)
			if LocationID == StartID then
				local Size = w * 3
				zclib.util.DrawOutlinedBox(w / 2 - Size / 2, h / 2 - Size / 2, Size, Size, 3, zclib.colors[ "blue02" ])

				draw.SimpleTextOutlined(zgo2.language[ "Start" ], zclib.GetFont("zclib_font_medium"), w / 2, 60 * zclib.hM, zclib.colors[ "blue02" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			end
		end)

		local RightClicked
		Map.PaintOver = function(s,w,h)

			if input.IsMouseDown(MOUSE_RIGHT) then
				if not RightClicked then
					RightClicked = true
					pcall(OnCancel)
				end
				return
			end

			local x, y = input.GetCursorPos()
			x, y = s:ScreenToLocal(x, y)
			x = math.Clamp(x, 0, w)
			y = math.Clamp(y, 0, h)

			local CurPos = Vector(x,y,0)
			local DestinationID
			local LastDist = 9999999999
			for k,v in pairs(zgo2.Marketplace.List) do
				local pos = Vector(v.pos.x * zclib.wM,v.pos.y * zclib.hM,0)

				local dist = pos:Distance(CurPos)
				if dist < LastDist then
					DestinationID = k
					LastDist = dist
				end
			end
			if not DestinationID then return end

			// Draw a line between start and your nearest destination
			zgo2.Marketplace.DrawPath(zclib.colors[ "blue02" ],StartID,DestinationID)

			draw.RoundedBox(5, x + 10 * zclib.wM, y - 60 * zclib.hM,130 * zclib.wM, 50 * zclib.hM, zclib.colors["black_a200"])

			surface.SetDrawColor(color_white)
			surface.SetMaterial(zclib.Materials.Get("zgo2_icon_plane"))
			surface.DrawTexturedRectRotated(x + 35 * zclib.wM, y - 35 * zclib.hM, 60 * zclib.wM, 60 * zclib.hM, 0)

			draw.SimpleTextOutlined(math.Round(zgo2.Marketplace.GetRealTravelDistance(StartID,DestinationID)) .. zgo2.language[ "km" ], zclib.GetFont("zclib_font_small"), x + 65 * zclib.wM, y + -15 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
			draw.SimpleTextOutlined(string.FormattedTime( math.Round(zgo2.Marketplace.GetTravelDuration(MuleID,StartID,DestinationID)), "%02i:%02i" ), zclib.GetFont("zclib_font_small"), x + 65 * zclib.wM, y - 35 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end
	end)
end

/*
	Build a small window that represents the specified marketplace which shows the players cargo that he currently can sell
*/
local contract_orange = Color(209, 185, 102,15)
local function BuildMarketplace(map,id)
	if IsValid(MarketplaceWindow) then MarketplaceWindow:Remove() end

	MarketplaceWindow = vgui.Create("DButton", map)
	MarketplaceWindow:Dock(FILL)
	MarketplaceWindow:SetText("")
	MarketplaceWindow.Paint = function(s, w, h)
		zclib.util.DrawBlur(s, 1, 5)
		zclib.util.DrawOutlinedBox(0, 0, w , h , 4, zclib.colors[ "ui01" ])
	end
	MarketplaceWindow.DoClick = function(s)
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		MarketplaceWindow:Remove()
	end
	MarketplaceWindow:InvalidateLayout(true)
	MarketplaceWindow:InvalidateParent(true)

	local MarketData = zgo2.Marketplace.List[id]

	local pnl = vgui.Create("DPanel", MarketplaceWindow)
	pnl:SetSize(700 * zclib.wM, 600 * zclib.hM)
	pnl:NoClipping(true)
	pnl:Center()
	pnl:DockPadding(0, 40 * zclib.hM, 0, 0)
	pnl.Paint = function(s, w, h)

		local x,y = s:LocalToScreen(0,0)
		BSHADOWS.BeginShadow()
		surface.SetDrawColor(255, 255,255)
		surface.DrawRect(x, y, w, h)
		BSHADOWS.EndShadow(1,15,1,255,0,0,true)

		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
		draw.SimpleText(MarketData.name, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 10 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	pnl:InvalidateLayout(true)
	pnl:InvalidateParent(true)


	// Check if we got contracts
	local OpenContracts = zgo2.Contracts.GetAll(LocalPlayer(),id)
	if OpenContracts and table.Count(OpenContracts) > 0 then


		local contracts_pnl = vgui.Create("DPanel", MarketplaceWindow)
		contracts_pnl:SetSize(400 * zclib.wM, 600 * zclib.hM)

		local pnlX, pnlY = pnl:GetPos()
		contracts_pnl:SetPos(pnlX + pnl:GetWide() + 10 * zclib.wM, pnlY)

		contracts_pnl:DockPadding(0, 40 * zclib.hM, 0, 0)
		contracts_pnl.Paint = function(s, w, h)

			local x,y = s:LocalToScreen(0,0)
			BSHADOWS.BeginShadow()
			surface.SetDrawColor(255, 255,255)
			surface.DrawRect(x, y, w, h)
			BSHADOWS.EndShadow(1,15,1,255,0,0,true)

			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
			draw.SimpleText(zgo2.language[ "Contracts" ], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 10 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		contracts_pnl:InvalidateLayout(true)
		contracts_pnl:InvalidateParent(true)


		// Build a list of all the weed that you currently have in this marketplace stored
		local list, scroll = zclib.vgui.List(contracts_pnl)
		list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
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
		end

		local steamID64 = LocalPlayer():SteamID64()

		// Here we display all the weed the player has in this marketplace
		for contract_id,contract_data in pairs(OpenContracts) do

			if contract_data.Players == nil then contract_data.Players = {} end

			local itm = list:Add("DPanel")
			itm:SetSize(contracts_pnl:GetWide() - 55 * zclib.wM,100 * zclib.hM)
			itm.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "ui00" ])

				if contract_data.Players[ steamID64 ] then
					draw.RoundedBox(5, 0, 0, w, h, contract_orange)
				end

				local bar = (w / contract_data.time) * (CurTime() - contract_data.start)
				bar = w - math.Clamp(bar,0,w)

				draw.RoundedBox(5, 0, h - 16 * zclib.hM, w, 16 * zclib.hM, zclib.colors[ "black_a100" ])
				draw.RoundedBox(5, 0, h - 16 * zclib.hM, bar, 16 * zclib.hM, zclib.colors[ "ui_highlight" ])

				local time = math.Clamp(contract_data.time - (CurTime() - contract_data.start),0,contract_data.time)

				draw.SimpleText(string.FormattedTime( math.Round(time), "%02i:%02i" ), zclib.GetFont("zclib_font_tiny"), 3 * zclib.wM, h, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

				if time <= 0 then s:Remove() end
			end
			itm:InvalidateLayout(true)
			itm:InvalidateParent(true)

			local CargoConfig = zgo2.Cargo.Get(contract_data.cargo[1])
			if not CargoConfig then continue end

			local Thumbnail = CargoConfig.GetThumbnailData(contract_data.cargo)
			if Thumbnail then
				local imgpnl = vgui.Create("DImage", itm)
				imgpnl:SetSize(90 * zclib.wM,90 * zclib.hM)
				local img = zclib.Snapshoter.Get(Thumbnail, imgpnl)
				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
				imgpnl:Dock(LEFT)
				imgpnl:DockMargin(0,0,0,10 * zclib.hM)
			else
				// Check if some icon was provided so we use that instead
				if CargoConfig.GetIcon then
					local imgpnl = vgui.Create("DPanel", itm)
					imgpnl:SetSize(90 * zclib.wM,90 * zclib.hM)
					imgpnl:Dock(LEFT)
					imgpnl:DockMargin(0,0,0,10 * zclib.hM)
					imgpnl.Paint = function(s, w, h)
						surface.SetDrawColor(color_white)
						surface.SetMaterial(CargoConfig.GetIcon)
						surface.DrawTexturedRect(0,0,w,h)
					end
				end
			end

			local cargo_name = CargoConfig.GetFullName(contract_data.cargo)
			local cargo_amount = CargoConfig.GetAmount(contract_data.cargo)
			local cargo_niceamount = CargoConfig.DisplayAmount(cargo_amount)

			local contract_earnings = zgo2.Contracts.GetEarnings(contract_id,LocalPlayer())

			// Make the player pay first the signing fee
			local SigningFee = (contract_earnings / 100) * zgo2.config.Marketplace.Contracts.SigningFee


			local infopnl = vgui.Create("DPanel", itm)
			infopnl:SetSize(130 * zclib.wM,80 * zclib.hM)
			infopnl.Paint = function(s, w, h)
				draw.SimpleText(cargo_name, zclib.GetFont("zclib_font_medium"), 0 * zclib.wM, 7 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(cargo_niceamount, zclib.GetFont("zclib_font_mediumsmall"), 0 * zclib.wM, 60 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

				draw.SimpleText(zgo2.language[ "Fee" ] .. ": " .. zclib.Money.Display(SigningFee), zclib.GetFont("zclib_font_small"), w - 8 * zclib.wM, h - 20 * zclib.hM, zclib.colors[ "red01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(zclib.Money.Display(contract_earnings), zclib.GetFont("zclib_font_mediumsmall"), w - 8 * zclib.wM, 60 * zclib.hM, zclib.colors[ "green01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			end
			infopnl:Dock(FILL)

			local selectbtn = vgui.Create("DButton", itm)
			selectbtn:SetText("")
			selectbtn.Paint = function(s, w, h)
				if s:IsHovered() and not contract_data.Players[ steamID64 ] then draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a50" ]) end
			end
			selectbtn:SetWide(itm:GetWide())
			selectbtn:SetTall(itm:GetTall())
			selectbtn.DoClick = function(s)

				// Once the player signed the contract he cant cancel it
				if contract_data.Players[ steamID64 ] then return end

				// Change this sound to a signing sound effect
				zclib.vgui.PlaySound("zgo2/sign_contract.wav")

				// Send net message to the SERVER telling him that you are doing this contract
				zgo2.Contracts.Request(contract_id)
			end
		end
	end

	/*
		Gets called when the currently open marketplace got an update on its contracts
	*/
	zclib.Hook.Remove("zgo2.Contracts.OnAdded","zgo2.Contracts.OnAdded.Marketplace")
	zclib.Hook.Add("zgo2.Contracts.OnAdded","zgo2.Contracts.OnAdded.Marketplace", function(market_id,contract_data,contract_id)
		if IsValid(WorldMapWindow) and IsValid(MarketplaceWindow) and MarketplaceID == market_id then
			// Update the marketplace window
			BuildMarketplace(map,MarketplaceID)
		end
	end)

	zclib.Hook.Remove("zgo2.Contracts.OnRemoved","zgo2.Contracts.OnRemoved.Marketplace")
	zclib.Hook.Add("zgo2.Contracts.OnRemoved","zgo2.Contracts.OnRemoved.Marketplace", function(market_id,contract_data,contract_id)
		if IsValid(WorldMapWindow) and IsValid(MarketplaceWindow) and MarketplaceID == market_id then
			// Update the marketplace window
			BuildMarketplace(map,MarketplaceID)
		end
	end)

	local marketimage = vgui.Create( "DPanel" ,pnl)
	marketimage:SetWide(300 * zclib.wM)
	marketimage:Dock(LEFT)
	marketimage:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	marketimage.Paint = function(s, w, h)
		if MarketData.img then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(MarketData.img)
			surface.DrawTexturedRect(0, 0, w, h)
		else
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a50" ])
		end

		draw.RoundedBox(0, 0, h - 48 * zclib.hM, w, 50 * zclib.hM, zclib.colors[ "black_a200" ])

		// Display how much the buy % is currently on this marketplace
		local NiceRate, NiceColor = zgo2.Marketplace.GetNiceRate(id)
		draw.SimpleTextOutlined(NiceRate, zclib.GetFont("zclib_font_big"), w / 2, h-1 * zclib.hM, NiceColor , TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	end

	local marketlist = vgui.Create( "DPanel" ,pnl)
	marketlist:Dock(FILL)
	marketlist:DockMargin(0 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	marketlist.Paint = function(s, w, h) end
	marketlist:InvalidateLayout(true)
	marketlist:InvalidateParent(true)

	if MarketData.Cargo and table.Count(MarketData.Cargo) > 0 then

		local send = zgo2.vgui.Button(marketlist,zgo2.language[ "Export" ],zclib.GetFont("zclib_font_mediumsmall"),zclib.colors[ "orange01" ],function()

			if table.Count(zgo2.Marketplace.Transfers) >= zgo2.Marketplace.GetTransferLimit(LocalPlayer()) then
				zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "transfer_limit" ], 1)
				return
			end

			if table.Count(CargoList) <= 0 then
				zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "no_selection" ], 1)
				return
			end

			if zgo2.config.Marketplace.DisableMules then

				local MuleID = 6666

				// Close the marketplace window
				MarketplaceWindow:Remove()

				// Let the player selected a destination marketplace
				SelectDestination(id,MuleID,function(DestinationID)

					// We cant send the cargo to the start marketplace
					if id == DestinationID then
						zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "invalid_cargo_destination" ], 1)
						return
					end

					// Tell server that we want to ship the selected items
					net.Start("zgo2.Marketplace.SendCargo")
					net.WriteUInt(id,10)
					net.WriteUInt(DestinationID,10)
					net.WriteUInt(table.Count(CargoList),10)
					for k,v in pairs(CargoList) do
						net.WriteUInt(k,10)
						net.WriteUInt(v,32)
					end
					net.WriteUInt(MuleID,32)
					net.SendToServer()

					// Back to the main menu
					zgo2.Marketplace.OpenMap()
				end,function()

					zgo2.Marketplace.OpenMap(id)
				end)

				return
			end

			// Ask the player which mule he wants to use
			SelectMule(pnl,function(MuleID)

				// Close the marketplace window
				MarketplaceWindow:Remove()

				// Let the player selected a destination marketplace
				SelectDestination(id,MuleID,function(DestinationID)

					// We cant send the cargo to the start marketplace
					if id == DestinationID then
						zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "invalid_cargo_destination" ], 1)
						return
					end

					// Tell server that we want to ship the selected items
					net.Start("zgo2.Marketplace.SendCargo")
					net.WriteUInt(id,10)
					net.WriteUInt(DestinationID,10)
					net.WriteUInt(table.Count(CargoList),10)
					for k,v in pairs(CargoList) do
						net.WriteUInt(k,10)
						net.WriteUInt(v,32)
					end
					net.WriteUInt(MuleID,32)
					net.SendToServer()

					// Back to the main menu
					zgo2.Marketplace.OpenMap()
				end,function()

					zgo2.Marketplace.OpenMap(id)
				end)
			end)
		end)
		send:Dock(BOTTOM)
		send:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		send:SetTall(40 * zclib.hM)
		send:SetTooltip(zgo2.language[ "cargo_export_tooltip" ])

		if zgo2.config.Marketplace.Sell.Enabled then
			local sell = zgo2.vgui.Button(marketlist,zgo2.language[ "Sell" ],zclib.GetFont("zclib_font_mediumsmall"),zclib.colors[ "green01" ],function()

				if table.Count(CargoList) <= 0 then
					zclib.PanelNotify.Create(LocalPlayer(), zgo2.language[ "no_selection" ], 1)
					return
				end

				// Tell server that we want to sell the selected items
				net.Start("zgo2.Marketplace.SellCargo")
				net.WriteUInt(id,10)
				net.WriteUInt(table.Count(CargoList),10)
				for k,v in pairs(CargoList) do
					net.WriteUInt(k,10)
					net.WriteUInt(v,32)
				end
				net.SendToServer()

				CargoList = {}
			end)
			sell:Dock(BOTTOM)
			sell:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
			sell:SetTall(40 * zclib.hM)
			sell:SetTooltip(zgo2.language[ "cargo_sell_tooltip" ])
		end
	end

	// Build a list of all the weed that you currently have in this marketplace stored
	local list, scroll = zclib.vgui.List(marketlist)
	list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
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

		if MarketData.Cargo == nil or table.Count(MarketData.Cargo) <= 0 then
			draw.SimpleText(zgo2.language[ "NoCargo" ], zclib.GetFont("zclib_font_big"), w / 2, h / 2, zclib.colors["white_a50"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	// Here we display all the weed the player has in this marketplace
	for cargo_id,cargo_data in pairs(MarketData.Cargo) do

		local itm = list:Add("DPanel")
		itm:SetSize(marketlist:GetWide() - 35 * zclib.wM,80 * zclib.hM)
		itm.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, CargoList[cargo_id] and zclib.colors[ "ui_highlight" ] or zclib.colors[ "ui00" ])
		end
		itm:InvalidateLayout(true)
		itm:InvalidateParent(true)

		local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
		if not CargoConfig then continue end

		local Thumbnail = CargoConfig.GetThumbnailData(cargo_data)
		if Thumbnail then
			local imgpnl = vgui.Create("DImage", itm)
			imgpnl:SetSize(80 * zclib.wM,80 * zclib.hM)
			local img = zclib.Snapshoter.Get(Thumbnail, imgpnl)
			imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			imgpnl:Dock(LEFT)
		else
			// Check if some icon was provided so we use that instead
			if CargoConfig.GetIcon then
				local imgpnl = vgui.Create("DPanel", itm)
				imgpnl:SetSize(80 * zclib.wM,80 * zclib.hM)
				imgpnl:Dock(LEFT)
				imgpnl.Paint = function(s, w, h)
					surface.SetDrawColor(color_white)
					surface.SetMaterial(CargoConfig.GetIcon)
					surface.DrawTexturedRect(0,0,w,h)
				end
			end
		end

		local cargo_name = CargoConfig.GetFullName(cargo_data)
		local cargo_amount = CargoConfig.GetAmount(cargo_data)
		local cargo_niceamount = CargoConfig.DisplayAmount(cargo_amount)
		local cargo_sellvalue = CargoConfig.GetSellValue(cargo_data)


		local infopnl = vgui.Create("DPanel", itm)
		infopnl:SetSize(130 * zclib.wM,80 * zclib.hM)
		infopnl.Paint = function(s, w, h)

			draw.SimpleText(cargo_name, zclib.util.FontSwitch(cargo_name,w / 2,zclib.GetFont("zclib_font_medium"),zclib.GetFont("zclib_font_small")), 0 * zclib.wM, 15 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			if CargoList[cargo_id] then
				draw.SimpleText(cargo_niceamount, zclib.GetFont("zclib_font_small"), 0 * zclib.wM, h - 15 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(">  " .. CargoConfig.DisplayAmount(CargoList[cargo_id]), zclib.GetFont("zclib_font_small"), w - 15 * zclib.wM, 15 * zclib.hM, zclib.colors[ "blue02" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			else
				draw.SimpleText(cargo_niceamount, zclib.GetFont("zclib_font_small"), 0 * zclib.wM, h - 15 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			end

			local BuyRate = (1 / 100) * (MarketData.buy_rate or 100)
			local TotalValue = zclib.Money.Display((cargo_sellvalue * cargo_amount) * BuyRate)

			draw.SimpleText(TotalValue, zclib.GetFont("zclib_font_mediumsmall"),w - 8 * zclib.wM,h - 5 * zclib.hM, zclib.colors[ "green01" ], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		end
		infopnl:Dock(FILL)

		local selectbtn = vgui.Create("DButton", itm)
		selectbtn:SetText("")
		selectbtn.Paint = function(s, w, h)
			if s:IsHovered() then draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "white_a50" ]) end
		end
		selectbtn:SetWide(itm:GetWide())
		selectbtn:SetTall(itm:GetTall())
		selectbtn.DoClick = function(s)
			zclib.vgui.PlaySound("UI/buttonclick.wav")

			if CargoList[cargo_id] then
				CargoList[cargo_id] = nil
			else
				// Open amount slider
				zgo2.vgui.AmountSelector(zgo2.language[ "Select Amount" ],cargo_amount, function(amount)
					CargoList[cargo_id] = math.Round(amount)
				end, nil,cargo_amount)
			end
		end
	end
end

/*
	Opens the Marketplace map
*/
function zgo2.Marketplace.OpenMap(AutoSelectMarketplace,NPC)
	WorldMapWindow = zclib.vgui.Page(zgo2.language[ "Export Manager" ], function(main, top)
		main:SetSize(1600 * zclib.wM, 800 * zclib.hM)

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

		// TODO Add some extra drawing function to display active contracts at the top right corner under the transfer limit

		// Build the world map
		local map = BuildMap(main,function(id,map)

			CargoList = {}

			MarketplaceID = id

			// Open window to show how much weed the player has currently in this marketplace
			BuildMarketplace(map,id)
		end,function(id,s,w,h)
			// OnLocationDraw

			// Draw a crate icon near this location if you got cargo in there
			if zgo2.Marketplace.List[id].Cargo and table.Count(zgo2.Marketplace.List[id].Cargo) > 0 then
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zclib.Materials.Get("zgo2_icon_cargo"))
				surface.DrawTexturedRectRotated(w + 25 * zclib.wM, h - 10 * zclib.hM, 40 * zclib.wM, 40 * zclib.hM, 0)
			end

			// If this marketplace has a contract then show a contract symbol
			local contracts = zgo2.Contracts.GetAll(LocalPlayer(),id)
			if contracts and table.Count(contracts) > 0 then

				local HasSignedOne = false
				local steamID64 = LocalPlayer():SteamID64()
				for k,v in pairs(contracts) do
					if v and v.Players and v.Players[steamID64] then
						HasSignedOne = true
						break
					end
				end

				// If the LocalPlayer accepted one of the contracts then the symbols color will change
				surface.SetDrawColor(HasSignedOne and zclib.colors["yellow01"] or zclib.colors["blue02"])
				surface.SetMaterial(zclib.Materials.Get("contract"))
				surface.DrawTexturedRectRotated(6 * zclib.wM, h + 20 * zclib.hM, 40 * zclib.wM, 40 * zclib.hM, 0)
			end
		end)

		/*
			Gets called when the players marketcargo gets updated
		*/
		zclib.Hook.Remove("zgo2.Marketplace.OnCargoUpdate","zgo2.Marketplace.OnCargoUpdate.Marketplace")
		zclib.Hook.Add("zgo2.Marketplace.OnCargoUpdate","zgo2.Marketplace.OnCargoUpdate.Marketplace", function( id )
			if IsValid(WorldMapWindow) and IsValid(MarketplaceWindow) and id == MarketplaceID then
				// Update the marketplace window
				BuildMarketplace(map,MarketplaceID)
			end
		end)

		/*
			Once the server confirms the transfer we rebuild the window
		*/
		zclib.Hook.Remove("zgo2.Marketplace.OnTransferCreated","zgo2.Marketplace.OnTransferCreated.Marketplace")
		zclib.Hook.Add("zgo2.Marketplace.OnTransferCreated","zgo2.Marketplace.OnTransferCreated.Marketplace", function( TransferID )
			if IsValid(WorldMapWindow) then
				zgo2.Marketplace.OpenMap()
			end
		end)

		if AutoSelectMarketplace then
			timer.Simple(0,function()
				if IsValid(map) then
					BuildMarketplace(map,AutoSelectMarketplace)
				end
			end)
		end
	end)
end
