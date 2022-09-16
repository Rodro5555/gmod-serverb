if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Actions = zvm.Actions or {}

zvm.Machines = zvm.Machines or {}
zclib.Hook.Add("PostDrawOpaqueRenderables", "zvm_DrawInterface", function(depth, skybox,isDraw3DSkybox)
	if isDraw3DSkybox == false then
		for machine, _ in pairs(zvm.Machines) do
			if IsValid(machine) then
				zvm.Machine.Draw(machine)
			end
		end
	end
end)

function zvm.Machine.Initialize(Machine)
	zclib.Debug("zvm.Machine.Initialize")

	zclib.EntityTracker.Add(Machine)

	Machine.LastMachineName = "Vendingmachine"

	Machine.MoneyType = 1

	Machine.LastNameIngrement = 0
	Machine.CurStringCount = 1
	Machine.MachineName = "Vendingmachine"
	Machine.NameConstruct = ""

	Machine.LastUser = -1
	Machine.LastEditConfig = -1
	Machine.Wait = true

	timer.Simple(1, function()
		if IsValid(Machine) then
			Machine.LastMachineName = Machine.MachineName
			Machine.Wait = false
		end
	end)

	Machine.RequestedData = false
	Machine.HasRequestedData = false

	zvm.Actions.ResetSelections(Machine)

	Machine.Products = {}

	// Product carousel for Idle switch mode
	Machine.ProductCarousel = {}

	// Current Displayed item in idle mode
	Machine.Idle_ProductID = 1

	// The currently shown product data in idle mode
	Machine.Idle_ProductData = nil

	Machine.VGUI = {}

	Machine.Page = 1

	zvm.Machine.InitMaterial(Machine)
end

function zvm.Machine.Think(Machine)
	zclib.util.LoopedSound(Machine, "zvm_screen_noise", true)

	if Machine.Wait then return end

	if zclib.util.InDistance(LocalPlayer():GetPos(), Machine:GetPos(), 500) then

		if Machine.RequestedData == false then
			if LocalPlayer().zvm_NextDataRequest and CurTime() < LocalPlayer().zvm_NextDataRequest then return end

			// Lets just make sure the machine is in the list
			if zvm.Machines[Machine] == nil then
				zvm.Machines[Machine] = true
			end

			// Sends Request to server
			net.Start("zvm_Machine_Data_Request")
			net.WriteEntity(Machine)
			net.SendToServer()

			LocalPlayer().zvm_NextDataRequest = CurTime() + 0.15
			Machine.RequestedData = true

			timer.Simple(1, function()
				if IsValid(Machine) and Machine.HasRequestedData == false then
					zclib.Debug("zvm_Machine_Data_Request FAILED!, Entity: " .. Machine:EntIndex())
					Machine.RequestedData = false
				end
			end)
		end
	else
		Machine.HasRequestedData = false
		Machine.RequestedData = false
	end
end

// The Main Panel
function zvm.Machine.MainInterface(Machine)

	zclib.Debug("zvm.Machine.MainInterface")
	Machine.VGUI.Main = vgui.Create("DPanel")
	Machine.VGUI.Main:ParentToHUD()
	Machine.VGUI.Main:SetMouseInputEnabled(true)
	Machine.VGUI.Main:SetPos(0, 0)
	Machine.VGUI.Main:SetSize(410 / zvm.Machine.util.sm, 630 / zvm.Machine.util.sm)
	Machine.VGUI.Main.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, zvm.colors["grey01"])
	end

	if zclib.Player.IsAdmin(LocalPlayer()) or zclib.Player.IsOwner(LocalPlayer(), Machine) then
		zvm.Machine.ConfigButton(Machine)
	end
end

// Checks if the machine gets drawn currently
function zvm.Machine.IsDrawn(Machine)
	if not Machine.LastDraw then return false end
	if Machine.LastDraw < (CurTime() - 0.25) then
		return false
	else
		return true
	end
end

// Gets called once the machine gets drawn again
function zvm.Machine.UpdateVisuals(Machine)
	zclib.Debug("zvm.Machine.UpdateVisuals")

	if not IsValid(Machine) then return end

	//If the player is to far away then we stop
	if zclib.util.InDistance(LocalPlayer():GetPos(), Machine:GetPos(), 600) == false then return end

	// If the main panel does not exist then we stop
	if Machine.VGUI == nil or not IsValid(Machine.VGUI.Main) then return end

	if not LocalPlayer():IsLineOfSightClear( Machine ) then return end

	// Updates the interface
	zvm.Machine.UpdateInterface(Machine)
end

// The Draw Function of the Interface
function zvm.Machine.Draw(Machine)

	if IsValid(Machine) and zclib.Convar.Get("zclib_cl_drawui") == 1 then

		// Is the player in distance?
		if zclib.util.InDistance(LocalPlayer():GetPos(), Machine:GetPos(), 600) then

			// Is the machine not waiting and do we have the data?
			if Machine.Wait == false and Machine.HasRequestedData then
				zvm.Machine.DrawInterface(Machine)
				zvm.Machine.Draw2D3D(Machine)
			end
		else

			// Hide the interface
			if Machine.VGUI and IsValid(Machine.VGUI.Main) and Machine.VGUI.Main:IsVisible() == true then
				Machine.VGUI.Main:SetVisible(false)
			end
		end
	end
end

function zvm.Machine.TitleAnim(Machine)
	if zvm.config.Vendingmachine.Visuals.AnimateTitle then
		local stringCount = string.len(Machine.MachineName)

		// This constructs the MachineName
		if CurTime() > Machine.LastNameIngrement  then
			Machine.LastNameIngrement = CurTime() + 0.5

			if Machine.CurStringCount < stringCount then
				Machine.CurStringCount = Machine.CurStringCount + 1
			elseif Machine.CurStringCount < stringCount + 4 then
				Machine.CurStringCount = Machine.CurStringCount + 1
			else
				Machine.CurStringCount = 1
			end

			Machine.NameConstruct = string.sub( Machine.MachineName, 1, Machine.CurStringCount )
		end

		// If the string gets build or its in the final phase then we draw it
		// This makes sure the title blinks at the end
		if Machine.CurStringCount < stringCount or Machine.CurStringCount == stringCount or Machine.CurStringCount == stringCount + 2 or Machine.CurStringCount == stringCount + 4 then
			draw.SimpleText(Machine.NameConstruct, zclib.util.FontSwitch(Machine.NameConstruct,20,zclib.GetFont("zvm_machine_name"),zclib.GetFont("zvm_machine_name_small")), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		if CurTime() > Machine.LastNameIngrement then

			if Machine.ShowTitle == nil then
				Machine.ShowTitle = true
			end

			Machine.ShowTitle = not Machine.ShowTitle

			Machine.LastNameIngrement = CurTime() + 1

		end

		if Machine.ShowTitle then
			draw.SimpleText(Machine.MachineName, zclib.util.FontSwitch(Machine.MachineName, 20, zclib.GetFont("zvm_machine_name"), zclib.GetFont("zvm_machine_name_small")), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

local d_pos = Vector(0, 23.1, 106)
local d_ang = Angle(0, 180, 90)
function zvm.Machine.Draw2D3D(Machine)
	cam.Start3D2D(Machine:LocalToWorld(d_pos), Machine:LocalToWorldAngles(d_ang), 0.1)
		draw.RoundedBox(5, -220 , -50, 440, 100,  color_black)

		zvm.Machine.TitleAnim(Machine)

		local dist = LocalPlayer():GetPos():DistToSqr(Machine:GetPos())
		surface.SetDrawColor(Color(0, 0, 0, math.Clamp(100 - ((100 / 40000) * dist ), 0, 100)))
		surface.SetMaterial(zvm.materials["zvm_scanlines"])
		surface.DrawTexturedRect(-205, 98, 350, 630)

		if zvm.config.Vendingmachine.Visuals.ScreenDirt then
			surface.SetDrawColor(color_black)
			surface.SetMaterial(zvm.materials["zvm_screen_dirt"])
			surface.DrawTexturedRect(-178, 98, 305, 630)
		end
	cam.End3D2D()
end

local m_pos = Vector(17.5, 23.1, 96.3)
local m_ang = Angle(0, 180, 90)
function zvm.Machine.DrawInterface(Machine)
	zclib.vgui3d.Start3D2D(Machine:LocalToWorld(m_pos), Machine:LocalToWorldAngles(m_ang), zvm.Machine.util.vscale)

		if Machine.VGUI and IsValid(Machine.VGUI.Main) then

			if Machine.VGUI and IsValid(Machine.VGUI.Main) and Machine.VGUI.Main:IsVisible() == false then Machine.VGUI.Main:SetVisible(true) end

			// Draws the UI
			Machine.VGUI.Main:ZCLIBPaint3D2D()

			// Cursor
			if zclib.vgui3d.IsPointingPanel(Machine.VGUI.Main) then
				local x, y = zclib.vgui3d.GetCursorPosition(Machine.VGUI.Main)
				surface.SetDrawColor(color_white)
				surface.SetMaterial(zvm.materials["zvm_cursor"])
				surface.DrawTexturedRect(x - 5 / zvm.Machine.util.sm, y - 5 / zvm.Machine.util.sm, 10 / zvm.Machine.util.sm, 10 / zvm.Machine.util.sm)
			end

			// Updates the interface
			zvm.Machine.UpdateInterface(Machine)
		else
			zvm.Machine.MainInterface(Machine)
		end
	zclib.vgui3d.End3D2D()
end

// This should update the interface if a player starts interacting with the machine
function zvm.Machine.UpdateInterface(Machine)

	local machineuser = Machine:GetMachineUser()
	if Machine.LastUser ~= machineuser then
		zclib.Debug("zvm.Machine.UpdateInterface")

		Machine.LastUser = machineuser

		if IsValid(Machine.LastUser) then
			if LocalPlayer() == Machine.LastUser then

				// If the user is editing the config then we stop here
				if Machine:GetEditConfig() == true then return end

				// Switch to Buy interface
				zvm.Machine.BuyInterface(Machine)
			else
				// Switch to Busy Interface
				zvm.Machine.BusyInterface(Machine)
			end
		else

			// Switch to Advertisment
			zvm.Machine.IdleInterface(Machine)
		end

		if zclib.Player.IsAdmin(LocalPlayer()) or zclib.Player.IsOwner(LocalPlayer(), Machine) then
			zvm.Machine.ConfigButton(Machine)
		end
	end
end

// Gets called when the machine gets removed
function zvm.Machine.OnRemove(Machine)
	zclib.Debug("zvm.Machine.OnRemove")

	Machine:StopSound("zvm_screen_noise")

	if IsValid(Machine) and Machine.VGUI and IsValid(Machine.VGUI.Main) then
		zclib.Debug("Machine_Interface_Removed")
		Machine.VGUI.Main:Remove()
	end

	// Adds the machine to get rendered
	zvm.Machines[Machine] = nil
end

function zvm.Actions.ResetSelections(Machine)
	Machine.SelectedItem = -1
	Machine.BuyList = {}
	Machine.BuyCost = 0
	Machine.BuyCount = 0
end
////////////////////////////////////////////
////////////////////////////////////////////


////////////////////////////////////////////
//////////////// Busy Interface /////////////
////////////////////////////////////////////
function zvm.Machine.BusyInterface(Machine)
	zclib.Debug("zvm.Machine.BusyInterface")

	if Machine.VGUI and IsValid(Machine.VGUI.Content) then
		Machine.VGUI.Content:Remove()
	end

	Machine.VGUI.Content = zvm.Machine.util.Page(Machine.VGUI.Main)
	Machine.VGUI.Content.Paint = function(s, w, h)
		surface.SetDrawColor(Color(255, 255, 255, math.abs(math.sin(CurTime() * 1) * 255)))
		surface.SetMaterial(zclib.Materials.Get("icon_loading"))
		local rot = CurTime() * -700
		rot = zclib.util.SnapValue(36, rot)
		surface.DrawTexturedRectRotated(150 / zvm.Machine.util.sm, 300 / zvm.Machine.util.sm, 150 / zvm.Machine.util.sm, 150 / zvm.Machine.util.sm, rot)
	end
end
////////////////////////////////////////////
////////////////////////////////////////////


// Sends a net msg to server that the machine appearance got changed
function zvm.Actions.RequestPayout(Machine)
	zclib.Debug("zvm.Actions.ApplyAppearance")
	surface.PlaySound("UI/buttonclick.wav")

	Machine:EmitSound("zvm_cash01")

	net.Start("zvm_Machine_Payout")
	net.WriteEntity(Machine)
	net.SendToServer()
end
