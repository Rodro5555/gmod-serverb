zrmine = zrmine or {}
zrmine.f = zrmine.f or {}


// List of all the zrms Entities on the server
if zrmine.EntList == nil then
	zrmine.EntList = {}
end

function zrmine.f.EntList_Add(ent)
	table.insert(zrmine.EntList, ent)
end
