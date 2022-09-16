

include("shared.lua")

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "RptCam" )
    self:NetworkVar( "String", 1, "RptRotate" )
end

function ENT:Draw()
    self:DrawModel()   
end

