SH_SZ.Shapes = {}
SH_SZ.ShapesIndex = {}

SH_SZ.Shapes["cube"] = {
	name = "cube",
	icon = "shenesis/safezones/cube.png",
	points = 2,
	steps = {
		{type = "place"},
		{type = "place"},
		{type = "confirm"},
	},

	setup = function(zone, points, size)
		zone:SetupCube(points[1], points[2], size)
	end,
	render = function(points, size, color)
		local z = math.min(points[1].z, points[2].z)

		local a = Vector(points[1].x, points[1].y, z)
		local b = Vector(points[2].x, points[2].y, z)

		local c1 = Vector(a.x, b.y, a.z)
		local c2 = Vector(b.x, a.y, a.z)

		render.DrawLine(a, c1, color, true)
		render.DrawLine(b, c1, color, true)
		render.DrawLine(a, c2, color, true)
		render.DrawLine(b, c2, color, true)

		local o = Vector(0, 0, size)
		local t1 = a + o
		local t2 = b + o
		local t3 = c1 + o
		local t4 = c2 + o

		render.DrawLine(a, t1, color, true)
		render.DrawLine(b, t2, color, true)
		render.DrawLine(c1, t3, color, true)
		render.DrawLine(c2, t4, color, true)

		render.DrawLine(t1, t4, color, true)
		render.DrawLine(t2, t3, color, true)
		render.DrawLine(t3, t1, color, true)
		render.DrawLine(t4, t2, color, true)
	end
}

SH_SZ.Shapes["sphere"] = {
	name = "sphere",
	icon = "shenesis/safezones/sphere.png",
	points = 1,
	steps = {
		{type = "place"},
		{type = "confirm"},
	},

	setup = function(zone, points, size)
		zone:SetupSphere(points[1], size)
	end,
	render = function(points, size, color)
		render.DrawWireframeSphere(points[1], size, 16, 16, color, true)
	end
}

do
	local i = 0
	for _, v in pairs (SH_SZ.Shapes) do
		i = i + 1
		v.id = i
		SH_SZ.ShapesIndex[i] = v
	end
end