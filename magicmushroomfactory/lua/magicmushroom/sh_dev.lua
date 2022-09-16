function MMF.Log(...)
    if GetConVar("developer"):GetBool() then
        print("[MMF]", ...)
    end
end