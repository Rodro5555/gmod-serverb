RCD.ScrW, RCD.ScrH = ScrW(), ScrH()

function RCD.LoadFonts()
	surface.CreateFont("RCD:Font:01", {
		font = "Georama Black",
		extended = false,
		size = RCD.ScrH*0.07,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:02", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.07,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:03", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.035,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:04", {
		font = "Georama Black",
		extended = false,
		size = RCD.ScrH*0.022,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:05", {
		font = "Georama",
		extended = false,
		size = RCD.ScrH*0.049,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:06", {
		font = "Georama Medium",
		extended = false,
		size = RCD.ScrH*0.02,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:07", {
		font = "Georama Medium",
		extended = false,
		size = RCD.ScrH*0.018,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:08", {
		font = "Georama Medium",
		extended = false,
		size = RCD.ScrH*0.015,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:09", {
		font = "Georama",
		extended = false,
		size = RCD.ScrH*0.025,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
		italic = false
	})

	surface.CreateFont("RCD:Font:10", {
		font = "Georama Black",
		extended = false,
		size = RCD.ScrH*0.04,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:11", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.025,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:12", {
		font = "Georama",
		extended = false,
		size = RCD.ScrH*0.026,
		italic = false,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:13", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.026,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:17", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.02,
		italic = false,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:18", {
		font = "Georama Medium",
		extended = false,
		size = RCD.ScrH*0.026,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:19", {
		font = "Georama Medium",
		extended = false,
		size = 165,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:21", {
		font = "Georama Bold",
		extended = false,
		size = RCD.ScrH*0.018,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:22", {
		font = "Georama Bold",
		extended = false,
		size = RCD.ScrH*0.12,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:23", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.03,
		italic = true,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:24", {
		font = "Georama Bold",
		extended = false,
		size = RCD.ScrH*0.025,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:25", {
		font = "Georama Bold",
		extended = false,
		size = RCD.ScrH*0.049,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:26", {
		font = "Georama Bold",
		extended = false,
		size = RCD.ScrH*0.028,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:27", {
		font = "Scriptina",
		extended = false,
		size = RCD.ScrH*0.08,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:28", {
		font = "Georama Bold",
		extended = false,
		size = RCD.ScrH*0.02,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD:Font:29", {
		font = "Georama Light",
		extended = false,
		size = RCD.ScrH*0.028,
		italic = false,
		weight = 0, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont("RCD3D:Font:01", {
		font = "Georama Black",
		extended = false,
		size = 200,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	
	surface.CreateFont("RCD3D:Font:02", {
		font = "Georama Light",
		extended = false,
		size = 200,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		italic = true,
		antialias = true,
	})	

	surface.CreateFont("RCD3D:Font:03", {
		font = "Georama Medium",
		extended = false,
		size = 100,
		weight = 0,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	
	surface.CreateFont("RCD3D:Font:04", {
		font = "Georama Medium",
		extended = false,
		size = 100,
		italic = false,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	
	surface.CreateFont("RCD3D:Font:05", {
		font = "Georama Light",
		extended = false,
		size = 70,
		italic = false,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	
	surface.CreateFont("RCD3D:Font:06", {
		font = "Georama Light",
		extended = false,
		size = 50,
		italic = false,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
end
RCD.LoadFonts()