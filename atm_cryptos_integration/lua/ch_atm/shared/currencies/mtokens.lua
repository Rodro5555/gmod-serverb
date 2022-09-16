CH_ATM.Currencies[ "mtokens" ] = {
	Name = "mTokens",
	
	AddMoney = function( ply, amount )
		mTokens.AddPlayerTokens( ply, amount )
	end,
	
	TakeMoney = function( ply, amount )
		mTokens.TakePlayerTokens( ply, amount )
	end,
	
	GetMoney = function( ply )
		return mTokens.GetPlayerTokens( ply )
	end,
	
	CanAfford = function( ply, amount )
		return mTokens.CanPlayerAfford( ply, amount )
	end,
	
	FormatMoney = function( amount )
		return string.Comma( amount ) .. " token" .. (amount > 1 and "s" or "")
	end,
	
	CurrencyAbbreviation = function()
		return "TOK"
	end,
}