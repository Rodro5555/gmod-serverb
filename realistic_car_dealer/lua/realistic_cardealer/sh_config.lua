RCD = RCD or {}

--[[ If you use mysql you have to activate this and configure the mysql information and restart your server !! ]]
RCD.Mysql = false

--[[ Which rank can have access to the admin configuration ]]
RCD.AdminRank = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["desarrollador"] = true,
}

--[[ Sound for each models ]]
RCD.AccidentModule = {
    ["modelSound"] = { 
        ["models/player/zelpa/male_01_extended.mdl"] = "male",
        ["models/player/zelpa/male_02_extended.mdl"] = "male",
        ["models/player/zelpa/female_01_extended.mdl"] = "female",
        ["models/player/zelpa/female_07_extended.mdl"] = "female",
    },
}

--[[ All colors used on the addon ]]
RCD.Colors = {
    ["black"] = Color(0, 0, 0),
    ["blackpurple"] = Color(23, 20, 35, 245),
    ["black18200"] = Color(18, 30, 42, 200),
    ["black18220"] = Color(18, 30, 42, 220),
    ["grey"] = Color(150, 150, 150),
    ["grey30"] = Color(150, 150, 150, 30),
    ["grey69"] = Color(69, 67, 79, 255),
    ["grey84"] = Color(84, 84, 88, 140),
    ["green97"] = Color(97, 181, 111),
    ["grey10010"] = Color(100, 100, 100, 10),
    ["grey10020"] = Color(100, 100, 100, 20),
    ["grey10050"] = Color(100, 100, 100, 50),
    ["grey134"] = Color(134, 119, 221, 20),
    ["grey187"] = Color(187, 178, -8, 108),
    ["notifycolor"] = Color(54, 140, 220),
    ["purple"] = Color(81, 56, 237),
    ["purple51"] = Color(84, 85, 165, 51),
    ["purple55"] = Color(55, 39, 134),
    ["purple84"] = Color(84, 86, 165),
    ["purple99"] = Color(99, 79, 210),
    ["purple120"] = Color(81, 56, 237, 100),
    ["red"] = Color(255, 0, 0, 255),
    ["red202"] = Color(202, 77, 68),
    ["speedoRed"] = Color(237, 56, 56),
    ["white"] = Color(248, 247, 252),
    ["white0"] = Color(255, 255, 255, 0),
    ["white2"] = Color(248, 247, 252, 2),
    ["white5"] = Color(248, 247, 252, 5),
    ["white20"] = Color(248, 247, 252, 10),
    ["white30"] = Color(248, 247, 252, 5),
    ["white80"] = Color(248, 247, 252, 80),
    ["white80248"] = Color(248, 247, 252, 80),
    ["white100"] = Color(248, 247, 252, 100),
    ["white120"] = Color(248, 247, 252, 120),
    ["white200"] = Color(248, 247, 252, 200),
    ["white200255"] = Color(200, 200, 200),
    ["white220"] = Color(255, 255, 255, 220),
    ["white250250"] = Color(250, 250, 250),
    ["white255200"] = Color(255, 255, 255, 200),
    ["white255"] = Color(255, 255, 255, 255),
    ["yellow"] = Color(183, 158, 55, 255),
}

RCD.UnitConvertion = {
    ["mph"] = 0.0568182, -- [[ Unit convertion to the mph ]]
    ["kmh"] = 0.09144, -- [[ Unit convertion to the kmh ]]
}

--[[ You can add more currency here ]]
RCD.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end
}
