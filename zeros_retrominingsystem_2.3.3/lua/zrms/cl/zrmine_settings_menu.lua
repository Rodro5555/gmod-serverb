if (not CLIENT) then return end
local Created = false

CreateConVar("zrms_cl_highlight_refreshrate", "0.1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_pickaxe_help", "1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_FillIndicator", "1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_lightsprites", "1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_dynlight", "1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_stencil", "1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_particleffects", "1", {FCVAR_ARCHIVE})
CreateConVar("zrms_cl_audiovolume", "1", {FCVAR_ARCHIVE})


local function zrmine_OptionPanel(name, CPanel, cmds)
	local panel = vgui.Create("DPanel")
	panel:SetSize(250 , 40 + (35 * table.Count(cmds)))
	panel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zrmine.default_colors["grey07"])
	end

	local title = vgui.Create("DLabel", panel)
	title:SetPos(10, 2.5)
	title:SetText(name)
	title:SetFont("zrmine_settings_font01")
	title:SetSize(panel:GetWide(), 30)
	title:SetTextColor(zrmine.default_colors["Gold"])

	for k, v in pairs(cmds) do
		if v.class == "DNumSlider" then

			local item = vgui.Create("DNumSlider", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText(v.name)
			item:SetMin(v.min)
			item:SetMax(v.max)
			item:SetDecimals(v.decimal)
			item:SetDefaultValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
			item:ResetToDefaultValue()

			item.OnValueChanged = function(self, val)

				if (not Created) then
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(),v.decimal),v.min,v.max))
				end
			end)

		elseif v.class == "DCheckBoxLabel" then

			local item = vgui.Create("DCheckBoxLabel", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( v.name )
			item:SetConVar( v.cmd )
			item:SetValue(0)
			item.OnChange = function(self, val)

				if (not Created) then
					if ((bVal and 1 or 0) == cvars.Number(v.cmd)) then return end
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(GetConVar(v.cmd):GetInt())
				end
			end)
		elseif v.class == "DButton" then
			local item = vgui.Create("DButton", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText( "" )
			item.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zrmine.default_colors["grey06"])
				draw.SimpleText(v.name, "zrmine_settings_font02", w / 2, h / 2, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if s.Hovered then
					draw.RoundedBox(5, 0, 0, w, h, zrmine.default_colors["white04"])
				end
			end
			item.DoClick = function()

				if zrmine.f.IsAdmin(LocalPlayer()) == false then return end

				LocalPlayer():EmitSound("zrmine_ui_click")

				if v.notify then

					notification.AddLegacy(  v.notify, NOTIFY_GENERIC, 2 )
				end
				LocalPlayer():ConCommand( v.cmd )

			end
		end
	end

	CPanel:AddPanel(panel)
end


local function zrmine_settings(CPanel)
	Created = true

	CPanel:AddControl("Header", {
		Text = "Client Settings",
		Description = ""
	})

	zrmine_OptionPanel("VFX",CPanel,{
		[1] = {name = "ParticleEffects",class = "DCheckBoxLabel", cmd = "zrms_cl_particleffects"},
		[2] = {name = "LightSprites",class = "DCheckBoxLabel", cmd = "zrms_cl_lightsprites"},
		[3] = {name = "DynamicLight",class = "DCheckBoxLabel", cmd = "zrms_cl_dynlight"},
		[4] = {name = "Stencil",class = "DCheckBoxLabel", cmd = "zrms_cl_stencil"},
		[5] = {name = "Fill Indicator",class = "DCheckBoxLabel", cmd = "zrms_cl_FillIndicator"},
	})


	zrmine_OptionPanel("UI",CPanel,{
		[1] = {name = "Pickaxe Help (On Screen Top)",class = "DCheckBoxLabel", cmd = "zrms_cl_pickaxe_help"},
		[2] = {name = "Machine Update Rate",class = "DNumSlider", cmd = "zrms_cl_highlight_refreshrate",min = 0.01,max = 3,decimal = 2},
	})


	zrmine_OptionPanel("SFX",CPanel,{
		[1] = {name = "Audio Volume",class = "DNumSlider", cmd = "zrms_cl_audiovolume",min = 0,max = 1,decimal = 2},
	})

	timer.Simple(0.2, function()
		Created = false
	end)
end

local function zrmine_admin_settings(CPanel)
	CPanel:AddControl("Header", {
		Text = "Admin Commands",
		Description = ""
	})

	zrmine_OptionPanel("NPC",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zrms_npc_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zrms_npc_remove"},
	})

	zrmine_OptionPanel("Ore Spawns",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zrms_ore_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zrms_ore_remove"},
	})

	zrmine_OptionPanel("Public Entities",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zrms_publicents_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zrms_publicents_remove"},
	})

	zrmine_OptionPanel("PipeLine",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zrmine_pipeline_save"},
		[2] = {name = "Rebuild",class = "DButton", cmd = "zrmine_pipeline_load"},
		[3] = {name = "Delete",class = "DButton", cmd = "zrmine_pipeline_delete"},
	})

	zrmine_OptionPanel("Level System",CPanel,{
		[1] = {name = "Open PlayerData",class = "DButton", cmd = "zrms_levelsystem_open"},
	})
end

hook.Add("PopulateToolMenu", "a_zrmine_PopulateToolMenu", function()
	spawnmenu.AddToolMenuOption("Options", "Retro Miner", "ZRMSSettings", "Client Settings", "", "", zrmine_settings)
	spawnmenu.AddToolMenuOption("Options", "Retro Miner", "ZRMSAdmin", "Admin Settings", "", "", zrmine_admin_settings)
end)

hook.Add("AddToolMenuCategories", "a_zrmine_AddToolMenuCategories", function()
	spawnmenu.AddToolCategory("Options", "Retro Miner", "Retro Miner")
end)
