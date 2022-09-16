if CLIENT then
    zclib.Convar.Create("zgo2_cl_smoothgrow", "1", {FCVAR_ARCHIVE})

	zclib.Convar.Create("zgo2_cl_dynlight", "0", {FCVAR_ARCHIVE})
	zclib.Convar.Create("zgo2_cl_lightsprite", "1", {FCVAR_ARCHIVE})
	zclib.Convar.Create("zgo2_cl_lightbeam", "1", {FCVAR_ARCHIVE})
	zclib.Convar.Create("zgo2_cl_drawskank", "1", {FCVAR_ARCHIVE})


else
	zclib.Convar.Create("zgo2_sv_growspeed", "1", {FCVAR_ARCHIVE})
end
