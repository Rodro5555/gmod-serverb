
print( "[SIMFPHYS] Legacy EyeAngles initialized" )
print( "Restores the original EyeAngles method that existed since release of gmod up to May 2021" )
print( "(only for players that are sitting inside a simfphys vehicle)" )
print( "What this fixes compared to latest gmod branch:" )
print( "  * EyeAngles do not use the ~20 degree deadspot" )
print( "  * clientside EyeAngles are LOCAL TO VEHICLE again" )
print( "  * this will hopefully restore functionality for all simfphys vehicles that have a custom camera view (tanks or similar)" )

local meta = FindMetaTable( "Entity" )
 
local Eye_Angles_OG = meta.EyeAngles

function meta:EyeAngles()
	if not isfunction( self.IsPlayer ) or not isfunction( self.LocalEyeAngles ) then return Eye_Angles_OG( self ) end -- safety check

	if not self:IsPlayer() then return Eye_Angles_OG( self ) end

	if IsValid( self:GetSimfphys() ) then
		if SERVER then
			return self:GetVehicle():LocalToWorldAngles( self:LocalEyeAngles() )
		else
			return self:LocalEyeAngles()
		end
	end

	return Eye_Angles_OG( self )
end