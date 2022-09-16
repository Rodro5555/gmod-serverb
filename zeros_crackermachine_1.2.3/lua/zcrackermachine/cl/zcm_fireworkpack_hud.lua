if not CLIENT then return end
zcm = zcm or {}
zcm.f = zcm.f or {}

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080

hook.Add("PostDrawHUD", "a_zcm_PostDrawHUD_cl_MachineCrateBuilder", function()

	if GetConVar("zcm_cl_hud_enabled"):GetInt() == 1 then

		local firework = LocalPlayer():GetNWInt("zcm_firework", 0)

		if firework > 0 then

			local pos_x = (1920 / 100) * GetConVar("zcm_cl_hud_pos_x"):GetInt()
			local pos_y = (1080 / 100) * GetConVar("zcm_cl_hud_pos_y"):GetInt()
			local scale = GetConVar("zcm_cl_hud_Scale"):GetFloat()
			local width,height = 150 * scale, 150 * scale

			pos_x = pos_x - (width / 2)
			pos_y = pos_y - (height / 2)

			draw.RoundedBox(20 * scale, pos_x * wMod, pos_y * hMod, width * wMod, height * hMod, zcm.default_colors["black04"])

			surface.SetDrawColor(zcm.default_colors["white01"])
			surface.SetMaterial(zcm.default_materials["fireworkpack"])
			surface.DrawTexturedRect(pos_x * wMod, pos_y * hMod, width * wMod, height * hMod)

			draw.SimpleText(firework, "zcm_hud_font02", (pos_x + (width / 2)) * wMod, (pos_y + (height / 2)) * hMod, zcm.default_colors["black01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(firework, "zcm_hud_font01", (pos_x + (width / 2)) * wMod, (pos_y + (height / 2)) * hMod, zcm.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)
