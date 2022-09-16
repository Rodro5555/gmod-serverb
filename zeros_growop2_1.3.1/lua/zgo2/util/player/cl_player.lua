
zclib.Hook.Add("zclib_PlayerInitialized", "zgo2_zclib_PlayerInitialized", function()

	// NOTE This is really important since we only can build the materials once the draw function of the client is running
	timer.Simple(1,function()

		// Lets preload some fancy images which can be used for the ScreenEffect later
		zclib.Imgur.GetMaterial("7MWdbsI", function(result) end)
		zclib.Imgur.GetMaterial("a28XrS6", function(result) end)
		zclib.Imgur.GetMaterial("qlBMyAB", function(result) end)
		zclib.Imgur.GetMaterial("dD44NaU", function(result) end)
		zclib.Imgur.GetMaterial("SJNDvNB", function(result) end)
		zclib.Imgur.GetMaterial("8SXjP1Y", function(result) end)
		zclib.Imgur.GetMaterial("6QtEPYP", function(result) end)
		zclib.Imgur.GetMaterial("Xvd21ZO", function(result) end)
		zclib.Imgur.GetMaterial("TMbL3hA", function(result) end)
		zclib.Imgur.GetMaterial("9vesYIc", function(result) end)
		zclib.Imgur.GetMaterial("p8hx90B", function(result) end)
		zclib.Imgur.GetMaterial("7BKe2Tt", function(result) end)
		zclib.Imgur.GetMaterial("xizvhL7", function(result) end)
		zclib.Imgur.GetMaterial("kX4KPrQ", function(result) end)

		zgo2.Print("PreBuild Bong Skins")
		timer.Simple(0.2,function()
			for k, v in pairs(zgo2.config.Bongs) do
				local data = zgo2.Bong.VerifyData(v)
				zgo2.config.Bongs[k] = data

				// Predownload the imgur images
				zclib.Imgur.GetMaterial(tostring(data.style.url), function(result)
					zgo2.Bong.RebuildMaterial(data)
				end)
			end
		end)

		timer.Simple(0.4,function()
			// Send the player the default plants
			for k, v in pairs(zgo2.Plant.GetAll()) do

				local data = zgo2.Plant.VerifyData(v)

				// Build normal plant materials
				zgo2.Plant.RebuildMaterial(data)

				timer.Simple(0,function()
					// Build dried plant materials
					zgo2.Plant.RebuildMaterial(data,false,true)
				end)

				// Download ScreenEffect BaseTexture
				zclib.Imgur.GetMaterial(tostring(data.screeneffect.basetexture_url), function()

					// Download ScreenEffect refract texture
					zclib.Imgur.GetMaterial(tostring(data.screeneffect.refract_url), function()

						zgo2.ScreenEffect.RebuildMaterial(data)
					end)
				end)

				if data.screeneffect.audio_music and data.screeneffect.audio_music ~= "" then
					zgo2.ScreenEffect.SetMusic(data,data.screeneffect.audio_music)
				end
			end
		end)

		timer.Simple(0.6,function()
			for k, v in pairs(zgo2.config.Pots) do

				local data = zgo2.Pot.VerifyData(v)

				zgo2.config.Pots[k] = data

				// Predownload the imgur images
				zclib.Imgur.GetMaterial(tostring(data.style.url), function(result)
					zgo2.Pot.RebuildMaterial(data)
				end)
			end
		end)

		timer.Simple(5,function()
			LocalPlayer().zgo2_Initialized = true
			zgo2.Print("Fully Initialized!")
		end)
	end)
end)
