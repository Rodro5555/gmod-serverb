-- CRYPTO CURRENCIES BY CRAP-HEAD
-- This will overwrite the bitcoin rate used in this addon.
-- It will also withdraw your mined bitcoins to your crypto wallet instead of paying out in darkrp money immediately.
-- ONLY ENABLE THIS IF YOU OWN https://www.gmodstore.com/market/view/718716878256570370
CH_Bitminers.Config.IntegrateCryptoCurrencies = true

-- Which crypto should we mine by default? It's important that you have this in your cryptos configuration!
CH_Bitminers.Config.DefaultCryptoToMine = "BTC"

-- How many dollars should we mine on each interval in USD?
-- This will be converted to the respective crypto that we're mining.
CH_Bitminers.Config.IntegrateCryptoDefaultMinedPer = 100

-- How many USD are mined on each interval based on their usergroup.
-- This will be converted to the respective crypto that we're mining.
CH_Bitminers.Config.IntegrateCryptoMinedPer = {
	{ Usergroup = "vipinicial", MinedPerInterval = 200 },
	{ Usergroup = "vipgiant", MinedPerInterval = 250 },
	{ Usergroup = "viplegend", MinedPerInterval = 300 },
	{ Usergroup = "vipblackblood", MinedPerInterval = 400 },
}