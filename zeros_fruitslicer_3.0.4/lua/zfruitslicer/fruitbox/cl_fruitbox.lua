if (not CLIENT) then return end
zfs = zfs or {}
zfs.Fruitbox = zfs.Fruitbox or {}

function zfs.Fruitbox.Draw(Fruitbox)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Fruitbox:GetPos(), zfs.dist_interaction) then
		cam.Start3D2D(Fruitbox:LocalToWorld(Vector(0, 0, 17)), Fruitbox:LocalToWorldAngles(Angle(0, 0, 0)), 0.2)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(zfs.Fruit.GetIcon(Fruitbox:GetFruitID()))
			surface.DrawTexturedRect(-50, -50, 100, 100)

			draw.SimpleText(zfs.config.FruitBox.Amount, zclib.GetFont("zclib_world_font_big"), 0, 0, color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
