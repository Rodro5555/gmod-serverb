CarePackage.Database = {}

function CarePackage.Database:GetConnection()
	return XCPMySQLite
end

function CarePackage.Database:Tables()
	local conn = self:GetConnection()

	XeninUI:InvokeSQL(conn, [[
		CREATE TABLE IF NOT EXISTS carepackage_drop_points (
			id INT(11),
			vector TEXT NOT NULL,
			PRIMARY KEY (id)
		)
	]], "CarePackage.Tables.DropPoints")

	XeninUI:InvokeSQL(conn, [[
		CREATE TABLE IF NOT EXISTS carepackage_plane_pos (
			map VARCHAR(127),
			vector_1 TEXT NOT NULL,
			vector_2 TEXT NOT NULL,
			PRIMARY KEY (map)
		)
	]], "CarePackage.Tables.PlanePos")

	CarePackage:LoadSpawns()
end

function CarePackage.Database:SavePoint(id, pos)
	local conn = self:GetConnection()
	local pos = pos.x .. "," .. pos.y .. "," .. pos.z

	local sql = [[
		INSERT INTO carepackage_drop_points (id, vector)
		VALUES (:id, ':vector')
	]]
	sql = sql:Replace(":id", id)
	sql = sql:Replace(":vector", pos)

	return XeninUI:InvokeSQL(conn, sql, "CarePackage.SavePoint." .. id)
end

function CarePackage.Database:GetPoints()
	local conn = self:GetConnection()
	local sql = [[
		SELECT * FROM carepackage_drop_points
	]]

	return XeninUI:InvokeSQL(conn, sql, "CarePackage.GetPoints")
end

function CarePackage.Database:DeletePoint(id)
	local conn = self:GetConnection()
	local sql = [[
		DELETE FROM carepackage_drop_points
		WHERE id = :id
	]]
	sql = sql:Replace(":id", id)

	return XeninUI:InvokeSQL(conn, sql, "CarePackage.DeletePoint." .. id)
end

function CarePackage.Database:DeleteAllPoints()
	local conn = self:GetConnection()
	local sql = [[
		DELETE FROM carepackage_drop_points
	]]

	return XeninUI:InvokeSQL(conn, sql, "CarePackage.DeleteAllPoints")
end

function CarePackage.Database:SavePlanePos(vec1, vec2)
	local conn = self:GetConnection()
	local map = game.GetMap()
	vec1 = vec1.x .. "," .. vec1.y .. "," .. vec1.z
	vec2 = vec2.x .. "," .. vec2.y .. "," .. vec2.z

	local sql = [[
		INSERT INTO carepackage_plane_pos (map, vector_1, vector_2)
		VALUES (':map', ':vector_1', ':vector_2')
	]]
	sql = sql:Replace(":vector_1", vec1)
	sql = sql:Replace(":vector_2", vec2)
	sql = sql:Replace(":map", map)

	return XeninUI:InvokeSQL(conn, sql, "CarePackage.SavePlanePos." .. map)
end

function CarePackage.Database:GetPlanePos()
	local conn = self:GetConnection()
	local map = game.GetMap()
	local sql = [[
		SELECT * FROM carepackage_plane_pos
		WHERE map = ':map'
	]]
	sql = sql:Replace(":map", map)

	return XeninUI:InvokeSQL(conn, sql, "CarePackage.GetPlanePos." .. map)
end

hook.Add("CarePackage.Database.Connected", "CarePackage", function()
	CarePackage.Database:Tables()
end)

hook.Add("CarePackage.FinishedLoading", "CarePackage.Database", function()
	if (!CarePackage.Database:GetConnection().isMySQL()) then
		CarePackage.Database:Tables()
	end
end)