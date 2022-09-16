CH_CryptoCurrencies.Currencies[ "pointshop2_premium" ] = {
	Name = "PointShop 2 Premium Points",
	
	AddMoney = function( ply, amount )
		ply:PS2_AddPremiumPoints( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:PS2_AddPremiumPoints( -amount )
	end,
	
	GetMoney = function( ply )
		return ply.PS2_Wallet.premiumPoints
	end,
	
	CanAfford = function( ply, amount )
		return ply.PS2_Wallet.premiumPoints >= amount
	end,
	
	FormatMoney = function( amount )
		return string.Comma( amount ) .. " point" .. (amount > 1 and "s" or "")
	end,
	
	CurrencyAbbreviation = function()
		return "PTS"
	end,
}