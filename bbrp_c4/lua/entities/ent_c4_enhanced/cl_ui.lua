surface.CreateFont("C4.Enhanced.UIDisplay", {
	font = "Tahoma",
	size = 50,
	weight = 500
})

local convarMin = GetConVar("c4_enhanced_mintimer")
local convarMax = GetConVar("c4_enhanced_maxtimer")

net.Receive("C4EnhancedOpenMenu", function()
	local ent = net.ReadEntity()

	local ui = vgui.Create("DFrame")

	ui:SetSize(200, 139)
	ui:Center()
	ui:SetTitle("C4")
	ui:MakePopup()

	ui.Entity = ent
	ui.Timer = 0

	function ui:Think()
		if self:IsActive() and input.IsKeyDown(KEY_ESCAPE) then
			self:Close()
			gui.HideGameUI()
		end

		if not IsValid(self.Entity) or self.Entity:IsArmed() then
			self:Close()
		end
	end

	function ui:SetTimer(time)
		self.Timer = math.Clamp(time, convarMin:GetInt(), convarMax:GetInt())
		self.Display:SetValue(os.date("%M:%S", self.Timer))
	end

	function ui:AddButton(x, y, text, change)
		local button = ui:Add("DButton")

		button:SetPos(x, y)
		button:SetSize(19, 19)
		button:SetText(text)

		function button.DoClick()
			ui:SetTimer(ui.Timer + change)

			ui.Arm:SetDisabled(true)
			ui.Arm:SetText("Arm")

			net.Start("C4EnhancedClickMenu")
				net.WriteEntity(ui.Entity)
			net.SendToServer()
		end
	end

	ui.Display = ui:Add("DTextEntry")
	ui.Display:SetFont("C4.Enhanced.UIDisplay")
	ui.Display:SetPos(5, 53)
	ui.Display:SetSize(110, 55)
	ui.Display:SetDisabled(true)

	ui:SetTimer(math.Round(ent:GetTimer()))

	ui:AddButton(10, 30, "+", 600)
	ui:AddButton(10, 113, "-", -600)

	ui:AddButton(32, 30, "+", 60)
	ui:AddButton(32, 113, "-", -60)

	ui:AddButton(69, 30, "+", 10)
	ui:AddButton(69, 113, "-", -10)

	ui:AddButton(91, 30, "+", 1)
	ui:AddButton(91, 113, "-", -1)

	ui.Set = ui:Add("DButton")
	ui.Set:SetPos(120, 30)
	ui.Set:SetSize(74, 30)
	ui.Set:SetText("Set")

	function ui.Set:DoClick()
		ui.Arm:SetDisabled(false)
		ui.Arm:SetText(ui.Timer == 0 and "Detonate" or "Arm")

		net.Start("C4EnhancedSet")
			net.WriteEntity(ui.Entity)
			net.WriteUInt(ui.Timer, 12)
		net.SendToServer()
	end

	ui.Arm = ui:Add("DButton")
	ui.Arm:SetPos(120, 66)
	ui.Arm:SetSize(74, 30)
	ui.Arm:SetText("Arm")
	ui.Arm:SetDisabled(ent:GetTimer() == 0)

	function ui.Arm:DoClick()
		net.Start("C4EnhancedArm")
			net.WriteEntity(ui.Entity)
		net.SendToServer()

		ui:Close()
	end

	ui.Pickup = ui:Add("DButton")
	ui.Pickup:SetPos(120, 102)
	ui.Pickup:SetSize(74, 30)
	ui.Pickup:SetText("Pick up")

	function ui.Pickup:DoClick()
		net.Start("C4EnhancedPickup")
			net.WriteEntity(ui.Entity)
		net.SendToServer()
	end
end)
