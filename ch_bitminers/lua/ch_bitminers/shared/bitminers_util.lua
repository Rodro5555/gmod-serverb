local PMETA = FindMetaTable( "Player" )

--[[
	Meta function to get max miners for a player
--]]
function PMETA:CH_BITMINERS_GetMaxMiners()
	local max_miners = 16

	for k, v in pairs( CH_Bitminers.Config.MaxBitminersInstalled ) do
		if serverguard then
			if v.UserGroup == serverguard.player:GetRank( self ) then
				return v.MaxBitminers
			end
		else
			if v.UserGroup == self:GetUserGroup() then
				return v.MaxBitminers
			end
		end
	end

	return max_miners
end

--[[
	Language functions
--]]
local function CH_Bitminers_GetLang()
	local lang = CH_Bitminers.Config.Language or "en"

	return lang
end

function CH_Bitminers.LangString( text )
	local translation = text .." (Translation missing)"
	
	if CH_Bitminers.Config.Lang[ text ] then
		translation = CH_Bitminers.Config.Lang[ text ][ CH_Bitminers_GetLang() ]
	end
	
	return translation
end