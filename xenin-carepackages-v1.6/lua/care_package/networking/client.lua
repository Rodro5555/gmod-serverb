net.Receive("CarePackage.Menu", function(len)
  local ply = LocalPlayer()
	local ent = net.ReadEntity()
  local tbl = net.ReadTable()

  CarePackage:Menu(ent, tbl)
end)

net.Receive("CarePackage.Menu.Response", function(len)
	local success = net.ReadBool()
	local id = net.ReadUInt(8)
	local errStr = net.ReadString()

	hook.Run("CarePackage.Menu.Response", success, id, errStr)
end)

net.Receive("CarePackage.Plane", function(len)
	local pos = net.ReadVector()
	local endPos = net.ReadVector()
	local ang = XeninUI:GetAngleBetweenTwoVectors(endPos, pos)
	ang = ang + CarePackage.Config.AngleAdjustment
	local duration = net.ReadFloat()
	local z = net.ReadFloat()

	CarePackage:CreatePlane(pos, endPos, ang, duration, z)
end)

net.Receive("CarePackage.Message", function(len)
	local msg = net.ReadString()

	chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, color_white, msg)
end)

net.Receive("CarePackage.Saving.Get", function(len)
	local spawns = net.ReadTable()

	CarePackage.Spawns = spawns
end)

concommand.Add("carepackages_planepos", function()
	local ply = LocalPlayer()

	if (!ply.cpPlanePos) then
		ply.cpPlanePos = ply:GetPos()
		MsgC(XeninUI.Theme.Green, CarePackage.Config.ThemeText, color_white, "Now go to other corner of the map\n")
	else
		local pos = ply:GetPos()
		ply.planePositions = {
			ply.cpPlanePos,
			pos
		}
	
		net.Start("CarePackage.Saving.PlanePos")
			net.WriteVector(ply.cpPlanePos)
			net.WriteVector(pos)
		net.SendToServer()

		MsgC(XeninUI.Theme.Green, CarePackage.Config.ThemeText, color_white, "You have now saved the plane edges! You will be able to see the box of the plane edges in the sky until you reconnect\n")

		ply.cpPlanePos = nil
	end
end)

concommand.Add("carepackages_removeplanepos_render", function()
	LocalPlayer().planePositions = nil
end)