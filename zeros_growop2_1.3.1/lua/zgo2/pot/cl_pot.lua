zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}
zgo2.Pot.List = zgo2.Pot.List or {}

/*

	The player can grow plants in pots if the bot has soil in it

*/

function zgo2.Pot.Initialize(Pot)
	timer.Simple(0.5,function()
		if not IsValid(Pot) then return end
		Pot.m_Initialized = true
		Pot.UpdateMaterials = nil
	end)
end

local ang = Angle(180, 90, -90)
local function DrawWarning(icon,color,txt)
	draw.RoundedBox(15, -150,65, 300, 300, zclib.colors["black_a200"])

	surface.SetDrawColor(color)
	surface.SetMaterial(zclib.Materials.Get(icon))
	surface.DrawTexturedRectRotated(0, 190, 250, 250, 0)

	draw.RoundedBox(15, -150,305, 300, 60, zclib.colors["black_a200"])
	draw.SimpleText(txt, zclib.GetFont("zclib_world_font_mediumsmall"), 0,  335,  zclib.colors["red01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function zgo2.Pot.DrawStatus(Pot,plant)
	local plant_id = plant:GetPlantID()
	local PlantData = zgo2.Plant.GetData(plant_id)
	if PlantData then
		draw.RoundedBox(10, -150,0, 300, 60, zclib.colors["ui00"])
		draw.SimpleText(PlantData.name, zclib.GetFont("zclib_world_font_mediumsmall"), 0,  30,  zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if zgo2.Plant.HarvestReady(plant) then

			draw.RoundedBox(15, -150,140, 300, 60, zclib.colors["green01"])
			draw.RoundedBox(15, -150,140, 300, 60, zclib.colors["black_a100"])
			draw.SimpleText(zgo2.language[ "Harvest Ready" ], zclib.GetFont("zclib_world_font_mediumsmall"), 0,  170,  color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


			// This is the time our plant stayed in the HarvestReady State
			local ExtraTime = CurTime() - plant:GetGrowCompletedTime()

			// Calculate how much more thc the weed will get because of longer grow time
			local thc_boost = zgo2.config.Plant.thc_bonus_boost or 10
			local thc_time = zgo2.config.Plant.thc_bonus_time or 300
			local ExtraTHC = math.Clamp((thc_boost / thc_time) * ExtraTime, 0, thc_boost)

			draw.RoundedBox(15, -150,70, 300, 60, zclib.colors["yellow01"])
			draw.RoundedBox(15, -150,70, 300, 60, zclib.colors["black_a100"])
			draw.SimpleText("THC: " .. PlantData.weed.thc + math.Round(ExtraTHC) .. "%", zclib.GetFont("zclib_world_font_medium"), 0, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			local water_limit = zgo2.Pot.GetWaterLimit(Pot)
			local water_stored = Pot:GetWater()
			zgo2.util.DrawBar(300, 60, zclib.Materials.Get("zgo2_icon_water"), zclib.colors[ "blue02" ], 0, 210, (1 / water_limit) * water_stored)
			draw.SimpleText(water_limit .. "/" .. water_stored, zclib.GetFont("zclib_world_font_medium"), 0, 240, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else

			// Does the plant have enough light?
			if plant:GetLightLevel() == 0 then
				DrawWarning("zgo2_icon_light",zclib.colors["red01"],zgo2.language[ "Missing Light!" ])
				return
			end

			// Does the plant have the correct light color?
			if plant:GetLightLevel() == 3 then
				DrawWarning("zgo2_icon_light",PlantData.grow.pref_lightcolor_color,zgo2.language[ "Wrong Color!" ])
				return
			end

			// Is the plant overheated?
			if plant:GetLightLevel() == 2 then
				DrawWarning("icon_hot",zclib.colors["red01"],zgo2.language[ "Overheat!" ])
				return
			end

			// Is the plant to close to other plants?
			if Pot:GetIsCramped() then
				DrawWarning("zgo2_pot_proximity",zclib.colors["red01"],zgo2.language[ "Is cramped!" ])
				return
			end

			// Does the plant have enough water?
			local needWater = zgo2.Plant.GetWaterNeed(plant_id)
			needWater = needWater / zgo2.Plant.GetGrowTime(plant_id,plant)
			if Pot:GetWater() < needWater then
				DrawWarning("zgo2_icon_water",zclib.colors["red01"],zgo2.language[ "Missing Water!" ])
				return
			end

			zgo2.util.DrawBar(300,60,zclib.Materials.Get("zgo2_icon_weed"), zclib.colors[ "green01" ],0, 70, (1 / zgo2.Plant.GetGrowTime(plant_id,plant)) * plant:GetGrowProgress())

			local water_limit = zgo2.Pot.GetWaterLimit(Pot)
			local water_stored = Pot:GetWater()
			zgo2.util.DrawBar(300, 60, zclib.Materials.Get("zgo2_icon_water"), zclib.colors[ "blue02" ], 0, 140, (1 / water_limit) * water_stored)
			draw.SimpleText(water_limit .. "/" .. water_stored, zclib.GetFont("zclib_world_font_medium"), 0, 170, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

function zgo2.Pot.OnDraw(Pot)

	//if not Pot.m_Initialized then return end
	Pot:DrawModel()

	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Pot:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end
	if not Pot.m_Initialized then return end
	if not LocalPlayer().zgo2_Initialized then return end

	local scale = Pot:GetModelScale()
	local min,max = Pot:GetRenderBounds()

	cam.Start3D2D(Pot:LocalToWorld(Vector(-max.y, 0, 15.5 * scale)), Pot:LocalToWorldAngles(ang), 0.03)
		local plant = Pot:GetPlant()
		if IsValid(plant) then
			zgo2.Pot.DrawStatus(Pot,plant)
		else
			local water_limit = zgo2.Pot.GetWaterLimit(Pot)
			local water_stored = Pot:GetWater()
			zgo2.util.DrawBar(300, 60, zclib.Materials.Get("zgo2_icon_water"), zclib.colors[ "blue02" ], 0, 140, (1 / water_limit) * water_stored)
			draw.SimpleText(water_limit .. "/" .. water_stored, zclib.GetFont("zclib_world_font_medium"), 0, 170, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end

function zgo2.Pot.Think(Pot)
	if not Pot.m_Initialized then return end
	if not LocalPlayer().zgo2_Initialized then return end

	if not zgo2.Pot.List[Pot] then
		zgo2.Pot.List[Pot] = true
	end

	// If the weed inside the bong changes then we need to update the weed material again
	if Pot:GetPotID() ~= Pot.LastPotID then
		Pot.LastPotID = Pot:GetPotID()
		Pot.UpdateMaterials = nil
	end
end

function zgo2.Pot.PreDraw()
	if not LocalPlayer().zgo2_Initialized then return end
    for ent,_ in pairs(zgo2.Pot.List) do
        if not IsValid(ent) then
			continue
		end

		if not ent.m_Initialized then continue end

        // If we cant see the Plant then skip
        if zclib.util.IsInsideViewCone(ent:GetPos(),EyePos(),EyeAngles(),1000,2000) == false then
			ent.UpdateMaterials = nil
            continue
        end

		if ent.UpdateMaterials then continue end
		ent.UpdateMaterials = true

		local PotData = zgo2.Pot.GetData(ent:GetPotID())
		if not PotData then continue end

		// Rebuild material to be save
		zgo2.Pot.RebuildMaterial(PotData)

		// Update world model texture
		zgo2.Pot.ApplyMaterial(ent,PotData)
    end
end
zclib.Hook.Remove("PreDrawHUD", "zgo2_pot_draw")
zclib.Hook.Add("PreDrawHUD", "zgo2_pot_draw", function() zgo2.Pot.PreDraw() end)
