zgo2 = zgo2 or {}
zgo2.NPC = zgo2.NPC or {}
zgo2.NPC.List = zgo2.NPC.List or {}

/*

	Players can buy bongs and sell weed at the npc

*/

function zgo2.NPC.Initialize(NPC)

end

function zgo2.NPC.Draw(NPC)

	local name = NPC:GetClass() == "zgo2_npc" and zgo2.language[ "Weed Dealer" ] or zgo2.language[ "Export Manager" ]

	zgo2.HUD.Draw(NPC,function()
		local boxSize = zclib.util.GetTextSize(name, zclib.GetFont("zclib_world_font_big")) * 1.2
		draw.RoundedBox(0, -boxSize / 2, -35, boxSize, 70, zclib.colors["black_a100"])
		draw.SimpleText(name, zclib.GetFont("zclib_world_font_big"), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		zclib.util.DrawOutlinedBox(-boxSize / 2, -35, boxSize, 70, 4, color_white)
	end)
end
