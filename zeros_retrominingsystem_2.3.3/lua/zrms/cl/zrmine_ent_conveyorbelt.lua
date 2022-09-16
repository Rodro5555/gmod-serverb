if SERVER then return end

zrmine = zrmine or {}
zrmine.f = zrmine.f or {}


// Draw Info
local offsetX, offsetY = -3, 10
function zrmine.f.Belt_DrawResourceItem(Belt,OreType, xpos, ypos, size)
	local color = zrmine.f.GetOreColor(OreType)

	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect(xpos + offsetX, ypos + offsetY, size, size)

	draw.DrawText( math.Round(zrmine.f.GetOreFromEnt(Belt,OreType)) .. zrmine.config.BuyerNPC_Mass, "zrmine_screen_font3", xpos + offsetX + 30, ypos + offsetY + size * 0.25, color, TEXT_ALIGN_LEFT)
end

local Offsets = {
	["zrms_splitter"] = {
		pos = Vector(0,-10.7,10),
		ang = Angle(0,0,90)
	},
	["zrms_sorter_coal"] = {
		pos = Vector(0,17,18.7),
		ang = Angle(0,0,0)
	},
	["zrms_sorter_iron"] = {
		pos = Vector(0,17,18.7),
		ang = Angle(0,0,0)
	},
	["zrms_sorter_bronze"] = {
		pos = Vector(0,17,18.7),
		ang = Angle(0,0,0)
	},
	["zrms_sorter_silver"] = {
		pos = Vector(0,17,18.7),
		ang = Angle(0,0,0)
	},
	["zrms_sorter_gold"] = {
		pos = Vector(0,17,18.7),
		ang = Angle(0,0,0)
	},
}

local function GetOffset(Belt)
	if Offsets[Belt:GetClass()] then
		return Offsets[Belt:GetClass()]
	else
		return {pos = Vector(0,0,17),ang = Angle(0,0,0)}
	end
end

function zrmine.f.Belt_DrawInfo(Belt)

	local Offset = GetOffset(Belt)
	cam.Start3D2D(Belt:LocalToWorld(Offset.pos), Belt:LocalToWorldAngles(Offset.ang), 0.1)

		draw.RoundedBox(0, -65, -75, 130, 150, zrmine.default_colors["grey01"])
		draw.RoundedBox(0, -60, -70, 120, 140, zrmine.default_colors["grey02"])

		local amount = math.Round(Belt:ReturnStorage(), 2)
		local aBar = (120 / zrmine.config.Belt_Capacity) * amount

		if (aBar > 120) then
			aBar = 120
		end

		draw.RoundedBox(0, 32, 60, 20, -aBar, zrmine.default_colors["brown01"])

		zrmine.f.Belt_DrawResourceItem(Belt,"Coal", -55, -75, 30)
		zrmine.f.Belt_DrawResourceItem(Belt,"Iron", -55, -50, 30)
		zrmine.f.Belt_DrawResourceItem(Belt,"Bronze", -55, -25, 30)
		zrmine.f.Belt_DrawResourceItem(Belt,"Silver", -55, 0, 30)
		zrmine.f.Belt_DrawResourceItem(Belt,"Gold", -55, 25, 30)

		surface.SetDrawColor(zrmine.default_colors["white02"])
		surface.SetMaterial(zrmine.default_materials["Scale"])
		surface.DrawTexturedRect(17, -62, 50, 125)
	cam.End3D2D()
end
