CH_ATM.Colors = CH_ATM.Colors or {}
CH_ATM.Materials = CH_ATM.Materials or {}

--[[
	Cache materials in our table.
--]]
local selectsprite = { sprite = "sprites/blueflare1", nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
local name = selectsprite.sprite.."-"
local params = { ["$basetexture"] = selectsprite.sprite }
local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
for i, j in pairs( tocheck ) do
	if (selectsprite[j]) then
		params["$"..j] = 1
		name = name.."1"
	else
		name = name.."0"
	end
end
CH_ATM.Materials.Cursor = CreateMaterial(name,"UnlitGeneric",params) --Material( "materials/craphead_scripts/ch_atm/gui/cursor.png", "noclamp smooth" )
CH_ATM.Materials.HandCursor = CH_ATM.Materials.Cursor --Material( "materials/craphead_scripts/ch_atm/gui/hand_cursor.png", "noclamp smooth" )
CH_ATM.Materials.CloseIcon = Material( "craphead_scripts/ch_atm/gui/close.png", "noclamp smooth" )
CH_ATM.Materials.Crosshair = Material( "craphead_scripts/ch_atm/gui/crosshair.png", "noclamp smooth" )

--[[
	Cache colors in our table.
--]]
CH_ATM.Colors.DarkGray = Color( 22, 22, 22, 255 )
CH_ATM.Colors.LightGray = Color( 30, 30, 30, 255 )

CH_ATM.Colors.Green = Color( 0, 100, 0, 255 )
CH_ATM.Colors.GreenHovered = Color( 0, 150, 0, 255 )

CH_ATM.Colors.Red = Color( 100, 0, 0, 255 )
CH_ATM.Colors.RedHovered = Color( 150, 0, 0, 255 )
CH_ATM.Colors.RedAlpha = Color( 150, 0, 0, 70 )

CH_ATM.Colors.WhiteAlpha = Color( 255, 255, 255, 5 )
CH_ATM.Colors.WhiteAlpha2 = Color( 255, 255, 255, 70 )

CH_ATM.Colors.GMSBlue = Color( 52, 152, 219, 255 )