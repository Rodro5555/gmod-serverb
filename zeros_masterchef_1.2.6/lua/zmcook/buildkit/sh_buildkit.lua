zmc = zmc or {}
zmc.Buildkit = zmc.Buildkit or {}

zmc.Buildkit_Classes = {}
timer.Simple(2,function()
    for k,v in pairs(zmc.config.Buildkit.List) do
        zmc.Buildkit_Classes[v.class] = k
    end
end)

// Check if some player is in the way
function zmc.Buildkit.AreaOccupied(pos,ignore)
    local IsOccupied = false
    for k,v in pairs(ents.FindInSphere(pos,10)) do
        if not IsValid(v) then continue end

        if ignore and v == ignore then continue end

        // We dont place a machine on top of another one
        if zmc.Buildkit_Classes[v:GetClass()] then
            IsOccupied = true
            break
        end

        // Dont place a machine on a player
        if v:IsPlayer() then
            IsOccupied = true
            break
        end
    end
    return IsOccupied
end

function zmc.Buildkit.GetName(id)
	local dat = zmc.config.Buildkit.List[id]
	if dat == nil or dat.name == nil then return "Unkown" end

	// Use translation instead
	if zmc.language[ dat.name ] then return zmc.language[ dat.name ] end

	return dat.name
end
