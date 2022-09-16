zgo2 = zgo2 or {}
zgo2.MixerBowl = zgo2.MixerBowl or {}

/*

	Just to combine the ingredients for baking

*/

function zgo2.MixerBowl.Initialize(MixerBowl)
	MixerBowl:DestroyShadow()

	timer.Simple(0.5, function()
		if IsValid(MixerBowl) then
			MixerBowl.m_Initialized = true
		end
	end)

	zclib.EntityTracker.Add(MixerBowl)
end

function zgo2.MixerBowl.Draw(MixerBowl)
	zgo2.MixerBowl.DrawInfo(MixerBowl)
end

function zgo2.MixerBowl.Think(MixerBowl)
	if zgo2.Plant.UpdateMaterials[ MixerBowl ] == nil then
		zgo2.Plant.UpdateMaterials[ MixerBowl ] = true
	end
end

function zgo2.MixerBowl.DrawInfo(MixerBowl)
	if not LocalPlayer().zgo2_Initialized then return end
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(MixerBowl:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	if zclib.Entity.GetLookTarget() ~= MixerBowl then return end

	local edible_id = MixerBowl:GetEdibleID()
	if edible_id and edible_id > 0 then
		zgo2.HUD.Draw(MixerBowl,function()

			local id = MixerBowl:GetWeedID()

			if id and id > 0 then

				local name = zgo2.Edible.GetName(edible_id)
				local boxSize = zclib.util.GetTextSize(name, zclib.GetFont("zclib_world_font_medium")) * 1.5

				draw.RoundedBox(20, -boxSize / 2, -370, boxSize, 60, zclib.colors[ "black_a200" ])
				draw.SimpleText(name, zclib.GetFont("zclib_world_font_medium"), 0, -340, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				local name = zgo2.Plant.GetName(id)
				local boxSize = zclib.util.GetTextSize(name, zclib.GetFont("zclib_world_font_medium")) * 1.5
				draw.RoundedBox(20, -boxSize / 2, -300, boxSize, 180, zclib.colors[ "black_a200" ])
				draw.SimpleText(name, zclib.GetFont("zclib_world_font_medium"), 0, -270, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(MixerBowl:GetWeedAmount() .. zgo2.config.UoM, zclib.GetFont("zclib_world_font_medium"), 0, -220, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(MixerBowl:GetWeedTHC() .. "%", zclib.GetFont("zclib_world_font_medium"), 0, -160, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("▼", zclib.GetFont("zclib_world_font_large"), 0, -50, zclib.colors[ "black_a200" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				local name = zgo2.Edible.GetName(edible_id)
				local boxSize = zclib.util.GetTextSize(name, zclib.GetFont("zclib_world_font_medium")) * 1.5

				draw.RoundedBox(20, -boxSize / 2, -300, boxSize, 100, zclib.colors[ "black_a200" ])
				draw.SimpleText(name, zclib.GetFont("zclib_world_font_medium"), 0, -250, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("▼", zclib.GetFont("zclib_world_font_large"), 0, -150, zclib.colors["black_a200"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end,0.05)
	end
end
