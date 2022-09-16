
include("shared.lua")

local function GetCameras(Players)
    local TableEnt = {} 
    for k,v in pairs(ents.FindByClass("realistic_police_camera")) do 
        if IsValid(v:CPPIGetOwner()) then 
            if v:CPPIGetOwner() == Players then 
                if IsValid(v) then 
                    table.insert(TableEnt, v) 
                end   
            end 
        end 
    end 
    return TableEnt 
end 

function ENT:Draw()
    if IsValid(self) && IsEntity(self) then 
        self:DrawModel()   
        local pos = self:GetPos() + self:GetAngles():Forward() * 6.1 + self:GetAngles():Up() * 37 + self:GetAngles():Right() * 29 
        local ang = self:GetAngles()
        ang:RotateAroundAxis( ang:Up(), -90 )
        ang:RotateAroundAxis( ang:Right(), 180 )
        ang:RotateAroundAxis( ang:Forward(), 270 )

        cam.Start3D2D(pos, ang, 0.25)
            if self:GetPos():DistToSqr(LocalPlayer():GetPos()) < 250^2 then 
                if self.CreateMaterialRPT == nil && self.RenderTarget == nil then 
                    self:CameraRender()
                end     
                if IsValid(self:CPPIGetOwner()) && self:CPPIGetOwner():IsPlayer() then 
                    if istable(GetCameras(self:CPPIGetOwner())) then 
                        if IsValid( GetCameras(self:CPPIGetOwner())[self:GetNWInt("CameraId")] ) then 
                            if not GetCameras(self:CPPIGetOwner())[self:GetNWInt("CameraId")]:GetRptCam() then 
                                surface.SetDrawColor( Realistic_Police.Colors["white"] )
                                surface.SetMaterial( self.CreateMaterialRPT ) 
                                surface.DrawTexturedRect( 0, 0, 227, 146 ) 
                            else 
                                draw.RoundedBox(0, 0, 0, 227, 146, Realistic_Police.Colors["black20"])
                                draw.DrawText(Realistic_Police.GetSentence("noSignal"), "rpt_font_19", 113.5, 53, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER)
                                draw.DrawText(Realistic_Police.GetSentence("connectionProblem"), "rpt_font_19", 113.5, 73, Realistic_Police.Colors["red"], TEXT_ALIGN_CENTER)
                            end 
                        end  
                    end 
                end 
            else 
                if self.CreateMaterialRPT != nil && self.RenderTarget != nil then 
                    hook.Remove( "HUDPaint", "RPTCamera:Render"..self:EntIndex() ) 
                    self.CreateMaterialRPT = nil 
                    self.RenderTarget = nil
                end 
            end 
        cam.End3D2D()
    end 
end 

function ENT:CameraRender()
    self.RenderTarget = GetRenderTarget( "rptcamera1"..self:EntIndex(), 500, 500, false )
    self.CreateMaterialRPT = CreateMaterial( "rptcamera1"..self:EntIndex(), "UnlitGeneric", { ["$basetexture"] = self.RenderTarget, } )
    
    timer.Create("rptcamera1"..self:EntIndex(), Realistic_Police.CameraUpdateRate, 0, function()
        RPTPlayerDraw = true 
        render.PushRenderTarget( self.RenderTarget ) 
            render.ClearDepth()
            if IsValid(self:CPPIGetOwner()) && self:CPPIGetOwner():IsPlayer() then 
                if istable(GetCameras(self:CPPIGetOwner())) then 
                    if IsValid( GetCameras(self:CPPIGetOwner())[self:GetNWInt("CameraId")] ) then 
                        local Angs = GetCameras(self:CPPIGetOwner())[self:GetNWInt("CameraId")]:GetAngles()
                        Angs:RotateAroundAxis(Angs:Up(), -90) 
                        local pos = GetCameras(self:CPPIGetOwner())[self:GetNWInt("CameraId")]:GetPos() + Angs:Forward() * 25 + Angs:Up() * 10 
                        
                        render.RenderView({
                            x = 0,
                            y = 0,
                            w = 1920,
                            h = 1080,
                            origin = pos,
                            angles = Angs,
                            drawviewer = false, 
                            drawviewmodel = true,
                            fov = LocalPlayer():GetFOV(),
                        })
                    end 
                end 
            end 

        render.UpdateScreenEffectTexture()
        render.PopRenderTarget()
        if IsValid(self) then 
            if self.RenderTarget != nil then 
                self.CreateMaterialRPT:SetTexture( '$basetexture', self.RenderTarget  )
            end 
        end 
        RPTPlayerDraw = false 
    end) 
end 

function ENT:Initialize()
    self:CameraRender()
end 

hook.Add("ShouldDrawLocalPlayer", "RPT:ShouldDrawLocalPlayer", function(ply)
    if string.find( ply:GetActiveWeapon().Base or "nothing", "tfa" ) then return false end
    cam.Start3D() cam.End3D()
    if RPTPlayerDraw then return true end 
end ) 
 