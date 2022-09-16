if not CLIENT then return end

zpiz = zpiz or {}
zpiz.Fridge = zpiz.Fridge or {}

local Fridge
net.Receive("zpiz_fridge_open", function(len)
	Fridge = net.ReadEntity()
	zpiz.Fridge.Open()
end)

function zpiz.Fridge.Open()
	zpiz.vgui.Page(zpiz.language.VGUI_ShopTitle, function(main, top)
		main:SetSize(800 * zclib.wM, 900 * zclib.hM)
		main.BgColor = zpiz.colors["blue01"]

		local close_btn = zclib.vgui.ImageButton(240 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 50 * zclib.hM, top, zclib.Materials.Get("close"), function()
			if IsValid(zpiz_main_panel) then
				zpiz_main_panel:Remove()
			end
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

		for i,v in ipairs(zpiz.config.Ingredients) do

			local itm = list:Add("DButton")
			itm:SetSize(665 * zclib.wM, 100 * zclib.hM)
			itm:SetText("")
			itm.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])

				surface.SetDrawColor(color_white)
				surface.SetMaterial(v.icon)
				surface.DrawTexturedRect(h * 0.1, h * 0.1, h * 0.8, h * 0.8)

				draw.SimpleText(v.name, zclib.GetFont("zclib_font_medium"), h, 20 * zclib.hM, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
				draw.SimpleText(v.desc, zclib.GetFont("zclib_font_mediumsmall_thin"), h, 50 * zclib.hM, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

				draw.SimpleText(zclib.Money.Display(v.price), zclib.GetFont("zclib_font_big"), w - 25 * zclib.wM, h / 2, zclib.colors["green01"], TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)

				if s:IsHovered() then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
				end
			end
			itm.DoClick = function()
				net.Start("zpiz_fridge_buy")
				net.WriteInt(i, 16)
				net.WriteEntity(Fridge)
				net.SendToServer()

				zclib.Sound.EmitFromPosition(Fridge:GetPos(),"cash")
			end
		end
	end)
end
