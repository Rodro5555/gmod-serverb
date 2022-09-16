zvm = zvm or {}
zvm.AllowedItems = zvm.AllowedItems or {}

function zvm.AllowedItems.Add(class)
	table.insert(zvm.config.Vendingmachine.AllowedItems,class)
end
