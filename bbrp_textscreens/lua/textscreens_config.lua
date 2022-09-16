textscreenFonts = {}

if CLIENT then

end

local function addFont(font, t)
	if CLIENT then
		t.size = 100
		surface.CreateFont(font, t)
		t.size = 50
		surface.CreateFont(font .. "_MENU", t)
	end

	table.insert(textscreenFonts, font)
end

--[[
---------------------------------------------------------------------------
Custom fonts - requires server restart to take affect -- "Screens_" will be removed from the font name in spawnmenu
---------------------------------------------------------------------------
--]]



-- Default textscreens font
addFont("Coolvetica outlined", {
	font = "coolvetica",
	weight = 400,
	antialias = true,
	outline = true
})
-- Tahoma
addFont("Tahoma Regular", {
	font = "tahoma",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("Tahoma Outlined", {
	font = "tahoma",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("Tahoma Bold", {
	font = "tahoma",
	weight = 900,
	antialias = true,
	outline = false
})

addFont("Tahoma Bold Outlined", {
	font = "tahoma",
	weight = 900,
	antialias = true,
	outline = true
})
--CoolVetica
addFont("Coolvetica Regular", {
	font = "coolvetica",
	weight = 400,
	antialias = true,
	outline = false
})

-- Chicago

addFont("Chicago", {
	font = "chicago",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("Chicago Outlined", {
	font = "chicago",
	weight = 400,
	antialias = true,
	outline = true
})

-- Chiller

addFont("Chiller", {
	font = "chiller",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("Chiller Outlined", {
	font = "chiller",
	weight = 400,
	antialias = true,
	outline = true
})

-- Impact

addFont("Impact", {
	font = "impact",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("Impact Outlined", {
	font = "impact",
	weight = 400,
	antialias = true,
	outline = true
})

-- Dirty HeadLine

addFont("Dirty Headline", {
	font = "dirty headline",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("Dirty Headline Outlined", {
	font = "dirty headline",
	weight = 400,
	antialias = true,
	outline = true
})

-- Space Age

addFont("Space Age", {
	font = "space age",
	weight = 400,
	antialias = true,
	outline = false
})

-- Conthrax SB

addFont("ConthraxSB", {
	font = "conthraxsb-regular",
	weight = 400,
	antialias = true,
	outline = false
})

-- SpaceRangerTitle

addFont("Space Ranger", {
	font = "space ranger title",
	weight = 400,
	antialias = true,
	outline = false
})

-- Trebuchet
addFont("TrebuchetMS outlined", {
	font = "Trebuchet MS",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("TrebuchetMS", {
	font = "Trebuchet MS",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("TrebuchetMS Bold outlined", {
	font = "Trebuchet MS",
	weight = 900,
	antialias = true,
	outline = true
})

addFont("TrebuchetMS Bold", {
	font = "Trebuchet MS",
	weight = 900,
	antialias = true,
	outline = false
})

-- Arial
addFont("Screens_Arial outlined", {
	font = "Arial",
	weight = 600,
	antialias = true,
	outline = true
})

addFont("Screens_Arial", {
	font = "Arial",
	weight = 600,
	antialias = true,
	outline = false
})

addFont("Screens_Arial Black outlined", {
	font = "Arial Black",
	weight = 600,
	antialias = true,
	outline = true
})

addFont("Screens_Arial Black", {
	font = "Arial Black",
	weight = 600,
	antialias = true,
	outline = false
})

addFont("Screens_Arial Bold outlined", {
	font = "Arial",
	weight = 900,
	antialias = true,
	outline = true
})

addFont("Screens_Arial Bold", {
	font = "Arial",
	weight = 900,
	antialias = true,
	outline = false
})

-- CaptureIt

addFont("DirtyBag", {
	font = "DIRTYBAG BOLD TRIAL",
	weight = 400,
	antialias = true,
	outline = false
})

-- HalfLife2

addFont("HalfLife2 Outlined", {
	font = "HalfLife2",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("HalfLife2", {
	font = "HalfLife2",
	weight = 400,
	antialias = true,
	outline = false
})

-- DIN

addFont("DIN Pro", {
	font = "DINPro-Regular",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("DIN-1451 mittelschrift", {
	font = "DINMittelschriftStd",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("DIN-1451 mittelschrift outlined", {
	font = "DINMittelschriftStd",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("DIN-1451 engschrift", {
	font = "DINEngschriftStd",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("DIN-1451 engschrift outlined", {
	font = "DINEngschriftStd",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("DIN Pro outlined", {
	font = "DINPro-Regular",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("DIN Bold", {
	font = "din-bold",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("DIN Bold outlined", {
	font = "din-bold",
	weight = 400,
	antialias = true,
	outline = true
})


-- BrokenDetroit

addFont("BrokenDetroit", {
	font = "Broken Detroit",
	weight = 400,
	antialias = true,
	outline = false
})

-- Roboto Bk
addFont("Screens_Roboto outlined", {
	font = "Roboto Bk",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("Screens_Roboto", {
	font = "Roboto Bk",
	weight = 400,
	antialias = true,
	outline = false
})

-- Helvetica
addFont("Screens_Helvetica outlined", {
	font = "Helvetica",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("Screens_Helvetica", {
	font = "Helvetica",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("Screens_Helvetica Bold outlined", {
	font = "Helvetica",
	weight = 900,
	antialias = true,
	outline = true
})

addFont("Screens_Helvetica Bold", {
	font = "Helvetica",
	weight = 900,
	antialias = true,
	outline = false
})

-- akbar
addFont("Screens_Akbar outlined", {
	font = "akbar",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("Screens_Akbar", {
	font = "akbar",
	weight = 400,
	antialias = true,
	outline = false
})

-- csd
addFont("Screens_csd outlined", {
	font = "csd",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("Screens_csd", {
	font = "csd",
	weight = 400,
	antialias = true,
	outline = false
})
-- highway
addFont("highway gothic", {
	font = "Highway Gothic",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("highway gothic outlined", {
	font = "Highway Gothic",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("highway gothic exp", {
	font = "highway gothic expanded",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("highway gothic exp outlined", {
	font = "highway gothic expanded",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("highway gothic narrow", {
	font = "Highway Gothic Narrow",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("highway gothic narrow outlined", {
	font = "Highway Gothic Narrow",
	weight = 400,
	antialias = true,
	outline = true
})

addFont("highway gothic wide", {
	font = "Highway Gothic Wide",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("highway gothic wide outlined", {
	font = "Highway Gothic Wide",
	weight = 400,
	antialias = true,
	outline = true
})

-- times new roman

addFont("times new roman", {
	font = "Times New Roman",
	weight = 400,
	antialias = true,
	outline = false
})

addFont("times new roman outlined", {
	font = "Times New Roman",
	weight = 400,
	antialias = true,
	outline = true
})

if CLIENT then

	local function addFonts(path)
		local files, folders = file.Find("resource/fonts/" .. path .. "*", "MOD")

		for k, v in ipairs(files) do
			if string.GetExtensionFromFilename(v) == "ttf" then
				local font = string.StripExtension(v)
				if table.HasValue(textscreenFonts, "Screens_" .. font) then continue end
print("-- "  .. font .. "\n" .. [[
addFont("Screens_ ]] .. font .. [[", {
	font = font,
	weight = 400,
	antialias = true,
	outline = true
})
				]])
			end
		end

		for k, v in ipairs(folders) do
			addFonts(path .. v .. "/")
		end
	end

	concommand.Add("get_fonts", function(ply)
		addFonts("")
	end)

end
