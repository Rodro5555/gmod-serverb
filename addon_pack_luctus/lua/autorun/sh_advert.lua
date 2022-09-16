--Advert-Command
--Made by OverlordAkise, ported from FPTje's OOC

hook.Add("PostGamemodeLoaded","luctus_advert",function()
    if not DarkRP then return end
    DarkRP.removeChatCommand("/advert")
    DarkRP.declareChatCommand{
        command = "advert",
        description = "Global in-character chat.",
        delay = 1.5
    }
    DarkRP.chatCommandAlias("advert","anuncio")
    if SERVER then
        local function advert(ply, args)
            local DoSay = function(text)
                if text == "" then
                    DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
                    return ""
                end
                local col = team.GetColor(ply:Team())

                local name = ply:Nick()
                for _, v in ipairs(player.GetAll()) do
                    DarkRP.talkToPerson(v, col, "[Anuncio] " .. name, Color(255, 255, 0, 255), text, ply)
                end
            end
            return args, DoSay
        end
        DarkRP.defineChatCommand("advert", advert, true, 1.5)
    else
        --CLIENT
        DarkRP.addChatReceiver("/advert", "speak in Advert", function(ply) return true end)
    end
end)
