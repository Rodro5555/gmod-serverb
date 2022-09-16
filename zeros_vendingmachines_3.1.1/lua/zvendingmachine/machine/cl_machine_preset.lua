if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}

// Ask the SERVER to send you a list of all the presets
function zvm.Machine.RequestPresets(Machine)
	net.Start("zvm_Machine_RequestPresets")
	net.WriteEntity(Machine)
	net.SendToServer()
end

// Here the SERVER will send you all the preset names
net.Receive("zvm_Machine_RequestPresets", function(len)
	zclib.Debug("zvm_Machine_RequestPresets Netlen: " .. len)

	local Machine = net.ReadEntity()
	local PresetCount = net.ReadUInt(32)
	local PresetList = {}
	for i = 1,PresetCount do
		table.insert(PresetList,{
			name = net.ReadString(),
			m_name = net.ReadString(),
			style = net.ReadUInt(32),
			count = net.ReadUInt(32)
		})
	end

	// Open a selection interface with the PresetList
	zvm.Machine.PresetList(Machine,PresetList)
end)

function zvm.Machine.PresetList(Machine,PresetList)
	LocalPlayer().zvm_Machine = Machine

	zvm.vgui.OptionPage(zvm.language.General["Presets"], function(main)
		main:SetSize(600 * zclib.wM, 800 * zclib.hM)
		main:Center()

		local bottom_pnl = vgui.Create("DPanel", main)
		bottom_pnl:SetSize(535 * zclib.wM, 500 * zclib.hM)
		bottom_pnl:SetAutoDelete(true)
		bottom_pnl:Dock(TOP)
		bottom_pnl:DockMargin(20 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
		bottom_pnl.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])
		end

		local SelectedItem
		local DaList
		local function BuildList()
			if IsValid(DaList) then DaList:Remove() end

			local scroll = vgui.Create("DScrollPanel", bottom_pnl)
			scroll:DockMargin(10 * zclib.wM, 20 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
			scroll:Dock(FILL)
			DaList = scroll

			local list = vgui.Create("DIconLayout", scroll)
			list:Dock(FILL)
			list:SetSpaceY(4 * zclib.hM)
			list:SetAutoDelete(true)
			list.Paint = function(s, w, h) end
			for k, v in ipairs(PresetList) do

				local itm_pnl = list:Add("DButton")
				itm_pnl:SetSize(500 * zclib.wM, 120 * zclib.hM)
				itm_pnl:SetAutoDelete(true)
				itm_pnl:SetText("")
				local amount = string.Replace(zvm.language.General["ItemCount"],"$Amount",v.count)
				itm_pnl.Paint = function(s, w, h)
					draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])

					surface.SetDrawColor(zvm.colors["blue03"])
					surface.SetMaterial(zclib.Materials.Get("item_bg"))
					surface.DrawTexturedRect(0, 0, h, h)

					draw.SimpleText(v.name, zclib.GetFont("zvm_interface_font01"),130 * zclib.hM, 5 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(v.m_name, zclib.GetFont("zvm_interface_item"),130 * zclib.hM, 40 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(amount, zclib.GetFont("zvm_interface_item"),130 * zclib.hM, 75 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

					if SelectedItem == v.name then
						zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
					end

					if s.Hovered then
						draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white03"])
					end
				end
				itm_pnl.DoClick = function()
					if SelectedItem == v.name then
						SelectedItem = nil
					else
						SelectedItem = v.name
					end
				end

				local imgpnl = vgui.Create("DImage", itm_pnl)
				imgpnl:SetSize(120 * zclib.wM, 120 * zclib.hM)
				local img = zclib.Snapshoter.Get({
					class = "zvm_machine",
					model = "models/zerochain/props_vendingmachine/zvm_machine.mdl",
					StyleID = zvm.Machine.GetUniqueStyleID(v.style)
				}, imgpnl)
				imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")
			end
		end

		BuildList()

		local save_btn = zvm.vgui.Button(main, function()
			// Call net msg to save current machines loadout
			// Open interface to write savefile name

			if SelectedItem then
				zvm.Machine.SavePreset(LocalPlayer().zvm_Machine,SelectedItem)
				return
			end

			zvm.vgui.OptionPage("Savefile Name", function(amain)
				amain:SetSize(600 * zclib.wM, 170 * zclib.hM)
				amain:Center()
				local Elements = {}

				Elements.TextEntryPanel = zclib.vgui.TextEntry(amain, "Savefile name", function(val) end)
				Elements.TextEntryPanel:SetPos(25 * zclib.wM, 45 * zclib.hM)
				Elements.TextEntryPanel:SetSize(550 * zclib.wM, 50 * zclib.hM)

				Elements.Apply_Button = zvm.vgui.Button(amain, function()
					zvm.Machine.SavePreset(LocalPlayer().zvm_Machine,Elements.TextEntryPanel:GetValue())
					amain:Remove()
				end)
				Elements.Apply_Button:SetPos(25 * zclib.wM, 100 * zclib.hM)
				Elements.Apply_Button:SetSize(550 * zclib.wM, 50 * zclib.hM)
			end)
		end)
		save_btn:SetPos(25 * zclib.wM, 50 * zclib.hM)
		save_btn:SetSize(550 * zclib.wM, 50 * zclib.hM)
		save_btn:DockMargin(20 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
		save_btn:Dock(TOP)
		save_btn.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zvm.colors["green01"])
			draw.SimpleText(SelectedItem and zvm.language.General["Overwrite"] or zvm.language.General["New"], zclib.GetFont("zvm_interface_font01"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if s:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"])
			end
		end

		local load_btn = zvm.vgui.Button(main, function()
			// Load selected savefile and apply it to the machine
			if SelectedItem then
				net.Start("zvm_Machine_LoadPreset")
				net.WriteString(SelectedItem)
				net.WriteEntity(Machine)
				net.SendToServer()

				main:Remove()
			end
		end)
		load_btn:SetPos(25 * zclib.wM, 100 * zclib.hM)
		load_btn:SetSize(550 * zclib.wM, 50 * zclib.hM)
		load_btn:Dock(TOP)
		load_btn:DockMargin(20 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 0 * zclib.hM)
		load_btn.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zvm.colors["green01"])
			draw.SimpleText(zvm.language.General["Load"], zclib.GetFont("zvm_interface_font01"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if s:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"])
			end
		end

		local delete_btn = zvm.vgui.Button(main, function()
			// Delete selected savefile and apply it to the machine

			if SelectedItem then
				net.Start("zvm_Machine_DeletePreset")
				net.WriteString(SelectedItem)
				net.SendToServer()

				main:Remove()
			end
		end)
		delete_btn:SetPos(25 * zclib.wM, 100 * zclib.hM)
		delete_btn:SetSize(550 * zclib.wM, 50 * zclib.hM)
		delete_btn:Dock(TOP)
		delete_btn:DockMargin(20 * zclib.wM, 20 * zclib.hM, 20 * zclib.wM, 10 * zclib.hM)
		delete_btn.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, zvm.colors["red01"])
			draw.SimpleText(zvm.language.General["Delete"], zclib.GetFont("zvm_interface_font01"), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if s:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, zvm.colors["white02"])
			end
		end
	end)
end

function zvm.Machine.SavePreset(Machine,name)

	if not IsValid(Machine) then return end
	if name == nil then return end
	if string.len(name) <= 2 then return end
	if name == "" then return end
	if name == " " then return end

	name = string.Replace(name,".txt","")

	net.Start("zvm_Machine_SavePreset")
	net.WriteEntity(Machine)
	net.WriteString(name)
	net.SendToServer()
end
