local MODULE = GAS.Logging:MODULE()
MODULE.Category = "SlownLS Hitman"

MODULE.Name = "Contracts sent"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("SlownLS:Hitman:Contract:Sent", "blogs", function(pPlayer, tblInfos)
		MODULE:Log("{1} sent a contract of " .. DarkRP.formatMoney(tblInfos.price) ..  " on {2}", GAS.Logging:FormatPlayer(pPlayer), GAS.Logging:FormatPlayer(tblInfos.victim))
	end)
end)

GAS.Logging:AddModule(MODULE)

-- Taked
local MODULE = GAS.Logging:MODULE()
MODULE.Category = "SlownLS Hitman"

MODULE.Name = "Contracts taked"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("SlownLS:Hitman:Contract:Taked", "blogs", function(pPlayer, tblInfos)
		MODULE:Log("{1} accepted the contract of {2}", GAS.Logging:FormatPlayer(pPlayer), GAS.Logging:FormatPlayer(tblInfos.by))
	end)
end)

GAS.Logging:AddModule(MODULE)

-- Finished
local MODULE = GAS.Logging:MODULE()
MODULE.Category = "SlownLS Hitman"

MODULE.Name = "Contracts finished"
MODULE.Colour = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("SlownLS:Hitman:Contract:Finished", "blogs", function(tblInfos, strType)
        if ( strType == "hitman_dead" ) then
		    MODULE:Log("The contract of {1} was canceled because the hitman died", GAS.Logging:FormatPlayer(tblInfos.by))
            return 
        end

        if ( strType == "victim_killed" ) then
		    MODULE:Log("The contract of {1} was successfully completed", GAS.Logging:FormatPlayer(tblInfos.by))
            return 
        end

        if ( strType == "victim_dead" ) then
		    MODULE:Log("The contract of {1} was canceled because the player died", GAS.Logging:FormatPlayer(tblInfos.by))
            return 
        end
	end)
end)

GAS.Logging:AddModule(MODULE)
