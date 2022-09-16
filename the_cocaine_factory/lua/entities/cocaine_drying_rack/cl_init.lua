include( "shared.lua" )

net.Receive( "COCAINE_DryerLoadingBar", function( length, ply )
	cocaine_dryer = net.ReadEntity()
	
	cocaine_dryer.LoadingBar = CurTime() + 10
end )

function ENT:Draw()	
	self:DrawModel()
end

local DryValue = 0
local LastThink = 0
local DrySpeed = ( 106 / TCF.Config.DryingTime ) -- 106 is 1 second

net.Receive( "COCAINE_DryCocaine", function( length, ply )
	local drying_rack = net.ReadEntity()
	local dry_value = net.ReadBool()
	
	drying_rack.DryingCocaine = dry_value
	if dry_value then
		DryValue = 0
	else
		DryValue = 100
	end
end )

local CurNumber = 0
local SwitchSpeed = 400

net.Receive( "COCAINE_DryingSwitch", function( length, ply )
	local drying_rack = net.ReadEntity()
	local switch_value = net.ReadBool()
	
	drying_rack.SwitchOn = switch_value
	if switch_value then
		CurNumber = 0
	else
		CurNumber = 100
	end
end )

function ENT:Think()
	local now = CurTime()
	local timepassed = now - LastThink
	LastThink = now
	
	if self.DryingCocaine then
		DryValue = math.Approach( DryValue, 100, DrySpeed * timepassed )
		
		self:SetPoseParameter( "thermometer", DryValue )
	else
		DryValue = math.Approach( DryValue, 0, DrySpeed * timepassed )
		
		self:SetPoseParameter( "thermometer", DryValue )
	end
	
	if self.SwitchOn then
		CurNumber = math.Approach( CurNumber, 100, SwitchSpeed * timepassed )
		
		self:SetPoseParameter( "switch", CurNumber )
	else
		CurNumber = math.Approach( CurNumber, 0, SwitchSpeed * timepassed )
		
		self:SetPoseParameter( "switch", CurNumber )
	end
	
	-- Battery Charge Amount
	if self:GetBatteryCharge() >= 0 then
		self:SetPoseParameter( "power", self:GetBatteryCharge() )
	end
	
	self:InvalidateBoneCache()
end