if (not CLIENT) then return end
zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

local lastTrace = 0
local trace
local traceEnt
local lastEnt
local lastInserterEnt

local ShowInfoClasses = {
	"zrms_conveyorbelt", "zrms_conveyorbelt_n", "zrms_conveyorbelt_s", "zrms_conveyorbelt_c_left", "zrms_conveyorbelt_c_right",
	"zrms_inserter", "zrms_splitter", "zrms_sorter_bronze", "zrms_sorter_coal", "zrms_sorter_gold", "zrms_sorter_iron", "zrms_sorter_silver"
}

hook.Add("Think", "a_zrmine_EntityInfo", function()
	if (CurTime() > (lastTrace or 1)) then
		lastTrace = CurTime() + GetConVar("zrms_cl_highlight_refreshrate"):GetFloat()
		trace = LocalPlayer():GetEyeTrace()
		traceEnt = trace.Entity

		-- Disables the Info if we dont look at the same ent again
		if (IsValid(lastEnt) and traceEnt ~= lastEnt) then
			lastEnt.ShowInfo = false

			if lastEnt:GetClass() == "zrms_inserter" and IsValid(lastInserterEnt) then
				lastInserterEnt:SetColor(zrmine.default_colors["white02"])
			end

			lastEnt = nil
		end

		-- If the Player is not the owner of the prop and not a admin then we stop
		if not zrmine.f.IsAdmin(LocalPlayer()) and not zrmine.f.IsOwner(LocalPlayer(), traceEnt) then return end

		-- Enables Conveyorbelt Info
		if IsValid(traceEnt) and table.HasValue(ShowInfoClasses,traceEnt:GetClass()) then
			lastEnt = traceEnt
			lastEnt.ShowInfo = true

			if lastEnt:GetClass() == "zrms_inserter" then

				lastInserterEnt = lastEnt:GetModuleChild()

				if IsValid(lastInserterEnt) then

					lastInserterEnt:SetColor(zrmine.default_colors["red03"])
				end
			end
		end

		-- Disables the Info if we are too far away
		if not zrmine.f.InDistance(LocalPlayer():GetPos(), trace.HitPos, 200) and IsValid(lastEnt) then

			if lastEnt:GetClass() == "zrms_inserter" and IsValid(lastInserterEnt) then
				lastInserterEnt:SetColor(zrmine.default_colors["white02"])
			end

			lastEnt.ShowInfo = false
			lastEnt = nil
			lastInserterEnt = nil
		end

		if not IsValid(traceEnt) and IsValid(lastInserterEnt) then
			lastInserterEnt:SetColor(zrmine.default_colors["white02"])
		end
	end
end)
