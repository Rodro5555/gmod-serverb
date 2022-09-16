CH_ATM.Currencies[ "darkrp" ] = {
	Name = "DarkRP Money",

	AddMoney = function( ply, amount )
		ply:addMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:addMoney( amount * -1 )
	end,
	
	GetMoney = function( ply )
		return ply:getDarkRPVar( "money" )
	end,
	
	CanAfford = function( ply, amount )
		return ply:canAfford( amount )
	end,
	
	FormatMoney = function( amount )
		return DarkRP.formatMoney( amount )
	end,
	
	CurrencyAbbreviation = function()
		return "USD"
	end,
}