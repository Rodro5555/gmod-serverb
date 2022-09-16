
--[[ Make sure sentence exist and also langage exist]]
function Realistic_Woodcutter.GetSentence(string)
    local result = "Lang Problem"
    local sentence = istable(Realistic_Woodcutter.Language[Realistic_Woodcutter.Lang]) and Realistic_Woodcutter.Language[Realistic_Woodcutter.Lang][string] or "Lang Problem"
    if istable(Realistic_Woodcutter.Language[Realistic_Woodcutter.Lang]) and isstring(sentence) then
        result = sentence
    elseif istable(Realistic_Woodcutter.Language["en"]) and isstring(Realistic_Woodcutter.Language["en"][sentence]) then
        result = Realistic_Woodcutter.Language["en"][sentence]
    end

    return result
end