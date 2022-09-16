if SERVER then return end
zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}
zgo2.Pot.Editor = zgo2.Pot.Editor or {}

concommand.Add("zgo2_pot_editor", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
		zgo2.Pot.Editor.MainMenu()
	end
end)

// Stores the pot data we are currently working on
local PotData

// If we edit a existing config then this is the id we overwrite after saving
local OverwriteID

// The model of the pot
local PotEntity

local function UpdateMaterial()
	zclib.Timer.Remove("zgo2_editor_preview_update")
	zclib.Timer.Create("zgo2_editor_preview_update", 0.3, 1, function()

		zgo2.Pot.RebuildMaterial(PotData,true)

		if not IsValid(PotEntity) then return end

		zgo2.Pot.ApplyMaterial(PotEntity,PotData,true)
	end)
end

/*
    Opens the Pot selection menu
*/
function zgo2.Pot.Editor.MainMenu()

    zclib.vgui.Page(zgo2.language[ "Pot Selection" ], function(main, top)
        main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
            main:Close()
        end,function() return false end,zgo2.language[ "Close" ])

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

        local SelectedID = -1

        local function InvalidPot() return not zgo2.Pot.GetData(SelectedID) end

        // Only admins can edit the skins
        if zclib.Player.IsAdmin(LocalPlayer()) then

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("delete"), zclib.colors["red01"], function()
                if SelectedID and zgo2.Pot.GetData(SelectedID) then

                    zgo2.vgui.ConfirmationWindow(zgo2.language[ "confirm_delete" ],function()
                        zgo2.config.Pots[SelectedID] = nil
                        SelectedID = nil

						// Update the config on the SERVER
					    zclib.Data.UpdateConfig("zgo2_pot_config")

                        zgo2.vgui.Wait(zgo2.language[ "Pot Editor" ],function()
							zgo2.Pot.Editor.MainMenu()
						end)
                    end)
                end
            end, function() return InvalidPot() end, zgo2.language[ "Delete" ])

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("edit"), zclib.colors["orange01"], function()
                if SelectedID and zgo2.Pot.GetData(SelectedID) then

					local FoundPotData = zgo2.Pot.GetData(SelectedID)
					PotData = table.Copy(FoundPotData)
					PotData = zgo2.Pot.VerifyData(PotData)

					zgo2.Pot.RebuildMaterial(PotData,true)

					OverwriteID = SelectedID

                    zgo2.Pot.Editor.Start()
                end
            end,function() return InvalidPot() end,zgo2.language[ "Edit" ])

            zgo2.vgui.ImageButton(top, zclib.Materials.Get("duplicate"), zclib.colors["blue02"], function()
                if SelectedID and zgo2.Pot.GetData(SelectedID) then

                    zgo2.vgui.ConfirmationWindow(zgo2.language[ "confirm_duplicate" ],function()
						// Copy data
                        local m_PotData = table.Copy(zgo2.Pot.GetData(SelectedID))

						// Generate new id
                        m_PotData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")

						zgo2.config.Pots_ListID[m_PotData.uniqueid] = table.insert(zgo2.config.Pots,m_PotData)

						// Update the config on the SERVER
					    zclib.Data.UpdateConfig("zgo2_pot_config")

                        // NOTE We need to build the material before the snapshoter is gonna use it in the next frame to render the thumbnail
                        // Its something about the Imgur material not being present in the current frame

						// Build every single part of the pots material
						zgo2.Pot.RebuildMaterial(m_PotData,true)

						zgo2.vgui.Wait(zgo2.language[ "Pot Editor" ],function()
							zgo2.Pot.Editor.MainMenu()
						end)
                    end)
                end
            end,function() return InvalidPot() end,zgo2.language[ "Duplicate" ])

			zgo2.vgui.ImageButton(top, zclib.Materials.Get("clipboard"), zclib.colors[ "blue02" ], function()
				if SelectedID and zgo2.Pot.GetData(SelectedID) then
					// Copys/Formats the select pots data to the clipboard
					local dat = zgo2.Pot.GetData(SelectedID)
					if dat == nil then return end

					// Convert any job ids to job commands
					dat = zgo2.util.ConvertJobIDToCommand(dat)

					SetClipboardText(zgo2.Editor.BuildClipboard(dat,"AddPot"))

					zclib.vgui.Notify(zgo2.language[ "ClipboardNotify" ], NOTIFY_GENERIC)
				end
			end, function() return InvalidPot() end,  zgo2.language[ "ClipboardTooltip" ] )


            zgo2.vgui.ImageButton(top, zclib.Materials.Get("plus"), zclib.colors["green01"], function()

				PotData = {}
				PotData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
		        PotData = zgo2.Pot.VerifyData(PotData)
				OverwriteID = nil

				zgo2.Pot.RebuildMaterial(PotData,true)

				zgo2.vgui.Wait(zgo2.language[ "Pot Editor" ],function()
					zgo2.Pot.Editor.Start()
				end)
            end,function() return false end,zgo2.language[ "Create" ])

            local seperator = zclib.vgui.AddSeperator(top)
            seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
            seperator:Dock(RIGHT)
            seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
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

		for k, v in pairs(zgo2.config.Pots) do
			zgo2.vgui.PotPanel(list, 205, k, v, function() return SelectedID == k end, function(id)
				SelectedID = id
			end,false)
		end
    end)
end

/*
    Opens the Pot editor
*/
local WindowMode = true
function zgo2.Pot.Editor.Start()
    zclib.vgui.Page(zgo2.language[ "Pot Editor" ], function(main, top)

		if WindowMode then
			main:SetSize(1200 * zclib.wM, 1000 * zclib.hM)
			main:SetDraggable(true)
		else
			main:SetSize(ScrW(), ScrH())
			main:SetDraggable(false)
		end
		main:Center()

		local Randomizing = false

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors["red01"], function()
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
		end, function() return false end)
		windowButton.IconImage = WindowMode and zclib.Materials.Get("fullscreen") or zclib.Materials.Get("minimize")

        local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

        zgo2.vgui.ImageButton(top, zclib.Materials.Get("save"), zclib.colors["green01"], function()

            if OverwriteID then
                // Overwrite existing one
                zgo2.config.Pots[OverwriteID] = table.Copy(PotData)

				// Send out net Message to all Clients to remove this file so it gets rebuild
				zclib.Snapshoter.Delete("zgo2/pot_" .. PotData.uniqueid,true)
            else
                // Create new
				zgo2.config.Pots_ListID[PotData.uniqueid] = table.insert(zgo2.config.Pots,PotData)
            end

			// Update the config on the SERVER
			zclib.Data.UpdateConfig("zgo2_pot_config")

            // NOTE We need to build the material before the snapshoter is gonna use it in the next frame to render the thumbnail
            // Its something about the Imgur material not being present in the current frame

			// Rebuild material
			zgo2.Pot.RebuildMaterial(PotData)

			// Back to the main menu
			zgo2.vgui.Wait(zgo2.language[ "Pot Editor" ],function()
				//main:Close()
				zgo2.Pot.Editor.MainMenu()
			end)
        end,function() return false end, zgo2.language["Save"])

		local seperator = zclib.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		///////////////////////////////////////////////
		local RandomizeStart
		local RandomizeDur = 0
		zgo2.vgui.ImageButton(top, zclib.Materials.Get("random_style"), zclib.colors["orange01"], function()

			// Randomize data
			PotData = zgo2.Pot.RandomizeData(PotData)

			// Update model
			UpdateMaterial()

			zgo2.Editor.UpdateControlls()
		end,function() return false end, zgo2.language[ "Randomize Style" ])
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
		///////////////////////////////////////////////

		local PotType = zgo2.Pot.Types[PotData.type]

		// Creates either a 3d or 2d preview
		local preview
		local function BuildPreview()
			if IsValid(preview) then preview:Remove() end

			preview = zclib.vgui.DAdjustableModelPanel({model = PotType.mdl})
			preview:OnMouseWheeled( 0 )
			preview:SetParent(PreviewContent)
			preview:Dock(FILL)

			preview:SetDirectionalLight(BOX_TOP, color_white)
			preview:SetDirectionalLight(BOX_FRONT, color_white)
			preview:SetDirectionalLight(BOX_BACK, color_white)
			preview:SetDirectionalLight(BOX_LEFT, color_black)
			preview:SetDirectionalLight(BOX_RIGHT, color_white)

			preview:OnMousePressed( MOUSE_LEFT )
			timer.Simple(0.15,function() if IsValid(preview) then preview:OnMouseReleased( MOUSE_LEFT ) end end)

			PotEntity = preview.Entity
			PotEntity.IsEditor = true

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

				// Draw background wall
				if not IsValid(self.Photowall) then
					self.Photowall = zclib.ClientModel.Add("models/zerochain/props_growop2/zgo2_photowall.mdl", RENDERGROUP_OTHER)
					self.Photowall:SetLOD( 0 )
					self.Photowall:SetModelScale(0.5)
				else
					render.Model({
						model = self.Photowall:GetModel(),
						pos = vector_origin,
						angle = Angle(0,90,0)
					}, self.Photowall)
				end
			end

			function preview:OnRemove()
				if IsValid(self.Photowall) then
					self.Photowall:Remove()
				end
			end

			function preview:PostDrawModel(ent)
				cam.Start2D()
					local w,h = preview:GetWide(), preview:GetTall()
					if Randomizing then
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
						local name = PotData.name
						if name then
							SimpleTextBox(name, zclib.colors["orange01"], zclib.GetFont("zclib_font_big"), 7 * zclib.wM, 10 * zclib.hM)
						end
						draw.RoundedBox(5, 0, h - 80 * zclib.hM, w, 80 * zclib.hM, zclib.colors["black_a200"])
					end
				cam.End2D()
			end

			// Display the restrictions
			zgo2.vgui.Restriction(preview,PotData)

			PotEntity:SetBodygroup(2,PotData.hose and 1 or 0)
			PotEntity:SetAngles(Angle(0,0,0))
			PotEntity:SetModelScale(PotData.scale or 1,0)

			UpdateMaterial()
		end

		timer.Simple(0,BuildPreview)

		RebuildOptions(function(cat_list)
			zgo2.Editor.CategoryBox(cat_list,zgo2.language["Basic"],function(parent)

				zgo2.Editor.TextEntry(parent, zgo2.language["Name"] .. ":", PotData.name, function(val)
					PotData.name = val
				end)

				zgo2.Editor.Numslider(parent,PotData.price,zgo2.language[ "Price" ],function(val)
					PotData.price = val
				end,0,1000000000,0,function(s)
					s:SetValue(PotData.price)
				end)

				zgo2.Editor.Numslider(parent,PotData.water_capacity,zgo2.language[ "Capacity" ],function(val)
					PotData.water_capacity = val
				end,100,5000,0,function(s)
					s:SetValue(PotData.water_capacity)
				end)

				zgo2.Editor.Numslider(parent,PotData.boost_time,zgo2.language[ "Grow Boost" ],function(val)
					PotData.boost_time = val
				end,1,10,2,function(s)
					s:SetValue(PotData.boost_time)
				end)

				zgo2.Editor.Numslider(parent,PotData.boost_amount,zgo2.language[ "Harvest Boost" ],function(val)
					PotData.boost_amount = val
				end,1,10,2,function(s)
					s:SetValue(PotData.boost_amount)
				end)

				zgo2.Editor.CheckBox(parent,PotData.hose,zgo2.language[ "Hose Connection" ],function()
					PotData.hose = not PotData.hose
					PotEntity:SetBodygroup(2,PotData.hose and 1 or 0)
				end,function(s)
					s:SetValue(PotData.hose == 1)
				end)

				zgo2.vgui.Button(parent,zgo2.language["Rank Restriction"],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["orange01"], function()
					zgo2.vgui.ListEditor(PotData,zgo2.language["Rank Restriction"],"ranks",zclib.colors["orange01"],function()
						zgo2.Pot.Editor.Start()
					end,function(data)
						PotData = data
					end)
				end)

				zgo2.vgui.Button(parent,zgo2.language["Job Restriction"],zclib.GetFont("zclib_font_mediumsmall"), zclib.colors["blue02"], function()
					zgo2.vgui.ListEditor(PotData,zgo2.language["Job Restriction"],"jobs",zclib.colors["blue02"],function()
						zgo2.Pot.Editor.Start()
					end,function(data)
						PotData = data
					end)
				end)
			end)

			local ImgurMat
			local LastFrame = CurTime()

			zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Main" ],function(parent)

				// Select which model
				local PotMesh_DComboBox = zgo2.Editor.ComboBox(parent, zgo2.language[ "Mesh" ] .. " - " .. PotData.type, function(index, value, pnl)
					PotData.type = pnl:GetOptionData(index)

					PotType = zgo2.Pot.Types[PotData.type]

					local mdl = zgo2.Pot.Types[PotData.type].mdl
					zclib.CacheModel(mdl)
					PotEntity:SetModel(mdl)
					UpdateMaterial()
				end, function(s)
					s:SetValue(PotData.type)
				end)
				for k, v in ipairs(zgo2.Pot.Types) do PotMesh_DComboBox:AddChoice(zgo2.language[ "Mesh" ] .. " - " .. k, k) end

				zgo2.Editor.Numslider(parent,PotData.scale,zgo2.language[ "Scale" ],function(val)
					PotEntity:SetModelScale(val,0)
					PotData.scale = val
					UpdateMaterial()
				end,0.5,1.25,2,function(s)
					s:SetValue(PotData.scale)
				end)

				zgo2.Editor.ColorMixer(parent, PotData.style.color,zgo2.language[ "Color" ], true, function(col)
					PotData.style.color = Color(col.r, col.g, col.b, col.a)
					UpdateMaterial()
				end,function(s)
					s:SetColor(PotData.style.color)
				end)
			end)

			zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Image" ],function(parent)

				zgo2.Editor.ColorMixer(parent, PotData.style.img_color,zgo2.language[ "Color" ], true, function(col)
					PotData.style.img_color = Color(col.r, col.g, col.b, col.a)
					UpdateMaterial()
				end,function(s)
					s:SetColor(PotData.style.img_color)
				end)

				zgo2.Editor.BlendMode(parent,PotData.style.blendmode or 0,function(index, value, pnl)
					local val = pnl:GetOptionData(index)
					PotData.style.blendmode = val
					UpdateMaterial()
				end)

				zgo2.Editor.ImageGallery(parent,PotData.style.url,function(val,txt)
					PotData.style.url = val
					ImgurMat = nil
					zclib.Imgur.GetMaterial(tostring(PotData.style.url), function(result)
						if result then
							ImgurMat = result
						else
							PotData.style.url = nil
						end

						UpdateMaterial()
					end)

					if LastFrame ~= CurTime() then
						txt:SetValue(PotData.style.url)
						LastFrame = CurTime()
					end
				end,function(s)
					s:SetValue(PotData.style.url)
				end)


				zgo2.Editor.Numslider(parent,PotData.style.pos_x,zgo2.language["PositionX"],function(val)
					PotData.style.pos_x = val
					UpdateMaterial()
				end,0,1,2,function(s)
					s:SetValue(PotData.style.pos_x)
				end)

				zgo2.Editor.Numslider(parent,PotData.style.pos_y,zgo2.language["PositionY"],function(val)
					PotData.style.pos_y = val
					UpdateMaterial()
				end,0,1,2,function(s)
					s:SetValue(PotData.style.pos_y)
				end)

				zgo2.Editor.Numslider(parent,PotData.style.scale,zgo2.language["Scale"],function(val)
					PotData.style.scale = val
					UpdateMaterial()
				end,0.1,15,2,function(s)
					s:SetValue(PotData.style.scale)
				end)

				if PotData and PotData.style.url then
					zclib.Imgur.GetMaterial(tostring(PotData.style.url), function(result)
						if result then
							ImgurMat = result
							UpdateMaterial()
						end
					end)
				end
			end)

			zgo2.Editor.CategoryBox(cat_list,zgo2.language[ "Shine" ],function(parent)

				zgo2.Editor.Numslider(parent,PotData.style.phongexponent,zgo2.language[ "Exponent" ],function(val)
					PotData.style.phongexponent = val
					UpdateMaterial()
				end,1,25,2,function(s)
					s:SetValue(PotData.style.phongexponent)
				end)

				zgo2.Editor.Numslider(parent,PotData.style.phongboost,zgo2.language[ "Boost" ],function(val)
					PotData.style.phongboost = val
					UpdateMaterial()
				end,0,25,2,function(s)
					s:SetValue(PotData.style.phongboost)
				end)

				zgo2.Editor.ColorMixer(parent, PotData.style.phongtint,zgo2.language[ "Tint" ], false, function(col)
					PotData.style.phongtint = col
					UpdateMaterial()
				end,function(s)
					s:SetColor(PotData.style.phongtint)
				end)

				zgo2.Editor.Numslider(parent,PotData.style.fresnel,zgo2.language[ "Fresnel" ],function(val)
					PotData.style.fresnel = val
					UpdateMaterial()
				end,0,3,2,function(s)
					s:SetColor(PotData.style.fresnel)
				end)
			end)

			local _2dpreview = vgui.Create("DButton", cat_list)
			_2dpreview:SetText("")
			_2dpreview:SetSize(350 * zclib.wM, 350 * zclib.hM)
			_2dpreview:Dock(TOP)
			_2dpreview:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
			_2dpreview.DrawUV = false
			_2dpreview.Paint = function(s, w, h)

				zgo2.Pot.DrawTexture(w, h,PotData,ImgurMat,true)

				if s.DrawUV then
					surface.SetDrawColor(zclib.colors["white_a100"])
					surface.SetMaterial(PotType.uv)
					surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 0)
				end
			end
			_2dpreview.DoClick = function(s)
				zclib.vgui.PlaySound("UI/buttonclick.wav")
				s.DrawUV = not s.DrawUV
			end
		end)
    end)
end
