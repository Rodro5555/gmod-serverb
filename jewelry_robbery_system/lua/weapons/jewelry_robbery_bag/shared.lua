SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.WorldModel				= ""
SWEP.ViewModel = "models/weapons/c_smg1.mdl"

SWEP.UseHands				= false

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Jewelry Robbery"
SWEP.PrintName				= "Mochila"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

local lang = Jewelry_Robbery.Config.Language
local sentences = Jewelry_Robbery.Config.Lang

function SWEP:PrimaryAttack()

	if CLIENT then return end
	
	if (self.NextClick or 0) > CurTime() then return end

	local ply = self.Owner
	
	self.NextClick = CurTime() + 1

	local entities = ents.FindInCone(ply:EyePos(), ply:GetAimVector(), 60, 0.99)

	local ent = NULL

	for k,v in pairs(entities) do
		if v:GetClass():lower() == "jewelryrobbery_jewelry" then
			ent = v
		end
	end

	if not IsValid( ent ) then return end
	
	if IsValid(ent:GetParent()) and not ent:GetParent().IsBroken then return end 
	
	if not ent.JewelryInfos or not ent.JewelryId then return end
	
	ply.ListJewelry = ply.ListJewelry or {}
	
	local ttweight = 0
	
	for k, v in pairs( ply.ListJewelry  ) do
		
		ttweight = ttweight + Jewelry_Robbery.Config.ListJewelry[k].weight * v
		
	end
	
	if ttweight + Jewelry_Robbery.Config.ListJewelry[ent.JewelryId].weight > Jewelry_Robbery.Config.BagWeightMax then 
		
		ply:JEWNOTIF(sentences[21][lang])
		
		return
	end
	
	ply.ListJewelry[ent.JewelryId] = ply.ListJewelry[ent.JewelryId] or 0
	ply.ListJewelry[ent.JewelryId] = ply.ListJewelry[ent.JewelryId] + 1
	
	net.Start("NetworkInfos.Jewelry")
		net.WriteTable( ply.ListJewelry )
	net.Send( ply )
	
	-- if not Jewelry_Robbery.IsRobStarted() then
		-- Jewelry_Robbery.StartRobbery()
	-- end

	ent:Remove()
	
	-- if CLIENT then 
		-- local ent = self.Owner:GetEyeTrace().Entity 

		-- if not IsValid( ent ) or ent:GetClass() != "jewelryrobbery_jewelry" then return end

		-- local dist = ent:GetPos():Distance(self.Owner:GetPos())

		-- if dist > 150 then return end
		
		-- net.Start("TakeJewelry.Jewelry")
			-- net.WriteEntity( ent )
		-- net.SendToServer()
	-- end

end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	
	if not IsValid( self.Owner ) then self:Remove() end
	
	local bag = ents.Create("jewelryrobbery_bag")
	
	if not IsValid(bag) then return end
	
	local trace = {}
	trace.start = self.Owner:EyePos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80
	trace.filter = self.Owner

	local tr = util.TraceLine(trace)
	
	bag:SetPos( tr.HitPos )
	bag:Spawn()
	self:Remove()
	
	bag.ListJewelry = self.Owner.ListJewelry or {}
	
	self.Owner.Bag = bag
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end 

function SWEP:Initialize()

	self:SetHoldType( "normal" )
	
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
	
    self:GetOwner():DrawWorldModel(false)
	
	local owner = self:GetOwner()
	
	/*if SERVER then
		owner.SpeedWalk = owner.SpeedWalk or GAMEMODE.Config.walkspeed or owner:GetWalkSpeed()
		owner.SpeedRun = owner.SpeedRun or GAMEMODE.Config.runspeed or owner:GetRunSpeed()
		
		owner:SetWalkSpeed( owner.SpeedWalk/1.7 )
		owner:SetRunSpeed( owner.SpeedRun/1.7 )
	end*/
	
    return true
end

function SWEP:OnRemove()
	if SERVER then
		
		local owner = self:GetOwner()
		
		if not IsValid( owner ) then return end
		
		//owner:SetWalkSpeed( owner.SpeedWalk or  GAMEMODE.Config.walkspeed )
		//owner:SetRunSpeed( owner.SpeedRun or GAMEMODE.Config.runspeed)
		owner.ListJewelry = {}
		net.Start("NetworkInfos.Jewelry")
			net.WriteTable( owner.ListJewelry )
		net.Send( owner )
	end
end

hook.Add("SetupMove", "jewelryrobbery.slowPeopleDown", function(ply, mv)
    if not ply:HasWeapon("jewelry_robbery_bag") or not ply.ListJewelry or #ply.ListJewelry <= 0 then return end

	if not Jewelry_Robbery.Config.BagSlowdownType or Jewelry_Robbery.Config.BagSlowdownType == 0 then return end

	local speed = mv:GetMaxClientSpeed() / 1.7

	if Jewelry_Robbery.Config.BagSlowdownType == 1 then

		local ttweight = 0

		for k, v in pairs( ply.ListJewelry  ) do
			ttweight = ttweight + Jewelry_Robbery.Config.ListJewelry[k].weight * v
		end

		speed = Lerp(ttweight / Jewelry_Robbery.Config.BagWeightMax, mv:GetMaxClientSpeed(), speed)

	end

	mv:SetMaxClientSpeed(speed)
end)

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

local blur = Material("pp/blurscreen")
local function DrawBlurRect(x, y, w, h)
	
	local X, Y = 0,0

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	for i = 1, 5 do
		blur:SetFloat("$blur", (i / 3) * (5))
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
   
   draw.RoundedBox(0,x,y,w,h,Color(0,0,0,205))
   -- surface.SetDrawColor(0,0,0)
   -- surface.DrawOutlinedRect(x,y,w,h)
   
end


function SWEP:DrawHUD()
	
	
	if table.Count(self.Owner.ListJewelry or {}) != 0 then
		
		local sizey = 45 + 30 * table.Count( self.Owner.ListJewelry)
		
		local ttweight = 0
	
		DrawBlurRect( 30,30, 240, sizey )
		
		local line = 1
		for k, v in pairs( self.Owner.ListJewelry or {}  ) do
			
			draw.SimpleText(Jewelry_Robbery.Config.ListJewelry[k].name.." x "..v, "JewelryFont2", 40,40+30*line, Color(255,255,255))
			ttweight = ttweight + Jewelry_Robbery.Config.ListJewelry[k].weight * v
			line = line+1
			
		end
		local x, y = draw.SimpleText(sentences[22][lang].." ", "JewelryFont1", 40,40, Color(255,255,255))
		draw.SimpleText("("..ttweight.."/"..Jewelry_Robbery.Config.BagWeightMax .."kg)", "JewelryFont3", 40+x,40+5, Color(255,255,255),0,0)
	end
	
	local tr = util.TraceLine( {
		start = LocalPlayer():EyePos(),
		endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 60,
		filter = function( ent ) if ( ent:GetClass() == "jewelryrobbery_jewelry" ) then return true end end
	} )


	local ent = tr.Entity or NULL
	
	if not IsValid( ent ) then return end
	
	local pos = ent:LocalToWorld(ent:OBBCenter())
	local spos = pos:ToScreen()
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Material("zerochain/zerolib/ui/icon_mouse_left.png") )
	surface.DrawTexturedRect(spos.x-64/2, spos.y-64/2, 64, 64 )
		
end