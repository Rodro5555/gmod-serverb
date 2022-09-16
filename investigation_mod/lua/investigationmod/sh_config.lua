InvestigationMod.Configuration.Language = "es"

--[[
	::: InvestigationMod.Configuration.Time_RegisterPrints :::
	
	After that someone is killed, the script register his footsteps and fingerprints during some time.
	How much time, in seconds ?

	Default : 720 seconds
]]
InvestigationMod.Configuration.Time_RegisterPrints = 720

--[[
	::: InvestigationMod.Configuration.Time_ClueRemoved :::
	
	After registering the footprints and the fingerprints, they should be removed
	after some time for optimization reasons. How much time?

	Default : 720 seconds
]]
InvestigationMod.Configuration.Time_ClueRemoved = 720

--[[
	::: InvestigationMod.Configuration.Time_RagdollRemoved :::
	
	When someone died, how much time his body stay on the ground before being
	automatically removed ( for optimization reasons ) ? 

	Default : 360 seconds
]]
InvestigationMod.Configuration.Time_RagdollRemoved = 360

--[[
	::: InvestigationMod.Configuration.ShouldBodyCollide :::
	
	Should the body collide with people and objects or not.

	Default : false
]]
InvestigationMod.Configuration.ShouldBodyCollide = false

--[[
	::: InvestigationMod.Configuration.KeysConfig :::

	All keys that can be pressed are referenced here.
	Find a list of keys here :
	https://wiki.facepunch.com/gmod/Enums/KEY
]]
InvestigationMod.Configuration.KeysConfig = {
	[ "Body" ] = {
		[ "Analyze" ] = KEY_R,
		[ "Morgue" ] = KEY_M,
		[ "Leave" ] = KEY_L,
		[ "Burn"] = KEY_B
	},
	[ "Bullet" ] = {
		[ "Analyze" ] = KEY_R,
		[ "Take" ] = KEY_E,
		[ "Leave" ] = KEY_L,
		
	},
	[ "Scanner" ] = {
		[ "Leave" ] = KEY_L,
	},
	[ "Fingerprint" ] = {
		[ "Take" ] = KEY_E,
	}
}

--[[
	::: InvestigationMod.Configuration.DontDropBullet :::

	A list of weapons that shouldn't drop a bullet if someone is killed with.
	( eg: knife, grenade )
	Normally, only weapons with bullet will drop one, but some weapons does it too.
]]
InvestigationMod.Configuration.DontDropBullet = {
	[ "weapon_crowbar" ] = true,
	[ "weapon_stunstick" ] = true,
}

--[[
	::: InvestigationMod.Configuration.CanBurnBody :::

	Allow or not the murderer to burn a body once he has killed someone.
]]
InvestigationMod.Configuration.CanBurnBody = true

--[[
	::: InvestigationMod.Configuration.JobsAllowed :::

	List all the jobs allowed to investigate.
	They'll be able to see all interactions.
]]
hook.Add( "PostGamemodeLoaded", "PostGamemodeLoaded.InvestigationMod", function() -- Do not touch this line

	InvestigationMod:AddJob( TEAM_POLICIAINVESTIGACION )

end ) -- Do not touch this line
