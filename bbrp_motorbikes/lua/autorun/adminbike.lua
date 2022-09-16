local light_table = {

	Headlight_sprites = { 
	
	{pos = Vector(-7.5,36,36),size = 80},
	{pos = Vector(6,36,36),size = 80},
	
	},
	
	Brakelight_sprites = { 
		
		{pos = Vector(2.2,-44,44),size = 100},
		{pos = Vector(-1.2,-44,44),size = 100},
	
	},


		Rearlight_sprites = { 
		{pos = Vector(2.2,-44,44),size = 100},
		{pos = Vector(-1.2,-44,44),size = 100},
	},
	
	DelayOn = 0,
	DelayOff = 0,
	BodyGroups = {
		On = {5,1}, 
		Off = {5,0}
	},
		Turnsignal_sprites = { 
		Left = { 

			{pos = Vector(-7,-40,36),size = 80},
			{pos = Vector(-14.2,23,46),size = 80},
			
		},
		Right = { 

			{pos = Vector(8,-40,36),size = 80},
			{pos = Vector(14.5,23,46),size = 80},
			
		},
	
	},
}
list.Set( "simfphys_lights", "bedocuklights", light_table) 

local V = {
	Name = "Ducati Panigalle ",
	Model = "models/bati.mdl", 
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Bikes",

	Members = {
		Mass = 2099,
		
		LightsTable = "bedocuklights",
		
		FrontWheelRadius = 14,
		RearWheelRadius = 14,

		SeatOffset = Vector(-8,0,-4),
		SeatPitch = 0,
		SeatYaw = 0,

	PassengerSeats = {
			{
			pos = Vector(25,0,26),
			ang = Angle(0,90,0)
			},
	},
	
		FrontHeight = 8.5,
		FrontConstant = 29000,
		FrontDamping = 6500,
		FrontRelativeDamping = 0,
		
		RearHeight = 9.2,
		RearConstant = 30000,
		RearDamping = 5500,
		RearRelativeDamping = 0,
		
		FastSteeringAngle = 40,
		SteeringFadeFastSpeed = 2535,
		
		StrengthenSuspension = false,
		
		TurnSpeed = 9,	
		
		MaxGrip = 130,
		Efficiency = 2.7,
		GripOffset = -15,
		BrakePower = 39,
		BulletProofTires = true,
		
		IdleRPM = 1950,
		LimitRPM = 13000,
		PeakTorque = 138,
		PowerbandStart = 2000,
		PowerbandEnd = 11000,

		Turbocharged = false,
		Supercharged = false,
		Backfire = true,

		PowerBias = 0.75,


		
		FuelFillPos = Vector(17.64,-14.55,30.06),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,
		
		
		
		EngineSoundPreset = 5,
		
		ExhaustPositions = {
			
			--Left side
			
			
						{
				pos = Vector(-2,-43,40),
				ang = Angle(-90,90,90)
			             },

			             						{
				pos = Vector(2,-43,40),
				ang = Angle(-90,90,90)
			             },
		
			
		},
		
		Sound_Idle = "simulated_vehicles/Boxer 6/rsr28-onlow.WAV",
		Sound_IdlePitch = 0,
		
		Sound_Mid = "simulated_vehicles/Boxer 6/rsr28-onmid.WAV",
		Sound_MidPitch = 0.55,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,		
		Sound_MidFadeOutRate = 1,                    
		
		Sound_High = "simulated_vehicles/Boxer 6/rsr28-onhigh.WAV",
		Sound_HighPitch = 0,
		Sound_HighVolume = 0,
		Sound_HighFadeInRPMpercent = 0,
		Sound_HighFadeInRate = 0,
		
		Sound_Throttle = "simulated_vehicles/Boxer 6/rsr28-onverylow.WAV",		
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		DifferentialGear = 0.1,
		Gears = {-1,0,0.8,1.5,2.2,3.1,4,5.2}
	}
}
list.Set( "simfphys_vehicles", "r757", V )