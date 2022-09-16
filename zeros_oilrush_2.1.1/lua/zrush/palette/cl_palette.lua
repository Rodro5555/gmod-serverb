if not CLIENT then return end
zrush = zrush or {}
zrush.Palette = zrush.Palette or {}

net.Receive("zrush_Palette_AddBarrel", function(len)
	local Palette = net.ReadEntity()
	local fuel_id = net.ReadInt(6)

	if fuel_id and IsValid(Palette) then
		if Palette.FuelList == nil then
			Palette.FuelList = {}
		end

		table.insert(Palette.FuelList, fuel_id)
	end
end)

function zrush.Palette.Initialize(Palette)
	if Palette.FuelList == nil then
		Palette.FuelList = {}
	end

	Palette.Count_Y = 0
	Palette.Count_X = 0
	Palette.Count_Z = 0
	Palette.LastBarrelCount = 0
end

function zrush.Palette.Think(Palette)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Palette:GetPos(), 1000) then
		zrush.Palette.CrateChangeUpdater(Palette)
	else
		zrush.Palette.RemoveClientModels(Palette)
		Palette.ClientProps = {}
		Palette.LastBarrelCount = -1
	end
end

function zrush.Palette.OnRemove(Palette)
	zrush.Palette.RemoveClientModels(Palette)
end

function zrush.Palette.CrateChangeUpdater(Palette)
	local barrelCount = table.Count(Palette.FuelList)

	if Palette.LastBarrelCount ~= barrelCount then
		Palette.LastBarrelCount = barrelCount
		zrush.Palette.UpdateClientProps(Palette)
	end
end

function zrush.Palette.CreateClientBarrel(Palette, fuel_id)
	if zrush.FuelTypes[fuel_id] == nil then return end
	local offset_x = 18
	local offset_y = 52
	local step_x = 35
	local step_y = 35
	local step_z = 50.5
	local m_scale = 1
	local count_w = 2

	if zrush.config.Palette.Capacity > 8 then
		offset_x = 22
		offset_y = 42
		step_x = 21
		step_y = 21
		step_z = 30.5
		m_scale = 0.60
		count_w = 3
	end

	local pos = Palette:GetPos() - Palette:GetRight() * offset_x - Palette:GetForward() * offset_y + Palette:GetUp() * 3
	local ang = Palette:GetAngles()

	if Palette.Count_X >= count_w then
		Palette.Count_X = 1
		Palette.Count_Y = Palette.Count_Y + 1
	else
		Palette.Count_X = Palette.Count_X + 1
	end

	if Palette.Count_Y >= count_w then
		Palette.Count_Y = 0
		Palette.Count_Z = Palette.Count_Z + 1
	end

	pos = pos + Palette:GetForward() * step_x * Palette.Count_X
	pos = pos + Palette:GetRight() * step_y * Palette.Count_Y
	pos = pos + Palette:GetUp() * step_z * Palette.Count_Z
	local Barrel = ents.CreateClientProp()
	Barrel:SetModel("models/zerochain/props_oilrush/zor_barrel.mdl")
	Barrel:SetAngles(ang)
	Barrel:SetPos(pos)
	Barrel:SetModelScale(m_scale)
	Barrel:Spawn()
	Barrel:Activate()
	Barrel:SetRenderMode(RENDERMODE_NORMAL)
	Barrel:SetParent(Palette)
	Barrel:SetColor(zrush.FuelTypes[fuel_id].color)
	table.insert(Palette.ClientProps, Barrel)
end

function zrush.Palette.RemoveClientModels(Palette)
	Palette.Count_Y = 0
	Palette.Count_X = 0
	Palette.Count_Z = 0

	if Palette.ClientProps and table.Count(Palette.ClientProps) > 0 then
		for k, v in pairs(Palette.ClientProps) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end

function zrush.Palette.UpdateClientProps(Palette)
	zrush.Palette.RemoveClientModels(Palette)
	Palette.ClientProps = {}

	if Palette.LastBarrelCount > 0 then
		for k, v in pairs(Palette.FuelList) do
			zrush.Palette.CreateClientBarrel(Palette, v)
		end
	end
end
