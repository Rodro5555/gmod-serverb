if not CLIENT then return end

zcm = zcm or {}
zcm.f = zcm.f or {}

local Created = false



CreateConVar("zcm_cl_vfx_updatedistance", "1000", {FCVAR_ARCHIVE})
CreateConVar("zcm_cl_vfx_effectcount", "25", {FCVAR_ARCHIVE})
CreateConVar("zcm_cl_vfx_particleffects", "1", {FCVAR_ARCHIVE})

CreateConVar("zcm_cl_sfx_volume", "0.6", {FCVAR_ARCHIVE})

CreateConVar("zcm_cl_hud_enabled", "1", {FCVAR_ARCHIVE})
CreateConVar("zcm_cl_hud_pos_y", "10", {FCVAR_ARCHIVE})
CreateConVar("zcm_cl_hud_pos_x", "95", {FCVAR_ARCHIVE})
CreateConVar("zcm_cl_hud_Scale", "1", {FCVAR_ARCHIVE})


function zcm.f.GetRenderDistance()
	return GetConVar("zcm_cl_vfx_updatedistance"):GetFloat() or 2000
end

function zcm.f.GetVolume()
	return GetConVar("zcm_cl_sfx_volume"):GetFloat() or 1
end


local function zcm_OptionPanel(name, CPanel, cmds)
	local panel = vgui.Create("DPanel")
	panel:SetSize(250, 40 + (35 * table.Count(cmds)))

	panel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, zcm.default_colors["grey01"])
	end

	local title = vgui.Create("DLabel", panel)
	title:SetPos(10, 2.5)
	title:SetText(name)
	title:SetFont("zcm_settings_font01")
	title:SetSize(panel:GetWide(), 30)
	title:SetTextColor(zcm.default_colors["yellow03"])

	for k, v in pairs(cmds) do
		if v.class == "DNumSlider" then
			local item = vgui.Create("DNumSlider", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText(v.name)
			item:SetMin(v.min)
			item:SetMax(v.max)
			item:SetDecimals(v.decimal)
			item:SetDefaultValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(), v.decimal), v.min, v.max))
			item:ResetToDefaultValue()

			item.OnValueChanged = function(self, val)
				if (not Created) then
					RunConsoleCommand(v.cmd, tostring(val))
				end
			end

			timer.Simple(0.1, function()
				if (item) then
					item:SetValue(math.Clamp(math.Round(GetConVar(v.cmd):GetFloat(), v.decimal), v.min, v.max))
				end
			end)
		elseif v.class == "DCheckBoxLabel" then
			local item = vgui.Create("DCheckBoxLabel", panel)
			item:SetPos(10, 35 * k)
			item:SetSize(panel:GetWide(), 30)
			item:SetText(v.name)
			item:SetConVar(v.cmd)
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
			item:SetText("")

			item.Paint = function(s, w, h)
				draw.RoundedBox(5, 0, 0, w, h, zcm.default_colors["yellow03"])
				draw.SimpleText(v.name, "zcm_settings_font02", w / 2, h / 2, zcm.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if s.Hovered then
					draw.RoundedBox(5, 0, 0, w, h, zcm.default_colors["white03"])
				end
			end

			item.DoClick = function()
				if zcm.f.IsAdmin(LocalPlayer()) == false then return end
				LocalPlayer():EmitSound("zcm_ui_click")

				if v.notify then
					notification.AddLegacy(v.notify, NOTIFY_GENERIC, 2)
				end

				LocalPlayer():ConCommand(v.cmd)
			end
		end
	end

	CPanel:AddPanel(panel)
end

local function zcrackermaker_settings(CPanel)
	Created = true

	CPanel:AddControl("Header", {
		Text = "Client Settings",
		Description = ""
	})

	zcm_OptionPanel("VFX", CPanel, {
		[1] = {
			name = "Render Distance",
			class = "DNumSlider",
			cmd = "zcm_cl_vfx_updatedistance",
			min = 1000,
			max = 5000,
			decimal = 0
		},
		[2] = {
			name = "Effect Count",
			class = "DNumSlider",
			cmd = "zcm_cl_vfx_effectcount",
			min = 1,
			max = 120,
			decimal = 0
		},
		[3] = {
			name = "ParticleEffects",
			class = "DCheckBoxLabel",
			cmd = "zcm_cl_vfx_particleffects"
		},
	})

	zcm_OptionPanel("SFX", CPanel, {
		[1] = {
			name = "Volume",
			class = "DNumSlider",
			cmd = "zcm_cl_sfx_volume",
			min = 0,
			max = 1,
			decimal = 1
		}
	})

	zcm_OptionPanel("UI", CPanel, {
		[1] = {
			name = "Show",
			class = "DCheckBoxLabel",
			cmd = "zcm_cl_hud_enabled"
		},
		[2] = {
			name = "Pos X",
			class = "DNumSlider",
			cmd = "zcm_cl_hud_pos_x",
			min = 0,
			max = 100,
			decimal = 0
		},
		[3] = {
			name = "Pos Y",
			class = "DNumSlider",
			cmd = "zcm_cl_hud_pos_y",
			min = 0,
			max = 100,
			decimal = 0
		},
		[4] = {
			name = "Scale",
			class = "DNumSlider",
			cmd = "zcm_cl_hud_Scale",
			min = 0.5,
			max = 2,
			decimal = 1
		}
	})

	timer.Simple(0.2, function()
		Created = false
	end)
end

local function zcrackermaker_admin_settings(CPanel)
	CPanel:AddControl("Header", {
		Text = "Admin Commands",
		Description = ""
	})

	zcm_OptionPanel("NPC",CPanel,{
		[1] = {name = "Save",class = "DButton", cmd = "zcm_debug_npc_save"},
		[2] = {name = "Remove",class = "DButton", cmd = "zcm_debug_npc_remove"},
	})

end

hook.Add("PopulateToolMenu", "a_zcm_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "CrackerMaker", "zcm_Settings", "Client Settings", "", "", zcrackermaker_settings)
	spawnmenu.AddToolMenuOption("Options", "CrackerMaker", "zcm_Admin_Settings", "Admin Settings", "", "", zcrackermaker_admin_settings)
end)

hook.Add("AddToolMenuCategories", "a_zcm_AddToolMenuCategories", function()
	spawnmenu.AddToolCategory("Options", "CrackerMaker", "CrackerMaker")
end)
