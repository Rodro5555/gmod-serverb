if not DarkRP then return end
DarkRP.declareChatCommand{
    command = "ano",
    description = "Send anonymous message on server",
    delay = 5
}

DarkRP.chatCommandAlias("ano","anonymous")

if SERVER then
    local function anonymous(ply, args)
        local DoSay = function(text)
            if text == "" then
                DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
                return ""
            end
     
            for _, v in ipairs(player.GetAll()) do
                if IsValid(v) then
                    DarkRP.talkToPerson(v, Color(204,18,21,255), "[Anonimo] ", Color(250,250,250,255), text)
                end
            end
        end
        return args, DoSay
    end
    DarkRP.defineChatCommand("ano", anonymous, true, 5)
else
    --CLIENT
    DarkRP.addChatReceiver("/ano", "speak in Ano", function(ply) return true end)
end
