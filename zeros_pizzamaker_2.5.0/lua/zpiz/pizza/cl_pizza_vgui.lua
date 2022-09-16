if not CLIENT then return end

zpiz = zpiz or {}
zpiz.Pizza = zpiz.Pizza or {}

local PizzaDough
net.Receive("zpiz_pizza_open", function(len)
	PizzaDough = net.ReadEntity()
	zpiz.Pizza.Open()
end)

function zpiz.Pizza.Open()
	zpiz.vgui.Page(zpiz.language.VGUI_Recipe, function(main, top)
		main:SetSize(800 * zclib.wM, 900 * zclib.hM)
		main.BgColor = zpiz.colors["orange01"]

		local close_btn = zclib.vgui.ImageButton(240 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 50 * zclib.hM, top, zclib.Materials.Get("close"), function()
			if IsValid(zpiz_main_panel) then zpiz_main_panel:Remove() end
		end, false)
		close_btn:Dock(RIGHT)
		close_btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		close_btn.IconColor = zclib.colors["red01"]
		close_btn.NoneHover_IconColor = zclib.colors["white_a15"]

		local seperator = zpiz.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local list, scroll = zpiz.vgui.List(main)
		scroll.Paint = function(s, w, h) end
		scroll:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)

		for i,v in ipairs(zpiz.config.Pizza) do

			local itm = list:Add("DButton")
			itm:SetSize(665 * zclib.wM, 140 * zclib.hM)
			itm:SetText("")
			itm.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])

				surface.SetDrawColor(204, 112, 55)
				surface.SetMaterial(zpiz.materials["zpiz_circle"])
				surface.DrawTexturedRect(h * 0.05, h * 0.05, h * 0.9, h * 0.9)

				surface.SetDrawColor(color_white)
				surface.SetMaterial(v.icon)
				surface.DrawTexturedRect(h * 0.1, h * 0.1, h * 0.8, h * 0.8)

				surface.SetDrawColor(zclib.colors["black_a100"])
				surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
				surface.DrawTexturedRectRotated(w * 0.61,h * 0.68,w * 0.8,h * 0.40,180)

				local count = 1
				for ing_id,ing_amount in pairs(zpiz.Pizza.GetRecipe(i)) do

					local x,y = (55 * count) * zclib.wM ,  70 * zclib.hM
					x = x + (95 * zclib.wM)

					surface.SetDrawColor(zclib.colors["black_a200"])
					surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
					surface.DrawTexturedRect(x,y,50 * zclib.wM,50 * zclib.hM)

					surface.SetDrawColor(color_white)
					surface.SetMaterial(zpiz.Ingredient.GetIcon(ing_id))
					surface.DrawTexturedRect(x + 5 * zclib.wM,y + 5 * zclib.hM,40 * zclib.wM,40 * zclib.hM)

					draw.SimpleText(ing_amount, zclib.GetFont("zclib_font_small"), x, y + 50 * zclib.hM, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
					count = count + 1
				end

				draw.SimpleText(v.name, zclib.GetFont("zclib_font_medium"), h, 10 * zclib.hM, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				draw.SimpleText(v.desc, zclib.GetFont("zclib_font_mediumsmall_thin"), h, 40 * zclib.hM, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

				draw.SimpleText(zpiz.language.VGUI_RecipeBakeTime .. " " .. v.time .. "s   /   " .. zpiz.language.VGUI_RecipeProfit .. " " .. zclib.Money.Display(v.price), zclib.GetFont("zclib_font_small_thin"), w - 20 * zclib.wM, 63 * zclib.hM, color_white, TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)

				if s:IsHovered() then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
				end
			end
			itm.DoClick = function()
				net.Start("zpiz_pizza_select")
				net.WriteUInt(i, 16)
				net.WriteEntity(PizzaDough)
				net.SendToServer()

				if IsValid(zpiz_main_panel) then zpiz_main_panel:Remove() end
			end
		end
	end)
end
