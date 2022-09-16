CarePackage.Languages = CarePackage.Languages or {}

function CarePackage:CreateLanguage(name, tbl)
	self.Languages[name] = tbl
end

function CarePackage:GetPhrase(phrase, replacement)
	local str = self.Languages[CarePackage.Config.Language][phrase] or "No Phrase"

	if (replacement) then
		for i, v in pairs(replacement) do
			str = str:Replace(":" .. i .. ":", v)
		end
	end

	return str
end