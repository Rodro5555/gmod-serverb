CH_CryptoCurrencies.Config.Currencies = CH_CryptoCurrencies.Config.Currencies or {}

local function CH_CryptoCurrencies_AddCrypto( crypto_info )
	table.insert( CH_CryptoCurrencies.Config.Currencies, crypto_info )
end

--[[
	You can add new cryptos below this line!
	I have written a guideline on how to do it. So please read this first before editing this file.
	https://www.gmodstore.com/help/addon/718716878256570370/configuring/topics/adding-or-editing-cryptocurrencies
--]]

CH_CryptoCurrencies_AddCrypto( {
	Currency = "BTC",
	Name = "Bitcoin",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/btc.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ETH",
	Name = "Ethereum",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/eth.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "LTC",
	Name = "Litecoin",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/ltc.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "DOT",
	Name = "Polkadot",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/dot.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "DOGE",
	Name = "Dogecoin",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/doge.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "XLM",
	Name = "Stellar",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/xlm.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ADA",
	Name = "Cardano",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/ada.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "USDT",
	Name = "Tether",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/usdt.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "BCH",
	Name = "Bitcoin Cash",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/bch.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "SOL",
	Name = "Solana",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/sol.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "USDC",
	Name = "USD Coin",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/usdc.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ATOM",
	Name = "Cosmos",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/atom.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "AVAX",
	Name = "Avalanche",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/avax.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "MATIC",
	Name = "Polygon",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/matic.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "LINK",
	Name = "Binance Chainlink",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/link.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "WBTC",
	Name = "Wrapped Bitcoin",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/wbtc.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "UNI",
	Name = "Uniswap",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/uni.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ALGO",
	Name = "Algorand",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/algo.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ETH2",
	Name = "Ethereum 2",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/eth2.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ETC",
	Name = "Ethereum Classic",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/etc.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ICP",
	Name = "Internet Computer",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/icp.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "GALA",
	Name = "Gala",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/gala.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "EOS",
	Name = "EOS",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/eos.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "ENJ",
	Name = "Enjin Coin",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/enj.png",
} )

CH_CryptoCurrencies_AddCrypto( {
	Currency = "AXS",
	Name = "Axie Infinity",
	Icon = "materials/craphead_scripts/ch_cryptocurrencies/gui/cryptos/axs.png",
} )