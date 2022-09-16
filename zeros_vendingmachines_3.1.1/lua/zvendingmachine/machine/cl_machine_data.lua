if SERVER then return end
zvm = zvm or {}
zvm.Machine = zvm.Machine or {}
zvm.Actions = zvm.Actions or {}

// Called when the product data changed or the client requested that data
net.Receive("zvm_Machine_Data_Send", function(len,ply)
	zclib.Debug("zvm_Machine_Data_Send Netlen: " .. len)

	local machine = net.ReadEntity()
	local dataLength = net.ReadUInt(16)
	local dataDecompressed = util.Decompress(net.ReadData(dataLength))
	local data = util.JSONToTable(dataDecompressed)

	// Everything valid?
	if data == nil then return end
	if istable(data) == nil then return end
	if not IsValid(machine) then return end
	if data.products == nil then return end

	// Reset vars
	machine.LastNameIngrement = 0
	machine.CurStringCount = 1
	machine.MachineName = data.name
	machine.MoneyType = data.moneytype
	machine.NameConstruct = ""
	machine.LastMachineName = data.name

	// Rebuild product list
	machine.Products = table.Copy(data.products) or {}

	// Inform anyone who cares that this machines data got updated
	hook.Run("zvm_OnMachineDataUpdated",machine)

	// Updates the product carousel for the idle mode
	zvm.Machine.UpdateProductCarousel(machine)

	// Tell the player that he got the up to date data
	machine.HasRequestedData = true

	// Checks if the machine gets even drawn before creating the interface
	if not zvm.Machine.IsDrawn(machine) then return end

	// If the main panel does not exist then we stop
	if machine.VGUI == nil or not IsValid(machine.VGUI.Main) then return end

	// Show the interface if it is hidden
	if machine.VGUI and IsValid(machine.VGUI.Main) and machine.VGUI.Main:IsVisible() == false then
		machine.VGUI.Main:SetVisible(true)
	end

	//If the player is to far away then we stop
	if zclib.util.InDistance(LocalPlayer():GetPos(), machine:GetPos(), 600) == false then return end

	// Does the machine has a user currently?
	local machineuser = machine:GetMachineUser()
	if IsValid(machineuser) then

		// Are we the user?
		if LocalPlayer() == machineuser then

			// Are we editing the config?
			if machine:GetEditConfig() then

				// Switch to config interface
				if IsValid(machine.VGUI.ConfigPanel) then

					zvm.Machine.EditProduct(machine)
				else

					zvm.Machine.ConfigInterface(machine)
				end
			else
				// Are we currently looking at the product list?
				if machine.VGUI and IsValid(machine.VGUI.ProductPanel) then
					// Rebuild product list
					zvm.Machine.ProductList(machine)
				else
					// Switch to Buy interface
					zvm.Machine.BuyInterface(machine)
				end
			end
		else
			// Switch to Busy Interface
			zvm.Machine.BusyInterface(machine)
		end
	else
		// Switch to Advertisment
		zvm.Machine.IdleInterface(machine)
	end
end)
