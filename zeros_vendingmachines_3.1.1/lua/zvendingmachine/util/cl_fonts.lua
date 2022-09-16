if SERVER then return end

zclib.AddFont("zvm_derma_textentry", {
	font = "Arial",
	extended = true,
	size = ScreenScale(20),
	weight = ScreenScale(3000),
	antialias = true
})

zclib.AddFont("zvm_derma_textentry01", {
	font = "Arial",
	extended = true,
	size = ScreenScale(7),
	weight = ScreenScale(3000),
	antialias = true
})

zclib.AddFont("zvm_derma_title", {
	font = "Arial",
	extended = true,
	size = ScreenScale(10),
	weight = ScreenScale(3000),
	antialias = true
})

zclib.AddFont("zvm_interface_item", {
	font = "Arial",
	extended = true,
	size = 15,
	weight = 1000,
	antialias = true
})

zclib.AddFont("zvm_interface_item_small", {
	font = "Arial",
	extended = true,
	size = 10,
	weight = 1000,
	antialias = true
})

zclib.AddFont("zvm_interface_font01", {
	font = "Arial",
	extended = true,
	size = 25,
	weight = 1000,
	antialias = true
})

zclib.AddFont("zvm_interface_title", {
	font = "Arial",
	extended = true,
	size = 45,
	weight = 1000,
	antialias = true
})

zclib.AddFont("zvm_interface_title_small", {
	font = "Arial",
	extended = true,
	size = 30,
	weight = 1000,
	antialias = true
})

zclib.AddFont("zvm_interface_font02", {
	font = "Arial",
	extended = true,
	size = 20,
	weight = 1000,
	antialias = true
})

local led_font = "Led Simple St"

if zvm.config.SelectedLanguage == "ru" then
	led_font = "Enhanced Dot Digital-7"
end

zclib.AddFont("zvm_machine_name", {
	font = led_font,
	extended = true,
	size = 50,
	weight = 1,
	antialias = true
})

zclib.AddFont("zvm_machine_name_small", {
	font = led_font,
	extended = true,
	size = 40,
	weight = 1,
	antialias = true
})
