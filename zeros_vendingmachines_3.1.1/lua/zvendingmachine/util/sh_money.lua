zvm = zvm or {}
zvm.Money = zvm.Money or {}

/*
    1 = Money
    2 = PS Points
    3 = PS2 Points
    4 = PS2 PremiumPoints
*/

// Tells us if the player has enough from the moneytype
function zvm.Money.HasMoney(ply,moneytype,money)

    if moneytype == 1 then
        return zclib.Money.Has(ply, money)
    elseif moneytype == 2 then
        return ply:PS_HasPoints(money)
    elseif moneytype == 3 then

        local points = 0
        if ply.PS2_Wallet then
            points = ply.PS2_Wallet.points
        end
        return points >= money
    elseif moneytype == 4 then

        local premiumPoints = 0
        if ply.PS2_Wallet then
            premiumPoints = ply.PS2_Wallet.premiumPoints
        end
        return premiumPoints >= money
    end
end

function zvm.Money.Display(money, symbol)
	if zvm.config.CurrencyPosInvert then
		return symbol .. zvm.Money.Format(money)
	else
		return zvm.Money.Format(money) .. symbol
	end
end

function zvm.Money.Format(money)
	if not money then return "0" end
	money = tostring(math.abs(money))
	local sep = ","
	local dp = string.find(money, "%.") or #money + 1

	for i = dp - 4, 1, -3 do
		money = money:sub(1, i) .. sep .. money:sub(i + 1)
	end

	return money
end

if SERVER then

    // Takes the specified moneytype from the player
    function zvm.Money.TakeMoney(ply,moneytype,money)

        if moneytype == 1 then
            zclib.Money.Take(ply, money)
        elseif moneytype == 2 then
            ply:PS_TakePoints(money)
        elseif moneytype == 3 then

            ply:PS2_AddStandardPoints(-money,"",false)
        elseif moneytype == 4 then
            ply:PS2_AddPremiumPoints(-money)
        end
    end
end
