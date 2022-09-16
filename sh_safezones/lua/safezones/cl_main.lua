local function L(s, ...)
	return string.format(SH_SZ.Language[s] or s, ...)
end

local aligns = {
	topleft = {TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, -1},
	top = {TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 0.5, -1},
	topright = {TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, -1, -1},
	left = {TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, 0},
	center = {TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, 0},
	right = {TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, -1, 0},
	bottomleft = {TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, 1},
	bottom = {TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 0.5, 1},
	bottomright = {TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, -1, 1},
}

function SH_SZ:HUDPaint()
	local sz = self.m_Safe
	if (!sz or !sz.opts.hud) then
		return end

	local styl = self.Style
	local th = self:GetPadding()
	local x, y = ScrW() * 0.5, ScrH() * 0.5

	local xa, ya = TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP
	local align = aligns[self.HUDAlign]
	if (align) then
		xa, ya = align[1], align[2]

		local xx = align[3]
		if (xx == 1) then
			x = th
		elseif (xx == -1) then
			x = ScrW() - th
		end

		local yy = align[4]
		if (yy == 1) then
			y = ScrH() - th - draw.GetFontHeight("SH_SZ.Larger")
		elseif (yy == -1) then
			y = th
		end
	end

	local o = self.HUDOffset
	local ss = o.scale and self:GetScreenScale() or 1
	x = x + o.x * ss
	y = y + o.y * ss

	local _w, _h = draw.SimpleTextOutlined(sz.opts.name, "SH_SZ.Largest", x, y, sz.opts.namecol or styl.header, xa, ya, 1, styl.inbg)
	draw.SimpleTextOutlined(L(self:GetSafeStatus(LocalPlayer(), sz)), "SH_SZ.Larger", x, y + _h, styl.text, xa, ya, 1, styl.inbg)
end

hook.Add("HUDPaint", "SH_SZ.HUDPaint", function()
	SH_SZ:HUDPaint()
end)

net.Receive("SH_SZ.Traverse", function()
	local enter = net.ReadBool()
	if (enter) then
		SH_SZ.m_Safe = {
			enter = net.ReadFloat(),
			opts = {
				name = net.ReadString(),
				namecol = net.ReadColor(),
				noatk = net.ReadBool(),
				ptime = net.ReadFloat(),
				hud = net.ReadBool(),
			}
		}
	else
		SH_SZ.m_Safe = nil
	end
end)

net.Receive("SH_SZ.Notify", function()
	SH_SZ:Notify(net.ReadString(), nil, SH_SZ.Style[net.ReadBool() and "success" or "failure"])
end)