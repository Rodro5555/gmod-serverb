if SERVER then return end
zpiz = zpiz or {}
zpiz.Sign = zpiz.Sign or {}

function zpiz.Sign.Draw(Sign)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Sign:GetPos(), 500) then
		zpiz.Sign.DrawMainInfo(Sign)
	end
end

function zpiz.Sign.DrawMainInfo(Sign)
	local status
	local sState = Sign:GetSignState()

	if (sState) then
		status = zpiz.language.OpenSign_open
	else
		status = zpiz.language.OpenSign_closed
	end

	cam.Start3D2D(Sign:GetPos(), zclib.HUD.GetLookAngles(), 0.1)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.SetMaterial(zpiz.materials["zpiz_button"])
		surface.DrawTexturedRect(-250, -360, 500, 80)

		if (sState) then
			surface.SetDrawColor(0, 0, 0, 100)
			surface.SetMaterial(zpiz.materials["zpiz_button"])
			surface.DrawTexturedRect(-150, -280, 300, 80)
			draw.DrawText(zpiz.language.OpenSign_Revenue .. zclib.Money.Display(Sign:GetSessionEarnings()), zclib.GetFont("zpiz_vgui_font03"), 0, -250, color_white, TEXT_ALIGN_CENTER)
		end

		draw.DrawText(status, zclib.GetFont("zpiz_plate_font02"), 0, -350, color_white, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
