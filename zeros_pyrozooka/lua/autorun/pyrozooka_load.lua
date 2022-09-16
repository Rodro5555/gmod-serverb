local function pyrozooka_LoadAllFiles( fdir )

	local files,dirs = file.Find( fdir.."*", "LUA" )

	for _,file in ipairs( files ) do
		if string.match( file, ".lua" ) then

			if SERVER then AddCSLuaFile( fdir..file ) end
			include( fdir..file )

		end
	end

	for _,dir in ipairs( dirs ) do
		pyrozooka_LoadAllFiles( fdir..dir.."/" )

	end

end
pyrozooka_LoadAllFiles( "pyrozooka/" )
