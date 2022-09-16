--[[
This code was generated by LAUX, a Lua transpiler
LAUX is a fork of LAU with additional changes.

More info & source code can be found at: https://gitlab.com/sleeppyy/laux
]]

local ITEM = XeninInventory:CreateItem()
ITEM.Hover = "XeninInventory.Shipment.Hover"
ITEM.MaxStack = 1
ITEM.UseDataAmount = true

ITEM:AddAction("Equip", 1, function(self, ply, ent, tbl)
  if CLIENT then return end
  tbl.data = tbl.data or {}

  local ship = CustomShipments[tbl.data.Contents or tbl.data.contents]
  ply:Give(ship.entity)
  ply:SelectWeapon(ship.entity)
end, function(self, ply, tbl)
  tbl.data = tbl.data or {}
  local ship = CustomShipments[tbl.data.Contents or tbl.data.contents]
  if (!ship) then return false, "The shipment seems to have been removed?"end

  return !ply:HasWeapon(ship.entity), "You already have that weapon equipped"
end)

ITEM:AddAction("Drop Amount", 2, function(self, ply, ent, tbl, amt)
  local trace = {}
  trace.start = ply:EyePos()
  trace.endpos = trace.start + ply:GetAimVector() * 85
  trace.filter = ply

  local tr = util.TraceLine(trace)
  local weapon = ents.Create("spawned_shipment")
  local model = self:GetModel(tbl.ent)
  weapon:Setcontents(tbl.data.Contents or tbl.data.contents)
  weapon:Setcount(amt or 1)
  weapon:SetPos(tr.HitPos)
  weapon.ammoadd = weapons.Get(ent) and weapons.Get(ent).Primary.DefaultClip

  weapon:Spawn()
end)

ITEM:AddAction("Drop All", 3, function(self, ply, ent, tbl)
  local trace = {}
  trace.start = ply:EyePos()
  trace.endpos = trace.start + ply:GetAimVector() * 85
  trace.filter = ply

  tbl.data = tbl.data or {}
  local tr = util.TraceLine(trace)
  local weapon = ents.Create("spawned_shipment")
  local model = self:GetModel(tbl.ent)
  weapon:Setcontents(tbl.data.Contents or tbl.data.contents)
  weapon:Setcount(tbl.data.Amount or tbl.data.amount or 1)
  weapon:SetPos(tr.HitPos)
  weapon.ammoadd = weapons.Get(ent) and weapons.Get(ent).Primary.DefaultClip

  weapon:Spawn()
end)

function ITEM:GetName(ent)
  if istable(ent) then ent = ent.ent end

  local tbl = {}
  if isentity(ent) then
    local shipment = CustomShipments[ent:Getcontents()]
    if shipment then
      local name = shipment.name or shipment.Name or shipment.Display or shipment.DisplayName or shipment.nick or shipment.Nick

      if name then
        return name .. " shipment"
      end

      return "Unknown shipment name"
    end

    return "Unknown shipment name"
  else
    tbl = weapons.Get(ent)
    if (!tbl) then return ent end
  end

  return (tbl.PrintName or ent) .. " shipment"
end

function ITEM:GetItem(ent)
  return ent
end

function ITEM:GetVisualAmount(tbl)
  if (!tbl) then return end

  return tbl.data and (tbl.data.amount or tbl.data.Amount or 0) or 0
end

function ITEM:GetData(ent)
  return {
    amount = ent:Getcount(),
    contents = ent:Getcontents()
  }
end

function ITEM:OnPickup(ply, ent)
  if (!IsValid(ent)) then return end

  local tbl = CustomShipments[ent:Getcontents()]

  local info = {
    ent = tbl.entity,
    dropEnt = ent:GetClass(),
    amount = 1,
    data = self:GetData(ent)
  }
  self:Pickup(ply, ent, info)

  return true
end

ITEM:Register("spawned_shipment")

if CLIENT then
  local PANEL = {}

  function PANEL:SetInfo(tbl)
    self.Alpha = 0
    self:LerpAlpha(255, 0.15)

    local item = XeninInventory:GetItem(tbl.dropEnt)
    local name = item and item:GetName(tbl)
    local data = tbl.data
    local rarity = XeninInventory:GetRarity(tbl)

    self.wepTbl = weapons.Get(tbl.ent)
    self.title = name
    self.rarity = rarity
    self.data = data
    local tbl = XeninInventory.Config.Categories[rarity]
    if tbl then

      self.tbl = tbl
    end
  end

  function PANEL:Paint(w, h)
    local aX, aY = self:LocalToScreen()
    BSHADOWS.BeginShadow()
    draw.RoundedBox(6, aX, aY, w, h, XeninUI.Theme.Primary)
    BSHADOWS.EndShadow(1, 2, 2)

    local y = 8
    draw.SimpleText(self.title, "XeninInventory.Hover.Title", 9, 9, Color(0, 0, 0, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self.title, "XeninInventory.Hover.Title", 8, 8, self.tbl and self.tbl.color or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.SimpleText(XeninInventory:GetPhrase("XeninInventory.Shipment.Desc", {
    amount = self.data.amount }), "XeninInventory.Hover.Subtitle", 8, 8 + draw.GetFontHeight("XeninInventory.Hover.Title"), Color(202, 202, 202), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
  end

  function PANEL:PerformLayout(w, h)
    surface.SetFont("XeninInventory.Hover.Title")
    local tw, th = surface.GetTextSize(self.title or "")
    local width = tw + 16
    local height = 16 + th + draw.GetFontHeight("XeninInventory.Hover.Title") - 2

    self:SetSize(width, height)
  end

  vgui.Register("XeninInventory.Shipment.Hover", PANEL)
end