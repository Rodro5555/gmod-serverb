CarePackage.Spawns = CarePackage.Spawns or {}

function CarePackage:AddSpawn(pos, ang)
	local id = table.insert(self.Spawns, {
		pos = pos,
		ang = ang
	})

	if (CLIENT) then
		net.Start("CarePackage.Saving.Add")
			net.WriteTable({
				pos = pos,
				ang = ang
			})
		net.SendToServer()
	elseif (SERVER) then
		self.Database:SavePoint(id, pos)
	end
end

function CarePackage:GetSpawns()
	return self.Spawns or {}
end

local function unpackVector(str)
	local split = string.Explode(",", str)
	
	return Vector(tonumber(split[1]), tonumber(split[2]), tonumber(split[3]))
end

function CarePackage:LoadSpawns()
	self.Database:GetPlanePos():next(function(result)
		if (!result) then return end
		local tbl = result[1]

		CarePackage.PlanePos = {
			unpackVector(tbl.vector_1),
			unpackVector(tbl.vector_2)
		}
	end)

	self.Database:GetPoints():next(function(result)
		for i, v in pairs(result) do
			CarePackage.Spawns[tonumber(v.id)] = {
				pos = unpackVector(v.vector)
			}
		end

		CarePackage.LoadedSpawns = true
	end)
end


function CarePackage:DeleteSpawn(id)
	self.Spawns[id] = nil

	if (CLIENT) then
		net.Start("CarePackage.Saving.Delete")
			net.WriteUInt(id, 32)
		net.SendToServer()
	elseif (SERVER) then
		self.Database:DeletePoint(id)
	end
end

function CarePackage:DeleteAllSpawns()
	self.Spawns = {}

	if (CLIENT) then
		net.Start("CarePackage.Saving.DeleteAll")
		net.SendToServer()
	elseif (SERVER) then
		self.Database:DeleteAllPoints()
	end
end
