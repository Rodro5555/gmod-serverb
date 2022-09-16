include("shared.lua")

surface.CreateFont("DiablosRSAboveHeadFont", { font = "Calibri", size = 60, weight = 400 })

function ENT:Draw()
	self:DrawModel()

	if Diablos.RS.NPCHeadMessage == "" then return end
	surface.SetFont("DiablosRSAboveHeadFont")
	local sizex, sizey = surface.GetTextSize(Diablos.RS.NPCHeadMessage)

	cam.Start3D2D(self:GetPos() + self:GetUp() * 85, Angle(0, LocalPlayer():EyeAngles().y-90, 90), .1)
		draw.RoundedBox(8, - sizex / 2 - 25, -10, sizex + 50, sizey + 20, Diablos.RS.Colors.AboveRadarBorder)
		draw.RoundedBox(8, - sizex / 2 - 5, 0, sizex + 10, sizey, Diablos.RS.Colors.AboveRadarBorder)
		draw.SimpleText(Diablos.RS.NPCHeadMessage, "DiablosRSAboveHeadFont", 0, 0, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
	cam.End3D2D()
end