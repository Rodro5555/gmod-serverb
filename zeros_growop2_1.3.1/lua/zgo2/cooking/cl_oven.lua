zgo2 = zgo2 or {}
zgo2.Oven = zgo2.Oven or {}
/*

	Bakes the dough

*/

function zgo2.Oven.Initialize(Oven)
	zclib.EntityTracker.Add(Oven)
end

function zgo2.Oven.Draw(Oven)
	if not LocalPlayer().zgo2_Initialized then return end
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Oven:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	if Oven:GetIsBaking() and Oven.BakeStart then
		cam.Start3D2D(Oven:LocalToWorld(Vector(0, 9,1.3)), Oven:LocalToWorldAngles(Angle(0, 180, 90)), 0.1)
			zgo2.util.DrawBar(160, 20, zclib.Materials.Get("time"), zclib.colors[ "blue02" ], -20, -55, (1 / zgo2.Edible.GetBakeDuration(Oven:GetEdibleID())) * (CurTime() - Oven.BakeStart))
		cam.End3D2D()
	end
end

function zgo2.Oven.Think(Oven)
	zclib.util.LoopedSound(Oven, "zgo2_oven_loop", Oven:GetIsBaking())

	if zclib.util.InDistance(LocalPlayer():GetPos(), Oven:GetPos(), 1000) then
		if Oven:GetIsBaking() then

			if not Oven.BakeStart then Oven.BakeStart = CurTime() end

			local EdibleData = zgo2.Edible.GetData(Oven:GetEdibleID())
			if EdibleData then
				if IsValid(Oven.DummyModel) then
					Oven.DummyModel:SetPos(Oven:LocalToWorld(Vector(1.3,0,7)))
					Oven.DummyModel:SetAngles(Oven:GetAngles())
				else
					Oven.DummyModel = ClientsideModel(EdibleData.edible_model)
					if not IsValid(Oven.DummyModel) then return end
					Oven.DummyModel:Spawn()
					Oven.DummyModel:SetModelScale(0.8)
					Oven.DummyModel:SetSubMaterial(1, "zerochain/props_growop2/mixer/zgo2_dough_diff" )

					local PlantData = zgo2.Plant.GetData(Oven:GetWeedID())
					if PlantData then
						zgo2.Plant.UpdateMaterial(Oven.DummyModel,PlantData,false,true)

						Oven.DummyModel:SetBodygroup(0,1)
						Oven.DummyModel:SetColor(zgo2.Plant.GetColor(Oven:GetWeedID()))
					end
				end
			else
				zgo2.Oven.RemoveDummy(Oven)
			end
		else
			Oven.BakeStart = nil
			zgo2.Oven.RemoveDummy(Oven)
		end
	else
		zgo2.Oven.RemoveDummy(Oven)
	end

	Oven:SetNextClientThink(CurTime())
	return true
end

function zgo2.Oven.RemoveDummy(Oven)
	if IsValid(Oven.DummyModel) then
		Oven.DummyModel:Remove()
		Oven.DummyModel = nil
	end
end

function zgo2.Oven.OnRemove(Oven)
	Oven:StopSound("zgo2_oven_loop")
	zgo2.Oven.RemoveDummy(Oven)
end
