if SERVER then return end
zgo2 = zgo2 or {}
zgo2.Sniffer = zgo2.Sniffer or {}
local effect_duration = 0
local IllegalItems = {}

local function AddIllegalItem(ent)
	local d_data = zgo2.Sniffer.Items[ ent:GetClass() ]
	if not d_data.check(ent) then return end

	table.insert(IllegalItems, {
		ent = ent,
		pos = ent:GetPos() + Vector(0, 0, 15),
		color = d_data.color,
		mat = d_data.icon
	})
end

net.Receive("zgo2_sniffer_check", function(len)
	IllegalItems = {}

	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), zgo2.config.Sniffer.distance)) do
		if IsValid(v) and zgo2.Sniffer.Items[ v:GetClass() ] then
			AddIllegalItem(v)
		end
	end

	effect_duration = zgo2.config.Sniffer.duration * 100

	zclib.Hook.Remove("HUDPaint", "zgo2_Sniffer")
	zclib.Hook.Add("HUDPaint", "zgo2_Sniffer", zgo2.Sniffer.Draw)

	zclib.Hook.Remove("RenderScreenspaceEffects", "zgo2_Sniffer")
	zclib.Hook.Add("RenderScreenspaceEffects", "zgo2_Sniffer", zgo2.Sniffer.ScreenEffect)

	timer.Remove("zgo2_sniffer_counter")
	timer.Create("zgo2_sniffer_counter", 0.1, 0, function()
		if (effect_duration or 0) > 0 then
			effect_duration = effect_duration - 10
		else
			timer.Remove("zgo2_sniffer_counter")
		end
	end)
end)

function zgo2.Sniffer.ScreenEffect()
	if effect_duration <= 0 then
		zclib.Hook.Remove("RenderScreenspaceEffects", "zgo2_Sniffer")

		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		zclib.Hook.Remove("RenderScreenspaceEffects", "zgo2_Sniffer")

		return
	end

	if not ply:Alive() then
		zclib.Hook.Remove("RenderScreenspaceEffects", "zgo2_Sniffer")

		return
	end

	local strength = math.Clamp((1 / 500) * effect_duration, 0, 1)

	local tab = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = -0.1 * strength,
		[ "$pp_colour_contrast" ] = 1 + (0.5 * strength),
		[ "$pp_colour_colour" ] = 1 - (0.5 * strength),
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0,
	}

	DrawColorModify(tab)
end

function zgo2.Sniffer.Draw()
	if effect_duration <= 0 then
		zclib.Hook.Remove("HUDPaint", "zgo2_Sniffer")

		return
	end

	local ply = LocalPlayer()

	if not IsValid(ply) then
		zclib.Hook.Remove("HUDPaint", "zgo2_Sniffer")

		return
	end

	if not ply:Alive() then
		zclib.Hook.Remove("HUDPaint", "zgo2_Sniffer")

		return
	end

	for k, v in pairs(IllegalItems) do
		local pos = v.pos:ToScreen()
		if zclib.util.InDistance(ply:GetPos(), v.pos, 100) then continue end
		if zclib.util.InDistance(ply:GetPos(), v.pos, zgo2.config.Sniffer.distance) == false then continue end
		local strength = math.Clamp((1 / 300) * effect_duration, 0, 1)
		local color = v.color
		color.a = 255 * strength
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
		surface.SetMaterial(v.mat)
		surface.DrawTexturedRect(pos.x - 25, pos.y - 25, 50, 50)
	end
end
