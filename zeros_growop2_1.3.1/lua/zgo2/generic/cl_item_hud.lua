zgo2 = zgo2 or {}
zgo2.HUD = zgo2.HUD or {}

function zgo2.HUD.Draw(ent,func,scale)
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(ent:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	local height = ((ent:OBBMaxs().z + ent:OBBMins().z) / 2) + 10

	cam.Start3D2D(ent:LocalToWorld(ent:OBBCenter()) + Vector(0, 0, height + 1 * math.sin(CurTime() * 2)), zclib.HUD.GetLookAngles(),scale or 0.1)
		pcall(func)
	cam.End3D2D()
end
