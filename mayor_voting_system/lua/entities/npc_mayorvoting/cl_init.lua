include("shared.lua");

function ENT:Initialize ( )	
	self.AutomaticFrameAdvance = true;
end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	pos.z = (pos.z + 15)
	local ang = self:GetAngles()
	
	surface.SetFont("Bebas40Font")
	local title = VOTING.Settings.NPCTitleText
	local tw = surface.GetTextSize(title)

	ang:RotateAroundAxis(ang:Forward(), 90)
	local textang = ang

	textang:RotateAroundAxis(textang:Right(), CurTime() * -180)

	cam.Start3D2D(pos + ang:Right() * -30, textang, 0.2)
		draw.WordBox(2, -tw *0.5 + 5, -180, title, "Bebas40Font", VOTING.Theme.ControlColor, color_white)
	cam.End3D2D()
end
