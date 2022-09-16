zgo2 = zgo2 or {}
zgo2.Joint = zgo2.Joint or {}
zgo2.Joint.List = zgo2.Joint.List or {}

/*

	Bongs are used to smoke da weed

*/

function zgo2.Joint.Initialize(Joint)
	Joint:SetHoldType(Joint.HoldType)
	Joint.LastWeed = -1
	Joint.LastWeedAmount = -1
	Joint.WeedLevel = -1
end

function zgo2.Joint.DrawHUD(Joint)
	local weed = Joint:GetWeedID()

	if Joint.LastWeed ~= weed then
		Joint.LastWeed = weed

		if Joint.LastWeed ~= -1 then
			Joint.WeedLevel = Joint:GetWeedAmount()
		end
	end

	local weed_amount = Joint:GetWeedAmount()

	if Joint.LastWeedAmount ~= weed_amount then
		Joint.LastWeedAmount = weed_amount
	end

	if Joint.LastWeed ~= -1 then
		Joint.WeedLevel = Joint.WeedLevel - 2 * FrameTime()
		Joint.WeedLevel = math.Clamp(Joint.WeedLevel, Joint.LastWeedAmount, zgo2.config.DoobyTable.WeedPerJoint)
		local width = (315 / zgo2.config.DoobyTable.WeedPerJoint) * Joint.WeedLevel
		draw.RoundedBox(5, 800 * zclib.wM, 1027 * zclib.hM, 320 * zclib.wM, 45 * zclib.hM, zclib.colors[ "black_a100" ])
		draw.RoundedBox(5, 803 * zclib.wM, 1029 * zclib.hM, width * zclib.wM, 41 * zclib.hM, zgo2.Plant.GetColor(weed))
		draw.SimpleText(zgo2.Plant.GetName(weed), zclib.GetFont("zclib_font_medium"), 960 * zclib.wM, 1065 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
end

function zgo2.Joint.Think(Joint)
	zclib.util.LoopedSound(LocalPlayer(), "zgo2_joint_loop", Joint:GetIsSmoking())
end

function zgo2.Joint.Holster(Joint)
	if IsValid(LocalPlayer()) then
		LocalPlayer():StopSound("zgo2_joint_loop")
	end
end

function zgo2.Joint.OnRemove(Joint)
	if IsValid(LocalPlayer()) then
		LocalPlayer():StopSound("zgo2_joint_loop")
	end
end
