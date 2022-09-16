zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

/*

	Setsup all the diffrent plant shapes

*/
zgo2.Plant.Shapes = {}
local function AddPlantShape(data) return table.insert(zgo2.Plant.Shapes,data) end
AddPlantShape("models/zerochain/props_growop2/zgo2_plant01.mdl")
AddPlantShape("models/zerochain/props_growop2/zgo2_plant02.mdl")
AddPlantShape("models/zerochain/props_growop2/zgo2_plant03.mdl")
AddPlantShape("models/zerochain/props_growop2/zgo2_plant04.mdl")

/*

	Small system to force update the plants model if requested by the SERVER

*/
if SERVER then
	util.AddNetworkString("zgo2.Plant.UpdateModel")

	function zgo2.Plant.UpdateModel(Plant)
		net.Start("zgo2.Plant.UpdateModel", true)
		net.WriteEntity(Plant)
		net.Broadcast()
	end
else
	net.Receive("zgo2.Plant.UpdateModel", function(len)
		zclib.Debug_Net("zgo2.Plant.UpdateModel", len)
		local Plant = net.ReadEntity()
		if not IsValid(Plant) then return end
		if not Plant:IsValid() then return end
		zgo2.Plant.UpdateModel(Plant)
	end)
end
