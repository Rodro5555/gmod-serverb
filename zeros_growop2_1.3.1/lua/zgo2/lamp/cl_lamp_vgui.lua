zgo2 = zgo2 or {}
zgo2.Lamp = zgo2.Lamp or {}

net.Receive("zgo2.Lamp.SelectColor", function(len, ply)
	zclib.Debug_Net("zgo2.Lamp.SelectColor", len)
	local Lamp = net.ReadEntity()
	zgo2.Lamp.OpenColorSelector(Lamp)
end)

function zgo2.Lamp.OpenColorSelector(Lamp)
	zclib.vgui.Page(zgo2.language[ "Light Color" ], function(main, top)
		main:SetSize(400 * zclib.wM, 300 * zclib.hM)
		main:DockPadding(0, 15, 0, 10)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors[ "red01" ], function()
			main:Close()
		end, function() return false end, zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		local color = Lamp:GetLampColor()
		color = Color(color.x, color.y, color.z)

		local paint_color = zclib.vgui.Colormixer(main, color, function(col) end, function(col, s)
			net.Start("zgo2.Lamp.SelectColor")
			net.WriteEntity(Lamp)
			net.WriteUInt(col.r, 8)
			net.WriteUInt(col.g, 8)
			net.WriteUInt(col.b, 8)
			net.SendToServer()
		end)

		paint_color:DockMargin(10, 0, 10, 0)
		paint_color:Dock(FILL)
		paint_color:SetWangs(false)
		paint_color:SetAlphaBar(false)
	end)
end
