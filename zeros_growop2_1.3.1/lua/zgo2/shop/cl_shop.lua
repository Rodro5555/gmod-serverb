zgo2 = zgo2 or {}
zgo2.Shop = zgo2.Shop or {}

/*
	Called from the server to tell the client what category and itemid this entity is bound to
*/
net.Receive("zgo2.Shop.Update", function(len,ply)
    zclib.Debug_Net("zgo2.Shop.Update", len)

	local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	if not ent:IsValid() then return end

	local price = net.ReadUInt(32)
	if not price then return end

	ent.zgo2_shop_price = price
end)
