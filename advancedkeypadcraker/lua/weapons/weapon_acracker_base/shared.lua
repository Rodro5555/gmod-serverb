



/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Config
---------------------------------------------------------------------------------------------------------------------------------------------
*/
SWEP.difficultWord = 6;				       			     	 -- amount of letters in words [4-10]				  																
SWEP.loadTimeCFG = 1;										 -- how long a loading goes before a memory screen.  
SWEP.hideDraw = 0.1;										 -- how long every line loads in a memory sreen.
SWEP.keypadCrackingSoundAfterLoad = true;  					 -- play world sounds while loading a memory screen. set false to dissable.
SWEP.callDenied = true;									  	 -- If wrong password choosed, call "Denied" on keypad.
SWEP.haveManual = true;										 -- open manual, when player press "Reload" key
/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Variables
---------------------------------------------------------------------------------------------------------------------------------------------
*/

SWEP.delaying = true;
SWEP.watching = false;
SWEP.IsACracker = true;
SWEP.CrackSound = Sound("buttons/blip2.wav");

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
SWEP.PrintName = "Keypad Cracker"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "slam"
SWEP.HoldType ="slam"
SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.Category = "Keypad Cracker"

SWEP.ViewModel = Model("models/weapons/drover/v_hack.mdl");
SWEP.WorldModel = Model("models/weapons/drover/hackw.mdl");



SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.UseHands = true;
/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Initialize
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:Initialize()
    self:SetHoldType("slam");
end



/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Start Delay
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:StartDelay()
	self:SetDelay(true);
	if SERVER then
		self:SetNWInt("delay",CurTime() + self.loadTimeCFG);
		self:StartCrackSound(self.loadTimeCFG);
	else
		self.loadTime = CurTime() + self.loadTimeCFG;
	end
end


function SWEP:SetDelay(bool)
	self.delaying = bool;
	self:SetNWBool("delaying",bool);
end
/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Cancel hacking
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:pressM2()
	if CLIENT then
		RunConsoleCommand("+attack2");
		timer.Simple(0.1,function() if IsValid(LocalPlayer()) then RunConsoleCommand("-attack2"); end end);
	else
		self.Owner:ConCommand("+attack2");
		timer.Simple(0.1,function() if IsValid(self.Owner) then self.Owner:ConCommand("-attack2"); end end);
	end
end


/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Start Crack Sound
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:StartCrackSound(ttime)		
	if self.keypadCrackingSoundAfterLoad then
		ttime = ttime + self.hideDraw * 16;
	end
	if ttime != 0 then
		timer.Create("CrackSounds"..self:EntIndex(), 1, ttime, function()
			if IsValid(self) and self.targetEntity != nil then
				self:EmitSound(self.CrackSound, 100, 100);			
			end
		end)
	end

end



/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Think
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:Think()
	if CLIENT then return true end;
	if not IsValid(self.targetEntity) then return end;
	if not self.targetEntity.IsKeypad then return end; 
	if self.targetEntity != self.Owner:GetEyeTrace().Entity or self.targetEntity:GetPos():Distance(self.Owner:GetPos()) > 200 then
		self:pressM2();
	end
end

/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Primary attack
---------------------------------------------------------------------------------------------------------------------------------------------
*/

function SWEP:PrimaryAttack()
	--self:ResetSequence(self:LookupSequence("open"));

	self:SetNextPrimaryFire(CurTime() + 1);

--	if CurTime() < self:GetNWInt("delay",0) then return end;
	
	self.targetEntity = self.Owner:GetEyeTrace().Entity;
	if not IsValid(self.targetEntity) then return end;
	if not self.targetEntity.IsKeypad then self.targetEntity = nil return end; 
	self:StartDelay();
	if !self.watching then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
		self.watching = true;
	end
	if CLIENT then gui.EnableScreenClicker(true) return end;

	self:CrackKeypad(self.targetEntity);
end

 
/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Secondary attack / Deploy static shield
---------------------------------------------------------------------------------------------------------------------------------------------
*/
function SWEP:SecondaryAttack()
	if self.watching then
		timer.Simple(0.1,function()
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
		end)
		self.watching = false;
	end
	self:SetNextPrimaryFire(CurTime() + 1);
	self.targetEntity = nil;
	self:SetNWInt("delay",0);
	if CLIENT then gui.EnableScreenClicker(false) return end;
end

  





/* 
---------------------------------------------------------------------------------------------------------------------------------------------
				Reload && Deploy && Holster && Drop && Remove
---------------------------------------------------------------------------------------------------------------------------------------------
*/


function SWEP:ViewModelDrawn(viewmodel)

end

function SWEP:Reload()
	if CLIENT then
		gui.OpenURL("https://www.youtube.com/watch?v=UP1rmiCWUgw&t=21s");
	end
end

function SWEP:Deploy()
	self:SetHoldType("slam"); 
	return true
end 

function SWEP:Holster()
	return true;
end


function SWEP:OnDrop()
	if CLIENT then gui.EnableScreenClicker(false) return end;
	return true;
end

function SWEP:OnRemove()
	if CLIENT then gui.EnableScreenClicker(false) return end;
	return true;
end

