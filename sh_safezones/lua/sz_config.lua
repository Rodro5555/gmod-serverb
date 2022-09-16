/**
* General configuration
**/

-- Usergroups allowed to add/modify Safe Zones
SH_SZ.Usergroups = {
	["admin"] = true,
	["superadmin"] = true,
	["owner"] = true,
}

-- If the "Block players from attacking" Safe Zone option is activated,
-- this is the whitelist of SWEPs players are allowed to attack with inside a Safe Zone.
-- Admins are not affected by this option; they can attack with any weapon.
SH_SZ.WeaponWhitelist = {
	["gmod_camera"] = true,
	["weapon_physcannon"] = true,
	["weapon_medkit"] = true,
}

-- Commands to bring up the Safe Zone Editor menu
-- Case/whitespace insensitive, ! commands are automatically replaced by /
SH_SZ.Commands = {
	["/safezones"] = true,
	["/safezone"] = true,
	["/sz"] = true,
}

-- Use Steam Workshop for the content instead of FastDL?
SH_SZ.UseWorkshop = true

-- Controls for the Editor camera.
-- See a full list here: http://wiki.garrysmod.com/page/Enums/KEY
SH_SZ.CameraControls = {
	forward = KEY_W,
	left = KEY_A,
	back = KEY_S,
	right = KEY_D,
}

-- Should the Safe Zone points hit props when editing?
SH_SZ.HitProps = false

/**
* HUD configuration
**/

-- Where to display the Safe Zone Indicator on the screen.
-- Possible options: topleft, top, topright, left, center, right, bottomleft, bottom, bottomright
SH_SZ.HUDAlign = "top"

-- Offset of the Indicator relative to its base position.
-- Use this if you want to move the indicator by a few pixels.
SH_SZ.HUDOffset = {
	x = 0,
	y = 0,
	scale = false, -- Set to false/true to enable offset scaling depending on screen resolution.
}

/**
* Advanced configuration
* Edit at your own risk!
**/

SH_SZ.WindowSize = {w = 800, h = 300}

SH_SZ.DefaultOptions = {
	name = "Safe Zone",
	namecolor = "52,152,219",
	hud = true,
	noatk = true,
	nonpc = true,
	noprop = true,
	noveh = true,
	pusg = "",
	ptime = 5,
	entermsg = "",
	leavemsg = "",
}

SH_SZ.MaximumSize = 1024

SH_SZ.DataDirName = "sh_safezones"

SH_SZ.ZoneHitboxesDeveloper = false

SH_SZ.TeleportIdealDistance = 512

/**
* Theme configuration
**/

-- Font to use for normal text throughout the interface.
SH_SZ.Font = "Circular Std Medium"

-- Font to use for bold text throughout the interface.
SH_SZ.FontBold = "Circular Std Bold"

-- Color sheet. Only modify if you know what you're doing
SH_SZ.Style = {
	header = Color(52, 152, 219, 255),
	bg = Color(52, 73, 94, 255),
	inbg = Color(44, 62, 80, 255),

	close_hover = Color(231, 76, 60, 255),
	hover = Color(255, 255, 255, 10, 255),
	hover2 = Color(255, 255, 255, 5, 255),

	text = Color(255, 255, 255, 255),
	text_down = Color(0, 0, 0),
	textentry = Color(236, 240, 241),
	menu = Color(127, 140, 141),

	success = Color(46, 204, 113),
	failure = Color(231, 76, 60),
}

/**
* Language configuration
**/

-- Various strings used throughout the chatbox. Change them to your language here.
-- %s and %d are special strings replaced with relevant info, keep them in the string!

SH_SZ.Language = {
	safezone = "Safe Zone",
	safezone_type = "Safe Zone Type",
	cube = "Cube",
	sphere = "Sphere",

	select_a_safezone = "Select a Safe Zone",

	options = "Options",
	name = "Name",
	name_color = "Name Color",
	enable_hud_indicator = "Enable HUD indicator",
	delete_non_admin_props = "Delete non-admin props",
	delete_vehicles = "Delete non-admin vehicles",
	prevent_attacking_with_weapons = "Block non-admins from attacking",
	automatically_remove_npcs = "Delete NPCs",
	time_until_protection_enables = "Time (in seconds) before protection is enabled",
	usergroups_with_protection = "Protected usergroups (separate with commas, leave blank for all)",
	enter_message = "Enter Message",
	leave_message = "Leave Message",

	will_be_protected_in_x = "You will be protected in %d seconds.",
	safe_from_damage = "You are protected from any damage.",

	place_point_x = "Place point num. %d with mouse",
	size = "Size",
	finalize_placement = "Finalize placement and then press Confirm",

	add = "Add",
	edit = "Edit",
	fill_vertically = "Fill vertically",
	reset = "Reset",
	confirm = "Confirm",
	teleport_there = "Teleport there",
	save = "Save",
	delete = "Delete",
	cancel = "Cancel",
	move_camera = "Move Camera",
	rotate_camera = "RIGHT-CLICK: Rotate Camera",

	an_error_has_occured = "An error has occured. Please restart the server and try again.",
	not_allowed = "You are not allowed to perform this action.",
	safe_zone_created = "Safe Zone successfully created!",
	safe_zone_edited = "Safe Zone successfully edited!",
	safe_zone_deleted = "Safe Zone successfully deleted!",
}