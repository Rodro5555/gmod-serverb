include("shared.lua")
include("zrmine_config.lua")
SWEP.PrintName = "Pickaxe" // The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true // Do you want the SWEP to have a crosshair?


local oldXP = -1
local oldLVL = -1
local UpdateXP_x = 0
local UpdateXpAnimation = true
local diffXP = 0


function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	oldXP = -1
	oldLVL = -1
end

local OF_Y = zrmine.config.PickaxeUI_Offset.y
local OF_X = zrmine.config.PickaxeUI_Offset.x
local mainOffsetX = -1

function SWEP:DrawHUD()
	local bgColor = zrmine.default_colors["white04"]

	if (zrmine.config.PickaxeThemeLight) then
		bgColor = zrmine.default_colors["white04"]
	else
		bgColor = zrmine.default_colors["black01"]
	end

	// The Inv Cap
	draw.RoundedBox(2.5, ScrW() / 2.495 + OF_X, ScrH() / 1.078 + OF_Y, ScrW() / 5, ScrH() / 75, bgColor)
	local invCap = (5.05 * self:GetOreInv())
	local curAmount = self:GetIron() + self:GetBronze() + self:GetSilver() + self:GetGold() + self:GetCoal()

	if (curAmount > self:GetOreInv()) then
		curAmount = self:GetOreInv()
	end

	draw.RoundedBox(2.5, ScrW() / 2.49 + OF_X, ScrH() / 1.077 + OF_Y, ScrW() / invCap * curAmount, ScrH() / 90, zrmine.default_colors["brown01"])
	draw.DrawText(math.Round(curAmount, 1) .. zrmine.config.BuyerNPC_Mass, "zrmine_pickaxe_font4", ScrW() / 2 + OF_X, ScrH() / 1.080 + OF_Y, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)

	// The XP bar
	local xpInfo
	local plyLvl = self:GetPlayerLVL()
	local xpCap = (5.05 * zrmine.config.Pickaxe_Lvl[plyLvl].NextXP)

	local curXP = self:GetPlayerXP()

	if (plyLvl ~= oldLVL) then
		//self:UpdateSkin()
		oldLVL = plyLvl
	end

	if (curXP > zrmine.config.Pickaxe_Lvl[plyLvl].NextXP) then
		curXP = zrmine.config.Pickaxe_Lvl[plyLvl].NextXP
	end

	draw.RoundedBox(2.5, ScrW() / 2.495 + OF_X, ScrH() / 1.097 + OF_Y, ScrW() / 5, ScrH() / 75, bgColor)

	if (plyLvl < (table.Count(zrmine.config.Pickaxe_Lvl) - 1)) then

		xpInfo = self:GetPlayerXP() .. " / " .. zrmine.config.Pickaxe_Lvl[plyLvl].NextXP .. " XP"
		draw.RoundedBox(2.5, ScrW() / 2.49 + OF_X, ScrH() / 1.096 + OF_Y, ScrW() / xpCap * curXP, ScrH() / 90, zrmine.default_colors["blue01"])
	else
		xpInfo = "Max"
		draw.RoundedBox(2.5, ScrW() / 2.49 + OF_X, ScrH() / 1.096 + OF_Y, ScrW() / 5.05, ScrH() / 90, zrmine.default_colors["orange01"])
	end

	surface.SetDrawColor(zrmine.default_colors["white04"])
	surface.SetMaterial(zrmine.default_materials["XPBar"])
	surface.DrawTexturedRect(ScrW() / 2.49 + OF_X, ScrH() / 1.096 + OF_Y, ScrW() / 5.05, ScrH() / 90)
	draw.NoTexture()
	draw.DrawText(xpInfo, "zrmine_pickaxe_font4", ScrW() / 2 + OF_X, ScrH() / 1.1 + OF_Y, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)

	// XP Update Animation
	if (oldXP ~= curXP) then
		diffXP = curXP - oldXP
		oldXP = curXP
		UpdateXpAnimation = true
	end

	if (UpdateXpAnimation) then
		UpdateXP_x = UpdateXP_x + 2
		local progress = 1 / 125 * UpdateXP_x
		local c = zrmine.default_colors["white02"]

		if (diffXP < 0) then
			c = zrmine.f.LerpColor(progress, zrmine.default_colors["red03"], zrmine.default_colors["red04"])
			draw.DrawText(diffXP, "zrmine_pickaxe_font2", ScrW() / 2 + UpdateXP_x + OF_X, ScrH() / 1.102 + OF_Y, c, TEXT_ALIGN_CENTER)
		else
			c = zrmine.f.LerpColor(progress, zrmine.default_colors["green02"], zrmine.default_colors["green03"])
			draw.DrawText("+" .. diffXP, "zrmine_pickaxe_font2", ScrW() / 2 + UpdateXP_x + OF_X, ScrH() / 1.102 + OF_Y, c, TEXT_ALIGN_CENTER)
		end

		if (UpdateXP_x > 125) then
			UpdateXpAnimation = false
			UpdateXP_x = 0
			UpdateXP_alpha = 255
		end
	end

	self:DrawResourceItem(self:GetIron(), zrmine.default_colors["Iron"], 0, -ScrH() / 175)
	self:DrawResourceItem(self:GetBronze(), zrmine.default_colors["Bronze"], ScrW() / 24.7, -ScrH() / 175)
	self:DrawResourceItem(self:GetSilver(), zrmine.default_colors["Silver"], ScrW() / 12.37, -ScrH() / 175)
	self:DrawResourceItem(self:GetGold(), zrmine.default_colors["Gold"], ScrW() / 8.238, -ScrH() / 175)
	self:DrawResourceItem(self:GetCoal(), zrmine.default_colors["Coal"] , ScrW() / 6.18, -ScrH() / 175)

	// [[Instructions]]
	if (self.Instructions and GetConVar("zrms_cl_pickaxe_help"):GetInt() == 1) then
		draw.SimpleTextOutlined(self.Instructions, "zrmine_pickaxe_font3", ScrW() / 2, ScrH() / 45, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, zrmine.default_colors["black05"])
	end



	// CoolDown
	draw.RoundedBox(2.5, ScrW() / 2.5 + OF_X, ScrH() / 1.153 + OF_Y, ScrW() / 5, ScrH() / 25, bgColor)
	local cd = self:GetCoolDown() - CurTime()

	if (cd > 0) then
		local barMax = 5.1 * self:GetNextCoolDown()
		barMax = ScrW() / barMax

		barMax = barMax * cd
		barMax = math.Clamp(barMax,0,ScrW() / 5.1)

		draw.RoundedBox(2.5, ScrW() / 2.487 + OF_X, ScrH() / 1.15 + OF_Y, barMax, ScrH() / 28, zrmine.f.LerpColor((1 / self:GetNextCoolDown()) * cd, zrmine.default_colors["green04"], zrmine.default_colors["red05"]))
	else
		self:SetCoolDown(-1)
	end

	draw.SimpleTextOutlined(self.PrintName .. " - Level: " .. plyLvl, "zrmine_pickaxe_font1", ScrW() / 2 + OF_X, ScrH() / 1.11 + OF_Y, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, zrmine.default_colors["black05"])
end

function SWEP:DrawResourceItem(Info, color, xpos, ypos)
	local bgColor = zrmine.default_colors["white04"]

	if (zrmine.config.PickaxeThemeLight) then
		bgColor = zrmine.default_colors["white04"]
	else
		bgColor = zrmine.default_colors["black01"]
	end

	draw.RoundedBox(5, (ScrW() / 2.495 + OF_X + xpos) + mainOffsetX, ScrH() / 1.053 + OF_Y + ypos, ScrW() / 26, ScrH() / 20, bgColor)
	surface.SetDrawColor(color)
	surface.SetMaterial(zrmine.default_materials["Ore"])
	surface.DrawTexturedRect((ScrW() / 2.5 + OF_X + xpos) + mainOffsetX, ScrH() / 1.067 + OF_Y + ypos, ScrW() / 25, ScrH() / 13)
	draw.NoTexture()

	draw.DrawText(math.Round(Info, 1), "zrmine_pickaxe_font2", (ScrW() / 2.38 + OF_X + xpos) + mainOffsetX, ScrH() / 1.035 + OF_Y + ypos, zrmine.default_colors["white02"], TEXT_ALIGN_CENTER)
	surface.SetDrawColor(zrmine.default_colors["white03"])
	surface.SetMaterial(zrmine.default_materials["ShineIcon"])
	surface.DrawTexturedRect((ScrW() / 2.507 + OF_X + xpos) + mainOffsetX, ScrH() / 1.054 + OF_Y + ypos, ScrW() / 23, ScrH() / 18.4)
	draw.NoTexture()
end



local vmAnims = {ACT_VM_HITCENTER, ACT_VM_HITKILL}
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	local trEnt = tr.Entity

	if ((self:GetCoolDown() - CurTime()) < 0) then
		if (IsValid(trEnt) and trEnt:GetClass() == "zrms_ore") then

			if zrmine.f.InDistance(self.Owner:GetPos(), trEnt:GetPos(), 100) then
				if (not zrmine.f.Pickaxe_HasStorageSpace(self)) then return end
				if (trEnt:GetResourceAmount() <= 0) then return end
				self:SendWeaponAnim(vmAnims[math.random(#vmAnims)])
				self.Owner:SetAnimation(PLAYER_ATTACK1)
			end
		else
			self:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	end
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTrace()
	local trEnt = tr.Entity

	if (IsValid(trEnt) and (trEnt:GetClass() == "zrms_crusher" or trEnt:GetClass() == "zrms_gravelcrate") and zrmine.f.InDistance(self.Owner:GetPos(), trEnt:GetPos(), 100) and (self:GetCoolDown() - CurTime()) < 0) then
		if ((self.lastHit or CurTime()) > CurTime()) then return end
		self.lastHit = CurTime() + 1
		self.Owner:DoAttackEvent()
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Holster()
	self:SendWeaponAnim(ACT_VM_HOLSTER)
end

//Tells the script what to do when the player "Initializes" the SWEP.
function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW) // View model animation
	self.Owner:SetAnimation(PLAYER_IDLE) // 3rd Person Animation
end
