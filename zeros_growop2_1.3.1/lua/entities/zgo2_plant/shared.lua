ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Plant"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = false
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_plant01.mdl"
ENT.RenderGroup             = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()

	// Id to the plant config
	self:NetworkVar("Int", 0, "PlantID")

	// How much THC do we currently have
	self:NetworkVar("Int", 3, "GrowCompletedTime")

	// Time in seconds till its fully grown
	self:NetworkVar("Int", 1, "GrowProgress")

	// Amount of light the plant is getting
	self:NetworkVar("Int", 2, "LightLevel")
	/*
		0 = No Light
		1 = Enough Light
		2 = Too much light
		3 = Wrong Color
	*/

	if (SERVER) then
		self:SetPlantID(0)
		self:SetGrowProgress(0)
		self:SetLightLevel(0)
		self:SetGrowCompletedTime(0)
	end
end

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end
