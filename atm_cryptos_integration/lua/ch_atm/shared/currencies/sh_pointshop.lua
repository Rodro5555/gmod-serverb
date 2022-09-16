CH_ATM.Currencies[ "sh_pointshop" ] = {
	Name = "SH Pointshop Points",
	
	AddMoney = function( ply, amount )
		ply:SH_AddStandardPoints( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:SH_AddStandardPoints( -amount )
	end,
	
	GetMoney = function( ply )
		return ply:SH_GetStandardPoints()
	end,
	
	CanAfford = function( ply, amount )
		return ply:SH_CanAffordStandard( amount )
	end,
	
	FormatMoney = function( amount )
		return string.Comma( amount ) .. " point" .. (amount > 1 and "s" or "")
	end,
	
	CurrencyAbbreviation = function()
		return "PTS"
	end,
}