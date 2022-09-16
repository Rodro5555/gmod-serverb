gPoker = {}

gPoker.model = Model("")

//Poker games

//WARNING: Keep in mind that networking of both game types and betting in the creation derma menu is used with net.WriteUInt(), and so the limit is 32
gPoker.gameType = {
    [0] = {
        name        = "Five Draw",  --The fancy name
        cardNum     = 5,            --Number of cards each player has
        cardDraw    = true,         --Can players exchange cards?
        cardComm    = false,        --Use community cards (cards in the center)?
        cardCommNum = 0,            --Amount of community cards (if uses any)
        cardCanSee  = true,         --Can players see their cards on HUD?
        available   = true,         --Is available?
        states      = {             --(NOTE: Begins AFTER the intermission timer) List of all actions
            [1] = {
                text    = "Cuota de entrada",
                func    = function(e) if CLIENT then return end e:entryFee() end  
            },
            [2] = {
                text    = "Repartiendo cartas...",           --Text to be displayed at the top, can also be function
                func    = function(e) if CLIENT then return end e:beginRound() end --Function that will run on the table
            },
            [3] = {
                text    = "Ronda de apuestas",
                func    = function(e) if CLIENT then return end e:bettingRound() end
            },
            [4] = {
                text    = "Ronda de robos",
                func    = function(e) if CLIENT then return end e:drawingRound() end,
                drawing = true
            },
            [5] = {
                text    = "Última ronda de apuestas",
                func    = function(e) if CLIENT then return end e:bettingRound() end
            },
            [6] = {
                text    = function(e)
                    local win = Entity(e.players[e:GetWinner()].ind)

                    if !IsValid(win) then return end

                    local t
                    if win:IsPlayer() then t = win:Nick() else t = win:GetBotName() end
                    t =  t .. " posee: "

                    if e.players[e:GetWinner()].strength and e.players[e:GetWinner()].value then
                        t = t .. gPoker.fancyDeckStrength(e.players[e:GetWinner()].strength, e.players[e:GetWinner()].value)
                    else
                        t = t .. "..."
                    end

                    return t
                end,
                func    = function(e) if CLIENT then return end e:revealCards() end,
                final   = true
            },
            [7] = {
                text    = function(e)
                    if !IsValid(e) then return end

                    local win = Entity(e.players[e:GetWinner()].ind)

                    if !IsValid(win) then return "Ganador: " end

                    local t = "Ganador: "
                    if win:IsPlayer() then t = t .. win:Nick() else t = t .. win:GetBotName() end
                    t = t .. ", " .. gPoker.fancyDeckStrength(e.players[e:GetWinner()].strength, e.players[e:GetWinner()].value)

                    return t
                end,
                func    = function(e) if CLIENT then return end e:finishRound() end
            },
        }
    },
    [1] = {
        name        = "Texas Hold'em", 
        cardNum     = 2,           
        cardDraw    = false,        
        cardComm    = true,       
        cardCommNum = 5,
        cardCanSee  = true,
        available   = true,
        states      = {
            [1] = {
                text = "Cuota de entrada",
                func = function(e) if CLIENT then return end e:entryFee() end
            },
            [2] = {
                text = "Repartiendo cartas...",
                func = function(e) if CLIENT then return end e:beginRound() end
            },
            [3] = {
                text = "Primera apuesta",
                func = function(e) if CLIENT then return end e:bettingRound() end
            },
            [4] = {
                text = "Revelando el flop",
                func = function(e) if CLIENT then return end e:revealCommunityCards({1,2,3}) end
            },
            [5] = {
                text = "segunda apuesta",
                func = function(e) if CLIENT then return end e:bettingRound() end
            },
            [6] = {
                text = "Revelando el turno",
                func = function(e) if CLIENT then return end e:revealCommunityCards(4) end
            },
            [7] = {
                text = "Tercera apuesta",
                func = function(e) if CLIENT then return end e:bettingRound() end
            },
            [8] = {
                text = "Revelando el río",
                func = function(e) if CLIENT then return end e:revealCommunityCards(5) end
            },
            [9] = {
                text = "Última apuesta",
                func = function(e) if CLIENT then return end e:bettingRound() end
            },
            [10] = {
                text    = function(e)
                    local win = Entity(e.players[e:GetWinner()].ind)

                    if !IsValid(win) then return end

                    local t
                    if win:IsPlayer() then t = win:Nick() else t = win:GetBotName() end
                    t =  t .. " posee: "

                    if e.players[e:GetWinner()].strength and e.players[e:GetWinner()].value then
                        t = t .. gPoker.fancyDeckStrength(e.players[e:GetWinner()].strength, e.players[e:GetWinner()].value)
                    else
                        t = t .. "..."
                    end

                    return t
                end,
                func    = function(e) if CLIENT then return end e:revealCards() end,
                final   = true
            },
            [11] = {
                text    = function(e)
                    if !IsValid(e) then return end

                    local win = Entity(e.players[e:GetWinner()].ind)

                    if !IsValid(win) then return "Ganador: " end

                    local t = "Ganador: "
                    if win:IsPlayer() then t = t .. win:Nick() else t = t .. win:GetBotName() end
                    t = t .. ", " .. gPoker.fancyDeckStrength(e.players[e:GetWinner()].strength, e.players[e:GetWinner()].value)

                    return t
                end,
                func    = function(e) if CLIENT then return end e:finishRound() end
            },
        }
    }
}

//Poker bets
gPoker.betType = {
    [0] = {
        name        = "Dinero",                              --Name
        fix         = "$",                                  --Text after value
        canSet      = engine.ActiveGamemode() != "darkrp",  --Can players set the amount of value each player gets in the spawn derma?
        setMinMax   = {min = 0, max = 10000},                --The minimum and maximum number of starting value (if uses)
        feeMinMax   = {min = 0, max = function(setSlider) 
            if CLIENT then 
                if engine.ActiveGamemode() != "darkrp" then 
                    return setSlider:GetValue() 
                else 
                    return LocalPlayer():getDarkRPVar("money") 
                end 
            end
        end}, --The minimum and maximum of entry fee
        get         = function(p)                           --Method for getting specified player's value
            if !IsValid(p) then return end

            local isDarkRp = engine.ActiveGamemode() == "darkrp"

            if !isDarkRp or (isDarkRp and !p:IsPlayer()) then
                local e = gPoker.getTableFromPlayer(p)

                local key = e:getPlayerKey(p)
                if key == nil then return end

                return e.players[key].money
            else
                return p:getDarkRPVar("money")
            end
        end,
        add         = function(p, a, e)                        --Method for adding or subtracting the value
            if CLIENT then return end
            if !IsValid(p) then return end


            local isDarkRp = engine.ActiveGamemode() == "darkrp"
            a = a or 0

            if !isDarkRp or (isDarkRp and !p:IsPlayer()) then 
                local key = e:getPlayerKey(p)
                if key == nil then return end

                e.players[key].money = e.players[key].money + a
                e:updatePlayersTable()
            else
                p:addMoney(a)
            end

            e:SetPot(e:GetPot() - a)
        end,
        call = function(s, p) --Called after player joins, mostly used for setting up custom value
            if !(engine.ActiveGamemode() == "darkrp") then
                s.players[s:getPlayerKey(p)].money = s:GetStartValue()
            elseif !p:IsPlayer() then
                s.players[s:getPlayerKey(p)].money = math.random(100,1000)
            end
        end,
        models      = {  --The spinning model at the center
            [1] = {
                mdl = Model("models/items/currencypack_small.mdl"), --The model, MUST be used with Model() because of CSEnt
                val = 100, --Maximum value this model can be used with
                scale = 0.5 --The scale of the model
            },
            [2] = {
                mdl = Model("models/items/currencypack_medium.mdl"),
                val = 1000,
                scale = 0.5
            },
            [3] = {
                mdl = Model("models/items/currencypack_large.mdl"),
                val = 999999,
                scale = 0.5
            }
        }
    },

    [1] = {
        name        = "Vida",
        fix         = "HP",
        canSet      = false,
        setMinMax   = {min = 0, max = 0},
        feeMinMax   = {min = 0, max = function() if CLIENT then return LocalPlayer():GetMaxHealth() end end},
        get         = function(p)
            if p:IsPlayer() then
                return p:Health()
            else
                local ent = gPoker.getTableFromPlayer(p)

                if !IsValid(ent) then return 0 end

                local key = ent:getPlayerKey(p)
                return ent.players[key].health
            end
        end,
        add         = function(p, a, e)
            if CLIENT then return end
            if !IsValid(p) then return end
            
            a = a or 0

            local hp = gPoker.betType[e:GetBetType()].get(p) + a
            
            if hp < 1 then 
                e:removePlayerFromMatch(p)
                if p:IsPlayer() then p:Kill() end
            else
                if p:IsPlayer() then p:SetHealth(hp) else 
                    e.players[e:getPlayerKey(p)].health = hp 
                    e:updatePlayersTable() 
                end
            end

            e:SetPot(e:GetPot() - a)
        end,
        call = function(s, p)
            if !p:IsPlayer() then
                s.players[s:getPlayerKey(p)].health = 100 + math.random(0,150) --Add a little randomziation ;)
            end
        end,
        models      = {
            [1] = {
                mdl = Model("models/healthvial.mdl"),
                val = 100,
                scale = 1
            },
            [2] = {
                mdl = Model("models/Items/HealthKit.mdl"),
                val = 999999,
                scale = 1
            }
        }
    }
}



//Cards materials, for hud
gPoker.cards = {}

for s = 0, 3 do
    gPoker.cards[s] = {}

    for r = 0, 12 do
        gPoker.cards[s][r] = Material("gpoker/cards/" .. s .. r .. ".png")
    end
end

gPoker.suit = {
    [0] = "Trébol",
    [1] = "Diamante",
    [2] = "Corazón",
    [3] = "Espada"
}

gPoker.rank = {
    [0] = "Dos",
    [1] = "Tres",
    [2] = "cuatro",
    [3] = "Cinco",
    [4] = "Seis",
    [5] = "Siete",
    [6] = "Ocho",
    [7] = "Nueve",
    [8] = "Diez",
    [9] = "Jota",
    [10] = "Dama",
    [11] = "Rey",
    [12] = "As"
}

gPoker.strength = {
    [0] = "Carta alta",
    [1] = "Par",
    [2] = "Doble Par",
    [3] = "Trío",
    [4] = "Color",
    [5] = "Escalera",
    [6] = "Full",
    [7] = "Poker",
    [8] = "Escalera de Color",
    [9] = "Escalera Real"
}

//Bots section//

gPoker.bots = {}

//Lots of references
gPoker.bots.names = {"Æ", "The Shark", "Multiplier", "The Ripper", "Big Boss", "Christ", "The Dude", "White", "Freeman", "Alpha", "Jetstream", "Beta", "Approaching Storm", "Afton", "Gamma", "White Wolf", "Narrator", "Rookie", "Snake Eater", "Mars", "Tea Sniffer", "Dango", "Folder", "Scarlet Devil", "Beep Boop", "Karen Slayer", "Black Blood RP", "Silent", "May", "August", "Player", "Sol", "Risker", "Miller", "Slayer of Doom", "Doom", "Finger", /*v1.0.3*/ "Minge", "anonymous", "ByzrK", "Trickster", "Dummy", "Cthulhu", "Deadweight", "Quiet", "V1", "V2", "Deez", "Nuts", "Shalashaska", "Liquid", "Bandit", "Monkey", "Bloon", "Red", "La Li Lu Le Lo", "Impending Doom", "Engineer", "Gwent Expert", "GPoker sucks", "Bug", "Red Saber", "CUtIRBTree Overflow!", "Stack Overflow", "JC"}

//Global Functions//

//Finds the table player is playing at
function gPoker.getTableFromPlayer(p)
    if !IsValid(p) then return end

    local tables = ents.FindByClass("ent_poker_game")

    if !table.IsEmpty(tables) then
        for k,v in pairs(tables) do
            local key = v:getPlayerKey(p)

            if key != nil then return v end
        end
    end

    return nil
end



//Returns a fancy formatted string of deck strength
function gPoker.fancyDeckStrength(st,vl)
    local text = ""
    
    if st == 0 then
        text = "Carta alta, " .. gPoker.rank[vl]
    elseif st == 1 then
        text = "Par de "
        local pairText = ""
        if vl == 4 then pairText = "Seises" else pairText = gPoker.rank[vl] .. "s" end

        text = text .. pairText
    elseif st == 2 then
        text = "Doble par, "
        local highPair = math.floor(vl)
        local lowPair = math.Round((vl - highPair) * 100)

        local highPairStr, lowPairStr

        if highPair == 4 then highPairStr = "Seises" else highPairStr = gPoker.rank[highPair] .. "s" end
        if lowPair == 4 then lowPairStr = "Seises" else lowPairStr = gPoker.rank[lowPair] .. "s" end

        local pairsText = highPairStr .. " y " .. lowPairStr 
        text = text .. pairsText
    elseif st == 3 then
        text = "Trío, "
        local threeText = ""
        if vl == 4 then threeText = "Seises" else threeText = gPoker.rank[vl] .. "s" end

        text = text .. threeText
    elseif st == 4 then
        text = "Color, " .. gPoker.rank[vl] .. " high"
    elseif st == 5 then
        text = "Escalera, " .. gPoker.rank[vl] .. " high"
    elseif st == 6 then
        text = "Full, "
        local threeKind = math.floor(vl)
        local pair = math.Round((vl - threeKind) * 100)
        local threeKindStr, pairStr

        if threeKind == 4 then threeKindStr = "Seises" else threeKindStr = gPoker.rank[threeKind] .. "s" end
        if pair == 4 then pairStr = "Seises" else pairStr = gPoker.rank[pair] .. "s" end

        local fullText =  threeKindStr .. " sobre " .. pairStr
        text = text .. fullText
    elseif st == 7 then
        text = "Poker, "
        local fourText = ""
        if vl == 0 then fourText = "doses" elseif vl == 4 then fourText = "seises" else fourText = gPoker.rank[vl] .. "s" end
        text = text .. fourText
    elseif st == 8 then
        text = "Escalera de Color, " .. gPoker.rank[vl] .. " high"
    else
        text = "Escalera Real"
    end

    return text
end