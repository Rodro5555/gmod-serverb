if not CLIENT then return end
zgo2 = zgo2 or {}
zgo2.Palette = zgo2.Palette or {}

net.Receive("zgo2_Palette_Update", function(len)
    zclib.Debug_Net("zgo2_Palette_Update", len)
    local Palette = net.ReadEntity()
	local Count = net.ReadUInt(32)

	if Palette and IsValid(Palette) and Palette:IsValid() then
		Palette.WeedList = {}
		for i=1,Count do
			Palette.WeedList[i] = net.ReadUInt(32)
		end

	    Palette.UpdateClientProps = true
	end
end)

function zgo2.Palette.Initialize(Palette)
    Palette.WeedList = {}

    Palette.Count_Y = 0
    Palette.Count_X = 0
    Palette.Count_Z = 0

    Palette.UpdateClientProps = false

    Palette.Money = zclib.Money.Display(0)
end

function zgo2.Palette.OnRemove(Palette)
    zgo2.Palette.RemoveClientModels(Palette)
end

function zgo2.Palette.Think(Palette)
    if zclib.util.InDistance(LocalPlayer():GetPos(), Palette:GetPos(), 1500) then
        if Palette.UpdateClientProps == true then
            zgo2.Palette.UpdateClientProps(Palette)
            Palette.UpdateClientProps = false
        end

		// TODO Ask the server about the current connected entities from this Palette
		// Verify first if this issue even exist where you dont get the palette info just because you are on a diffrent part of the map or joined on a later time
    else
        zgo2.Palette.RemoveClientModels(Palette)
        Palette.UpdateClientProps = true
    end
end

function zgo2.Palette.UpdateClientProps(Palette)
    zgo2.Palette.RemoveClientModels(Palette)

    Palette.ClientProps = {}

    for k, weedid in pairs(Palette.WeedList) do
        if not IsValid(Palette) then continue end
        if k == nil then continue end
        if weedid == nil then continue end
        zgo2.Palette.CreateClientProp(Palette, k, weedid)
    end
end

function zgo2.Palette.CreateClientProp(Palette, id, WeedID)

	local WeedData = zgo2.Plant.GetData(WeedID)

	if not WeedData then return end

    local pos = Palette:GetPos() - Palette:GetRight() * 16 - Palette:GetForward() * 51 + Palette:GetUp() * 18
    local ang = Palette:GetAngles()

    if Palette.Count_X >= 3 then
        Palette.Count_X = 1
        Palette.Count_Y = Palette.Count_Y + 1
    else
        Palette.Count_X = Palette.Count_X + 1
    end

    if Palette.Count_Y >= 2 then
        Palette.Count_Y = 0
        Palette.Count_Z = Palette.Count_Z + 1
    end

    pos = pos + Palette:GetForward() * 25 * Palette.Count_X
    pos = pos + Palette:GetRight() * 34 * Palette.Count_Y
    pos = pos + Palette:GetUp() * 12 * Palette.Count_Z

	local Weedblock = ClientsideModel("models/zerochain/props_growop2/zgo2_weedblock.mdl")
	if not IsValid(Weedblock) then return end
	Weedblock:Spawn()
    Weedblock:SetAngles(ang)
    Weedblock:SetPos(pos)
	//Weedblock:SetModelScale(0.9,0.001)
    Weedblock:SetParent(Palette)

	Weedblock.WeedID = WeedID

	// Creates / Updates the plants lua materials
	zgo2.Plant.UpdateMaterial(Weedblock,WeedData,nil,true)

    Palette.ClientProps[id] = Weedblock
end

function zgo2.Palette.RemoveClientModels(Palette)
    Palette.Count_Y = 0
    Palette.Count_X = 0
    Palette.Count_Z = 0

    if (Palette.ClientProps and table.Count(Palette.ClientProps) > 0) then
        for k, v in pairs(Palette.ClientProps) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end

    Palette.ClientProps = {}
end
