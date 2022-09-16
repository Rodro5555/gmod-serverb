if not CLIENT then return end
local defaultFont = "Marlett"

if (system.IsOSX()) then
	defaultFont = "Arial"
end

surface.CreateFont("zrmine_gravelcrate_font1", {
	font = defaultFont,
	extended = true,
	size = 15,
	weight = 1000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_inserter_font1", {
	font = defaultFont,
	extended = true,
	size = ScreenScale( 100 ),
	weight = ScreenScale( 300 ),
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_pickaxe_font1", {
	font = defaultFont,
	extended = true,
	size = 25,
	weight = 1000,
	antialias = true,
	outline = false
})


surface.CreateFont("zrmine_pickaxe_font2", {
	font = defaultFont,
	extended = true,
	size = 20,
	weight = 10000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_pickaxe_font3", {
	font = defaultFont,
	extended = true,
	size = 18,
	weight = 1,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_pickaxe_font4", {
	font = defaultFont,
	extended = true,
	size = 14,
	weight = 5000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_npc_font1", {
	font = "Imperial One",
	extended = true,
	size = 50,
	weight = 1000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_npc_font2", {
	font = defaultFont,
	extended = true,
	size = 30,
	weight = 1000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_npc_font3", {
	font = defaultFont,
	extended = true,
	size = 15,
	weight = 1000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_npc_font4", {
	font = defaultFont,
	extended = true,
	size = 15,
	weight = 25,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_mineentrance_font1", {
	font = defaultFont,
	extended = true,
	size = 60,
	weight = 10000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_mineentrance_font2", {
	font = defaultFont,
	extended = true,
	size = 40,
	weight = 0,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_mineentrance_font3", {
	font = "Imperial One",
	extended = true,
	size = 100,
	weight = 0,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_screen_font1", {
	font = defaultFont,
	extended = true,
	size = 30,
	weight = 1000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_screen_font2", {
	font = defaultFont,
	extended = true,
	size = 40,
	weight = 5000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_screen_font3", {
	font = defaultFont,
	extended = true,
	size = 20,
	weight = 5000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_screen_font4", {
	font = defaultFont,
	extended = true,
	size = 60,
	weight = 5000,
	antialias = true,
	outline = false
})

surface.CreateFont("zrmine_resource_font1", {
	font = defaultFont,
	extended = true,
	size = 40,
	weight = 1000,
	antialias = true
})

surface.CreateFont("zrmine_resource_font2", {
	font = defaultFont,
	extended = true,
	size = 45,
	weight = 1000,
	antialias = true
})


// Config VGUI
surface.CreateFont("zrmine_vgui_font01", {
	font = defaultFont,
	extended = false,
	size = ScreenScale( 10 ),
	weight = ScreenScale( 300 ),
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("zrmine_vgui_font02", {
	font = defaultFont,
	extended = false,
	size = ScreenScale( 15 ),
	weight = ScreenScale( 300 ),
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("zrmine_vgui_font03", {
	font = defaultFont,
	extended = false,
	size = ScreenScale( 10 ),
	weight = ScreenScale( 300 ),
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})


surface.CreateFont("zrmine_builder_font1", {
	font = defaultFont,
	extended = true,
	size = ScreenScale(10),
	weight = ScreenScale(3000),
	antialias = true,
	outline = false,
	shadow = false
})

surface.CreateFont("zrmine_builder_font1_shadow", {
	font = defaultFont,
	extended = true,
	size = ScreenScale(10),
	weight = ScreenScale(3000),
	antialias = true,
	outline = false,
	shadow = true,
	blursize = 2,
})

surface.CreateFont("zrmine_settings_font01", {
	font = defaultFont,
	extended = true,
	size = ScreenScale( 12 ),
	weight = ScreenScale( 300 ),
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("zrmine_settings_font02", {
	font = defaultFont,
	extended = true,
	size = ScreenScale( 8 ),
	weight = ScreenScale( 5 ),
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})
