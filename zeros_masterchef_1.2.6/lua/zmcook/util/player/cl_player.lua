if SERVER then return end

zclib.Hook.Add("zclib_PlayerInitialized", "zmc_zclib_PlayerInitialized", function()

    timer.Simple(3, function()
        if not IsValid(LocalPlayer()) then return end

		// Force translate buildkist items
		for k,v in pairs(zmc.config.Buildkit.List) do
			if v and v.name then
				v.name = zmc.Buildkit.GetName(k)
			end
		end

		// Force translate items
		for k,v in pairs(zmc.config.Items) do
			if v and v.name then
				v.name = zmc.Item.GetName(k)
			end
		end

		// Force translate items
		for k,v in pairs(zmc.config.Dishs) do
			if v and v.name then
				v.name = zmc.Dish.GetName(k)
			end
		end
    end)
end)
