/*

	A bunch of hooks to modify certain aspects

*/

if SERVER then
	/*
		Called once a player sells weed on a marketplace
	*/
	hook.Add("zgo2.Marketplace.OnCargoSold","zgo2.Marketplace.OnCargoSold.test",function(ply,MarketplaceID,cargo_name,cargo_amount,cargo_value,cargo_data)

	end)

	/*
		Called once a player sells weed to the npc
	*/
	hook.Add("zgo2.NPC.OnQuickSell","zgo2.NPC.OnQuickSell.test",function(ply,weed_id,weed_amount,weed_value)

	end)

	/*
		Called once a player buys something from the multitool
	*/
	hook.Add("zgo2.Shop.OnPurchase","zgo2.Shop.OnPurchase.test",function(ply,data)

	end)

	/*
		Called once a player sells something using the multitool
	*/
	hook.Add("zgo2.Shop.OnSell","zgo2.Shop.OnSell.test",function(ply,data,price)

	end)
end

if CLIENT then
	/*
		Called once a marketplace receives the players cargo
	*/
	hook.Add("zgo2.Marketplace.OnCargoUpdate","zgo2.Marketplace.OnCargoUpdate.Test",function(MarketplaceID)

	end)

	/*
		Called once a transfer got succesfully created
	*/
	hook.Add("zgo2.Marketplace.OnTransferCreated","zgo2.Marketplace.OnTransferCreated.Test",function(TransferID)

	end)
end
