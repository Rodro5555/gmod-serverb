--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]
Realistic_Properties.Notify = Realistic_Properties.Notify or {} 
Kobralost = Kobralost or {}
Kobralost.NotifyTable = Kobralost.NotifyTable or {}

function Realistic_Properties.SendNotify(msg, time)
    if Realistic_Properties.UseCustomNotify then
        Kobralost.NotifyTable[#Kobralost.NotifyTable + 1] = {
            ["Message"] = msg,
            ["Time"] = CurTime() + (time or 5), 
            ["Color1"] = Realistic_Properties.Colors["black41200"], 
            ["Color2"] = Realistic_Properties.Colors["blue41200"], 
            ["Material"] = "rps_materials3.png", 
            ["Font"] = "rps_notify_14",
        }
    else
        notification.AddLegacy(msg, 1, 5)
    end
end 

hook.Add("DrawOverlay", "RPT:DrawOverlay", function()
    if Kobralost.NotifyTable && #Kobralost.NotifyTable > 0 then 
        for k,v in pairs(Kobralost.NotifyTable) do 
            if not isnumber(v.RLerp) then v.RLerp = -(ScrW()*0.25 + #v.Message*ScrW()*0.0057) end 

            if v.Time > CurTime() then 
                v.RLerp = math.Round(Lerp(3*FrameTime(), v.RLerp, ScrW()*0.03))
            else 
                v.RLerp = math.Round(Lerp(3*FrameTime(), v.RLerp, -(ScrW()*0.25 + #v.Message*ScrW()*0.0057+ScrW()*0.032)))
                if v.RLerp < -(ScrW()*0.1 + #v.Message*ScrW()*0.0057+ScrW()*0.032) then Kobralost.NotifyTable[k] = nil Kobralost.NotifyTable = table.ClearKeys( Kobralost.NotifyTable ) end 
            end 
            
            draw.RoundedBox(4, v.RLerp, (ScrH()*0.055*k)-ScrH()*0.038, #v.Message*ScrW()*0.0055+ScrW()*0.032, ScrH()*0.043, v.Color1)
            draw.RoundedBox(4, v.RLerp, (ScrH()*0.055*k)-ScrH()*0.038, ScrH()*0.043, ScrH()*0.043, v.Color2)

            surface.SetDrawColor( Realistic_Properties.Colors["white240"] )
            surface.SetMaterial( Material(v.Material) )
		    surface.DrawTexturedRect( v.RLerp + ScrW()*0.001, (ScrH()*0.055*k)-ScrH()*0.0365, ScrH()*0.04, ScrH()*0.04 )

            draw.SimpleText(v.Message, v.Font, v.RLerp+ScrW()*0.03, (ScrH()*0.055*k) + ScrH()*0.043/2-ScrH()*0.038, Realistic_Properties.Colors["white240"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
    end 
end ) 

net.Receive("RealisticProperties:Notify", function()
	local msg = net.ReadString() or ""
	Realistic_Properties.SendNotify(msg, 5)
end )
