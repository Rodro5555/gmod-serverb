include("shared.lua")

-- The color :think:
local secondary = Color(0,0,0,85)

function ENT:Initialize()
	self.requestedInfo = false
	self.cooldown = 0
end

function ENT:Draw()
	self:DrawModel()

	-- Get the position once.
	local getpos = self:GetPos()

	-- Distance Check
	if LocalPlayer():GetPos():DistToSqr(getpos) > 120000 then return end 

	-- Request the dumpster info when the player is close enough to need it.
	if not self.requestedInfo then 
		self.requestedInfo = true 
		net.Start("bdumpster_request_info")
			net.WriteUInt(self:EntIndex(), 16)
		net.SendToServer()
	end

	-- Draw the 3D2D
	local pos = getpos + ( self:GetAngles():Forward() * 21.16) + ( self:GetAngles():Up() *10.4  ) + (self:GetAngles():Right() *25.3)
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
 	cam.Start3D2D(pos,Angle(ang.p,ang.y,ang.r+97), 0.113)
		draw.SimpleText(self.cooldown < CurTime() and "Empty Me" or ("Cooldown: "..math.Round(self.cooldown-CurTime(), 0)),"bdumpster_main",455/2,100/2,secondary,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
 	cam.End3D2D()

end

