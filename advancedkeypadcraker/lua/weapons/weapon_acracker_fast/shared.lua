AddCSLuaFile()


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Default SWEP config
---------------------------------------------------------------------------------------------------------------------------------------------
*/

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Author = "Drover"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""
SWEP.PrintName = "Fast Keypad Cracker"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "slam"
SWEP.HoldType ="slam"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Keypad Cracker"
SWEP.Base = "weapon_acracker_base";

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Config
---------------------------------------------------------------------------------------------------------------------------------------------
*/
SWEP.difficultWord = 5;				       			     	 -- amount of letters in words [4-10]				  																
SWEP.loadTimeCFG = 2;										 -- how long a loading goes before a memory screen.  
SWEP.hideDraw = 0.1;										 -- how long every line loads in a memory sreen.
SWEP.keypadCrackingSoundAfterLoad = true;  					 -- play world sounds while loading a memory screen. set false to dissable.
SWEP.callDenied = true;									  	 -- If wrong password choosed, call "Denied" on keypad.
SWEP.haveManual = true;										 -- open manual, when player press "Reload" key
