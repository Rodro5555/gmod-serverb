ztm = ztm or {}
ztm.util = ztm.util or {}

function ztm.Print(msg)
	print("[Zero´s Trashman] " .. msg)
end


if (CLIENT) then

	// Checks if the entity did not got drawn for certain amount of time and call update functions for visuals
	function ztm.util.UpdateEntityVisuals(ent)
		if zclib.util.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 1000) then

			local curDraw = CurTime()

			if ent.LastDraw == nil then
				ent.LastDraw = CurTime()
			end

			if ent.LastDraw < (curDraw - 1) then
				//print("Entity: " .. ent:EntIndex() .. " , Call UpdateVisuals() at " .. math.Round(CurTime()))

				ent:UpdateVisuals()
			end

			ent.LastDraw = curDraw
		end
	end
end
