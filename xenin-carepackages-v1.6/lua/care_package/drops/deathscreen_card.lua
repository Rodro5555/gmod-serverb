local DROP = CarePackage:CreateDrop()
DROP.InventoryEnabled = false
DROP.Skins = {}
DROP.EquipName = function()
	return CarePackage:GetPhrase("Drops.Money.Loot")
end

function DROP:CanLoot(ent, ply, type)
	if (!XeninDS) then return false, "Xenin Deathscreen not installed" end
	local controller = ply:XeninDeathscreen()
	if (controller:getCard(ent)) then return false, "You already own that card" end

	return true
end

function DROP:Loot(ent, ply, type)
	local controller = ply:XeninDeathscreen()
	controller:addCard(ent)

	if (SERVER) then
		controller:saveCard(ent)
	end
end

function DROP:GetName(ent)
	if (!XeninDS) then return "Xenin Deathscreen not installed" end
	local card = XeninDS.Config:getCard(ent)
	if (!card) then return "Invalid Card ID [" .. ent .. "]" end

	return card.name .. " deathscreen card"
end

function DROP:CustomPanel(panel, reward)
  if (!XeninDS) then
    panel.Model = panel:Add("Panel")

    return
  end
  local card = XeninDS.Config:getCard(reward)
  if (!card) then
    panel.Model = panel:Add("Panel")

    return
  end
  local animated = card.animatedSrc
  panel.Model = panel:Add("Panel")
  panel.Model:Dock(FILL)
  panel.Model:SetZPos(1)
  panel.Model:DockMargin(1, 65, 1, 1)
  panel.Model:SetMouseInputEnabled(false)

  if (animated) then
    panel.Model.Animated = panel.Model:Add("XeninUI.AnimatedTexture")
    panel.Model.Animated:SetTimes(card.times.normal or 0.05, card.times.idle or 0.05)
    panel.Model.Animated:SetImages(card.animatedSrc)
    panel.Model.Animated:PostInit()
    local oldPaint = panel.Model.Animated.Paint
    panel.Model.Animated.Paint = function(pnl, w, h)
      XeninUI:Mask(function()
        XeninUI:DrawRoundedBoxEx(6, 0, 0, w, h, color_white, false, false, true, true)
      end, function()
        oldPaint(pnl, w, h)
      end)
    end

    panel.Model.PerformLayout = function(pnl, w, h)
      local width = w - 16
      local height = width / 4
      local y = h / 2 - height / 2

      pnl.Animated:SetPos(8, y)
      pnl.Animated:SetSize(width, height)
    end
  else
    XeninUI:DownloadIcon(panel.Model, card.src)
    panel.Model.Paint = function(pnl, w, h)
      XeninUI:Mask(function()
        XeninUI:DrawRoundedBox(6, 8, 8, w - 16, h - 16, color_white)
      end, function()
        -- The reason we do this is we don't actually need to start the download of an icon before it's used first time (lazyloading)
        if (pnl.Icon) then
          local width = w - 16
          local height = width / 4
          local y = h / 2 - height / 2

          XeninUI:DrawIcon(8, y, width, height, pnl)
        else
          XeninUI:DownloadIcon(pnl, tbl.src)
        end
      end)
    end
  end
end


function DROP:GetModel(ent)
	return ".mdl"
end

function DROP:GetData(ent)
	return {}
end

function DROP:GetColor(ent)
	if (self.Options.Color) then return self.Options.Color end

	return CarePackage.Config.DefaultItemColor
end

DROP:Register("DeathscreenCard")