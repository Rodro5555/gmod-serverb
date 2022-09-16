if (not CLIENT) then return end
zrush = zrush or {}
zrush.Machinecrate = zrush.Machinecrate or {}

function zrush.Machinecrate.Draw(Machinecrate)
    if zclib.Convar.Get("zclib_cl_drawui") == 1 and zclib.util.InDistance(LocalPlayer():GetPos(), Machinecrate:GetPos(), 500) then
        zrush.Machinecrate.DrawInfo(Machinecrate)
    end
end

local l_pos = Vector(-9, 0, 5)
local l_ang = Angle(0, -90, 90)
// Draws the 2d3d ui on whats inside the crate
function zrush.Machinecrate.DrawInfo(Machinecrate)
    cam.Start3D2D(Machinecrate:LocalToWorld(l_pos), Machinecrate:LocalToWorldAngles(l_ang), 0.1)
        local mId = Machinecrate:GetMachineID()
        local text

        if mId > 0 then
            surface.SetDrawColor(zrush.default_colors["white03"])
            surface.SetMaterial(zrush.Machine.GetIcon(mId))
            surface.DrawTexturedRect(-120, -73, 240, 240)
            text = zrush.Machine.GetName(mId)
        else
            text = zrush.language["BuyMachine"]
        end

        draw.RoundedBox(25, -200, -60, 400, 70, zrush.default_colors["black02"])
        draw.DrawText(text, zclib.GetFont("zrush_machinecrate_font01"), 0, -60, color_white, TEXT_ALIGN_CENTER)

        if (Machinecrate.InstalledModules and table.Count(Machinecrate.InstalledModules) > 0) then
            draw.RoundedBox(25, -200, 45, 400, 100, zrush.default_colors["black02"])

            for k, v in pairs(Machinecrate.InstalledModules) do
                if v <= 0 then continue end
                zrush.Modules.DrawSimple(v, 90, 90, -295 + (100 * k), 50)
            end
        end
    cam.End3D2D()
end

// Starts the client side zclib pointer system to determine where the player wants to build the machine
function zrush.Machinecrate.Place(Machinecrate)

    Machinecrate:EmitSound("zrush_sfx_drill_loadpipe")

    zclib.PointerSystem.Start(Machinecrate,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]

        zclib.PointerSystem.Data.ActionName = zrush.language["BuildEntity"]
        zclib.PointerSystem.Data.CancelName = zrush.language["Cancel"]

        zclib.PointerSystem.Data.Machinecrate = Machinecrate
        zclib.PointerSystem.Data.MachineID = Machinecrate:GetMachineID()

        // Overwride model if we got a EquipmentID
        zclib.PointerSystem.Data.ModelOverwrite = zrush.Machine.GetModel(Machinecrate:GetMachineID())
    end,function()

        // Can we build here?
        if zclib.PointerSystem.Data.CanPlace ~= true then
            return
        end

        // Position detection done, send info to server and wait for further instructions
        net.Start("zrush_Machinecrate_Build")
        net.WriteEntity(Machinecrate)
        net.SendToServer()

        zclib.PointerSystem.Stop()
    end,function()

        // MainLogic
        local canBuild,buildPos , buildAng = zrush.Machinecrate.CanBuild(LocalPlayer(), zclib.PointerSystem.Data.MachineID, zclib.PointerSystem.Data.Machinecrate)

        zclib.PointerSystem.Data.CanPlace = canBuild

        if buildPos then
            zclib.PointerSystem.Data.Pos = buildPos
        end

        if buildAng then
            zclib.PointerSystem.Data.Ang = buildAng
        end

        // Change the main color depening if we found a valid building pos
        if zclib.PointerSystem.Data.CanPlace then
            zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]
        else
            zclib.PointerSystem.Data.MainColor = zclib.colors["red01"]
        end

        // Update PreviewModel
        if IsValid(zclib.PointerSystem.Data.PreviewModel) then

            if zclib.PointerSystem.Data.MachineID == ZRUSH_PUMP then
                zclib.PointerSystem.Data.PreviewModel:SetBodygroup(0, 1)
                zclib.PointerSystem.Data.PreviewModel:SetBodygroup(1, 1)
                zclib.PointerSystem.Data.PreviewModel:SetBodygroup(3, 1)
                zclib.PointerSystem.Data.PreviewModel:SetBodygroup(5, 1)
                zclib.PointerSystem.Data.PreviewModel:SetBodygroup(2, 1)
                zclib.PointerSystem.Data.PreviewModel:SetBodygroup(4, 1)
            end

            zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.ModelOverwrite)
            zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
            zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Ang)
            zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
        end
    end, function()
        // HUD Logic
    end,function()
        // Right Click
        LocalPlayer():EmitSound("zrush_sfx_deconnect")
    end)
end

// This gets called from then machine options box to inform the player what modules are inside it
net.Receive("zrush_MachineCrate_AddModules", function(len, ply)
    local ent = net.ReadEntity()
    local mTable = net.ReadTable()

    if IsValid(ent) then
        ent.InstalledModules = {}
        table.CopyFromTo(mTable, ent.InstalledModules)
    end
end)
