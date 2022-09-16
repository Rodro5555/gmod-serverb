--[[  
    Addon: Hitman
    By: SlownLS
]]

local TABLE = SlownLS.Hitman

TABLE.Languages = TABLE.Languages or {}

function TABLE:addLanguage(strName,tbl)
    self.Languages = self.Languages or {}

    self.Languages[strName] = tbl
end

function TABLE:getLanguage(strName)
    local strCurrent = self:getConfig("Language")

    if !self.Languages[strCurrent] then 
        strCurrent = "en"
    end

    return self.Languages[strCurrent][strName] or "nil"
end