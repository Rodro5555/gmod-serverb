include("shared.lua")

function ENT:Draw()
	if LocalPlayer():GetNWBool("axebuyed") == true then
		self:DrawModel()  
	end  
end