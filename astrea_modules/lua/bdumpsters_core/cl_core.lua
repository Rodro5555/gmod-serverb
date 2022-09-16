net.Receive("bdumpster_send_info", function()
	local cooldown = net.ReadUInt(32)
	
	local index = net.ReadUInt(16)
	local ent = Entity(index)

	if not IsValid(ent) or ent:GetClass() != "bdumpster" then return end 

	ent.cooldown = cooldown

end)


net.Receive("bdumpster_opened", function()
	local cooldown = net.ReadUInt(32)
	
	local index = net.ReadUInt(16)
	local ent = Entity(index)

	if not IsValid(ent) or ent:GetClass() != "bdumpster" then return end 

	ent.cooldown = cooldown
end)

net.Receive("bdumpsters_msg", function()
	local msg = net.ReadString()
	local prefix = net.ReadString()

	bDumpsters.Message(LocalPlayer(), msg, prefix)
end)

-- Create the font.
surface.CreateFont( "bdumpster_main", {
	font = "Trebuchet24", 
	size = 66,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	bold = true
});


