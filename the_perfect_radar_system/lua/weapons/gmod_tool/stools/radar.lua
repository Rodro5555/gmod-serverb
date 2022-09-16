TOOL.Category = "Diablos Tool"
TOOL.Name = "Radar Placer"

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}
	language.Add("tool.radar.name", "Radar Placer")
	language.Add("tool.radar.desc", "Create or modify a radar using the Diablos's toolgun.")
	language.Add("tool.radar.left", "Create a radar or modify a radar you clicked")
	language.Add("tool.radar.right", "Switch between purposes")
	language.Add("tool.radar.reload", "Return to the main toolscreen")
end

local RadarTypes = {
	["english_speed_camera"] = 1,
	["french_speed_camera"] = 2,
	["discriminating_camera"] = 3,
	["educational_camera"] = 4,
	["average_camera_begin"] = 5,
	["average_camera_end"] = 6,
	["stop_camera"] = 7,
	["pedestrian_camera"] = 8,
	["sign"] = 9,
}

local level, max, radaraddon, extranum, edit, extras, distance, veh_height, lastpos
local function ResetVars()
	level = 1
	max = 3
	radaraddon, extranum = 0, 0
	edit, extras = 0, 0
	distance, veh_height = 0, 0
	lastpos = nil
end
ResetVars()

local function CreateTimer(ply)
	if IsValid(ply) then
		local steamid64 = ply:SteamID64()
		lastpos = ply:GetPos()
		timer.Create(steamid64 .. "distancepoints", 0, 0, function()
			if IsValid(ply) then
				distance = distance + lastpos:Distance(ply:GetPos())
				lastpos = ply:GetPos()
			else
				timer.Remove(steamid64 .. "distancepoints")
			end
		end)
	end
end

function TOOL:LeftClick(trace)
	if not IsFirstTimePredicted() then return end
	local ply = self:GetOwner()
	if not Diablos.RS.AdminGroups[ply:GetUserGroup()] then return end

	local radartypenum = level
	if radaraddon == 2 then radartypenum = radartypenum + 2 end
	if radaraddon == 3 then radartypenum = radartypenum + 6 end

	local stage = self:GetStage()
	if stage == 1 then edit, extras = level - 1, level - 2 max = 3 end -- for the stage 2 there will be 3 cases
	if edit != 1 and extras != 1 then
		if stage == 2 then
			radaraddon = level
			if radaraddon == 1 then
				max = 2
			elseif radaraddon == 2 then
				if Diablos.RS.DLC1 then
					max = 4
				else
					self:SetStage(1)
					ResetVars()
					return
				end
			elseif radaraddon == 3 then
				if Diablos.RS.DLC2 then
					max = 3
				else
					self:SetStage(1)
					ResetVars()
					return
				end
			end
		end
		self:SetStage(stage + 1)
		if stage == 4 then self:SetStage(1) ResetVars() end
		level = 1
	elseif edit == 1 then
		self:SetStage(2)
	else
		if stage == 1 then
			self:SetStage(stage + 1)
		elseif stage == 2 then
			extranum = level
			self:SetStage(stage + 1)
		elseif stage == 3 then
			if extranum == 1 then
				distance, lastpos = 0, nil
				CreateTimer(self:GetOwner())
			elseif extranum == 2 then
				if IsValid(trace.Entity) then
					veh_height = math.abs(trace.Entity:OBBMins().z) + trace.Entity:OBBMaxs().z
				else
					veh_height = 0
				end
			end
		end
		level = 1
	end

	if edit != 1 and extras != 1 and self:GetStage() == 4 then
		self:Reload(trace)
		if SERVER then
			net.Start("TPRSA:AdminVGUI")
				net.WriteEntity(nil)
				net.WriteUInt(radartypenum, 5)
			net.Send(self:GetOwner())
		end
	elseif edit == 1 then
		self:Reload(trace)
		if SERVER then
			local ent = nil
			local radartypenum = -1
			local ent = trace.Entity
			if IsValid(ent) then
				local radartypeclass = ent:GetClass()
				if Diablos.RS.SignList[radartypeclass] then radartypeclass = "sign" end
				radartypenum = RadarTypes[radartypeclass]
				if not radartypenum then return end
			end

			if IsValid(ent) then
				net.Start("TPRSA:AdminVGUI")
					net.WriteEntity(ent)
					net.WriteUInt(radartypenum, 5)
				net.Send(self:GetOwner())
			end
		end
	end
	return true
end


function TOOL:RightClick(trace)
	if not IsFirstTimePredicted() then return end
	level = level + 1
	if level > max then level = 1 end
	return false
end

function TOOL:Reload(trace)
	if not IsFirstTimePredicted() then return end
	local steamid64 = self:GetOwner():SteamID64()
	if timer.Exists(steamid64.."distancepoints") then timer.Remove(steamid64 .. "distancepoints") end
	ResetVars()
	self:SetStage(1)
	return false
end

function TOOL:Allowed() return Diablos.RS.AdminGroups[self:GetOwner():GetUserGroup()] end

function TOOL:Deploy() self:SetStage(1) end

local col = {
	b = Color(20, 20, 20, 255),
	grey = Color(100, 100, 100, 100),
	grey_light = Color(200, 200, 200, 100),
	w = Color(200, 200, 200, 255),
	r = Color(150, 0, 0, 100),
	r_light = Color(200, 30, 30, 110),
	g = Color(0, 150, 0, 100),
	g_light = Color(30, 200, 30, 110),
}


function TOOL:DrawToolScreen(width, height)
	surface.SetDrawColor(col.b)
	surface.DrawRect(0, 0, width, height)

	local stage = self:GetStage()

	local function ToolScreenTypes(numInfos, inRed, str1, str2, str3, str4)

		local function ChooseColor(id, var)
			if inRed then
				if var then 
					if level == id then surface.SetDrawColor(col.g_light) else surface.SetDrawColor(col.g) end
				else
					if level == id then surface.SetDrawColor(col.r_light) else surface.SetDrawColor(col.r) end
				end
			else
				if level == id then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			end
		end

		if numInfos == 2 then

			if level == 1 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 - 50, width - 40, 30)
			if level == 2 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 + 20, width - 40, 30)

			draw.SimpleText(str1, "DiablosRSToolgunFont1", width / 2, height / 2 - 35, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str2, "DiablosRSToolgunFont1", width / 2, height / 2 + 35, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		elseif numInfos == 3 then

			if level == 1 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 - 65, width - 40, 30)
			ChooseColor(2, Diablos.RS.DLC1)
			surface.DrawRect(20, height / 2 - 15, width - 40, 30)
			ChooseColor(3, Diablos.RS.DLC2)
			surface.DrawRect(20, height / 2 + 35, width - 40, 30)

			draw.SimpleText(str1, "DiablosRSToolgunFont1", width / 2, height / 2 - 50, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str2, "DiablosRSToolgunFont1", width / 2, height / 2, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str3, "DiablosRSToolgunFont1", width / 2, height / 2 + 50, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		elseif numInfos == 4 then

			if level == 1 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 - 90, width - 40, 30)
			if level == 2 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 - 40, width - 40, 30)
			if level == 3 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 + 10, width - 40, 30)
			if level == 4 then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, height / 2 + 60, width - 40, 30)

			draw.SimpleText(str1, "DiablosRSToolgunFont1", width / 2, height / 2 - 75, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str2, "DiablosRSToolgunFont1", width / 2, height / 2 - 25, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str3, "DiablosRSToolgunFont1", width / 2, height / 2 + 25, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(str4, "DiablosRSToolgunFont1", width / 2, height / 2 + 75, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end
	end

	if stage == 1 then
		ToolScreenTypes(3, false, "Create", "Edit / Remove", "Extras", "")
	elseif stage == 2 then
		if edit == 1 then
			draw.SimpleText("Left click on entity!", "DiablosRSToolgunFont2", width / 2, height / 2, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif extras == 1 then
			ToolScreenTypes(3, false, "Distance calc", "Vehicle height", "Credits", "")
		else
			ToolScreenTypes(3, true, "Main addon", "DLC #1", "DLC #2", "")
		end
	elseif stage == 3 then
		if extranum == 1 then -- radaraddon isn't touched
			draw.SimpleText("Left click: reset", "DiablosRSToolgunFont2", width / 2, height / 2 - 40, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Distance: " .. math.floor(distance), "DiablosRSToolgunFont1", width / 2, height / 2 + 40, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		elseif extranum == 2 then
			draw.SimpleText("Left click: select a veh", "DiablosRSToolgunFont2", width / 2, height / 2 - 40, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Vehicle height: " .. math.floor(veh_height), "DiablosRSToolgunFont1", width / 2, height / 2 + 40, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		elseif extranum == 3 then
			draw.SimpleText("Addon: Diablos", "DiablosRSToolgunFont2", width / 2, height / 2 - 50, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("EN/FR models: PYRO", "DiablosRSToolgunFont2", width / 2, height / 2, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("DLC models: D3RN", "DiablosRSToolgunFont2", width / 2, height / 2 + 50, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		elseif radaraddon == 1 then
			ToolScreenTypes(2, false, "English", "French", "", "")
		elseif radaraddon == 2 then
			ToolScreenTypes(4, false, "Discriminating", "Educational", "Average Begin", "Average End")
		elseif radaraddon == 3 then
			ToolScreenTypes(3, false, "Stop", "Pedestrian", "Sign", "")
		end
	end

	draw.SimpleText("Radar Placer Tool", "DiablosRSToolgunFont2", width / 2, 5, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("Created by Diablos", "DiablosRSToolgunFont2", width - 5, height - 5, col.w, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

if CLIENT then
	hook.Add("PostDrawOpaqueRenderables", "TPRSA:AdminRenderHook", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		if ply:InVehicle() then return end
		if not IsValid(ply:GetActiveWeapon()) then return end
		local wepclass = ply:GetActiveWeapon():GetClass()
		if (wepclass == "gmod_tool" and istable(ply:GetTool()) and ply:GetTool().Mode == "radar") or wepclass == "radar_infos" then
			local globtab = ents.GetAll()
			for k, ent in pairs(globtab) do
				if ent:GetClass() == "speed_camera_detector" or ent:GetClass() == "pedestrian_detector" or ent:GetClass() == "stop_detector" then
					local parent = ent:GetParentEnt()
					if IsValid(parent) then
						local min, max = ent:OBBMins(), ent:OBBMaxs()
						render.SetColorMaterial()
						render.SetColorModulation(1, 1, 1)
						render.DrawBox(ent:GetPos(), ent:GetAngles(), min, max, colw, true)
					end
				end
			end
		end
	end)
end