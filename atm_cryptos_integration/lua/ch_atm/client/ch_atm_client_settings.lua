--[[
	Cache all the materials to their respective theme number
--]]
CH_ATM.IconTheme = CH_ATM.IconTheme or {}
CH_ATM.IconTheme.Icons = CH_ATM.IconTheme.Icons or {}

CH_ATM.IconTheme.Icons[ 1 ] = { -- WHITE OUTLINE
	mat_cryptos = Material( "materials/craphead_scripts/ch_atm/gui/white/browse_crypto.png", "noclamp smooth" ),
	mat_history = Material( "materials/craphead_scripts/ch_atm/gui/white/crypto_history.png", "noclamp smooth" ),
	mat_portfolio = Material( "materials/craphead_scripts/ch_atm/gui/white/crypto_portfolio.png", "noclamp smooth" ),
	mat_send_crypto = Material( "materials/craphead_scripts/ch_atm/gui/white/send_crypto.png", "noclamp smooth" ),

	mat_load = Material( "materials/craphead_scripts/ch_atm/gui/white/loading.png", "noclamp smooth" ),
	mat_settings = Material( "materials/craphead_scripts/ch_atm/gui/white/settings.png", "noclamp smooth" ),
	mat_upgrade_account = Material( "materials/craphead_scripts/ch_atm/gui/white/upgrade_account.png", "noclamp smooth" ),
	
	mat_bank = Material( "materials/craphead_scripts/ch_atm/gui/white/bank_account.png", "noclamp smooth" ),
	mat_crypto_bank = Material( "materials/craphead_scripts/ch_atm/gui/white/crypto_account.png", "noclamp smooth" ),
	mat_no_cryptos = Material( "materials/craphead_scripts/ch_atm/gui/white/no_crypto.png", "noclamp smooth" ),

	mat_deposit = Material( "materials/craphead_scripts/ch_atm/gui/white/deposit.png", "noclamp smooth" ),
	mat_withdraw = Material( "materials/craphead_scripts/ch_atm/gui/white/withdraw.png", "noclamp smooth" ),
	mat_send_money = Material( "materials/craphead_scripts/ch_atm/gui/white/send_money.png", "noclamp smooth" ),
	mat_bank_history = Material( "materials/craphead_scripts/ch_atm/gui/white/history.png", "noclamp smooth" ),
	
	mat_insert_card = Material( "materials/craphead_scripts/ch_atm/gui/white/insert_card.png", "noclamp smooth" ),
	mat_exit_atm = Material( "materials/craphead_scripts/ch_atm/gui/white/exit_atm.png", "noclamp smooth" ),
}

CH_ATM.IconTheme.Icons[ 2 ] = { -- GRADIENT
	mat_cryptos = Material( "materials/craphead_scripts/ch_atm/gui/gradient/browse_crypto.png", "noclamp smooth" ),
	mat_history = Material( "materials/craphead_scripts/ch_atm/gui/gradient/crypto_history.png", "noclamp smooth" ),
	mat_portfolio = Material( "materials/craphead_scripts/ch_atm/gui/gradient/crypto_portfolio.png", "noclamp smooth" ),
	mat_send_crypto = Material( "materials/craphead_scripts/ch_atm/gui/gradient/send_crypto.png", "noclamp smooth" ),

	mat_load = Material( "materials/craphead_scripts/ch_atm/gui/gradient/loading.png", "noclamp smooth" ),
	mat_settings = Material( "materials/craphead_scripts/ch_atm/gui/gradient/settings.png", "noclamp smooth" ),
	mat_upgrade_account = Material( "materials/craphead_scripts/ch_atm/gui/gradient/upgrade_account.png", "noclamp smooth" ),
	
	mat_bank = Material( "materials/craphead_scripts/ch_atm/gui/gradient/bank_account.png", "noclamp smooth" ),
	mat_crypto_bank = Material( "materials/craphead_scripts/ch_atm/gui/gradient/crypto_account.png", "noclamp smooth" ),
	mat_no_cryptos = Material( "materials/craphead_scripts/ch_atm/gui/gradient/no_crypto.png", "noclamp smooth" ),

	mat_deposit = Material( "materials/craphead_scripts/ch_atm/gui/gradient/deposit.png", "noclamp smooth" ),
	mat_withdraw = Material( "materials/craphead_scripts/ch_atm/gui/gradient/withdraw.png", "noclamp smooth" ),
	mat_send_money = Material( "materials/craphead_scripts/ch_atm/gui/gradient/send_money.png", "noclamp smooth" ),
	mat_bank_history = Material( "materials/craphead_scripts/ch_atm/gui/gradient/history.png", "noclamp smooth" ),
	
	mat_insert_card = Material( "materials/craphead_scripts/ch_atm/gui/gradient/insert_card.png", "noclamp smooth" ),
	mat_exit_atm = Material( "materials/craphead_scripts/ch_atm/gui/gradient/exit_atm.png", "noclamp smooth" ),
}

CH_ATM.IconTheme.Icons[ 3 ] = { -- FLAT COLOR
	mat_cryptos = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/browse_crypto.png", "noclamp smooth" ),
	mat_history = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/crypto_history.png", "noclamp smooth" ),
	mat_portfolio = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/crypto_portfolio.png", "noclamp smooth" ),
	mat_send_crypto = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/send_crypto.png", "noclamp smooth" ),

	mat_load = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/loading.png", "noclamp smooth" ),
	mat_settings = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/settings.png", "noclamp smooth" ),
	mat_upgrade_account = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/upgrade_account.png", "noclamp smooth" ),
	
	mat_bank = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/bank_account.png", "noclamp smooth" ),
	mat_crypto_bank = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/crypto_account.png", "noclamp smooth" ),
	mat_no_cryptos = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/no_crypto.png", "noclamp smooth" ),

	mat_deposit = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/deposit.png", "noclamp smooth" ),
	mat_withdraw = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/withdraw.png", "noclamp smooth" ),
	mat_send_money = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/send_money.png", "noclamp smooth" ),
	mat_bank_history = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/history.png", "noclamp smooth" ),
	
	mat_insert_card = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/insert_card.png", "noclamp smooth" ),
	mat_exit_atm = Material( "materials/craphead_scripts/ch_atm/gui/flat_color/exit_atm.png", "noclamp smooth" ),
}

--[[
	Create the clientside convar setting for the ATM icon theme pack
	1 = White outlined
	2 = Gradient
	3 = Flat color
--]]
CreateClientConVar( "ch_atm_theme_setting", "1", true, false, "This setting allows you to change the icon theme for the ATM. It can be an integer between 1 and 3", 1, 3 )

function CH_ATM.GetIconTheme()
	local theme = GetConVar( "ch_atm_theme_setting" ):GetInt()
	
	return theme or 1
end

--[[
	Create the clientside convar setting for the use of cursor or hand cursor
	1 - Cursor
	2- Hand Cursor
--]]
CreateClientConVar( "ch_atm_cursor_setting", "1", true, false, "Setting for cursor or hand cursor. 1 for cursor and 2 for hand cursor.", 1, 2 )

function CH_ATM.GetCursorSetting()
	local theme = GetConVar( "ch_atm_cursor_setting" ):GetInt()
	
	return theme or 1
end