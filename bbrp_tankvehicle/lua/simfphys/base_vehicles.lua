local V = {
	Name = "HL2 Combine APC",
	Model = "models/combine_apc.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Half Life 2 / Synergy",

	Members = {
		Mass = 3500,
		MaxHealth = 3000,
		
		GibModels = {
			"models/combine_apc_destroyed_gib01.mdl",
			"models/combine_apc_destroyed_gib02.mdl",
			"models/combine_apc_destroyed_gib03.mdl",
			"models/combine_apc_destroyed_gib04.mdl",
			"models/combine_apc_destroyed_gib05.mdl",
			"models/combine_apc_destroyed_gib06.mdl",
		},
		
		FrontWheelRadius = 28,
		RearWheelRadius = 28,
		
		SeatOffset = Vector(-25,0,104),
		SeatPitch = 0,
		
		PassengerSeats = {
		},
		
		FrontHeight = 10,
		FrontConstant = 50000,
		FrontDamping = 3000,
		FrontRelativeDamping = 3000,
		
		RearHeight = 10,
		RearConstant = 50000,
		RearDamping = 3000,
		RearRelativeDamping = 3000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 70,
		Efficiency = 1.8,
		GripOffset = 0,
		BrakePower = 70,
		BulletProofTires = true,
		
		IdleRPM = 750,
		LimitRPM = 6000,
		PeakTorque = 100,
		PowerbandStart = 1500,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(32.82,-78.31,81.89),
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/c_apc/apc_idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/c_apc/apc_mid.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_High = "",
		
		Sound_Throttle = "",
		
		snd_horn = "ambient/alarms/apc_alarm_pass1.wav",
		
		DifferentialGear = 0.3,
		Gears = {-0.1,0,0.1,0.2,0.3}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_combineapc", V )


local V = {
	Name = "HL2:EP2 Jalopy",
	Model = "models/vehicle.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Half Life 2 / Synergy",

	Members = {
		Mass = 1700,
		LightsTable = "jalopy",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,
		
		SeatOffset = Vector(-1,0,5),
		SeatPitch = 3,
		
		PassengerSeats = {
			{
				pos = Vector(21,-22,21),
				ang = Angle(0,0,9),
			}
		},
		
		ExhaustPositions = {
			{
				pos = Vector(-21.63,-142.52,37.55),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(19.65,-144.09,38.03),
				ang = Angle(90,-90,0)
			}
		},
		
		FrontHeight = 11.5,
		FrontConstant = 27000,
		FrontDamping = 2800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 8.5,
		RearConstant = 32000,
		RearDamping = 2900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 45,
		Efficiency = 1.22,
		GripOffset = -0.5,
		BrakePower = 50,
		
		IdleRPM = 750,
		LimitRPM = 6000,
		PeakTorque = 130,
		PowerbandStart = 2200,
		PowerbandEnd = 5800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(-39.07,-108.1,60.81),
		FuelTankSize = 80,
		
		PowerBias = 1,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 0.9,
		snd_idle = "simulated_vehicles/jalopy/jalopy_idle.wav",
		
		snd_low = "simulated_vehicles/jalopy/jalopy_low.wav",
		snd_low_revdown = "simulated_vehicles/jalopy/jalopy_revdown.wav",
		snd_low_pitch = 0.95,
		
		snd_mid = "simulated_vehicles/jalopy/jalopy_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jalopy/jalopy_second.wav",
		snd_mid_pitch = 1.1,
		
		Sound_Idle = "simulated_vehicles/jalopy/jalopy_idle.wav",
		Sound_IdlePitch = 0.95,
		
		Sound_Mid = "simulated_vehicles/jalopy/jalopy_mid.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 55,
		Sound_MidFadeOutRate = 0.25,
		
		Sound_High = "simulated_vehicles/jalopy/jalopy_high.wav",
		Sound_HighPitch = 0.75,
		Sound_HighVolume = 0.9,
		Sound_HighFadeInRPMpercent = 55,
		Sound_HighFadeInRate = 0.4,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		DifferentialGear = 0.3,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45}
	}
}
if (file.Exists( "models/vehicle.mdl", "GAME" )) then
	list.Set( "simfphys_vehicles", "sim_fphys_jalopy", V )
end


local V = {
	Name = "Driveable Couch",
	Model = "models/props_c17/FurnitureCouch002a.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Base",
	SpawnAngleOffset = 90,

	Members = {
		Mass = 500,

		CustomWheels = true,
		CustomSuspensionTravel = 10,

		CustomWheelModel = "models/props_phx/wheels/magnetic_small_base.mdl",
		
		CustomWheelPosFL = Vector(12,22,-15),
		CustomWheelPosFR = Vector(12,-22,-15),
		CustomWheelPosRL = Vector(-12,22,-15),
		CustomWheelPosRR = Vector(-12,-22,-15),
		CustomWheelAngleOffset = Angle(90,0,0),
		
		CustomMassCenter = Vector(0,0,0),
		
		CustomSteerAngle = 35,
		
		SeatOffset = Vector(-3,-13.5,21),
		SeatPitch = 15,
		SeatYaw = 90,
		--SeatAnim = "sit_zen", -- driver seat animation
		
		PassengerSeats = {
			{
				pos = Vector(0,-14,-12),
				ang = Angle(0,-90,0),
				--anim = "sit_zen", -- passenger seat animation
			}
		},
		
		FrontHeight = 7,
		FrontConstant = 12000,
		FrontDamping = 400,
		FrontRelativeDamping = 50,
		
		RearHeight = 7,
		RearConstant = 12000,
		RearDamping = 400,
		RearRelativeDamping = 50,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 120,
		
		TurnSpeed = 8,
		
		MaxGrip = 20,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 5,
		BulletProofTires = true,
		
		IdleRPM = 600,
		LimitRPM = 10000,
		PeakTorque = 40,
		PowerbandStart = 650,
		PowerbandEnd = 700,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,
		
		FuelType = FUELTYPE_ELECTRIC,
		FuelTankSize = 80,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "",
		Sound_IdlePitch = 0,
		
		Sound_Mid = "vehicles/apc/apc_idle1.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_High = "",
		
		Sound_Throttle = "",
		
		snd_horn = "simulated_vehicles/horn_0.wav",
		
		DifferentialGear = 0.7,
		Gears = {-0.1,0,0.1}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_couch", V )
