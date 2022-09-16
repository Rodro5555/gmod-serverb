if not CLIENT then return end
zvm = zvm or {}
zvm.vgui = zvm.vgui or {}

function zvm.vgui.OptionPage(title, content)
	if IsValid(zvm_vgui_2d_panel) then
		zvm_vgui_2d_panel:Remove()
	end

	local main = vgui.Create("DFrame")
	main:SetSize(600 * zclib.wM, 400 * zclib.hM)
	main:Center()
	main:MakePopup()
	main:SetDraggable(false)
	main:SetIsMenu(false)
	main:SetSizable(false)
	main:SetTitle("")

	main.Paint = function(s, w, h)
		zclib.util.DrawBlur(s, 3, 6)
		draw.RoundedBox(5, 0, 0, w, h, zvm.colors["black03"])
	end

	local TextEntry_Title = vgui.Create("DLabel", main)
	TextEntry_Title:SetPos(25 * zclib.wM, 10 * zclib.hM)
	TextEntry_Title:SetSize(300 * zclib.wM, 40 * zclib.hM)
	TextEntry_Title:SetContentAlignment(7)
	TextEntry_Title:SetFont(zclib.GetFont("zvm_derma_title"))
	TextEntry_Title:SetText(title)
	zvm_vgui_2d_panel = main
	pcall(content, main)
end

function zvm.vgui.Title(parent, txt, font, y)
	local Rank_Title = vgui.Create("DLabel", parent)
	Rank_Title:SetPos(25 * zclib.wM, y * zclib.hM)
	Rank_Title:SetSize(300 * zclib.wM, 40 * zclib.hM)
	Rank_Title:SetContentAlignment(7)
	Rank_Title:SetFont(zclib.GetFont(font))
	Rank_Title:SetText(txt)
end

function zvm.vgui.ColorMixer(parent, default, OnChange)
	local colmix = vgui.Create("DColorMixer", parent)
	colmix:SetPos(25 * zclib.wM, 235 * zclib.hM)
	colmix:SetSize(300 * zclib.wM, 250 * zclib.hM)
	colmix:SetPalette(true)
	colmix:SetAlphaBar(false)
	colmix:SetWangs(true)
	colmix:SetColor(default or color_white)

	colmix.ValueChanged = function(s, col)
		pcall(OnChange, Color(col.r,col.g,col.b,col.a))
	end

	return colmix
end

function zvm.vgui.Button(parent, onclick)
	local btn = vgui.Create("DButton", parent)
	btn:SetPos(25 * zclib.wM, 325 * zclib.hM)
	btn:SetSize(550 * zclib.wM, 50 * zclib.hM)
	btn:SetText("")
	btn.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zvm.colors["green01"])
		draw.SimpleText(zvm.language.General["Apply"], zclib.GetFont("zvm_interface_font01"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if s:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"])
		end
	end
	btn.DoClick = function()
		pcall(onclick)
	end
	return btn
end
