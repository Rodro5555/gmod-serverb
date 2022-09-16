--[[

 _____           _ _     _   _          _    _                 _            _   _             // 3761c9d3d6e27c207d6e8d3428ec169c47c15a367b9bfecc7d3599aa22b40db0
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   


--]] 

local RealisticWoodCutterImgui = include("realistic_woodcutter/client/cl_realistic_woodcutter_imgui.lua")
local RealisticWoodCutterMeta = FindMetaTable("Entity")

net.Receive("RealisticWoodCutter:UpdateVar",function()
   	local tbl = net.ReadTable() or {}
	if not istable(tbl[3].TableCustomVar) then tbl[3].TableCustomVar = {} end

    tbl[3].TableCustomVar[tbl[1]] = tbl[2]
 end)

function RealisticWoodCutterMeta:GetRWCCustomVar(id)
    if !self.TableCustomVar then return 0 end 
    return self.TableCustomVar[id] or 0
end

hook.Add("PostDrawTranslucentRenderables", "Paint3D2DUIpdva", function(bDrawingSkybox, bDrawingDepth)	
	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 100)) do
		if v:IsVehicle() then
			if v:GetOwner() == LocalPlayer() or v:CPPIGetOwner() == LocalPlayer() && Realistic_Woodcutter.JobTable[team.GetName(LocalPlayer():Team())] then 
				if v:GetNWVector("rwc_vector") != Vector(0,0,0) then 
					if v:GetPos():Distance(LocalPlayer():GetPos()) < 2000 then
						if RealisticWoodCutterImgui.Start3D2D(v:LocalToWorld(v:GetNWVector("rwc_vector")), v:LocalToWorldAngles(v:GetNWVector("rwc_angle") + Angle(-90,-90,90)), 0.1, 200, 150) then
							surface.SetDrawColor(Realistic_Woodcutter.Colors["lightgrey"])
							surface.DrawRect(0, 0, 195, 75)				
							if RealisticWoodCutterImgui.xTextButton(Realistic_Woodcutter.GetSentence("takeObject"), "!Roboto@24", 10, 10, 175, 25) then
								net.Start("RealisticWoodCutter:VehicleProps")
								net.SendToServer()
							end
							
							if v:GetRWCCustomVar(4) > 0 then
								stock = v:GetRWCCustomVar(4)
								stock_max = v:GetRWCCustomVar(9)
							elseif v:GetRWCCustomVar(1) > 0 then
								stock = v:GetRWCCustomVar(1)
								stock_max = v:GetRWCCustomVar(6)
							elseif v:GetRWCCustomVar(2) > 0 then
								stock = v:GetRWCCustomVar(2)
								stock_max = v:GetRWCCustomVar(7)
							elseif v:GetRWCCustomVar(3) > 0 then
								stock = v:GetRWCCustomVar(3)
								stock_max = v:GetRWCCustomVar(8)
							elseif v:GetRWCCustomVar(5) > 0 then
								stock = v:GetRWCCustomVar(5)
								stock_max = v:GetRWCCustomVar(10)
							else
								stock = 0
								stock_max = 0
							end
							draw.SimpleText(Realistic_Woodcutter.GetSentence("stock").." "..stock.."/"..stock_max,"Trebuchet24",97.5,60,Realistic_Woodcutter.Colors["white"],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
							RealisticWoodCutterImgui.End3D2D()
						end
					end 
				end
			end 
		end 
    end
end)