local function HandleAirboatAnimation( vehicle, ply )
	return ply:SelectWeightedSequence( ACT_DRIVE_AIRBOAT ) 
end

local V = {
	Name = "Triathlon Bike", 
	Class = "prop_vehicle_jeep",
	Category = "TDM Cars - GTA V",
	Author = "TheDanishMaster, R*",
	Information = "A drivable Triathlon Bike by TheDanishMaster",
	Model = "models/tdmcars/gtav/tribike.mdl",
	KeyValues = {
		vehiclescript	=	"scripts/vehicles/TDMCars/gtav/tribike.txt"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}
list.Set("Vehicles", "tribikegtav", V)
