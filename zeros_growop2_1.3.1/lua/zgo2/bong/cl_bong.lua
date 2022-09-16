zgo2 = zgo2 or {}
zgo2.Bong = zgo2.Bong or {}
zgo2.Bong.List = zgo2.Bong.List or {}

/*

	Bongs are used to smoke da weed

*/

function zgo2.Bong.Initialize(Bong)
	Bong:SetHoldType(Bong.HoldType)

	timer.Simple(0,function()
		if IsValid(Bong) then
			Bong.UpdateMaterials = nil
		end
	end)
end

function zgo2.Bong.DrawHUD(Bong)

	local w = ScrW()

	local effect_dur = LocalPlayer().zgo2_screeneffect_duration
	if effect_dur and effect_dur > 0 then
		local DurBar = math.Clamp((400 / zgo2.config.HighEffect.MaxDuration) * effect_dur,0,400)
		draw.RoundedBox(0, (w / 2) - 200 * zclib.wM,985 * zclib.hM, 400 * zclib.wM, 10 * zclib.hM,zclib.colors["ui00"])
		draw.RoundedBox(0, (w / 2) - 200 * zclib.wM,985 * zclib.hM, DurBar * zclib.wM, 10 * zclib.hM,zclib.colors["blue02"])
		zclib.util.DrawOutlinedBox((w / 2) - 200 * zclib.wM, 985 * zclib.hM, 400 * zclib.wM, 10 * zclib.hM, 2, color_white)
	end


	local WeedID = Bong:GetWeedID()
	local WeedAmount = Bong:GetWeedAmount()
	if WeedID ~= -1 then
		local WeedData = zgo2.Plant.GetData(WeedID)
		local BongData = zgo2.Bong.GetData(Bong:GetBongID())

		local width = math.Clamp((400 / BongData.capacity) * WeedAmount,0,400)

		if WeedData then
			local barHeight = 50 * zclib.hM
			draw.RoundedBox(0, (w / 2) - 200 * zclib.wM, 1000 * zclib.hM, 400 * zclib.wM, barHeight, zclib.colors[ "ui00" ])
			draw.RoundedBox(0, (w / 2) - 200 * zclib.wM, 1000 * zclib.hM, width * zclib.wM, barHeight, WeedData.style.bud.color01)
			zclib.util.DrawOutlinedBox((w / 2) - 200 * zclib.wM, 1000 * zclib.hM, 400 * zclib.wM, barHeight, 2, color_white)

			draw.SimpleText("[ " .. WeedAmount .. " " .. zgo2.config.UoM .. " ]", zclib.GetFont("zclib_font_small"), w / 2, 1033 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(WeedData.name, zclib.GetFont("zclib_font_mediumsmall"), w / 2, 1015 * zclib.hM, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

function zgo2.Bong.Think(Bong)
	zgo2.Bong.UpdateTexture(Bong)
end

function zgo2.Bong.Deploy(Bong)
	timer.Simple(0,function()
		if IsValid(Bong) then
			Bong.UpdateMaterials = nil
		end
	end)
end

function zgo2.Bong.Holster(Bong)
	zgo2.Bong.StopLoopedSound(Bong)

	local ply = Bong:GetOwner()

	// Reset the material of the world / viezclib.wMel back to default
	timer.Simple(0,function()
		if IsValid(Bong) then
			Bong:SetMaterial("")
			Bong:SetSubMaterial()
		end
		if not IsValid(ply) then return end
		if ply.GetViewModel then
			local vm = ply:GetViewModel(0)
			if IsValid(vm) then
				vm:SetMaterial("")
				vm:SetSubMaterial()
			end
		end
	end)
end

function zgo2.Bong.OnRemove(Bong)
	zgo2.Bong.StopLoopedSound(Bong)
end

function zgo2.Bong.StopLoopedSound(Bong)
	Bong:StopSound("zgo2_bong_loop")
end

function zgo2.Bong.PreDrawViewModel(Bong,vm, weapon, ply)
	local BongTypeData = zgo2.Bong.GetTypeData(Bong:GetBongID())
	vm:SetModel(BongTypeData.vm)
end

/*
	Updates the bongs Texture and plays the smoking sound
*/
function zgo2.Bong.UpdateTexture(Bong)
	zclib.util.LoopedSound(Bong, "zgo2_bong_loop", Bong:GetIsSmoking())

	local BongData = zgo2.Bong.GetData(Bong:GetBongID())
	local WeedData = zgo2.Plant.GetData(Bong:GetWeedID())

	// Its a hacky solution but it does reset the viewmodel correctly
	local ply = Bong:GetOwner()
	if IsValid(ply) and LocalPlayer() == ply then
		local timerid = "zgo2_bong_"..Bong:EntIndex()
		zclib.Timer.Remove(timerid)
		zclib.Timer.Create(timerid, 1, 1, function()
			if not IsValid(ply) then return end
			if ply.GetViewModel then
				local vm = ply:GetViewModel(0)
				if IsValid(vm) then
					vm:SetMaterial("")
					vm:SetSubMaterial()
				end
			end
		end)
	end

	if Bong.LastCheck == nil or CurTime() > (Bong.LastCheck + 1) then
		Bong.LastCheck = CurTime()
		Bong.UpdateMaterials = nil
	end

	// If the weed inside the bong changes then we need to update the weed material again
	if Bong:GetWeedID() ~= Bong.LastWeedID then
		Bong.LastWeedID = Bong:GetWeedID()
		Bong.UpdateMaterials = nil
	end

	// If the bong id changes then we need to update the weed material again
	if Bong:GetBongID() ~= Bong.LastBongID then
		Bong.LastBongID = Bong:GetBongID()
		Bong.UpdateMaterials = nil
	end

	if Bong.UpdateMaterials then return end
	Bong.UpdateMaterials = true

	// Rebuild material to be save
	zgo2.Bong.RebuildMaterial(BongData)

	// Update world model texture
	zgo2.Bong.ApplyMaterial(Bong,BongData)

	if WeedData then zgo2.Plant.UpdateMaterial(Bong,WeedData,nil,true) end

	// Update view model texture
	if IsValid(ply) and LocalPlayer() == ply and ply.GetViewModel then
		local vm = ply:GetViewModel(0)
		if IsValid(vm) then
			zgo2.Bong.ApplyMaterial(vm, BongData)
			if WeedData then
				zgo2.Plant.UpdateMaterial(vm, WeedData, nil, true)
			end
		end
	end
end

/*
	Draw the bongs world model texture for all the other players
*/
function zgo2.Bong.DrawWorldModel(pl)
	if not IsValid(pl) then return end
	local Bong = pl:GetActiveWeapon()
	if not IsValid(Bong) then return end
	if Bong:GetClass() ~= "zgo2_bong" then return end

	zgo2.Bong.UpdateTexture(Bong)
end


zclib.Hook.Remove("PostPlayerDraw", "zgo2.Bong.DrawTexture")
zclib.Hook.Add("PostPlayerDraw", "zgo2.Bong.DrawTexture", function(ply) zgo2.Bong.DrawWorldModel(ply) end)
