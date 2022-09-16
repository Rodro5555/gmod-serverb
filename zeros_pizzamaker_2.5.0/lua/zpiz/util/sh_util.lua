zpiz = zpiz or {}

function zpiz.Print(msg)
	print("[Zero´s Pizzamaker] " .. msg)
end

function zpiz.UseHungermod()
	if DarkRP and DarkRP.disabledDefaults and DarkRP.disabledDefaults["modules"] and DarkRP.disabledDefaults["modules"]["hungermod"] ~= true then
		return true
	else
		return false
	end
end
