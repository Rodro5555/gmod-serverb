-- Shared Utils
--[[
	Language functions
--]]
local function CH_CryptoCurrencies_GetLang()
	local lang = CH_CryptoCurrencies.Config.Language or "en"

	return lang
end

function CH_CryptoCurrencies.LangString( text )
	local translation = "Missing translation"
	
	if CH_CryptoCurrencies.Config.Lang[ text ] then
		translation = CH_CryptoCurrencies.Config.Lang[ text ][ CH_CryptoCurrencies_GetLang() ]
	end
	
	return translation
end

--[[
	A range of currency functions
--]]
local function CH_CryptoCurrencies_GetCurrency()
	return CH_CryptoCurrencies.Config.TradeCurrency or "darkrp"
end

function CH_CryptoCurrencies.AddMoney( ply, amount )
	CH_CryptoCurrencies.Currencies[ CH_CryptoCurrencies_GetCurrency() ].AddMoney( ply, amount )
end

function CH_CryptoCurrencies.TakeMoney( ply, amount )
	CH_CryptoCurrencies.Currencies[ CH_CryptoCurrencies_GetCurrency() ].TakeMoney( ply, amount )
end

function CH_CryptoCurrencies.GetMoney( ply )
	return CH_CryptoCurrencies.Currencies[ CH_CryptoCurrencies_GetCurrency() ].GetMoney( ply )
end

function CH_CryptoCurrencies.CanAfford( ply, amount )
	return CH_CryptoCurrencies.Currencies[ CH_CryptoCurrencies_GetCurrency() ].CanAfford( ply, amount )
end

function CH_CryptoCurrencies.FormatMoney( amount )
	return CH_CryptoCurrencies.Currencies[ CH_CryptoCurrencies_GetCurrency() ].FormatMoney( amount )
end

function CH_CryptoCurrencies.CurrencyAbbreviation()
	return CH_CryptoCurrencies.Currencies[ CH_CryptoCurrencies_GetCurrency() ].CurrencyAbbreviation()
end