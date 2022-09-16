local tbl_ent = {
	["realistic_woodcutter_splitter_machine"] = {
		"rwc_swep_small_log",
		"rwc_swep_log_demi_split"
	},
	["realistic_woodcutter_debarker_machine"] = {"rwc_swep_log"},
	["realistic_woodcutter_sawmill_machine"] = {"rwc_swep_log"},	
}

hook.Add("HUDPaint", "RealisticWoodCutter:ClickSwep", function()
	if LocalPlayer():GetActiveWeapon():IsWeapon() then 
		if ( LocalPlayer():HasWeapon(Realistic_Woodcutter.swep[1]) or LocalPlayer():HasWeapon(Realistic_Woodcutter.swep[2]) or LocalPlayer():HasWeapon(Realistic_Woodcutter.swep[3]) or LocalPlayer():HasWeapon(Realistic_Woodcutter.swep[4]) or LocalPlayer():HasWeapon(Realistic_Woodcutter.swep[5]) ) then
			surface.SetDrawColor(255,255,255)
			if IsValid(LocalPlayer():GetEyeTrace().Entity) && isentity(LocalPlayer():GetEyeTrace().Entity) && istable(tbl_ent[LocalPlayer():GetEyeTrace().Entity:GetClass()]) then 
				if table.HasValue(tbl_ent[LocalPlayer():GetEyeTrace().Entity:GetClass()], LocalPlayer():GetActiveWeapon():GetClass()) and LocalPlayer():GetEyeTrace().Entity:GetPos():Distance(LocalPlayer():GetPos()) < 325 then 
					surface.SetMaterial(Material("rwc_image/keyboard_e.png"))
				elseif LocalPlayer():GetEyeTrace().Entity:GetNWVector("rwc_vector") == Vector(0,0,0) then 
					surface.SetMaterial(Material("rwc_image/mouse.png"))
				end
			elseif LocalPlayer():GetEyeTrace().Entity:GetNWVector("rwc_vector") == Vector(0,0,0) then  
				surface.SetMaterial(Material("rwc_image/mouse.png"))
			end 
			if LocalPlayer():GetEyeTrace().Entity:GetNWVector("rwc_vector") != Vector(0,0,0) then 
				surface.SetMaterial(Material("rwc_image/keyboard_e.png"))
			end 
			surface.DrawTexturedRect(ScrW()/2-25, ScrH()*0.9,50,50)
		end
	end 
end)

hook.Add("ShouldCollide", "RWC:ShouldCollide:Optimsation", function(ent1, ent2)
	if not IsValid(ent1) or not IsValid(ent2) then return end
	if Realistic_Woodcutter.Entities[ent2:GetClass()] then return end
	
	if Realistic_Woodcutter.Optimisation[ent1:GetClass()] && not ent2:IsPlayer() then return false end
end)