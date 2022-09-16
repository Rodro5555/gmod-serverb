-- // QCardWars - By MerekiDor & toobeduge

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName= "QCardWars Table"
ENT.Author= "MerekiDor | Traduccion para BlackBloodRP"
ENT.Category = "Fun + Games"
ENT.Spawnable = true

-- // Locals {{{

    local function getTableRandom(t)
        return t[math.random(1,#t)]
    end

    local function getColorFromCard(c,a)
        if c then
            return Color(c.cr,c.cg,c.cb,a or c.ca or 255)
        end
    end
    
    local function makeList(t)
        local list = {}
        for k,v in ipairs(t) do
            list[v] = true
        end
        return list 
    end

    local function oppositeLane(l)
        return 3-l
    end

    local function oppositeTeam(t)
        return t==1 and 2 or 1
    end

    local function shortenName(name)
        if #name>13 then
            return utf8.sub(name,1,13).."..."
        end
        return name
    end

    local function getMul(mana) -- power tiers of cards
        if not mana then return 2 end
        
        -- hell yeah, elseifs
        if mana <= 1 then
            return 1
        elseif mana <= 4 then
            return 2
        elseif mana <= 7 then
            return 3
        elseif mana<=14 then
            return 4
        else
            return 5
        end
    end

    local function checkAABB(x,y,bx,by,bw,bh)
        return (x>=bx and x<bx+bw) and (y>=by and y<by+bh)
    end

    local VectorZero = Vector(0,0,0)
    local yaw90      = Angle(0,90,0)

    local qcwSPModeText = {
        "CONFIRMAR",
        "SELECCIONA ALIADO",
        "SELECCIONA ENEMIGO"
    }

-- // }}}

-- // Colors {{{

    local qcwBlack = Color(2,4,7,230)
    local qcwBlackLight = Color(2,4,7,200)
    local qcwGreen = Color(2,228,32,230)
    local qcwGreenLight = Color(100,255,132,230)
    local qcwGreenSel = Color(2,228,32,24)
    local qcwRed = Color(220,50,50,230)
    local qcwYellow = Color(220,200,50,230)
    local qcwPurple = Color(161,12,230,230)
    local qcwWhite = Color(206,213,232)
    local qcwBright = Color(255,255,255)
    local qcwRainbow = Color(0,0,0)
    local qcwBuilding = Color(0,0,0)
    local qcwPower = Color(0,0,0)
    local qcwStatReduced = Color(164,142,133)
    local qcwStatMore = Color(123,232,255)

-- // }}}

-- // Fonts {{{

    if CLIENT then
        surface.CreateFont("QCWName",{
            font = "Courier New",
            size = 62,
            weight = 1000,
            antialias = true
        })
        surface.CreateFont("QCWHuge",{
            font = "Courier",
            size = 150,
            weight = 1000,
            antialias = true
        })
        surface.CreateFont("QCWOutlined",{
            font = "Courier",
            size = 35,
            weight = 1000
        })
        surface.CreateFont("QCWDesc",{
            font = "Courier",
            size = 16,
            weight = 1000,
            antialias = true
        })
    end
    
-- // }}}

-- // Functions {{{

    -- Table {{{
        
        local qcwPressFunc = {
            -- 1: Lane Selection
            function(self,pid,mx,my,pl)
                local lvalid = 0
                
                if #self.lanesValid~=(table.Count(qcwLaneTypes)-1) then
                    self.lanesValid = {}
                    for n,lane in pairs(qcwLaneTypes) do
                        if n ~= "null" then
                            table.insert(self.lanesValid,n)
                        end
                    end
                    table.sort(self.lanesValid,function(a,b) return qcwLaneTypes[a].name<qcwLaneTypes[b].name end)
                    
                    for i=1,2 do
                        for j=0,3 do
                            local append = i..j
                            local prev = self.qcwData["l"..append]
                            
                            if qcwLaneTypes[prev] then
                                local id
                                for k,v in ipairs(self.lanesValid) do
                                    if v==prev then
                                        id = k
                                    end
                                end
                                
                                if id then
                                    self.qcwData["lid"..append]   = id
                                    self.qcwData["l"..append] = self.lanesValid[self.qcwData["lid"..append]]
                                else
                                    self.qcwData["l"..append]   = nil
                                    self.qcwData["lid"..append] = nil
                                end
                            else
                                self.qcwData["l"..append]   = nil
                                self.qcwData["lid"..append] = nil
                            end
                        end
                    end
                    
                    self.lanesValid.y = true
                    sound.Play("buttons/combine_button7.wav",self:GetPos())
                    net.Start("qcw_sendTableData")
                        net.WriteEntity(self)
                        net.WriteTable(self.qcwData)
                    net.Broadcast()
                    
                    net.Start("qcw_communicate")
                        net.WriteUInt(3,3)
                        net.WriteEntity(self)
                        net.WriteTable(self.lanesValid)
                    net.Broadcast()
                end
                
                for i=0,3 do
                    local append = pid..i
                    local off = self["lo"..append] or 0
                    
                    if checkAABB(mx,my,-507+256*i+8,512-132+off,240,24,y,w,h) then
                        self.qcwData["lid"..append] = math.Clamp(math.ceil(math.Remap(mx,-507+256*i,-507+256*i+8+240,0,#self.lanesValid)),1,#self.lanesValid)
                        self.qcwData["l"..append] = self.lanesValid[self.qcwData["lid"..append] or 1] or "null"
                        sound.Play("buttons/button15.wav",self:GetPos())
                        net.Start("qcw_sendTableData")
                            net.WriteEntity(self)
                            net.WriteTable(self.qcwData)
                        net.Broadcast()
                    else
                        for j=0,1 do
                            local lid = self.qcwData["lid"..append] or 1
                            if (j==0 and lid>1) or (j==1 and (#self.lanesValid==1 or lid<#self.lanesValid)) then
                                local x,y,w,h = -508+125*j+256*i,512-64+off,121,76
                                if checkAABB(mx,my,x,y,w,h) then
                                    self.qcwData["lid"..append] = math.Clamp((self.qcwData["lid"..append] or 0) + (j==0 and -1 or 1),1,#self.lanesValid)
                                    self.qcwData["l"..append] = self.lanesValid[self.qcwData["lid"..append] or 1] or "null"
                                    sound.Play("buttons/button15.wav",self:GetPos())
                                    net.Start("qcw_sendTableData")
                                        net.WriteEntity(self)
                                        net.WriteTable(self.qcwData)
                                    net.Broadcast()
                                end
                            end
                        end
                    end
                    if self.qcwData["l"..append] then
                        lvalid = lvalid + 1
                    end
                end
                
                if pl==self:GetNWEntity("creator") then
                    local x,y,w,h = -512,548,250,64
                    local delta = pl:KeyDown(IN_SPEED) and 20 or (pl:KeyDown(IN_WALK) and 1 or 5)
                    if checkAABB(mx,my,x-4,y+40,64,48) then
                        sound.Play("buttons/button15.wav",self:GetPos())
                        self:SetNWInt("plhpMax",math.Clamp(self:GetNWInt("plhpMax",100)-delta,1,1000))
                    elseif checkAABB(mx,my,x+w-64+4,y+40,64,48) then
                        sound.Play("buttons/button15.wav",self:GetPos())
                        self:SetNWInt("plhpMax",math.Clamp(self:GetNWInt("plhpMax",100)+delta,1,1000))
                    end
                end
                
                if checkAABB(mx,my,-200,548,400,76) and lvalid==4 then
                    local v = not self:GetNWBool("ready"..pid,false)
                    self:SetNWBool("ready"..pid,v)
                    
                    if self:GetNWBool("ready1",false) and self:GetNWBool("ready2",false) then
                        self.busy = true
                        self:SetModelScale(0,0.25)
                        timer.Simple(0.5,function()
                            if IsValid(self) then
                                self:qcwGenDeck(1)
                                self:qcwGenDeck(2)
                                
                                self:SetModelScale(1,0.25)
                                self:SetNWInt("gameStatus",3)
                                self:SetNWInt("turnOffset",math.random(1,10))
                                self:SetNWInt("turn",0)
                                
                                PrintMessage(3, ("[QCW] %s VS %s started!"):format(
                                    self:GetNWEntity("pl1",Entity(1)):Nick(), 
                                    self:GetNWEntity("pl2",Entity(1)):Nick()
                                ))
                                
                                self.qcwData["plhp1"] = self:GetNWInt("plhpMax",100)
                                self.qcwData["plhp2"] = self:GetNWInt("plhpMax",100)
                                
                                self:qcwProgressTurn()
                                
                                self.busy = false
                            end
                        end)
                        sound.Play("buttons/button3.wav",self:GetPos())
                        
                        self:SetNWBool("ready1",false)
                        self:SetNWBool("ready2",false)
                    else
                        if v then
                            sound.Play("buttons/button14.wav",self:GetPos())
                        else
                            sound.Play("buttons/button16.wav",self:GetPos())
                        end
                    end
                end
            end,
            
            -- 2: Game
            function(self,pid,mx,my)
                local x,y,w,h = -252,550,109,101
                local data = self.qcwData
                
                local rows = math.ceil( (data["deck"..pid] and #data["deck"..pid] or 1)/7 )+1
                
                if checkAABB(mx,my,x,y,w*7,h*rows) then
                    local i, py = 1+math.floor((mx-x)/109), math.floor((my-y)/101)
                    while py>0 do
                        py = py - 1
                        i = i + 7
                    end
                    
                    if i>#data["deck"..pid] then
                        data["sel"..pid] = 0
                    else
                        if data["sel"..pid] == i then
                            data["sel"..pid] = 0
                        else
                            data["sel"..pid] = i
                        end
                    end
                    for j=0,3 do
                        data["spmode"..pid..j] = -1
                    end
                    sound.Play("buttons/button15.wav",self:GetPos())
                    net.Start("qcw_sendTableData")
                        net.WriteEntity(self)
                        net.WriteTable(data)
                    net.Broadcast()
                elseif checkAABB(mx,my,-512,16,1024,530) then
                    
                    local cid = (data["spcur"..pid] or 0)
                    local sel = data["sel"..pid]
                    local lid = math.Clamp(math.ceil((mx+512)/256),1,4)-1 -- Clamping just in case
                    local unit = data["unidad"..pid..lid]
                    
                    local sunit = data["unidad"..pid..cid]
                    local smode = (data["spmode"..pid..cid] or -1)
                    
                    if sel==0 and smode>0 and sunit then
                        if checkAABB(mx,my,-512+256*cid+26,348,204,44) then
                            data["spmode"..pid..cid] = -1
                            sound.Play("buttons/button16.wav",self:GetPos())
                            net.Start("qcw_sendTableData")
                                net.WriteEntity(self)
                                net.WriteTable(data)
                            net.Broadcast()
                        elseif sunit.special and data["mana"..pid]>=sunit.scost and (sunit.suses or 999)>0 and (sunit.nospecial or 0)<=0 then
                            local success = self:qcwDoSpecial(sunit,(smode==1 and lid or 3-lid))
                            if success then
                                sound.Play("buttons/button3.wav",self:GetPos())
                                
                                data["mana"..pid] = data["mana"..pid] - sunit.scost
                                sunit.suses = (sunit.suses or 999)-1
                                sunit.nospecial = sunit.nospecial + 1
                                        
                                sound.Play("garrysmod/save_load3.wav",self:GetPos())
                                self:qcwChecks()
                                
                                data["spmode"..pid..cid] = -1
                                
                                net.Start("qcw_sendTableData")
                                    net.WriteEntity(self)
                                    net.WriteTable(data)
                                net.Broadcast()
                            else
                                sound.Play("buttons/button16.wav",self:GetPos())
                            end
                        else
                            sound.Play("buttons/button16.wav",self:GetPos())
                        end
                    elseif sel ~= 0 then
                        local ctype = data["deck"..pid][sel]
                        if ctype then
                            local cdata = qcwCards[ctype]
                            
                            if not cdata then
                                sound.Play("buttons/button16.wav",self:GetPos())
                                return
                            end
                            
                            if cdata.type=="hechizo" then
                                cdata.team = pid
                                cdata.lid  = lid
                            end
                            if (cdata.lane==data["l"..pid..lid] or cdata.lane=="todos" or cdata.type~="unidad") and (cdata.cost<=data["mana"..pid]) and (cdata.type~="hechizo" or qcwSpecials[cdata.specialCheck or "C_Always"](self,cdata,cdata.spick==2 and 3-lid or lid)) then
                                data["sel"..pid]  = 0
                                data["mana"..pid] = data["mana"..pid] - cdata.cost
                                self.busy = true
                                
                                self:SetNWInt("cAnimFrom", sel)
                                self:SetNWInt("cAnimTo",   lid)
                                self:SetNWInt("cAnimTime", CurTime())
                                
                                sound.Play("weapons/slam/throw.wav",self:GetPos(),75,200)
                                if cdata.type=="hechizo" then
                                    sound.Play("weapons/physcannon/energy_sing_flyby1.wav",self:GetPos(),75,120)
                                end
                                timer.Simple(0.3,function()
                                    if IsValid(self) then
                                        table.remove(data["deck"..pid],sel)
                                        table.RemoveByValue(data["deckAll"..pid],cdata.class)
                                        self:SetNWInt("cAnimFrom", 0)
                                        self:SetNWInt("cAnimTo",   0)
                                        self:SetNWInt("cAnimTime", 0)
                                        
                                        self:qcwPlaceCard(pid,lid,ctype)
                                        self.busy = false
                                    end
                                end)
                            else
                                sound.Play("buttons/button16.wav",self:GetPos())
                            end
                        end
                    else
                        local lid   = math.Clamp(math.ceil((mx+512)/256),1,4)-1
                        local unit  = data["unidad"..pid..lid]
                        local smode = (data["spmode"..pid..lid] or -1)
                        
                        local x,y,w,h = -512+256*lid+26,348,204,44
                        if checkAABB(mx,my,x,y,w,h) then
                            if smode<=0 then
                                for i=0,3 do
                                    if i~=lid then
                                        data["spmode"..pid..i] = -1
                                    elseif unit then
                                        if unit.special and data["mana"..pid]>=unit.scost and (unit.suses or 999)>0 and (unit.nospecial or 0)<=0 then
                                            local old, new = data["spmode"..pid..lid], data["spmode"..pid..lid]==-1 and unit.spick or -1
                                            data["spmode"..pid..lid] = new
                                            data["spcur"..pid] = lid
                                            
                                            if new==-1 then
                                                if old == 0 then
                                                    
                                                    local success = self:qcwDoSpecial(sunit)
                                                    if success then
                                                        sound.Play("buttons/button3.wav",self:GetPos())
                                                        
                                                        data["mana"..pid] = data["mana"..pid] - unit.scost
                                                        unit.suses = (unit.suses or 999)-1
                                                        unit.nospecial = unit.nospecial + 1
                                                        
                                                        sound.Play("garrysmod/save_load2.wav",self:GetPos())
                                                        self:qcwChecks()
                                                    else
                                                        sound.Play("buttons/button16.wav",self:GetPos())
                                                    end
                                                else
                                                    sound.Play("buttons/button16.wav",self:GetPos())
                                                end
                                            else
                                                sound.Play("buttons/button15.wav",self:GetPos())
                                            end
                                        end
                                    end
                                end
                            end
                            
                            net.Start("qcw_sendTableData")
                                net.WriteEntity(self)
                                net.WriteTable(data)
                            net.Broadcast()
                            
                        end
                    end
                elseif checkAABB(mx,my,-510,650,120,100) then
                    data["mana"..pid] = 0
                    self:qcwProgressTurn()
                end
            end
            
        }
        
        local qcwDrawLaneFunc = {
            -- 1: Lane Selection
            function(self,pid,i)
                local p1, p2 = self:GetNWEntity("pl1"), self:GetNWEntity("pl2")
                
                local off = (self["lo"..pid..i] or 0)
                if (LocalPlayer()==p1 and pid==1) or (LocalPlayer()==p2 and pid==2) or (p1==p2) then
                    local ltype = qcwLaneTypes[(self.qcwData["l"..pid..i] or "null")] or qcwLaneTypes.null
                    draw.RoundedBox(8,-512+256*i,16+off,254,512,getColorFromCard(ltype,195+off*5))
                    draw.RoundedBox(8,-508+256*i,400+off,246,44,qcwBlackLight)
                    draw.SimpleText(ltype.name or "None","ScoreboardDefaultTitle",-385+256*i,420+off,qcwBright,1,1)
                    draw.RoundedBox(8,-508+256*i,400+off-18,246,16,qcwBlackLight)
                    
                    local count = table.Count(qcwLaneTypes)-1
                    local bw = (246-2)/count
                    local tj = self.qcwData["lid"..pid..i]
                    local rs = count<=16 and 8 or (count<=32 and 4 or 0)
                    for j=1,count do
                        local x,y,w,h = -507+256*i+bw*(j-1)+2,400+off-16,bw-4,12
                        draw.RoundedBox(rs,x,y,w,h,qcwBlackLight)
                        if j==tj then
                            draw.RoundedBox(rs,x+2,y+2,w-4,h-4,qcwGreenLight)
                        end
                    end
                    local pdata = self.laneDescTable[i+1 + (pid-1)*4]
                    local d = (ltype.desc or "")
                    if not pdata.parsed or pdata.text~=d then
                        pdata.parsed = markup.Parse("<font=QCWDesc>"..d.."</font>",240)
                        pdata.text   = d
                    else
                        if pdata.text~="" then
                            draw.RoundedBox(8,-508+256*i,228+off-16,246,168,qcwBlackLight)
                        end
                        pdata.parsed:Draw(-500+256*i,228+off)
                    end
                else
                    draw.RoundedBox(8,-512+256*i,16+off,254,512,HSVToColor((CurTime()*120+30*i)%360,0.25,0.2))
                    draw.SimpleTextOutlined("?","QCWHuge",-512+256*i+254/2,16+off+256,qcwBright,1,1,2,qcwBlack)
                end
            end,
            
            -- 2: Game
            function(self,pid,i, c_pos,c_angle,c_scale)
                local _, cid = self:qcwGetPlayer()
                local x,y,w,h = -512+256*i,16,254,512
                
                local ltype = qcwLaneTypes[(self.qcwData["l"..pid..i] or "null")] or qcwLaneTypes.null
                local unit = self.qcwData["unidad"..pid..i]
                local build = self.qcwData["estructura"..pid..i]
                
                if pid == cid then
                    local off = self["lo"..pid..i] or 0
                    y = y + off
                    draw.RoundedBox(8,x,y,w,h,getColorFromCard(ltype,195+off*5))
                else
                    draw.RoundedBox(8,-512+256*i,16,254,512,getColorFromCard(ltype,50))
                end
                
                if unit then
                    local cond = (LocalPlayer():GetPos()-self:GetPos()):Dot(self:GetAngles():Right())*(pid==1 and 1 or -1)<0
                    local muly = 1
                    
                    local hpc = LocalPlayer()==self:GetNWEntity("pl"..pid) and qcwGreenLight or qcwRed
                    if cond then
                        cam.End3D2D()
                        local c_angle = c_angle+Angle(0,0,-90)
                        -- Names below mismatch cuz I named them from other player's perspective
                        local forward,right,up = c_angle:Up(), c_angle:Forward(), c_angle:Right()
                        cam.Start3D2D(c_pos+right*(-3+2*i)*32+forward*-32,c_angle,-c_scale)
                        muly = -0.5
                    end
                    if build then
                        draw.SimpleTextOutlined(build.name,"QCWDesc",x+128,y+370*muly+(cond and -4 or 4),qcwBright,1,2, 2,qcwBlack)
                    end
                    draw.SimpleTextOutlined(unit.name,#unit.name>10 and "GModNotify" or "QCWOutlined",x+128,y+390*muly+(cond and -24 or 4)+20,qcwBright,1,1, 2,qcwBlack)
                    draw.SimpleTextOutlined("❤"..unit.hp,"QCWName",x+6,y+490*muly,unit.hpc or qcwBright,0,4, 2,qcwBlack)
                    draw.SimpleTextOutlined(unit.atk.."⚔","QCWName",x+248,y+490*muly,unit.atkc or qcwBright,2,4, 2,qcwBlack)
                    if (unit.noatk or 0)>0 then
                        draw.SimpleTextOutlined("❌","QCWName",x+235,y+485*muly-(cond and 8 or 0),qcwRed,2,4, 2,qcwBlack)
                    end
                    draw.RoundedBox(8,x+6,y+490*muly,w-12,18,qcwBlack)
                    draw.RoundedBox(8,x+8,y+490*muly+2,(w-16)*math.Clamp(unit.hp/unit.hpm,0,1),14,unit.hpc or hpc)
                    for j=1,math.min(10,unit.block or 0) do
                        draw.SimpleTextOutlined("⛊","QCWOutlined",x+w-24-j*10,y+490*muly-6,qcwStatMore,0,0, 2,qcwBlack)
                    end
                    for j=1,math.min(10,unit.armor or 0) do
                        draw.SimpleTextOutlined("⛊","QCWOutlined",x+j*10+4,y+490*muly-6,qcwYellow,0,0, 2,qcwBlack)
                    end
                    if cond then
                        cam.End3D2D()
                        cam.Start3D2D(c_pos,c_angle,c_scale)
                    end
                end
            end
        }
        qcwDrawLaneFunc[3] = qcwDrawLaneFunc[2]
        
        local qcwDrawGlobalFunc = {
            -- 1: Lane Selection
            function(self,pid)
                local mx, my = self:qcwPos(pid,EyePos(),EyeAngles())
                local lp = LocalPlayer()
                
                local lvalid = 0
                for i=0,3 do
                    local off = self["lo"..pid..i] or 0
                    if self:GetNWEntity("pl"..pid,lp)==lp then
                        local lid = self.qcwData["lid"..pid..i] or 1
                        for j=0,1 do
                            if (j==0 and lid>1) or (j==1 and (#self.lanesValid==1 or lid<#self.lanesValid)) then
                                local x,y,w,h = -508+125*j+256*i,512-64+off,121,76
                                draw.RoundedBox(8,x,y,w,h,qcwBlack)
                                if checkAABB(mx,my,x,y,w,h) then
                                    draw.RoundedBox(8,x,y-4,w,h,qcwGreenSel)
                                end
                                draw.SimpleText((j==0 and "￩" or "￫"),"QCWName",x+62,y+38,qcwBright,1,1)
                            end
                        end
                    end
                    if self.qcwData["l"..pid..i] then
                        lvalid = lvalid + 1
                    end
                end
                
                if lvalid == 4 then
                    local x,y,w,h = -200,548,400,76
                    draw.RoundedBox(8,x,y,w,h,qcwBlack)
                    if checkAABB(mx,my,x,y,w,h) then
                        draw.RoundedBox(8,x,y-4,w,h,qcwGreenSel)
                    end
                    if not self:GetNWBool("ready"..pid,false) then
                        draw.SimpleText("LISTO","QCWName",x+200,y+40,qcwBright,1,1)
                    else
                        draw.SimpleText("CANCELAR","QCWName",x+200,y+40,qcwBright,1,1)
                    end
                end
                
                if LocalPlayer()==self:GetNWEntity("creator") then
                    local x,y,w,h = -512,548,250,64
                    draw.RoundedBox(8,x,y,w,h,qcwBlack)
                    draw.SimpleText("Salud de los jugadores","Trebuchet24",x+w/2,y+4,qcwBright,1,0)
                    draw.RoundedBox(8,x+64,y+40,w-128,48,qcwBlack)
                    draw.RoundedBox(8,x+64+2,y+40+2,w-128-4,48-4,qcwGreenLight)
                    draw.RoundedBox(8,x-4,y+40,64,48,color_black)
                    if checkAABB(mx,my,x-4,y+40,64,48) then
                        draw.RoundedBox(8,x-4,y+40-4,64,48,qcwGreenSel)
                    end
                    draw.RoundedBox(8,x+w-64+4,y+40,64,48,color_black)
                    if checkAABB(mx,my,x+w-64+4,y+40,64,48) then
                        draw.RoundedBox(8,x+w-64+4,y+40-4,64,48,qcwGreenSel)
                    end
                    draw.SimpleText(">","QCWOutlined",x+w-32+4,y+40+24,qcwBright,1,1)
                    draw.SimpleText("<","QCWOutlined",x+4+24,y+40+24,qcwBright,1,1)
                    draw.SimpleText(self:GetNWInt("plhpMax",100),"QCWOutlined",x+w/2,y+40+24,color_black,1,1)
                    draw.SimpleText("Sostenga SHIFT/ALT para números más grandes/más pequeños","QCWDesc",x+w/2,y+40+64,qcwBright,1,1)
                end
            end,
            
            -- 2: Game
            function(self,pid)
                local cpl, cid = self:qcwGetPlayer()
                local data = self.qcwData
                if pid == cid then
                    local mx, my = self:qcwPos(cid,cpl:EyePos(),cpl:EyeAngles())
                    
                    local deck = data["deck"..pid] or {}
                    local mana = data["mana"..pid] or 0
                    local x,y,w,h = -252,550,107,99
                    
                    draw.RoundedBoxEx(24,-388,550,134,self.cardSpecParsed and math.max(self.cardSpecParsed:GetHeight()+8+128,200) or 200,qcwBlack,false,false,true,false)
                    
                    draw.RoundedBoxEx(24,-512,550,122,48,qcwBlack,true,false,true,false)
                    draw.RoundedBox(22,-510,552,48,44,qcwPurple)
                    draw.SimpleTextOutlined(mana,"QCWOutlined",-512+26,576,qcwBright,1,1,2,qcwBlack)
                    draw.SimpleText("Mana","Trebuchet24",-512+54,574,qcwWhite,0,1)
                    
                    draw.RoundedBoxEx(24,-512,600,122,48,qcwBlack,true,false,true,false)
                    draw.RoundedBox(22,-510,602,48,44,qcwGreen)
                    draw.SimpleTextOutlined(self:qcwGetTurn(),"QCWOutlined",-512+26,626,qcwBright,1,1,2,qcwBlack)
                    draw.SimpleText("Turno","Trebuchet24",-512+54,624,qcwWhite,0,1)
                    
                    local cAnimTimeInt = self:GetNWInt("cAnimTime",0) 
                    if self.cAnimTimeDone ~= cAnimTimeInt then
                        self.cAnimTime = CurTime()
                        self.cAnimTimeDone = cAnimTimeInt
                    end
                    
                    local cAnimFrom, cAnimTo, cAnimTime = self:GetNWInt("cAnimFrom", 0), self:GetNWInt("cAnimTo", 0), self.cAnimTime or 0
                    
                    for id,card in ipairs(deck) do
                    
                        local px, py, f
                        
                        if cAnimFrom == id then
                            f = 1-math.EaseInOut((cAnimTime+0.3-CurTime())*2,1,1)
                            px = x
                            py = y
                            x,y,w,h = Lerp(f,px,-512+256*cAnimTo),Lerp(f,py,16),Lerp(f,107,254),Lerp(f,99,512)
                            surface.SetAlphaMultiplier(1-f)
                        end
                        surface.SetDrawColor(qcwBlackLight)
                        surface.DrawRect(x,y,w,h)
                        if checkAABB(mx,my,x,y,w,h) then
                            surface.SetDrawColor(qcwGreenSel)
                            surface.DrawRect(x+2,y+2,w-4,h-4)
                        end
                        if id==data["sel"..pid] then
                            surface.SetDrawColor(qcwGreenSel)
                            surface.DrawRect(x,y,w,h)
                        end
                        
                        local cdata = qcwCards[card]
                        
                        if cdata then
                            if cdata.cost>mana then
                                surface.SetAlphaMultiplier(0.2)
                            end
                            
                            local big = #cdata.name>10
                            draw.SimpleText(cdata.name,big and "DermaDefault" or "Trebuchet24",x+8,y+(big and 8 or 4),qcwBright)
                            if cdata.type=="unidad" then
                                draw.SimpleText("❤"..cdata.hp.." ⚔"..cdata.atk,"Trebuchet24",x+8,y+24,qcwBright)
                            elseif cdata.type=="estructura" then
                                draw.SimpleText("⌂","QCWName",x+8,y+16,qcwBright)
                            elseif cdata.type=="hechizo" then
                                draw.SimpleText("⚡","QCWName",x+12,y+16,qcwBright)
                            end
                            
                            if cdata.type=="hechizo" then
                                surface.SetDrawColor(qcwPower)
                            elseif cdata.type=="estructura" then
                                surface.SetDrawColor(qcwBuilding)
                            else
                                if cdata.lane=="todos" then
                                    surface.SetDrawColor(qcwRainbow)
                                else
                                    surface.SetDrawColor(qcwLaneTypes[cdata.lane] and getColorFromCard(qcwLaneTypes[cdata.lane]) or color_black)
                                end
                            end
                            
                            surface.DrawRect(x+2,y+h-18,w-38,16)
                            
                            draw.RoundedBoxEx(8,x+w-34,y+h-34,32,32,qcwPurple,true,false,false,false)
                            draw.SimpleText(cdata.cost,"Trebuchet24",x+w-18,y+h-18,qcwBright,1,1)
                        else
                            draw.SimpleText("Invalid","Trebuchet24",x+8,y+(big and 8 or 4),qcwBright)
                        end
                        
                        surface.SetAlphaMultiplier(1)
                        
                        if px then
                            x = px - 108*f
                            y = py
                            w = 107
                            h = 99
                        end
                        
                        if id%7==0 then
                            y = y+h+2
                            x = -252
                        else
                            x = x+(w+2)
                        end
                    end
                    
                    x,y,w,h = -510,650,120,100
                    draw.RoundedBoxEx(24,x,y,w,h,qcwBlack,true,false,true,true)
                    if checkAABB(mx,my,x,y,w,h) then
                        draw.RoundedBoxEx(24,x+2,y+2,w-4,h-4,qcwGreenSel,true,false,true,true)
                    end
                    draw.SimpleText("PASAR","QCWOutlined",x+60,y+50,q,1,1)
                    
                    local sel = data["sel"..pid] or 0
                    if sel>0 then
                        local card = qcwCards[data["deck"..pid][sel]]
                        if card then
                            draw.SimpleText(card.name,"Trebuchet24",x+124,y-100,q)
                            draw.SimpleText(card.type.."; "..card.cost.." MP","Trebuchet18",x+128,y-80,q)
                            
                            draw.SimpleText(card.type=="unidad" and "Habilidad:" or "Efecto:","Trebuchet24",x+124,y-20,q)
                            if card.type == "unidad" then
                                draw.SimpleText("Carril: "..card.lane,"Trebuchet18",x+128,y-64,q)
                                draw.SimpleText(card.atk.."ATK; "..card.hp.."HP","Trebuchet18",x+128,y-48,q)
                                draw.SimpleText((card.special and card.scost.." MP; " or "Ninguno; ").." uso"..((card.suses or 2)==1 and "" or "s")..": "..(card.suses or "inf"),"Trebuchet18",x+128,y,q)
                            end
                            if self.cardSpecParsed and self.cardSpecText == card.sdesc then
                                self.cardSpecParsed:Draw(x+128,card.type=="unidad" and y+20 or y+8)
                            else
                                self.cardSpecParsed = markup.Parse(card.sdesc or "", 120)
                                self.cardSpecText   = card.sdesc or ""
                            end
                        else
                            draw.SimpleText("Tarjeta no valida","Trebuchet24",x+124,y-100,q)
                            draw.SimpleText("¿Posiblemente eliminado?","Trebuchet18",x+128,y-80,q)
                        end
                    else
                        self.cardSpecParsed = nil
                    end
                    
                    for i=0,3 do
                        local x,y,w,h = -512+256*i,16+(self["lo"..pid..i] or 0),254,512
                        local unit = data["unidad"..pid..i]
                        
                        if unit then
                            if unit.special and unit.scost<=data["mana"..pid] and (unit.suses or 999)>0 and (unit.nospecial or 0)<=0 then
                                surface.SetAlphaMultiplier(sel==0 and 1 or 0.3)
                                surface.SetDrawColor(qcwRainbow)
                                surface.DrawRect(x+24,y+320,w-48,48)
                                surface.SetDrawColor(qcwBlack)
                                surface.DrawRect(x+26,y+322,w-52,44)
                                local sappend = ""
                                if (unit.suses or 11)<=10 then
                                    sappend = " [" .. (unit.suses or "INF") .. " USOS]"
                                end
                                local sptext = qcwSPModeText[(data["spmode"..pid..i] or -1)+1] or "ESPECIAL ("..(unit.scost).." MP)"..sappend
                                draw.SimpleText(sptext,"Trebuchet18",x+126,y+345,qcwRainbow,1,1)
                                if sel==0 then
                                    if checkAABB(mx,my,x+24,y+320,w-48,48) then
                                        local ww = #unit.sdesc*8
                                        local xc = x+w/2-ww/2
                                        surface.SetDrawColor(qcwRainbow)
                                        surface.DrawRect(xc,y+372,ww,52)
                                        surface.SetDrawColor(qcwBlack)
                                        surface.DrawRect(xc+2,y+374,ww-4,48)
                                        draw.SimpleText(unit.sdesc,"QCWDesc",x+w/2,y+388,qcwRainbow,1)
                                    end
                                end
                                surface.SetAlphaMultiplier(1)
                            end
                        end
                        
                        if sel>0 and not (self:GetNWInt("cAnimFrom",0)==sel) then
                            if checkAABB(mx,my,x,y,w,h) then
                                local cdata = qcwCards[data["deck"..pid][sel]]
                                if cdata then
                                    local off = 32
                                    if cdata.type=="hechizo" then
                                        cdata.team = pid
                                        cdata.lid  = i
                                        if qcwSpecials[cdata.specialCheck or "C_Always"](self,cdata,cdata.spick==2 and 3-i or i) then
                                            if cdata.spick==2 then
                                                draw.SimpleTextOutlined("⬆","QCWHuge",x+126,y,qcwPower,1,1,2,qcwBlack)
                                            elseif cdata.spick==1 then
                                                draw.SimpleTextOutlined("⚡","QCWHuge",x+126,y+258-off,qcwPower,1,1,2,qcwBlack)
                                            else
                                                surface.SetDrawColor(ColorAlpha(qcwPower,100))
                                                surface.DrawRect(x+4,y+4,w-8,h-8)
                                            end
                                            draw.SimpleTextOutlined("Usar","DermaLarge",x+126,y+340-off,qcwPower,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined(cdata.name,"ScoreboardDefaultTitle",x+126,y+370-off,qcwPower,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined("para "..cdata.cost.." MP","ScoreboardDefault",x+126,y+400-off,qcwPower,1,1,2,qcwBlack)
                                        else
                                            draw.SimpleTextOutlined("❌","QCWHuge",x+126,y+258,qcwRed,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined("No se puede usar aquí","DermaLarge",x+126,y+400,qcwRed,1,1,2,qcwBlack)
                                        end
                                    else
                                        if cdata.lane==data["l"..pid..i] or cdata.lane=="todos" or cdata.type~="unidad" then
                                            draw.SimpleTextOutlined("⬆","QCWHuge",x+126,y+258-off,qcwGreen,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined("Colocar","DermaLarge",x+126,y+340-off,qcwGreen,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined(cdata.name,"ScoreboardDefaultTitle",x+126,y+370-off,qcwGreen,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined("para "..cdata.cost.." MP","ScoreboardDefault",x+126,y+400-off,qcwGreen,1,1,2,qcwBlack)
                                        else
                                            draw.SimpleTextOutlined("❌","QCWHuge",x+126,y+258,qcwRed,1,1,2,qcwBlack)
                                            draw.SimpleTextOutlined("Tipo incorrecto","DermaLarge",x+126,y+400,qcwRed,1,1,2,qcwBlack)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    local lid = math.Clamp(math.ceil((512+mx)/256),1,4)-1
                    
                    x,y,w,h = -512+lid*256,0,256,512
                    
                    local cid = (data["spcur"..pid] or -1)
                    local sunit = data["unidad"..pid..cid]
                    local ally, enemy = data["unidad"..pid..lid], data["unidad"..oppositeTeam(pid)..(3-lid)]
                    local smode = (data["spmode"..pid..cid] or -1)
                    
                    if sunit then
                        if smode==1 and ally then
                            draw.SimpleTextOutlined("O","QCWHuge",x+126,y+256,qcwGreen,1,1,1,qcwBlack)
                        elseif smode==2 and enemy then
                            draw.SimpleTextOutlined("⬆","QCWHuge",x+126,y,qcwRed,1,1,2,qcwBlack)
                            draw.SimpleTextOutlined("USAR ESPECIAL","DermaLarge",x+126,y+150,qcwRed,1,1,2,qcwBlack)
                        end
                    end
                end
            end
        }
        
    -- }}}

    -- Evaluation {{{
        
        local _qcwRands = {}
        _qcwEvRes = 0 -- I can't believe I have to add a global for that. Apparently RunString() doesn't even return anything, so I gotta store it here
        
        function qcwEvalDebug(exp)
            local desk  = { qcwData = {} }
            local runit = { team = 1, lid = 1 }
            return qcwEval(desk,runit,0,exp)
        end
        
        function qcwEval(desk,runit,rsel,exp,nomath)
            local overflow = 0
            for k,v in pairs({
                ["!SELF"] = runit.team .. runit.lid, ["!ENEMY"] = oppositeTeam(runit.team) .. oppositeLane(runit.lid),
                ["!AID"]  = runit.team, ["!EID"] = oppositeTeam(runit.team),
                ["!LID"]  = runit.lid,  ["!OLID"] = oppositeLane(runit.lid),
                ["!SID"]  = rsel or 0,
                ["!AHP"]  = desk.qcwData["plhp"..runit.team], ["!EHP"] = desk.qcwData["plhp"..oppositeTeam(runit.team)],
                ["!MANA"] = desk.qcwData["mana"..runit.team] or 0,
                ["!RAND"]  = math.random(),
                ["!TURN"]  = (desk.qcwGetTurn and desk:qcwGetTurn() or 1),
                ["!RN1"] = _qcwRands[1] or math.random(),
                ["!RN2"] = _qcwRands[2] or math.random(),
                ["!RN3"] = _qcwRands[3] or math.random(),
                ["!RN4"] = _qcwRands[4] or math.random()
            }) do
                exp = exp:gsub(k,v or 0)
            end
            
            repeat
                exp = exp:gsub("%d%d%d?::[%a_]+",function(e)
                    local split  = e:Split("::")
                    local uid = (split[1] or runit.team..runit.lid)
                    return (desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid] or {})[split[2]] or 0
                end)
                overflow = overflow+1
            until not exp:find("::") or overflow>60
            
            local mathpat = "[%d%.%*%+%-%+%^%%()]+"
            
            overflow = 0
            repeat
                exp = exp:gsub("%b[]",function(e)
                    e = e:sub(2,-2)
                    e = e:gsub("%b[]",function(c) return qcwEval(desk,runit,rsel,c) end)
                    
                    local split  = e:Split("?")
                    local result = split[2]:Split(":")
                    
                    split[1]:gsub("[><=~]+",function(c)
                        local csplit = split[1]:Split(c)
                        --print("csplits: ",csplit[1],", ",csplit[2])
                        
                        if not nomath and csplit[1]:match(mathpat)==csplit[1] and csplit[2]:match(mathpat)==csplit[2] then
                            split[1] = csplit[1] .. c .. csplit[2]
                        else
                            split[1] = '"'..csplit[1]..'"' .. c .. '"'..csplit[2]..'"'
                        end
                    end)
                    --print("Split1: ",'"'..split[1]..'"')
                    
                    local err = RunString("_qcwEvRes = "..split[1],"QCW",false)
                    if err then 
                        ErrorNoHalt(err) 
                        return ""
                    elseif _qcwEvRes then
                        return result[1] or 1
                    else
                        return result[2] or 0
                    end
                    overflow = overflow+1
                end)
            until not exp:find("%b[]") or overflow>60
            
            --print("Expression: ",exp)
            
            if not nomath then
                exp = exp:gsub(mathpat,function(e)
                    --print("Math exp: ",e)
                    local err = RunString("_qcwEvRes = "..e,"QCW",false)
                    if err then 
                        ErrorNoHalt(err)
                        return ""
                    else
                        return _qcwEvRes or 0
                    end
                end)
            end
            
            return exp
        end
    -- }}}
    
-- // }}}
    
-- // Game Data {{{

    -- Specials {{{
        
        qcwSpecials = {
            ["C_Always"] = function() return true end,
            ["C_EnemyFront"] = function(desk,unit,sel) 
                return desk.qcwData["unidad"..oppositeTeam(unit.team)..oppositeLane(unit.lid)]
            end,
            ["C_EnemySel"] = function(desk,unit,sel) 
                return desk.qcwData["unidad"..oppositeTeam(unit.team)..sel]
            end,
            ["C_AllySel"] = function(desk,unit,sel) 
                return desk.qcwData["unidad"..unit.team..sel]
            end,
            ["C_AllySelNotSelf"] = function(desk,unit,sel) 
                return desk.qcwData["unidad"..unit.team..sel]~=unit
            end,
            ["C_AllyBuilding"] = function(desk,unit,sel) 
                return desk.qcwData["estructura"..unit.team..unit.lid]
            end,
            ["C_EnemyBuilding"] = function(desk,unit,sel) 
                return desk.qcwData["estructura"..oppositeTeam(unit.team)..oppositeLane(unit.lid)]
            end,
            ["C_AllyEmptyLine"] = function(desk,unit,sel) 
                return not desk.qcwData["unidad"..unit.team..unit.lid]
            end,
            ["C_EnemyEmptyLine"] = function(desk,unit,sel) 
                return not desk.qcwData["unidad"..oppositeTeam(unit.team)..oppositeLane(unit.lid)]
            end,
            
            --
            ["Set Player HP"] = {
                argDescs = {"player ID","to"}, desc = "Establece el HP del jugador.",
                func = function(desk,rUnit,rSel, pid,to)
                    local epid = tonumber(qcwEval(desk,rUnit,rSel,pid))
                    if epid==1 or epid==2 then
                        local n = tonumber(qcwEval(desk,rUnit,rSel,to)) or desk.qcwData["plhp"..epid]
                        desk.qcwData["plhp"..epid] = math.Clamp(math.floor(n),0,desk:GetNWInt("plhpMax",100))
                    end
                end
            },
            ["Draw Weak Card"] = {
                argDescs = {"player ID"}, desc = "Le da al jugador una carta débil al azar. Prioriza los carriles que tienen menos cartas en el mazo.",
                func = function(desk,rUnit,rSel, pid)
                    local epid = tonumber(qcwEval(desk,rUnit,rSel,pid))
                    if epid==1 or epid==2 then
                        local lanes = {}
                        
                        for i=1,128 do
                            local card = qcwCards[desk.qcwData["deckAll"..epid][i]]
                            if card and card.type=="unidad" then
                                lanes[card.lane] = (lanes[card.lane] or 128) - 1
                            end
                            
                            if card==nil then break end
                        end
                        
                        local lane = table.GetWinningKey(lanes)
                        
                        table.Empty(lanes)
                        for card,info in pairs(qcwCards) do
                            if info.type=="unidad" and info.lane==lane and info.cost<=4 then
                                table.insert(lanes,card)
                            end
                        end
                        
                        local card = lanes[math.random(1,#lanes)] or "univ_bucket"
                        table.insert(desk.qcwData["deckAll"..epid],card)
                        table.insert(desk.qcwData["deck"..epid],card)
                    end
                end
            },
            ["Set Mana"] = {
                argDescs = {"player ID","to"}, desc = "Establece el maná del jugador.",
                func = function(desk,rUnit,rSel, pid,to)
                    local epid = tonumber(qcwEval(desk,rUnit,rSel,pid))
                    if epid==1 or epid==2 then
                        local n = tonumber(qcwEval(desk,rUnit,rSel,to)) or desk.qcwData["mana"..epid]
                        desk.qcwData["mana"..epid] = math.max(math.floor(n),0)
                    end
                end
            },
            ["Terminate"] = {
                argDescs = {"confirm"}, desc = "Si el argumento es 1, finaliza la ejecución de la habilidad.",
                func = function(desk,rUnit,rSel, conf)
                    local s = tonumber(qcwEval(desk,rUnit,rSel,conf))
                    if s==1 then
                        return true
                    end
                end
            },
            ["Set Custom Value"] = {
                argDescs = {"unit ID","value name","to"}, desc = "Establece un valor ficticio dentro de una unidad. No hace nada, pero puede recuperarlo con UNIT_ID::cv_NAME, es decir, UNIT_ID:cv_CustomVal para obtener CustomVal.",
                func = function(desk,rUnit,rSel, of,vn,to)
                    local uid  = qcwEval(desk,rUnit,rSel,of) or rUnit.team..rUnit.lid
                    local name = tostring(qcwEval(desk,rUnit,rSel,vn))
                    local unit = desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid]
                    if unit then
                        local ev = qcwEval(desk,rUnit,rSel,to)
                        print(name,ev,unit[k],0)
                        unit["cv_"..name] = ev or unit[k] or 0
                    end
                end
            },
            ["Set Building"] = {
                argDescs = {"lane ID","to"}, desc = "Reemplaza un edificio en un carril. Utilice 'ninguno' para eliminar.",
                func = function(desk,rUnit,rSel, lane,to)
                    local bname = qcwEval(desk,rUnit,rSel,to)
                    local lid   = qcwEval(desk,rUnit,rSel,lane)
                    
                    if bname~="none" then
                        local building = qcwCards[bname]
                        if building and building.type=="estructura" then
                            desk:qcwPlaceCard(lid:sub(1,1), lid:sub(2,2), bname, true)
                        end
                    else
                        desk.qcwData["estructura"..lid] = nil
                    end
                end
            },
            ["Set Unit"] = {
                argDescs = {"lane ID","to"}, desc = "Reemplaza una unidad en un carril. Utilice 'ninguno' para eliminar.",
                func = function(desk,rUnit,rSel, lane,to)
                    local uname = qcwEval(desk,rUnit,rSel,to)
                    local lid   = qcwEval(desk,rUnit,rSel,lane)
                    
                    if uname~="none" then
                        local unit = qcwCards[uname] or qcwCards.univ_bucket
                        if unit and unit.type=="unidad" then
                            desk:qcwPlaceCard(lid:sub(1,1), lid:sub(2,2), uname, true, true)
                        end
                    else
                        desk.qcwData["unidad"..lid] = nil
                    end
                end
            },
            ["Play Sound"] = {
                argDescs = {"filename","pitch (100)","volume (1.00)","delay (0)"}, desc = "Reproducir un archivo de sonido.",
                func = function(desk,rUnit,rSel, snd,pitch,vol,delay)
                    local esnd = tostring(qcwEval(desk,rUnit,rSel,snd,true))
                    esnd = esnd:gsub("%awav$",".wav")
                    esnd = esnd:gsub("%aogg$",".ogg")
                    esnd = esnd:gsub("%amp3$",".mp3")
                    if esnd then
                        pitch = tonumber(pitch) or 100
                        vol   = tonumber(vol)   or 1
                        delay = tonumber(delay) or 0
                        local pos = desk:GetPos()
                        if delay>0 then
                            timer.Simple(delay,function()
                                sound.Play(esnd,pos,75,pitch,vol)
                            end)
                        else
                            sound.Play(esnd,pos,75,pitch,vol)
                        end
                    end
                end
            },
            ["Mimic Model"] = {
                argDescs = {"unit ID", "target ID"}, desc = "¡Copie el modelo del objetivo, pero no la escala/color/cualquier otra cosa!",
                func = function(desk,rUnit,rSel, unit,target)
                    local uid = qcwEval(desk,rUnit,rSel,unit) or rUnit.team..rUnit.lid
                    local unit = desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid]
                    if unit then
                        local eid = qcwEval(desk,rUnit,rSel,target)
                        local enemy = desk.qcwData["unidad"..eid]
                        if enemy and enemy.mdl then
                            unit.mdl = enemy.mdl
                        end
                    end
                end
            },
            ["Add Card"] = {
                argDescs = {"to (player ID)","card class name"}, desc = "Agrega una unidad por nombre de clase al mazo del jugador. Agrega un cubo si la tarjeta no existe, porque es divertido. 'none' específicamente no agrega nada, evitando un depósito.",
                func = function(desk,rUnit,rSel, pid,name)
                    pid  = qcwEval(desk,rUnit,rSel,pid)
                    name = qcwEval(desk,rUnit,rSel,name)
                    if desk.qcwData["deck"..pid] then
                        if name~="none" then
                            local class = qcwCards[name] and name or "univ_bucket"
                            table.insert(desk.qcwData["deckAll"..pid],class)
                            table.insert(desk.qcwData["deck"..pid],class)
                        end
                    end
                end
            },
            ["Swap Position"] = {
                argDescs = {"from (unit/lane ID)", "to (unit/lane ID)"}, desc = "Haz que una unidad intercambie lugares. Si el destino está vacío, técnicamente es teletransportación. Si ya hay una unidad allí, cambian de posición. Funciona incluso entre equipos, de esa forma puedes cambiar tu unidad por una enemiga, por ejemplo.",
                func = function(desk,rUnit,rSel, from,to)
                    local e1 = qcwEval(desk,rUnit,rSel,from) or rUnit.team..rUnit.lid
                    local e2 = qcwEval(desk,rUnit,rSel,to)   or rUnit.team..rSel or 10
                    
                    local ref1 = desk.qcwData["unidad"..e1]
                    local ref2 = desk.qcwData["unidad"..e2]
                    
                    if ref1 then
                        ref1.lid = tostring(e2):sub(2,2)
                        ref1.team = tostring(e2):sub(1,1)
                    end
                    
                    if ref2 then
                        ref2.lid = tostring(e1):sub(2,2)
                        ref2.team = tostring(e1):sub(1,1)
                    end
                    
                    desk.qcwData["unidad"..e1] = ref2
                    desk.qcwData["unidad"..e2] = ref1
                end
            }
        }
        
        -- Ugly code {{{
        do
            local descs = {
                mdlScale = "El modelo en el escritorio es 1/6 de su tamaño predeterminado, la escala del modelo se aplica DESPUÉS de eso, lo que significa que la escala del modelo 2x sería en realidad 1/3x.",
                material = "Material aplicado al modelo.",
                elev = "Esto modifica la elevación del modelo sobre la mesa. Normalmente se utiliza para modelos voladores o correcciones.",
                mdlSeq = "Básicamente establece la animación del modelo, pero no la reproduce.",
                mdlYaw = "Esto es útil si desea corregir la dirección en la que mira el modelo.",
                spick = "0 es el botón 'confirmar'; 1 es 'seleccionar aliado', 2 es 'seleccionar enemigo'.",
                sCritMul = "Multiplicador para tu propia tasa de críticos contra enemigos, te hace hacer más críticos. 1.0x es normal.",
                sMissMul = "Multiplicador de probabilidad de golpe contra enemigos, lo que te hace menos preciso con valores más altos. 1.0x es normal.",
                eCritMul = "A los enemigos se les multiplicará su índice crítico por ese valor contra esta unidad. Un valor más alto lo hace más vulnerable, 1.0x es normal.",
                eMissMul = "Los enemigos tendrán su probabilidad de fallar contra esta unidad multiplicada por esa cantidad. ¡Los valores más altos te hacen más difícil de golpear! 1.0x es normal.",
                noatk = "La unidad no atacará la próxima vez si está por encima de 0. Cada vez que falla un ataque, este valor disminuye en 1.",
                nospecial = "Evita que la unidad use una habilidad especial para el próximo turno. Cada turno este valor se reduce en 1.",
                spinning = "Rotaciones por segundo.",
                armor = "Reducción de daños (no se puede reducir por debajo de 1)"
            }
            descs["val2"], descs["val3"], descs["val4"] = descs["val1"], descs["val1"], descs["val1"]
            local list2 = makeList({"hp","hpm","atk","block","scost","noatk","nospecial"})
            local list3 = makeList({"sdesc","mdl","mdlSeq","name","material"})
            for k,v in pairs({
                name = "Name", hp = "HP", hpm = "Max HP", atk = "ATK", block = "Block", mdlScale = "Model Scale", elev = "Elevation", scost = "Special Cost", sdesc = "Special Desc", spick = "Special Activation Mode", cr = "Color - Red", cg = "Color - Green", cb = "Color - Blue", ca = "Color - Opacity", mdl = "Model", mdlSeq = "Model Pose (Sequence)", mdlYaw = "Rotation", sCritMul = "Crit Mul VS Enemies", sMissMul = "Miss Mul VS Enemies", eCritMul = "Crit Mul VS Self", eMissMul = "Miss Mul VS Self",noatk="Prevent ATK",nospecial="Prevent Special",material="Material",spinning="Spinning",float="Flying Animation",armor="Armor"}) do
                local translatedShit = {
                    name = "Nombre",
                    hp = "HP",
                    hpm = "HP máx.",
                    atk = "ATK",
                    block = "Bloquear",
                    mdlScale = "Escala modelo",
                    elev = "Elevación",
                    scost = "Costo especial",
                    sdesc = "Descripción especial",
                    spick = "Modo de activación especial",
                    cr = "Color - rojo",
                    cg = "Color - verde",
                    cb = "Color - azul",
                    ca = "Color - Opacidad",
                    mdl = "Modelo",
                    mdlSeq = "Pose de modelo (secuencia)",
                    mdlYaw = "Rotación",
                    sCritMul = "Mult. Crit VS Enemigos",
                    sMissMul = "Mult. Miss VS Enemigos",
                    eCritMul = "Mult. Crit VS Self",
                    eMissMul = "Mult. Miss VS Yo",
                    noatk = "Prevenir ATK",
                    nospecial = "Evitar especial",
                    material = "Material",
                    spinning = "Rotación",
                    float = "Animación voladora",
                    armor = "Armor"
                }
                qcwSpecials["Set "..v] = {
                    argDescs = {"unit ID","new value"},
                    desc = "Configure el "..translatedShit[k].." de la unidad, puede acceder a él en expresiones con UNIT_ID::"..k.."."..(descs[k] and "\n"..descs[k] or "")
                }
                
                -- this is probably really crappy, but oh well
                if list2[k] then
                    qcwSpecials["Set "..v].func = function(desk,rUnit,rSel, of,to)
                        local uid = qcwEval(desk,rUnit,rSel,of) or rUnit.team..rUnit.lid
                        local unit = desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid]
                        if unit then
                            local ev = qcwEval(desk,rUnit,rSel,to)
                            unit[k] = math.max(math.floor(tonumber(ev) or unit[k] or 0),0)
                        end
                    end
                elseif list3[k] then
                    qcwSpecials["Set "..v].func = function(desk,rUnit,rSel, of,to)
                        local uid = qcwEval(desk,rUnit,rSel,of) or rUnit.team..rUnit.lid
                        local unit = desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid]
                        if unit then
                            unit[k] = qcwEval(desk,rUnit,rSel,to,true) or unit[k] or 0
                        end
                    end
                elseif k=="spick" then
                    qcwSpecials["Set "..v].func = function(desk,rUnit,rSel, of,to)
                        local uid = qcwEval(desk,rUnit,rSel,of) or rUnit.team..rUnit.lid
                        local unit = desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid]
                        if unit then
                            local ev = qcwEval(desk,rUnit,rSel,to)
                            local n = math.floor(tonumber(ev) or 0)
                            unit.spick = (n>=0 and n<=2) and n or 0
                        end
                    end
                else
                    qcwSpecials["Set "..v].func = function(desk,rUnit,rSel, of,to)
                        local uid = qcwEval(desk,rUnit,rSel,of) or rUnit.team..rUnit.lid
                        local unit = desk.qcwData[#uid==3 and "estructura"..uid:sub(1,2) or "unidad"..uid]
                        if unit then
                            local ev = qcwEval(desk,rUnit,rSel,to)
                            --print(v,ev)
                            unit[k] = tonumber(ev) or unit[k] or 0
                        end
                    end
                end
            end
        end
        -- }}}
        
    -- }}}
    
    -- Cards {{{
        
        qcwCards = {}
        setmetatable(qcwCards, {
            __newindex = function(t,k,v)
                if type(v)=="table" and v.type then
                    v.class         = tostring(k)
                    v.name          = tostring(v.name or "unidad")
                    v.mdl           = tostring(v.mdl  or "models/props_junk/MetalBucket01a.mdl")
                    v.mdlAlt        = tostring(v.mdlAlt or "")
                    v.material      = tostring(v.material or "")
                    v.mdlScale      = tonumber(v.mdlScale) or 1
                    v.mdlSeq        = tonumber(v.mdlSeq) or tostring(v.mdlSeq or "")
                    v.mdlYaw        = tonumber(v.mdlYaw) or 0
                    v.spinning      = tonumber(v.spinning) or 0
                    v.elev          = tonumber(v.elev) or 0
                    v.cost          = math.max(1,math.Round(tonumber(v.cost) or 1))
                    v.armor         = tonumber(v.armor) or 0
                    
                    if v.active == nil then
                        v.active = true
                    else
                        v.active = tobool(v.active)
                    end
                    
                    if v.nodeck == nil then
                        v.nodeck = false
                    else
                        v.nodeck = tobool(v.nodeck)
                    end
                    
                    if v.hidden == nil then
                        v.hidden = false
                    else
                        v.hidden = tobool(v.hidden)
                    end
                    
                    if v.type == "unidad" then
                        v.float     = tobool(v.float)
                        v.atk       = math.max(0,math.Round(tonumber(v.atk ) or 1))
                        v.hp        = math.max(1,math.Round(tonumber(v.hp  ) or 1))
                        v.lane      = tostring(v.lane or "todos")
                        
                        v.eMissMul  = tonumber(v.eMissMul) or 1 
                        v.eCritMul  = tonumber(v.eCritMul) or 1
                        v.sMissMul  = tonumber(v.sMissMul) or 1
                        v.sCritMul  = tonumber(v.sCritMul) or 1
                    else
                        v.lane      = "todos"
                    end
                    
                    v.cr = tonumber(v.cr) or 1
                    v.cg = tonumber(v.cg) or 1
                    v.cb = tonumber(v.cb) or 1
                    v.ca = tonumber(v.ca) or 1
                    
                    rawset(t,k,v)
                end
            end
        })
        
        for card,info in pairs {
            -- Universal
            univ_bucket = {
                name = "Balde", type = "unidad",
                mdl = "models/props_junk/MetalBucket01a.mdl", mdlScale = 2, elev = 2,
                atk = 2, hp = 2, cost = 1,
                special = {
                    {"Set ATK","!SELF","!SELF::atk+1"}
                },
                sdesc = "Bono de +1 ATK a esta unidad.", scost = 1,
                spick = 0,
                lane = "todos"
            },
            univ_landmine = {
                name = "Mina", type = "unidad",
                mdl = "models/props_combine/combine_mine01.mdl",  mdlScale = 1.5,
                atk = 1, hp = 2, cost = 1, eMissMul = 1.75, eCritMul = 0.84,
                special = {
                    {"Set Custom Value","!SELF","primed","1"},
                    {"Play Sound","npc/roller/mine/rmine_blip3.wav"}
                },
                specialDeath = {
                    {"Set HP","!ENEMY","!ENEMY::hp-1"},
                    {"Play Sound","weapons/physcannon/energy_sing_explosion2.wav",110,0.3},
                    {"Terminate","[!SELF::cv_primed==1?0:1]"},
                    {"Set ATK","!ENEMY","!ENEMY::atk-1"},
                    {"Set HP","!ENEMY","!ENEMY::hp-3"},
                    {"Play Sound","weapons/physcannon/energy_sing_explosion2.wav",90,1}
                },
                specialCheck = "C_Always",
                sdesc = "Activa la capacidad de cebar esta unidad. Cuando está preparado, al morir, inflige -4 HP y -1 ATK al enemigo en el carril opuesto.",
                scost = 1,
                suses = 1,
                spick = 0,
                lane = "todos"
            },
            univ_lamp = {
                name = "Lámpara", type = "unidad",
                mdl = "models/props_lab/desklamp01.mdl", mdlScale = 5, elev = 6,
                atk = 3, hp = 2, cost = 1,
                special = {
                    {"Set HP","!EID!SID","!EID!SID::hp-2"}
                },
                sdesc = "-2 HP a cualquier enemigo.", scost = 2,
                spick = 2,
                lane = "todos"
            },
            univ_stove = {
                name = "Estufa", type = "unidad",
                mdl = "models/props_c17/furnitureStove001a.mdl", elev = 4,
                atk = 3, hp = 3, cost = 2,
                special = {
                    {"Set HP","!EID0","!EID0::hp-1"},
                    {"Set HP","!EID1","!EID1::hp-1"},
                    {"Set HP","!EID2","!EID2::hp-1"},
                    {"Set HP","!EID3","!EID3::hp-1"},
                    {"Play Sound","ambient/fire/ignite.wav"}
                }, sdesc = "-1 HP a todos los enemigos. ¡Quemar!", suses = 1, scost = 1,
                spick = 0,
                lane = "todos"
            },
            univ_rook = {
                name = "Roque", type = "unidad",
                mdl = "models/props_phx/games/chess/white_rook.mdl", mdlScale = 2, elev = -2,
                atk = 4, hp = 5, cost = 4,
                special = {
                    {"Swap Position","!SELF","!AID!SID"},
                    {"Play Sound","friends/friend_online.wav"}
                }, sdesc = "Intercambia posiciones con un aliado, incluso si este carril no es compatible con su tipo. ¡Enroque!", suses = 3, scost = 2,
                spick = 1,
                lane = "todos"
            },
            univ_wall = {
                name = "Muro", type = "unidad",
                mdl = "models/props_phx/construct/concrete_barrier00.mdl", mdlScale = 1.2, elev = 0, mdlYaw = 90,
                atk = 0, hp = 12, cost = 4, eMissMul = 0.2, eCritMul = 0.5,
                special = {
                    {"Set Block","!SELF","!SELF::block+1"},
                    {"Set HP","!SELF","!SELF::hp-2"}
                }, sdesc = "-2 CV. Bloquea el siguiente ataque.", scost = 2, suses = 2,
                spick = 0,
                lane = "todos"
            },
            univ_mimic = {
                name = "Imitar", type = "unidad",
                mdl = "models/balloons/balloon_dog.mdl", mdlScale = 3, elev = 2, float = true,
                atk = 1, hp = 2, cost = 5,
                special = {
                    {"Set HP","!SELF","!EID!SID::hpm*0.7+2"},
                    {"Set Max HP","!SELF","!EID!SID::hpm*0.7+2"},
                    {"Set ATK","!SELF","[!EID!SID::atk>1?!EID!SID::atk*0.7-1:1]"},
                    {"Set Block","!SELF","!EID!SID::block"},
                    {"Mimic Model","!SELF","!EID!SID"},
                    {"Set Model Scale","!SELF","!EID!SID::mdlScale"},
                    {"Set Elevation","!SELF","!EID!SID::elev"},
                    {"Set Model Pose (Sequence)","!SELF","!EID!SID::mdlSeq"},
                    {"Set Name","!SELF","\"!EID!SID::name\""},
                    {"Set Color - Red","!SELF","1"},
                    {"Set Color - Green","!SELF","5"},
                    {"Set Color - Blue","!SELF","10"},
                    {"Set Color - Opacity","!SELF","0.8"}
                }, specialCheck = "C_EnemySel", sdesc = "Conviértete en una copia barata de cualquier enemigo.", scost = 2, suses = 2,
                spick = 2,
                lane = "todos"
            },
            univ_shadowfigure = {
                name = "Figura de sombra", type = "unidad", hidden = true,
                mdl = "models/gman_high.mdl", mdlScale = 1.32, elev = 2, float = true, elev=2,cr=-5,cg=-5,cb=-4,
                atk = 15, hp = 20, cost = 25,
                special = {
                    {"Set HP","!AID0","!AID0::hp+2"},
                    {"Set HP","!AID1","!AID1::hp+2"},
                    {"Set HP","!AID2","!AID2::hp+2"},
                    {"Set HP","!AID3","!AID3::hp+2"},
                    {"Set HP","!EID0","0"},
                    {"Set HP","!EID1","0"},
                    {"Set HP","!EID2","0"},
                    {"Set HP","!EID3","0"},
                    {"Set HP","!SELF","0"},
                    {"Play Sound","ambient/atmosphere/cave_hit2.wav"}
                }, specialCheck = "C_Always", sdesc = "Cambia el rumbo\nÚsalo cuando estés abrumado", scost = 5, suses = 1,
                spick = 0,
                lane = "todos"
            },
            univ_burger = {
                name = "Hamburguesa", type = "unidad",
                mdl = "models/food/burger.mdl", mdlScale = 8, elev = -10, float = true, spinning = 1,
                atk = 6, hp = 8, cost = 8,
                special = {
                    {"Set HP","!AID0","!AID0::hp+2"},
                    {"Set HP","!AID1","!AID1::hp+2"},
                    {"Set HP","!AID2","!AID2::hp+2"},
                    {"Set HP","!AID3","!AID3::hp+2"}
                }, specialCheck = "C_Always", sdesc = "Todos los aliados reciben +2 HP.", scost = 3, suses = 4,
                eMissMul = 0.95, eCritMul = 0.95,
                spick = 0,
                lane = "todos"
            },
            univ_magneto = {
                name = "Magneto", type = "unidad",
                mdl = "models/maxofs2d/hover_rings.mdl", mdlScale = 2.5, elev = 5, float = true,
                atk = 3, hp = 5, cost = 10,
                special = {
                    {"Set ATK","!AID0","!AID0::atk+2"},
                    {"Set ATK","!AID1","!AID1::atk+2"},
                    {"Set ATK","!AID2","!AID2::atk+2"},
                    {"Set ATK","!AID3","!AID3::atk+2"}
                }, specialCheck = "C_Always", sdesc = "Todos los aliados reciben +2 ATK.", scost = 4, suses = 2,
                spick = 0,
                lane = "todos"
            },
            univ_cube = {
                name = "El cubo", type = "unidad",
                mdl = "models/hunter/blocks/cube025x025x025.mdl", mdlScale = 2.5, elev = 5, float = true, cr = 0, cg = 2, cb = 0.5,
                material = "models/shiny",  spinning = 0.25,
                atk = 6, hp = 5, cost = 9,
                special = {
                    {"Set Miss Mul VS Self","!AID0","!AID0::eMissMul*1.05"},
                    {"Set Miss Mul VS Self","!AID1","!AID1::eMissMul*1.05"},
                    {"Set Miss Mul VS Self","!AID2","!AID2::eMissMul*1.05"},
                    {"Set Miss Mul VS Self","!AID3","!AID3::eMissMul*1.05"},
                    {"Set Miss Mul VS Enemies","!AID0","!AID0::sMissMul*0.9"},
                    {"Set Miss Mul VS Enemies","!AID1","!AID1::sMissMul*0.9"},
                    {"Set Miss Mul VS Enemies","!AID2","!AID2::sMissMul*0.9"},
                    {"Set Miss Mul VS Enemies","!AID3","!AID3::sMissMul*0.9"},
                }, specialCheck = "C_Always", sdesc = "Todos los aliados se vuelven un 5% más difíciles de acertar y un 10% más precisos.", scost = 3, suses = 5,
                spick = 0,
                lane = "todos"
            },
            univ_bomb = {
                name = "Bomba", type = "unidad",
                mdl = "models/dynamite/dynamite.mdl", mdlScale = 2.5, float = false, mdlYaw = 30,
                atk = 3, hp = 6, cost = 8,
                special = {
                    {"Set HP","!ENEMY","!ENEMY::hp-5"},
                    {"Set Building","!ENEMY","none"},
                    {"Play Sound","weapons/explode5.wav"}
                }, specialCheck = "C_EnemyFront", sdesc = "Inflige 5 DAÑOS al enemigo opuesto y, si hay un edificio, destrúyelo. La unidad muere en el proceso.", scost = 5, suses = 1,
                spick = 0,
                lane = "todos"
            },
            univ_teapot = {
                name = "Tetera", type = "unidad",
                mdl = "models/props_interiors/pot01a.mdl", mdlScale = 4, elev = 3, float = true,
                atk = 4, hp = 5, cost = 6,
                special = {
                    {"Set ATK","!EID!SID","!EID!SID::atk-1"},
                }, specialCheck = "C_EnemySel", sdesc = "Reduce el ATK del enemigo en 1.", scost = 2,
                eMissMul = 0.8, eCritMul = 1.15, sMissMul = 0, sCritMul = 0.8,
                spick = 2, spinning = 0.3,
                lane = "todos"
            },
            
            -- Rebels
            rebel_grunt = {
                name = "Gruñón", type = "unidad", 
                mdl = "models/humans/group03/male_09.mdl",
                atk  = 2, hp = 15, cost = 1,
                special = {
                    {"Set HP","!SELF","[!SELF::atk>1?!SELF::hp+3:AID!LID::hp]"},
                    {"Set ATK","!SELF","[!SELF::atk>1?!SELF::atk-1:1]"},
                }, sdesc = "+3 HP por -1 ATK. Sin efecto si ATK está en 1.", scost = 1,
                spick = 0,
                lane = "rebel"
            },
            rebel_medic = {
                name = "Médico", type = "unidad", 
                mdl = "models/humans/group03m/female_03.mdl", mdlSeq = "idle_subtle",
                atk  = 1, hp = 14, cost = 2,
                special = {
                    {"Set HP","!AID!SID","!AID!SID::hp+4"},
                    {"Play Sound","items/smallmedkit1.wav"}
                }, specialCheck = "C_AllySel", sdesc = "+4 HP a cualquier unidad amiga elegida.", scost = 2, suses = 3, 
                spick = 1,
                lane = "rebel"
            },
            rebel_chuck = {
                name = "Mandril", type = "unidad", 
                mdl = "models/Humans/Group02/Male_04.mdl", mdlSeq = "idle_subtle",
                atk  = 3, hp = 20, cost = 8,
                special = {
                    {"Set HP","!AID0","[!AID0::lane==rebel?!AID0::hp+3:!AID0::hp+2]"},
                    {"Set HP","!AID1","[!AID1::lane==rebel?!AID1::hp+3:!AID1::hp+2]"},
                    {"Set HP","!AID2","[!AID2::lane==rebel?!AID2::hp+3:!AID2::hp+2]"},
                    {"Set HP","!AID3","[!AID3::lane==rebel?!AID3::hp+3:!AID3::hp+2]"},
                    
                    {"Set ATK","!AID0","[!AID0::lane==rebel?!AID0::atk+1:!AID0::atk]"},
                    {"Set ATK","!AID1","[!AID1::lane==rebel?!AID1::atk+1:!AID1::atk]"},
                    {"Set ATK","!AID2","[!AID2::lane==rebel?!AID2::atk+1:!AID2::atk]"},
                    {"Set ATK","!AID3","[!AID3::lane==rebel?!AID3::atk+1:!AID3::atk]"},
                    
                    {"Play Sound","items/smallmedkit1.wav"}
                }, sdesc = "+2 HP a todos los aliados; +3 HP y +1 ATK a los rebeldes.", scost = 4, suses = 1, 
                spick = 0,
                lane = "rebel"
            },
            rebel_bobby = {
                name = "Bobby", type = "unidad", 
                mdl = "models/odessa.mdl", mdlSeq = "idle_subtle",
                atk  = 4, hp = 21, cost = 5,
                special = {
                    {"Set HP","!AID0","!AID0::hp+3"},
                    {"Set HP","!SELF","[!AID0::hp>0?!SELF::hp-1:!SELF::hp]"},
                    {"Set HP","!AID1","!AID1::hp+3"},
                    {"Set HP","!SELF","[!AID1::hp>0?!SELF::hp-1:!SELF::hp]"},
                    {"Set HP","!AID2","!AID2::hp+3"},
                    {"Set HP","!SELF","[!AID2::hp>0?!SELF::hp-1:!SELF::hp]"},
                    {"Set HP","!AID3","!AID3::hp+3"},
                    {"Set HP","!SELF","[!AID3::hp>0?!SELF::hp-1:!SELF::hp]"},
                    {"Play Sound","items/medshot4.wav"}
                }, sdesc = "+3 HP a todas las unidades amigas; -1 HP para uno mismo por cada uno curado. Puede morir en el proceso, pero no antes de curar a todos.", scost = 3,
                spick = 0,
                lane = "rebel"
            },
            rebel_alyx = {
                name = "Alyx", type = "unidad", 
                mdl = "models/alyx.mdl", mdlSeq = "idle_subtle",
                atk  = 2, hp = 26, cost = 7,
                special = {
                    {"Set Prevent ATK","!AID0","0"},
                    {"Set Prevent ATK","!AID1","0"},
                    {"Set Prevent ATK","!AID2","0"},
                    {"Set Prevent ATK","!AID3","0"},
                    {"Set Prevent Special","!AID0","0"},
                    {"Set Prevent Special","!AID1","0"},
                    {"Set Prevent Special","!AID2","0"},
                    {"Set Prevent Special","!AID3","0"},
                    {"Set Block","!EID0","0"},
                    {"Set Block","!EID1","0"},
                    {"Set Block","!EID2","0"},
                    {"Set Block","!EID3","0"},
                    {"Play Sound","items/battery_pickup.wav"}
                }, sdesc = "Elimina todos los bloqueos de tus aliados y todos los escudos de los enemigos.", scost = 3, suses = 2,
                spick = 0,
                lane = "rebel"
            },
            rebel_barney = {
                name = "Barney", type = "unidad", 
                mdl = "models/Barney.mdl", mdlSeq = "idle_subtle",
                atk  = 3, hp = 28, cost = 7,
                special = {
                    {"Set Miss Mul VS Self","!AID0","!AID0::eMissMul+0.12"},
                    {"Set Miss Mul VS Self","!AID1","!AID1::eMissMul+0.12"},
                    {"Set Miss Mul VS Self","!AID2","!AID2::eMissMul+0.12"},
                    {"Set Miss Mul VS Self","!AID3","!AID3::eMissMul+0.12"},
                    {"Set Crit Mul VS Self","!AID0","!AID0::eCritMul+0.08"},
                    {"Set Crit Mul VS Self","!AID1","!AID1::eCritMul+0.08"},
                    {"Set Crit Mul VS Self","!AID2","!AID2::eCritMul+0.08"},
                    {"Set Crit Mul VS Self","!AID3","!AID3::eCritMul+0.08"},
                    {"Play Sound","vo/npc/barney/ba_laugh01.wav"}
                }, sdesc = "Todos los aliados se vuelven más difíciles de golpear o criticar.", scost = 4, suses = 1,
                spick = 0,
                lane = "rebel"
            },
            rebel_snatcher = {
                name = "Ladrón", type = "unidad", 
                mdl = "models/dog.mdl", mdlScale = 0.8, mdlYaw = 90,
                atk  = 2, hp = 25, cost = 5, eMissMul = 0.9,
                special = {
                    {"Set HP","!AID0","!AID0::hp+2"},
                    {"Set HP","!AID1","!AID1::hp+2"},
                    {"Set HP","!AID2","!AID2::hp+2"},
                    {"Set HP","!AID3","!AID3::hp+2"},
                    {"Set HP","!EID!SID","!EID!SID::hp-4"}
                }, specialCheck = "C_EnemySel", sdesc = "-4 HP a cualquier enemigo elegido, +2HP a todas las unidades amigas, incluido el mismo.", scost = 2,
                spick = 2,
                lane = "rebel"
            },
            
            -- Combine
            combine_metrocop = {
                name = "Metrocop", type = "unidad", 
                mdl = "models/police.mdl", mdlSeq = "batonidle1",
                atk  = 5, hp = 2, cost = 1,
                special = {
                    {"Set HP","!EID!SID","[!EID!SID::lane==rebel?!EID!SID::hp-3:!EID!SID::hp-2]"},
                    {"Play Sound","ambient/voices/citizen_punches1.wav"},
                    {"Add Card","!AID","[!RAND<0.2?combine_manhack:none]"}
                }, specialCheck = "C_EnemySel", sdesc = "-2 HP a cualquier unidad enemiga elegida (-3 HP a los rebeldes). 20% de agregar un Manhack a tu mazo.", scost = 1,
                spick = 2,
                lane = "combine"
            },
            combine_manhack = {
                name = "Manhack", type = "unidad",
                mdl = "models/manhack.mdl", mdlScale =  3, float = true, elev = 6,
                atk = 3, hp = 1, cost = 1, eMissMul = 1.25,
                special = {
                    {"Set ATK","!ENEMY","!ENEMY::atk-1"},
                    {"Play Sound","npc/manhack/grind_flesh1.wav"},
                }, specialCheck = "C_EnemyFront", sdesc = "-1 ATK a la unidad frente a ti.", scost = 1,
                spick = 0,
                lane = "combine"
            },
            combine_scanner = {
                name = "Escáner", type = "unidad",
                mdl = "models/Combine_Scanner.mdl", mdlScale =  2, float = true, elev = 6,
                atk = 3, hp = 3, cost = 4, eMissMul = 1.33,
                special = {
                    {"Set Prevent Special","!EID!SID","!EID!SID::nospecial+1"},
                    {"Set Miss Mul VS Enemies","!EID!SID","!EID!SID::sMissMul*1.25"},
                    {"Play Sound","npc/scanner/scanner_photo1.wav"},
                }, specialCheck = "C_EnemySel", sdesc = "Ciega al enemigo, impidiendo su habilidad especial el próximo turno y reduciendo su precisión.", scost = 1,
                spick = 2,
                lane = "combine"
            },
            combine_soldier = {
                name = "Soldado", type = "unidad", 
                mdl = "models/combine_soldier.mdl", mdlSeq = "deathpose_back",
                atk  = 9, hp = 4, cost = 2, sMissMul = 0.9,
                special = {
                    {"Set ATK","!ENEMY","!ENEMY::atk-3"},
                    {"Play Sound","npc/combine_soldier/vo/copythat.wav"}
                }, specialCheck = "C_EnemyFront", sdesc = "-3 ATK al enemigo en el carril opuesto.", scost = 1,
                spick = 0,
                lane = "combine"
            },
            combine_elite = {
                name = "Élite", type = "unidad", 
                mdl = "models/combine_super_soldier.mdl", mdlSeq = "deathpose_back",
                atk  = 11, hp = 5, cost = 6,
                special = {
                    {"Set HP","!EID!SID","!EID!SID::hp-3"},
                    {"Set ATK","!SELF","!SELF::atk+1"},
                    {"Play Sound","weapons/physcannon/energy_sing_explosion2.wav"}
                }, specialCheck = "C_EnemySel", sdesc = "-3 HP para cualquier unidad enemiga elegida, +1 ATK para uno mismo.", scost = 3,
                spick = 2,
                lane = "combine"
            },
            combine_turret = {
                name = "Torreta", type = "unidad", 
                mdl = "models/combine_turrets/floor_turret.mdl",
                atk  = 6, hp = 3, cost = 5,  sMissMul = 0.73,
                special = {
                    {"Set HP","!ENEMY","!ENEMY::hp-3"},
                    {"Set ATK","!SELF","[!ENEMY::hp<=0?!SELF::atk+2:!SELF::atk]"},
                    {"Play Sound","npc/turret_floor/active.wav"},
                    {"Play Sound","npc/turret_floor/shoot3.wav"},
                    {"Play Sound","npc/turret_floor/shoot2.wav","100","1","0.1"},
                    {"Play Sound","npc/turret_floor/shoot1.wav","100","1","0.2"},
                }, specialCheck = "C_EnemyFront", sdesc = "-3 HP para el enemigo en el carril opuesto, +2 ATK para uno mismo si el enemigo murió en el proceso.", scost = 1,
                spick = 0,
                lane = "combine"
            },
            combine_strider = {
                name = "Strider", type = "unidad",
                mdl = "models/Combine_Strider.mdl", mdlScale = 0.32, elev = 28, mdlSeq = "BighitL",
                atk = 12, hp = 6, cost = 8,  eMissMul = 0.85,
                special = {
                    {"Set HP","!EID!SID","0"},
                    {"Set ATK","!SELF","!SELF::atk*0.5"},
                    {"Set HP","!SELF","!SELF::hp*0.5"},
                    {"Play Sound","npc/strider/fire.wav"}
                }, specialCheck = "C_EnemySel", sdesc = "Mata instantáneamente a cualquier unidad, pero reduce a la mitad tu propio ATK y HP.", scost = 5, suses = 1,
                spick = 2,
                lane = "combine"
            },
            
            -- Antlion
            antlion_drone = {
                name = "Dron", type = "unidad", 
                mdl = "models/antlion.mdl", mdlScale = 0.8,
                atk  = 3, hp = 4, cost = 1,
                special = {
                    {"Set Block","!SELF","!SELF::block+1"}
                }, sdesc = "Bloquea un ataque del siguiente turno enemigo. Solo se puede usar una vez.", scost = 2, suses = 1,
                spick = 0,
                lane = "antlion"
            },
            antlion_sdrone = {
                name = "Super Dron", type = "unidad", 
                mdl = "models/antlion.mdl", mdlScale = 1,
                atk  = 5, hp = 5, cost = 3,
                special = {
                    {"Set Crit Mul VS Self","!AID!SID","0"}
                }, specialCheck = "C_AllySel", sdesc = "Haz que un aliado sea inmune a criticos.", scost = 3, suses = 1,
                spick = 1,
                lane = "antlion"
            },
            antlion_worker = {
                name = "Trabajador", type = "unidad", 
                mdl = "models/antlion_worker.mdl", mdlAlt = "models/antlion.mdl", mdlScale = 1, cr = 0.6, cg = 0.67, cb = 0.45,
                atk  = 4, hp = 7, cost = 2,
                special = {
                    {"Set Prevent ATK","!EID!SID","!EID!SID::noatk+1"}
                }, specialCheck = "C_EnemySel", sdesc = "Evita que cualquier enemigo ataque durante 1 turno.", scost = 3, suses = 2,
                spick = 2,
                lane = "antlion"
            },
            antlion_drago = { -- I did it, man, I put you into the game
                name = "Drago", type = "unidad", 
                mdl = "models/antlion.mdl", mdlScale = 1.2,  cr = 2, cg = 1.4, cb = 0.9,
                atk  = 5, hp = 8, cost = 4,
                special = {
                    {"Set Prevent Special","!EID0","!EID0::nospecial+1"},
                    {"Set Prevent Special","!EID1","!EID1::nospecial+1"},
                    {"Set Prevent Special","!EID2","!EID2::nospecial+1"},
                    {"Set Prevent Special","!EID3","!EID3::nospecial+1"}
                }, sdesc = "Todos los enemigos no podrán usar habilidades especiales para el próximo turno.", scost = 3, suses = 2,
                spick = 0,
                lane = "antlion"
            },
            antlion_guard = {
                name = "Guardia", type = "unidad", 
                mdl = "models/antlion_guard.mdl",
                atk  = 9, hp = 9, cost = 6,
                special = {
                    {"Set ATK","!AID0","!AID0::atk+2"},
                    {"Set ATK","!AID1","!AID1::atk+2"},
                    {"Set ATK","!AID2","!AID2::atk+2"},
                    {"Set ATK","!AID3","!AID3::atk+2"}
                }, sdesc = "Todas las unidades amigas reciben +2 ATK.", scost = 4, suses = 3,
                spick = 0,
                lane = "antlion"
            },
            antlion_sentinel = {
                name = "Centinela", type = "unidad", 
                mdl = "models/antlion_guard.mdl", mdlScale = 0.6, cr = 0.8, cg = 1.3, cb = 4,
                atk  = 6, hp = 10, cost = 8,
                special = {
                    {"Set Block","!AID0","!AID0::block+1"},
                    {"Set Block","!AID1","!AID1::block+1"},
                    {"Set Block","!AID2","!AID2::block+1"},
                    {"Set Block","!AID3","!AID3::block+1"},
                    {"Play Sound","npc/antlion/distract1.wav"}
                }, sdesc = "Todas las unidades amigas bloquean 1 ataque.", scost = 5, suses = 1,
                spick = 0,
                lane = "antlion"
            },
            
            -- Zombie
            zombie_headcrab = {
                name = "Headcrab", type = "unidad", 
                mdl = "models/headcrabclassic.mdl", mdlScale = 2,
                atk  = 2, hp = 1, cost = 1, eMissMul = 1.5, sCritMul = 1.2,
                special = {
                    {"Set HP","!ENEMY","!ENEMY::hp*0.5-2"},
                    {"Set HP","!SELF","0"},
                    {"Play Sound","npc/headcrab/headbite.wav"},
                    {"Terminate","[!RAND<0.66?0:1]"},
                    {"Set Unit","!SELF","zombie_zombie"},
                    {"Set HP","!SELF","!SELF::hp*!RAND"}
                },
                specialKill = {
                    {"Terminate","[!RAND<0.4?0:1]"},
                    {"Set Unit","!SELF","zombie_zombie"},
                    {"Set HP","!SELF","!SELF::hp*!RAND"}
                }, specialCheck = "C_EnemyFront", sdesc = "Reduce a la mitad la salud del enemigo opuesto y luego inflige 2 DAÑO, pero sacrifica esta unidad. Al matar tiene ~40% de convertirse en Zombi.", scost = 2, suses = 1,
                spick = 0,
                lane = "zombie"
            },
            zombie_lamarr = {
                name = "Lamarr", type = "unidad", 
                mdl = "models/headcrabclassic.mdl", mdlScale = 2,
                atk  = 1, hp = 4, cost = 2, eMissMul = 2, sCritMul = 1.2,
                special = {
                    {"Set HP","!EID!SID","!EID!SID::hp-!SELF::hp-3"},
                    {"Set HP","!SELF","0"},
                    {"Play Sound","vo/k_lab/kl_comeout.wav"},
                    {"Play Sound","npc/headcrab/headbite.wav"}
                }, specialCheck = "C_EnemySel", sdesc = "Inflige el HP de esta unidad +3 de daño a cualquier enemigo y muere.", scost = 3, suses = 1,
                spick = 2,
                lane = "zombie"
            },
            zombie_poisoncrab = {
                name = "Poisoncrab", type = "unidad",
                mdl = "models/headcrabblack.mdl", mdlSeq = "Idle01", mdlScale = 2,
                atk  = 3, hp = 3, cost = 2, eMissMul = 1.5, sCritMul = 1.2,
                special = {
                    {"Set HP","!EID!SID","1"},
                    {"Set Block","!EID!SID","[!EID!SID::block>1?!EID!SID::block:1]"},
                    {"Set ATK","!SELF","1"}
                },
                specialKill = {
                    {"Terminate","[!RAND<0.4?0:1]"},
                    {"Set Unit","!SELF","zombie_tank"},
                    {"Set HP","!SELF","!SELF::hp*!RAND"}
                }, specialCheck = "C_EnemySel", sdesc = "Reduce el HP del enemigo a 1, el ATK de esta unidad a 1 y vuelve al enemigo inmune a 1 ataque. ~40% para convertirse en Tanque al matar.", scost = 2, suses = 1,
                spick = 2,
                lane = "zombie"
            },
            zombie_dreadspirit = {
                name = "Espíritu aterrador", type = "unidad",
                mdl = "models/Gibs/HGIBS.mdl", mdlScale = 4, elev = 10, cr = 5, cb = 0.7, cg = 0.8,
                atk  = 3, hp = 5, cost = 4, eMissMul = 1.5, sCritMul = 1.2, float = true,
                special = {
                    {"Set HP","!EID0","!EID0::hp-3"},
                    {"Set HP","!EID1","!EID1::hp-3"},
                    {"Set HP","!EID2","!EID2::hp-3"},
                    {"Set HP","!EID3","!EID3::hp-3"},
                    
                    {"Set ATK","!AID0","[!AID0::hp==1?!AID0::atk-1:!AID0::atk]"},
                    {"Set HP","!AID0","[!AID0::hp>1?!AID0::hp-1:1]"},
                    
                    {"Set ATK","!AID1","[!AID1::hp==1?!AID1::atk-1:!AID1::atk]"},
                    {"Set HP","!AID1","[!AID1::hp>1?!AID1::hp-1:1]"},
                    
                    {"Set ATK","!AID2","[!AID2::hp==1?!AID2::atk-1:!AID2::atk]"},
                    {"Set HP","!AID2","[!AID2::hp>1?!AID2::hp-1:1]"},
                    
                    {"Set ATK","!AID3","[!AID3::hp==1?!AID3::atk-1:!AID3::atk]"},
                    {"Set HP","!AID3","[!AID3::hp>1?!AID3::hp-1:1]"},
                    
                    {"Play Sound","physics/flesh/flesh_bloody_break.wav"},
                    {"Play Sound","npc/ichthyosaur/water_growl5.wav"}
                }, sdesc = "-3HP a todos los enemigos, pero -1HP a todos los aliados. Si un aliado ya tiene 1 HP, reduce el ATK en su lugar.", scost = 3, suses = 2,
                spick = 0,
                lane = "zombie"
            },
            zombie_zombie = {
                name = "Zombie", type = "unidad",
                mdl = "models/Zombie/Classic.mdl", mdlScale = 1.2,
                atk = 4, hp = 4, cost = 5, eMissMul = 1.3, sCritMul = 1.1, sMissMul = 0.75,
                special = {
                    {"Set HP","!AID!SID","!AID!SID::hp+!SELF::hp"},
                    {"Set HP","!SELF","0"},
                    {"Play Sound","npc/zombie/zombie_pain4.wav"}
                },
                specialDeath = {
                    {"Terminate","[!RAND<0.66?0:1]"},
                    {"Set Unit","!SELF","zombie_headcrab"},
                    {"Set ATK","!SELF","1"},
                    {"Set HP","!SELF","1"}
                }, specialCheck = "C_AllySel", sdesc = "Da todo el HP de esta unidad a cualquier aliado, muriendo en el proceso. Puede dejar caer un headcrab al morir.", scost = 3,
                spick = 1,
                lane = "zombie"
            },
            zombie_damned = {
                name = "Maldito", type = "unidad",
                mdl = "models/Zombie/Fast.mdl", mdlScale = 1.1,
                atk = 5, hp = 4, cost = 5, eMissMul = 1.2, sCritMul = 1.2, sMissMul = 0.55,
                special = {
                    {"Set HP","!SELF","!SELF::hp-2"},
                    {"Set HP","!EID!SID","!EID!SID::hp-4"},
                    {"Play Sound","npc/fast_zombie/claw_strike1.wav"},
                    {"Play Sound","npc/fast_zombie/fz_alert_close1.wav"}
                }, specialCheck = "C_EnemySel", sdesc = "-2 HP para uno mismo, -4 HP para el enemigo.", scost = 2,
                spick = 2,
                lane = "zombie"
            },
            zombie_tank = {
                name = "Tanque", type = "unidad",
                mdl = "models/Zombie/Poison.mdl", mdlScale = 1.5,
                atk = 5, hp = 7, cost = 8, eMissMul = 1.2,
                special = {
                    {"Set HP","!SELF","!SELF::hp-2"},
                    {"Set ATK","!SELF","!SELF::atk+1"},
                    {"Add Card","!AID","zombie_poisoncrab"},
                    {"Add Card","!AID","[!RAND<0.4?zombie_poisoncrab:none]"},
                    {"Play Sound","npc/zombie_poison/pz_warn1.wav"},
                    {"Play Sound","physics/flesh/flesh_squishy_impact_hard3.wav"}
                }, sdesc = "-2 HP y +1 ATK a esta unidad. Se añaden 1 o 2 Poisoncrab a tu mazo.", scost = 3, suses = 2,
                spick = 0,
                lane = "zombie"
            },
            
            -- // Buildings
            build_hospital = {
                name = "Hospital", type = "estructura", 
                mdl = "models/Items/HealthKit.mdl", mdlScale = 4, mdlYaw = 180,
                cost = 5,
                special = {
                    {"Set HP","!SELF","[!SELF::hp<!SELF::hpm?!SELF::hp+[!RAND<0.66?1:2]:!SELF::hp]"},
                    {"Play Sound","items/medshot4.wav","110","0.7"}
                }, sdesc = "Cura a la unidad en el carril por 1 o 2 HP cada turno, siempre que no esté sobrecurada.",
                lane = "todos"
            },
            build_lantern = {
                name = "Linterna", type = "estructura", 
                mdl = "models/Items/combine_rifle_ammo01.mdl", mdlScale = 5,
                cost = 6,
                specialOnce = {
                    {"Set Miss Mul VS Self","!SELF","!SELF::eMissMul+0.33"},
                }, sdesc = "La unidad en el carril es más difícil de alcanzar.",
                lane = "todos"
            },
            build_shielder = {
                name = "Escudero", type = "estructura", material = "models/debug/debugwhite",
                mdl = "models/props_c17/gravestone_cross001a.mdl", mdlScale = 0.8, cr=1,cg=1,cb=5,elev=8.5,
                cost = 8,
                special = {
                    {"Terminate","[!RN1<0.23?1:0]"},
                    {"Terminate","[!SELF::block>0?1:0]"},
                    {"Set Block","!SELF","1"},
                    {"Play Sound","physics/metal/metal_barrel_impact_hard3.wav","150"}
                }, sdesc = "23% para dar a la unidad un escudo cada turno. No se apila.",
                lane = "todos"
            },
            build_avenger = {
                name = "Vengador", type = "estructura", material = "models/debug/debugwhite",
                mdl = "models/props_c17/gravestone_cross001b.mdl", mdlScale = 0.8, cr=5,cg=1,cb=1,elev=7,
                cost = 9,
                specialDeath = {
                    {"Set HP","!EID0","!EID0::hp-2*!RAND"},
                    {"Set HP","!EID1","!EID1::hp-2*!RAND"},
                    {"Set HP","!EID2","!EID2::hp-2*!RAND"},
                    {"Set HP","!EID3","!EID3::hp-2*!RAND"}
                }, sdesc = "Al morir la unidad, cada enemigo recibe aleatoriamente hasta 2 DAÑO.",
                lane = "todos"
            },
            build_fortress = {
                name = "Fortaleza", type = "estructura",
                mdl = "models/props_trainstation/trainstation_ornament002.mdl", mdlScale = 3,
                cost = 4,
                specialOnce = {
                    {"Set HP","!SELF","!SELF::hp+3"},
                    {"Set Max HP","!SELF","!SELF::hpm+3"}
                }, sdesc = "La unidad en el carril obtiene +3 HP.",
                lane = "todos"
            },
            build_stronghold = {
                name = "Ciudadela", type = "estructura",
                mdl = "models/XQM/CoasterTrack/train_car_1.mdl", mdlScale = 0.7, cr = 0.5, cg = 0.5, cb = 0.7,
                cost = 6,
                specialOnce = {
                    {"Set Armor","!SELF","!SELF::armor+1"},
                }, sdesc = "Unit on the lane gets +1 armor.",
                lane = "todos"
            },
            build_tower = {
                name = "Torre", type = "estructura",
                mdl = "models/props_junk/propane_tank001a.mdl", mdlScale = 2.5, elev = 5,
                cost = 6,
                specialOnce = {
                    {"Set ATK","!SELF","!SELF::atk+2"}
                }, sdesc = "Unit on the lane gets +2 ATK.",
                lane = "todos"
            },
            build_powerplant = {
                name = "Planta de energía", type = "estructura",
                mdl = "models/maxofs2d/thruster_projector.mdl", mdlScale = 3.25,
                cost = 5,
                specialOnce = {
                    {"Set Mana","!AID","[!SELF::cost<=2?[!SELF::cost==1?!MANA:!MANA+1]:!MANA+2]"}
                }, sdesc = "Obtendrá hasta 2 MP reembolsados ​​por cualquier unidad colocada en este carril, sin embargo, no más de su costo original.",
                lane = "todos"
            },
            build_castle = {
                name = "Castillo", type = "estructura",
                mdl = "models/props_trainstation/trainstation_ornament001.mdl", mdlScale = 1,
                cost = 9,
                specialOnce = {
                    {"Set HP","!SELF","!SELF::hp+4"},
                    {"Set Max HP","!SELF","!SELF::hpm+4"},
                    {"Set ATK","!SELF","!SELF::atk+2"},
                }, sdesc = "La unidad en el carril obtiene +4 HP y +2 ATK.",
                lane = "todos"
            },
            build_unitypyramid = {
                name = "Pirámide de la unidad", type = "estructura", material = "brick/brick_model",
                mdl = "models/hunter/misc/squarecap1x1x1.mdl", mdlScale = 1.2, cr=2,cg=1.5,cb=0,elev=5,
                cost = 8,
                specialOnce = {
                    {"Set HP","!SELF","[!AID0::hp>0?!SELF::hp+2:!SELF::hp]"},
                    {"Set HP","!SELF","[!AID1::hp>0?!SELF::hp+2:!SELF::hp]"},
                    {"Set HP","!SELF","[!AID2::hp>0?!SELF::hp+2:!SELF::hp]"},
                    {"Set HP","!SELF","[!AID3::hp>0?!SELF::hp+2:!SELF::hp]"},
                }, sdesc = "La unidad en el carril obtiene +2 HP por cada unidad activa que tenía al momento de colocarla.",
                lane = "todos"
            },
            build_crate = {
                name = "Caja", type = "estructura",
                mdl = "models/props_junk/wood_crate001a.mdl", mdlScale = 1.5, elev=3, mdlYaw=15,
                cost = 3,
                specialDeath = {
                    {"Draw Weak Card","!AID"},
                    {"Draw Weak Card","!AID"},
                    {"Play Sound","physics/wood/wood_box_break1.wav"},
                    {"Set Building","!AID!LID","none"}
                }, sdesc = "Se agregan 2 cartas a tu mazo cuando la unidad debajo de este edificio muere y la caja se pierde en el proceso.",
                lane = "todos"
            },
            build_mirror = {
                name = "Espejo", type = "estructura",
                mdl = "models/props_c17/Frame002a.mdl", material = "debug/env_cubemap_model", mdlScale = 1.5, elev=4, float=true,
                cost = 3,
                special = {
                    {"Terminate","[!SELF1::cv_swap==1?0:1]"},
                    {"Set Building","!SELF","none"},
                    {"Swap Position","!SELF","!ENEMY"},
                    {"Set ATK","!SELF","!SELF::atk*0.8"},
                    {"Set HP","!SELF","!SELF::hp*0.8"},
                    {"Play Sound","friends/friend_online.wav","75","0.8"},
                    {"Play Sound","physics/glass/glass_sheet_break2.wav","120","0.9"}
                },
                specialDeath = {
                    {"Terminate","[!RAND<0.3333?0:1]"},
                    {"Set Custom Value","!SELF1","swap","1"}
                }, sdesc = "Cuando una unidad muere, hay un 33% de posibilidades de que la unidad enemiga del carril opuesto se convierta a tu lado, aunque con menos HP, y el espejo se elimina en el proceso.",
                lane = "todos"
            },
            build_thumper = {
                name = "Golpeador", type = "estructura",
                mdl = "models/props_combine/CombineThumper001a.mdl", mdlScale = 0.25,
                cost = 9,
                special = {
                    {"Set HP","!EID0","[!EID0::lane==!SELF::lane?!EID0::hp-[!RAND<0.66?2:0]:EID0::hp]"},
                    {"Set HP","!EID1","[!EID1::lane==!SELF::lane?!EID1::hp-[!RAND<0.66?2:0]:EID1::hp]"},
                    {"Set HP","!EID2","[!EID2::lane==!SELF::lane?!EID2::hp-[!RAND<0.66?2:0]:EID2::hp]"},
                    {"Set HP","!EID3","[!EID3::lane==!SELF::lane?!EID3::hp-[!RAND<0.66?2:0]:EID3::hp]"},
                    {"Play Sound","ambient/machines/thumper_hit.wav","135"}
                }, sdesc = "Los carriles enemigos del mismo tipo que este carril tienen un 66% para recibir 2 daños cada turno.",
                lane = "todos"
            },
            build_obelisk = {
                name = "Obelisco", type = "estructura",
                mdl = "models/phxtended/trieq1x1x2solid.mdl", mdlScale = 0.8, mdlYaw = -45, cr=2,cg=0.5,cb=0.25,
                cost = 10,
                special = {
                    {"Set HP","!ENEMY","!ENEMY::hp-1"},
                    {"Play Sound","[!ENEMY::hp>0?npc/turret_floor/shoot3.wav:ambient/_period.wav]","80"}
                }, sdesc = "Inflige 1 DAÑO al enemigo en el carril opuesto cada turno.",
                lane = "todos"
            },
            build_oildrum = {
                name = "Barril explosivo", type = "estructura",
                mdl = "models/props_c17/oildrum001_explosive.mdl", mdlScale = 1.2, cr = 2,
                cost = 8,
                specialDeath = {
                    {"Play Sound","weapons/explode3.wav","90"},
                    {"Set Building","!SELF","none"},
                    {"Set HP","!ENEMY","!ENEMY::hp*0.5"}
                }, sdesc = "Cuando la unidad en este carril muere, el HP del atacante se reduce a la mitad y el barril se pierde.",
                lane = "todos"
            },
            build_powersigil = {
                name = "Sello de poder", type = "estructura",
                mdl = "models/props_combine/breenglobe.mdl", mdlScale = 4, elev = 3, cr = 0.1, cg = 0.2, cb = 1,
                material = "models/shiny",
                cost = 10,
                specialKill = {
                    {"Set ATK","!SELF","!SELF::atk+1"},
                    {"Play Sound","friends/friend_online.wav","110"}
                },
                sdesc = "Las unidades en este carril obtienen 1 ATK cada muerte.",
                lane = "todos"
            },
            
            -- // Powers
            power_strike = {
                name = "Strike", type = "hechizo", cost = 4,
                special = {
                    {"Set HP","!ENEMY","!ENEMY::hp-4"},
                    {"Play Sound","weapons/pistol/pistol_fire2.wav","70"}
                }, specialCheck = "C_EnemySel", sdesc = "Inflige 4 daños a cualquier unidad enemiga.",
                spick = 2,
                lane = "todos"
            },
            power_lightning = {
                name = "Rayo", type = "hechizo", cost = 5,
                special = {
                    {"Set Player HP","!EID","!EHP-8"},
                    {"Play Sound","weapons/357/357_fire2.wav","85"}
                }, specialCheck = "C_Always", sdesc = "Daña al otro jugador directamente por 8 HP.",
                spick = 0,
                lane = "todos"
            },
            power_impair = {
                name = "Perjudicar", type = "hechizo", cost = 3,
                special = {
                    {"Set ATK","!ENEMY","!ENEMY::atk-2"},
                    {"Play Sound","weapons/grenade/tick1.wav","70"}
                }, specialCheck = "C_EnemySel", sdesc = "Reduce el ATK de la unidad enemiga en 2.",
                spick = 2,
                lane = "todos"
            },
            power_sabotage = {
                name = "Sabotaje", type = "hechizo", cost = 6,
                special = {
                    {"Set Prevent ATK","!ENEMY","!ENEMY::noatk+1"},
                    {"Play Sound","weapons/stunstick/spark2.wav"}
                }, specialCheck = "C_EnemySel", sdesc = "Evita que el enemigo ataque el próximo turno.",
                spick = 2,
                lane = "todos"
            },
            power_shield = {
                name = "Escudo", type = "hechizo", cost = 7,
                special = {
                    {"Set Block","!SELF","!SELF::block+1"},
                    {"Play Sound","physics/metal/metal_barrel_impact_hard3.wav","135"}
                }, specialCheck = "C_AllySel", sdesc = "Protege a tu unidad del próximo ataque.",
                spick = 1,
                lane = "todos"
            },
            power_armor = {
                name = "Armadura", type = "hechizo", cost = 6,
                special = {
                    {"Set Armor","!SELF","!SELF::armor+1"},
                    {"Play Sound","physics/metal/metal_barrel_impact_hard2.wav","150"}
                }, specialCheck = "C_AllySel", sdesc = "Agrega +1 armadura a tu unidad.",
                spick = 1,
                lane = "todos"
            },
            power_mist = {
                name = "Neblina", type = "hechizo", cost = 8,
                special = {
                    {"Set Miss Mul VS Self","!SELF","!SELF::eMissMul+0.25"},
                    {"Play Sound","weapons/flaregun/fire.wav","135"}
                }, specialCheck = "C_AllySel", sdesc = "Haz que tu unidad sea un 25 % más difícil de alcanzar.",
                spick = 1,
                lane = "todos"
            },
            power_heal = {
                name = "Sanar", type = "hechizo", cost = 3,
                special = {
                    {"Set HP","!SELF","!SELF::hp+3"},
                    {"Play Sound","items/medshot4.wav"}
                }, specialCheck = "C_AllySel", sdesc = "Cura 3 HP a la unidad.",
                spick = 1,
                lane = "todos"
            },
            power_draw = {
                name = "Dibujar", type = "hechizo", cost = 3,
                special = {
                    {"Draw Weak Card","!AID"},
                    {"Play Sound","physics/cardboard/cardboard_box_impact_bullet1.wav"}
                }, specialCheck = "C_Always", sdesc = "Añade una carta a tu mazo.",
                spick = 0,
                lane = "todos"
            },
            power_draw3x = {
                name = "Draw 3x", type = "hechizo", cost = 8,
                special = {
                    {"Draw Weak Card","!AID"},
                    {"Draw Weak Card","!AID"},
                    {"Draw Weak Card","!AID"},
                    {"Play Sound","physics/cardboard/cardboard_box_impact_bullet1.wav"}
                }, specialCheck = "C_Always", sdesc = "Añade 3 cartas débiles a tu mazo.",
                spick = 0,
                lane = "todos"
            },
            power_divinepower = {
                name = "Poder divino", type = "hechizo", cost = 3,
                special = {
                    {"Set Player HP","!AID","!AHP+10"},
                    {"Play Sound","items/medshot4.wav","80"}
                }, specialCheck = "C_Always", sdesc = "Cúrate a ti mismo (al jugador) por 10 hp.",
                spick = 0,
                lane = "todos"
            },
            power_sheal = {
                name = "Supercuración", type = "hechizo", cost = 5,
                special = {
                    {"Set HP","!AID0","!AID0::hp+2"},
                    {"Set HP","!AID1","!AID1::hp+2"},
                    {"Set HP","!AID2","!AID2::hp+2"},
                    {"Set HP","!AID3","!AID3::hp+2"},
                    {"Play Sound","items/medshot4.wav","90"}
                }, specialCheck = "C_Always", sdesc = "Cura 2 HP a todas las unidades.",
                spick = 0,
                lane = "todos"
            },
            power_empower = {
                name = "Empoderar", type = "hechizo", cost = 4,
                special = {
                    {"Set ATK","!SELF","!SELF::atk+3"},
                    {"Play Sound","items/suitchargeok1.wav","120"}
                }, specialCheck = "C_AllySel", sdesc = "Agrega 3 ATK a la unidad.",
                spick = 1,
                lane = "todos"
            },
            power_comspirit = {
                name = "Espíritu de combate", type = "hechizo", cost = 7,
                special = {
                    {"Set ATK","!AID0","!AID0::atk+1"},
                    {"Set ATK","!AID1","!AID1::atk+1"},
                    {"Set ATK","!AID2","!AID2::atk+1"},
                    {"Set ATK","!AID3","!AID3::atk+1"},
                    {"Play Sound","items/suitchargeok1.wav","100"}
                }, specialCheck = "C_Always", sdesc = "Cada unidad recibe +1 ATK.",
                spick = 0,
                lane = "todos"
            },
            power_discard = {
                name = "Sacrificio", type = "hechizo", cost = 2,
                special = {
                    {"Set Player HP","!AID","!AHP+!AID!SID::hp/2+5"},
                    {"Set HP","!SELF","0"},
                    {"Play Sound","weapons/physcannon/energy_bounce2.wav","75"}
                }, specialCheck = "C_AllySel", sdesc = "Sacrifica tu unidad y cúrate a ti mismo (al jugador) por el hp de la mitad de la unidad + 5.",
                spick = 1,
                lane = "todos"
            },
            power_steal = {
                name = "Robar", type = "hechizo", cost = 5,
                special = {
                    {"Add Card","!AID","!ENEMY::class"},
                    {"Add Card","!AID","!ENEMY::class"},
                    {"Play Sound","vo/npc/barney/ba_laugh02.wav","120"}
                }, specialCheck = "C_EnemySel", sdesc = "Agrega 2 copias de la unidad enemiga a tu mazo.",
                spick = 2,
                lane = "todos"
            },
            power_swapstat = {
                name = "Swapstat", type = "hechizo", cost = 8,
                special = {
                    {"Set Max HP","!SELF","!SELF::atk"},
                    {"Set ATK","!SELF","!SELF::hp"},
                    {"Set HP","!SELF","!SELF::hpm"},
                    {"Play Sound","friends/message.wav","80"}
                }, specialCheck = "C_AllySel", sdesc = "Cambia el ATK y HP de la unidad.",
                spick = 1,
                lane = "todos"
            },
            power_wildcard = {
                name = "Comodín", type = "hechizo", cost = 10,
                special = {
                    {"Set Max HP","!SELF","!RAND*15"},
                    {"Set ATK","!SELF","!RAND*15"},
                    {"Set HP","!SELF","!SELF::hpm"},
                    {"Play Sound","ambient/energy/zap1.wav","120"}
                }, specialCheck = "C_AllySel", sdesc = "Aleatoriza el ATK y HP de la unidad entre 0 y 15. ¡1/15 de probabilidad de ser letal!",
                spick = 1,
                lane = "todos"
            },
            power_nuke = {
                name = "Arma nuclear", type = "hechizo", cost = 10,
                special = {
                    {"Set HP","!SELF","0"},
                    {"Set HP","!ENEMY","0"},
                    {"Set Building","!SELF","none"},
                    {"Set Building","!ENEMY","none"},
                    {"Play Sound","phx/explode02.wav","80"}
                }, specialCheck = "C_Always", sdesc = "Mata a todas las unidades en un carril, tanto las tuyas como las enemigas. También destruye edificios.",
                spick = 0,
                lane = "todos"
            }
        } do
            info.custom    = false
            qcwCards[card] = info
        end
        
    -- }}}

    -- Lanes {{{
    
        qcwLaneTypes = {}
        setmetatable(qcwLaneTypes, {
            __newindex = function(t,k,v)
                if type(v)=="table" then
                    v.type  = "lane"
                    v.class = tostring(k)
                    if v.active == nil then
                        v.active = true
                    else
                        v.active = v.active and true or false
                    end
                    
                    if v.hidden == nil then
                        v.hidden = false
                    else
                        v.hidden = v.hidden and true or false
                    end
                    
                    v.cr = v.cr or math.random(0,255)
                    v.cg = v.cg or math.random(0,255)
                    v.cb = v.cb or math.random(0,255)
                    
                    rawset(t,k,v)
                end
            end
        })
        
        for lane,info in pairs {
            null = {
                name = "Ninguna", class = "null",
                color = Color(32,32,53)
            },
            rebel = {
                name = "Rebelde", class = "rebel",
                color = Color(245,120,66),
                desc = "Las Unidades Rebeldes tienen la mayor cantidad de HP de todas, pero un ATK bastante bajo. La mayoría de sus habilidades se enfocan en curar o robar vidas, además de ayudar al equipo."
            },
            combine = {
                name = "Combine", class = "combine",
                color = Color(33,161,196),
                desc = "Todas las Unidades Combine tienen un ATK alto, pero HP bajo. Sus habilidades se enfocan en matar rápidamente, dañar y quitarle el poder al oponente."
            },
            zombie = {
                name = "Zombi", class = "zombie",
                color = Color(124,51,46),
                desc = "Los zombis son débiles, pero numerosos y persistentes. Un headcrab puede convertirse en un zombi y un zombi puede dejar caer un headcrab. La mayoría de sus habilidades tienen que ver con el sacrificio, matarse o debilitarse a sí mismos, y es más fácil pasarlos por alto."
            },
            antlion = {
                name = "Hormiga león", class = "antlion",
                color = Color(189, 194, 58),
                desc = "Las hormigas león son muy completas y sus habilidades les permiten bloquear los ataques enemigos y evitar que usen sus habilidades."
            }
        } do
            info.type   = "lane"
            info.custom = false
            local c = info.color
            info.cr = c.r
            info.cg = c.g
            info.cb = c.b
            info.color = nil
            qcwLaneTypes[lane] = info
        end
        
    -- }}}

-- // }}}
    
-- // Entity functions {{{

    function ENT:qcwChecks()
        local data = self.qcwData
        for pid=1,2 do
            for lid=0,3 do
                local unit = data["unidad"..pid..lid]
                if unit then
                    local type = qcwCards[unit.class]
                    
                    if unit.hp>unit.hpm then
                        unit.hpm = unit.hp
                        unit.hpc = qcwStatMore
                    elseif unit.hpm<type.hp then
                        unit.hpc = qcwStatReduced
                    elseif unit.hp<=0 then
                        local ei = "unidad"..oppositeTeam(pid)..oppositeLane(lid)
                        self:qcwDoSpecial(data[ei],0,"Kill",true)
                        self:qcwDoSpecial(data["estructura"..oppositeTeam(pid)..oppositeLane(lid)],0,"Kill",true)
                        self:qcwDoSpecial(data["unidad"..pid..lid],0,"Death",true)
                        self:qcwDoSpecial(data["estructura"..pid..lid],0,"Death",true)
                        if data["unidad"..pid..lid] and data["unidad"..pid..lid].uid==unit.uid then
                            data["unidad"..pid..lid] = nil
                        end
                        
                        if data[ei] and data[ei].hp<=0 then
                            data[ei] = nil
                        end
                    end
                    
                    if unit.atk>type.atk then
                        unit.atkc = qcwStatMore
                    elseif unit.atk<type.atk then
                        unit.atkc = qcwStatReduced
                    end
                end
            end
        end
        
        local pl, pid = self:qcwGetPlayer()
        if data["mana"..pid]<=0 then
            self:qcwProgressTurn()
        end
    end

    function ENT:qcwDoSpecial(unit,sel,add,nochecks)
        if not unit then return false end
        if (add~="" and add~=nil) or qcwSpecials[unit.specialCheck or "C_Always"](self,unit,sel) then
            for i=1,4 do _qcwRands[i] = math.random() end
            for id,info in ipairs(unit["special"..(add or "")] or {}) do
                local terminate = qcwSpecials[info[1]].func(self,unit,sel or -1,unpack(info,2))
                if terminate then
                    break
                end
            end
            if not nochecks then
                self:qcwChecks()
            end
            return true
        else
            return false
        end
    end

    function ENT:qcwProgressTurn()
        
        for pid=1,2 do
            self.qcwData["spcur"..pid] = -1 
            for lid=0,3 do
                self.qcwData["spmode"..pid..lid] = -1
            end
        end
        
        self.lost1, self.lost2 = self.qcwData["plhp1"]<=0, self.qcwData["plhp2"]<=0
        if self.lost1 or self.lost2 then
            self.busy = true
            
            sound.Play("weapons/physcannon/energy_disintegrate5.wav",self:GetPos(),75)
            timer.Simple(1,function() if IsValid(self) then
                local lost = self:GetNWEntity("pl"..(self.lost1 and 1 or 2),Entity(1)):Nick()
                local won  = self:GetNWEntity("pl"..(self.lost1 and 2 or 1),Entity(1)):Nick()
                PrintMessage(3, ("[QCW] ¡%s ganó contra %s!"):format(won,lost))
                self:SetModelScale(0,0.25)
            end end)
            timer.Simple(1.25,function() if IsValid(self) then
                self:Remove()
            end end)
            
            return
        end
        
        local st, oldTurn = self:GetNWInt("gameStatus",0), self:GetNWInt("turn",0)
        if st==2 and oldTurn>1 then
            -- Attacking
            local pl, pid = self:qcwGetPlayer()
            self:SetNWInt("gameStatus",3)
            self.busy = true
            
            local attacked = 0
            for i=0,3 do
                local card = self.qcwData["unidad"..pid..i]
                if card then
                    timer.Simple(1+attacked*1.5,function() if IsValid(self) and self.qcwData["unidad"..pid..i]==card then
                        -- Effect
                        local ot, ol = oppositeTeam(pid), oppositeLane(i)
                        local enemy = self:qcwGetLaneCards(ot, ol)
                        
                        local miss, crit = 
                            math.Clamp(math.floor(20*(card.sMissMul or 1)*(enemy.eMissMul or 1)),0,100) * (card.noatk>0 and 100 or 1), 
                            math.Clamp(math.floor(10*(card.sCritMul or 1)*(enemy.eCritMul or 1)),0,100)
                        crit = math.Clamp(crit,0,100-miss)
                        local mch = math.Clamp(100-miss-crit,0,50)
                        local rand = math.random(mch,100+mch)
                        local dmgMul
                        
                        if rand<=100-miss-crit or rand>100 then
                            dmgMul = 1
                        elseif rand<=100-miss then
                            dmgMul = 2
                        else
                            dmgMul = 0
                        end
                        
                        local ed = EffectData()
                            ed:SetEntity(self)
                            ed:SetOrigin(self:GetPos())
                            ed:SetRadius((pid==1 and i or 3-i))
                            ed:SetStart (Vector(miss,crit,rand))
                        util.Effect("qcwHitCircle", ed)
                            
                        timer.Simple(0.4+rand/120, function() if IsValid(self) then
                            if dmgMul==0 then
                                sound.Play("weapons/iceaxe/iceaxe_swing1.wav",self:GetPos(),75)
                            end
                            self:SetNWInt("cPunchLane", i)
                            self:SetNWInt("cPunchPid" , pid)
                            self:SetNWInt("cPunchTime", self:GetNWInt("cPunchTime", 0)+1 )
                            
                            local dmg = math.Round(card.atk*dmgMul) or 0
                            if dmg>0 then
                                dmg = math.max(dmg-(enemy.armor or 0),1)
                                if enemy.lane then
                                    if enemy.block>0 then
                                        sound.Play("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav",self:GetPos())
                                        enemy.block = enemy.block - 1
                                    else
                                        if (enemy.armor or 0)>=1 then
                                            sound.Play("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav",self:GetPos(),75,math.random(96,104),0.8)
                                        end
                                        enemy.hp = math.max(0,enemy.hp-dmg)
                                        if dmgMul>=2 then
                                            sound.Play("physics/body/body_medium_break2.wav",self:GetPos(),75,95,0.8)
                                        end
                                        sound.Play("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav",self:GetPos())
                                        if enemy.hp<=0 then
                                            local data = self.qcwData
                                            sound.Play("physics/glass/glass_largesheet_break"..math.random(1,3)..".wav",self:GetPos(),75,110,0.6)
                                            local ei = "unidad"..oppositeTeam(ot)..oppositeLane(ol)
                                            self:qcwDoSpecial(data[ei],0,"Kill",true)
                                            self:qcwDoSpecial(data["estructura"..oppositeTeam(ot)..oppositeLane(ol)],0,"Kill",true)
                                            self:qcwDoSpecial(data["unidad"..ot..ol],0,"Death",true)
                                            self:qcwDoSpecial(data["estructura"..ot..ol],0,"Death",true)
                                            if data["unidad"..ot..ol] and data["unidad"..ot..ol].uid==enemy.uid then
                                                data["unidad"..ot..ol] = nil
                                            end
                                            
                                            if data[ei] and data[ei].hp<=0 then
                                                data[ei] = nil
                                            end
                                        end
                                    end
                                else
                                    self.qcwData["plhp"..ot] = math.Max(0,math.Round(self.qcwData["plhp"..ot]-math.Clamp(dmg*(-1/oldTurn+1),0,self:GetNWInt("plhpMax",100)/5+oldTurn)))
                                    if dmgMul>=2 then
                                        sound.Play("physics/body/body_medium_break2.wav",self:GetPos(),75,95,0.8)
                                    end
                                    sound.Play("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav",self:GetPos())
                                    
                                    local newHp = self.qcwData["plhp"..ot]
                                    
                                    if newHp==0 and not self.over then
                                        self.over = true
                                        local loser, winner = self:GetNWEntity("pl"..ot), self:GetNWEntity("pl"..pid)
                                        sound.Play("phx/kaboom.wav",self:GetPos())
                                        
                                        if loser and loser.ScreenFade then
                                            loser:ScreenFade(1,ColorAlpha(qcwRed,66),2,0)
                                        end
                                        
                                        if winner and winner.ScreenFade then
                                            winner:ScreenFade(1,ColorAlpha(qcwGreen,66),2,0)
                                        end
                                    else
                                        local pl = self:GetNWEntity("pl"..ot)
                                        if pl and pl.ScreenFade then
                                            pl:ScreenFade(1,ColorAlpha(qcwRed,50),0.5,0)
                                        end
                                    end
                                end
                                
                                if card.noatk>0 then
                                    sound.Play("buttons/button10.wav",self:GetPos())
                                end
                                
                                net.Start("qcw_sendTableData")
                                    net.WriteEntity(self)
                                    net.WriteTable(self.qcwData)
                                net.Broadcast()
                            end
                            card.noatk = math.max(0,card.noatk-1)
                            card.nospecial = math.max(0,card.nospecial-1)
                            
                        end end)
                        
                    end end)
                    attacked = attacked + 1
                end
            end
            
            timer.Simple(1+attacked*1.5+0.5,function()
                if IsValid(self) then
                    self:qcwProgressTurn()
                    self.busy = false
                end
            end)
            
            net.Start("qcw_sendTableData")
                net.WriteEntity(self)
                net.WriteTable(self.qcwData)
            net.Broadcast()
            
        else
            -- Passing the turn
            local turn = oldTurn+1
            self:SetNWInt("turn",turn)
            self:SetNWInt("gameStatus",2)
            local pl, pid = self:qcwGetPlayer()
            local aturn = self:qcwGetTurn()
            self.qcwData["mana"..pid] = math.Round(aturn<=12 and aturn or (aturn-12)^0.7+12)
            self.qcwData["sel1"] = 0
            self.qcwData["sel2"] = 0
            
            local function sorter(a,b)
                return (a.type or "a")..(a.cost or 1/0)..(a.lane or "z")< (b.type or "a")..(b.cost or 1/0)..(b.lane or "z")
            end
            
            local deckAll = self.qcwData["deckAll"..pid]
            table.sort(deckAll,sorter)
            
            local deck = {}
            
            for lid=0,3 do
                local building = self.qcwData["estructura"..pid..lid]
                if building and building.special then
                    self:qcwDoSpecial(building,0)
                end
            end
            
            -- This might be messy, but I think it's relatively quick
            local lmuls = {}
            for i=0,3 do
                local t = self.qcwData["l"..pid..i]
                lmuls[t] = (lmuls[t] or 0) + 1 
            end
            
            local oftype = {}
            for id,card in ipairs(deckAll) do
                local cdata = qcwCards[card]
                if cdata then
                    cdata.class = card
                    
                    local ctype = cdata.type=="unidad" and (cdata.lane or "todos") or cdata.type
                    local mul = cdata.lane~="todos" and lmuls[cdata.lane] or 1
                    
                    if cdata.cost<=self.qcwData["mana"..pid] and math.random()<0.8 and (oftype[ctype] or 0)<math.max(1,math.floor((aturn^0.72-aturn/4))) then
                        table.insert(deck,cdata)
                        oftype[ctype] = (oftype[ctype] or 0) + 1/mul
                    end
                end
            end
            table.sort(deck,sorter)
            for id,card in ipairs(deck) do
                deck[id] = card.class
            end
            
            self.qcwData["deck"..pid] = deck
            net.Start("qcw_sendTableData")
                net.WriteEntity(self)
                net.WriteTable(self.qcwData)
                net.WriteEntity(pl)
            net.Broadcast()
        end
    end

    function ENT:qcwGetTurn()
        local turn = self:GetNWInt("turn",0)
        return math.ceil( (turn-1)/2 + 0.1 )
    end

    function ENT:qcwPlaceCard(pid, lid, ctype, force, nochecks)
        local cdata = qcwCards[ctype]
        if not cdata then return end
        
        local data, append = self.qcwData, pid..lid
        if (cdata.lane == data["l"..append]) or (cdata.lane == "todos") or force then
            local card = table.Copy(cdata)
            card.eMissMul = card.eMissMul or 1
            card.sMissMul = card.sMissMul or 1
            card.eCritMul = card.eCritMul or 1
            card.sCritMul = card.sCritMul or 1
            card.class = ctype
            card.team = pid
            card.block = 0
            card.noatk = 0
            card.nospecial = 1
            card.lid = lid
            card.hpm = card.hp
            card.uid = math.floor(CurTime()*(math.random()+0.25))..card.class
            data[card.type..append] = card
            util.PrecacheModel(card.mdl)
            
            if card.type == "estructura" then
                local u = data["unidad"..pid..lid]
                if (u and not u["did"..card.class] and card.specialOnce) then
                    self:qcwDoSpecial(card,0,"Once",true)
                end
            elseif card.type == "unidad" then
                local b = data["estructura"..pid..lid]
                if (b and b.specialOnce) then
                    self:qcwDoSpecial(b,0,"Once",true)
                end
            elseif card.type == "hechizo" then
                self:qcwDoSpecial(card,card.spick==2 and 3-lid or lid,"") 
                data["hechizo"..append] = nil
            end
            
            if not nochecks then
                if data["mana"..pid]<=0 and card.type~="hechizo" then
                    self:qcwProgressTurn()
                else
                    net.Start("qcw_sendTableData")
                        net.WriteEntity(self)
                        net.WriteTable(data)
                    net.Broadcast()
                end
            end
            
            return card
        end
    end

    function ENT:qcwGetLaneCards(pid, lid)
        local data, append = self.qcwData, pid..lid
        return data["unidad"..append] or self:GetNWEntity("pl"..pid), data["estructura"..append]
    end

    function ENT:qcwGetPlayer()
        local pid = ((self:GetNWInt("turn",0)+self:GetNWInt("turnOffset",0))%2)+1
        return self:GetNWEntity("pl"..pid, Entity(1)),pid
    end

    function ENT:qcwGenDeck(pid)
        local deck = {}
        local validLanes  = {}
        local validUnits  = {}
        local univUnits   = {{},{},{},{},{}}
        local buildings   = {{},{},{},{},{}}
        local powers      = {{},{},{},{},{}}
        
        for i=0,3 do
            local id = self.qcwData["l"..pid..i]
            validLanes[id] = (validLanes[id] or 0) + 1
        end
        
        for card,data in pairs(qcwCards) do
            if data.active and not data.nodeck and data.cost then
                if data.type=="unidad" then
                    if validLanes[data.lane] then
                        validUnits[data.lane] = validUnits[data.lane] or {{},{},{},{},{}}
                        table.insert(validUnits[data.lane][getMul(data.cost)], card)
                    elseif data.lane == "todos" then
                        table.insert(univUnits[getMul(data.cost)], card)
                    end
                elseif data.type=="estructura" then
                    table.insert(buildings[getMul(data.cost)], card)
                elseif data.type=="hechizo" then
                    table.insert(powers[getMul(data.cost)], card)
                end
            end
        end
        
        for lane,mul in pairs(validLanes) do
            local t = validUnits[lane] or univUnits
            for i=1,mul do
                -- could've done the smart way, but whatever
                table.insert(deck,getTableRandom(buildings[1]))
                table.insert(deck,getTableRandom(buildings[2]))
                table.insert(deck,getTableRandom(buildings[3]))
                table.insert(deck,getTableRandom(buildings[4]))
                table.insert(deck,getTableRandom(univUnits[1]))
                table.insert(deck,getTableRandom(univUnits[2]))
                table.insert(deck,getTableRandom(univUnits[3]))
                table.insert(deck,getTableRandom(univUnits[4]))
                
                table.insert(deck,getTableRandom(t[1]))
                table.insert(deck,getTableRandom(t[1]))
                table.insert(deck,getTableRandom(t[2]))
                table.insert(deck,getTableRandom(t[2]))
                table.insert(deck,getTableRandom(t[3]))
                table.insert(deck,getTableRandom(t[4]))
                
                table.insert(deck,getTableRandom(powers[1]))
                table.insert(deck,getTableRandom(powers[2]))
                table.insert(deck,getTableRandom(powers[3]))
                table.insert(deck,getTableRandom(powers[4]))
            end
        end
        
        table.insert(deck,getTableRandom(univUnits[1]))
        table.insert(deck,getTableRandom(univUnits[1]))
        table.insert(deck,getTableRandom(univUnits[3]))
        table.insert(deck,getTableRandom(univUnits[3]))
        table.insert(deck,getTableRandom(univUnits[4]))
        table.insert(deck,getTableRandom(univUnits[5]))
        table.insert(deck,getTableRandom(powers[2]))
        table.insert(deck,getTableRandom(powers[2]))
        table.insert(deck,getTableRandom(powers[3]))
        table.insert(deck,getTableRandom(powers[3]))
        
        self.qcwData["deckAll"..pid] = deck
        net.Start("qcw_sendTableData")
            net.WriteEntity(self)
            net.WriteTable(self.qcwData)
        net.Broadcast()
        
        return deck
    end

    function ENT:qcwPressed(pid,x,y,pl)
        local f = qcwPressFunc[self:GetNWInt("gameStatus",1)]
        if f and not self.busy then
            f(self,pid,x,y,pl)
        end
    end

    function ENT:qcwPos(pl,ep,ea)
        local tableAngle, tableScale = self:GetAngles(), self:GetModelScale()/8
        tableAngle.r = 0
        tableAngle.p = 0
        local tablePos = self:GetPos()+tableAngle:Up()*34
        if pl==1 then
            tableAngle:RotateAroundAxis(tableAngle:Forward(),4)
            tableAngle:RotateAroundAxis(tableAngle:Up(),180)
        else
            tableAngle:RotateAroundAxis(tableAngle:Forward(),-4)
        end
        local up, fwd = tableAngle:Up(), tableAngle:Forward()
        local vector  = util.IntersectRayWithPlane(ep,ea:Forward(),tablePos,up)
        
        if not vector then
            return 0, 0, VectorZero
        end
        
        -- This is from the Keypad mod, thanks to Robbis_1 / Willox
        local diff = tablePos-vector
        local mx = diff:Dot((tableAngle):Forward())/tableScale
        local my = diff:Dot((tableAngle):Right()  )/tableScale
        return mx, my, vector
    end
    
-- // }}}

-- // Entity {{{

    function ENT:Initialize()
        if SERVER then
            -- Visual
            self:SetModel      ("models/props_phx/trains/wheel_medium.mdl")
            self:SetMaterial   ("models/debug/debugwhite")
            self:SetColor      (qcwWhite)
            self:DrawShadow    (false)
            
            self:SetModelScale(0)
            self:SetModelScale(1,0.25)
            self:SetRenderMode(1)
            
            -- Physics
            self:PhysicsInit   (SOLID_VPHYSICS)
            self:SetSolid      (SOLID_VPHYSICS)
            self:SetMoveType   (MOVETYPE_VPHYSICS)
            
            self:SetNWEntity("creator",self:GetCreator())
            
            -- Game Data
            self:SetUseType(SIMPLE_USE)
            self:SetNWBool("playing", #player.GetHumans()<=1)
            self:SetNWInt ("gameStatus",1)
            
            -- Hooks
            hook.Add("KeyPress","qcwTableInteract"..self:EntIndex(),function(act,key)
                if key == IN_USE and self:GetNWBool("playing") then
                    local activePl = self:qcwGetPlayer()
                    local p1, p2 = self:GetNWEntity("pl1", Entity(1)), self:GetNWEntity("pl2", Entity(1))
                    if (self:GetNWInt("gameStatus")==1) or (activePl==act) then
                        if act==p1 then
                            local x,y = self:qcwPos(1,act:EyePos(),act:EyeAngles())
                            self:qcwPressed(1,x,y,act)
                        end
                        
                        if act==p2 then
                            local x,y = self:qcwPos(2,act:EyePos(),act:EyeAngles())
                            self:qcwPressed(2,x,y,act)
                        end
                    end
                end
            end)
            
            hook.Add("PlayerDisconnected","qcwDisconnect"..self:EntIndex(),function(pl)
                if pl==self:GetNWEntity("pl1") or pl==self:GetNWEntity("pl2") then
                    self:SetNWEntity("pl1", Entity(1))
                    self:SetNWEntity("pl2", Entity(1))
                    self:Remove()
                end
            end)
            
            local timerId = "qcw_table_"..tostring(self)
            
            timer.Create(timerId,6,0,function()
                if IsValid(self) and self:GetNWBool("playing") then
                    local pl1, pls = self:GetNWEntity("pl1"), self:GetNWEntity("pl2")
                    pl1 = IsValid(pl1) and pl1 or nil
                    pl2 = IsValid(pl2) and pl2 or nil
                    
                    net.Start("qcw_sendTableData")
                        net.WriteEntity(self)
                        net.WriteTable(self.qcwData)
                    if pl1 or pl2 then
                        net.Send { pl1 or pl2, pl1 and pl2 }
                    else
                        net.Broadcast()
                    end
                else
                    timer.Remove(timerId)
                end
            end)
            
        else
            self:SetRenderBounds(Vector(-256,-256,-256),Vector(256,256,256))
            
            -- Markup
            self.laneDescTable  = { {}, {}, {}, {}, {}, {}, {}, {} }
        end
        self.qcwData = {}
        
        self.lanesValid = {}
        for n,lane in pairs(qcwLaneTypes) do
            if n ~= "null" then
                table.insert(self.lanesValid,n)
            end
        end
        table.sort(self.lanesValid,function(a,b) return qcwLaneTypes[a].name<qcwLaneTypes[b].name end)
    end

    function ENT:OnRemove()
        hook.Remove("KeyPress","qcwTableInteract"..self:EntIndex())
        hook.Remove("PlayerDisconnected","qcwDisconnect"..self:EntIndex())
        for pid=1,2 do
            for lid=0,3 do
                if self.qcwData["mdl"..pid..lid] then
                    self.qcwData["mdl"..pid..lid]:Remove()
                end
            end
        end
    end

    function ENT:Use(act)
        local pl1, pl2 = self:GetNWEntity("pl1"), self:GetNWEntity("pl2")
        local null = Entity(0)
        --
        if not self.busy then
            if not self:GetNWBool("playing",false) then
                if IsValid(pl1) then
                    if pl1==act then
                        self:SetNWEntity("pl1",null)
                    else
                        self:SetNWEntity("pl2",act)
                        self:SetModelScale(0,0.5)
                        self.busy = true
                        timer.Simple(0.5,function()
                            if IsValid(self) then
                                self:SetNWBool("playing",true)
                                self:SetModelScale(1,0.5)
                                self.busy = false
                            end
                        end)
                    end
                else
                    self:SetNWEntity("pl1",act)
                end
            end
        end
        --
    end

    function ENT:Think()
        if CLIENT then
            local lp = LocalPlayer()
            local ep, ea = lp:EyePos(),lp:EyeAngles()
            local pid
            if self:GetNWEntity("pl1",Entity(1))==lp then
                pid = 1
            elseif self:GetNWEntity("pl2",Entity(1))==lp then
                pid = 2
            else
                return
            end
            local mx, my = self:qcwPos(pid,ep,ea)
            
            local lid
            if checkAABB(mx,my,-512,0,1024,512) then
                lid = math.Clamp(math.ceil((mx+512)/256),1,4)-1
            end
            
            for i=0,3 do
                self["lo"..pid..i] = math.Approach(self["lo"..pid..i] or 0,
                lid==i and 8 or 0,
                FrameTime()*32)
            end
            
            self.mdlCache = type(self.mdlCache)=="table" and self.mdlCache or {}
            self.mdlCacheB = type(self.mdlCacheB)=="table" and self.mdlCacheB or {}
        end
    end

    function ENT:Draw()
        self:DrawModel()
        
        if EyePos():DistToSqr(self:GetPos()) >= 5000000 then
            return
        end
        
        local tableAngle, tableScale = self:GetAngles(), self:GetModelScale()/8
        tableAngle.r = 0
        tableAngle.p = 0
        local isPlaying = self:GetNWBool("playing",false)
        local up,fwd = tableAngle:Up(), tableAngle:Forward()
        local close = self:GetPos():DistToSqr(EyePos())<20000
        
        if isPlaying then
            local tablePos = self:GetPos()+up*28
            
            -- Table
            cam.Start3D2D(tablePos,tableAngle,tableScale)
                draw.RoundedBox(16,-528,-522,1056,1044,qcwBlackLight)
            cam.End3D2D()
            
            -- Side Panel
            local gs = self:GetNWInt("gameStatus",1)
            cam.Start3D2D(tablePos-fwd*80+up*50,tableAngle+Angle(0,90,90),tableScale)
                local n1, n2 = shortenName(self:GetNWEntity("pl1", Entity(1)):Nick()), shortenName(self:GetNWEntity("pl2", Entity(1)):Nick())
                draw.SimpleTextOutlined("VS","QCWHuge",0,-46,qcwWhite,1,1,2,qcwBlack)
                draw.SimpleTextOutlined("ID "..self:EntIndex(),"QCWDesc",0,-96,qcwWhite,1,1,1,qcwBlack)
                draw.SimpleTextOutlined(n1,"QCWName",-120,-46,(self:GetNWInt("ready1",false) and qcwGreenLight or qcwBright),2,1,2,qcwBlack)
                draw.SimpleTextOutlined(n2,"QCWName", 120,-46,(self:GetNWInt("ready2",false) and qcwGreenLight or qcwBright),0,1,2,qcwBlack)
                
                if gs == 1 then
                    -- Lane Placement
                    draw.RoundedBox(8,-350,16,700,200,qcwBlack)
                    draw.SimpleText("¡Seleccione los tipos de carril!","QCWName",0,16,qcwBright,1)
                    if close then
                        draw.SimpleText("El tipo de carril determina qué unidades puedes colocar en ese carril","ScoreboardDefault",0,80,qcwBright,1)
                        draw.SimpleText("Por lo tanto, los rebeldes solo se pueden colocar en carriles rebeldes, los zombis solo en ","ScoreboardDefault",0,104,qcwBright,1)
                        draw.SimpleText("Carriles de zombis. También hay unidades universales que pueden ir a cualquier parte.","ScoreboardDefault",0,128,qcwBright,1)
                        draw.SimpleText("Tiene 4 carriles que pueden ser de cualquier tipo y puede usar el mismo tipo varias veces.","Trebuchet18",0,128+24,qcwWhite,1)
                        draw.SimpleText("Los administradores pueden crear tipos de carriles personalizados y unidades personalizadas que van en ellos.","Trebuchet18",0,128+38,qcwWhite,1)
                        draw.SimpleText("Interactúa con la mesa presionando la tecla [USE] sobre el holograma.","Trebuchet18",0,128+52,qcwWhite,1)
                    end
                elseif gs >= 2 then
                    -- Game
                    
                    local plhp = self:GetNWInt("plhpMax",100)
                    
                    local hp1,  hp2  = self.qcwData["plhp1"] or 0, self.qcwData["plhp2"] or 0
                    local hpp1, hpp2 = hp1/plhp, hp2/plhp
                    
                    surface.SetDrawColor(qcwBlack)
                    surface.DrawRect(-370,-24,250,34)
                    surface.DrawRect(120,-24,250,34)
                    
                    surface.SetDrawColor( (hpp1<0.35 and CurTime()%0.5<0.25) and qcwRed or qcwGreenLight)
                    surface.DrawRect(-368+246*(1-hpp1),-22,246*hpp1,30)
                    draw.SimpleTextOutlined(hp1.." / "..plhp,"ScoreboardDefaultTitle",-128,-6,qcwBright,2,1,1,qcwBlack)
                    surface.SetDrawColor( (hpp2<0.35 and CurTime()%0.5>0.25) and qcwRed or qcwGreenLight)
                    surface.DrawRect(122,-22,246*hpp2,30)
                    draw.SimpleTextOutlined(hp2.." / "..plhp,"ScoreboardDefaultTitle",128,-6,qcwBright,0,1,1,qcwBlack)
                    
                    draw.RoundedBox(16,-450,16,900,64,qcwBlack)
                    draw.SimpleText("¡Juego en marcha!","QCWName",0,16,qcwBright,1)
                    
                    if close then
                        draw.RoundedBox(8,-450,96,900,200,qcwBlack)
                        draw.SimpleText("El primer jugador se decide al azar.","ScoreboardDefault",0,108,qcwBright,1)
                        draw.SimpleText("Presiona [USE] en una tarjeta y luego presiónala nuevamente en un carril para colocar la unidad.","ScoreboardDefault",0,128,qcwBright,1)
                        draw.SimpleText("• Las unidades cuestan [MANA], indicado por un orbe morado, que se repone cada turno. Con el tiempo, obtienes más maná.","Trebuchet18",-410,148,qcwWhite)
                        draw.SimpleText("• Las unidades tienen [ATK] y [HP]. Siempre atacan a la unidad enemiga que tienen delante y tienen la posibilidad de fallar o","Trebuchet18",-410,168,qcwWhite)
                        draw.SimpleText("crítico por doble daño. Si no hay ninguna unidad al frente, atacan al jugador. Ganas una vez que llevas al jugador a 0 hp.","Trebuchet18",-410,180,qcwWhite)
                        draw.SimpleText("• Las unidades tienen una habilidad [ESPECIAL], que también cuesta maná y se puede usar una vez por turno. Por lo general, hace cosas geniales.","Trebuchet18",-410,200,qcwWhite)
                        draw.SimpleText("• Aparte de las unidades, también hay edificios y poderes. Los edificios se pueden colocar en un carril para un efecto pasivo,","Trebuchet18",-410,220,qcwWhite)
                        draw.DrawText("y son indestructibles por medios normales. Poderes... simplemente hacen cosas extrañas para obtener maná, ya sea en ti o en el enemigo.","Trebuchet18",-410,232,qcwWhite)
                        draw.DrawText("A veces son bastante útiles, ¿sabes?","Trebuchet18",-410,244,qcwWhite)
                    end
                end
            cam.End3D2D()
            
            for pid=1,2 do
                -- Table Render
                tableAngle:RotateAroundAxis(fwd,4)
                tableAngle:RotateAroundAxis(up,180*(pid-1))
                
                local pos,angle,scale = tablePos+up*6,tableAngle,tableScale
                cam.Start3D2D(pos,angle,scale)
                    for i=0,3 do
                        if qcwDrawLaneFunc[gs] then
                            qcwDrawLaneFunc[gs](self,pid,i, pos,angle,scale)
                        end
                    end
                    if qcwDrawGlobalFunc[gs] then
                        qcwDrawGlobalFunc[gs](self,pid, pos,angle,scale)
                    end
                cam.End3D2D()
                
                -- Models Render
                tableAngle:RotateAroundAxis(fwd,-4+(pid-1)*8)
                for i=0,3 do
                    -- Unit
                    local ucsent, unit, bcsent, building = self.qcwData["mdl"..pid..i], self.qcwData["unidad"..pid..i], self.qcwData["bmdl"..pid..i], self.qcwData["estructura"..pid..i]
                    if unit then
                        if ucsent then
                            local fwd, right = tableAngle:Forward(), tableAngle:Right() -- Player-relative directions
                            local add = VectorZero
                            if self:GetNWInt("cPunchLane", 0)==i and self:GetNWInt("cPunchPid", 0)==pid then
                                local cPunchTimeInt = self:GetNWInt("cPunchTime",0) 
                                if self.cPunchTimeDone ~= cPunchTimeInt then
                                    self.cPunchTime = CurTime()
                                    self.cPunchTimeDone = cPunchTimeInt
                                end
                                local atk  = math.EaseInOut(math.max(0,self.cPunchTime+1-CurTime()),1,0.2)
                                add = (-right*24*atk)+(up*4*atk)
                            end
                            
                            render.SetColorModulation(unit.cr or 1, unit.cg or 1, unit.cb or 1)
                            render.SetBlend(unit.ca or 1)
                            render.Model({
                                model = unit.mdlValid,
                                pos   = tablePos+fwd*(-48+32*i)+right*16+up*6+add+Vector(0,0,(unit.elev or 0)+(tobool(unit.float) and math.sin(CurTime()*5+unit.lid) or 0)),
                                angle = tableAngle+yaw90+Angle(0,(unit.mdlYaw or 0)+(CurTime()*(unit.spinning or 0)*360),0)
                            }, ucsent)
                        end
                    end
                    -- Building
                    if building then
                        if bcsent then
                            local fwd, right = tableAngle:Forward(), tableAngle:Right() -- Player-relative directions
                            
                            render.SetColorModulation(building.cr or 1, building.cg or 1, building.cb or 1)
                            render.SetBlend(building.ca or 1)
                            render.Model({
                                model = building.mdlValid,
                                pos   = tablePos+fwd*(-48+32*i)+right*30+up*6+Vector(0,0,(building.elev or 0)+(tobool(building.float) and math.cos(CurTime()*5+building.lid) or 0)),
                                angle = tableAngle+yaw90+Angle(0,(building.mdlYaw or 0)+(CurTime()*(building.spinning or 0)*360),0)
                            }, bcsent)
                        end
                    end
                end
            end
            render.SetColorModulation(1,1,1)
            render.SetBlend(1)
        else
            local tablePos = self:GetPos()+up*64
            cam.Start3D2D(tablePos,tableAngle+Angle(0,90,90),tableScale)
                -- Window Render
                local x,y,w,h = -250,-200,500,400
                draw.RoundedBox(4,x,y,w,48,qcwBlack)
                draw.SimpleText("QCardWars","ScoreboardDefaultTitle",x,y+8,qcwBright,0)
                draw.SimpleText("Por MerekiDor & toobeduge | Traduccion para BlackBloodRP","ScoreboardDefault",x+w-4,y+12,qcwWhite,2)
                
                draw.RoundedBox(4,x,y+50,w,64,qcwBlackLight)
                draw.SimpleText("¡Dos jugadores deben presionar [USE] para comenzar el juego!","ScoreboardDefault",x+w/2,y+72,qcwWhite,1)
                -- Players render
                local pl1, pl2 = self:GetNWEntity("pl1"), self:GetNWEntity("pl2")
                draw.RoundedBox(4,x+50,y+116,w-50,48,qcwBlackLight)
                if IsValid(pl1) then
                    draw.RoundedBox(4,x,y+116,48,48,qcwGreen)
                    draw.SimpleText("✓","ScoreboardDefaultTitle",x+24,y+116+24,qcwBright,1,1)
                    draw.SimpleText(pl1:Nick(),"DermaLarge",x+54,y+116+24,qcwBright,0,1)
                else
                    draw.RoundedBox(4,x,y+116,48,48,qcwRed)
                    draw.SimpleText("x","ScoreboardDefaultTitle",x+24,y+116+24,qcwBright,1,1)
                    draw.SimpleText("EMPTY","DermaLarge",x+54,y+116+24,qcwBright,0,1)
                end
                
                draw.RoundedBox(4,x+50,y+166,w-50,48,qcwBlackLight)
                if IsValid(pl2) then
                    draw.RoundedBox(4,x,y+166,48,48,qcwGreen)
                    draw.SimpleText("✓","ScoreboardDefaultTitle",x+24,y+166+24,qcwBright,1,1)
                    draw.SimpleText(pl2:Nick(),"DermaLarge",x+54,y+166+24,qcwBright,0,1)
                else
                    draw.RoundedBox(4,x,y+166,48,48,qcwRed)
                    draw.SimpleText("x","ScoreboardDefaultTitle",x+24,y+166+24,qcwBright,1,1)
                    draw.SimpleText("EMPTY","DermaLarge",x+54,y+166+24,qcwBright,0,1)
                end
                draw.RoundedBox(4,x,y+216,w,128,qcwBlackLight)
                draw.SimpleText("Busque el menú QCardWars en la sección Utilidades (Q) o use","GModNotify",x+4,y+220,qcwWhite)
                draw.SimpleText("el comando qcw_menu para obtener información y configurar el juego.","GModNotify",x+4,y+238,qcwWhite)
                draw.SimpleText("El administrador del servidor también puede agregar unidades personalizadas y tipos de carril","GModNotify",x+4,y+268,qcwWhite)
                draw.SimpleText("de ese menú. ¡Que te diviertas!","GModNotify",x+4,y+286,qcwWhite)
            cam.End3D2D()
        end
    end
    
-- // }}}

-- // Net {{{

    local function spawnCSEnt(unit,mdlCache,append)
        local mdl = ClientsideModel(unit.mdlValid)
        mdl:Spawn()
        mdl:SetLOD(3)
        mdl:SetModelScale( (unit.mdlScale or 1)*0.1666)
        mdl:SetSequence(tonumber(unit.mdlSeq) or (isstring(unit.mdlSeq) and #unit.mdlSeq>0 and unit.mdlSeq) or 1)
        if unit.material then
            mdl:SetMaterial(unit.material)
        end
        mdlCache[append] = mdl
        return mdl
    end
    
-- // }}}

-- // Other (Model render and client stuff mostly) {{{

    if CLIENT then
        hook.Add("Think","qcwRainbowCycle",function()
            local ct = CurTime()
            qcwRainbow  = HSVToColor( (ct*200)%360, 0.6, 1 )
            qcwBuilding = HSVToColor( 120,0.75-ct%0.5,0.5 )
            qcwPower = HSVToColor( 15+(math.sin(ct*10)+1)*15, 1, 1 )
        end)

        net.Receive("qcw_sendTableData",function()
            local ent, data, pl = net.ReadEntity(), net.ReadTable(), net.ReadEntity()
            
            ent.mdlCache  = ent.mdlCache  or {}
            ent.mdlCacheB = ent.mdlCacheB or {}
            
            for pid=1,2 do
                for lid=0,3 do
                    local append = pid..lid
                    
                    local unit   = data["unidad"..append]
                    
                    if type(ent.mdlCache)~="table" then
                        ent.mdlCache = {}
                    end
                    if type(ent.mdlCacheB)~="table" then
                        ent.mdlCacheB = {}
                    end
                    
                    local ucsent  = ent.mdlCache[append]
                    local valid  = IsValid(ucsent) and ucsent~=nil
                    if unit then
                        if unit.mdl then
                            if util.IsValidModel(unit.mdl) then
                                unit.mdlValid = unit.mdl
                            else
                                unit.mdlValid = unit.mdlAlt or unit.mdl
                            end
                            
                            if valid then
                                ucsent:Remove()
                            end
                            data["mdl"..append] = spawnCSEnt(unit,ent.mdlCache,append)
                            
                        else
                            if valid then
                                ucsent:Remove()
                                ent.mdlCache[append] = nil
                            end
                        end
                    else
                        if valid then
                            ucsent:Remove()
                            ent.mdlCache[append] = nil
                        end
                    end
                    
                    local building = data["estructura"..append]
                    local bcsent   = ent.mdlCacheB[append]
                    valid          = IsValid(bcsent) and bcsent~=nil
                    if building then
                        if building.mdl then
                            if util.IsValidModel(building.mdl) then
                                building.mdlValid = building.mdl
                            else
                                building.mdlValid = building.mdlAlt or building.mdl
                            end
                            
                            if valid then
                                bcsent:Remove()
                            end
                            data["bmdl"..append] = spawnCSEnt(building,ent.mdlCacheB,append)
                            
                        else
                            if valid then
                                bcsent:Remove()
                                ent.mdlCacheB[append] = nil
                            end
                        end
                    else
                        if valid then
                            bcsent:Remove()
                            ent.mdlCacheB[append] = nil
                        end
                    end
                end
            end
            
            if ent:IsValid() then
                ent.qcwData = data
            end
            
            if pl == LocalPlayer() then
                surface.PlaySound("garrysmod/content_downloaded.wav")
                notification.AddLegacy("[QCW] Tu turno!", 3, 4)
            end
        end)
    end

-- // }}}
