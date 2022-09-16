zgo2 = zgo2 or {}
zgo2.Waterlines = zgo2.Waterlines or {}
zgo2.Waterlines.List = zgo2.Waterlines.List or {}

/*

	Waterlines just visually show hoses between connected ents (Watertank > Pump) (Pump > pots)

*/
local gravity = Vector(0, 0, -0.2)
local damping = 0.5
local Length = 12
function zgo2.Waterlines.PreDraw()
	for ent,_ in pairs(zgo2.Pump.List) do
        if not IsValid(ent) then
			continue
		end

		if not ent.m_Initialized then continue end

		if zclib.util.InDistance(ent:GetPos(), LocalPlayer():GetPos(), 1000) == false then continue end

		if not ent.OutputEntities then continue end

		// Draw the output entities of the pump
		for k,v in pairs(ent.OutputEntities) do zgo2.Waterlines.Draw(ent,k,false) end

		// Draw the watertank cable of the pump
		if IsValid(ent.InputEntity) then
			zgo2.Waterlines.Draw(ent,ent.InputEntity,true)
		end
    end
end


local rope_beam = Material("zerochain/zgo2/cable/cable_hose")
local HosePos = {
	["models/zerochain/props_growop2/zgo2_pump.mdl"] = Vector(0,0,0),
	["models/zerochain/props_growop2/zgo2_pot01.mdl"] = Vector(-10,0,2.5),
	["models/zerochain/props_growop2/zgo2_pot02.mdl"] = Vector(-10,0,2.5),
	["models/zerochain/props_growop2/zgo2_pot03.mdl"] = Vector(-10,0,2.5),
	["models/zerochain/props_growop2/zgo2_pot04.mdl"] = Vector(-10,0,2.5),
	["models/zerochain/props_growop2/zgo2_pot05.mdl"] = Vector(-10,0,2.5),
	["models/zerochain/props_growop2/zgo2_watertank.mdl"] = Vector(0,53,6),
	["models/zerochain/props_growop2/zgo2_watertank_small.mdl"] = Vector(0,0,0),
}
function zgo2.Waterlines.GetHosePos(ent)
	return HosePos[ent:GetModel()] or vector_origin
end

function zgo2.Waterlines.Draw(pump,ent,IsInput)
	if not IsValid(pump) or not IsValid(ent) then
		if IsValid(ent) then
			ent.LinePoints = nil
		end
		return
	end

	local from = IsInput and pump:LocalToWorld(pump.InputPos) or pump:LocalToWorld(pump.OutputPos)
	local to = ent:LocalToWorld(zgo2.Waterlines.GetHosePos(ent))

	if not to then ent.LinePoints = nil
		return
	end

	// Render the rope
	local r_start = from

	// Create rope points
	if ent.LinePoints == nil then
		ent.LinePoints = zclib.Rope.Setup(Length, r_start)
	end

	// Updates the Rope points to move physicly
	if ent.LinePoints and table.Count(ent.LinePoints) > 0 then
		zclib.Rope.Update(ent.LinePoints, r_start, to, Length, gravity, damping)
	end

	// If the pot is on a rack then drop the waterline to the ground aka the same height as the pump
	if IsValid(ent) and ent:GetClass() == "zgo2_pot" and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "zgo2_rack" then
		local FromPos = pump:GetPos()
		ent.LinePoints[#ent.LinePoints-1].position = Vector(to.x,to.y,FromPos.z)

		ent.LinePoints[2].position = Vector(from.x,from.y,FromPos.z) + pump:GetRight() * -3
	end

	// Draw the rope
	zclib.Rope.Draw(ent.LinePoints, r_start, to, Length, rope_beam, nil, color_white,2)
end
