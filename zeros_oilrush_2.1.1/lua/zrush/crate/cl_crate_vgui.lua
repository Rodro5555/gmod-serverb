if not CLIENT then return end
zrush = zrush or {}
zrush.Machinecrate = zrush.Machinecrate or {}

// This opens the machine ui for a user
net.Receive("zrush_Machinecrate_Buy", function(len)
	zrush.vgui.ActiveEntity = net.ReadEntity()
	if not IsValid(zrush.vgui.ActiveEntity) then return end

	zrush.Machinecrate.Shop()
end)

function zrush.Machinecrate.Shop()
	local SelectedItem = 1
	local InfoContent

	local function UpdateInfoPanel(parent,id)

		local machineData = zrush.Machine.GetData(id)

		if IsValid(InfoContent) then InfoContent:Remove() end
		local main = vgui.Create("DPanel",parent)
		main:Dock(FILL)
		main.Paint = function(s, w, h)
			if machineData == nil then
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
			end
		end
		InfoContent = main

		if machineData == nil then return end

		local bgs
		if machineData.machineID == "Pump" then
			bgs = {
				[0] = 1,
				[1] = 1,
				[2] = 1,
				[3] = 1,
				[4] = 1,
				[5] = 1,
			}
		end

		local purchase = zrush.vgui.Button(main,zrush.language["Purchase"],zclib.colors["green01"],function()
			if IsValid(zrush.vgui.ActiveEntity) and SelectedItem then
				net.Start("zrush_Machinecrate_Buy")
				net.WriteEntity(zrush.vgui.ActiveEntity)
				net.WriteInt(SelectedItem, 16)
				net.SendToServer()
			end

			zrush.vgui.Close()
		end)
		purchase:Dock(BOTTOM)
	    purchase:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local mdl = zclib.vgui.ModelPanel({model = machineData.model, bodygroup = bgs, render = {FOV = 45}})
		mdl:SetSize(400 * zclib.wM, 600 * zclib.hM)
		mdl:SetParent(main)
		mdl:Dock(FILL)
		mdl.Entity:SetAngles(Angle(0, 160, 0))
		mdl.PreDrawModel = function(s, ent)
			local w, h = s:GetWide(), s:GetTall()
			cam.Start2D()
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
			cam.End2D()
		end

		local name = zrush.Machine.GetName(id)
		local money = zclib.Money.Display(machineData.price)

		mdl.PostDrawModel = function(s)
			local w, h = s:GetWide(), s:GetTall()
			cam.Start2D()
				surface.SetDrawColor(zclib.colors["black_a200"])
				surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
				surface.DrawTexturedRectRotated(w / 2, 25 * zclib.hM, w, 50 * zclib.hM, 180)

				draw.SimpleText(money, zclib.GetFont("zclib_font_medium"), w - 10 * zclib.wM, h - 25 * zclib.hM, zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

				draw.SimpleText(name, zclib.GetFont("zclib_font_big"), 10 * zclib.wM, 25 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			cam.End2D()
		end

		if machineData.machineID == "Pump" then
			mdl.Entity:SetPos(Vector(-150,0,0))
		end
	end

	zrush.vgui.Page(zrush.language["MachineShop"], function(main, top)
		main:SetSize(800 * zclib.wM, 600 * zclib.hM)

		local close_btn = zclib.vgui.ImageButton(940 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 50 * zclib.hM, top, zclib.Materials.Get("close"), function()
			zrush.vgui.Close()
		end, false)
		close_btn:Dock(RIGHT)
		close_btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		close_btn.IconColor = zclib.colors["red01"]

		local seperator = zrush.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local InfoPanel = vgui.Create("DPanel", main)
		InfoPanel:SetSize(400 * zclib.wM, 600 * zclib.hM)
		InfoPanel:Dock(RIGHT)
		InfoPanel:DockMargin(10 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		InfoPanel.Paint = function(s, w, h) end

		local list, scroll = zrush.vgui.List(main)
		scroll:DockMargin(50 * zclib.wM, 5 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
		scroll.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
		end

		for k, v in pairs(zrush.Machines) do
			local money = zclib.Money.Display(v.price)
			local name = zrush.Machine.GetName(k)
			local btn = vgui.Create("DButton")
			btn:SetSize(270 * zclib.wM, 50 * zclib.hM)
			btn:SetText("")

			btn.Paint = function(s, w, h)
				draw.RoundedBox(1, 0, 0, w, h, zclib.colors["ui00"])
				draw.SimpleText(money, zclib.GetFont("zclib_font_small"), w - 10 * zclib.wM, h / 2, zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

				draw.SimpleText(name, zclib.GetFont("zclib_font_mediumsmall"), 10 * zclib.wM, h / 2, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				if SelectedItem == k then
					zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["green01"])
				end

				if s:IsHovered() then
					draw.RoundedBox(1, 0, 0, w, h, zclib.colors["white_a15"])
				end
			end

			btn.DoClick = function(s)
				zclib.vgui.PlaySound("UI/buttonclick.wav")
				SelectedItem = k

				UpdateInfoPanel(InfoPanel, k)
			end

			list:Add(btn)
		end

		UpdateInfoPanel(InfoPanel,SelectedItem)
	end)
end


local MachineCrateModules = {}
net.Receive("zrush_Machinecrate_Options", function(len)

	zrush.vgui.ActiveEntity = net.ReadEntity()
	MachineCrateModules = net.ReadTable()
	if not IsValid(zrush.vgui.ActiveEntity) then return end

	zrush.Machinecrate.Options()
end)

function zrush.Machinecrate.Options()

	zrush.vgui.Page(zrush.Machine.GetName(zrush.vgui.ActiveEntity:GetMachineID()), function(main, top)
		main:SetSize(500 * zclib.wM, 380 * zclib.hM)

		local close_btn = zclib.vgui.ImageButton(940 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 50 * zclib.hM, top, zclib.Materials.Get("close"), function()
			zrush.vgui.Close()
		end, false)
		close_btn:Dock(RIGHT)
		close_btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		close_btn.IconColor = zclib.colors["red01"]

		local seperator = zrush.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local place = zrush.vgui.Button(main,zrush.language["Place"],zclib.colors["green01"],function()

			if IsValid(zrush.vgui.ActiveEntity) then
				zrush.Machinecrate.Place(zrush.vgui.ActiveEntity)
			end

			zrush.vgui.Close()
		end)

		local sell = zrush.vgui.Button(main,zrush.language["Sell"],zclib.colors["red01"],function()

			if IsValid(zrush.vgui.ActiveEntity) then
				net.Start("zrush_MachineCrate_Sell")
				net.WriteEntity(zrush.vgui.ActiveEntity)
				net.SendToServer()
			end

			zrush.vgui.Close()
		end)

		local machineWorth = zrush.Machinecrate.GetValue(zrush.vgui.ActiveEntity, MachineCrateModules)
		sell.Text = zrush.language["Sell"] .. " (" .. zclib.Money.Display(machineWorth) .. ")"

		if zclib.Player.IsOwner(LocalPlayer(), zrush.vgui.ActiveEntity) == false then
			if zrush.config.Machine["MachineCrate"].AllowSell == true then
				place.IsLocked = true
			else
				sell.IsLocked = true
				place.IsLocked = true
			end
		end

		if MachineCrateModules == nil or table.Count(MachineCrateModules) <= 0 then return end

		local list, scroll = zrush.vgui.List(main)
		scroll:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		scroll:SetTall(70 * zclib.hM)
		scroll.Paint = function(s, w, h)
			//draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui00"])
		end

		for i = 1,4 do
			local itm = list:Add("DPanel")
		    itm:SetSize(87 * zclib.wM, 87 * zclib.hM)
		    itm.Paint = function(s, w, h)
		        //draw.RoundedBox(w, 0, 0, w, h, zclib.colors["ui01"])
				zrush.Modules.DrawDetailed(MachineCrateModules[i],w,h)
		    end
		end
	end)
end
