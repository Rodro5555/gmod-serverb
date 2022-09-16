-- // QCardWars - By MerekiDor & toobeduge

local qcwBlack = Color(2,4,7)
local qcwArrow = Color(2,4,7,200)
local qcwHit   = Color(63, 171, 54)
local qcwHitB   = Color(63, 255, 54, 130)
local qcwMiss  = Color(157, 42, 42)
local qcwMissB  = Color(255, 42, 42, 130)
local qcwCrit  = Color(51, 193, 255)
local qcwCritB  = Color(51, 255, 255, 130)

local function drawArc(x,y,r,from,len,c)
    local t = {}
    
    table.insert(t,{x=x,y=y})
    
    local seg = math.ceil(len/6)
    for i=0,seg do
        local a = math.rad( math.min(from+(i*6),from+len) )
        table.insert(t,{
            x = x+math.cos(a)*r, 
            y = y+math.sin(a)*r 
        })
    end
    
    surface.SetDrawColor(c)
	surface.DrawPoly(t)
end

-- // Effect

function EFFECT:Init(data)
    self:SetRenderMode(1)
    self.tstart = CurTime()
    
    self.tout   = 0
    self.arrow  = 0
    
    self.ent  = data:GetEntity()
    self.lane = data:GetRadius()
    
    local v = data:GetStart()
    self.miss = 3.6*v.x
    self.crit = 3.6*v.y
    self.dest = 3.6*v.z
end

function EFFECT:Think()
    local dt = FrameTime()
    if self.tout>1 or not IsValid(self.ent) then
        return false
    else
        if self.arrow < self.dest then
            self.arrow = math.min(self.dest, self.arrow + 800*dt*( CurTime()-self.tstart ))
        else
            if self.tout == 0 then
                surface.PlaySound("buttons/lightswitch2.wav")
            end
            self.tout = self.tout + dt*1.66
        end
        return true
    end
end

function EFFECT:Render()
    if not IsValid(self.ent) then
        return
    end
    local delta  = CurTime()-self.tstart
    local ang    = self.ent:GetAngles()
    ang.p = 0
    ang.r = 0
    local fwd, up = ang:Forward(), ang:Up()
    
    local mul = math.min(1, math.min( 1-self.tout, (delta)*2 )*3)
    surface.SetAlphaMultiplier( mul )
    
    local pos = self.ent:GetPos() + up*64 + up*delta + fwd*(-48+self.lane*32)
    local eang = (EyePos()-pos):Angle()+Angle(90,0,0)
    eang:RotateAroundAxis(eang:Up(),180)
    cam.Start3D2D(pos,eang,1/16)
        local miss, crit = self.miss, self.crit
        local da, d1, d2 = self.arrow, -miss, -miss-crit
        local ra, r1, r2 = math.rad(da), math.rad(d1), math.rad(d2)
        draw.NoTexture()
        
        mul = (mul^2)*150+100
        drawArc(0,0,8+mul,0,360,qcwBlack)
        drawArc(0,0,mul,0,360+d2,qcwHit)
        drawArc(0,0,mul,d1,miss,qcwMiss)
        drawArc(0,0,mul,d2,crit,qcwCrit)
        drawArc(0,0,8,0,360,qcwBlack)
        
        if self.arrow == self.dest then 
            local dest = self.dest
            
            self.tmed = self.tmed or CurTime()
            delta = ((self.tmed+1-CurTime())^0.5)*32
            
            if dest<360+d2 or dest>=360 then
                drawArc(0,0,mul+delta,0,360+d2,qcwHitB)
            elseif dest<360+d1 then
                drawArc(0,0,mul+delta,d2,crit,qcwCritB)
            else
                drawArc(0,0,mul+delta,d1,miss,qcwMissB)
            end
        end
        
        local mul2 = mul/2
        surface.SetDrawColor(qcwBlack)
        surface.DrawTexturedRectRotated(math.cos(r1)*mul2, math.sin(r1)*mul2, mul+6, 4, -d1)
        surface.DrawTexturedRectRotated(math.cos(r2)*mul2, math.sin(r2)*mul2, mul+6, 4, -d2)
        surface.DrawTexturedRectRotated(mul2, 0, mul+6, 4, 0)
        surface.SetDrawColor(qcwArrow)
        surface.DrawTexturedRectRotated(math.cos(ra)*mul2, math.sin(ra)*mul2, mul+6, 8, -da)
        
    cam.End3D2D()
    
    surface.SetAlphaMultiplier(1)
end
