zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}
zgo2.Plant.Editor = zgo2.Plant.Editor or {}

concommand.Add("zgo2_plant_editor", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        zgo2.Plant.Editor.MainMenu()
    end
end)

// Stores the plant data we are currently working on
local PlantData

// If we edit a existing config then this is the id we overwrite after saving
local OverwriteID

// The Root model of the plant
local PlantRoot

/*
    Updates the provided models lua materials
*/
local function UpdateMaterials()

	zgo2.Plant.RebuildMaterial(PlantData,true)

	timer.Simple(0,function()
		if not IsValid(PlantRoot) then return end
		// Update the root material
		zgo2.Plant.UpdateMaterial(PlantRoot,PlantData,true)
	end)
end

/*
	Update / Rebuild the models scale, bend, branch count
*/
local function UpdateModel()

	zgo2.Plant.Update(PlantRoot,PlantData,1)

	zclib.Timer.Remove("zgo2_editor_preview_update")
	zclib.Timer.Create("zgo2_editor_preview_update", 0.3, 1, function()
		if not IsValid(PlantRoot) then return end
		zgo2.Plant.Update(PlantRoot,PlantData,1)

		UpdateMaterials()

		zclib.Timer.Remove("zgo2_editor_preview_update")
	end)
end

/*
	This editor is special and only used for the plant editor
*/
local function DesignEditor(parent,DesignData,TextureList,MaterialID)

	local texture_DComboBox = zgo2.Editor.ComboBox(parent, DesignData.texture, function(index, value, pnl)
		DesignData.texture = pnl:GetOptionData(index)
		UpdateMaterials()
	end, function(s)
		s:SetValue(DesignData.texture)
	end)
	for k, v in ipairs(TextureList) do texture_DComboBox:AddChoice(v, v) end

	local pattern_DComboBox = zgo2.Editor.ComboBox(parent, zgo2.Plant.Patterns[DesignData.pattern_id].name, function(index, value, pnl)
		DesignData.pattern_id = pnl:GetOptionData(index)
		UpdateMaterials()
	end, function(s)
		s:SetValue(zgo2.Plant.Patterns[DesignData.pattern_id].name)
	end)
	for k, v in ipairs(zgo2.Plant.Patterns) do pattern_DComboBox:AddChoice(v.name, k) end


	zgo2.Editor.ColorMixer(parent, DesignData.color01,zgo2.language[ "Color01" ], false, function(col)
		DesignData.color01 = Color(col.r, col.g, col.b, 255)
		UpdateMaterials()
	end,function(s)
		s:SetColor(DesignData.color01)
	end)

	zgo2.Editor.ColorMixer(parent, DesignData.color02,zgo2.language[ "Color02" ], false, function(col)
		DesignData.color02 = Color(col.r, col.g, col.b, 255)
		UpdateMaterials()
	end,function(s)
		s:SetColor(DesignData.color02)
	end)

	local preview = vgui.Create("DPanel", parent)
	preview:SetSize(350 * zclib.wM, 350 * zclib.hM)
	preview:Dock(TOP)
	preview:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
	preview.Paint = function(s, w, h)
		zgo2.Plant.DrawTexture(w, h, DesignData.pattern_id, DesignData.texture, DesignData.color01, DesignData.color02,DesignData.x,DesignData.y)
	end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local SelectedPage = "whitelist"

/*
    Opens the Plant selection menu
*/
LocalPlayer().zgo2_plant_editor_showspliced = false
function zgo2.Plant.Editor.MainMenu()

	SelectedPage = "whitelist"

    zclib.vgui.Page(zgo2.language[ "Plant Selection" ], function(main, top)
        main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zgo2.language[ "Close" ])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

        local SelectedID = -1

        local function InvalidPlant() return not zgo2.Plant.GetData(SelectedID) end

        // Only admins can edit the skins
        if zclib.Player.IsAdmin(LocalPlayer()) then

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("delete"), zclib.colors["red01"], function()
                if SelectedID and zgo2.Plant.GetData(SelectedID) then

                    zgo2.vgui.ConfirmationWindow(zgo2.language[ "confirm_delete" ],function()
                        zgo2.config.Plants[SelectedID] = nil
                        SelectedID = nil

						// Update the config on the SERVER
						zclib.Data.UpdateConfig("zgo2_plant_config")

                        zgo2.vgui.Wait(zgo2.language[ "Plant Editor" ],function()
							zgo2.Plant.Editor.MainMenu()
						end)
                    end)
                end
            end, function() return InvalidPlant() end, zgo2.language[ "Delete" ])

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("edit"), zclib.colors["orange01"], function()
                if SelectedID and zgo2.Plant.GetData(SelectedID) then

					local FoundPlantData = zgo2.Plant.GetData(SelectedID)
					PlantData = table.Copy(FoundPlantData)
					PlantData = zgo2.Plant.VerifyData(PlantData)

					zgo2.Plant.RebuildMaterial(PlantData,true)

					OverwriteID = SelectedID

                    zgo2.Plant.Editor.Start()
                end
            end,function() return InvalidPlant() end,zgo2.language[ "Edit" ])

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("duplicate"), zclib.colors["blue02"], function()
                if SelectedID and zgo2.Plant.GetData(SelectedID) then

                    zgo2.vgui.ConfirmationWindow(zgo2.language[ "confirm_duplicate" ],function()
                        local m_PlantData = table.Copy(zgo2.Plant.GetData(SelectedID))
                        m_PlantData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
                        table.insert(zgo2.config.Plants,m_PlantData)

						// Update the config on the SERVER
						zclib.Data.UpdateConfig("zgo2_plant_config")

                        // NOTE We need to build the material before the snapshoter is gonna use it in the next frame to render the thumbnail
                        // Its something about the Imgur material not being present in the current frame

						// Build every single part of the plants material
						zgo2.Plant.RebuildMaterial(m_PlantData,true)

						zgo2.vgui.Wait(zgo2.language[ "Plant Editor" ],function()
							zgo2.Plant.Editor.MainMenu()
						end)
                    end)
                end
            end,function() return InvalidPlant() end,zgo2.language[ "Duplicate" ])

			zgo2.vgui.ImageButton(top, zclib.Materials.Get("clipboard"), zclib.colors[ "blue02" ], function()
				if SelectedID and zgo2.Plant.GetData(SelectedID) then
					// Copys/Formats the select plants data to the clipboard
					local dat = zgo2.Plant.GetData(SelectedID)
					if dat == nil then return end

					// Convert any job ids to job commands
					dat = zgo2.util.ConvertJobIDToCommand(dat)

					SetClipboardText(zgo2.Editor.BuildClipboard(dat,"AddPlant"))

					zclib.vgui.Notify(zgo2.language[ "ClipboardNotify" ], NOTIFY_GENERIC)
				end
			end, function() return InvalidPlant() end,  zgo2.language[ "ClipboardTooltip" ] )

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("plus"), zclib.colors["green01"], function()

				PlantData = {}
				PlantData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
		        PlantData = zgo2.Plant.VerifyData(PlantData)
				OverwriteID = nil

				zgo2.Plant.RebuildMaterial(PlantData,true)

				zgo2.vgui.Wait(zgo2.language[ "Plant Editor" ],function()
					zgo2.Plant.Editor.Start()
				end)
            end,function() return false end,zgo2.language[ "Create" ])

            local seperator = zclib.vgui.AddSeperator(top)
            seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
            seperator:Dock(RIGHT)
            seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

			zgo2.vgui.ImageButton(top, zclib.Materials.Get("zgo2_icon_splice"), zgo2.colors[ "violett01" ], function()
				LocalPlayer().zgo2_plant_editor_showspliced = not LocalPlayer().zgo2_plant_editor_showspliced
				zgo2.Plant.Editor.MainMenu()
			end, function() return false end, zgo2.language["DisplaySplicedPlantConfigs"])
        end

        local Machines_content = vgui.Create("DPanel", main)
        Machines_content:SetSize(1000 * zclib.wM, 1000 * zclib.hM)
        Machines_content:Dock(FILL)
        Machines_content:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
        Machines_content.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
            draw.RoundedBox(5, w - 15 * zclib.wM, 0, 15 * zclib.wM, h, zclib.colors["black_a50"])
        end

        local list,scroll = zclib.vgui.List(Machines_content)
        scroll:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        list:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        list:SetSpaceY( 10 * zclib.hM)
        list:SetSpaceX( 10 * zclib.wM)

		for k, v in pairs(zgo2.config.Plants) do

			// If the plant config is a spliced data one then ignore it
			if not LocalPlayer().zgo2_plant_editor_showspliced and zgo2.Plant.IsSplice(k) then continue end

			zgo2.vgui.PlantPanel(list, 205, k, v, function() return SelectedID == k end, function(id)
				SelectedID = id
			end,false)
		end
    end)
end

/*
    Opens the Plant editor
*/
local WindowMode = true
local Titles = {[ "whitelist" ] = zgo2.language[ "Stat Editor" ],[ "zgo2_icon_weed" ] = zgo2.language[ "Plant Editor" ],[ "zgo2_icon_seed" ] = zgo2.language[ "Seed Editor" ],[ "zgo2_icon_screeneffect" ] = zgo2.language[ "Effect Editor" ]}
local vec01 = Vector(0,0,-15)
local vec02 = Vector(15,0,-15)
local vec03 = Vector(0,5,5)
local vec04 = Vector(15,0,15)
local ang01 = Angle(0,90,0)
local ang02 = Angle(0,90,-90)
local sideLight = Color(200,200,200)
function zgo2.Plant.Editor.Start()
    zclib.vgui.Page(Titles[SelectedPage] or "nil", function(main, top)

		if WindowMode then
			main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)
			main:SetDraggable(true)
		else
			main:SetSize(ScrW(), ScrH())
			main:SetDraggable(false)
		end
		main:Center()

		local Randomizing = false

		top.OnRemove = function()
			zgo2.ScreenEffect.Stop()
			zgo2.ScreenEffect.StopMusic()
		end

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
			//zgo2.Plant.Editor.MainMenu()
            main:Close()
        end,function() return false end,zgo2.language["Close"])


		local windowButton = zgo2.vgui.ImageButton(top, zclib.Materials.Get("fullscreen"), zclib.colors[ "orange01" ], function(s)
			WindowMode = not WindowMode

			if WindowMode then
				main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)
				main:SetDraggable(true)
			else
				main:SetSize(ScrW(), ScrH())
				main:SetDraggable(false)
			end

			main:Center()
			s.IconImage = WindowMode and zclib.Materials.Get("fullscreen") or zclib.Materials.Get("minimize")
		end, function() return SelectedPage == "zgo2_icon_screeneffect" end)
		windowButton.IconImage = WindowMode and zclib.Materials.Get("fullscreen") or zclib.Materials.Get("minimize")

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("save"), zclib.colors["green01"], function()

            if OverwriteID then
                // Overwrite existing one
                zgo2.config.Plants[OverwriteID] = table.Copy(PlantData)

				// Send out net Message to all Clients to remove this file so it gets rebuild
				zclib.Snapshoter.Delete("zgo2/plant_" .. PlantData.uniqueid,true)
            else
                // Create new
                table.insert(zgo2.config.Plants,PlantData)
            end

			// Update the config on the SERVER
			zclib.Data.UpdateConfig("zgo2_plant_config")

            // NOTE We need to build the material before the snapshoter is gonna use it in the next frame to render the thumbnail
            // Its something about the Imgur material not being present in the current frame

			// Build every single part of the plants material
			zgo2.Plant.RebuildMaterial(PlantData,true)

			zgo2.vgui.Wait(zgo2.language[ "Plant Editor" ],function()
				zgo2.Plant.Editor.MainMenu()
			end)
        end,function() return false end, zgo2.language["Save"])

		local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		///////////////////////////////////////////////
		// Randomize the whole plant
		local RandomizeStart
		local RandomizeDur = 0
		local plant_rndstyle , plant_rndscreen
		local function RemoveRandomButtons()
			if IsValid(plant_rndstyle) then plant_rndstyle:Remove() end
			if IsValid(plant_rndscreen) then plant_rndscreen:Remove() end
		end
		local function RebuildRandomButtons()

			RemoveRandomButtons()

			if SelectedPage == "zgo2_icon_screeneffect" then
				plant_rndscreen = zgo2.vgui.ImageButton(top, zclib.Materials.Get("random"), zclib.colors["orange01"], function()

					PlantData = zgo2.Plant.RandomizeScreeneffectData(PlantData)

					zgo2.Editor.UpdateControlls()

					// Rebuild screeneffect
					zgo2.ScreenEffect.RebuildMaterial(PlantData,true)

					// Displays the screeneffect on the screen
					zgo2.ScreenEffect.Start(PlantData,true)

				end,function() return false end, zgo2.language[ "Randomize" ])
				return
			end

			if SelectedPage == "zgo2_icon_weed" then

				// Add anoter button to randomize the style only
				plant_rndstyle = zgo2.vgui.ImageButton(top, zclib.Materials.Get("random_style"), zclib.colors["orange01"], function()

					// Randomize data
					PlantData = zgo2.Plant.RandomizeStyleData(PlantData)

					// Update model
					UpdateModel()

					zgo2.Editor.UpdateControlls()
				end,function() return false end, zgo2.language[ "Randomize Style" ])
			end
		end
		///////////////////////////////////////////////

        local PageContent = vgui.Create("DPanel", main)
        PageContent:SetSize(1000 * zclib.wM, 800 * zclib.hM)
        PageContent:Dock(FILL)
        PageContent:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
        PageContent.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
        end

		local PreviewContent = vgui.Create("DPanel", PageContent)
		PreviewContent:Dock(FILL)
		PreviewContent:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		PreviewContent.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
		end

		///////////////////////////////////////////////
		local OptionsPnl = vgui.Create("DPanel", PageContent)
        OptionsPnl:SetSize(410 * zclib.wM, 800 * zclib.hM)
        OptionsPnl:Dock(LEFT)
        OptionsPnl:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
        OptionsPnl:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
        OptionsPnl.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"]) end

		local ButtonBox = vgui.Create("DPanel", OptionsPnl)
		ButtonBox:SetSize(410 * zclib.wM, 80 * zclib.hM)
		ButtonBox:Dock(TOP)
		ButtonBox.Paint = function(s, w, h) end
		ButtonBox:InvalidateLayout(true)
		ButtonBox:InvalidateParent(true)
		ButtonBox:InvalidateChildren(true)

		local ButtonWidth = ButtonBox:GetWide() / 4

		local OptionsContainer = vgui.Create("DPanel", OptionsPnl)
		OptionsContainer:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		OptionsContainer:SetSize(410 * zclib.wM, 800 * zclib.hM)
		OptionsContainer:Dock(FILL)
		OptionsContainer.Paint = function(s, w, h) end

		local Options
		local function RebuildOptions(content)
			if IsValid(Options) then Options:Remove() end

	        Options = vgui.Create("DCategoryList", OptionsContainer)
	        Options:SetSize(300 * zclib.wM, 200 * zclib.hM)
	        Options:DockPadding(0, 0 * zclib.hM, 0, 0 * zclib.hM)
	        Options:Dock(FILL)
	        Options.Paint = function(s, w, h) end
	        local sbar = Options:GetVBar()
	    	sbar:SetHideButtons(true)
	    	function sbar:Paint(w, h) draw.RoundedBox(5, w * 0.1, 0, w * 0.8, h, zclib.colors["black_a50"]) end
	    	function sbar.btnUp:Paint(w, h) end
	    	function sbar.btnDown:Paint(w, h) end
	        function sbar.btnGrip:Paint(w, h) draw.RoundedBox(5, w * 0.1, 0, w * 0.8, h, zclib.colors["text01"]) end

			pcall(content,Options)
		end

		local ButtonList = {}
		local function AddSwitchButton(icon)
			local btn = vgui.Create("DButton", ButtonBox)
			btn:SetText("")
			btn:SetWide(ButtonWidth)
			btn:SetTall(ButtonWidth)
			btn:Dock(LEFT)
			btn.Paint = function(s, w, h)

				draw.RoundedBox(10, w * 0.1, h * 0.1, w * 0.8, h * 0.8, zclib.colors[ "black_a50" ])

				surface.SetDrawColor(SelectedPage == icon and zclib.colors["blue02"] or zclib.colors["text01"])
				surface.SetMaterial(zclib.Materials.Get(icon))
				surface.DrawTexturedRectRotated(w / 2, h / 2, h, h, 0)

				if s:IsHovered() then
					surface.SetDrawColor(zclib.colors[ "white_a15" ])
					surface.SetMaterial(zclib.Materials.Get(icon))
					surface.DrawTexturedRectRotated(w / 2, h / 2, h, h, 0)
				end
			end
			btn.DoClick = function(s)
				zclib.vgui.PlaySound("UI/buttonclick.wav")
				SelectedPage = icon
				zgo2.Plant.Editor.Start()
			end
			ButtonList[icon] = btn

			if SelectedPage == nil then
				SelectedPage = icon
			end
		end
		///////////////////////////////////////////////

		// Creates either a 3d or 2d preview
		local preview
		local function BuildPreview()

			// CleanUp previews stuff

			if preview and IsValid(preview.PotModel) then
				preview.PotModel:Remove()
			end

			if preview and IsValid(preview.Photowall) then
				preview.Photowall:Remove()
			end

			if IsValid(preview) then preview:Remove() end

			zgo2.ScreenEffect.Stop()

			///////////////////////////////////////////////

			if SelectedPage == "zgo2_icon_screeneffect" then

				main:SetWide(650 * zclib.wM)

				PreviewContent:Remove()

				OptionsPnl:Dock(FILL)

				main:InvalidateLayout(true)
				main:SizeToChildren(true,false)

				main:Center()
				main:SetX(ScrW() - 700 * zclib.wM)

				// Displays the screeneffect on the screen
				zgo2.ScreenEffect.Start(PlantData,true)

				// We dont need the music to auto play in this case
				zgo2.ScreenEffect.StopMusic()

				// Rebuild screeneffect
				zgo2.ScreenEffect.RebuildMaterial(PlantData,true)

				return
			end

			main:SetWide(1200 * zclib.wM)

			local mdl = SelectedPage == "zgo2_icon_seed" and "models/zerochain/props_growop2/zgo2_weedseeds.mdl" or "models/zerochain/props_growop2/zgo2_plant_root.mdl"

			preview = zclib.vgui.DAdjustableModelPanel({model = mdl})
			preview:SetFOV(20)
			preview:OnMouseWheeled( -40 )
			preview:SetParent(PreviewContent)
			preview:Dock(FILL)

			preview:SetDirectionalLight(BOX_TOP, color_white)
			preview:SetDirectionalLight(BOX_FRONT, sideLight)
			preview:SetDirectionalLight(BOX_BACK, sideLight)
			preview:SetDirectionalLight(BOX_LEFT, sideLight)
			preview:SetDirectionalLight(BOX_RIGHT, sideLight)

			preview:OnMousePressed( MOUSE_LEFT )
			timer.Simple(0.1,function() if IsValid(preview) then preview:OnMouseReleased( MOUSE_LEFT ) end end)

			PlantRoot = preview.Entity
			PlantRoot.IsEditor = true

			local function SimpleTextBox(txt, color, font, x, y)
				local txtWidth, txtHeight = zclib.util.GetTextSize(txt, font)
				txtWidth = txtWidth + 20 * zclib.wM
				txtHeight = txtHeight + 5 * zclib.hM
				draw.RoundedBox(5, x - 10 * zclib.wM, y, txtWidth, txtHeight, zclib.colors["black_a100"])
				draw.SimpleText(txt, font, x, y + 3 * zclib.hM, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end

			function preview:PreDrawModel(ent)

				cam.Start2D()
					surface.SetDrawColor(zclib.colors["text01"])
					surface.SetMaterial(zclib.Materials.Get("zgo2_editor_bg"))
					surface.DrawTexturedRect(0, 0, preview:GetWide(), preview:GetTall())
				cam.End2D()

				if SelectedPage == "whitelist" or SelectedPage == "zgo2_icon_weed" then
					// Draw pot
					if not IsValid(self.PotModel) then
						self.PotModel = zclib.ClientModel.Add("models/zerochain/props_growop2/zgo2_pot01.mdl", RENDERGROUP_OTHER)
						self.PotModel:SetLOD( 0 )
						self.PotModel:SetBodygroup(0,1)
						self.PotModel:SetSkin(1)
					else
						render.Model({
							model = self.PotModel:GetModel(),
							pos = vec01,
							angle = angle_zero
						}, self.PotModel)
					end

					// Draw background wall
					if not IsValid(self.Photowall) then
						self.Photowall = zclib.ClientModel.Add("models/zerochain/props_growop2/zgo2_photowall.mdl", RENDERGROUP_OTHER)
						self.Photowall:SetLOD( 0 )
					else
						render.Model({
							model = self.Photowall:GetModel(),
							pos = vec02,
							angle = ang01
						}, self.Photowall)
					end
				end
			end

			function preview:PostDrawModel(ent)
				cam.Start2D()

					if Randomizing then
						local w,h = preview:GetWide(), preview:GetTall()

						surface.SetDrawColor(zclib.colors[ "text01" ])
						surface.SetMaterial(zclib.Materials.Get("zgo2_editor_bg"))
						surface.DrawTexturedRect(0, 0, w, h)

						draw.RoundedBox(5, 0, 0, w, h, zclib.colors[ "black_a100" ])

						draw.SimpleText(zgo2.language[ "Randomizing" ], zclib.GetFont("zclib_font_big"), w / 2, h / 2 + 200 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

						if RandomizeStart then
							draw.RoundedBox(5, (w / 2) - w * 0.4, h / 2 + 300 * zclib.hM, w * 0.8, 16 * zclib.hM, zclib.colors[ "black_a100" ])
							local barW = ((w * 0.8) / RandomizeDur) * (CurTime() - RandomizeStart)
							barW = math.Clamp(barW, 0, w * 0.8)
							draw.RoundedBox(5, w / 2 - w * 0.4, h / 2 + 300 * zclib.hM, barW, 16 * zclib.hM, color_white)
						end
					else

						local name = PlantData.name
						if name then
							SimpleTextBox(name, zclib.colors["orange01"], zclib.GetFont("zclib_font_big"), 7 * zclib.wM, 10 * zclib.hM)
						end

						if SelectedPage == "whitelist" then
							local w,h = preview:GetWide(), preview:GetTall()
							draw.RoundedBox(5, 0, h - 80 * zclib.hM, w, 80 * zclib.hM, zclib.colors["black_a200"])
						end
					end
				cam.End2D()
			end

			function preview:OnRemove()
				if IsValid(self.PotModel) then
					self.PotModel:Remove()
				end
				if IsValid(self.Photowall) then
					self.Photowall:Remove()
				end
			end

			if SelectedPage == "whitelist" then zgo2.vgui.Restriction(preview,PlantData) end

			if SelectedPage == "zgo2_icon_seed" then
				// Set seedbox model
				preview.Entity:SetSubMaterial()
				preview.Entity:SetAngles(ang02)
				preview.Entity:SetPos(vec03)

				timer.Simple(0.01,function()
					if IsValid(preview) then
						preview:SetCamPos(vec04)
						preview:SetLookAt(vector_origin)
						preview:SetLookAng(angle_zero)

						preview:OnMousePressed( MOUSE_LEFT )
					end
					timer.Simple(0.1,function() if IsValid(preview) then preview:OnMouseReleased( MOUSE_LEFT ) end end)
				end)

				// Apply the seedbox texture
				zgo2.Seed.UpdateMaterial(preview.Entity,PlantData,true)
			else
				UpdateModel()
			end
		end

		// Display all the technical stats about the plant
		AddSwitchButton("whitelist")
		if SelectedPage == "whitelist" then
			timer.Simple(0,BuildPreview)

			RebuildRandomButtons()

			RebuildOptions(function(cat_list)
				zgo2.Editor.CategoryBox(cat_list,zgo2.language["Basic"],function(parent)

					zgo2.Editor.TextEntry(parent, zgo2.language["Name"] .. ":", PlantData.name, function(val)
						PlantData.name = val
					end)

					zgo2.Editor.Numslider(parent, PlantData.sell.value, string.Replace(zgo2.language[ "MoneyPer" ],"$Unit",zgo2.config.UoM), function(val)
						PlantData.sell.value = math.Round(val)
					end, 1, 1000, 0,function(s)
						s:SetValue(PlantData.sell.value)
					end)

					zgo2.vgui.Button(parent,zgo2.language["Rank Restriction"],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["orange01"], function()
						zgo2.vgui.ListEditor(PlantData,zgo2.language["Rank Restriction"],"ranks",zclib.colors["orange01"],function()
							zgo2.Plant.Editor.Start()
						end,function(data)
							PlantData = data
						end)
					end)

					zgo2.vgui.Button(parent,zgo2.language["Job Restriction"],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["blue02"], function()
						zgo2.vgui.ListEditor(PlantData,zgo2.language["Job Restriction"],"jobs",zclib.colors["blue02"],function()
							zgo2.Plant.Editor.Start()
						end,function(data)
							PlantData = data
						end)
					end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Grow Stats" ],function(parent)

					zgo2.Editor.Numslider(parent, PlantData.grow.time, zgo2.language[ "Grow Time" ] .. ":", function(val)
						PlantData.grow.time = math.Round(val)
					end, zgo2.config.Plant.grow_time.min, zgo2.config.Plant.grow_time.max, 0,function(s)
						s:SetValue(PlantData.grow.time)
					end)

					zgo2.Editor.Numslider(parent, PlantData.grow.water, zgo2.language[ "Water" ] .. ":", function(val)
						PlantData.grow.water = math.Round(val)
					end, zgo2.config.Plant.water_need.min, zgo2.config.Plant.water_need.max, 0,function(s)
						s:SetValue(PlantData.grow.water)
					end)

					zgo2.Editor.CategorySeperator(parent)

					local pref_lightcolor_color

					zgo2.Editor.CheckBox(parent, PlantData.grow.pref_lightcolor_req, zgo2.language[ "RequiereLightcolor" ], function()
						PlantData.grow.pref_lightcolor_req = not PlantData.grow.pref_lightcolor_req
						pref_lightcolor_color:SetDisabled(not PlantData.grow.pref_lightcolor_req)
					end,function(s)
						s:SetValue(PlantData.grow.pref_lightcolor_req)
						pref_lightcolor_color:SetDisabled(not PlantData.grow.pref_lightcolor_req)
					end)

					pref_lightcolor_color = zgo2.Editor.ColorMixer(parent, PlantData.grow.pref_lightcolor_color,zgo2.language[ "Lightcolor" ], false, function(col)
						PlantData.grow.pref_lightcolor_color = Color(col.r, col.g, col.b, 255)
					end,function(s)
						s:SetColor(PlantData.grow.pref_lightcolor_color)
					end)
					pref_lightcolor_color.PaintOver = function(s,w,h)
						if not PlantData.grow.pref_lightcolor_req then
							draw.RoundedBox(4, 0, 0, w, h, zclib.colors["black_a200"])
						end
					end
					pref_lightcolor_color:SetDisabled(not PlantData.grow.pref_lightcolor_req)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Weed Stats" ],function(parent)

					zgo2.Editor.Numslider(parent, PlantData.weed.amount, zgo2.language[ "Amount" ] .. ":", function(val)
						PlantData.weed.amount = math.Round(val)
					end, zgo2.config.Plant.weed_amount.min, zgo2.config.Plant.weed_amount.max, 0,function(s)
						s:SetValue(PlantData.weed.amount)
					end)

					zgo2.Editor.Numslider(parent, PlantData.weed.thc, zgo2.language[ "THC" ] .. ":", function(val)
						PlantData.weed.thc = math.Round(val)
					end, 1, 100, 0,function(s)
						s:SetValue(PlantData.weed.thc)
					end)
				end)
			end)
		end

		// Display all the mesh / style options
		AddSwitchButton("zgo2_icon_weed")
		if SelectedPage == "zgo2_icon_weed" then
			timer.Simple(0,BuildPreview)

			RebuildRandomButtons()

			RebuildOptions(function(cat_list)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Mesh" ],function(parent)

					// Select which model
					local PlantMesh_DComboBox = zgo2.Editor.ComboBox(parent, zgo2.language[ "Mesh" ] .. " - " .. PlantData.style.mesh, function(index, value, pnl)

						PlantData.style.mesh = pnl:GetOptionData(index)

						PlantRoot:SetModel(zgo2.Plant.GetMesh(PlantData))

						local mdl = zgo2.Plant.Shapes[PlantData.style.mesh]
						zclib.CacheModel(mdl)
						UpdateModel()
					end, function(s)
						s:SetValue(PlantData.style.mesh)
					end)
					for k, v in ipairs(zgo2.Plant.Shapes) do PlantMesh_DComboBox:AddChoice(zgo2.language[ "Mesh" ] .. " - " .. k, k) end

					zgo2.Editor.Numslider(parent, PlantData.style.scale, zgo2.language[ "Scale" ] .. ":", function(val)
						PlantData.style.scale = math.Round(val,2)
						UpdateModel()
					end, 0.5, 2, 2,function(s)
						s:SetValue(PlantData.style.scale)
					end)

					zgo2.Editor.Numslider(parent, PlantData.style.width, zgo2.language[ "Width" ] .. ":", function(val)
						PlantData.style.width = math.Round(val,2)
						UpdateModel()
					end, 0.5, 1.5, 2,function(s)
						s:SetValue(PlantData.style.width)
					end)

					zgo2.Editor.Numslider(parent, PlantData.style.height, zgo2.language[ "Height" ] .. ":", function(val)
						PlantData.style.height = math.Round(val,2)
						UpdateModel()
					end, 0.5, 1.5, 2,function(s)
						s:SetValue(PlantData.style.height)
					end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Style - Stem" ],function(parent)
					DesignEditor(parent,PlantData.style.stem,zgo2.Plant.Stems,"zgo2_plant_stem_" .. PlantData.uniqueid)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Style - Leaf01" ],function(parent)
					DesignEditor(parent,PlantData.style.leaf01,zgo2.Plant.Leafs,"zgo2_plant_leaf01_" .. PlantData.uniqueid)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Style - Leaf02" ],function(parent)
					DesignEditor(parent,PlantData.style.leaf02,zgo2.Plant.Leafs,"zgo2_plant_leaf02_" .. PlantData.uniqueid)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Style - Bud" ],function(parent)
					DesignEditor(parent,PlantData.style.bud,zgo2.Plant.Buds,"zgo2_plant_bud_" .. PlantData.uniqueid)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Style - Hair" ],function(parent)
					DesignEditor(parent,PlantData.style.hair,zgo2.Plant.BudHair,"zgo2_plant_hair_" .. PlantData.uniqueid)
				end)
			end)
		end

		// Display all the options for the seed / seedbox
		AddSwitchButton("zgo2_icon_seed")
		if SelectedPage == "zgo2_icon_seed" then
			timer.Simple(0,BuildPreview)

			RebuildRandomButtons()

			local function UpdateMaterial()
				zgo2.Seed.UpdateMaterial(preview.Entity,PlantData,true)
			end

			RebuildOptions(function(cat_list)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Main" ],function(parent)

					zgo2.Editor.ColorMixer(parent, PlantData.style.seedbox.main_color,zgo2.language[ "Color" ], false, function(col)
						PlantData.style.seedbox.main_color = Color(col.r, col.g, col.b, 255)
						UpdateMaterial()
					end,function(s)
						s:SetColor(PlantData.style.seedbox.main_color)
					end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Title" ],function(parent)

					zgo2.Editor.CheckBox(parent, PlantData.style.seedbox.title_enabled, zgo2.language[ "Display" ], function()
						PlantData.style.seedbox.title_enabled = not PlantData.style.seedbox.title_enabled
						UpdateMaterial()
					end,function(s)
						s:SetValue(PlantData.style.seedbox.title_enabled)
					end)

					zgo2.Editor.TextEntry(parent, zgo2.language["Name"] .. ":", PlantData.name, function(val)
						PlantData.name = val
						UpdateMaterial()
					end)

					zgo2.Editor.ColorMixer(parent, PlantData.style.seedbox.title_color,zgo2.language[ "Color" ], false, function(col)
						PlantData.style.seedbox.title_color = Color(col.r, col.g, col.b, 255)
						UpdateMaterial()
					end,function(s)
						s:SetColor(PlantData.style.seedbox.title_color)
					end)

					local CurrentSelectedID = 1
					local font_DComboBox = zgo2.Editor.ComboBox(parent, PlantData.style.seedbox.title_font, function(index, value, pnl)
						PlantData.style.seedbox.title_font = pnl:GetOptionData(index)
						CurrentSelectedID = index
						UpdateMaterial()
					end, function(s)
						s:SetValue(PlantData.style.seedbox.title_font)
					end)
					for k, v in pairs(zgo2.TrackedFonts) do font_DComboBox:AddChoice(k, k) end

					// This junk of code lets the player switch through the fonts using the UP / DOWN Arrow Keys
					font_DComboBox.Think = function(s)
						if s:IsMenuOpen() and (s.NextAction == nil or CurTime() > s.NextAction) then
							if input.IsKeyDown(KEY_UP) then
								CurrentSelectedID = CurrentSelectedID - 1

								if CurrentSelectedID <= 0 then
									CurrentSelectedID = table.Count(zgo2.TrackedFonts)
								end

								font_DComboBox:ChooseOptionID(CurrentSelectedID)
								font_DComboBox:OpenMenu()
								s.NextAction = CurTime() + 0.25
							elseif input.IsKeyDown(KEY_DOWN) then
								CurrentSelectedID = CurrentSelectedID + 1

								if CurrentSelectedID > table.Count(zgo2.TrackedFonts) then
									CurrentSelectedID = 1
								end

								font_DComboBox:ChooseOptionID(CurrentSelectedID)
								font_DComboBox:OpenMenu()
								s.NextAction = CurTime() + 0.25
							end
						end
					end


					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.title_pos_x,zgo2.language["PositionX"],function(val)
						PlantData.style.seedbox.title_pos_x = val
						UpdateMaterial()
					end,0,1,2,function(s)
						s:SetValue(PlantData.style.seedbox.title_pos_x)
					end)

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.title_pos_y,zgo2.language["PositionY"],function(val)
						PlantData.style.seedbox.title_pos_y = val
						UpdateMaterial()
					end,0,1,2,function(s)
						s:SetValue(PlantData.style.seedbox.title_pos_y)
					end)
				end)

				local LastFrame = CurTime()
				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Imgur" ],function(parent)

					zgo2.Editor.ColorMixer(parent, PlantData.style.seedbox.imgur_color,zgo2.language[ "Color" ], true, function(col)
						PlantData.style.seedbox.imgur_color = Color(col.r, col.g, col.b, col.a)
						UpdateMaterial()
					end,function(s)
						s:SetColor(PlantData.style.seedbox.imgur_color)
					end)

					zgo2.Editor.BlendMode(parent, PlantData.style.seedbox.imgur_blendmode or "Multiply", function(index, value, pnl)
						local val = pnl:GetOptionData(index)
						PlantData.style.seedbox.imgur_blendmode = val
						UpdateMaterial()
					end)

					local Entry = zgo2.vgui.ImgurEntry(parent,zgo2.language["ImgurID"],function(val,txt)
						PlantData.style.seedbox.imgur_url = val

						zclib.Imgur.GetMaterial(tostring(PlantData.style.seedbox.imgur_url), function(result)
							if not result then
								PlantData.style.seedbox.imgur_url = nil
							end

							UpdateMaterial()
						end)

						if LastFrame ~= CurTime() then
							txt:SetValue(PlantData.style.seedbox.imgur_url)
							LastFrame = CurTime()
						end
					end)
					if PlantData.style.seedbox.imgur_url then
						Entry:SetValue(PlantData.style.seedbox.imgur_url)
					end

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.imgur_pos_x,zgo2.language["PositionX"],function(val)
						PlantData.style.seedbox.imgur_pos_x = val
						UpdateMaterial()
					end,0,1,2,function(s)
						s:SetValue(PlantData.style.seedbox.imgur_pos_x)
					end)

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.imgur_pos_y,zgo2.language["PositionY"],function(val)
						PlantData.style.seedbox.imgur_pos_y = val
						UpdateMaterial()
					end,0,1,2,function(s)
						s:SetValue(PlantData.style.seedbox.imgur_pos_y)
					end)

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.imgur_scale,zgo2.language["Scale"],function(val)
						PlantData.style.seedbox.imgur_scale = val
						UpdateMaterial()
					end,0.1,15,2,function(s)
						s:SetValue(PlantData.style.seedbox.imgur_scale)
					end)

					if PlantData and PlantData.style.seedbox.imgur_url then
						zclib.Imgur.GetMaterial(tostring(PlantData.style.seedbox.imgur_url), function(result)
							if result then
								UpdateMaterial()
							end
						end)
					end
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language["Shine"],function(parent)

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.phongexponent,zgo2.language["Exponent"],function(val)
						PlantData.style.seedbox.phongexponent = val
						UpdateMaterial()
					end,1,25,2,function(s)
						s:SetValue(PlantData.style.seedbox.phongexponent)
					end)

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.phongboost,zgo2.language["Boost"],function(val)
						PlantData.style.seedbox.phongboost = val
						UpdateMaterial()
					end,0,25,2,function(s)
						s:SetValue(PlantData.style.seedbox.phongboost)
					end)

					zgo2.Editor.ColorMixer(parent, PlantData.style.seedbox.phongtint,zgo2.language["Tint"], false, function(col)
						PlantData.style.seedbox.phongtint = col
						UpdateMaterial()
					end,function(s)
						s:SetColor(PlantData.style.seedbox.phongtint)
					end)

					zgo2.Editor.Numslider(parent,PlantData.style.seedbox.fresnel,zgo2.language["Fresnel"],function(val)
						PlantData.style.seedbox.fresnel = val
						UpdateMaterial()
					end,0,3,2,function(s)
						s:SetValue(PlantData.style.seedbox.fresnel)
					end)
				end)


				local material = CreateMaterial("zgo2_seedbox_editor_texture", "VertexLitGeneric", {[ "$basetexture" ] = ""})

				local _2dpreview = vgui.Create("DButton", cat_list)
				_2dpreview:SetText("")
				_2dpreview:SetSize(350 * zclib.wM, 350 * zclib.hM)
				_2dpreview:Dock(TOP)
				_2dpreview:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
				_2dpreview.DrawUV = false
				_2dpreview.Paint = function(s, w, h)
					if material and zgo2.Seed.CachedMaterials[ "zgo2_seedbox_editor" ] then
						material:SetTexture("$basetexture", zgo2.Seed.CachedMaterials[ "zgo2_seedbox_editor" ]:GetTexture("$basetexture"))
					end

					surface.SetDrawColor(color_white)
					surface.SetMaterial(material)
					surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)

					if s.DrawUV then
						surface.SetDrawColor(color_white)
						surface.SetMaterial(zclib.Materials.Get("zgo2_icon_seedbox_uv"))
						surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)
					end
				end
				_2dpreview.DoClick = function(s)
					zclib.vgui.PlaySound("UI/buttonclick.wav")
					s.DrawUV = not s.DrawUV
				end
			end)
		end

		// Display all the options for the visual effect
		AddSwitchButton("zgo2_icon_screeneffect")
		if SelectedPage == "zgo2_icon_screeneffect" then
			timer.Simple(0,BuildPreview)

			RebuildRandomButtons()

			// Rebuilt option list to only show plant options
			RebuildOptions(function(cat_list)

				local function UpdateScreenEffect()
					// Rebuild screeneffect
					zgo2.ScreenEffect.RebuildMaterial(PlantData,true)

					// Displays the screeneffect on the screen
					zgo2.ScreenEffect.Start(PlantData,true)

					zgo2.ScreenEffect.StopMusic()
				end

				local LastFrame = CurTime()

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Texture" ],function(parent)

					zgo2.Editor.ColorMixer(parent, PlantData.screeneffect.basetexture_color,zgo2.language[ "Color" ], false, function(col)

						PlantData.screeneffect.basetexture_color = Color(col.r, col.g, col.b, 255)
						UpdateScreenEffect()
					end,function(s)
						s:SetColor(PlantData.screeneffect.basetexture_color)
					end)

					zgo2.Editor.ImageGallery(parent,PlantData.screeneffect.basetexture_url,function(val,txt)
						PlantData.screeneffect.basetexture_url = val
						zclib.Imgur.GetMaterial(tostring(PlantData.screeneffect.basetexture_url), function(result)
							UpdateScreenEffect()
						end)

						if LastFrame ~= CurTime() then
							txt:SetValue(PlantData.screeneffect.basetexture_url)
							LastFrame = CurTime()
						end
					end,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_url)
					end,1000 * zclib.wM)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_scale,zgo2.language["Scale"], function(val)
						PlantData.screeneffect.basetexture_scale = val
						UpdateScreenEffect()
					end, 0.1, 15, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_scale)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_alpha,zgo2.language[ "Alpha" ], function(val)
						PlantData.screeneffect.basetexture_alpha = val
						UpdateScreenEffect()
					end, 0, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_alpha)
					end)

					zgo2.Editor.CategorySeperator(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_spin_speed,zgo2.language[ "Spin - Speed" ], function(val)
						PlantData.screeneffect.basetexture_spin_speed = val
						UpdateScreenEffect()
					end, -360, 360, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_spin_speed)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_spin_snap,zgo2.language[ "Spin - Step" ], function(val)
						PlantData.screeneffect.basetexture_spin_snap = val
						UpdateScreenEffect()
					end, 0, 360, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_spin_snap)
					end)

					zgo2.Editor.CategorySeperator(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_blink_interval,zgo2.language[ "Blink - Interval" ], function(val)
						PlantData.screeneffect.basetexture_blink_interval = val
						UpdateScreenEffect()
					end, 0, 3, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_blink_interval)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_blink_min,zgo2.language[ "Blink - Min" ], function(val)
						PlantData.screeneffect.basetexture_blink_min = val
						UpdateScreenEffect()
					end, 0, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_blink_min)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_blink_max,zgo2.language[ "Blink - Max" ], function(val)
						PlantData.screeneffect.basetexture_blink_max = val
						UpdateScreenEffect()
					end, 0.1, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_blink_max)
					end)

					zgo2.Editor.CategorySeperator(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_bounce_interval,zgo2.language[ "Bounce - Interval" ], function(val)
						PlantData.screeneffect.basetexture_bounce_interval = val
						UpdateScreenEffect()
					end, 0, 3, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_bounce_interval)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_bounce_min,zgo2.language[ "Bounce - Min" ], function(val)
						PlantData.screeneffect.basetexture_bounce_min = val
						UpdateScreenEffect()
					end, 0, 15, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_bounce_min)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.basetexture_bounce_max,zgo2.language[ "Bounce - Max" ], function(val)
						PlantData.screeneffect.basetexture_bounce_max = val
						UpdateScreenEffect()
					end, 0, 15, 2,function(s)
						s:SetValue(PlantData.screeneffect.basetexture_bounce_max)
					end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Warp (Normalmap Refraction)" ],function(parent)

					zgo2.Editor.ColorMixer(parent, PlantData.screeneffect.refract_tint,zgo2.language[ "Color" ], false, function(col)

						PlantData.screeneffect.refract_tint = Color(col.r, col.g, col.b, 255)

						UpdateScreenEffect()
					end,function(s)
						s:SetColor(PlantData.screeneffect.refract_tint)
					end)

					zgo2.Editor.ImageGallery(parent,PlantData.screeneffect.refract_url,function(val,txt)
						PlantData.screeneffect.refract_url = val
						zclib.Imgur.GetMaterial(tostring(PlantData.screeneffect.refract_url), function(result)
							UpdateScreenEffect()
						end)

						if LastFrame ~= CurTime() then
							txt:SetValue(PlantData.screeneffect.refract_url)
							LastFrame = CurTime()
						end
					end,function(s)
						s:SetValue(PlantData.screeneffect.refract_url)
					end,1000 * zclib.wM)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_scale,zgo2.language["Scale"], function(val)
						PlantData.screeneffect.refract_scale = val
						UpdateScreenEffect()
					end, 0.1, 15, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_scale)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_ref,zgo2.language[ "Refraction" ], function(val)
						PlantData.screeneffect.refract_ref = val
						UpdateScreenEffect()
					end, 0, 1, 3,function(s)
						s:SetValue(PlantData.screeneffect.refract_ref)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_blur,zgo2.language[ "Blur" ], function(val)
						PlantData.screeneffect.refract_blur = val
						UpdateScreenEffect()
					end, 0, 3, 0,function(s)
						s:SetValue(PlantData.screeneffect.refract_blur)
					end)

					zgo2.Editor.CategorySeperator(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_spin_speed,zgo2.language[ "Spin - Speed" ], function(val)
						PlantData.screeneffect.refract_spin_speed = val
						UpdateScreenEffect()
					end, -360, 360, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_spin_speed)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_spin_snap,zgo2.language[ "Spin - Step" ], function(val)
						PlantData.screeneffect.refract_spin_snap = val
						UpdateScreenEffect()
					end, 0, 360, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_spin_snap)
					end)

					zgo2.Editor.CategorySeperator(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_blink_interval,zgo2.language[ "Blink - Interval" ], function(val)
						PlantData.screeneffect.refract_blink_interval = val
						UpdateScreenEffect()
					end, 0, 3, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_blink_interval)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_blink_min,zgo2.language[ "Blink - Min" ], function(val)
						PlantData.screeneffect.refract_blink_min = val
						UpdateScreenEffect()
					end, 0, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_blink_min)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_blink_max,zgo2.language[ "Blink - Max" ], function(val)
						PlantData.screeneffect.refract_blink_max = val
						UpdateScreenEffect()
					end, 0.1, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_blink_max)
					end)

					zgo2.Editor.CategorySeperator(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_bounce_interval,zgo2.language[ "Bounce - Interval" ], function(val)
						PlantData.screeneffect.refract_bounce_interval = val
						UpdateScreenEffect()
					end, 0, 3, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_bounce_interval)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_bounce_min,zgo2.language[ "Bounce - Min" ], function(val)
						PlantData.screeneffect.refract_bounce_min = val
						UpdateScreenEffect()
					end, 0, 15, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_bounce_min)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.refract_bounce_max,zgo2.language[ "Bounce - Max" ], function(val)
						PlantData.screeneffect.refract_bounce_max = val
						UpdateScreenEffect()
					end, 0, 15, 2,function(s)
						s:SetValue(PlantData.screeneffect.refract_bounce_max)
					end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Bloom" ],function(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.bloom_darken,zgo2.language[ "Darken" ], function(val)
						PlantData.screeneffect.bloom_darken = val
					end, -1, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.bloom_darken)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.bloom_multiply,zgo2.language[ "Multiply" ], function(val)
						PlantData.screeneffect.bloom_multiply = val
					end, 0, 100, 2,function(s)
						s:SetValue(PlantData.screeneffect.bloom_multiply)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.bloom_sizex,zgo2.language[ "SizeX" ], function(val)
						PlantData.screeneffect.bloom_sizex = val
					end, 0, 100, 2,function(s)
						s:SetValue(PlantData.screeneffect.bloom_sizex)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.bloom_sizey,zgo2.language[ "SizeY" ], function(val)
						PlantData.screeneffect.bloom_sizey = val
					end, 0, 100, 2,function(s)
						s:SetValue(PlantData.screeneffect.bloom_sizey)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.bloom_passes,zgo2.language[ "Passes" ], function(val)
						PlantData.screeneffect.bloom_passes = math.Round(val)
					end, 1, 10, 0,function(s)
						s:SetValue(PlantData.screeneffect.bloom_passes)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.bloom_colormul,zgo2.language[ "ColorMultiply" ], function(val)
						PlantData.screeneffect.bloom_colormul = val
					end, 1, 100, 2,function(s)
						s:SetValue(PlantData.screeneffect.bloom_colormul)
					end)

					zgo2.Editor.ColorMixer(parent, PlantData.screeneffect.bloom_color,zgo2.language[ "Color" ], false, function(col)
						PlantData.screeneffect.bloom_color = Color(col.r, col.g, col.b, 255)
					end,function(s) s:SetColor(PlantData.screeneffect.bloom_color) end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Motion Blur" ],function(parent)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.mblur_addalpha,zgo2.language[ "AddAlpha" ], function(val)
						PlantData.screeneffect.mblur_addalpha = val
					end, 0, 50, 2,function(s)
						s:SetValue(PlantData.screeneffect.mblur_addalpha)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.mblur_drawalpha,zgo2.language[ "DrawAlpha" ], function(val)
						PlantData.screeneffect.mblur_drawalpha = val
					end, 0, 1, 2,function(s)
						s:SetValue(PlantData.screeneffect.mblur_drawalpha)
					end)

					zgo2.Editor.Numslider(parent, PlantData.screeneffect.mblur_delay,zgo2.language[ "Delay" ], function(val)
						PlantData.screeneffect.mblur_delay = val
					end, 0, 3, 2,function(s)
						s:SetValue(PlantData.screeneffect.mblur_delay)
					end)
				end)

				zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Audio" ],function(parent)

					local DSP_List = {
						[ 0 ] = "DSP [OFF]",
						[ 1 ] = "Generic",
						[ 2 ] = "Metal Small",
						[ 3 ] = "Metal Medium",
						[ 4 ] = "Metal Large",
						[ 5 ] = "Tunnel Small",
						[ 6 ] = "Tunnel Medium",
						[ 7 ] = "Tunnel Large",
						[ 8 ] = "Chamber Small",
						[ 9 ] = "Chamber Medium",
						[ 10 ] = "Chamber Large",
						[ 11 ] = "Bright Small",
						[ 12 ] = "Bright Medium",
						[ 13 ] = "Bright Large",
						[ 14 ] = "Water 1",
						[ 15 ] = "Water 2",
						[ 16 ] = "Water 3",
						[ 17 ] = "Concrete Small",
						[ 18 ] = "Concrete Medium",
						[ 19 ] = "Concrete Large",
						[ 20 ] = "Big 1",
						[ 21 ] = "Big 2",
						[ 22 ] = "Big 3",
						[ 23 ] = "Cavern Small",
						[ 24 ] = "Cavern Medium",
						[ 25 ] = "Cavern Large",
						[ 26 ] = "Weirdo 1",
						[ 27 ] = "Weirdo 2",
						[ 28 ] = "Weirdo 3",
						[ 29 ] = "Weirdo 4",
						[ 30 ] = "Lowpass",
						[ 31 ] = "Lowpass",
						[ 32 ] = "Explosion ring 1",
						[ 33 ] = "Explosion ring 2",
						[ 34 ] = "Explosion ring 3",
						[ 35 ] = "Shock muffle 1",
						[ 36 ] = "Shock muffle 2",
						[ 37 ] = "Shock muffle 3",
						[ 38 ] = "Distorted speaker 0",
						[ 39 ] = "Strider pre-fire",
						[ 40 ] = "player spatial (wall) delay",
						[ 41 ] = "spatial delay",
						[ 42 ] = "spatial delay",
						[ 43 ] = "spatial delay",
					}

					local dspSlider = zgo2.Editor.Numslider(parent, PlantData.screeneffect.audio_dsp,"DSP", function(val,pnl)
						PlantData.screeneffect.audio_dsp = math.Round(val)
						pnl:SetText(DSP_List[PlantData.screeneffect.audio_dsp])
					end, 0, 43, 0,function(s)
						s:SetValue(PlantData.screeneffect.audio_dsp)
						s:SetText(DSP_List[PlantData.screeneffect.audio_dsp])
					end)
					dspSlider:SetText(DSP_List[math.Round(PlantData.screeneffect.audio_dsp)])

					local entry = zgo2.Editor.TextEntry(parent, zgo2.language[ "Music File" ], PlantData.screeneffect.audio_music, function(path)
						zgo2.ScreenEffect.SetMusic(PlantData,path)
					end,function(s)
						s:SetValue(PlantData.screeneffect.audio_music)
					end)

					entry.PlayMusicPreview = function(s, play)
						entry.IsPlaying = play

						if play then
							zgo2.ScreenEffect.StopMusic()
							zgo2.ScreenEffect.PlayMusic(PlantData)
						else
							zgo2.ScreenEffect.StopMusic()
						end
					end

					zgo2.vgui.Button(parent,zgo2.language[ "Music Libary" ],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["blue02"], function()

			   			 // Open interface to change music
			   			 local bg = vgui.Create("DPanel", main)
			   			 bg:SetAutoDelete(true)
			   			 bg:SetSize(main:GetWide(), main:GetTall())
			   			 bg:SetPos(0 * zclib.wM, 0 * zclib.hM)
			   			 bg.Paint = function(s, w, h)
			   				 draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a150"])
			   			 end

			   			 // Create song libary
			   			 zgo2.vgui.SongLibary(bg,function(song)

							zgo2.ScreenEffect.SetMusic(PlantData,song)

							entry:SetText(song)
							bg:Remove()
			   			 end,function()
			   				 bg:Remove()
			   			 end)
					end)

					zgo2.vgui.Button(parent,zgo2.language[ "Play" ],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["blue02"], function(s)
						entry.IsPlaying = not entry.IsPlaying
						entry:PlayMusicPreview(entry.IsPlaying)

						s:SetText(entry.IsPlaying and zgo2.language[ "Stop" ] or zgo2.language[ "Play" ])
					end)
				end)
			end)
		end
    end)
end
