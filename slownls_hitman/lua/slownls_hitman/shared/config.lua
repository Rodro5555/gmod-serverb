--[[  
    Addon: Hitman
    By: SlownLS
]]

SlownLS.Hitman = SlownLS.Hitman or {}
SlownLS.Hitman.Config = SlownLS.Hitman.Config or {}

-- Language of the script
SlownLS.Hitman.Config.Language = "es"

-- Enable the FastDL for the models and materials ?
SlownLS.Hitman.Config.FastDL = true 

-- Model of the phone booth
SlownLS.Hitman.Config.PhoneBoothModel = "models/props_equipment/phone_booth.mdl" 

-- Hitman jobs
SlownLS.Hitman.Config.Jobs = {
    ['Hitman'] = true,
}

-- Jobs can't make contract
SlownLS.Hitman.Config.BlackList = {
    ['Civil Protection'] = true,
}

-- Description configuration (contract)
SlownLS.Hitman.Config.Verifications = {
    description = {
        required = false,
        min = 1, // Minimum length of the description
        max = 200, // Maxium length of the description
    },
    price = {
        min = 100, // Minimum price of the contract
        max = 25000, // Maximum price of the contract
    }
}


SlownLS.Hitman.Config.XP = {
    ['Completed'] = 70,
    ['Sent'] = 30,
    ['Accepted'] = 0,
}

-- Time to finish the contract (in seconds)
SlownLS.Hitman.Config.Time = 60 * 5 // 0 to disable

-- Hitman panel
SlownLS.Hitman.Config.Panel = {
    showJob = true, -- Display the victim job
    showDistance = true, -- Display the distance between the hitman and the victim
}

--  Appearance of the menus
SlownLS.Hitman.Config.Colors = {
    primary = Color(32,32,32),
    secondary = Color(36,36,36),
    
    blue = Color(41,128,185),

    red = Color(190,71,71),
    red2 = Color(255,0,0),

    green = Color(29, 131, 72),
    green2 = Color(0,255,0),

    text = Color(188,188,188),
    outline = Color(44,44,44),
}
