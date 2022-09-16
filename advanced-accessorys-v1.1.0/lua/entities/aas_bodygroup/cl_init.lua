include("shared.lua")

function ENT:Draw()
	if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end
	
    self:DrawModel()

    local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 0)
	ang:RotateAroundAxis(ang:Forward(), 85)	
    
    if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 40000 then
		cam.Start3D2D(pos + ang:Up()*0, Angle(0, AAS.LocalPlayer:EyeAngles().y-90, 90), 0.025)

			draw.RoundedBoxEx(16, -500, -2150, 1000, 170, AAS.Colors["background"], true, true, false, false)
			draw.RoundedBox(0, -500, -2000, 1000, 20, AAS.Colors["black150"])

			draw.SimpleText(AAS.BodyGroupsName, "AAS:Font:08", 0, -2135, AAS.Colors["white"], TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end 
end