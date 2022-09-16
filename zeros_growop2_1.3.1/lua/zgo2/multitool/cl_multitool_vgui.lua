zgo2 = zgo2 or {}
zgo2.Multitool = zgo2.Multitool or {}

zclib.BMASKS.CreateMask("zgo2_hexagon_mask", "materials/zerochain/zgo2/hexagon_mask.png", "smooth")

local SelectionWindow
local WindowSize = 600

function zgo2.Multitool.OpenMenu(CurrentKey,current_path)

	if IsValid(SelectionWindow) then SelectionWindow:Remove() end

	WindowSize = ScrH() * 0.75

	local Size = WindowSize * 0.2

	SelectionWindow = vgui.Create("Panel")
	SelectionWindow:SetSize(WindowSize,WindowSize)
	SelectionWindow:MakePopup()
	SelectionWindow:Center()
	SelectionWindow:NoClipping(true)
	SelectionWindow.CreationTime = CurTime()
	SelectionWindow.Paint = function(s, w, h)
		zclib.util.DrawBlur(s, 0.1,10)

		if s:IsVisible() and (input.IsMouseDown(MOUSE_RIGHT) or input.IsKeyDown(KEY_ESCAPE)) and s.CreationTime and CurTime() > (s.CreationTime + 0.5) then
			s:Remove()
		end
	end

	local InfoPanel

	// Lets remove any data that the player is not allowed to buy
	local cPath = current_path.items or current_path

	local clean = table.Copy(cPath)
	cPath = {}
	for k,v in pairs(clean) do
		if CurrentKey and not zgo2.Shop.CanBuy(LocalPlayer(),CurrentKey,k) then continue end
		cPath[k] = v
	end

	if not CurrentKey then
		local test = table.Copy(cPath)
		cPath = {}
		for cat_name,data in pairs(test) do

			if data.func then
				cPath[cat_name] = data
				continue
			end

			if not data.items then continue end
			local dat = table.Copy(data.items)
			data.items = {}
			for k,v in pairs(dat) do
				if not zgo2.Shop.CanBuy(LocalPlayer(),cat_name,k) then continue end
				data.items[k] = v
			end
			if data.items and table.Count(data.items) <= 0 then continue end
			cPath[cat_name] = data
		end
	end

	local itmCount = math.Clamp(table.Count(cPath),3,50)
	if itmCount > 12 then Size = WindowSize * 0.15 end

	local function AddButton(btn_id,ListID,ListData,OnClick)

		local rad = math.rad((360 / itmCount) * btn_id)

		local half = Size / 2
		local winHalf = WindowSize / 2
		local x = winHalf + (math.cos(rad) * (winHalf - half)) - half
		local y = winHalf + (math.sin(rad) * (winHalf - half)) - half

		local btn

		local CanBuy = zgo2.Shop.CanBuy(LocalPlayer(),CurrentKey,ListID)

		local StartX,StartY = (SelectionWindow:GetWide() / 2) - Size/2 , (SelectionWindow:GetTall() / 2) - Size/2

		local main = vgui.Create("DPanel", SelectionWindow)
		main:SetSize(Size,Size)
		main:SetAutoDelete(true)
		main:NoClipping(true)
		main:SetPos(StartX,StartY)
		main:MoveTo(x,y,0.3,0,0.5,function() end)

		main:SetAlpha(0)
		main:AlphaTo(255,0.5,0,function() end)

		main:SetAutoDelete(true)
		main.Paint = function(s, w, h)

			local aSize = btn:IsHovered() and Size * 1.25 or Size
			s.SmoothSize = Lerp(FrameTime() * 15,s.SmoothSize or aSize,aSize)

			if btn:IsHovered() then
				if not s.PlayedSound then
					s.PlayedSound = true
					surface.PlaySound("UI/buttonrollover.wav")
				end
			else
				s.PlayedSound = nil
			end

			surface.SetDrawColor((CanBuy and btn:IsHovered()) and zclib.colors["ui03"] or zclib.colors["ui02"])
			surface.SetMaterial(zclib.Materials.Get("zgo2_hexagon"))
			surface.DrawTexturedRectRotated(w / 2, h / 2, w,h, 0)

			main:SetSize(s.SmoothSize, s.SmoothSize)

			local half = s.SmoothSize / 2
			local winHalf = WindowSize / 2
			local x = winHalf + (math.cos(rad) * (winHalf - half)) - half
			local y = winHalf + (math.sin(rad) * (winHalf - half)) - half

			main:SetPos(x,y)
		end

		local name = ListID
		if ListData then

			if ListData.class == "zgo2_seed" then
				name = nil
				local PlantData = zgo2.Plant.GetData(ListData.id)
				local imgpnl = vgui.Create("DImage", main)
				imgpnl:Dock(FILL)
				imgpnl:DockMargin(30 * zclib.wM, 30 * zclib.hM, 30 * zclib.wM, 30 * zclib.hM)
				local img = zclib.Snapshoter.Get({
					class = "zgo2_plant",
					model = "models/zerochain/props_growop2/zgo2_plant_root.mdl",
					PlantID = PlantData.uniqueid,
				}, imgpnl)

				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			elseif ListData.class == "zgo2_pot" then
				name = nil
				local PotData = zgo2.Pot.GetData(ListData.id)
				local imgpnl = vgui.Create("DImage", main)

				local img = zclib.Snapshoter.Get({
					class = "zgo2_pot",
					model = zgo2.Pot.GetModel(ListData.id),
					PotID = PotData.uniqueid,
				}, imgpnl)

				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
				imgpnl:Dock(FILL)
				imgpnl:DockMargin(30 * zclib.wM, 30 * zclib.hM, 30 * zclib.wM, 30 * zclib.hM)
			elseif ListData.mdl then
				name = nil
				local imgpnl = vgui.Create("DImage", main)
				imgpnl:Dock(FILL)
				imgpnl:DockMargin(30 * zclib.wM, 30 * zclib.hM, 30 * zclib.wM, 30 * zclib.hM)
				local img = zclib.Snapshoter.Get({
					class = ListData.class,
					model = ListData.mdl,
				}, imgpnl)

				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			end
		end

		btn = vgui.Create("DButton", main)
		btn:Dock(FILL)
		btn:SetAutoDelete(true)
		btn:SetFont(zclib.GetFont("zclib_font_medium"))
		btn:SetText("")
		btn.Paint = function(s, w, h)
			zclib.BMASKS.BeginMask("zgo2_hexagon_mask")

				if ListData and ListData.icon then

					if ListData.icon == "back" or ListData.icon == "close" then
						surface.SetDrawColor(zclib.colors["red01"])
						surface.SetMaterial(zclib.Materials.Get(ListData.icon))
						surface.DrawTexturedRect(w * 0.1, h * 0.1, w * 0.8, h * 0.8)
					elseif ListData.icon == "money" then
						surface.SetDrawColor(zclib.colors["green01"])
						surface.SetMaterial(zclib.Materials.Get(ListData.icon))
						surface.DrawTexturedRect(w * 0.1, h * 0.1, w * 0.8, h * 0.8)
					else
						surface.SetDrawColor((s:IsHovered() and s:IsEnabled()) and color_white or zclib.colors[ "white_a100" ])
						surface.SetMaterial(zclib.Materials.Get(ListData.icon))
						surface.DrawTexturedRect(w * 0.1, h * 0.1, w * 0.8, h * 0.8)
					end

					if s:IsHovered() and s:IsEnabled() then
						surface.SetDrawColor(zclib.colors[ "white_a15" ])
						surface.SetMaterial(zclib.Materials.Get(ListData.icon))
						surface.DrawTexturedRect(w * 0.1, h * 0.1, w * 0.8, h * 0.8)
					else
						surface.SetDrawColor(zclib.colors[ "black_a150" ])
						surface.SetMaterial(zclib.Materials.Get(ListData.icon))
						surface.DrawTexturedRect(w * 0.1, h * 0.1, w * 0.8, h * 0.8)
					end
				else
					if name then
						draw.SimpleText(name, zclib.GetFont("zclib_font_medium"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end

				if ListData.price and not CanBuy then
					local size = w * 0.7
					surface.SetDrawColor(color_white)
					surface.SetMaterial(zclib.Materials.Get("icon_locked"))
					surface.DrawTexturedRectRotated(w / 2, h / 2, size, size, 0)
				end

				if ListData and ListData.price and s:IsHovered() then
					draw.RoundedBox(0, 0, (h / 2) - 18 * zclib.hM, w, 40 * zclib.hM, zclib.colors[ "black_a150" ])
					draw.SimpleText("> " .. zgo2.language[ "Purchase" ] .. " <", itmCount > 12 and zclib.GetFont("zclib_font_small") or zclib.GetFont("zclib_font_medium"), w / 2, h / 2, zclib.colors[ "green01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

			zclib.BMASKS.EndMask("zgo2_hexagon_mask", 0, 0, w, h)
		end
		if ListData.icon == "back" then
			btn:SetTooltip(zgo2.language[ "Back" ])
		elseif ListData.icon == "close" then
			btn:SetTooltip(zgo2.language[ "Close" ])
		elseif ListData.icon == "money" then
			btn:SetTooltip(zgo2.language[ "Sell" ])
		end
		btn.DoClick = function(s)
			zclib.vgui.PlaySound("UI/buttonclick.wav")
			if ListData.price and not CanBuy then return end
			pcall(OnClick, s)
		end

		btn.ListData = ListData
		btn.ListID = ListID
	end

	local id = 1

	if CurrentKey then
		cPath[99] = {
			icon = "back",
			func = function()
				zgo2.Multitool.OpenMenu(nil,zgo2.Shop.List)
			end
		}
	else
		cPath[99] = {
			icon = "close",
			func = function()
				SelectionWindow:Remove()
			end
		}
	end

	itmCount = math.Clamp(table.Count(cPath),3,50)

	local LastHoverPanel
	local function SelectItem(ItemData)
		if IsValid(InfoPanel) then InfoPanel:Remove() end

		local ValidItem = ItemData and ItemData.price

		InfoPanel = vgui.Create("DPanel", SelectionWindow)
		InfoPanel:SetSize(400 * zclib.wM, 400 * zclib.hM)
		InfoPanel:Center()

		InfoPanel.Paint = function(s, w, h)
			surface.SetDrawColor(ValidItem and zclib.colors["ui03"] or zclib.colors["ui02"])
			surface.SetMaterial(zclib.Materials.Get("zgo2_hexagon"))
			surface.DrawTexturedRect(0, 0, w, h)

			surface.SetDrawColor(zclib.colors["black_a50"])
			surface.SetMaterial(zclib.Materials.Get("zgo2_icon_weed"))
			surface.DrawTexturedRect(0, 0, w, h)
		end
		InfoPanel.IsPreviewPanel = true

		InfoPanel.Think = function(s)
			local pnl = vgui.GetHoveredPanel()

			if pnl == s then return end

			if pnl ~= LastHoverPanel then
				LastHoverPanel = pnl

				if IsValid(pnl) and pnl.ListData and pnl.ListData.mdl then
					SelectItem(pnl.ListData)
				else

					SelectItem()
				end
			end
		end

		if not ValidItem then return end

		local TitleFont = zclib.util.FontSwitch(ItemData.name,350 * zclib.wM,zclib.GetFont("zclib_font_medium"),zclib.GetFont("zclib_font_mediumsmoll_thin"))

		local function DrawCustomText(txt,y,color,w)
			draw.SimpleText(txt, zclib.util.FontSwitch(txt,350 * zclib.wM,zclib.GetFont("zclib_font_small"),zclib.GetFont("zclib_font_tiny")), w / 2, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		InfoPanel.PaintOver = function(s, w, h)

			zclib.BMASKS.BeginMask("zgo2_hexagon_mask")
			draw.RoundedBox(0, 0, h / 1.5, w, h, zclib.colors[ "black_a150" ])

			if ItemData.price then
				draw.SimpleText(zclib.Money.Display(ItemData.price), zclib.GetFont("zclib_font_big"), w / 2, h - 50 * zclib.hM, zclib.colors[ "green01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end

			if ItemData.name then
				draw.SimpleText(ItemData.name, TitleFont, w / 2, h - 130 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end

			if ItemData.class == "zgo2_seed" then
				local PlantData = zgo2.Plant.GetData(ItemData.id)
				if PlantData.grow.pref_lightcolor_req then
					draw.RoundedBox(0, 0, 50 * zclib.hM, w, 75 * zclib.hM, zclib.colors[ "black_a200" ])
					// 229407176
					DrawCustomText(zgo2.language[ "Light Color" ], 100 * zclib.hM, PlantData.grow.pref_lightcolor_color,w)
				else
					draw.RoundedBox(0, 0, 50 * zclib.hM, w, 55 * zclib.hM, zclib.colors[ "black_a200" ])
				end

				DrawCustomText(zgo2.language[ "Grow Time" ] .. ": " .. PlantData.grow.time .. "s", 60 * zclib.hM, color_white,w)
				DrawCustomText(zgo2.language[ "Harvest Amount" ] .. ": " .. PlantData.weed.amount .. zgo2.config.UoM, 80 * zclib.hM, color_white,w)
			end

			if ItemData.class == "zgo2_pot" then
				draw.RoundedBox(0, 0, 50 * zclib.hM, w, 57 * zclib.hM, zclib.colors[ "black_a200" ])
				DrawCustomText(zgo2.language[ "Speed Boost" ] .. ": " .. zgo2.Pot.GetNiceTimeBoost(ItemData.id), 60 * zclib.hM, color_white,w)
				DrawCustomText(zgo2.language[ "Harvest Boost" ] .. ": " .. zgo2.Pot.GetNiceAmountBoost(ItemData.id), 80 * zclib.hM, color_white,w)
			end

			if ItemData.class == "zgo2_watertank" then
				local dat = zgo2.Watertank.GetData(ItemData.id)
				draw.RoundedBox(0, 0, 50 * zclib.hM, w, 57 * zclib.hM, zclib.colors[ "black_a200" ])

				DrawCustomText(zgo2.language[ "Capacity" ] .. ": " .. dat.Capacity, 60 * zclib.hM, color_white,w)
				DrawCustomText(zgo2.language[ "RefillRate" ] .. ": " .. dat.RefillRate, 80 * zclib.hM, color_white,w)
			end

			if ItemData.class == "zgo2_generator" then
				local dat = zgo2.Generator.GetData(ItemData.id)
				draw.RoundedBox(0, 0, 50 * zclib.hM, w, 57 * zclib.hM, zclib.colors[ "black_a200" ])

				DrawCustomText(zgo2.language[ "Fuel Capacity" ] .. ": " .. dat.Capacity, 60 * zclib.hM, color_white,w)
				DrawCustomText(zgo2.language[ "PowerRate" ] .. ": " .. dat.PowerRate, 80 * zclib.hM, color_white,w)
			end

			zclib.BMASKS.EndMask("zgo2_hexagon_mask", 0, 0, w, h)
		end

		local imgpnl = vgui.Create("DImage", InfoPanel)
		local img
		imgpnl:Dock(FILL)
		imgpnl:DockMargin(60 * zclib.wM, 60 * zclib.hM, 60 * zclib.wM, 60 * zclib.hM)
		if ItemData.class == "zgo2_seed" then
			local PlantData = zgo2.Plant.GetData(ItemData.id)

			img = zclib.Snapshoter.Get({
				class = "zgo2_plant",
				model = "models/zerochain/props_growop2/zgo2_plant_root.mdl",
				PlantID = PlantData.uniqueid,
			}, imgpnl)
		elseif ItemData.class == "zgo2_pot" then
			local PotData = zgo2.Pot.GetData(ItemData.id)

			img = zclib.Snapshoter.Get({
				class = "zgo2_pot",
				model = zgo2.Pot.GetModel(ItemData.id),
				PotID = PotData.uniqueid,
			}, imgpnl)
		elseif ItemData.mdl then
			img = zclib.Snapshoter.Get({
				class = ItemData.class,
				model = ItemData.mdl,
			}, imgpnl)
		end
		imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
	end

	for k,v in pairs(cPath) do
		AddButton(id,k,v,function()
			if v.mdl then

				SelectionWindow:Remove()

				zgo2.Multitool.BuyItem(CurrentKey,k,v,function()

					// Reopen the last page
					zgo2.Multitool.OpenMenu(CurrentKey,current_path)
				end)
				return
			end

			// If it has a function then we call it
			if v.func then
				pcall(v.func)
			else
				// Otherwhise its probably a list
				zgo2.Multitool.OpenMenu(k,cPath[k])
			end
		end)
		id = id + 1
	end

	SelectItem()
end

function zgo2.Multitool.BuyItem(category,itemid,ItemData,OnClose)

	local ply = LocalPlayer()

	local ItemScale = 1
	if ItemData.class == "zgo2_pot" then
		local dat = zgo2.Pot.GetData(ItemData.id)
		ItemScale =  dat.scale or 1
	end

	zclib.PointerSystem.Start(ply, function()
		// OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
		zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Purchase" ] .. " - " .. zclib.Money.Display(ItemData.price or 25)
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()
		// OnLeftClick

		net.Start("zgo2.Shop.Purchase")
		net.WriteString(category)
		net.WriteUInt(itemid,32)
		net.SendToServer()
	end, function()
		// MainLogic
		local IsPlaceTarget = zgo2.Multitool.IsPlaceTarget(ply,ItemData.class,zclib.PointerSystem.Data.Pos,zclib.PointerSystem.Data.HitEntity,category,itemid)

		zclib.PointerSystem.Data.MainColor = IsPlaceTarget and zclib.colors[ "green01" ] or zclib.colors[ "red01" ]

		ply.zgo2_LockSwep = CurTime() + 1

		// Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			local ent = zclib.PointerSystem.Data.HitEntity

			if zgo2.Multitool.IsHitTarget(ent) and IsPlaceTarget then
				zclib.PointerSystem.Data.PreviewModel:SetModel(ent:GetModel())
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
				zclib.PointerSystem.Data.PreviewModel:SetPos(ent:GetPos())
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ent:GetAngles())
				zclib.PointerSystem.Data.PreviewModel:SetModelScale(ent:GetModelScale() or 1)
			else
				zclib.PointerSystem.Data.PreviewModel:SetModel(ItemData.mdl)
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)

				local ang,pos
				if ItemData.class == "zgo2_dryline" then
					ang = zclib.PointerSystem.Data.Ang
					pos = zclib.PointerSystem.Data.Pos
				else
					ang = (ply:GetPos() - zclib.PointerSystem.Data.Pos):Angle()
					ang = Angle(0, 180 + ang.y + zgo2.Multitool.GetOffset(zclib.PointerSystem.Data.PreviewModel:GetModel()), 0)
					pos = zclib.PointerSystem.Data.Pos //+ ang:Up() * 25
				end

				local min,max = zclib.PointerSystem.Data.PreviewModel:GetCollisionBounds()
				local height = math.abs(min.z) + math.abs(max.z)

				zclib.PointerSystem.Data.PreviewModel:SetPos(pos + Vector(0,0,height - math.abs(max.z)))
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ang)
				zclib.PointerSystem.Data.PreviewModel:SetModelScale(ItemScale)
			end
		end
	end, nil, function()
		// Reopen last window
		pcall(OnClose)
	end,nil,function()
		// OnClose
	end)
end

function zgo2.Multitool.SellItem()

	if IsValid(SelectionWindow) then SelectionWindow:Remove() end

	local ply = LocalPlayer()

	local function GetNearestEnt()
		local ent
		for k,v in ipairs(ents.FindInSphere(zclib.PointerSystem.Data.Pos,5)) do
			if IsValid(v) and v.zgo2_shop_price then
				ent = v
				break
			end
		end
		return ent
	end

	zclib.PointerSystem.Start(ply, function()
		// OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
		zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Sell" ] .. " - " .. zclib.Money.Display(0)
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()
		// OnLeftClick
		local ent = GetNearestEnt()
		if not IsValid(ent) then return end

		net.Start("zgo2.Shop.Sell")
		net.WriteEntity(ent)
		net.SendToServer()
	end, function()

		// Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			local ent = GetNearestEnt()

			local IsSellTarget = IsValid(ent) and zgo2.Shop.IsItem[ent:GetClass()]
			zclib.PointerSystem.Data.MainColor = IsSellTarget and zclib.colors[ "green01" ] or zclib.colors[ "red01" ]

			if IsSellTarget then

				if ent.zgo2_shop_price then
					zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Sell" ] .. " - " .. zclib.Money.Display(zgo2.Shop.GetItemRefund(ent.zgo2_shop_price))
				else
					zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Sell" ] .. " - " .. zclib.Money.Display(0)
				end

				zclib.PointerSystem.Data.PreviewModel:SetModel(ent:GetModel())
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
				zclib.PointerSystem.Data.PreviewModel:SetPos(ent:GetPos())
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ent:GetAngles())
				zclib.PointerSystem.Data.PreviewModel:SetModelScale(ent:GetModelScale() or 1)
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
			else
				zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Sell" ] .. " - " .. zclib.Money.Display(0)
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
			end
		end
	end, nil, function()
		// Reopen last window
		zgo2.Multitool.OpenMenu(nil,zgo2.Shop.List)
	end)
end
