include("shared.lua")

net.Receive("MMF_SetLookingPortal", function()
	LocalPlayer().MMF_LookingPortal = net.ReadEntity()
end)

local portalMaterial = Material("icon16/world.png")

hook.Add("PostDrawHUD", "MMF_CreatePortalMarker", function()
	local portal = LocalPlayer().MMF_LookingPortal
	if not IsValid(portal) then return end

	local portalpos = portal:GetPos()
	if portalpos:DistToSqr(LocalPlayer():GetPos()) < 30000 then return end

	cam.Start2D()
		-- ToScreen only works in a 3d rendering context....
		local scrpos = nil
		cam.Start3D()
			scrpos = portalpos:ToScreen()
		cam.End3D()

		local x = math.Clamp(scrpos.x, 100, ScrW() - 100)
		local y = math.Clamp(scrpos.y, 100, ScrH() - 100)

		surface.SetDrawColor(Color(255, 0, 255))

		local radius, seg, cir = 20, 32, {}

		table.insert(cir, { x = x, y = y, u = 0.5, v = 0.5 })
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
		end

		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

		surface.DrawPoly(cir)

		local size = radius * 1.7
		surface.SetMaterial(portalMaterial)
		surface.SetDrawColor(color_white)
		local rot = math.sin(CurTime() * 4) * 20
		surface.DrawTexturedRectRotated(x, y, size, size, rot)
	cam.End2D()
end)