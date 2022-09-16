CH_CryptoCurrencies = CH_CryptoCurrencies or {}
CH_CryptoCurrencies.Config = CH_CryptoCurrencies.Config or {}
CH_CryptoCurrencies.Currencies = CH_CryptoCurrencies.Currencies or {}

--[[
	Language Config
	English: en - Danish: da - French: fr - Spanish: es - Polish: pl - Russian: ru
--]]
CH_CryptoCurrencies.Config.Language = "es" -- Set the language of the script.

--[[
	Default Config
--]]
CH_CryptoCurrencies.Config.NotificationTime = 8 -- Amount of seconds to show notifications
CH_CryptoCurrencies.Config.DistanceTo3D2D = 50000 -- Distance between the player and the 3d2d to draw

CH_CryptoCurrencies.Config.UseCryptoNPC = true -- Should the crypto NPC spawn? It allows for opening the crypto menu.
CH_CryptoCurrencies.Config.UseCryptoChatCommand = true -- Should the chat command be enabled to open the crypto menu?
CH_CryptoCurrencies.Config.CryptoMenuChatCommand = "!cryptos" -- If enabled then this is the chat command to open the crypto menu.

CH_CryptoCurrencies.Config.FetchConsolePrints = false -- If you want to disable the fetch crypto console prints then you can set this to false.

CH_CryptoCurrencies.Config.StartMenuOnPopup = 1 -- Which tab of the menu should it start on? 1 = dashboard 2 = cryptos 3 = portfolio 4 = transactions

--[[
	MySQLOO
	If you want to use MySQLOO then enable this config.
	Then go to lua/ch_cryptocurrencies/server/mysql/mysql_connect.lua and type in your sql credentials.
--]]
CH_CryptoCurrencies.Config.EnableSQL = false -- Enable or disable using SQL.

--[[
	Currency
	What currency do we use to trade crypto with?
	Supported currencies: darkrp, sh_pointshop, sh_pointshop_premium, basewars, helix, mtokens, bricks_credit_store, pointshop2, pointshop2_premium, santosrp, underdone
	
	Coinbase Rates Currency
	What currency do we use to get the exchange rates for the cryptocurrencies?
	Popular ones are USD, EUR and GBP
	You can get a full list here https://api.coinbase.com/v2/currencies - Currency codes will conform to the ISO 4217 standard where possible
--]]
CH_CryptoCurrencies.Config.TradeCurrency = "darkrp"

CH_CryptoCurrencies.Config.ExchangeRateCurrency = "USD"

--[[
	Transaction History
	If you have SQL enabled then players can view their buy/sell history through the in-game menu.
    It will show their last buy and sell transactions.
--]]
CH_CryptoCurrencies.Config.MaximumTransactionsToShow = 10 -- How many transactions should we network and list to the player in the menu?

--[[
	Fetch Cryptocurrencies Config
	This is done as efficient as possible in terms of networking to clients, but don't make it too frequent as it does network to every player online.
	It also really depends how many cryptocurrencies you have added to your configuration.
--]]
CH_CryptoCurrencies.Config.FetchCryptosInterval = 300 -- Seconds between updating cryptocurrencies via the API. (Default 5 minutes)
CH_CryptoCurrencies.Config.NotifyPlayersChatFetch = true -- Should players be notified in chat when the cryptocurrencies prices are updated?

--[[
	ATM Support
	Requires https://www.gmodstore.com/market/view/atm
--]]
CH_CryptoCurrencies.Config.UseMoneyFromBankAccount = true -- If you own the addon you can use your bank account to buy/sell cryptocurrencies.