CH_CryptoCurrencies.Currencies[ "bricks_credit_store" ] = {
	Name = "Bricks Credit Store",
	
	AddMoney = function( ply, amount )
		ply:AddBRCS_Credits( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:RemoveBRCS_Credits( amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetBRCS_Credits()
	end,
	
	CanAfford = function( ply, amount )
		return ply:GetBRCS_Credits() >= amount
	end,
	
	FormatMoney = function( amount )
		return BRICKSCREDITSTORE.FormatCredits( amount, true )
	end,
	
	CurrencyAbbreviation = function()
		return "CR"
	end,
}