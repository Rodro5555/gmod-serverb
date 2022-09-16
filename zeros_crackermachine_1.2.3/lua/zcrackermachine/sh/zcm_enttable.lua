zcm = zcm or {}
zcm.f = zcm.f or {}

// List of all the zcm Entities on the server and Client
zcm.EntList = zcm.EntList or {}

function zcm.f.EntList_Add(ent)
	table.insert(zcm.EntList, ent)
end

function zcm.f.EntList_Remove(ent)
	table.RemoveByValue(zcm.EntList,ent)
end
