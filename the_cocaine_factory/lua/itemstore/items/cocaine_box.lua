ITEM.Name = "Drug Holder"
ITEM.Description = "Contains all your packed cocaine."
ITEM.Model = "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetDescription()
	local coco_amount = self:GetData("BoxAmount")
	
	local desc = "Contains ".. coco_amount .." packs of cocaine"

	return self:GetData( "Description", desc )
end

function ITEM:SaveData( ent )
	self:SetData( "BoxAmount", ent.BoxCocaineAmount )
	self:SetData( "BoxIsClosed", ent.IsClosed )
	
	local box_owner = ent:CPPIGetOwner()
	self:SetData( "BoxOwner", box_owner )
end

function ITEM:LoadData(ent)
	timer.Simple( 0.1,function()
		if IsValid( ent ) then
			ent.BoxCocaineAmount = self:GetData( "BoxAmount" )
			ent.IsClosed = self:GetData( "BoxIsClosed" )
			
			if ent.IsClosed then
				ent:SetBodygroup( 1, 1 )
				ent.IsClosed = true
			else
				ent:SetBodygroup( 1, 0 )
				ent.IsClosed = false
			end
			
			ent:SetBodygroup( 2, ent.BoxCocaineAmount )
			
			ent:CPPISetOwner( self:GetData( "BoxOwner" ) )
		end
	end )
end