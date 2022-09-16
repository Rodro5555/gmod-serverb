if not CLIENT then return end

zrush = zrush or {}
zrush.Barrel = zrush.Barrel or {}

net.Receive("zrush_Barrel_OpenUI", function(len)
	zrush.vgui.ActiveEntity = net.ReadEntity()
	if not IsValid(zrush.vgui.ActiveEntity) then return end

	zrush.Barrel.Open()
end)

function zrush.Barrel.Open()

	local barrel = zrush.vgui.ActiveEntity
	local fuelID = barrel:GetFuelTypeID()
	local fuelData = zrush.Fuel.GetData(fuelID)
	if fuelData == nil then return end

	local fuel_color = zrush.Fuel.GetColor(fuelID)
	local fuel_color_trans = zrush.Fuel.GetTransColor(fuelID)

	zrush.vgui.Page(zrush.Fuel.GetName(fuelID), function(main, top)
		main:SetSize(400 * zclib.wM, 400 * zclib.hM)

		top.Title_color = fuel_color
		top.Title_font = zclib.GetFont("zclib_font_medium")

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

		local fuel_amount =  math.Round(barrel:GetFuel())
		local fuel_text = fuel_amount .. zrush.config.UoM
		local fuel_fract = 1 - (1 / zrush.config.Barrel.Storage) * fuel_amount
		local barrel_color = Color(75, 80, 91)

		local barrel_bg = vgui.Create("DPanel", main)
		barrel_bg:SetSize(300 * zclib.wM, 400 * zclib.hM)
		barrel_bg:Dock(TOP)
		barrel_bg:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		barrel_bg.Paint = function(s, w, h)

			surface.SetDrawColor(fuel_color_trans)
			surface.SetMaterial(zrush.default_materials["barrel_icon"])
			surface.DrawTexturedRect(0, 0, w, h)


			surface.SetDrawColor(barrel_color)
			surface.SetMaterial(zrush.default_materials["barrel_icon"])
			surface.DrawTexturedRectUV(0, 0, w, h * fuel_fract, 0, 0, 1, fuel_fract)

			draw.SimpleText(fuel_text, zclib.GetFont("zclib_font_big"), w / 2, 80 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local PickUpButton = zrush.vgui.Button(barrel_bg,zrush.language["Collect"],zclib.colors["text01"],function()
			if IsValid(zrush.vgui.ActiveEntity) then
				net.Start("zrush_Barrel_CollectFuel")
				net.WriteEntity(zrush.vgui.ActiveEntity)
				net.SendToServer()
			end

			zrush.vgui.Close()
		end)
		PickUpButton:Dock(TOP)
		PickUpButton:DockMargin(100 * zclib.wM, 180 * zclib.hM, 100 * zclib.wM, 0 * zclib.hM)

		if VC or SVMOD then
			local vcmodfuel = "Diesel"
			if fuelData.vcmodfuel == 0 then
				vcmodfuel = "Petrol"
			end
			local str = zrush.language["SpawnVCModFuelCan"]
			str = string.Replace(str, "$fueltype", vcmodfuel)

			local SplitButton = zrush.vgui.Button(barrel_bg,str,zclib.colors["text01"],function()

				if IsValid(zrush.vgui.ActiveEntity) then
					net.Start("zrush_Barrel_SplittFuel")
					net.WriteEntity(zrush.vgui.ActiveEntity)
					net.SendToServer()
				end

				zrush.vgui.Close()
			end)
			SplitButton:Dock(TOP)
			SplitButton:DockMargin(100 * zclib.wM, 55 * zclib.hM, 100 * zclib.wM, 0 * zclib.hM)
			SplitButton.Text_font = zclib.GetFont("zclib_font_small")

			local Info = vgui.Create("DLabel", barrel_bg)
			Info:SetPos(50 * zclib.wM, 325 * zclib.hM)
			Info:SetSize(225 * zclib.wM, 70 * zclib.hM)
			Info:SetFont(zclib.GetFont("zrush_vgui_font04"))
			Info:SetText(zrush.language["BarrelMenuInfo"])
			Info:SetColor(color_white)
			Info:SetContentAlignment(7)
			Info:SetWrap(true)
			Info:Dock(TOP)
			Info:DockMargin(100 * zclib.wM, 5 * zclib.hM, 100 * zclib.wM, 0 * zclib.hM)
		end
	end)
end
