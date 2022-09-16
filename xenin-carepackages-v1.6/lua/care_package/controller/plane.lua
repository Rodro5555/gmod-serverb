CarePackage.PlaneCount = CarePackage.PlaneCount or 0

function CarePackage:CreatePlane(pos, dropPos, z)
	local start = CurTime()
	local len = pos:Distance(dropPos) / CarePackage.Config.PlaneSpeed

	net.Start("CarePackage.Plane")
		net.WriteVector(pos)
		net.WriteVector(dropPos)
		net.WriteFloat(len)
		net.WriteFloat(z)
	net.Broadcast()

	timer.Simple(len, function()
		if (self.Config.KillOnImpact) then
			local start = CurTime()
			local timeToDrop = start + self.Config.DropTime
			self.PlaneCount = self.PlaneCount + 1
			local id = self.PlaneCount
			local startPos = dropPos
			local endPos = Vector(dropPos.x, dropPos.y, z)
		
			timer.Create("Plane.KillerBox." .. id, self.Config.KillTickDelay, 0, function()
				if (timeToDrop - ((timeToDrop - start) * 0.75) > CurTime()) then
					local frac = math.Clamp(math.TimeFraction(start, timeToDrop, CurTime()), 0, 1)
					local movePos = XeninUI:LerpVector(frac, startPos, endPos)
					local size = 30

					local min = Vector(movePos.x - size, movePos.y - size, movePos.z)
					local max = Vector(movePos.x + size, movePos.y + size, movePos.z + size * 2)
					local ents = ents.FindInBox(min, max)

					for i, v in ipairs(ents) do
						if (!v:IsPlayer()) then continue end
						if (!v:Alive()) then continue end

						v:Kill()
					end
				end
			end)

			timer.Simple(self.Config.DropTime, function()
				if (self.Config.KillOnImpact) then
					timer.Remove("Plane.KillerBox." .. id)
				end

				local ang = XeninUI:GetAngleBetweenTwoVectors(pos, dropPos)
				ang = ang + Angle(0, -90, 0)
				local ent = ents.Create("care_package")
				ent:SetAngles(ang)
				local pos = LocalToWorld(Vector(0, 0, 250), Angle(0, 0, 0), dropPos, ent:GetAngles())
				pos.z = z
				ent:SetPos(pos)
				ent:Spawn()
			end)
		end
	end)
end

function CarePackage:CalculateStartPosition()
	if (!self.PlanePos) then return end
	-- Lets order them.
	if (!self.PlanePosOrdered) then
		local p = self.PlanePos
		local v1 = Vector(p[1].x, p[1].y, p[1].z)
		local v2 = Vector(p[2].x, p[2].y, p[2].z)

		OrderVectors(v1, v2)

		self.PlanePosOrdered = { v1, v2 }
	end

	local min = self.PlanePosOrdered[1]
	local max = self.PlanePosOrdered[2]
	
	local xUp = tobool(math.random())
	local x = 0
	local y = 0

	if (xUp) then
		x = Lerp(math.random(), min.x, max.x)
		y = Lerp(math.Round(math.random()), min.y, max.y)
	else
		x = Lerp(math.Round(math.random()), min.x, max.x)
		y = Lerp(math.random(), min.y, max.y)
	end

	return Vector(x, y, max.z)
end

function CarePackage:GetRandomPositions()
	local startPos = self:CalculateStartPosition()
	local rnd = table.Random(self.Spawns)
	local endPos = rnd and rnd.pos or Vector(0, 0, 0)
	local newEndPos = Vector(endPos.x, endPos.y, CarePackage.Config.PlaneHeight)
	startPos.z = CarePackage.Config.PlaneHeight

	return startPos, newEndPos, endPos.z + 30
end

concommand.Add("crate", function(ply)
	if (!CarePackage.Config.IsAdmin(ply)) then return end

	CarePackage:Start()
end)


