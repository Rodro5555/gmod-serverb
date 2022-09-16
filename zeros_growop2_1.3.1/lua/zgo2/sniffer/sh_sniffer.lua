zgo2 = zgo2 or {}
zgo2.Sniffer = zgo2.Sniffer or {}
zgo2.Sniffer.Items = zgo2.Sniffer.Items or {}

local function AddItem(class,data) zgo2.Sniffer.Items[class] = data end

/*

	Zeros GrowOP - 2

*/
AddItem("zgo2_crate", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent.WeedBranches and table.Count(ent.WeedBranches) > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_doobytable", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetWeedAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_dryline", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent.WeedBranches and table.Count(ent.WeedBranches) > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_jar", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetWeedAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_baggy", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetWeedAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_joint_ent", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})
AddItem("zgo2_packer", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetWeedAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_plant", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if zgo2.Plant.HarvestReady(ent) then
			return true
		else
			return false
		end
	end
})
AddItem("zgo2_weedblock", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})
AddItem("zgo2_weedbranch", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})

/*

	Zeros GrowOP - 1

*/
AddItem("zwf_pot", {
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetSeed() ~= 1 and ent:GetHarvestReady() then
			return true
		else
			return false
		end
	end
})
AddItem("zwf_jar",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetPlantID() ~= 1 then
			return true
		else
			return false
		end
	end
})
AddItem("zwf_pot_hydro",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetSeed() ~= 1 and ent:GetHarvestReady() then
			return true
		else
			return false
		end
	end
})
AddItem("zwf_joint_ent",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})
AddItem("zwf_palette",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetBlockCount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zwf_weedblock",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})
AddItem("zwf_weedstick",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})

/*

	Zeros Methlab - 1

*/
AddItem("zmlab_collectcrate",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetMethAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zmlab_meth",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetMethAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zmlab_meth_baggy",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetMethAmount() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zmlab_palette",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetMethAmount() > 0 then
			return true
		else
			return false
		end
	end
})

/*

	Zeros Crackermaker

*/
AddItem("zcm_firecracker",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		return true
	end
})
AddItem("zcm_box",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetFireworkCount() > 0 then
			return true
		else
			return false
		end
	end
})

/*

	Zeros Yeastbeast

*/
AddItem("zyb_jar",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetMoonShine() > 0 then
			return true
		else
			return false
		end
	end
})
AddItem("zyb_jarcrate",{
	icon = zclib.Materials.Get("zgo2_icon_illegal"),
	color = Color(233, 48, 48),
	check = function(ent)
		if ent:GetJarCount() > 0 then
			return true
		else
			return false
		end
	end
})
