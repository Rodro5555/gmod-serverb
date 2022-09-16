zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}

zgo2.Plant.Patterns = {}
local function AddPattern(data) table.insert(zgo2.Plant.Patterns,data) end

AddPattern({name = zgo2.language[ "Gradient" ],top = Material("zerochain/zgo2/pattern/gradient.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/gradient_inverted.png","ignorez smooth noclamp")})
AddPattern({name = zgo2.language[ "Dots" ],top = Material("zerochain/zgo2/pattern/dots.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/dots_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "ZickZack" ],top =  Material("zerochain/zgo2/pattern/zickzack.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/zickzack_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "Sphere" ],top = Material("zerochain/zgo2/pattern/sphere.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/sphere_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "Polygon" ],top = Material("zerochain/zgo2/pattern/polygon.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/polygon_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "Pyramid" ],top = Material("zerochain/zgo2/pattern/pyramid.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/pyramid_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "Star" ],top = Material("zerochain/zgo2/pattern/star.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/star_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "Stripes" ],top = Material("zerochain/zgo2/pattern/stripes.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/stripes_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = zgo2.language[ "Weave" ],top = Material("zerochain/zgo2/pattern/weave.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/weave_inverted.png","ignorez smooth noclamp"),})
AddPattern({name = "Random",top = Material("zerochain/zgo2/pattern/bud.png","ignorez smooth"),bottom = Material("zerochain/zgo2/pattern/bud_inverted.png","ignorez smooth noclamp"),})

zgo2.Plant.Stems = {}
local function AddStem(texture) table.insert(zgo2.Plant.Stems,texture) end
AddStem("zerochain/zgo2/plant/stem/zgo2_stem01")
AddStem("zerochain/zgo2/plant/stem/zgo2_stem02")
AddStem("zerochain/zgo2/plant/stem/zgo2_stem03")
AddStem("zerochain/zgo2/plant/stem/zgo2_stem04")

zgo2.Plant.Leafs = {}
local function AddLeaf(texture) table.insert(zgo2.Plant.Leafs,texture) end
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf01")
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf02")
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf03")
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf04")
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf05")
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf06")
AddLeaf("zerochain/zgo2/plant/leaf/zgo2_leaf07")

zgo2.Plant.Buds = {}
local function AddBud(texture) table.insert(zgo2.Plant.Buds,texture) end
AddBud("zerochain/zgo2/plant/bud/zgo2_bud01")
AddBud("zerochain/zgo2/plant/bud/zgo2_bud02")
AddBud("zerochain/zgo2/plant/bud/zgo2_bud03")

zgo2.Plant.BudHair = {}
local function AddBudHair(texture) table.insert(zgo2.Plant.BudHair,texture) end
AddBudHair("zerochain/zgo2/plant/hair/zgo2_hair")
AddBudHair("zerochain/zgo2/plant/hair/zgo2_hair01")
AddBudHair("zerochain/zgo2/plant/hair/zgo2_hair02")
AddBudHair("zerochain/zgo2/plant/hair/zgo2_hair03")


/*

	Small system to force update the plants material if requested by the SERVER

*/
if SERVER then
	util.AddNetworkString("zgo2.Plant.UpdateMaterial")

	function zgo2.Plant.UpdateMaterial(Plant)
		net.Start("zgo2.Plant.UpdateMaterial", true)
		net.WriteEntity(Plant)
		net.Broadcast()
	end
else
	net.Receive("zgo2.Plant.UpdateMaterial", function(len)
		zclib.Debug_Net("zgo2.Plant.UpdateMaterial", len)
		local Plant = net.ReadEntity()
		if not IsValid(Plant) then return end
		if not Plant:IsValid() then return end
		Plant.UpdatedPlant_material = nil
	end)
end
