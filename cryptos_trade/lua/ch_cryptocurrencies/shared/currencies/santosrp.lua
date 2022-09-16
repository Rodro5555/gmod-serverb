CH_CryptoCurrencies.Currencies[ "santosrp" ] = {
	Name = "SantosRP Money",
	
	AddMoney = function( ply, amount )
		ply:AddMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:AddMoney( -amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:CanAfford( amount )
	end,
	
	FormatMoney = function( amount )
		return "$" .. string.Comma( amount )
	end,
	
	CurrencyAbbreviation = function()
		return CH_CryptoCurrencies.Config.ExchangeRateCurrency
	end,
}