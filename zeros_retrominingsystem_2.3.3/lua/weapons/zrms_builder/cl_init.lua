include("shared.lua")
include("zrmine_config.lua")

SWEP.PrintName = "Builder" // The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true // Do you want the SWEP to have a crosshair?

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080


local iconSize01 = 120
local iconSize02 = 100
local iconSize03 = 130

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.LastItem = -1
end

function SWEP:DrawHUD()

	//draw.RoundedBox(5, 560 * wMod , 1027 * hMod , 800 * wMod, 45 * hMod, zrmine.default_colors["Gold"])

	draw.RoundedBox(5, 560 * wMod , 1027 * hMod , 235 * wMod, 45 * hMod, zrmine.default_colors["grey03"])
	draw.RoundedBox(5, 800 * wMod , 1027 * hMod , 320 * wMod, 45 * hMod, zrmine.default_colors["grey03"])
	draw.RoundedBox(5, 1125 * wMod , 1027 * hMod , 235 * wMod, 45 * hMod, zrmine.default_colors["grey03"])


	draw.RoundedBox(5, 563 * wMod , 1029 * hMod , 230 * wMod, 41 * hMod, zrmine.default_colors["grey07"])
	draw.RoundedBox(5, 803 * wMod , 1029 * hMod , 315 * wMod, 41 * hMod, zrmine.default_colors["grey07"])
	draw.RoundedBox(5, 1128 * wMod , 1029 * hMod , 230 * wMod, 41 * hMod, zrmine.default_colors["grey07"])




	// Shawdow
	local lKey = string.upper(language.GetPhrase(input.GetKeyName(zrmine.config.BuilderSWEP.keys.switch_left)))
	local rKey = string.upper(language.GetPhrase(input.GetKeyName(zrmine.config.BuilderSWEP.keys.switch_right)))

	draw.SimpleText("LMB: " .. zrmine.language.Buy, "zrmine_builder_font1_shadow", 675 * wMod, 1065 * hMod, zrmine.default_colors["black02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("◀ [ " .. lKey .. " ] " .. zrmine.language.SwitchItem .. " [ " .. rKey .. " ] ▶", "zrmine_builder_font1_shadow", 960 * wMod, 1065 * hMod, zrmine.default_colors["black02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("RMB: " .. zrmine.language.Sell, "zrmine_builder_font1_shadow", 1243 * wMod, 1065 * hMod, zrmine.default_colors["black02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)


	// Main text
	draw.SimpleText("LMB: " .. zrmine.language.Buy, "zrmine_builder_font1", 675 * wMod, 1065 * hMod, zrmine.default_colors["grey03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("◀ [ " .. lKey .. " ] " .. zrmine.language.SwitchItem .. " [ " .. rKey .. " ] ▶", "zrmine_builder_font1", 960 * wMod, 1065 * hMod, zrmine.default_colors["grey03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText("RMB: " .. zrmine.language.Sell, "zrmine_builder_font1", 1243 * wMod, 1065 * hMod, zrmine.default_colors["grey03"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)


	local c_selectedItem = self:GetItemSelected()

	draw.SimpleTextOutlined("Construir", "zrmine_pickaxe_font1", 959 * wMod, 850 * hMod, zrmine.default_colors["yellow02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, zrmine.default_colors["brown01"])
	draw.SimpleTextOutlined(zrmine.Swep_BuildItems[c_selectedItem].name, "zrmine_pickaxe_font1", 959 * wMod, 875 * hMod, zrmine.default_colors["yellow02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, zrmine.default_colors["brown01"])

	// Makes a click sound
	if self.LastItem ~= c_selectedItem then
		surface.PlaySound("UI/buttonclick.wav")
		self.LastItem = c_selectedItem
	end

	local p_selectedItem = c_selectedItem - 1
	if p_selectedItem <= 0 then
		p_selectedItem = table.Count(zrmine.Swep_BuildItems)
	end

	local pp_selectedItem = p_selectedItem - 1
	if pp_selectedItem <= 0 then
		pp_selectedItem = table.Count(zrmine.Swep_BuildItems)
	end

	local n_selectedItem = c_selectedItem + 1
	if n_selectedItem > table.Count(zrmine.Swep_BuildItems) then
		n_selectedItem = 1
	end

	local nn_selectedItem = n_selectedItem + 1
	if nn_selectedItem > table.Count(zrmine.Swep_BuildItems) then
		nn_selectedItem = 1
	end


	draw.RoundedBox(5, (960 - iconSize03 / 2) * wMod, (949 - iconSize03 / 2) * hMod, iconSize03 * wMod, iconSize03 * hMod, zrmine.default_colors["orange03"])


	// Mid
	surface.SetDrawColor(zrmine.default_colors["white02"])
	surface.SetMaterial(zrmine.Swep_BuildItems[c_selectedItem].icon)
	surface.DrawTexturedRect((960 - iconSize01 / 2) * wMod, (950 - iconSize01 / 2) * hMod, iconSize01 * wMod, iconSize01 * hMod)
	draw.NoTexture()

	local itemData = zrmine.Swep_BuildItems[c_selectedItem]
	draw.SimpleTextOutlined(zrmine.config.Currency .. zrmine.config.BuilderSWEP.entity_price[itemData.class], "zrmine_pickaxe_font1", 960 * wMod, 1005 * hMod, zrmine.default_colors["money01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, zrmine.default_colors["money02"])


	// Pre
	surface.SetDrawColor(zrmine.default_colors["grey06"])
	surface.SetMaterial(zrmine.Swep_BuildItems[p_selectedItem].icon)
	surface.DrawTexturedRect(((960 - 150) - iconSize02 / 2) * wMod, (950 - iconSize02 / 2) * hMod, iconSize02 * wMod, iconSize02 * hMod)
	draw.NoTexture()

	//PrePre
	surface.SetDrawColor(zrmine.default_colors["grey06"])
	surface.SetMaterial(zrmine.Swep_BuildItems[pp_selectedItem].icon)
	surface.DrawTexturedRect(((960 - 300) - iconSize02 / 2) * wMod, (950 - iconSize02 / 2) * hMod, iconSize02 * wMod, iconSize02 * hMod)
	draw.NoTexture()



	// Next
	surface.SetDrawColor(zrmine.default_colors["grey06"])
	surface.SetMaterial(zrmine.Swep_BuildItems[n_selectedItem].icon)
	surface.DrawTexturedRect(((960 + 150) - iconSize02 / 2) * wMod, (950 - iconSize02 / 2) * hMod, iconSize02 * wMod, iconSize02 * hMod)
	draw.NoTexture()


	// NextNext
	surface.SetDrawColor(zrmine.default_colors["grey06"])
	surface.SetMaterial(zrmine.Swep_BuildItems[nn_selectedItem].icon)
	surface.DrawTexturedRect(((960 + 300) - iconSize02 / 2) * wMod, (950 - iconSize02 / 2) * hMod, iconSize02 * wMod, iconSize02 * hMod)
	draw.NoTexture()
end

// Build Entity
function SWEP:PrimaryAttack()
	self:SendWeaponAnim(ACT_SLAM_THROW_TO_STICKWALL)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

// Deconstruct Entity
function SWEP:SecondaryAttack()
	self:SendWeaponAnim(ACT_SLAM_THROW_DETONATE)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

// Switch Item to build
function SWEP:Reload()
	self:SendWeaponAnim(ACT_VM_RELOAD)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
end

function SWEP:Holster()
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_HOLSTER)

end

function SWEP:Equip()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:SetAnimation(PLAYER_IDLE)
end
