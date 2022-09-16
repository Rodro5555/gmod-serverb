if not CLIENT then return end
zrush = zrush or {}
zrush.FuelBuyer = zrush.FuelBuyer or {}

local offsetX, offsetY = -140, 125

// Lets sort the fuel table only once so we dont need do redo it all the time in update
local FuelTableSorted = {}
table.CopyFromTo(zrush.FuelTypes, FuelTableSorted)
table.sort(FuelTableSorted, function(a, b) return a.price > b.price end)

function zrush.FuelBuyer.Initialize(FuelBuyer)

end

function zrush.FuelBuyer.Draw(FuelBuyer)
	if zclib.Convar.Get("zclib_cl_drawui") == 1 and zclib.util.InDistance(LocalPlayer():GetPos(), FuelBuyer:GetPos(), 500) then
		zrush.FuelBuyer.DrawInfo(FuelBuyer)
	end
end

function zrush.FuelBuyer.DrawInfo(FuelBuyer)
	cam.Start3D2D(FuelBuyer:LocalToWorld(Vector(0,0,85 + 1 * math.abs(math.sin(CurTime()) * 1))), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)

		// Title
		draw.SimpleTextOutlined(zrush.language["FuelBuyer"], zclib.GetFont("zrush_npc_font01"), 0, -10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, zrush.default_colors["black03"])

		// Profit
		draw.RoundedBox(25, -200, 50, 400, 50, zrush.default_colors["black02"])
		local progress = (1 / zrush.config.FuelBuyer.MaxBuyRate) * FuelBuyer:GetPrice_Mul()
		local pColor = zclib.util.LerpColor(progress, zrush.default_colors["red04"], zrush.default_colors["green04"])

		local sellProfit = FuelBuyer:GetPrice_Mul() - 100
		if sellProfit > 0 then sellProfit = "+ " .. sellProfit end
		draw.DrawText(zrush.language["Profit"], zclib.GetFont("zrush_npc_font02"), -175, 62, color_white, TEXT_ALIGN_LEFT)
		draw.DrawText(sellProfit .. "%", zclib.GetFont("zrush_npc_font02"), 190, 62, pColor, TEXT_ALIGN_RIGHT)

		// Fuel Info
		draw.RoundedBox(25, -200, 110, 120, 45 + (30 * table.Count(zrush.FuelTypes)), zrush.default_colors["black02"])
		draw.DrawText(zclib.config.Currency .. " / " .. zrush.config.UoM, zclib.GetFont("zrush_npc_font02"), -140, 120, color_white, TEXT_ALIGN_CENTER)

		if FuelTableSorted then
			for k, v in pairs(FuelTableSorted) do
				zrush.FuelBuyer.DrawResourceItem(FuelBuyer,v, -50, 30 * k, 20)
			end
		end

	cam.End3D2D()
end

function zrush.FuelBuyer.DrawResourceItem(FuelBuyer, fuelData, xpos, ypos, size)
	local price = math.Round(fuelData.price * (FuelBuyer:GetPrice_Mul() / 100))
	surface.SetDrawColor(fuelData.color)
	surface.SetMaterial(zrush.default_materials["barrel_icon"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)
	draw.DrawText(zclib.Money.Display(price), zclib.GetFont("zrush_npc_font03"), xpos + offsetX + 25, ypos + offsetY + size * 0.1, color_white, TEXT_ALIGN_LEFT)
end
