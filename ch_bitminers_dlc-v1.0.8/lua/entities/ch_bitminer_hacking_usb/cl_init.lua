include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()
end

net.Receive( "CH_BITMINERS_DLC_StartHacking", function( length, ply )
	local hacking_time = net.ReadDouble()
	local bitminer_ent = net.ReadEntity()
	
	bitminer_ent.HackingCountdown = CurTime() + hacking_time
end )