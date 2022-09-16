
--[[ Make sure sentence exist and also langage exist]]
function Realistic_Police.GetSentence(string)
    local result = "Lang Problem"
    local sentence = istable(Realistic_Police.Language[Realistic_Police.Lang]) and Realistic_Police.Language[Realistic_Police.Lang][string] or "Lang Problem"

    if istable(Realistic_Police.Language[Realistic_Police.Lang]) and isstring(sentence) then
        result = sentence
    elseif istable(Realistic_Police.Language["en"]) and isstring(Realistic_Police.Language["en"][sentence]) then
        result = Realistic_Police.Language["en"][sentence]
    end

    return result
end