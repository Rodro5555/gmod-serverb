local client_id = sReward.config["discord"]["client_id"]
local guild_id = sReward.config["discord"]["guild_id"]

if CLIENT then
    local rpc_url = "http://rpc.stromic.xyz" -- Gmod blocks localhost calls so we bypassed it this way.
    local open_port

    local function findOpenPort(port)
        local portrange = {6463, 6472}

        port = port or portrange[1]

        if port > portrange[2] then hook.Run("sR:DiscordFoundOpenPort", false) return end
        http.Fetch(rpc_url..":"..port, function(data)
            hook.Run("sR:DiscordFoundOpenPort", port)
        end,
        function(err)
            findOpenPort(port + 1)
        end)
    end

    local function sendCode(code)
        net.Start("sR:DiscordIntegration")
        net.WriteString(code)
        net.SendToServer()
    end

    local requested = false
    hook.Add("sR:DiscordFoundOpenPort", "sR:URLHandeling", function(port)
        if requested then return end
        if !port then
            slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_failed_application_com"))
        return end
        
        local url = rpc_url..":"..port

        requested = true
        HTTP({
            method = "post",
            url = url.."/rpc?v=1&client_id="..client_id,
            type = "application/json",
            body = util.TableToJSON({
                cmd = "AUTHORIZE",
                args = {
                    client_id = client_id,
                    scopes = {"identify"},
                },
                nonce = "ABC123ABC",
            }),
            success = function(code, body, headers)
                requested = false
                if (code == 200) then
                    local data = util.JSONToTable(body)
                    
                    if !data or !data.data or !data.data.code then
                        slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"))
                    return end

                    sendCode(data.data.code)
                else
                    slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"))
                end
            end,
            failed = function(err)
                requested = false
                slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"))
            end
            })
    end)

    net.Receive("sR:DiscordIntegration", function()
        if !open_port then
            findOpenPort()
        else
            hook.Run("sR:DiscordFoundOpenPort", open_port)
        end
    end)
else
    util.AddNetworkString("sR:DiscordIntegration")

    sReward = sReward or {}
    sReward.discord = sReward.discord or {}
    sReward.discord.members = sReward.discord.members or {}
    sReward.discord.queue = sReward.discord.queue or {}

    local client_secret = sReward.config["discord"]["client_secret"]
    local bot_token = sReward.config["discord"]["bot_token"]

    local apiURL = "https://stromic.xyz/discord.php" --- We will get blocked by Cloudflare so we reverse proxy!

    local function handleQueue(sid)
        for k,v in pairs(sReward.discord.queue[sid]) do
            v()
            sReward.discord.queue[sid][k] = nil
        end
    end

    local function syncMember(sid)
        local uid = sReward.discord.members[sid] and sReward.discord.members[sid].id
        if !uid then return end
        http.Fetch(apiURL.."/guilds/"..guild_id.."/members/"..uid, function(json, len, headers, code)
            local data = util.JSONToTable(json)
            if data then
                sReward.discord.members[sid].joined = !!data.user
                sReward.discord.members[sid].boosting = !!data.premium_since

                handleQueue(sid)
            end
        end, nil, {
            ["Authorization"] = "Bot "..bot_token
        })
    end

    local function storeuid(ply, code)
        local sid = ply:SteamID()
        
        HTTP({
            method = "post",
            url = apiURL.."/oauth2/token",
            parameters = {
                grant_type = "authorization_code",
                code = code,
                client_id = client_id,
                client_secret = client_secret,
            },
            headers	= {},
            success = function(code, body, headers)
                if (code == 200) then
                    local data = util.JSONToTable(body)
                    local token = data.access_token

                    if !token then
                        slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"), ply)
                    return end

                    http.Fetch(apiURL.."/users/@me", function(data)
                        local json = util.JSONToTable(data)
            
                        sReward.discord.members[sid].id = json and json.id

                        if !sReward.discord.members[sid] then
                            slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"), ply)
                        else
                            syncMember(sid)
                        end
                    end, function()
                        slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"), ply) 
                    end,{ --- Headers include token!    ​​   ​​ ​    
                        ["Authorization"] = "Bearer "..token
                    })
                else
                    slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"), ply)
                end
            end,
            failed = function(err)
                slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "discord_error_retrieving_data"), ply)
            end
        })
    end

    local function handleVerification(ply, key, type)
        local reward = sReward.config["rewards"][key]

        local sid = ply:SteamID()
        
        sReward.discord.members[sid] = sReward.discord.members[sid] or {}
        sReward.discord.queue[sid] = sReward.discord.queue[sid] or {}

        if sReward.discord.members[sid][type] then
            sReward.GiveReward(ply, key)
        return end

        local success = function()
            if sReward.discord.members[sid][type] then
                sReward.GiveReward(ply, key)
            else
                slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "failed_verification", reward.name), ply)
            end
        end

        if !sReward.discord.members[sid].id then            
            net.Start("sR:DiscordIntegration")
            net.Send(ply)

            ply.sR_RequestedAuth = true
        elseif !sReward.discord.members[sid][type] then
            syncMember(sid)
        end

        sReward.discord.queue[sid][type] = success

        slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "checking_wait", reward.name), ply)
    end

    sReward.VerifyDiscordJoin = function(ply, key)
        handleVerification(ply, key, "joined")
    end

    sReward.VerifyDiscordBoost = function(ply, key)
        handleVerification(ply, key, "boosting")
    end

    net.Receive("sR:DiscordIntegration", function(len, ply)
        local sid = ply:SteamID()
        if !ply.sR_RequestedAuth then return end
        ply.sR_RequestedAuth = nil

        local code = net.ReadString()

        if code == "" then return end
            
        storeuid(ply, code, v)
    end)
end