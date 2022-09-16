local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/Zerochain/props_mining/zrms_gravelcrate.mdl")
//ITEM:SetDescription("Used to store and sell metal bars.")

ITEM:SetDescription(function(self, tbl)
	local data = tbl.data

	local desc = ""

	if data.Coal and data.Coal > 0 then
		desc = desc .. "Coal: " .. tostring(data.Coal)
	end

	if data.Iron and data.Iron > 0 then
		desc = desc .. " | Iron: " .. tostring(data.Iron)
	end

	if data.Bronze and data.Bronze > 0 then
		desc = desc .. " | Bronze: " .. tostring(data.Bronze)
	end

	if data.Silver and data.Silver > 0 then
		desc = desc .. " | Silver: " .. tostring(data.Silver)
	end

	if data.Gold and data.Gold > 0 then
		desc = desc .. " | Gold: " .. tostring(data.Gold)
	end

	return desc
end)


ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	ent:SetCoal(data.Coal)
	ent:SetIron(data.Iron)
	ent:SetBronze(data.Bronze)
	ent:SetSilver(data.Silver)
	ent:SetGold(data.Gold)

	zrmine.f.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		Coal = math.Round(ent:GetCoal(),1),
		Iron = math.Round(ent:GetIron(),1),
		Bronze = math.Round(ent:GetBronze(),1),
		Silver = math.Round(ent:GetSilver(),1),
		Gold = math.Round(ent:GetGold(),1),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local name = "Gravel Crate"

	return name
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, -190, 0),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	local Coal = tbl.data.Coal or 0
	local Iron = tbl.data.Iron or 0
	local Bronze = tbl.data.Bronze or 0
	local Silver = tbl.data.Silver or 0
	local Gold = tbl.data.Gold or 0

	local storedAmount = Iron + Bronze + Silver + Gold + Coal

	if (storedAmount >= zrmine.config.GravelCrates_Capacity) then
		mdlPanel.Entity:SetBodygroup(0, 3)
	elseif (storedAmount >= zrmine.config.GravelCrates_Capacity / 2) then
		mdlPanel.Entity:SetBodygroup(0, 2)
	elseif (storedAmount > 0) then
		mdlPanel.Entity:SetBodygroup(0, 1)
	elseif (storedAmount <= 0) then
		mdlPanel.Entity:SetBodygroup(0, 0)
	end

	local rTable = {
		["Coal"] = Coal,
		["Iron"] = Iron,
		["Bronze"] = Bronze,
		["Silver"] = Silver,
		["Gold"] = Gold,
	}

	local rSkin
	local HasMultipleRessources = false

	for k, v in pairs(rTable) do
		if v > 0 then
			if rSkin == nil then
				rSkin = k
			else
				HasMultipleRessources = true
				break
			end
		end
	end

	if storedAmount > 0 then
		if HasMultipleRessources then
			mdlPanel.Entity:SetSkin(0)
		else
			if rSkin == "Coal" then
				mdlPanel.Entity:SetSkin(5)
			elseif rSkin == "Iron" then
				mdlPanel.Entity:SetSkin(1)
			elseif rSkin == "Bronze" then
				mdlPanel.Entity:SetSkin(2)
			elseif rSkin == "Silver" then
				mdlPanel.Entity:SetSkin(3)
			elseif rSkin == "Gold" then
				mdlPanel.Entity:SetSkin(4)
			end
		end
	end
end

ITEM:Register("zrms_gravelcrate")
