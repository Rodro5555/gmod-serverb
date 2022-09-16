local pelvis             = "ValveBiped.Bip01_Pelvis"
local r_calf             = "ValveBiped.Bip01_R_Calf"
local l_calf             = "ValveBiped.Bip01_L_Calf"
local r_thigh            = "ValveBiped.Bip01_R_Thigh"
local l_thigh            = "ValveBiped.Bip01_L_Thigh"
local r_foot             = "ValveBiped.Bip01_R_Foot"
local l_foot             = "ValveBiped.Bip01_L_Foot"
local r_upperarm         = "ValveBiped.Bip01_R_UpperArm"
local l_upperarm         = "ValveBiped.Bip01_L_UpperArm"
local r_forearm          = "ValveBiped.Bip01_R_ForeArm"
local l_forearm          = "ValveBiped.Bip01_L_ForeArm"
local r_hand             = "ValveBiped.Bip01_R_Hand"
local l_hand             = "ValveBiped.Bip01_L_Hand"
local head               = "ValveBiped.Bip01_Head1"
--Main gauche
local l_auricullaire_4   = "ValveBiped.Bip01_L_Finger4"
local l_auricullaire_41  = "ValveBiped.Bip01_L_Finger41"
local l_auricullaire_42  = "ValveBiped.Bip01_L_Finger42"
local l_annulaire_3      = "ValveBiped.Bip01_L_Finger3"
local l_annulaire_31     = "ValveBiped.Bip01_L_Finger31"
local l_annulaire_32     = "ValveBiped.Bip01_L_Finger32"
local l_majeur_2         = "ValveBiped.Bip01_L_Finger2"
local l_majeur_21        = "ValveBiped.Bip01_L_Finger21"
local l_majeur_22        = "ValveBiped.Bip01_L_Finger22"
local l_index_1          = "ValveBiped.Bip01_L_Finger1"
local l_index_11         = "ValveBiped.Bip01_L_Finger11"
local l_index_12         = "ValveBiped.Bip01_L_Finger12"
local l_pouce_0          = "ValveBiped.Bip01_L_Finger0"
local l_pouce_01         = "ValveBiped.Bip01_L_Finger01"
local l_pouce_02         = "ValveBiped.Bip01_L_Finger02"

--Main droite
local r_auricullaire_4   = "ValveBiped.Bip01_R_Finger4"
local r_auricullaire_41  = "ValveBiped.Bip01_R_Finger41"
local r_auricullaire_42  = "ValveBiped.Bip01_R_Finger42"
local r_annulaire_3      = "ValveBiped.Bip01_R_Finger3"
local r_annulaire_31     = "ValveBiped.Bip01_R_Finger31"
local r_annulaire_32     = "ValveBiped.Bip01_R_Finger32"
local r_majeur_2         = "ValveBiped.Bip01_R_Finger2"
local r_majeur_21        = "ValveBiped.Bip01_R_Finger21"
local r_majeur_22        = "ValveBiped.Bip01_R_Finger22"
local r_index_1          = "ValveBiped.Bip01_R_Finger1"
local r_index_11         = "ValveBiped.Bip01_R_Finger11"
local r_index_12         = "ValveBiped.Bip01_R_Finger12"
local r_pouce_0          = "ValveBiped.Bip01_R_Finger0"
local r_pouce_01         = "ValveBiped.Bip01_R_Finger01"
local r_pouce_02         = "ValveBiped.Bip01_R_Finger02"

local origin = Vector(0,0,0)
local originA = Angle(0,0,0)
local cheapbonemanips = {}

cheapbonemanips["NoRealistBikeKTMDuke690"] = {
	[pelvis]             	= {origin,originA},
	[r_calf]             	= {origin,originA},
	[l_calf]             	= {origin,originA},
	[r_thigh]            	= {origin,originA},
	[l_thigh]            	= {origin,originA},
	[r_foot]             	= {origin,originA},
	[l_foot]             	= {origin,originA},
	[r_upperarm]         	= {origin,originA},
	[r_forearm]          	= {origin,originA},
	[r_hand]             	= {origin,originA},
	[l_upperarm]         	= {origin,originA},
	[l_forearm]          	= {origin,originA},
	[l_hand]             	= {origin,originA},
	[head]               	= {origin,originA},
	--Gauche
	[l_auricullaire_4]		= {origin,originA},
	[l_auricullaire_41]		= {origin,originA},
	[l_auricullaire_42]		= {origin,originA},
	[l_annulaire_3]			= {origin,originA},
	[l_annulaire_31]		= {origin,originA},
	[l_annulaire_32]		= {origin,originA},
	[l_majeur_2]			= {origin,originA},
	[l_majeur_21]			= {origin,originA},
	[l_majeur_22]			= {origin,originA},
	[l_index_1]				= {origin,originA},
	[l_index_11]			= {origin,originA},
	[l_index_12]			= {origin,originA},
	[l_pouce_0]				= {origin,originA},
	[l_pouce_01]			= {origin,originA},
	[l_pouce_02]			= {origin,originA},
	--Droite
	[r_auricullaire_4]		= {origin,originA},
	[r_auricullaire_41]		= {origin,originA},
	[r_auricullaire_42]		= {origin,originA},
	[r_annulaire_3]			= {origin,originA},
	[r_annulaire_31]		= {origin,originA},
	[r_annulaire_32]		= {origin,originA},
	[r_majeur_2]			= {origin,originA},
	[r_majeur_21]			= {origin,originA},
	[r_majeur_22]			= {origin,originA},
	[r_index_1]				= {origin,originA},
	[r_index_11]			= {origin,originA},
	[r_index_12]			= {origin,originA},
	[r_pouce_0]				= {origin,originA},
	[r_pouce_01]			= {origin,originA},
	[r_pouce_02]			= {origin,originA},
}

cheapbonemanips["InRealistBikeKTMDuke690"] = {
	[pelvis]             	= {Vector(-5,0,0),Angle(0,0,0)},
	[r_calf]             	= {Vector(0,0,0),Angle(20,45,0)},
	[l_calf]             	= {Vector(0,0,0),Angle(-20,45,0)},
	[r_thigh]            	= {Vector(0,0,0),Angle(20,30,0)},
	[l_thigh]            	= {Vector(0,0,0),Angle(-20,30,0)},
	[r_foot]             	= {Vector(0,0,0),Angle(0,-45,0)},
	[l_foot]             	= {Vector(0,0,0),Angle(0,-45,0)},
	[r_upperarm]         	= {Vector(0,0,0),Angle(13,25,0)},
	[r_forearm]          	= {Vector(0,0,0),Angle(0,0,0)},
	[r_hand]             	= {Vector(0,0,0),Angle(0,30,20)},
	[l_upperarm]         	= {Vector(0,0,0),Angle(-3,25,0)},
	[l_forearm]          	= {Vector(0,0,0),Angle(0,0,0)},
	[l_hand]             	= {Vector(0,0,0),Angle(-15,30,-10)},
	[head]               	= {Vector(0,0,0),Angle(0,0,0)},
	--Gauche
	[l_auricullaire_4]		= {Vector(0,0,0),Angle(0,0,0)},
	[l_auricullaire_41]		= {Vector(0,0,0),Angle(0,0,0)},
	[l_auricullaire_42]		= {Vector(0,0,0),Angle(0,0,0)},
	[l_annulaire_3]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_annulaire_31]		= {Vector(0,0,0),Angle(0,0,0)},
	[l_annulaire_32]		= {Vector(0,0,0),Angle(0,0,0)},
	[l_majeur_2]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_majeur_21]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_majeur_22]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_index_1]				= {Vector(0,0,0),Angle(0,0,0)},
	[l_index_11]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_index_12]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_pouce_0]				= {Vector(0,0,0),Angle(0,0,0)},
	[l_pouce_01]			= {Vector(0,0,0),Angle(0,0,0)},
	[l_pouce_02]			= {Vector(0,0,0),Angle(0,0,0)},
	--Droite
	[r_auricullaire_4]		= {Vector(0,0,0),Angle(0,0,0)},
	[r_auricullaire_41]		= {Vector(0,0,0),Angle(0,0,0)},
	[r_auricullaire_42]		= {Vector(0,0,0),Angle(0,0,0)},
	[r_annulaire_3]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_annulaire_31]		= {Vector(0,0,0),Angle(0,0,0)},
	[r_annulaire_32]		= {Vector(0,0,0),Angle(0,0,0)},
	[r_majeur_2]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_majeur_21]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_majeur_22]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_index_1]				= {Vector(0,0,0),Angle(0,0,0)},
	[r_index_11]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_index_12]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_pouce_0]				= {Vector(0,0,0),Angle(0,0,0)},
	[r_pouce_01]			= {Vector(0,0,0),Angle(0,0,0)},
	[r_pouce_02]			= {Vector(0,0,0),Angle(0,0,0)},
}

if SERVER then
	util.AddNetworkString( "RealBike_Adapt_bone" )
end


local function HandleBoatVehicleAnimation( vehicle, ply )
		if SERVER then
					--print(vehicle:WaterLevel())
			if vehicle:WaterLevel()==3 then
				vehicle:EnableEngine( false )
			else vehicle:EnableEngine( true ) end
		end
	return ply:SelectWeightedSequence( ACT_DRIVE_AIRBOAT )
end


hook.Add("PlayerEnteredVehicle","RealisticFixBoneKTMDuke690",function( ply, veh, role )
	if veh:GetVehicleClass()=="realistic_bike_ktm_690" then
		for k,v in pairs(cheapbonemanips["InRealistBikeKTMDuke690"]) do
			local boneid = ply:LookupBone(k)
			if boneid then
				ply:ManipulateBonePosition(boneid,v[1])
				ply:ManipulateBoneAngles(boneid,v[2])
			end
		end

		net.Start("RealBike_Adapt_bone")
			net.WriteString("Enter")
		net.Send(ply)


		----HELMET

				local pos, ang = LocalToWorld( Vector(0,-3,-5), Angle(60,90,0), ply:GetAttachment(ply:LookupAttachment("anim_attachment_head")).Pos, ply:GetAttachment(ply:LookupAttachment("anim_attachment_head")).Ang )
			
				local Helmet = ents.Create("prop_dynamic")
				Helmet:SetPos(pos)
				Helmet:SetAngles(ang)
				Helmet:SetParent(ply, ply:LookupAttachment("anim_attachment_head"))
				Helmet:SetModel("models/realistic_bike/realistic_bike_helmet.mdl")
				Helmet:SetColor(Color(255,255,255,0))
				Helmet:SetRenderMode( RENDERMODE_TRANSALPHA )
				Helmet:Spawn()
				ply:SetHelmet(Helmet:EntIndex())
	end
end)

hook.Add("PlayerLeaveVehicle","RealisticFixBoneKTMDuke690",function( ply, veh )
	if veh:GetVehicleClass()=="realistic_bike_ktm_690" then
		for k,v in pairs(cheapbonemanips["NoRealistBikeKTMDuke690"]) do
			local boneid = ply:LookupBone(k)
			if boneid then
				ply:ManipulateBonePosition(boneid,v[1])
				ply:ManipulateBoneAngles(boneid,v[2])
			end
		end

		net.Start("RealBike_Adapt_bone")
			net.WriteString("Exit")
		net.Send(ply)

		local Helmet = Entity(ply:GetHelmet())
		Helmet:Remove()
		ply:SetHaveHelmet_KTM_690(false)
	end
end)


----FOR SINGLE PLAYER---

net.Receive("RealBike_Adapt_bone", function()
	local Word = net.ReadString()
	local ply = LocalPlayer()
	
	if Word=="Enter" then
		for k,v in pairs(cheapbonemanips["InRealistBikeKTMDuke690"]) do
			local boneid = ply:LookupBone(k)
			if boneid then
				ply:ManipulateBonePosition(boneid,v[1])
				ply:ManipulateBoneAngles(boneid,v[2])
			end
		end
	elseif Word=="Exit" then
		for k,v in pairs(cheapbonemanips["NoRealistBikeKTMDuke690"]) do
			local boneid = ply:LookupBone(k)
			if boneid then
				ply:ManipulateBonePosition(boneid,v[1])
				ply:ManipulateBoneAngles(boneid,v[2])
			end
		end
	end

end)


-----Wheeling-----


local BIKE = FindMetaTable("Vehicle")
local MOTARD = FindMetaTable("Player")

function BIKE:SetBikePress(bool)
	self:SetNW2Bool("RealisticBike_BikePress", bool)
end
function BIKE:GetBikePress()
	return self:GetNW2Bool("RealisticBike_BikePress")
end

function BIKE:SetWheelingRot(float)
	self:SetNW2Float("RealisticBike_WheelingRot", float)
end
function BIKE:GetWheelingRot()
	return self:GetNW2Float("RealisticBike_WheelingRot")
end


function MOTARD:SetHaveHelmet_KTM_690(bool)
	self:SetNW2Bool("RealisticBike_HaveHelmet_KTM_690", bool)
end

function MOTARD:GetHaveHelmet_KTM_690()
	return self:GetNW2Bool("RealisticBike_HaveHelmet_KTM_690")
end

function MOTARD:SetHelmet(int)
	self:SetNW2Int("RealisticBike_Helmet", int)
end

function MOTARD:GetHelmet()
	return self:GetNW2Int("RealisticBike_Helmet")
end

function MOTARD:SetHelmetGlass_KTM_690(bool)
	self:SetNW2Bool("RealisticBike_HelmetGlass_KTM_690", bool)
end

function MOTARD:GetHelmetGlass_KTM_690()
	return self:GetNW2Bool("RealisticBike_HelmetGlass_KTM_690")
end


hook.Add("Think", "RealisticFixBoneKTMDuke690", function()

	for k,veh in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if veh:GetVehicleClass()=="realistic_bike_ktm_690" then
	
			local WheelingBone = veh:LookupBone("bone002")
			local WheelingFact = 30
			local MaxWheelingAng = 80
			-----ANIMATION
			if CLIENT then --CLIENT
				if veh:GetBikePress() and veh:GetVelocity():Length()>=50 then
					if veh:GetWheelingRot()<MaxWheelingAng then
						veh:ManipulateBoneAngles( WheelingBone, Angle( 0, veh:GetWheelingRot() + WheelingFact *FrameTime(), 0 ) )
					end
				else
					if veh:GetWheelingRot()>5 then
						veh:ManipulateBoneAngles( WheelingBone, Angle( 0, veh:GetWheelingRot() - (WheelingFact+30) *FrameTime(), 0 ) )
					else
						veh:ManipulateBoneAngles( WheelingBone, Angle( 0, 0, 0 ) )
					end
				end

			else           --SERVER
				if veh:GetBikePress() and veh:GetVelocity():Length()>=50 then
					if veh:GetWheelingRot()<MaxWheelingAng then
						veh:SetWheelingRot(veh:GetWheelingRot() + WheelingFact *FrameTime())
					end
				else
					if veh:GetWheelingRot()>5 then
						veh:SetWheelingRot(veh:GetWheelingRot() - (WheelingFact+30) *FrameTime())
					else
						veh:SetWheelingRot(0)
					end
				end
					-----HELMET
				if IsValid(veh:GetDriver()) then
					local ply = veh:GetDriver()
					local helmet = Entity(ply:GetHelmet())
					
					if ply:GetHelmetGlass_KTM_690() then
						helmet:ManipulateBoneAngles( helmet:LookupBone("glass"), Angle( 0, 0, -50 ) )
					else
						helmet:ManipulateBoneAngles( helmet:LookupBone("glass"), Angle( 0, 0, 0 ) )
					end

					if ply:GetHaveHelmet_KTM_690() then
						helmet:SetColor(Color(255,255,255,255))
					else
						helmet:SetColor(Color(255,255,255,0))
					end
				end
			end			
		end
	end
end)

hook.Add("VehicleMove", "RealisticFixBoneKTMDuke690", function(ply, veh, mv)
	if not veh:GetVehicleClass()=="realistic_bike_ktm_690" then return end

	local Press = mv:KeyDown(IN_ATTACK2)
	local Reload= mv:KeyPressed(IN_RELOAD)

	local ShAR = mv:KeyPressed(IN_WALK)

	if SERVER then
		if Press then
			--print("TEST")
			veh:SetBikePress(true)
		else
			veh:SetBikePress(false)
		end

		if Reload then
			if ply:GetHelmetGlass_KTM_690() then
				ply:SetHelmetGlass_KTM_690(false)
			elseif not ply:GetHelmetGlass_KTM_690() then
				ply:SetHelmetGlass_KTM_690(true)
			end
		end

		if ShAR then
			if ply:GetHaveHelmet_KTM_690() then
				ply:SetHaveHelmet_KTM_690(false)
			elseif not ply:GetHaveHelmet_KTM_690() then
				ply:SetHaveHelmet_KTM_690(true)
			end			
		end
	end
end)





local Category = "Realistic_Bike"
local V = { 	
				Name = "KTM Duke 690", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				Information = "CeiLciuZ",
				Model = "models/realistic_bike/ktm_duke_690.mdl",

				KeyValues = {
								vehiclescript	=	"scripts/vehicles/ceil-code/ktm_duke_690.txt"
							},
				Members = {
								HandleAnimation = HandleBoatVehicleAnimation,
				}
			}
list.Set( "Vehicles", "realistic_bike_ktm_690", V )