-- Shared Utils
--[[
	Language functions
--]]
local function CH_ATM_GetLang()
	local lang = CH_ATM.Config.Language or "en"

	return lang
end

function CH_ATM.LangString( text )
	local translation = text .." (Translation missing)"
	
	if CH_ATM.Config.Lang[ text ] then
		translation = CH_ATM.Config.Lang[ text ][ CH_ATM_GetLang() ]
	end
	
	return translation
end

--[[
	Get account holding
--]]
function CH_ATM.GetMoneyBankAccount( ply )
	return ply.CH_ATM_BankAccount
end

--[[
	Get account level
--]]
function CH_ATM.GetAccountLevel( ply )
	return ply.CH_ATM_BankAccountLevel
end

--[[
	Get account interest rate
--]]
function CH_ATM.GetAccountFixedInterestRate( ply )
	return CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].InterestRate
end

function CH_ATM.GetAccountInterestRate( ply )
	return ply.CH_ATM_InterestRate
end

--[[
	Get account max amount of money
--]]
function CH_ATM.GetAccountMaxMoney( ply )
	return CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].MaxMoney
end

--[[
	Get account max interest to earn
--]]
function CH_ATM.GetMaxInterestToEarn( ply )
	return CH_ATM.Config.AccountLevels[ CH_ATM.GetAccountLevel( ply ) ].MaxInterestToEarn
end

--[[
	A range of currency functions
--]]
local function CH_ATM_GetCurrency()
	return CH_ATM.Config.ATMCurrency or "darkrp"
end

function CH_ATM.AddMoney( ply, amount )
	CH_ATM.Currencies[ CH_ATM_GetCurrency() ].AddMoney( ply, amount )
end

function CH_ATM.TakeMoney( ply, amount )
	CH_ATM.Currencies[ CH_ATM_GetCurrency() ].TakeMoney( ply, amount )
end

function CH_ATM.GetMoney( ply )
	return CH_ATM.Currencies[ CH_ATM_GetCurrency() ].GetMoney( ply )
end

function CH_ATM.CanAfford( ply, amount )
	return CH_ATM.Currencies[ CH_ATM_GetCurrency() ].CanAfford( ply, amount )
end

function CH_ATM.FormatMoney( amount )
	return CH_ATM.Currencies[ CH_ATM_GetCurrency() ].FormatMoney( amount )
end

function CH_ATM.CurrencyAbbreviation()
	return CH_ATM.Currencies[ CH_ATM_GetCurrency() ].CurrencyAbbreviation()
end