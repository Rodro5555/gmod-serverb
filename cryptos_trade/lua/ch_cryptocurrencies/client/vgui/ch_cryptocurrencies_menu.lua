CH_CryptoCurrencies.Colors = CH_CryptoCurrencies.Colors or {}
CH_CryptoCurrencies.Materials = CH_CryptoCurrencies.Materials or {}

--[[
	Cache materials
--]]
CH_CryptoCurrencies.Materials.CloseIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/close.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.BackIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/arrowbtn.png", "noclamp smooth" )

CH_CryptoCurrencies.Materials.WavingHand = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/waving_hand.png", "noclamp smooth" )

CH_CryptoCurrencies.Materials.ArrowUpIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/increase.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.ArrowDownIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/decrease.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.ArrowExchangeIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/arrow_exchange.png", "noclamp smooth" )

CH_CryptoCurrencies.Materials.MenuDashboard = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/dashboard.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.MenuCryptos = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/browse_crypto.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.MenuPortfolio = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/crypto_portfolio.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.MenuTransactions = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/crypto_history.png", "noclamp smooth" )

--[[
	Cache colors
--]]
CH_CryptoCurrencies.Colors.GrayBG = Color( 30, 30, 30, 255 )
CH_CryptoCurrencies.Colors.GrayFront = Color( 22, 22, 22, 255 )

CH_CryptoCurrencies.Colors.Green = Color( 52, 178, 52, 255 )
CH_CryptoCurrencies.Colors.Red = Color( 201, 29, 29, 255 )
CH_CryptoCurrencies.Colors.WhiteAlpha = Color( 255, 255, 255, 5 )
CH_CryptoCurrencies.Colors.WhiteAlpha2 = Color( 255, 255, 255, 100 )
CH_CryptoCurrencies.Colors.GMSBlue = Color( 52, 152, 219, 255 )

CH_CryptoCurrencies.Colors.DarkGray = Color( 22, 22, 22, 255 )
CH_CryptoCurrencies.Colors.LightGray = Color( 30, 30, 30, 255 )

CH_CryptoCurrencies.Colors.GreenHovered = Color( 0, 150, 0, 255 )

CH_CryptoCurrencies.Colors.RedHovered = Color( 150, 0, 0, 255 )
CH_CryptoCurrencies.Colors.RedAlpha = Color( 150, 0, 0, 70 )

CH_CryptoCurrencies.Colors.Invisible = Color( 0, 0, 0, 0 )

--[[
	Net message to show crypto menu
--]]
net.Receive( "CH_CryptoCurrencies_ShowCryptoMenu", function( len, ply )
	if CH_CryptoCurrencies.Config.StartMenuOnPopup == 1 then
		CH_CryptoCurrencies.DashboardMenu()
	elseif CH_CryptoCurrencies.Config.StartMenuOnPopup == 2 then
		CH_CryptoCurrencies.CryptoMenu()
	elseif CH_CryptoCurrencies.Config.StartMenuOnPopup == 3 then
		CH_CryptoCurrencies.PortfolioMenu()
	elseif CH_CryptoCurrencies.Config.StartMenuOnPopup == 4 then
		CH_CryptoCurrencies.TransactionsMenu()
	end
end )