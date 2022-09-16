local PANEL = {}

XeninUI:CreateFont("CarePackage.Claimed", 40)
XeninUI:CreateFont("CarePackage.Button", 20)

for i = 24, 1, -1 do
	XeninUI:CreateFont("CarePackage.Name." .. i, i)
end

AccessorFunc(PANEL, "m_entity", "Entity")

function PANEL:Init()
	CarePackage.Frame = self

	self:SetTitle("Care Package")
	self.Grids = {}

	if (CarePackage.Config.ItemsPerDrop > 4) then
		self.Scroll = self:Add("XeninUI.Scrollpanel.Wyvern")
		self.Scroll:Dock(FILL)
		self.Scroll:DockMargin(8, 8, 8, 8)

		self.Layout = self.Scroll:Add("DIconLayout")
		self.Layout:Dock(FILL)
		self.Layout:DockMargin(0, 0, 8, 0)
		self.Layout:SetSpaceY(8)
		self.Layout:SetSpaceX(8)
		self.Layout.PerformLayout = function(pnl, w, h)
			local children = pnl:GetChildren()
			local count = 4
			local amount = (math.max(1, math.floor(#children / count))) * 276 -- Idfk where the 276 is from, it was in the code I took from an earlier project
			local width = w / math.min(count, #children)

			local x = 0
			local y = 0

			local spacingX = pnl:GetSpaceX()
			local spacingY = pnl:GetSpaceY()
			local border = pnl:GetBorder()
			local innerWidth = w - border * 2 - spacingX * (count - 1)

			for i, child in ipairs(children) do
				if (!IsValid(child)) then continue end
			
				child:SetPos(border + x * innerWidth / count + spacingX * x, border + y * child:GetTall() + spacingY * y)
				child:SetSize(innerWidth / count, 400 - 16 - 40)

				x = x + 1
				if (x >= count) then
					x = 0
					y = y + 1
				end
			end

			pnl:SizeToChildren(false, true)
		end
	end

	for i = 1, CarePackage.Config.ItemsPerDrop do
		local panel
		if (CarePackage.Config.ItemsPerDrop > 4) then
			panel = self.Layout:Add("XeninUI.Panel")
		else
			panel = self:Add("XeninUI.Panel")
		end
		panel.Background = XeninUI.Theme.Navbar
		panel.Outline = XeninUI.Theme.Purple
		panel.Name = "ITEM NAME"
		panel.Id = i
		panel.Alpha = 0
		panel.Font = ""
		panel.FontID = 24
		panel.GetFont = function(pnl, text, w)
			local id = math.Clamp(pnl.FontID, 1, 24)
			local font = "CarePackage.Name." .. id
			surface.SetFont(font)
			local tw = surface.GetTextSize(text)

			if (tw > w * 0.9) then
				pnl.FontID = pnl.FontID - 1
			end

			return font
		end
		panel.Paint = function(pnl, w, h)
			draw.RoundedBox(6, 0, 0, w, h, pnl.Outline)
			draw.RoundedBox(6, 1, 1, w - 2, h - 2, pnl.Background)
			draw.RoundedBoxEx(6, 0, 0, w, 64, pnl.Outline, true, true, false, false)

			local font = pnl:GetFont(pnl.Name, w)
			for j = 1, 2 do
				draw.SimpleText(pnl.Name, font, w / 2 + j, 64 / 2 + j, Color(0, 0, 0, j * 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			draw.SimpleText(pnl.Name, font, w / 2, 64 / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		panel:AddHook("CarePackage.Menu.Response", i, function(self, success, id, str)
			if (id == self.Id) then
				if (success) then
					if (self.Drop.ClientsideLoot) then
						self.Drop:Loot(self.Ent, LocalPlayer(), self.TypeClicked)
					end
					
					self:MarkClaimed()
				else
					self:Notification(str, XeninUI.Theme.Red)
					self.StartedClaim = nil
					if (IsValid(self.Model.Bottom.Equip)) then
						local equipName = self.Drop.EquipName and (isfunction(self.Drop.EquipName) and self.Drop.EquipName()) or self.Drop.EquipName
						self.Model.Bottom.Equip:SetText(equipName or "Equip")
						self.Model.Bottom.Equip.Loading = nil
					end
					if (IsValid(self.Model.Bottom.Inventory)) then
						self.Model.Bottom.Inventory:SetText("Inventory")
						self.Model.Bottom.Inventory.Loading = nil
					end
				end
			end
		end)
		panel.MarkClaimed = function(pnl)
			pnl.Claimed = true
			pnl:Lerp("Alpha", 1, 0.3)

			pnl.Model.Bottom.Alpha = 255
			pnl.Model.Bottom:Lerp("Alpha", 0, 0.3, function()
				pnl.Model.Bottom:SetVisible(false)
			end)
			pnl.Model.Bottom.Think = function(pnl)
				pnl:SetAlpha(pnl.Alpha)
			end
		end
		panel.DoClick = function(pnl, type)
			if (pnl.StartedClaim) then return end
			local canLoot, err = pnl.Drop:CanLoot(pnl.Ent, LocalPlayer(), type)
			if (!canLoot) then
				pnl:Notification(err, XeninUI.Theme.Red)

				return
			end
			pnl.TypeClicked = type
			pnl.StartedClaim = true

			net.Start("CarePackage.Menu.Loot")
				net.WriteEntity(self:GetEntity())
				net.WriteUInt(pnl.Id, 8)
				net.WriteUInt(type, 1)
			net.SendToServer()
		end
		panel.SetItem = function(pnl, tbl)
			local drop = tbl.Drop
			local ent = tbl.Ent

			pnl.Name = tbl.Drop:GetName(ent)
			pnl.Ent = ent
			pnl.Drop = drop
			pnl.Outline = tbl.Drop:GetColor(ent)
			pnl.ModelStr = tbl.Drop:GetModel(ent)
			pnl.Data = tbl.Drop:GetData(ent)

			pnl:CreateModel(pnl.ModelStr, pnl.Ent, pnl.Data)
			
			if (tbl.Claimed) then
				pnl.Alpha = 1
				pnl.Model.Bottom:SetAlpha(0)
				pnl.StartedClaim = true
				pnl.Claimed = true
			end
		end
		panel.CreateModel = function(pnl, mdl, ent, data)
			data.model = data.model or {}
			data.camera = data.camera or {}

			if (!pnl.Drop.CustomPanel) then
				pnl.Model = pnl:Add("DModelPanel")
				pnl.Model:Dock(FILL)
				pnl.Model:SetZPos(1)
				pnl.Model:DockMargin(1, 65, 1, 1)
				pnl.Model:SetMouseInputEnabled(false)
				pnl.Model:SetModel(mdl)
				pnl.Model.LayoutEntity = function() end
				if (IsValid(pnl.Model.Entity)) then
					local mn, mx = pnl.Model.Entity:GetRenderBounds()
					local size = 0
					size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
					size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
					size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
					pnl.Model:SetFOV(35)
					pnl.Model:SetCamPos(Vector(
						size - 45 + (data.camera.x or 0),
						size + 30 + (data.camera.y or 0),
						size + (data.camera.z or 0)
						)
					)
					pnl.Model:SetLookAt((mn + mx) * 0.5)
					pnl.Model.Entity:SetPos(Vector(0, 0, data.model.yOffset or 0))
				end
				if (data.skin) then
					pnl.Model.Entity:SetSkin(data.skin)
				end
				pnl.Drop:GetPostDisplay(pnl, ent)
			else
				pnl.Drop:CustomPanel(pnl, ent, data)
			end

			pnl.Model.Bottom = pnl:Add("Panel")
			pnl.Model.Bottom:Dock(BOTTOM)
			pnl.Model.Bottom:DockMargin(8, 0, 8, 8)
			pnl.Model.Bottom:SetTall(36)

			if (ent) then
				pnl.Model.Bottom.Equip = pnl.Model.Bottom:Add("DButton")
				local equipName = pnl.Drop.EquipName and (isfunction(pnl.Drop.EquipName) and pnl.Drop.EquipName()) or pnl.Drop.EquipName
				pnl.Model.Bottom.Equip:SetText(equipName or "Equip")
				pnl.Model.Bottom.Equip:SetFont("CarePackage.Button")
				pnl.Model.Bottom.Equip:SetContentAlignment(5)
				pnl.Model.Bottom.Equip.TextColor = Color(185, 185, 185)
				pnl.Model.Bottom.Equip.Background = XeninUI.Theme.Background
				pnl.Model.Bottom.Equip.Paint = function(pnl, w, h)
					pnl:SetTextColor(pnl.TextColor)

					draw.RoundedBox(h / 2, 0, 0, w, h, pnl.Background)

					if (pnl.Loading) then
						local size = h - 8
						local x = w / 2
						local y = h / 2

						XeninUI:DrawLoadingCircle(x, y, size, XeninUI.Theme.Green)
					end
				end
				pnl.Model.Bottom.Equip.OnCursorEntered = function(btn)
					local hasWeapon = !pnl.Drop:CanLoot(pnl.Ent, LocalPlayer(), CAREPACKAGE_STANDARD)
					local col = !hasWeapon and XeninUI.Theme.Primary or XeninUI.Theme.Red

					btn:LerpColor("Background", col)
					btn:LerpColor("TextColor", color_white)
				end
				pnl.Model.Bottom.Equip.OnCursorExited = function(pnl)
					pnl:LerpColor("Background", XeninUI.Theme.Background)
					pnl:LerpColor("TextColor", Color(185, 185, 185))
				end
				pnl.Model.Bottom.Equip.DoClick = function(btn)
					local canLoot, err = pnl.Drop:CanLoot(pnl.Ent, LocalPlayer(), CAREPACKAGE_STANDARD)
					if (!canLoot) then 
						panel:Notification(err, XeninUI.Theme.Red)
					
						return
					end

					btn:SetText("")
					btn.Loading = true
					
					panel:DoClick(CAREPACKAGE_STANDARD)
				end
			end

			if (XeninInventory and pnl.Drop.InventoryEnabled) then
				pnl.Model.Bottom.Inventory = pnl.Model.Bottom:Add("DButton")
				pnl.Model.Bottom.Inventory:SetText("Inventory")
				pnl.Model.Bottom.Inventory:SetFont("CarePackage.Button")
				pnl.Model.Bottom.Inventory:SetContentAlignment(5)
				pnl.Model.Bottom.Inventory.TextColor = Color(185, 185, 185)
				pnl.Model.Bottom.Inventory.Background = XeninUI.Theme.Background
				pnl.Model.Bottom.Inventory.Paint = function(pnl, w, h)
					pnl:SetTextColor(pnl.TextColor)

					draw.RoundedBox(h / 2, 0, 0, w, h, pnl.Background)

					if (pnl.Loading) then
						local size = h - 8
						local x = w / 2
						local y = h / 2

						XeninUI:DrawLoadingCircle(x, y, size, XeninUI.Theme.Green)
					end
				end
				pnl.Model.Bottom.Inventory.OnCursorEntered = function(btn)
					local col = pnl.Drop:CanLoot(pnl.Ent, LocalPlayer(), CAREPACKAGE_INVENTORY) and XeninUI.Theme.Primary or XeninUI.Theme.Red

					btn:LerpColor("Background", col)
					btn:LerpColor("TextColor", color_white)
				end
				pnl.Model.Bottom.Inventory.OnCursorExited = function(pnl)
					pnl:LerpColor("Background", XeninUI.Theme.Background)
					pnl:LerpColor("TextColor", Color(185, 185, 185))
				end
				pnl.Model.Bottom.Inventory.DoClick = function(btn)
					local canLoot, err = pnl.Drop:CanLoot(pnl.Ent, LocalPlayer(), CAREPACKAGE_INVENTORY)
					
					if (!canLoot) then
						panel:Notification(err, XeninUI.Theme.Red)

						return
					end

					btn:SetText("")
					btn.Loading = true

					panel:DoClick(CAREPACKAGE_INVENTORY)
				end
			end

			pnl.Model.Bottom.PerformLayout = function(pnl, w, h)
				if (IsValid(pnl.Inventory)) then
					pnl.Equip:SetTall(h)
					pnl.Equip:SetWide((w - 8) / 2)

					pnl.Inventory:SetTall(h)
					pnl.Inventory:SetWide((w - 8) / 2)
					pnl.Inventory:MoveRightOf(pnl.Equip, 8)
				else
					pnl.Equip:SetTall(h)
					pnl.Equip:SetWide(w)
				end
			end
		end

		panel.Overlay = panel:Add("DPanel")
		panel.Overlay:SetMouseInputEnabled(false)
		panel.Overlay:SetZPos(2)
		panel.Overlay.Paint = function(pnl, w, h)
			pnl = panel
			if (pnl.Claimed) then
				local alpha = pnl.Alpha
				local aX, aY = pnl:LocalToScreen()
				
				local poly = {
					{ x = 0, y = h * 0.9 + 14 },
					{ x = 0, y = h * 0.7 + 14 },
					{ x = w, y = 64 + 24 },
					{ x = w, y = 64 + 94 }
				}
				draw.NoTexture()
				surface.SetDrawColor(ColorAlpha(pnl.Outline, alpha * 255))
				surface.DrawPoly(poly)

				draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 100 * alpha))
			
				local mat = CarePackage.Config.LootedMat
				surface.SetDrawColor(color_white)
				surface.SetMaterial(mat)
				local width = mat:Width()
				local height = mat:Height()
				XeninUI:DrawRotatedTexture(w / 2 + h * 0.015, h / 2 + h * 0.09, width, height, 36)
			end
		end

		panel.PerformLayout = function(pnl, w, h)
			pnl.Overlay:SetSize(w, h)
		end

		table.insert(self.Grids, panel)
	end
end

function PANEL:SetItems(items)
	for i, value in pairs(items) do
		local claimed = value.claimed
		local index = value.id
		local tbl = CarePackage.Config.Drops[index]
		if (!tbl) then continue end
		tbl.Claimed = claimed

		self.Grids[i]:SetItem(tbl)
	end
end

function PANEL:PerformLayout(w, h)
	self.BaseClass.PerformLayout(self, w, h)

	if (IsValid(self.Scroll)) then return end

	local x = 8
	local y = 48
	h = h - y - x
	w = w - 16
	w = w / CarePackage.Config.ItemsPerDrop - 6

	for i, v in pairs(self.Grids) do
		v:SetPos(x, y)
		v:SetSize(w, h)

		x = x + w + 8
	end
end

vgui.Register("CarePackage", PANEL, "XeninUI.Frame")

function CarePackage:Menu(ent, tbl)
	if (IsValid(self.Frame)) then return end

	local width = 8 + 8
	width = width + ((236 + 8) * math.Clamp(CarePackage.Config.ItemsPerDrop, 1, 4))
	local w = math.min(ScrW(), width)
	local h = math.min(ScrH(), 400)

	local frame = vgui.Create("CarePackage")
	frame:SetSize(w, h)
	frame:Center()
	frame:MakePopup()
	frame:SetEntity(ent)
	frame:SetItems(tbl or {})
end

concommand.Add("carepackage", function()
	CarePackage:Menu()
end)