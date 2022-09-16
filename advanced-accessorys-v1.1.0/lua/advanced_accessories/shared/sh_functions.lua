-- [[ Compress table ]] --
function AAS.CompressTable(tbl)
    if not istable(tbl) then return end

    return (util.Compress(util.TableToJSON(tbl)) or "")
end

-- [[ Uncompress table ]] --
function AAS.UnCompressTable(compressedString)
    if not isstring(compressedString) then return end

    return (util.JSONToTable(util.Decompress(compressedString)) or {})
end

--[[ Check if the category exist on the sh_advanced_configuration.lua ]]
function AAS.CheckCategory(category)
    for k,v in pairs(AAS.Category["mainMenu"]) do 
        if v.uniqueName == category then return true end 
    end
    return false 
end

--[[ Convert a number to a format number ]]
function AAS.formatMoney(money)
    if not isnumber(money) then return 0 end

    money = string.Comma(money)

    return isfunction(AAS.Currencies[AAS.CurrentCurrency]) and AAS.Currencies[AAS.CurrentCurrency](money) or money
end

--[[ Serverside get the invetory table with a steamId64 and Clientside get your inventory ]]
function AAS.GetInventory(steamId64)
    if SERVER then
        local inventoryQuery = AAS.Query("SELECT * FROM aas_inventory WHERE steam_id = '"..steamId64.."'")
        local returnTable = {}

        for k,v in ipairs(inventoryQuery) do
            if not AAS.GetTableById(v.uniqueId) then continue end

            returnTable[#returnTable + 1] = v
        end
        
        return returnTable
    else
        return AAS.ClientTable["ItemsInventory"]
    end
end

--[[ Make sure sentence exist and also langage exist]]
function AAS.GetSentence(string)
    local result = "Lang Problem"
    local sentence = istable(AAS.Language[AAS.Lang]) and AAS.Language[AAS.Lang][string] or "Lang Problem"

    if istable(AAS.Language[AAS.Lang]) and isstring(sentence) then
        result = sentence
    elseif istable(AAS.Language["en"]) and isstring(AAS.Language["en"][sentence]) then
        result = AAS.Language["en"][sentence]
    end

    return result
end

local PLAYER = FindMetaTable("Player")

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:AASGetMoney()
    if DarkRP then
        return self:getDarkRPVar("money")
    elseif ix then
        return (self:GetCharacter() != nil and self:GetCharacter():GetMoney() or 0)
    elseif nut then
        return (self:getChar() != nil and self:getChar():getMoney() or 0)
    end

    return 0
end

--[[ Get if the model is equipped on the player ]]
function PLAYER:AASModelEquiped(model)
    if SERVER then
        local AASTbl = AAS.Query("SELECT * FROM aas_item WHERE model = '"..model.."'")
        local tbl = AASTbl[1] or {}    
        local Equiped = false

        for k,v in pairs(self.AASAccessories) do
            if tonumber(v) != tonumber(tbl["uniqueId"]) then continue end

            Equiped = true
            break
        end

        return Equiped
    else
        local Equiped = false
        local itemsEquiped = AAS.ClientTable["ItemsEquiped"][self:SteamID64()] or {}
        
        for k,v in pairs(itemsEquiped) do
            if v.model == model then Equiped = true break end
        end

        return Equiped
    end
end