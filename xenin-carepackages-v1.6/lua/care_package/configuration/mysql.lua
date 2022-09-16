-- This is for MySQL if you want to enable it
-- It should explain itself, if not this is the same way DarkRP formats it

CarePackage.Config.MySQL = {}

CarePackage.Config.MySQL.EnableMySQL = false
CarePackage.Config.MySQL.Host = "127.0.0.1"
CarePackage.Config.MySQL.Username = "root"
CarePackage.Config.MySQL.Password = ""
CarePackage.Config.MySQL.Database_name = "darkrp"
CarePackage.Config.MySQL.Database_port = 3306
CarePackage.Config.MySQL.module = "mysqloo"
CarePackage.Config.MySQL.MultiStatements = false

if (CarePackage.FinishedLoading) then
	XCPMySQLite.initialize(CarePackage.Config.MySQL)
end