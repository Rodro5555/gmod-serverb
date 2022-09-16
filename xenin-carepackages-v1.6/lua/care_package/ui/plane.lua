function CarePackage:CreatePlane(startPos, endPos, ang, dur, z)
	local cs = ClientsideModel(self.Config.PlaneModel)
	cs:SetNoDraw(true)
	cs.Start = CurTime()
	cs.End = CurTime() + dur
	cs.StartPos = startPos
	cs.EndPos = endPos
	cs.DropZ = z
	ang = ang + Angle(0, -90, 0)
	cs:SetAngles(ang)
	cs:SetRenderAngles(ang)
	cs.Sound = CreateSound(cs, CarePackage.Config.SoundPath or "xenin/carepackage/plane.wav")
	cs.Sound:PlayEx(CarePackage.Config.SoundVolume, 100)
	cs.LastSoundChange = 0
	if (CarePackage.Config.PlaneAnimation) then
		cs:ResetSequence(CarePackage.Config.PlaneAnimation)
		
		hook.Add("Think", cs, function()
			if (!IsValid(cs)) then return end

			cs:FrameAdvance(0)
		end)
	end

	timer.Simple(math.min(dur * 2, 45), function()
		if (!IsValid(cs)) then return end

		if (cs.Sound) then
			cs.Sound:Stop()
			cs.Sound = nil
		end

		timer.Simple(0.5, function()
			-- IDK fix
			LocalPlayer():ConCommand("stopsound")
			
			cs:Remove()
		end)
	end)

	table.insert(self.Planes, cs)
end

function CarePackage:CreateCrate(plane, pos)
	local cs = ClientsideModel(self.Config.Model)
	cs:SetNoDraw(true)
	cs:DrawShadow(true)
	cs.Start = CurTime()
	cs.End = CurTime() + self.Config.DropTime
	cs.StartPos = pos
	cs.Ang = Angle(0, 0, 0)
	cs.EndPos = Vector(pos.x, pos.y, plane.DropZ)

	table.insert(self.Crates, cs)
end

function CarePackage:DrawCrate()
	for i, v in ipairs(CarePackage.Crates) do
		if (!IsValid(v)) then continue end

		local cs = v
		if (!cs.Start) then continue end
		if (!cs.End) then continue end
		local frac = math.Clamp((CurTime() - cs.Start) / (cs.End - cs.Start), 0, 1)
		local newPos = XeninUI:LerpVector(frac, cs.StartPos, cs.EndPos)--CarePackage.Easing)
		cs:SetPos(newPos)
		cs:SetAngles(cs.Ang)
		cs:SetRenderOrigin(newPos)
		cs:SetRenderAngles(cs.Ang)
		cs:DrawModel()

		if (frac >= 1) then
			cs:Remove()
		end
	end
end

function CarePackage:DrawPlanes()
	for i, v in ipairs(self.Planes) do
		if (!IsValid(v)) then continue end

		local cs = v
		local frac = (CurTime() - cs.Start) / (cs.End - cs.Start)
		local newPos = LerpVector(frac, cs.StartPos, cs.EndPos)
		cs:SetPos(newPos)
		cs:SetRenderOrigin(newPos)
		cs:DrawModel()

		local curTime = CurTime()
		if (cs.Sound and cs.LastSoundChange < curTime) then
			local dist = LocalPlayer():GetPos():Distance(cs:GetPos())

			local volume = math.Clamp(1 - (dist / 7000), 0.03, 1)
			cs.Sound:Stop()
			cs.Sound:PlayEx(volume, 100)
			cs.LastSoundChange = curTime + 0.1
		end

		local ply = LocalPlayer()
		local dist = newPos:Distance(ply:GetPos())
		if (dist <= 2500 and !cs.ShakedPlayer) then
			cs.ShakedPlayer = true

			util.ScreenShake(Vector(0, 0, 0), 5, 21, 4, 5)
		end

		if (frac >= 1 and !cs.HasDropped) then
			local pos = LocalToWorld(Vector(0, 0, 250), Angle(0, 0, 0), newPos, cs:GetAngles())
			self:CreateCrate(cs, pos)

			cs.HasDropped = true
		end
	end
end


function CarePackage:DrawPlaneBox()
	local ply = LocalPlayer()

	if (ply.planePositions) then
		local ang = Angle(0, 0, 0)
		local v1 = ply.planePositions[1]
		local v2 = ply.planePositions[2]
		local z = math.max(v1.z, v2.z)

		local relative = WorldToLocal(v2 + Vector(0, 0, 5), ang, v1, ang)
		render.SetColorMaterial()
		render.DrawBox(v1, ang, Vector(0, 0, 0), relative, Color(255, 0, 0, 200))
	end
end

hook.Add("PostDrawTranslucentRenderables", "CarePackage", function()
	CarePackage:DrawPlanes()
	CarePackage:DrawCrate()
	CarePackage:DrawPlaneBox()
end)