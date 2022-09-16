TOOL.Category = "Admin Tools"
TOOL.Name = "Care Package"
TOOL.Command = nil
TOOL.ConfigName =""
TOOL.LastFire = 0

if (CLIENT) then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
    { name = "reload" }
	}

	language.Add("tool.xenin_cp.left", "Add spawn")
	language.Add("tool.xenin_cp.right", "Delete the spawn you are looking at")
  language.Add("tool.xenin_cp.reload", "Delete all spawns")
  language.Add("tool.xenin_cp.name", "Xenin Care Packages - Spawn Points")
  language.Add("tool.xenin_cp.desc", "Add and remove spawn points")
end

function TOOL:LeftClick(tr)
  if (CLIENT) then
    local ply = LocalPlayer()

		if (!CarePackage.Config.IsAdmin(ply)) then 
			chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, color_white, CarePackage:GetPhrase("Tool.NotAdmin"))

			return false
		end

    if (CurTime() > self.LastFire) then
      local pos = tr.HitPos
      local ang = Angle(0, 0, 0)

      local skyboxTrace = util.QuickTrace(pos, Vector(pos.x, pos.y, pos.z + 99999))
      local hitSky = skyboxTrace.HitSky

      if (pos:Distance(skyboxTrace.HitPos) < 100) then
        chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, XeninUI.Theme.Red, "[ERROR] ", color_white, CarePackage:GetPhrase("Tool.TooClose"))

        self.LastFire = CurTime() + 0.1

        return false
      end

      if (!hitSky) then
        chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, XeninUI.Theme.Red, "[ERROR] ", color_white, CarePackage:GetPhrase("Tool.Blocked"))

        self.LastFire = CurTime() + 0.1

        return false
      end

      CarePackage:AddSpawn(tr.HitPos, ang, skyboxTrace.HitPos)

      self.LastFire = CurTime() + 0.1
    end
  end

  return true
end

function TOOL:RightClick(tr)
  if (CLIENT) then
    local ply = LocalPlayer()
    
		if (!CarePackage.Config.IsAdmin(ply)) then 
			chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, color_white, CarePackage:GetPhrase("Tool.NotAdmin"))

			return false
		end

    if (CurTime() > self.LastFire) then
      local pos = tr.HitPos

      local match

			for i, v in pairs(CarePackage:GetSpawns()) do
        local startPos = v.pos - Vector(18, 17, 15)
        local endPos = v.pos + Vector(17, 18, 25)

        if (!pos:WithinAABox(startPos, endPos)) then continue end

        match = i

        break
      end

      if (match) then
        CarePackage:DeleteSpawn(match)
      end
      
      self.LastFire = CurTime() + 0.2
    end
  end

  return true
end

function TOOL:Reload()
  if (CLIENT) then
    local ply = LocalPlayer()
    
    if (!CarePackage.Config.IsAdmin(ply)) then 
      chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, color_white, CarePackage:GetPhrase("Tool.NotAdmin"))

      return false
    end

    if (CurTime() > self.LastFire) then
      if (#CarePackage.Spawns > 0) then
        chat.AddText(CarePackage.Config.ThemeColor, CarePackage.Config.ThemeText, color_white, CarePackage:GetPhrase("Tool.DeletedAll", { amount = #CarePackage.Spawns } ))
        CarePackage:DeleteAllSpawns()
      end

      self.LastFire = CurTime() + 0.2
    end
  end

  return true
end

local function Render()
  for i, v in pairs(CarePackage:GetSpawns()) do
    render.SetColorMaterial()
    render.DrawBox(v.pos, v.ang or Angle(0, 0, 0), Vector(-18, -17, 0), Vector(17, 18, 20), Color(255, 0, 0, 200))
  end
end

function TOOL:Think()
  if (CLIENT) then
    if (table.Count(CarePackage:GetSpawns()) == 0 and !self.Requested) then
      net.Start("CarePackage.Saving.Get")
      net.SendToServer()

      self.Requested = true
    end

    local ply = LocalPlayer()

    hook.Add("PostDrawTranslucentRenderables", "CarePackage.SpawnPoints", Render)
  end
end

function TOOL:Holster()
  if (CLIENT) then
    hook.Remove("PostDrawTranslucentRenderables", "CarePackage.SpawnPoints")
  end
end