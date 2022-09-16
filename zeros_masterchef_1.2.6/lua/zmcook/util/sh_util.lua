zmc = zmc or {}

// Makeing sure they are not changed by some other script
angle_zero = Angle(0,0,0)
vector_origin = Vector(0,0,0)

// EntityDistance check for net messages
zmc.netdist = 1500

zmc.throw_distance = 1000

zmc.renderdist_generic = 1500

zmc.renderdist_item_ui = 300
zmc.renderdist_ui = 500
zmc.renderdist_effect = 600
zmc.renderdist_clientmodels = 1000
zmc.renderdist_dynamiclight = 500
zmc.renderdist_dish_clientmodels = 300
zmc.renderdist_dish_clipping = 300

function zmc.Print(msg)
	print("[Zeros MasterCook] " .. msg)
end
