if not CLIENT then return end
zrush = zrush or {}
zrush.Machine = zrush.Machine or {}

// This gets filled with all the modules which are currently installed on the machine
local InstalledModules

// The main panels of the interface to define the layout
local StatPanel
local ModulePanel
local InfoPanel
local ActionPanel
local ShopPanel

// This keeps track on which module is currently selected, (both for the shop and the installed modules)
local SELECTED_MODULE_INSTALLED
local SELECTED_MODULE_SHOP

// Gets updated when the ui opens and checks if a chaosevent is currently ongoing
local HasChaosEvent

// Gets called if a users wants do close the ui
net.Receive("zrush_Machine_CloseUI", function(len)
	zclib.Debug("zrush_Machine_CloseUI Len:" .. len)
	local ent = net.ReadEntity()

	if not IsValid(ent) or ent == zrush.vgui.ActiveEntity then
		zrush.vgui.Close()
	end
end)

// This opens the machine ui for a user
net.Receive("zrush_Machine_OpenUI", function(len)
	zclib.Debug("zrush_Machine_OpenUI Len:" .. len)
	zrush.vgui.ActiveEntity = net.ReadEntity()
	if not IsValid(zrush.vgui.ActiveEntity) then return end

	InstalledModules = net.ReadTable()

	zrush.Machine.Open()
end)

local function CustomNotify(msg, msgtype, dur)
	if IsValid(zrush_main_panel.NotifyPanel) then
		zrush_main_panel.NotifyPanel:Remove()
	end

	local s_sound = "common/bugreporter_succeeded.wav"
	local mat_icon = zclib.Materials.Get("info")

	if msgtype == NOTIFY_GENERIC then
		s_sound = "common/bugreporter_succeeded.wav"
	elseif msgtype == NOTIFY_ERROR then
		s_sound = "common/warning.wav"
	elseif msgtype == NOTIFY_HINT then
		s_sound = "buttons/button15.wav"
	end

	zclib.vgui.PlaySound(s_sound)
	local x, y = zrush_main_panel:GetPos()
	local p = vgui.Create("DPanel")

	p:SetPos(x, y)
	p:MoveTo(x, y - 55 * zclib.hM, 0.25, 0, 1, function()
		if IsValid(p) then
			p:AlphaTo(0, 1, dur, function()
				if IsValid(p) then
					p:Remove()
				end
			end)
		end
	end)

	p:SetSize(1200 * zclib.wM, 50 * zclib.hM)
	p:SetAutoDelete(true)
	p:ParentToHUD()
	p:SetDrawOnTop(false)

	p.Paint = function(s, w, h)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
	end

	local p_icon = vgui.Create("DPanel", p)
	p_icon:SetPos(0 * zclib.wM, 0 * zclib.hM)
	p_icon:SetSize(50 * zclib.wM, 50 * zclib.hM)

	p_icon.Paint = function(s, w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat_icon)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	p_icon:Dock(LEFT)
	local p_lbl = vgui.Create("DLabel", p)
	p_lbl:SetPos(0 * zclib.wM, 0 * zclib.hM)
	p_lbl:SetSize(1200 * zclib.wM, 50 * zclib.hM)
	p_lbl.Paint = function(s, w, h) end
	p_lbl:SetText(msg)
	p_lbl:SetTextColor(zclib.colors["text01"])
	p_lbl:SetFont(zclib.GetFont("zclib_font_medium"))
	p_lbl:SetContentAlignment(4)
	p_lbl:SizeToContentsX(15 * zclib.wM)
	p_lbl:Dock(LEFT)
	p:InvalidateChildren(true)
	p:SizeToChildren(true, false)
	zrush_main_panel.NotifyPanel = p

	-- Here we attach the notify to the on remove function, so it gets cleaned up
	if zrush_main_panel.NotifyCleanup == nil then
		zrush_main_panel.NotifyCleanup = function()
			local oldRemove = zrush_main_panel.OnRemove

			function zrush_main_panel:OnRemove()
				pcall(oldRemove)

				if IsValid(self.NotifyPanel) then
					self.NotifyPanel:Remove()
				end
			end
		end

		zrush_main_panel.NotifyCleanup()
	end
end

function zrush.Machine.Open()

	// Who is the owner of the machine?
	local ownerID = zclib.Player.GetOwnerID(zrush.vgui.ActiveEntity)
	local owner = player.GetBySteamID(ownerID)
	local owner_name = "Unkown"
	if IsValid(owner) then owner_name = owner:Nick() end

	HasChaosEvent = zrush.vgui.ActiveEntity:HasChaosEvent()

	zrush.vgui.Page(owner_name .. "´s " .. zrush.language[zrush.vgui.ActiveEntity.MachineID], function(main, top)

		main:SetSize(1200 * zclib.wM, 800 * zclib.hM)

		local close_btn = zclib.vgui.ImageButton(940 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 50 * zclib.hM, top, zclib.Materials.Get("close"), function()
			zrush.vgui.Close()
		end, false)
		close_btn:Dock(RIGHT)
		close_btn:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		close_btn.IconColor = zclib.colors["red01"]

		local seperator = zrush.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local LeftPanel = vgui.Create("DPanel", main)
		LeftPanel:SetSize(690 * zclib.wM, 300 * zclib.hM)
		LeftPanel:Dock(LEFT)
		LeftPanel:DockMargin(50 * zclib.wM, 5 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
		LeftPanel.Paint = function(s, w, h)
			//draw.RoundedBox(5, 0, 0, w, h, zclib.colors["red01"])
		end

		local RightPanel = vgui.Create("DPanel", main)
		RightPanel:SetSize(400 * zclib.wM, 300 * zclib.hM)
		RightPanel:Dock(RIGHT)
		RightPanel:DockMargin(10 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 10 * zclib.hM)
		RightPanel.Paint = function(s, w, h)
			//draw.RoundedBox(5, 0, 0, w, h, zclib.colors["red01"])
		end

		// This panel will be populated with statistics about the machine
		// NOTE The refinery will also allow to select the fuel type in this panel
		StatPanel = vgui.Create("DPanel", LeftPanel)
		StatPanel:SetSize(690 * zclib.wM, 335 * zclib.hM)
		StatPanel:Dock(TOP)
		StatPanel:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
		StatPanel.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
		end
		zrush.Machine.Statistic(StatPanel)

		// This panel will show all the installed modules
		ModulePanel = vgui.Create("DPanel", LeftPanel)
		ModulePanel:SetSize(690 * zclib.wM, 140 * zclib.hM)
		ModulePanel:Dock(TOP)
		ModulePanel:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
		ModulePanel.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
		end
		zrush.Machine.InstalledModules(ModulePanel)

		// This panel will show all available actions
		ActionPanel = vgui.Create("DPanel", LeftPanel)
		ActionPanel:SetSize(690 * zclib.wM, 155 * zclib.hM)
		ActionPanel:Dock(TOP)
		ActionPanel:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
		ActionPanel.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
		end
		zrush.Machine.Actions(ActionPanel)

		// This panel will allow the player to buy modules
		InfoPanel = vgui.Create("DPanel", RightPanel)
		InfoPanel:SetSize(500 * zclib.wM, 305 * zclib.hM)
		InfoPanel:Dock(BOTTOM)
		InfoPanel:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		InfoPanel.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
		end
		zrush.Machine.ModuleInfo(InfoPanel)

		// This panel will allow the player to buy modules
		ShopPanel = vgui.Create("DPanel", RightPanel)
		ShopPanel:Dock(FILL)
		ShopPanel.Paint = function(s, w, h)
			draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
		end
		zrush.Machine.ModuleShop(ShopPanel)
	end)
end

// This updates the ui if the machine does a action
net.Receive("zrush_Machine_UpdateUI", function(len)
	zclib.Debug("zrush_Machine_UpdateUI Len:" .. len)
	local ent = net.ReadEntity()
	local tbl = net.ReadTable()
	local UpdateShop = net.ReadBool()
	local StatisticOnly = net.ReadBool()

	if ent == zrush.vgui.ActiveEntity and IsValid(zrush_main_panel) and tbl then
		InstalledModules = tbl
		zrush.Machine.Update(UpdateShop,StatisticOnly)
	end
end)
function zrush.Machine.Update(UpdateShop,StatisticOnly)

	HasChaosEvent = zrush.vgui.ActiveEntity:HasChaosEvent()

	zrush.Machine.Statistic(StatPanel)
	if StatisticOnly then return end

	zrush.Machine.InstalledModules(ModulePanel)
	zrush.Machine.Actions(ActionPanel)
	zrush.Machine.ModuleInfo(InfoPanel)

	if UpdateShop then
		zrush.Machine.ModuleShop(ShopPanel)
	end
end

net.Receive("zrush_Refinery_ChangeFuel", function(len, ply)
	local ent = net.ReadEntity()

	if IsValid(zrush_main_panel) and IsValid(ent) and ent == zrush.vgui.ActiveEntity then
		zrush.Machine.Statistic(StatPanel)
	end
end)


///////////
/////////// Stats
// This creates our Machien statistic panel
local StatContent
function zrush.Machine.Statistic(parent)
	if IsValid(StatContent) then StatContent:Remove() end

	local stateMessage = zrush.MachineState.GetTranslation(zrush.vgui.ActiveEntity:GetState())

	StatContent = vgui.Create("DPanel", parent)
	StatContent:Dock(FILL)
	StatContent.Paint = function(s, w, h) end

	if zrush.vgui.ActiveEntity:GetClass() == "zrush_refinery" then

		local refinery = zrush.vgui.ActiveEntity

		// What fuel is selected?
		local SELECTED_FUEL = refinery:GetFuelTypeID()

		local list, scroll = zrush.vgui.List(StatContent)
		list:DockPadding(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
		list:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
		scroll:SetSize(250 * zclib.wM, 50 * zclib.hM)
		scroll:Dock(RIGHT)
		scroll:DockMargin(20 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h)
			draw.RoundedBox(5, w - 17 * zclib.wM, 0, 17 * zclib.wM, h, zclib.colors["black_a50"])
		end

		for k, v in ipairs(zrush.FuelTypes) do

			local IsLocked = zclib.Player.RankCheck(LocalPlayer(), v.ranks) == false

			// Does the player have the correct Job do select this fuel
			local UserHasAllowedJob = true
			if v.jobs then UserHasAllowedJob = zclib.Player.JobCheck(LocalPlayer(), v.jobs) end


			local itm = list:Add("DButton")
			itm:SetSize(225 * zclib.wM, 44 * zclib.hM)
			itm:SetAutoDelete(true)
			itm:SetText("")
			itm.Paint = function(s, w, h)

				if k == SELECTED_FUEL then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
				else
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
				end

				if IsLocked or UserHasAllowedJob == false then
					surface.SetDrawColor(zclib.colors["black_a100"])
					surface.SetMaterial(zclib.Materials.Get("icon_locked"))
					surface.DrawTexturedRect(w - h ,0, h, h )
				else
					local panelcolor = v.color
					if (k == SELECTED_FUEL) then
						surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.75)
					else
						surface.SetDrawColor(panelcolor.r, panelcolor.g, panelcolor.b, panelcolor.a * 0.05)
					end
					surface.SetMaterial(zrush.default_materials["barrel_icon"])
					surface.DrawTexturedRect(w - h * 0.88, h * 0.1, h * 0.8, h * 0.8)
				end

				draw.SimpleText(v.name, zclib.GetFont("zclib_font_small"), 10 * zclib.wM, h / 2, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				if s:IsHovered() then
					draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
				end
			end
			itm.DoClick = function()

				if HasChaosEvent then
					CustomNotify(zrush.language["FixMachinefirst"],NOTIFY_ERROR,3)
					return
				end

				if not zclib.Player.IsOwner(LocalPlayer(), refinery) then
					CustomNotify(zrush.language["YouDontOwnThis"],NOTIFY_ERROR,3)
					return
				end

				if IsLocked then
					CustomNotify(zrush.language["WrongUserGroup"],NOTIFY_ERROR,3)
					return
				end

				if not UserHasAllowedJob then
					CustomNotify(zrush.language["WrongJob"],NOTIFY_ERROR,3)
					return
				end

				SELECTED_FUEL = k

				if IsValid(refinery) then
					net.Start("zrush_Refinery_ChangeFuel")
					net.WriteEntity(refinery)
					net.WriteInt(SELECTED_FUEL, 16)
					net.SendToServer()
				end

				surface.PlaySound("zrush/zrush_command.wav")
			end
		end
	end

	local content_Stats = vgui.Create("DPanel", StatContent)
	content_Stats:Dock(FILL)
	content_Stats:DockPadding(0 * zclib.wM, 50 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	content_Stats.Paint = function(s, w, h)
		draw.SimpleText(zrush.language["Status"], zclib.GetFont("zclib_font_big"), 10 * zclib.wM, 50 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(stateMessage, zclib.GetFont("zclib_font_medium"), w - 10 * zclib.wM, 50 * zclib.hM, zclib.colors["orange01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		draw.RoundedBox(5, 0, 50 * zclib.hM, w, 2 * zclib.hM, zclib.colors["text01"])
	end

	local function AddStat(name,value)
		local p = vgui.Create("DPanel", content_Stats)
		p:SetSize(200 * zclib.wM, 40 * zclib.hM)
		p:Dock(TOP)
		p.Paint = function(s, w, h)
			draw.SimpleText(name, zclib.GetFont("zclib_font_mediumsmall"), 10 * zclib.wM, h / 2, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(value, zclib.GetFont("zclib_font_mediumsmall_thin"), w - 10 * zclib.wM, h / 2, zclib.colors["orange01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.RoundedBox(5, 0, h - 1 * zclib.hM, w, 1 * zclib.hM, zclib.colors["white_a15"])
		end
	end

	for k,v in ipairs(zrush.vgui.ActiveEntity:GetStats()) do
		AddStat(v.name,v.val)
	end
end


///////////
/////////// Installed Modules
// This creates our Installed Module Panel
local ModuleContent
function zrush.Machine.InstalledModules(parent)
	if IsValid(ModuleContent) then ModuleContent:Remove() end

	ModuleContent = vgui.Create("DPanel", parent)
	ModuleContent:Dock(FILL)
	ModuleContent:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	ModuleContent.Paint = function(s, w, h) end

	// Does the machine currently has a chaos event?
	if HasChaosEvent then
		local Locked = vgui.Create("Panel", ModuleContent)
		Locked:Dock(FILL)
		Locked.Paint = function(self, w, h)
			draw.SimpleText(zrush.language["FixMachinefirst"], zclib.GetFont("zclib_font_big"), w / 2 , h / 2, zclib.colors["red01"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		return
	end



	for i = 1,table.Count(zrush.ModuleSockets[zrush.vgui.ActiveEntity.MachineID]) do
		local itm = vgui.Create("DPanel", ModuleContent)
		itm:SetSize(160 * zclib.wM, 120 * zclib.hM)
		itm:Dock(LEFT)
		itm:DockMargin(0 * zclib.wM, 0 * zclib.hM, 10 * zclib.wM, 0 * zclib.hM)
		itm.Paint = function(s, w, h)
			surface.SetDrawColor(color_black)
			surface.SetMaterial(zrush.default_materials["shadow_circle"])
			surface.DrawTexturedRect(20 * zclib.hM, 0, 120 * zclib.hM, 120 * zclib.hM)
		end

		local m_id = InstalledModules[i]
		if m_id == nil then continue end

		local dat = zrush.Modules.GetData(m_id)
		if dat == nil then continue end

		local m_icon = zrush.Modules.GetIcon(dat.type)
		local m_color = dat.color

		local mod = vgui.Create("DButton", itm)
		mod:SetSize(100 * zclib.wM, 100 * zclib.hM)
		mod:Center()
		mod:SetText("")
		mod.Paint = function(s, w, h)

			if s:IsHovered() then
				draw.RoundedBox(w, 0, 0, w, h, zclib.colors["ui_highlight"])
			else
				draw.RoundedBox(w, 0, 0, w, h, zclib.colors["ui02"])
			end

			if i == SELECTED_MODULE_INSTALLED then
				surface.SetDrawColor(zclib.colors["white_a100"])
				surface.SetMaterial(zrush.default_materials["ui_circle_selection"])
				surface.DrawTexturedRect(0,0,h,h)
			end

			surface.SetDrawColor(m_color)
			surface.SetMaterial(m_icon)
			surface.DrawTexturedRect(w * 0.2,w * 0.2, w * 0.6, w * 0.6)

			local m_amount = dat.amount
			if m_amount == nil then return end

			local m_text
			if (dat.type == "pipes") then
				m_text = "+" .. tostring(m_amount)
			else
				m_text = "+" .. tostring(100 * m_amount) .. "%"
			end
			draw.SimpleText(m_text, zclib.GetFont("zclib_font_medium"), w / 2 , h / 2, color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

			surface.SetDrawColor(zclib.colors["white_a15"])
			surface.SetMaterial(zrush.default_materials["glam_circle"])
			surface.DrawTexturedRect(0,0,w,h)
		end
		mod.DoClick = function()
			if HasChaosEvent then
				CustomNotify(zrush.language["FixMachinefirst"],NOTIFY_ERROR,3)
				return
			end
			surface.PlaySound("zrush/zrush_command.wav")

			SELECTED_MODULE_INSTALLED = i
			SELECTED_MODULE_SHOP = nil

			zrush.Machine.ModuleInfo(InfoPanel,m_id,true)
		end
	end
end


///////////
/////////// Module Info
// This creates our Installed Module Panel
local InfoContent
function zrush.Machine.ModuleInfo(parent,m_id,Sell)
	if IsValid(InfoContent) then InfoContent:Remove() end

	InfoContent = vgui.Create("DPanel", parent)
	InfoContent:Dock(FILL)
	InfoContent:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	InfoContent.Paint = function(s, w, h)
		if HasChaosEvent then
			draw.SimpleText(zrush.language["FixMachinefirst"], zclib.GetFont("zclib_font_big"), w / 2 , h / 2, zclib.colors["red01"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end

	if HasChaosEvent then return end

	local dat = zrush.Modules.GetData(m_id)
	if dat == nil then return end

	local function AddField(txt,font,color,align,width,height,dock,warp,aparent)
		local lbl = vgui.Create("DLabel", aparent or InfoContent)
		lbl:Dock(dock or BOTTOM)
		lbl:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 5 * zclib.hM)
		lbl:SetSize(width * zclib.wM, height * zclib.hM)
		lbl:SetFont(font)
		lbl:SetText(txt)
		lbl:SetColor(color)
		lbl:SetContentAlignment(align)
		lbl:SetWrap(warp)
		lbl.Paint = function(s, w, h)
			//draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
			//zclib.util.DrawOutlinedBox(0,0, w, h, 1, color_black)
		end
	end

	/////////
	local top_con = vgui.Create("DPanel", InfoContent)
	top_con:SetTall(30 * zclib.hM)
	top_con:Dock(TOP)
	top_con:DockPadding(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	top_con:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 5 * zclib.hM)
	top_con.Paint = function(s, w, h) end
	AddField(dat.name,zclib.GetFont("zclib_font_mediumsmall"),zclib.colors["text01"],7,230,25,LEFT,false,top_con)
	local value = dat.price
	if Sell then value = value * zrush.config.MachineBuilder.SellValue end
	AddField(zclib.Money.Display(value),zclib.GetFont("zclib_font_mediumsmall"),zclib.colors["green01"],9,150,20, RIGHT,false,top_con)
	/////////


	/////////
	local AmountValue
	if (dat.type == "pipes") then
		AmountValue = "+" .. dat.amount
	else
		AmountValue = "+" .. (100 * dat.amount) .. "%"
	end
	AddField(zrush.language[dat.type] .. " | " .. AmountValue,zclib.GetFont("zclib_font_small"),zclib.colors["orange01"],7,200,20,TOP,false)
	AddField(dat.desc,zclib.GetFont("zclib_font_small_thin"),zclib.colors["text01"],7,200,55,TOP,true)
	/////////

	/////////
	local reg = vgui.Create("DPanel", InfoContent)
	reg:SetTall(25 * zclib.hM)
	reg:Dock(TOP)
	reg:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	reg:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 5 * zclib.hM)
	reg.Paint = function(s, w, h)
		draw.SimpleText(zrush.language["Restriction"], zclib.GetFont("zclib_font_small"), 0,0, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.RoundedBox(2, 0, h-2 * zclib.hM, w, 2 * zclib.hM, zclib.colors["white_a15"])
	end
	if dat.ranks and table.Count(dat.ranks) > 0 then
		AddField(zclib.table.ToString(dat.ranks or {}),zclib.GetFont("zclib_font_tiny"),zclib.colors["red01"],7,200,40,TOP,true)
	end
	if dat.jobs and table.Count(dat.jobs) > 0 then
		AddField(zclib.table.ToString(dat.jobs or {}),zclib.GetFont("zclib_font_tiny"),zclib.colors["blue01"],7,200,40,TOP,true)
	end
	/////////


	local action
	if Sell then
		action = zrush.vgui.Button(InfoContent,zrush.language["Sell"],zclib.colors["red01"],function()
			if (not zclib.Player.IsOwner(LocalPlayer(), zrush.vgui.ActiveEntity)) then
				CustomNotify(zrush.language["YouDontOwnThis"],NOTIFY_ERROR,3)
				return
			end

			if SELECTED_MODULE_INSTALLED then
				net.Start("zrush_machine_SellModule")
				net.WriteEntity(zrush.vgui.ActiveEntity)
				net.WriteInt(SELECTED_MODULE_INSTALLED, 16)
				net.SendToServer()

				SELECTED_MODULE_INSTALLED = nil
			end
		end)
	else
		action = zrush.vgui.Button(InfoContent,zrush.language["Purchase"],zclib.colors["green01"],function()

			if (not zclib.Player.IsOwner(LocalPlayer(), zrush.vgui.ActiveEntity)) then
				CustomNotify(zrush.language["YouDontOwnThis"],NOTIFY_ERROR,3)
				return
			end

			if SELECTED_MODULE_SHOP then
				net.Start("zrush_machine_PurchaseModule")
				net.WriteEntity(zrush.vgui.ActiveEntity)
				net.WriteInt(SELECTED_MODULE_SHOP, 16)
				net.SendToServer()
			end
		end)
	end
	action:SetTall(50 * zclib.hM)
	action:Dock(BOTTOM)
	action:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
end


///////////
/////////// Actions
// This creates our Action Panel
local ActionsContent
function zrush.Machine.Actions(parent)
	if IsValid(ActionsContent) then ActionsContent:Remove() end

	ActionsContent = vgui.Create("DPanel", parent)
	ActionsContent:Dock(FILL)
	ActionsContent:DockPadding(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	ActionsContent.Paint = function(s, w, h)
		draw.SimpleText(zrush.language["Actions"], zclib.GetFont("zclib_font_big"), 20 * zclib.wM, 0 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local list, scroll = zrush.vgui.List(ActionsContent)
	scroll:Dock(FILL)
	scroll:DockMargin(0 * zclib.wM, 25 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	scroll.Paint = function(s, w, h) end

	for k,v in ipairs(zrush.MachineActions) do
		if not v.check(zrush.vgui.ActiveEntity) then continue end
		local btn = list:Add("DButton")
		btn:SetText("")
		btn:SetSize(100 * zclib.wM, 100 * zclib.hM)
		btn:SetAutoDelete(true)
		btn.DoClick = function()
			surface.PlaySound("zrush/zrush_command.wav")

			net.Start("zrush_machine_Action")
			net.WriteEntity(zrush.vgui.ActiveEntity)
			net.WriteInt(k, 16)
			net.SendToServer()
		end
		btn.Paint = function(s, w, h)
			surface.SetDrawColor(v.color)
			surface.SetMaterial(zrush.default_materials["ui_action_button"])
			surface.DrawTexturedRect(0, 0, w, h)

			surface.SetDrawColor(zclib.colors["black_a50"])
			surface.SetMaterial(v.icon)
			surface.DrawTexturedRect(0, 0, w, h)

			if s:IsHovered() then
				surface.SetDrawColor(zrush.default_colors["green05"])
				surface.SetMaterial(zrush.default_materials["ui_action_button_hover"])
				surface.DrawTexturedRect(0, 0, w, h)
			end

			draw.SimpleText(v.name, zclib.GetFont("zclib_font_small"), w / 2, h - 5 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

			surface.SetDrawColor(255, 255, 255, 25)
			surface.SetMaterial(zrush.default_materials["ui_action_button_shine"])
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end


///////////
/////////// Actions
// This creates our Action Panel
local ShopContent
function zrush.Machine.ModuleShop(parent)
	if IsValid(ShopContent) then ShopContent:Remove() end

	ShopContent = vgui.Create("DPanel", parent)
	ShopContent:Dock(FILL)
	ShopContent:DockPadding(20 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
	ShopContent.Paint = function(s, w, h)
		if HasChaosEvent then
			draw.SimpleText(zrush.language["FixMachinefirst"], zclib.GetFont("zclib_font_big"), w / 2 , h / 2, zclib.colors["red01"], TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(zrush.language["ModuleShop"], zclib.GetFont("zclib_font_big"), 20 * zclib.wM, 5 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

	// Does the machine currently has a chaos event?
	if HasChaosEvent then
		return
	end


	// This generates a table with all the items that the user can buy
	local function ItemGenerator()
		local machineType = zrush.vgui.ActiveEntity.MachineID
		local ItemTable = {}

		for id, data in pairs(zrush.AbilityModules) do
			local MachineHasAllowedType

			local allowed_machines = zrush.Modules.CatchMachinesByType(data.type)

			// Does this module work for the current machine?
			if (table.Count(allowed_machines) > 0) then
				MachineHasAllowedType = allowed_machines[machineType]
			end

			// Is this Module allready installed?
			local Installed = table.HasValue(InstalledModules,id)

			// Is this type allready installed?
			local ModuleType_AllreadyInstalled = false

			for _, m_id in pairs(InstalledModules) do
				if zrush.AbilityModules[m_id] and zrush.AbilityModules[m_id].type == data.type then
					ModuleType_AllreadyInstalled = true
					break
				end
			end

			if (MachineHasAllowedType and not Installed and not ModuleType_AllreadyInstalled) then
				ItemTable[id] = data
			end
		end

		return ItemTable
	end
	local PurchaseableItems = ItemGenerator()


	local list, scroll = zrush.vgui.List(ShopContent)
	list:DockPadding(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	list:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
	scroll:Dock(FILL)
	scroll:DockMargin(0 * zclib.wM, 40 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
	scroll.Paint = function(s, w, h)
		if PurchaseableItems == nil or table.Count(PurchaseableItems) <= 0 then
			draw.DrawText(zrush.language["NonSocketfound"], zclib.GetFont("zclib_font_big"), w / 2 , 80 * zclib.hM, zclib.colors["white_a15"], TEXT_ALIGN_CENTER)
		end
	end

	for m_id, m_dat in pairs(PurchaseableItems) do

		// Does the player have the correct Rank do buy thsi module?
		local UserHasAllowedRank = zclib.Player.RankCheck(LocalPlayer(), m_dat.ranks)

		// Does the player have the correct Job do buy thsi module?
		local UserHasAllowedJob = zclib.Player.JobCheck(LocalPlayer(), m_dat.jobs)

		local itm = list:Add("DButton")
		itm:SetSize(345 * zclib.wM, 60 * zclib.hM)
		itm:SetAutoDelete(true)
		itm:SetText("")
		itm.Paint = function(s, w, h)

			draw.RoundedBox(h, 0, 0, w, h, zclib.colors["ui02"])
			draw.RoundedBox(5, w / 2, 0, w / 2, h, zclib.colors["ui02"])

			if s:IsHovered() then
				draw.RoundedBox(h, 0, 0, w, h, zclib.colors["ui_highlight"])
				draw.RoundedBox(5, w / 2, 0, w / 2, h, zclib.colors["ui_highlight"])
				//draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
			end


			if UserHasAllowedRank == false or UserHasAllowedJob == false then
				draw.SimpleText(zrush.language["Locked"], zclib.GetFont("zclib_font_medium"),h + 5 * zclib.wM, h / 2, zclib.colors["red01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				surface.SetDrawColor(zclib.colors["black_a100"])
				surface.SetMaterial(zclib.Materials.Get("icon_locked"))
				surface.DrawTexturedRect(w - h ,0, h, h )
			else
				draw.SimpleText(m_dat.name, zclib.GetFont("zclib_font_mediumsmall"), h + 5 * zclib.wM, 5 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(zclib.Money.Display(m_dat.price), zclib.GetFont("zclib_font_mediumsmall"), w - 10 * zclib.wM, h - 5 * zclib.hM, zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			end

			zrush.Modules.DrawSimple(m_id,h * 0.9,h * 0.9,h * 0.05,h * 0.05,zclib.colors["black_a50"])

			if m_id == SELECTED_MODULE_SHOP then
				surface.SetDrawColor(zclib.colors["white_a100"])
				surface.SetMaterial(zrush.default_materials["ui_circle_selection"])
				surface.DrawTexturedRect(h * 0.05, h * 0.05, h * 0.9, h * 0.9)
			end
		end
		itm.DoClick = function()

			SELECTED_MODULE_INSTALLED = nil

			/*
			if not zclib.Player.IsOwner(LocalPlayer(), zrush.vgui.ActiveEntity) then
				return
			end
			*/

			if UserHasAllowedRank == false then
				CustomNotify(zrush.language["WrongUserGroup"],NOTIFY_ERROR,3)
				return
			end

			if UserHasAllowedJob == false then
				CustomNotify(zrush.language["WrongJob"],NOTIFY_ERROR,3)
				return
			end

			SELECTED_MODULE_SHOP = m_id
			zrush.Machine.ModuleInfo(InfoPanel,m_id,false)
			surface.PlaySound("zrush/zrush_command.wav")
		end
	end
end
