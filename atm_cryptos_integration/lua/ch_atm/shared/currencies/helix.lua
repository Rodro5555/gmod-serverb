CH_ATM.Currencies[ "Helix" ] = {
	Name = "Helix Money",
	
	AddMoney = function( ply, amount )
		ply:GetCharacter():GiveMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:GetCharacter():TakeMoney( amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetCharacter():GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:GetCharacter():HasMoney( amount )
	end,
	
	FormatMoney = function( amount )
		return ix.currency.Get( amount )
	end,
	
	CurrencyAbbreviation = function()
		return "USD"
	end,
}