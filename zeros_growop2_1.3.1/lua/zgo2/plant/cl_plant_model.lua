zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

/*

	This whole system was way more complex in previous versions (500 lines of code boi :I) where we procedurally generated weedplants (BranchCount, Distripution, BranchMorph)
	Because of performance reasons (Way to many client side entities) i removed all that and now the only thing thats changed on the mesh is the model and scale.

*/

/*
	Updates the model of the plant
*/
function zgo2.Plant.UpdateModel(Plant)
	if not Plant.GetPlantID then return end

	local plant_id = Plant:GetPlantID()
	local plant_data = zgo2.Plant.GetData(plant_id)

	local grow_scale = (1 / zgo2.Plant.GetGrowTime(plant_id,Plant)) * (Plant.LastProgress or 0)

	zgo2.Plant.Update(Plant,plant_data,grow_scale)
end

/*
	Updates the plants visuals
*/
local GrowColor = Color(106,181,109,255)
function zgo2.Plant.Update(Plant,PlantData,grow_scale)
	if not IsValid(Plant) then return end

	// Set the model of the plant
	Plant:SetModel(zgo2.Plant.GetMesh(PlantData))

	if not PlantData then return end

	local width, height =  zgo2.Plant.GetFinalSize(Plant,PlantData)

	// Scale the root model
	local vmat = Matrix()
	local scale = Vector(width,width,height) * grow_scale
	vmat:Scale(scale)
	Plant:EnableMatrix( "RenderMultiply", vmat )

	local PotScale = 1
	if not zgo2.Plant.InsideTent(Plant) and IsValid(Plant:GetParent()) then
		PotScale = Plant:GetParent():GetModelScale()
	end

	Plant:SetModelScale(PlantData.style.scale * PotScale)
	Plant:SetupBones()

	// Update grow color
	Plant:SetColor(zclib.util.LerpColor(grow_scale, GrowColor, color_white))
end
