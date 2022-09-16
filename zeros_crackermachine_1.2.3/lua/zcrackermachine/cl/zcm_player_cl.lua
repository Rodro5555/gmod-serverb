if SERVER then return end

zcm = zcm or {}
zcm.f = zcm.f or {}

function zcm.f.Player_Initialize()
	zcm.f.Debug("zcm.f.Player_Initialize")

	net.Start("zcm_Player_Initialize")
	net.SendToServer()
end

// Sends a net msg to the server that the player has fully initialized and removes itself
hook.Add("HUDPaint", "a_zcm_PlayerInit_HUDPaint", function()
	zcm.f.Debug("zcm_PlayerInit_HUDPaint")

	zcm.f.Player_Initialize()

	hook.Remove("HUDPaint", "a_zcm_PlayerInit_HUDPaint")
end)
