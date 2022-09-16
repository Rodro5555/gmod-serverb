--MayorVoting System Fonts
local function LoadMayorVotingFonts()
if VOTING.FontsLoaded then return end
surface.CreateFont("Bebas24Font", {font = "Bebas Neue", size= 24, weight = 400, antialias = true } )
surface.CreateFont("Bebas40Font", {font = "Bebas Neue", size= 40, weight = 400, antialias = true } )
surface.CreateFont("Bebas70Font", {font = "Bebas Neue", size= 70, weight = 400, antialias = true } ) --Font used for titles

surface.CreateFont("OpenSans18Font", {font = "Open Sans Condensed", size= 18, weight = 400, antialias = true } ) --Font used for vote ticker
VOTING.FontsLoaded = true
end
LoadMayorVotingFonts()
hook.Add("InitPostEntity", "VOTING_InitPostLoadFonts", LoadMayorVotingFonts)