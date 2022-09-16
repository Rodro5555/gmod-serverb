if SERVER then return end
zpiz = zpiz or {}
zpiz.Oven = zpiz.Oven or {}

function zpiz.Oven.Initialize(Oven)
	Oven.pizza01 = nil
	Oven.pizza02 = nil
end

function zpiz.Oven.PizzaProgress(Oven, pizza, pos)
	local pizzaState = pizza:GetPizzaState()
	local pizzaBakeTime = pizza:GetBakeTime()
	local status = zpiz.language.Oven_PizzaBaking or "nil"

	if (pizzaState == 3) then
		status = zpiz.language.Oven_PizzaReady
	elseif (pizzaState == 4) then
		status = zpiz.language.Oven_PizzaBurned
	end

	local baketime = zpiz.Pizza.GetBakeTime(pizza:GetPizzaID())
	local aBar = math.Clamp((400 / baketime) * pizzaBakeTime, 0, 400) or 200
	local t = ((1 / baketime) * pizzaBakeTime) or 0.5
	local barColor = zclib.util.LerpColor(t, zpiz.colors["brown04"], zpiz.colors["brown05"])

	if (pizzaBakeTime >= baketime + zpiz.config.Oven.BurnTime) then
		barColor = zpiz.colors["red01"]
	end

	local YOffset = 0

	if (pos == 1) then
		YOffset = 0
	elseif (pos == 2) then
		YOffset = -177
	end

	draw.RoundedBox(0, -205, 25 + YOffset, 410, 25, zpiz.colors["black01"])
	draw.RoundedBox(0, -200, 27 + YOffset, aBar, 20, barColor)
	draw.DrawText(status, zclib.GetFont("zpiz_oven_font01"), 0, 30 + YOffset, color_white, TEXT_ALIGN_CENTER)
end

local vec_offset = Vector(24.5, -1.7, 54.1)
local ang_offset = Angle(180, -90, 270)
function zpiz.Oven.Draw(Oven)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Oven:GetPos(), 300) then
		Oven.pizza01 = Oven:GetPizzaSlot01()
		Oven.pizza02 = Oven:GetPizzaSlot02()
		cam.Start3D2D(Oven:LocalToWorld(vec_offset), Oven:LocalToWorldAngles(ang_offset), 0.1)
			if IsValid(Oven.pizza01) then
				zpiz.Oven.PizzaProgress(Oven, Oven.pizza01, 1)
			end

			if IsValid(Oven.pizza02) then
				zpiz.Oven.PizzaProgress(Oven, Oven.pizza02, 2)
			end
		cam.End3D2D()
	end
end

function zpiz.Oven.Think(Oven)
	zclib.util.LoopedSound(Oven, "zpiz_sfx_ovenbake", IsValid(Oven.pizza01) or IsValid(Oven.pizza02))
end

function zpiz.Oven.OnRemove(Oven)
	Oven:StopSound("zpiz_sfx_ovenbake")
end
