/////////////////////////
// Zeros Secret Stash
// https://www.gmodstore.com/market/view/717344124917481473

zvm.AllowedItems.Add("zss_mine") // Has CustomData

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosSecretStash", function(cEnt, ItemData)
	if zss and ItemData.class == "zss_mine" then
		cEnt:SetSkin(1)
	end
end)
