if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Palette = zmlab2.Palette or {}

net.Receive("zmlab2_Palette_Update", function(len)
    zclib.Debug_Net("zmlab2_Palette_Update", len)
    local Palette = net.ReadEntity()

    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local MethList = util.JSONToTable(dataDecompressed)


    if MethList and istable(MethList) and IsValid(Palette) then
        if Palette.MethList == nil then
            Palette.MethList = {}
        end

        Palette.MethList = table.Copy(MethList)

        Palette.UpdateClientProps = true
    end
end)

function zmlab2.Palette.Initialize(Palette)
    Palette.MethList = {}

    Palette.Count_Y = 0
    Palette.Count_X = 0
    Palette.Count_Z = 0

    Palette.UpdateClientProps = false

    Palette.Money = zclib.Money.Display(0)
end

function zmlab2.Palette.Draw(Palette)
    if zclib.util.InDistance(Palette:GetPos(), LocalPlayer():GetPos(), 500) and zclib.Convar.Get("zmlab2_cl_drawui") == 1  then
        cam.Start3D2D(Palette:LocalToWorld(Vector(0, 0, 50 + 5 * Palette.Count_Z)), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
            local boxSize = zclib.util.GetTextSize(Palette.Money, zclib.GetFont("zmlab2_font02")) * 1.5
            draw.RoundedBox(0, -boxSize / 2, -30, boxSize, 60, zclib.colors["black_a100"])
            draw.SimpleText(Palette.Money, zclib.GetFont("zmlab2_font02"), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            zclib.util.DrawOutlinedBox(-boxSize / 2, -30, boxSize, 60, 4, color_white)
        cam.End3D2D()
    end
end

function zmlab2.Palette.OnRemove(Palette)
    zmlab2.Palette.RemoveClientModels(Palette)
end

function zmlab2.Palette.Think(Palette)
    if zclib.util.InDistance(LocalPlayer():GetPos(), Palette:GetPos(), 1500) then
        if Palette.UpdateClientProps == true then

            // Calculates new money value
            local money = 0
            for k,v in pairs(Palette.MethList) do
                if v == nil then continue end
                money = money + zmlab2.Meth.GetValue(v.t,v.a,v.q)
            end

            // Multiply by rank
            Palette.Money = money * (zmlab2.config.NPC.SellRanks[zclib.Player.GetRank(LocalPlayer())] or zmlab2.config.NPC.SellRanks["default"])

            Palette.Money = zclib.Money.Display(Palette.Money)

            zmlab2.Palette.UpdateClientProps(Palette)
            Palette.UpdateClientProps = false
        end
    else
        zmlab2.Palette.RemoveClientModels(Palette)
        Palette.UpdateClientProps = true
    end
end

function zmlab2.Palette.UpdateClientProps(Palette)
    zmlab2.Palette.RemoveClientModels(Palette)
    Palette.ClientProps = {}

    for k, v in pairs(Palette.MethList) do
        if not IsValid(Palette) then continue end
        if k == nil then continue end
        if v == nil then continue end
        if v.t == nil then continue end
        if v.a == nil then continue end
        if v.q == nil then continue end
        zmlab2.Palette.CreateClientProp(Palette, k, v.t,v.a, v.q)
    end
end

function zmlab2.Palette.CreateClientProp(Palette, id, meth_type, meth_amount,meth_quality)

	if zmlab2.Meth.GetData(meth_type) == nil then return end

    local pos = Palette:GetPos() - Palette:GetRight() * 25 - Palette:GetForward() * 36 + Palette:GetUp() * 8
    local ang = Palette:GetAngles()

    if Palette.Count_X >= 2 then
        Palette.Count_X = 1
        Palette.Count_Y = Palette.Count_Y + 1
    else
        Palette.Count_X = Palette.Count_X + 1
    end

    if Palette.Count_Y >= 4 then
        Palette.Count_Y = 0
        Palette.Count_Z = Palette.Count_Z + 1
    end

    pos = pos + Palette:GetForward() * 24 * Palette.Count_X
    pos = pos + Palette:GetRight() * 17 * Palette.Count_Y
    pos = pos + Palette:GetUp() * 12 * Palette.Count_Z

    local crate = zclib.ClientModel.AddProp()
    if not IsValid(crate) then return end
    crate:SetAngles(ang)
    crate:SetModel("models/zerochain/props_methlab/zmlab2_crate.mdl")
    crate:SetPos(pos)

    crate:Spawn()
    crate:Activate()

    crate:SetRenderMode(RENDERMODE_NORMAL)
    crate:SetParent(Palette)

    local MethMat = zmlab2.Meth.GetMaterial(meth_type, meth_quality)
	if MethMat then
    	crate:SetSubMaterial(0, "!" .. MethMat)
	end

    local cur_amount = meth_amount
    if cur_amount <= 0 then
        crate:SetBodygroup(0,5)
    else
        local bg = math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * cur_amount),1,5)
        crate:SetBodygroup(0,bg)
    end

    Palette.ClientProps[id] = crate
end

function zmlab2.Palette.RemoveClientModels(Palette)
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
