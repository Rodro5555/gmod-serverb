surface.CreateFont("MMF_GuideTitle", {
    font = "Caslon Antique",
    size = ScrW() > 1024 and 60 or 30,
    weight = 500,
    antialias = true,
})

surface.CreateFont("MMF_GuideDescription", {
    font = "Caslon Antique",
    size = ScrW() > 1024 and 30 or 15,
    weight = 300,
    antialias = true,
})