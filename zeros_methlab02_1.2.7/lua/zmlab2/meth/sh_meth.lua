zmlab2 = zmlab2 or {}
zmlab2.Meth = zmlab2.Meth or {}

zmlab2.Meth.Materials = zmlab2.Meth.Materials or {}

// Creates / returns a meth material which matches the specified parameters
function zmlab2.Meth.GetMaterial(MethType,MethQuality)

    local quality_step = math.Round((5 / 100) * MethQuality)

    local mat_name = "zmlab2_material_meth_" .. MethType .. "_" .. quality_step

    if zmlab2.Meth.Materials[mat_name] then
        return mat_name
    end


    local MethData = zmlab2.Meth.GetData(MethType)

	// NOTE We need to return something otherwhise it could cause a error
    if MethData == nil then return "" end
    // This is a big OOF but for some reason phong wont work for materials created with LUA

    local mat_params = {
    	["$basetexture"] = "$basetexture","zerochain/props_methlab/meth/zmlab2_meth_cracked_diff",
    	["$bumpMap"] = "$bumpMap","zerochain/props_methlab/meth/zmlab2_meth_cracked_nrm",
        ["$normalmapalphaenvmapmask"] = 1,

        ["$halflambert"] = 1,
        ["$model"] = 1,
        ["$selfillum"] = 1,
        ["$selfillummaskscale"] = 0.5,

        ["$envmap"] = "env_cubemap",
        ["$envmaptint"] = Vector(1,1,1),
        ["$envmapfresnel"] = 1,

        ["$phong"] = 1,
        ["$phongexponent"] = 1,
        ["$phongboost"] = 1,
        ["$phongfresnelranges"] = Vector(1, 1, 1),
        ["$phongtint"] = Vector(1, 1, 1),

        ["$rimlight"] = 1,
        ["$rimlightexponent"] = 5,
        ["$rimlightboost"] = 1,
    }

    zclib.Debug("zmlab2.Meth.MethMaterial Created!")
    local mat = CreateMaterial(mat_name, "VertexLitGeneric", mat_params)

    mat:SetInt("$halflambert", 1)
    mat:SetInt("$model", 1)
    mat:SetInt("$normalmapalphaenvmapmask", 1)
    mat:SetInt("$phong", 1)
    mat:SetVector("$phongfresnelranges", Vector(1, 1, 1))
    mat:SetInt("$rimlight", 1)
    mat:SetFloat("$rimlightexponent", 2)
    mat:SetFloat("$rimlightboost", 1)

    // $model + $envmapmode + $normalmapalphaenvmapmask + $opaquetexture + $softwareskin + $halflambert + $selfillum
    mat:SetInt("$flags", 2048 + 33554432 + 4194304 + 16777216 + 8388608)

    if MethData.material then
        if MethData.material.diff then mat:SetTexture("$basetexture",MethData.material.diff) end
        if MethData.material.nrm then mat:SetTexture("$bumpMap",MethData.material.nrm) end
    else
        mat:SetTexture("$basetexture","zerochain/props_methlab/meth/zmlab2_meth_cracked_diff")
        mat:SetTexture("$bumpMap","zerochain/props_methlab/meth/zmlab2_meth_cracked_nrm")
    end
    //mat:SetInt("$flags",2048 + 4194304 + 134217728 + 512 ) // model + normalmapalphaenvmapmask + halflambert + $multipass

    local qual_fract = (1 / 100) * MethQuality

    local col = MethData.color

    mat:SetFloat("$phongexponent",5 * qual_fract) // DOES NOT WORK
    mat:SetFloat("$phongboost",1 * qual_fract) // DOES NOT WORK
    mat:SetFloat("$envmapfresnel",1 * qual_fract)

    local h,s,v = ColorToHSV(col)
    s = s * qual_fract

    local reflect_strength = 0.25

    local col_vec = zclib.util.ColorToVector(HSVToColor(h,s,v))
    mat:SetVector("$phongtint",zclib.util.ColorToVector(col)) // DOES NOT WORK
    mat:SetVector("$envmaptint",Vector(col_vec.x * qual_fract * reflect_strength,col_vec.y * qual_fract * reflect_strength,col_vec.z * qual_fract * reflect_strength))
    mat:SetVector("$color2",col_vec)

    mat:Recompute()

    zmlab2.Meth.Materials[mat_name] = mat

    return mat_name
end

function zmlab2.Meth.GetData(id)
	if id == nil then return end

	return zmlab2.config.MethTypes[id]
end

function zmlab2.Meth.GetValue(MethType, MethAmount, MethQuality)
	local dat = zmlab2.Meth.GetData(MethType)

	if MethType and MethAmount and MethQuality and dat and dat.price then
		return (dat.price * MethAmount) * ((1 / 100) * MethQuality)
	else
		return 0
	end
end

function zmlab2.Meth.GetMixTime(MethType)
	local dat = zmlab2.Meth.GetData(MethType)

	return dat and dat.mix_time or 60
end

function zmlab2.Meth.GetVentTime(MethType)
	local dat = zmlab2.Meth.GetData(MethType)

	return dat and dat.vent_time or 60
end

function zmlab2.Meth.GetFilterTime(MethType)
	local dat = zmlab2.Meth.GetData(MethType)

	return dat and dat.filter_time or 60
end

function zmlab2.Meth.GetColor(MethType)
	local dat = zmlab2.Meth.GetData(MethType)

	return dat and dat.color or Color(255, 255, 255, 255)
end

function zmlab2.Meth.GetDifficulty(MethType)
	local dat = zmlab2.Meth.GetData(MethType)

	return dat and math.Clamp(dat.difficulty or 1, 1, 10)
end

function zmlab2.Meth.GetName(MethType)
	local dat = zmlab2.Meth.GetData(MethType)

	return dat and dat.name
end
