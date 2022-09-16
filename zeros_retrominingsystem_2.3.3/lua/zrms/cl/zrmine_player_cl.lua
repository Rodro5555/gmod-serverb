if SERVER then return end

zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.Player_Initialize()
	zrmine.f.Debug("zrmine.f.Player_Initialize")

	net.Start("zrmine_Player_Initialize")
	net.SendToServer()
end

// Sends a net msg to the server that the player has fully initialized and removes itself
hook.Add("HUDPaint", "a_zrmine_PlayerInit_HUDPaint", function()
	zrmine.f.Debug("zrmine_PlayerInit_HUDPaint")

	zrmine.f.Player_Initialize()

	hook.Remove("HUDPaint", "a_zrmine_PlayerInit_HUDPaint")
end)
