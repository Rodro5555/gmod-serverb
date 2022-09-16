include("shared.lua")

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
end

/*
function ENT:OnRemove()
    for k,v in pairs(self:GetChildren()) do
    	if IsValid(v) and v.FlameObject then
			zclib.ClientModel.Remove(v)
		end
    end
end
*/
