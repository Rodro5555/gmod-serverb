if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Machine.util = zvm.Machine.util or {}

zvm.Machine.util.vscale = 0.08
zvm.Machine.util.sm = (1 / 0.1) * zvm.Machine.util.vscale

function zvm.Machine.util.PageButton(parent,icon,rot,onclick,islocked)
	local btn = vgui.Create("DButton", parent)
	btn:SetPos(50 / zvm.Machine.util.sm, 200 / zvm.Machine.util.sm)
	btn:SetSize(50 / zvm.Machine.util.sm, 50 / zvm.Machine.util.sm)
	btn:SetAutoDelete(true)
	btn:SetText("")
	btn.Paint = function(s, w, h)

		if islocked() then
			zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, zclib.colors["black_a100"])

			surface.SetDrawColor(zclib.colors["black_a100"])
			surface.SetMaterial(zclib.Materials.Get(icon))
			surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, rot)

			return
		end

		zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, color_white)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(zclib.Materials.Get(icon))
		surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, rot)

		if s.Hovered then
			draw.RoundedBox(0, 0 , 0, w, h,  zvm.colors["white02"])
		end
	end
	btn.DoClick = function()
		if islocked() then return end
		surface.PlaySound("UI/buttonrollover.wav")
		pcall(onclick)
	end

	return btn
end

function zvm.Machine.util.GetPageCount(Machine)
	local itmLimit = zvm.Machine.PageItemLimit()
	local pCount = zvm.Machine.ProductCount(Machine)
	local pageCount = pCount / itmLimit
	if (pageCount - math.floor(pCount / itmLimit)) > 0 then pageCount = math.floor(pCount / itmLimit) + 1 end
	return pageCount
end

function zvm.Machine.util.TextButton(parent,txt,onclick,filled,color,islocked)
	local btn = vgui.Create("DButton",parent)
	btn:SetPos(50 / zvm.Machine.util.sm, 100 / zvm.Machine.util.sm)
	btn:SetSize(200 / zvm.Machine.util.sm, 50 / zvm.Machine.util.sm)
	btn:SetAutoDelete(true)
	btn:SetText("")
	btn.Text = txt
	btn.Paint = function(s, w, h)

		if filled then
			draw.RoundedBox(0, 0, 0, w, h, color or zvm.colors["white02"])
		else
			zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 4, color or color_white)
		end
		draw.SimpleText(s.Text, zclib.GetFont("zvm_interface_font01"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if islocked and islocked() then
			draw.RoundedBox(0, 0 , 0, w, h,  zclib.colors["black_a100"])
		else
			if s.Hovered then
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"])
			end
		end
	end
	btn.DoClick = function()
		surface.PlaySound("UI/buttonclick.wav")
		if islocked and islocked() then return end
		pcall(onclick,btn)
	end
	return btn
end

function zvm.Machine.util.Page(parent)
	local MainPanel = vgui.Create("DPanel",parent)
	MainPanel:SetPos(0, 0)
	MainPanel:SetSize(300 / zvm.Machine.util.sm, 630 / zvm.Machine.util.sm)
	MainPanel.Paint = function(s, w, h) end
	return MainPanel
end

function zvm.Machine.util.ScrollPanel(parent)
	local scroll = vgui.Create("DScrollPanel", parent)
	scroll:DockMargin(10 / zvm.Machine.util.sm, 10 / zvm.Machine.util.sm, 0, 0)
	scroll:Dock(FILL)
	scroll.Paint = function(s, w, h) end
	local sbar = scroll:GetVBar()
	sbar:SetHideButtons(true)

	function sbar:Paint(w, h)
	end

	function sbar.btnUp:Paint(w, h)
	end

	function sbar.btnDown:Paint(w, h)
	end

	function sbar.btnGrip:Paint(w, h)
	end

	return scroll
end

// A nice little panel which shows you on which page you are using circles?
function zvm.Machine.util.PageIndicator(parent, Machine)
	local count = zvm.Machine.util.GetPageCount(Machine)
	local MainPanel = vgui.Create("DPanel", parent)
	MainPanel:SetPos(0, 0)
	MainPanel:SetSize(300 / zvm.Machine.util.sm, 630 / zvm.Machine.util.sm)
	MainPanel.Paint = function(s, w, h)
		local field_w = math.Clamp(w / count, 0, h * 0.9)
		//local center = (2 / w) - (2 / (field_w * count))
		//draw.RoundedBox(0, 0, 0, w, h, zvm.colors["green01"])
		for i = 0, count - 1 do
			if i == Machine.Page - 1 then
				surface.SetDrawColor(zclib.colors["green01"])
			else
				surface.SetDrawColor(zclib.colors["black_a100"])
			end
			surface.SetMaterial(zclib.Materials.Get("knob"))
			surface.DrawTexturedRect( field_w * i, (h / 2) - (field_w / 2), field_w, field_w)
		end
	end

	return MainPanel
end

// Returns true if we reached the limit of possible displayable pages
function zvm.Machine.util.PageCheck(Machine,count)
	local itmLimit = zvm.Machine.PageItemLimit()
	local min = (Machine.Page * itmLimit) - itmLimit
	local max = Machine.Page * itmLimit
	if count <= min then return true end
	if count > max then return true end
end
