zgo2 = zgo2 or {}
zgo2.Tent = zgo2.Tent or {}
zgo2.Tent.List = zgo2.Tent.List or {}

/*

	Growboxes are used for small scale grow operations

*/
function zgo2.Tent.Initialize(Tent)
	Tent:DrawShadow(false)
	Tent:DestroyShadow()

	timer.Simple(0.2, function()
		if IsValid(Tent) then
			Tent.m_Initialized = true
		end
	end)
end

/*
	Draw ui and light stuff
*/
function zgo2.Tent.OnDraw(Tent)
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Tent:GetPos(), LocalPlayer():GetPos(), 600) == false then return end
end

function zgo2.Tent.OnThink(Tent)
	zgo2.Tent.List[Tent] = true
end
