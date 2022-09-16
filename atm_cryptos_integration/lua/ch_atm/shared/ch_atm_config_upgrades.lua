--[[
	Bank Account Levels Config
	InterestRate = How much percentage of the players bank account to give in interest rates.
	MaxInterestToEarn = How much can a player maximum earn in interest per interval? Set to 0 to disable the max
	MaxMoney = How much money can the players bank account maximum hold? 0 for unlimited.
	UpgradePrice = How much much does it cost the player to upgrade to this level?
	
	NOTE: The first one [ 1 ] is the default level.
--]]
CH_ATM.Config.AccountLevels = {
	[ 1 ] = {
		InterestRate = 0.10,
		MaxInterestToEarn = 1000,
		MaxMoney = 1000000,
		UpgradePrice = 0,
	},
	[ 2 ] = {
		InterestRate = 0.25,
		MaxInterestToEarn = 2000,
		MaxMoney = 2000000,
		UpgradePrice = 10000,
	},
	[ 3 ] = {
		InterestRate = 0.50,
		MaxInterestToEarn = 3000,
		MaxMoney = 3000000,
		UpgradePrice = 15000,
	},
	[ 4 ] = {
		InterestRate = 0.75,
		MaxInterestToEarn = 4000,
		MaxMoney = 4000000,
		UpgradePrice = 20000,
	},
	[ 5 ] = {
		InterestRate = 1.00,
		MaxInterestToEarn = 5000,
		MaxMoney = 5000000,
		UpgradePrice = 25000,
	},
	[ 6 ] = {
		InterestRate = 1.25,
		MaxInterestToEarn = 6000,
		MaxMoney = 6000000,
		UpgradePrice = 30000,
	},
	[ 7 ] = {
		InterestRate = 1.50,
		MaxInterestToEarn = 7000,
		MaxMoney = 7000000,
		UpgradePrice = 35000,
	},
	[ 8 ] = {
		InterestRate = 1.75,
		MaxInterestToEarn = 8000,
		MaxMoney = 8000000,
		UpgradePrice = 40000,
	},
	[ 9 ] = {
		InterestRate = 2.00,
		MaxInterestToEarn = 9000,
		MaxMoney = 9000000,
		UpgradePrice = 45000,
	},
	[ 10 ] = {
		InterestRate = 2.50,
		MaxInterestToEarn = 10000,
		MaxMoney = 0,
		UpgradePrice = 50000,
	},
}