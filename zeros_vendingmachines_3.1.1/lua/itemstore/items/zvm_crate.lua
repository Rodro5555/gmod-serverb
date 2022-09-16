ITEM.Name = "Vendingmachine Package"
ITEM.Description = "A package from the Vendingmachine."
ITEM.Model = "models/zerochain/props_vendingmachine/zvm_package.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()

	local _content = self:GetData("Content")

	local desc = ""

	for k, v in pairs(_content) do
		desc = desc .. v.name .. ", "
	end

	return self:GetData("Description", desc)
end

function ITEM:SaveData(ent)
	self:SetData("Content", ent.Content)
end

function ITEM:LoadData(ent)
	timer.Simple(0.1,function()
		if IsValid(ent) then
			ent.Content = {}
			table.CopyFromTo(self:GetData("Content"), ent.Content)
		end
	end)
end

function ITEM:Drop(ply, container,slot,ent)
	if not IsValid(ent) then return end
	if zvm.Player.GetPackageCount(ply) >= zvm.config.Vendingmachine.PackageLimit then
		ent.Content = {}
		table.CopyFromTo(self:GetData("Content"), ent.Content)
		ply:PickupItem( ent )
		zclib.Notify(ply, zvm.language.General["BuyLimitReached"], 1)
	else
		zvm.Player.AddPackage(ply,ent)
		ent:SetPos(ent:GetPos() + Vector(0,0,20))
		zclib.Player.SetOwner(ent, ply)
	end
end


function ITEM:CanPickup(ply, ent)
	if ent.IsOpening == true or ent.Wait == true then
		return false
	else
		return true
	end
end
