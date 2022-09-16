--[[  
    Addon: Hitman
    By: SlownLS
]]

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Phone box"
ENT.Category = "SlownLS | Hitman"
ENT.Spawnable = true

if( SERVER ) then
    function ENT:Initialize()
        self:SetModel(SlownLS.Hitman.Config.PhoneBoothModel)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end

    function ENT:AcceptInput(strName, _, pCaller)
        if( strName == "Use" && IsValid(pCaller) && pCaller:IsPlayer() ) then
            if( SlownLS.Hitman.Config.BlackList[team.GetName(pCaller:Team())] or pCaller:isCP() ) then return end

            SlownLS.Hitman:sendEvent("open_phone", {}, pCaller)
        end
    end
else
    -- print 3d2d text
    function ENT:Draw()
        self:DrawModel()

        local pos = self:GetPos()
        local ang = self:GetAngles()

        -- move forward
        pos = pos + ang:Forward() * 10
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 90)
        pos.z = pos.z + 90

        cam.Start3D2D(pos + ang:Up() * 10, ang, 0.3)
            draw.SimpleTextOutlined("Teléfono del Hitman", "SlownLS:Hitman:24", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_red)
        cam.End3D2D()
    end
end
