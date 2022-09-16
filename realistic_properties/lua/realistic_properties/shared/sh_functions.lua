
--[[ Make sure sentence exist and also langage exist]]
function Realistic_Properties.GetSentence(string)
    local result = "Lang Problem"
    local sentence = istable(Realistic_Properties.Language[Realistic_Properties.Lang]) and Realistic_Properties.Language[Realistic_Properties.Lang][string] or "Lang Problem"

    if istable(Realistic_Properties.Language[Realistic_Properties.Lang]) and isstring(sentence) then
        result = sentence
    elseif istable(Realistic_Properties.Language["en"]) and isstring(Realistic_Properties.Language["en"][sentence]) then
        result = Realistic_Properties.Language["en"][sentence]
    end

    return result
end