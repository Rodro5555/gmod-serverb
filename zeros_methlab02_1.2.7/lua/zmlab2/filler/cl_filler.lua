if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Filler = zmlab2.Filler or {}

function zmlab2.Filler.Initialize(Filler)
end

function zmlab2.Filler.Think(Filler)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Filler:GetPos(), 1000) and Filler:GetProcessState() == 2 and (Filler.NextEffect == nil or Filler.NextEffect < CurTime()) then
		local attach = Filler:GetAttachment(2)

		if attach then
			zclib.Effect.ParticleEffect("zmlab2_methsludge_fill", attach.Pos + Filler:GetForward() * math.random(-5, 5), angle_zero, Filler)
		end

		Filler.NextEffect = CurTime() + 0.1
	end
end

function zmlab2.Filler.Draw(Filler)
	zclib.util.LoopedSound(Filler, "zmlab2_machine_pumping", Filler:GetProcessState() == 2)

	if zclib.util.InDistance(LocalPlayer():GetPos(), Filler:GetPos(), 1000) and zclib.Convar.Get("zmlab2_cl_drawui") == 1 then
		zmlab2.Filler.DrawUI(Filler)
	end
end

function zmlab2.Filler.OnRemove(Filler)
	Filler:StopSound("zmlab2_machine_pumping")
end

function zmlab2.Filler.DrawUI_Liquid(Filler)
	if Filler.SmoothBar == nil then
		Filler.SmoothBar = 0
	end

	Filler.SmoothBar = Lerp(0.5 * FrameTime(), Filler.SmoothBar, Filler:GetMethAmount())
	local dat = zmlab2.config.MethTypes[Filler:GetMethType()]
	local turbulence = 0

	if Filler:GetProcessState() == 2 then
		turbulence = 0.5
	end

	cam.Start3D2D(Filler:LocalToWorld(Vector(17.8, 13.7, 18)), Filler:LocalToWorldAngles(Angle(0, 0, -90)), 0.1)
	zmlab2.Interface.DrawLiquid(Filler, -50, -20, 40, 260, (1 / dat.batch_size) * Filler.SmoothBar, dat.color, turbulence)
	cam.End3D2D()
end

local ScreenData = {
	pos = Vector(-4.85, 12, 29.55),
	ang = Angle(0, 180, 90),
	x = 0,
	y = 0,
	w = 200,
	h = 220,
	pages = {
		[0] = function(Filler)
			zmlab2.Interface.DrawPipe(200, 200, zmlab2.colors["mixer_liquid01"])
		end,
		[1] = function(Filler)
			zmlab2.Interface.DrawIngredient(0, 0, 200, 210, zclib.Materials.Get("icon_tray"), 1, zclib.GetFont("zmlab2_font03"))
		end,
		[3] = function(Filler)
			surface.SetDrawColor(color_white)
			surface.SetMaterial(zclib.Materials.Get("icon_sponge"))
			surface.DrawTexturedRectRotated(0, 0, 140, 140, 0)
		end
	}
}

function zmlab2.Filler.DrawUI(Filler)
	zmlab2.Filler.DrawUI_Liquid(Filler)
	zmlab2.Interface.Draw(Filler, ScreenData)
	zmlab2.Interface.DrawScalar(Filler, Vector(6, 1, 52), Angle(0, 0, -90), Filler:GetProcessState() == 2)
end
