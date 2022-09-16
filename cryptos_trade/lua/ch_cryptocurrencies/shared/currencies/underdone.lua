CH_CryptoCurrencies.Currencies[ "underdone" ] = {
	Name = "Underdone Money",
	
	AddMoney = function( ply, amount )
		ply:AddItem( "money", amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:RemoveItem( "money", -amount )
	end,
	
	GetMoney = function( ply )
		return ply.Data.Inventory["money"] or 0
	end,
	
	CanAfford = function( ply, amount )
		local cur_money = ply.Data.Inventory["money"] or 0
		
		return cur_money >= amount
	end,
	
	FormatMoney = function( amount )
		return "$" .. string.Comma( amount )
	end,
	
	CurrencyAbbreviation = function()
		return CH_CryptoCurrencies.Config.ExchangeRateCurrency
	end,
}