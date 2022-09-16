CH_CryptoCurrencies.Currencies[ "pointshop2" ] = {
	Name = "PointShop 2 Points",
	
	AddMoney = function( ply, amount )
		ply:PS2_AddStandardPoints( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:PS2_AddStandardPoints( -amount )
	end,
	
	GetMoney = function( ply )
		return ply.PS2_Wallet.points
	end,
	
	CanAfford = function( ply, amount )
		return ply.PS2_Wallet.points >= amount
	end,
	
	FormatMoney = function( amount )
		return string.Comma( amount ) .. " point" .. (amount > 1 and "s" or "")
	end,
	
	CurrencyAbbreviation = function()
		return "PTS"
	end,
}