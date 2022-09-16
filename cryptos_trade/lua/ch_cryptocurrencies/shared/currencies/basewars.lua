CH_CryptoCurrencies.Currencies[ "basewars" ] = {
	Name = "Basewars Money",
	
	AddMoney = function( ply, amount )
		ply:GiveMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:TakeMoney( amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:GetMoney() >= amount
	end,
	
	FormatMoney = function( amount )
		return DarkRP.formatMoney( amount )
	end,
	
	CurrencyAbbreviation = function()
		return CH_CryptoCurrencies.Config.ExchangeRateCurrency
	end,
}