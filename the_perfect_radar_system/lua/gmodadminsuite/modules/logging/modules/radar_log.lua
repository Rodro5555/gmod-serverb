local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Radar System"
MODULE.Name     = "Radar "
MODULE.Colour   = Color(10, 10, 210)

MODULE:Setup(function()
    MODULE:Hook("TPRSA:InfractionHook","TPRSA:InfractionHook:Logs", function(caughtply, ply, entity, veh, speed, speedlim, realfineprice, finebudget)
        if not IsValid(caughtply) or not IsValid(veh) then return end
        local taker = ""
        if IsValid(ply) then
        	taker = Diablos.RS.Strings.taker .. ": " .. ply:Nick()
       	elseif IsValid(entity) then
       		local class = entity:GetClass()
			if class == "english_speed_camera" then
				taker = Diablos.RS.Strings.english
			elseif class == "french_speed_camera" then
				taker = Diablos.RS.Strings.french
			elseif class == "discriminating_camera" then
				taker = Diablos.RS.Strings.discr
			elseif class == "average_camera_end" then
				taker = Diablos.RS.Strings.avg
			elseif class == "car_camera" then
				taker = Diablos.RS.Strings.car
			elseif class == "stop_camera" or class == "pedestrian_camera" then

				if class == "stop_camera" then
					taker = Diablos.RS.Strings.stop
				else
					taker = Diablos.RS.Strings.ped
				end
				taker = string.lower(taker)

				MODULE:Log("{1} " .. Diablos.RS.Strings.takenby .. " {2} " .. taker .. ". " .. Diablos.RS.Strings.finepricewas .. " {3} " .. Diablos.RS.Strings.amountpaid .. " {4}.",
        		GAS.Logging:FormatPlayer(caughtply), DarkRP.formatMoney(realfineprice), DarkRP.formatMoney(finebudget))

        		return
			end

			taker = string.lower(taker)
			taker = " " .. Diablos.RS.Strings.takenby .. " " .. taker .. "."
		end
		
        MODULE:Log("{1} " .. Diablos.RS.Strings.hasbeentaken .. " {2} " .. Diablos.RS.Strings.insteadof .. " {3} (" .. taker .. "). " .. Diablos.RS.Strings.finepricewas .. " {4} " .. Diablos.RS.Strings.amountpaid .. " {5}.",
        GAS.Logging:FormatPlayer(caughtply), GAS.Logging:Highlight(speed .. Diablos.RS.MPHKMHText), GAS.Logging:Highlight(speedlim .. Diablos.RS.MPHKMHText), DarkRP.formatMoney(realfineprice), DarkRP.formatMoney(finebudget))
 
	end)
end)

GAS.Logging:AddModule(MODULE)