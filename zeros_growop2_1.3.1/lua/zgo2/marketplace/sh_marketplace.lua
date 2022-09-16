zgo2 = zgo2 or {}
zgo2.Marketplace = zgo2.Marketplace or {}

/*

	The Marketplace manages which players has what weed in which Marketplace in the world
	Players can sell large amounts of weed from here

*/

zgo2.Marketplace.List = {}
local function AddMarketplace(data)
	// This keeps track which player owns which cargo
	data.Cargo = {
		// [SteamID64] = {[cargo_id] = cargo_data}
	}
	return table.insert(zgo2.Marketplace.List,data)
end


AddMarketplace({
	// Name of the Marketplace
	name = zgo2.language[ "California" ],

	// Location of the Marketplace in the map
	pos = Vector(250,200,0),

	// The image of the marketplace / location
	img = Material("materials/zerochain/zgo2/marketplaces/California.png", "noclamp smooth"),

	// TODO Add custom sounds per marketplace
	sound = "zgo2_map_marketplace_ambient",
})

AddMarketplace({
	name = zgo2.language[ "Jamaica" ],
	pos = Vector(428,268,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Jamaica.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Amsterdam" ],
	pos = Vector(772,137,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Amsterdam.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Tokyo" ],
	pos = Vector(1333,197,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Tokyo.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Sydney" ],
	pos = Vector(1380,455,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Sydney.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Taiwan" ],
	pos = Vector(1254,243,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Taiwan.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Tansania" ],
	pos = Vector(908,352,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Tansania.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Chile" ],
	pos = Vector(459,421,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Chile.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Paris" ],
	pos = Vector(760,160,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Paris.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Kiev" ],
	pos = Vector(864,144,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Kiev.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Moscow" ],
	pos = Vector(898,127,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Moscow.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "New York" ],
	pos = Vector(434,188,0),
	img = Material("materials/zerochain/zgo2/marketplaces/NewYork.png", "noclamp smooth")
})

AddMarketplace({
	name = zgo2.language[ "Beijing" ],
	pos = Vector(1248,217,0),
	img = Material("materials/zerochain/zgo2/marketplaces/Beijing.png", "noclamp smooth")
})


function zgo2.Marketplace.Get(id)
	return zgo2.Marketplace.List[id]
end

function zgo2.Marketplace.GetRate(id)
	return zgo2.Marketplace.List[id].buy_rate or 100
end

function zgo2.Marketplace.GetName(id)
	return zgo2.Marketplace.List[id].name or "Unkown"
end

function zgo2.Marketplace.GetNiceRate(id)
	local rate = zgo2.Marketplace.GetRate(id)
	rate = rate - 100
	local NiceRate = rate
	local NiceColor = zclib.colors[ "red01" ]

	if NiceRate > 0 then
		NiceRate = "+" .. NiceRate
		NiceColor = zclib.colors[ "green01" ]
	elseif NiceRate == 0 then
		NiceRate = 0
		NiceColor = zclib.colors[ "text01" ]
	end

	NiceRate = NiceRate .. "%"

	return NiceRate, NiceColor
end

/*
	I aint gonna calculate the shortest path between two points on a spherical map, the map is only 2d and it doesent need to be super realistic
	NOTE If i would be better at math then all of that would be only 5 lines of code :I
*/

local MapW = 1500

/*
	Returns the distance from the direct path between point A and B
*/
function zgo2.Marketplace.GetDirectDistance(MarketplaceA,MarketplaceB)
	local StartCity = zgo2.Marketplace.List[MarketplaceA].pos
	local DestinationCity = zgo2.Marketplace.List[MarketplaceB].pos

	return StartCity:Distance(DestinationCity)
end

/*
	Returns the distance and Intersecting Points using the path which goes all around the globe
*/
function zgo2.Marketplace.GetAroundData(MarketplaceA,MarketplaceB)
	local StartCity = zgo2.Marketplace.List[MarketplaceA].pos
	local DestinationCity = zgo2.Marketplace.List[MarketplaceB].pos

	local AroundDist = 0
	local AroundA
	local AroundB

	local CenterHeight = Lerp(0.5,StartCity.y,DestinationCity.y)

	// On which side on the map are we, LEFT or RIGHT?
	if StartCity.x < (MapW / 2) then
		// Start Position is on the left side

		// From start to total left
		local TotalLeft = Vector(0,CenterHeight,0)
		AroundA = TotalLeft
		AroundDist = AroundDist + StartCity:Distance(TotalLeft)

		// From RIGHT to destination
		local TotalRight = Vector(MapW,CenterHeight,0)
		AroundB = TotalRight
		AroundDist = AroundDist + TotalRight:Distance(DestinationCity)
	else
		// Start Position is on the Right side

		// From start to total RIGHT
		local TotalRight = Vector(MapW,CenterHeight,0)
		AroundA = TotalRight
		AroundDist = AroundDist + StartCity:Distance(TotalRight)

		// From LEFT to destination
		local TotalLeft = Vector(0,CenterHeight,0)
		AroundB = TotalLeft
		AroundDist = AroundDist + TotalLeft:Distance(DestinationCity)
	end
	return AroundDist , AroundA , AroundB
end

/*
	Builds a list of points which we can use to draw the path
*/
local function GetSegments(dist) return 40/*(20 / 100) * dist*/ end
function zgo2.Marketplace.BuildLine(seg,PosA,PosB)
	local PathPoints = {}
	local height = math.abs(Lerp(0.5,PosA.y,PosB.y)) / 10
	for i = 0, seg do
		local bend
		local fract = (1 / seg) * i

		if fract < 0.5 then
			bend = Lerp(math.ease.InOutQuad((1 / 0.5) * fract), 0, height)
		else
			bend = Lerp(math.ease.InOutQuad((1 / 0.5) * (fract - 0.5)), height, 0)
		end

		table.insert(PathPoints, Lerp(fract, PosA, PosB) + Vector(0, bend, 0))
	end
	return PathPoints
end
function zgo2.Marketplace.BuildPaths(MarketplaceA,MarketplaceB)

	local StartCity = zgo2.Marketplace.List[MarketplaceA].pos
	local DestinationCity = zgo2.Marketplace.List[MarketplaceB].pos

	local DirectDist = zgo2.Marketplace.GetDirectDistance(MarketplaceA,MarketplaceB)

	local AroundDist , AroundA , AroundB = zgo2.Marketplace.GetAroundData(MarketplaceA,MarketplaceB)

	// Now which path is shorter
	local PathA
	local SegmentA

	local PathB
	local SegmentB

	if DirectDist < AroundDist then
		PathA = zgo2.Marketplace.BuildLine(GetSegments(DirectDist),StartCity,DestinationCity)
	else
		local DistA = StartCity:Distance(AroundA)
		SegmentA = math.Round((GetSegments(AroundDist) / AroundDist) * DistA)
		PathA = zgo2.Marketplace.BuildLine(SegmentA,StartCity,AroundA)

		local DistB = AroundB:Distance(DestinationCity)
		SegmentB = math.Round((GetSegments(AroundDist) / AroundDist) * DistB)
		PathB = zgo2.Marketplace.BuildLine(SegmentB,AroundB,DestinationCity)
	end
	return PathA , PathB , AroundA , AroundB , SegmentA , SegmentB
end

/*
	Draws a line on the map between the two Marketplaces, using the shortest path
*/

local function DrawIndicator(pos,color)
	local width = 25 * zclib.hM
	local height = 25 * zclib.hM
	surface.SetDrawColor(color)
	surface.SetMaterial(zclib.Materials.Get("close"))
	surface.DrawTexturedRectRotated(pos.x * zclib.wM, pos.y * zclib.wM, width, height, 0)
end

local function DrawLine(color,points)
	local LastPoint
	for k,v in pairs(points) do
		if LastPoint then
			surface.SetDrawColor(color)
			surface.DrawLine(LastPoint.x * zclib.wM, LastPoint.y * zclib.hM, v.x * zclib.wM, v.y * zclib.hM)
		end
		LastPoint = v
	end
end

function zgo2.Marketplace.DrawPath(color,MarketplaceA,MarketplaceB)

	local PathA , PathB , AroundA , AroundB = zgo2.Marketplace.BuildPaths(MarketplaceA,MarketplaceB)

	if PathA then DrawLine(color,PathA) end

	if PathB then
		DrawLine(color,PathB)

		// Draw the intersection markers if we use the path around the map
		DrawIndicator(AroundA,color)
		DrawIndicator(AroundB,color)
	end
end

/*
	Returns the position on a line according to a value between 0-1
*/
function zgo2.Marketplace.GetPositionOnPath(TransferID,MarketplaceA,MarketplaceB,Progress)
	local DirectDist = zgo2.Marketplace.GetDirectDistance(MarketplaceA,MarketplaceB)
	local AroundDist = zgo2.Marketplace.GetAroundData(MarketplaceA,MarketplaceB)

	local PathA , PathB , AroundA , AroundB , SegmentA , SegmentB = zgo2.Marketplace.BuildPaths(MarketplaceA,MarketplaceB)

	local Point
	local Pos

	if DirectDist < AroundDist then
		Point = math.Round(GetSegments(DirectDist) * Progress)
		Pos = PathA[ Point ]

	else
		local TransferData = zgo2.Marketplace.Transfers[TransferID]

		if Progress > 0.5 then
			Progress = (1 / 0.5) * (Progress - 0.5)
			Point = math.Round(SegmentB * Progress)
			Pos = PathB[Point]

			if not TransferData.HitBorder and Pos then
				TransferData.HitBorder = true
				TransferData.PlanePos = Pos
			end
		else
			Progress = (1 / 0.5) * Progress
			Point = math.Round(SegmentA * Progress)
			Pos = PathA[Point]

			if TransferData.HitBorder and Pos then
				TransferData.HitBorder = nil
				TransferData.PlanePos = Pos
			end
		end
	end

	return Pos
end

/*
	Draws a plane on the map along the path according to travel time
*/
function zgo2.Marketplace.DrawPlane(TransferID,MarketplaceA,MarketplaceB,TravelTime,DepatureTime,MuleID)

	// How much time till arival
	local Remain = math.Clamp(CurTime() - DepatureTime,0,TravelTime)

	// Convert value to 0 - 1
	local Progress = math.Clamp((1 / TravelTime) * Remain, 0, 1)

	// Get the path point that corresponds to this value
	local Pos = zgo2.Marketplace.GetPositionOnPath(TransferID,MarketplaceA,MarketplaceB,Progress)

	local TransferData = zgo2.Marketplace.Transfers[TransferID]

	// Start smoothing
	if TransferData.PlanePos == nil then TransferData.PlanePos = Pos end
	if TransferData.PlanePos and Pos then
		local MuleData = zgo2.config.Mules[MuleID]
		TransferData.PlanePos = Lerp(FrameTime() * MuleData.speed,TransferData.PlanePos,Pos)
	end

	local rot = 0
	if Pos and TransferData.PlanePos then
		rot = Pos.x > TransferData.PlanePos.x and -90 or 90
	end

	if TransferData.PlanePos then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(zclib.Materials.Get("zgo2_icon_plane"))
		surface.DrawTexturedRectRotated(TransferData.PlanePos.x * zclib.wM, TransferData.PlanePos.y * zclib.hM, 40 * zclib.wM, 40 * zclib.hM, rot)
	end
end

/*
	Returns the travel distance between the start and destination marketplace
*/
function zgo2.Marketplace.GetTravelDistance(MarketplaceA,MarketplaceB)
	local DirectDist = zgo2.Marketplace.GetDirectDistance(MarketplaceA,MarketplaceB)
	local AroundDist = zgo2.Marketplace.GetAroundData(MarketplaceA,MarketplaceB)
	if DirectDist < AroundDist then
		return DirectDist
	else
		return AroundDist
	end
end

/*
	Returs the real world distance , or atleast a close enough distance
*/
function zgo2.Marketplace.GetRealTravelDistance(MarketplaceA,MarketplaceB)
	// 229407176
	return zgo2.Marketplace.GetTravelDistance(MarketplaceA, MarketplaceB) * 23
end

/*
	Returns the travel duration
*/
function zgo2.Marketplace.GetTravelDuration(MuleID, MarketplaceA, MarketplaceB)
	// Get the speed of the used mule
	local MuleData = zgo2.config.Mules[ MuleID ]

	return (zgo2.Marketplace.GetTravelDistance(MarketplaceA, MarketplaceB) / MuleData.speed) * zgo2.config.Marketplace.TravelDuration
end

/*
	Returns how many transfer the player can do at once
*/
function zgo2.Marketplace.GetTransferLimit(ply)

	local limit = zgo2.config.Marketplace.TransferLimit[zclib.Player.GetRank(ply)]
	if not limit then limit = zgo2.config.Marketplace.TransferLimit["Default"] end
	if not limit then limit = 3 end

	return limit
end

/*
	Returns the weight of the whole cargo tahts being shipped
*/
function zgo2.Marketplace.GetFreightWeight(CargoList,OnlySpillage)

	if not CargoList then return 0 end

	// Keep track which cargo_id has spillage
	local SpillageList = {}

	local FreightWeight = 0
	for cargo_id,move_amount in pairs(CargoList) do

		local cargo_data = CargoList[cargo_id]
		if not cargo_data then continue end

		// Can the entity class even be sold?
		local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
		if not CargoConfig then continue end

		// Should we only count cargo that has spillage?
		if OnlySpillage and not CargoConfig.HasSpillage then continue end

		// Write down which items have spillage
		SpillageList[cargo_id] = true

		FreightWeight = FreightWeight + CargoConfig.GetAmount(cargo_data)
	end
	return FreightWeight , SpillageList
end

/*
	Returns the shipping cost according to weight
*/
function zgo2.Marketplace.GetShippingCost(StoredCargo,CargoList)
	if not StoredCargo then return 0 end

	local ShippingCost = 0
	for k,v in pairs(CargoList) do

		local cargo_data = StoredCargo[k]
		if not cargo_data then continue end

		// Can the entity class even be sold?
		local CargoConfig = zgo2.Cargo.Get(cargo_data[1])
		if not CargoConfig then continue end

		ShippingCost = ShippingCost + (CargoConfig.GetAmount(cargo_data) * CargoConfig.GetShippingCost(cargo_data))
	end
	return math.Round(ShippingCost)
end
