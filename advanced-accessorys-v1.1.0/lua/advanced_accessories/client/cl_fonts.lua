function AAS.LoadFonts(itemNameScale)
	surface.CreateFont( "AAS:Font:01", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.034,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:02", {
		font = "Segoe UI",
		extended = false,
		size = isnumber(itemNameScale) and itemNameScale or AAS.ScrH*0.026,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:03", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.02,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:04", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.022,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:05", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.024,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:06", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.03,
		weight = 600, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:07", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.025,
		weight = 500, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:08", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.12,
		weight = 600, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:09", {
		font = "Segoe UI",
		extended = false,
		size = AAS.ScrH*0.08,
		weight = 600, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:10", {
		font = "Lato Black",
		extended = false,
		size = AAS.ScrH*0.02,
		weight = 600, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:11", {
		font = "Lato Black",
		extended = false,
		size = AAS.ScrH*0.02,
		weight = 600, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( "AAS:Font:12", {
		font = "Lato Black",
		extended = false,
		size = AAS.ScrH*0.025,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
end