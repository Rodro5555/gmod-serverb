include("shared.lua")

function ENT:Draw()
    if not IsValid(RCD.LocalPlayer) then return end

    self:DrawModel()
	
    local pos = self:GetPos()
    
    if RCD.LocalPlayer:GetPos():DistToSqr(pos) < 800000 then
		local name = RCD.GetNWVariables("rcd_npc_name", self) or ""

		cam.Start3D2D(pos + RCD.Constants["vectorNPC"], Angle(0, RCD.LocalPlayer:EyeAngles().y-90, 90), 0.025)

			surface.SetFont("RCD:Font:19")
			local size = surface.GetTextSize(name)*1.15

			draw.RoundedBox(0, -size/2, -2150, size, 250, RCD.Colors["blackpurple"])
			draw.RoundedBox(0, -size/2, -1930, size, 30, RCD.Colors["purple"])

			draw.DrawText(name, "RCD:Font:19", 5, -2120, RCD.Colors["white"], TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end 
end