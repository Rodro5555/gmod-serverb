CarePackage.Config = CarePackage.Config or {}

-- How high up should the plane fly? In rp_downtown_tits I recommend that you use the default value of 3500
-- Noclip above the map and type getpos in your console, then grab the third number and put it in here if you want the plane to fly at the height you are at
CarePackage.Config.PlaneHeight = 7000
-- How fast should the plane fly? This is units per second
CarePackage.Config.PlaneSpeed = 650
-- How long should it take for the crate to drop from plane and hit the ground?
CarePackage.Config.DropTime = 8

-- If you touch the care package in any way before it's landed will you die?
-- I recommend to turn this setting on
CarePackage.Config.KillOnImpact = true
-- How many seconds in between checks if they are touching care package before it lands?
-- I recommend around 0.1-0.2, any higher and it'll feel very laggy
-- The lower the more resource intensive it is.
CarePackage.Config.KillTickDelay = 0.1

-- How long should it take for the crate to unlock after somebody has begun opening it?
CarePackage.Config.OpenTime = 5

-- How long time should it take for the crate to despawn in seconds?
CarePackage.Config.DespawnTime = 300
-- If the care package has been opened, how long time should it take till it despawns then?
CarePackage.Config.DespawnTimeOpened = 60

-- How many items in a drop? If this is higher than 4 the menu will add a scrollbar.
CarePackage.Config.ItemsPerDrop = 3

-- How many seconds before the airdrop drops should it give a warning in chat?
CarePackage.Config.CommencingSeconds = 30

CarePackage.Config.SpawnTime = {
	PlayerBased = {
		-- Should the drop time be based off players online?
		-- If this is disabled the drop time is instead randomised.
		Enabled = true,
		-- If the drop time is based off online players, where should it "cap" the time.
		-- If the player count is this number or above it'll drop every *minimum* time
		-- Minimum time is defined just under this
		CapAt = 180
	},
	-- Minimum time?
	-- If PLayerBased is turned off this is the minimum random time
	-- If PlayerBased is turned on this is the minimum time when the player count is at or higher than CapAt
	Min = 180,
	-- Maximum time?
	-- Same concept as minimum time, but this is the time if player count are at 5 or less if PlayerBased is turned on
	Max = 220
}

-- Make a circle around the care package when somebody tries to open it?
-- Good for having an indicator for PVP area
CarePackage.Config.Indicator = {
	-- Should it be enabled?
	Enabled = true,
	-- How much should it's radius be? 10000 is a good default size.
	Radius = 10000,
	-- What should the color of the circle be?
	Color = ColorAlpha(XeninUI.Theme.Red, 150)
}

-- Should skins from EzSkins be looted on first time?
-- Enabling this, the skin will be tagged as looted even if the person alredy have the skin
CarePackage.Config.OnetimeSkinLoot = false
-- The model of the crate
-- Default: models/sterling/carepackage_crate.mdl
CarePackage.Config.Model = "models/sterling/carepackage_crate.mdl"
-- The plane model
-- Default: models/custom/c17_static.mdl
CarePackage.Config.PlaneModel = "models/custom/c17_static.mdl"
-- If your model got an animation that it should play you can type it here.
-- USE THE ANIMATION NAME, NOT THE NUMBER!
-- If you don't use an animation set this to false
CarePackage.Config.PlaneAnimation  = false
-- If your plane model by default has weird angles, use this to readjust the angle
-- https://wiki.garrysmod.com/page/Global/Angle
-- Just experiment with it if you're unsure, use the flare gun to keep spawning in planes
CarePackage.Config.AngleAdjustment = Angle(0, 0, 0)
-- Path for the sound
CarePackage.Config.SoundPath = "xenin/carepackage/plane.wav"
-- If your plane height is really low, you might want to lower the volume (0-1 number)
CarePackage.Config.SoundVolume = 1

-- The material file that is the "looted" text
CarePackage.Config.LootedMat = Material("xenin/carepackage/looted_english.png", "smooth")
-- Color of the smoke
CarePackage.Config.SmokeColor = Color(230, 58, 64)
-- Theme color for chat messages
CarePackage.Config.ThemeColor = Color(201, 176, 15)
-- String for the theme. Remember a space at the end!
CarePackage.Config.ThemeText = "[Drop de Suministros] "
-- If you don't own Xenin Inventory what should the color of an item if not configured be?
CarePackage.Config.DefaultItemColor = Color(125, 125, 125)

-- Language
-- By default there is only English but you can add more languages
CarePackage.Config.Language = "Spanish"

-- The function to determine if someone is an admin.
CarePackage.Config.IsAdmin = function(ply)
	return CLIENT and ply:GetUserGroup() == "superadmin" or SERVER
end
