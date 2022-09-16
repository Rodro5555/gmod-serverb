include("shared.lua")

--[[ Thanks to Mouloud for this part ]]
function ENT:Draw()
    self:DrawModel()
	self.vehicleInfo = self.vehicleInfo or {}

    local pos = self:GetPos()+self:GetUp()*48+self:GetForward()*12.3+self:GetRight()*-2.6
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 59.22)
	
	RCD.JobButtons:addView(pos, ang, self:EntIndex(), false, 0.007)
	RCD.JobButtons:drawView(RCD.CarDealerJob["calcPos"], RCD.CarDealerJob["calcAng"], 115, self:EntIndex())

	if isstring(self.vehicleInfo["model"]) then
		self.GhostEntity:SetModel((self.vehicleInfo["model"] or ""))

		if self.vehicle then
			self.GhostEntity:SetNoDraw(true)
		else
			self.GhostEntity:SetNoDraw(false)

			if self:RCDCanSpawn(self.GhostEntity) then
				self.GhostEntity:SetColor(RCD.Colors["purple"])
			else
				self.GhostEntity:SetColor(RCD.Colors["red"])
			end
		end

		if not RCD.VehiclesList or not RCD.VehiclesList[self.vehicleInfo["class"] or ""] then return end
		local addAng = RCD.VehiclesList[self.vehicleInfo["class"] or ""]["SpawnAngleOffset"] or 0
		local spawnOffset = RCD.VehiclesList[self.vehicleInfo["class"] or ""]["SpawnOffset"] or {}

		self.GhostEntity:SetPos(self:LocalToWorld(RCD.Constants["vectorShowcase"]) + Vector(0,0,(spawnOffset[3] or 0)))
		self.GhostEntity:SetAngles(self:LocalToWorldAngles(Angle(0, 90+addAng, 0)))
	end
end

function ENT:RCDCreateGhostEntity()
	if IsValid(self.GhostEntity) then return end

    self.GhostEntity = ents.CreateClientProp()
    if not IsValid(self.GhostEntity) then return end

    self.GhostEntity:Spawn()
    self.GhostEntity:SetParent(self)
    self.GhostEntity:SetMaterial("rcd_materials/model_stripes")
end

// check if the ent have space to spawn
function ENT:RCDCanSpawn(ent)
	if not IsValid(ent) then return end

    local maxL = ent:OBBMaxs()
    local minL = ent:OBBMins()

    local lenghtY = (maxL.y-minL.y)/10
    local lenghtZ = (maxL.z-minL.z)/2

    for j = 0, 1 do
        for i = 0, 10 do
            local botLeft = ent:OBBMins()
            botLeft.y = botLeft.y+lenghtY*i

            local topRight = ent:OBBMaxs()
            topRight.y = minL.y+lenghtY*i
            topRight.z = topRight.z-lenghtZ*j

            local topLeft = ent:OBBMins()
            topLeft.y = topLeft.y+lenghtY*i

            local botRight = ent:OBBMaxs()
            botRight.y = minL.y+lenghtY*i
            botRight.z = minL.z
            topLeft.z = maxL.z-lenghtZ*j

            botLeft = ent:LocalToWorld(botLeft)
            topRight = ent:LocalToWorld(topRight)
            topLeft = ent:LocalToWorld(topLeft)
            botRight = ent:LocalToWorld(botRight)

            local End = util.TraceLine({
                start = botLeft,
                endpos = topRight,
                filter = self,
            })

            local Start = util.TraceLine({
                start = topLeft,
                endpos = botRight,
                filter = self,
            })

            if End.Hit or Start.Hit then return false end
        end
    end
    return true
end

function ENT:OnRemove()
    if IsValid(self.GhostEntity) then
        self.GhostEntity:Remove()
    end
    RCD.JobButtons:removeView(self:EntIndex())
end


function RCD.loadMenuInformation(ent, vehicleId, class, price)
	RCD.JobButtons:removeView(ent:EntIndex())
	RCD.JobButtons:addView(RCD.Constants["vectorOrigin"], RCD.Constants["vectorOrigin"], ent:EntIndex(), false, 0.01)

    local layoutMenu = RCD.JobButtons:createButton()
	layoutMenu:SetSize(3550, 1700)
	layoutMenu:SetPos(0, 0)
	layoutMenu:SetIdView(ent:EntIndex())
	layoutMenu.Paint = function(self,w,h,x,y)
		surface.SetDrawColor(RCD.Colors["white255"])
		surface.SetMaterial(RCD.Materials["background"])
		surface.DrawTexturedRect(x, y, w, h)
		
        surface.SetDrawColor(RCD.Colors["white255"])
        surface.SetMaterial(RCD.Materials["logo"])
        surface.DrawTexturedRectRotated(x+w/2, y+h/2, 1000, 1000, math.sin(CurTime())*10)
		
		local base = string.upper(RCD.GetSentence("standTitle"))

		surface.SetFont("RCD3D:Font:01")
        local textSize = surface.GetTextSize(base)

		draw.DrawText(base, "RCD3D:Font:01", x+150, y+100, color_white, TEXT_ALIGN_LEFT)
		draw.DrawText(" - "..RCD.GetSentence("stand"), "RCD3D:Font:02", x+150+textSize, y+100, color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("pressE"), "RCD3D:Font:02", x+w/2, y+h-300, color_white, TEXT_ALIGN_CENTER)
	end

	if isstring(class) then
		local vehicleList = RCD.VehiclesList or {}
		ent.vehicleInfo = {
			["model"] = vehicleList[class]["Model"],
			["name"] = vehicleList[class]["Name"],
			["class"] = class,
			["bodyGroups"] = {},
			["underglow"] = RCD.Colors["white"],
			["color"] = RCD.Colors["white"],
			["skin"] = 0,
			["price"] = price,
			["vehicleId"] = vehicleId,
			["commission"] = 30,
		}

		ent:RCDCreateGhostEntity()
	end
end

local lerpBuy, lerpSell = 0, 0
function RCD.OpenShowcaseMenu(ent, vehicleId, class)
    local vehicleList = RCD.VehiclesList or {}
	if class && not vehicleList[class] then return end

	RCD.JobButtons:removeView(ent:EntIndex())
	RCD.JobButtons:addView(RCD.Constants["vectorOrigin"], RCD.Constants["angleOrigin"], ent:EntIndex(), false, 0.01)

	local mainModel
	local layoutMenu = RCD.JobButtons:createButton()
	layoutMenu:SetSize(3550, 1700)
	layoutMenu:SetPos(0, 0)
	layoutMenu:SetIdView(ent:EntIndex())
	layoutMenu.Paint = function(self,w,h,x,y)
		surface.SetDrawColor(RCD.Colors["white255"])
		surface.SetMaterial(RCD.Materials["background"])
		surface.DrawTexturedRect(x, y, w, h)

		local base = string.upper(RCD.GetSentence("standTitle"))

		surface.SetFont("RCD3D:Font:01")
        local textSize = surface.GetTextSize(base)

		draw.DrawText(base, "RCD3D:Font:01", x+150, y+100, color_white, TEXT_ALIGN_LEFT)
		draw.DrawText(" - "..RCD.GetSentence("stand"), "RCD3D:Font:02", x+150+textSize, y+100, color_white, TEXT_ALIGN_LEFT)

		if mainModel then
			if not mainModel.customMaterial then return end
			mainModel.Updated = false
			surface.SetDrawColor(RCD.Colors["white255"])
			surface.SetMaterial(mainModel.customMaterial)
			surface.DrawTexturedRect(x+w/5-1000, y+h/2-1000, 2000, 2000, 0)
		end

		draw.DrawText(ent.vehicleInfo["name"].." ("..RCD.formatMoney((ent.vehicleInfo["price"] or 0))..")" or "", "RCD3D:Font:03", x+w/5, y+h-250, color_white, TEXT_ALIGN_CENTER)
	end

	mainModel = RCD.JobButtons:createButton()
	mainModel:SetSize(4000, 4000)
	mainModel:SetPos(0, 0)
	mainModel:SetFOV(40)
	mainModel:CreateDModelPanel(ent.vehicleInfo["model"])
	mainModel:AddRemoveParent(layoutMenu)
	mainModel:SetIdView(ent:EntIndex())
	mainModel.PaintManual = true
	mainModel.Paint = function(self,w,h,x,y) end

	local layoutPurchase = RCD.JobButtons:createButton()
	layoutPurchase:SetSize(1900, 1200)
	layoutPurchase:SetPos(1500, 150)
	layoutPurchase:SetIdView(ent:EntIndex())
	layoutPurchase:CreateLayout(frame, 0, 25, 25, 10, -10)
	layoutPurchase.Paint = function(self,w,h,x,y) end

	local modelCars = {}
	local layoutCar
	
    local idModel = 1
	for k, v in pairs(RCD.AdvancedConfiguration["vehiclesList"]) do
		local options = v.options or {}
		if not options["canSellWithJob"] then continue end

		modelCars[k] = modelCars[k] or {}

		local modelCars1 = RCD.JobButtons:createButton()
		modelCars1:SetSize(4000, 4000)
		modelCars1:SetPos(0, 0)
		modelCars1:SetFOV(40)
		modelCars1:CreateDModelPanel(vehicleList[v.class]["Model"])
		modelCars1:AddRemoveParent(layoutMenu)
		modelCars1:SetIdView(ent:EntIndex())
		modelCars1.PaintManual = true
		modelCars1.Paint = function(self,w,h,x,y) end

		modelCars[k][1]	= modelCars1
        modelCars[k].id = idModel
		
		local modelCars2 = RCD.JobButtons:createButton()
		modelCars2:SetSize(350, 350)
		modelCars2:SetPos(1525+((modelCars[k].id-1)%5)*(350+25), 10000)
		modelCars2:SetIdView(ent:EntIndex())
		modelCars2.PaintManual = true
		modelCars2.lerp = 0
		modelCars2.Paint = function(self,w,h,x,y)
			self.lerp = Lerp(FrameTime()*5, self.lerp, (self:IsHovered() and 30 or 50))

			self.y = (layoutCar.y or 0)+125+math.floor((modelCars[k].id-1)/5)*375
			draw.RoundedBox(10, x, y, w, h, ColorAlpha(RCD.Colors["grey134"], self.lerp))
		end
		modelCars2.DoClick = function()
			ent.vehicleInfo = {
				["model"] = vehicleList[v.class]["Model"],
				["name"] = vehicleList[v.class]["Name"],
				["class"] = v.class,
				["price"] = v.price,
				["bodyGroups"] = {},
				["underglow"] = RCD.Colors["white"],
				["color"] = RCD.Colors["white"],
				["skin"] = 0,
				["vehicleId"] = k,
				["commission"] = 30,
			}
			RCD.OpenShowcaseMenu(ent, k, v.class)
		end

		modelCars[k][2]	= modelCars2
        idModel = idModel + 1
	end

	layoutCar = RCD.JobButtons:createButton()
	layoutCar:SetSize(1900, 100)
	layoutCar:SetPos(1500, 150)
	layoutCar:SetOpenSize(125+math.ceil((idModel-1)/5)*375)
	layoutCar.Paint = function(self,w,h,x,y)
		surface.SetDrawColor(RCD.Colors["grey10020"])
		surface.DrawRect(x, y, w, 100)

		draw.DrawText(RCD.GetSentence("buyVehicle"), "RCD3D:Font:05", x+30, y+12, color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10010"])
		surface.DrawRect(x, y+100, w, h-100)

		for k, v in pairs(RCD.AdvancedConfiguration["vehiclesList"]) do
			if !modelCars[k] then continue end

			if modelCars[k][1] && modelCars[k][2] then
				local btn = modelCars[k][2]
				btn:Paint(btn.w, btn.h, btn.x, btn.y)

				surface.SetDrawColor(RCD.Colors["white255"])
				surface.SetMaterial(modelCars[k][1].customMaterial)
				surface.DrawTexturedRect(btn.x+btn.w/2-300, btn.y+btn.h/2-300, 600, 600)
			end
		end
	end
	layoutCar.DoClick = function(self)
		if modelCars then
			for _,panel in pairs(modelCars) do
				if panel[2]:IsHovered() then
					if panel[2].DoClick then
						panel[2]:DoClick()
					end
					return
				end
			end
		end

		self:SetOpen(!self:GetOpen())
		ent.layoutCarOpen = self:GetOpen()
	end
	if ent.layoutCarOpen then
		layoutCar:SetOpen(true)
		layoutCar.h = layoutCar:GetOpenSize()
	end

	layoutPurchase:AddToLayout(layoutCar)

	local layoutColor1, layoutColor2
	
	local bodyChildren = {}
	local layoutBody = RCD.JobButtons:createButton()
	layoutBody:SetSize(925, 100)
	layoutBody:SetPos(1500, 150)
	layoutBody:SetOpenSize(600)
	layoutBody.line = true
	layoutBody.Paint = function(self,w,h,x,y)
		surface.SetDrawColor(RCD.Colors["grey10020"])
		surface.DrawRect(x, y, w, 100)

		draw.DrawText(RCD.GetSentence("bodygroups"), "RCD3D:Font:05", x+30, y+12, color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10010"])
		surface.DrawRect(x, y+100, w, h-100)
		for k, v in pairs(bodyChildren) do
			v[0]:Paint(v[0].w, v[0].h, v[0].x, v[0].y)

			for kk, panel in pairs(v) do
				if kk == 0 then continue end
				panel:Paint(panel.w, panel.h, panel.x, panel.y)
			end
		end
	end
	layoutBody.DoClick = function(self)
		if bodyChildren then
			for _,v in pairs(bodyChildren) do
				for _, panel in pairs(v) do
					if panel:IsHovered() then
						if panel.DoClick then
							panel:DoClick()
						end
						return
					end
				end
			end
		end
		local Open = !self:GetOpen()
		layoutBody:SetOpen(Open)
		layoutColor1:SetOpen(Open)
		layoutColor2:SetOpen(Open)
		ent.layoutColorOpen = Open
	end
	layoutPurchase:AddToLayout(layoutBody)

	local id = 1
	local sizeY = 100

	for k, v in pairs(mainModel.Model:GetBodyGroups()) do
		if #v.submodels < 1 then continue end

		bodyChildren[id] = {}
		bodyChildren[id][0] = RCD.JobButtons:createButton()
		bodyChildren[id][0]:SetSize(925, 70)
		bodyChildren[id][0]:SetPos(1500, 0)
		bodyChildren[id][0]:SetIdView(ent:EntIndex())
		bodyChildren[id][0].id = id
		bodyChildren[id][0].moveY = sizeY-100
		bodyChildren[id][0].PaintManual = true
		bodyChildren[id][0].Paint = function(self,w,h,x,y)
			self.y = layoutBody.y+110+self.moveY
			draw.DrawText(v.name, "RCD3D:Font:06", x+30, y, color_white, TEXT_ALIGN_LEFT)
		end
		
		local countY, moveY = 0, 0
		local modelCount = #v.submodels

		for i = 0, modelCount do
			bodyChildren[id][i+1] = RCD.JobButtons:createButton()
			bodyChildren[id][i+1]:SetSize(70, 70)
			bodyChildren[id][i+1]:SetPos(1525+countY*80, 0)
			bodyChildren[id][i+1]:SetIdView(ent:EntIndex())
			bodyChildren[id][i+1].Parent = bodyChildren[id][0]
			bodyChildren[id][i+1].moveY = moveY
			bodyChildren[id][i+1].PaintManual = true
			bodyChildren[id][i+1].Paint = function(self,w,h,x,y)
				self.y = self.Parent.y+60+self.moveY
				if self:IsHovered() or ent.vehicleInfo["bodyGroups"][v.id] == i then
					draw.RoundedBox(4, x, y, w, h, RCD.Colors["purple99"])
				else
					draw.RoundedBox(4, x, y, w, h, RCD.Colors["purple55"])
				end
				draw.DrawText(i, "RCD3D:Font:06", x+w/2, y+10, color_white, TEXT_ALIGN_CENTER)
			end
			bodyChildren[id][i+1].DoClick = function()
				mainModel.Model:SetBodygroup(v.id, i)
				ent.vehicleInfo["bodyGroups"][v.id] = i
			end
			
			countY = countY+1
			if countY == 11 then
				countY = 0
				moveY = moveY+80
			end
		end

		sizeY = sizeY+70+math.ceil(modelCount/11)*90
		id = id+1
	end

    mainModel.Model:SetColor(ent.vehicleInfo["color"])
    mainModel.Model:SetSkin(ent.vehicleInfo["skin"])
    for k, v in pairs(ent.vehicleInfo["bodyGroups"]) do
        mainModel.Model:SetBodygroup(k, v)
    end

	local colorChildren1 = {}

	layoutColor1 = RCD.JobButtons:createButton()
	layoutColor1:SetSize(472.5, 100)
	layoutColor1:SetPos(2450, 150)
	layoutColor1:SetOpenSize(600)
	layoutColor1.line = true
	layoutColor1.Paint = function(self, w, h, x, y)
		surface.SetDrawColor(RCD.Colors["grey10020"])
		surface.DrawRect(x, y, w, 100)
		draw.DrawText(RCD.GetSentence("colors"), "RCD3D:Font:05", x+30, y+12, color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10010"])
		surface.DrawRect(x, y+100, w, h-100)

		for _, panel in pairs(colorChildren1) do
			panel:Paint(panel.w, panel.h, panel.x, panel.y)
		end
	end

	layoutColor1.DoClick = function(self)
		if colorChildren1 then
			for _,panel in pairs(colorChildren1) do
				if panel:IsHovered() then
					if panel.DoClick then
						panel:DoClick()
					end
					return
				end
			end
		end
		local Open = !self:GetOpen()
		layoutBody:SetOpen(Open)
		layoutColor1:SetOpen(Open)
		layoutColor2:SetOpen(Open)
		ent.layoutColorOpen = Open
	end

	colorChildren1[0] = RCD.JobButtons:createButton()
	colorChildren1[0]:SetSize(393, 393)
	colorChildren1[0]:SetPos(2450+472.5/2-393/2, 10000)
	colorChildren1[0]:SetIdView(ent:EntIndex())
	colorChildren1[0].PaintManual = true
	colorChildren1[0].posMouse = {colorChildren1[0]:GetWide()/2, colorChildren1[0]:GetTall()/2}
	colorChildren1[0].Paint = function(self, w, h, x, y)
		self.y = layoutColor1.y+150
		surface.SetDrawColor(RCD.Colors["white255"])
		surface.SetMaterial(RCD.Materials["color_circle"])
		surface.DrawTexturedRect(x, y, w, h)

		local cx, cy = RCD.JobButtons:getXCursor(0.007)-x, RCD.JobButtons:getYCursor(0.007)-y

		surface.SetDrawColor(Color(0, 0, 0))
		draw.NoTexture()
		RCD.DrawSimpleCircle(x+self.posMouse[1], y+self.posMouse[2], 20, 30)

		surface.SetDrawColor(ent.vehicleInfo["color"] or self.m_color or color_white)
		draw.NoTexture()
		RCD.DrawSimpleCircle(x+self.posMouse[1], y+self.posMouse[2], 15, 30)

		if self.DragStart then
			if !input.IsMouseDown(MOUSE_LEFT) then
				self.DragStart = false
			end
			local ang = math.atan2( cy-h / 2, cx-w / 2 )
			local dist = math.Distance(w/2, h/2, cx, cy)
			if dist <= w/2 then
				dist = dist / w
				ang = ang+math.pi
				ang = -ang

				self.m_color = HSVToColor( math.deg( ang ) > 0 and math.deg( ang ) or math.abs( math.deg( ang )-180 ), dist*2, 1)
				self.posMouse = {cx, cy}
				mainModel.Model:SetColor(self.m_color)

				ent.vehicleInfo["color"] = self.m_color
			end
		else
			local n, s, r = ColorToHSV(ent.vehicleInfo["color"])
			local rad = math.rad(n)
			self.posMouse = {w/2+math.cos(rad)*(s*w/2), h/2+math.sin(rad)*(s*w/2)}
		end
	end
	colorChildren1[0].DoClick = function(self)
		self.DragStart = true
	end

	for k, v in pairs(RCD.ColorPaletteColors) do
		colorChildren1[k] = RCD.JobButtons:createButton()
		colorChildren1[k]:SetSize(50, 50)
		colorChildren1[k]:SetPos(2460+((k-1)%9)*50, 10000)
		colorChildren1[k]:SetIdView(ent:EntIndex())
		colorChildren1[k].id = k
		colorChildren1[k].PaintManual = true
		colorChildren1[k].Paint = function(self, w, h, x, y)
			self.y = layoutColor1.y+600+math.floor((self.id-1)/9)*50
			surface.SetDrawColor(v)
			draw.NoTexture()
			RCD.DrawSimpleCircle(x+w/2, y+h/2, 20, 30)
		end
		colorChildren1[k].DoClick = function()
			mainModel.Model:SetColor(v)

			ent.vehicleInfo["color"] = v
		end
	end
	layoutPurchase:AddToLayout(layoutColor1)

	local colorChildren2 = {}

	layoutColor2 = RCD.JobButtons:createButton()
	layoutColor2:SetSize(472.5, 100)
	layoutColor2:SetPos(2925+12.5, 150)
	layoutColor2:SetOpenSize(600)
	layoutColor2.Paint = function(self,w,h,x,y)

		surface.SetDrawColor(RCD.Colors["grey10020"])
		surface.DrawRect(x, y, w, 100)
		draw.DrawText(RCD.GetSentence("underglow"), "RCD3D:Font:05", x+30, y+12, self.m_color or color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10010"])
		surface.DrawRect(x, y+100, w, h-100)

		for _, panel in pairs(colorChildren2) do
			panel:Paint(panel.w, panel.h, panel.x, panel.y)
		end
	end

	layoutColor2.DoClick = function(self)
		if colorChildren2 then
			for _,panel in pairs(colorChildren2) do
				if panel:IsHovered() then
					if panel.DoClick then
						panel:DoClick()
					end
					return
				end
			end
		end
		local Open = !self:GetOpen()
		
		layoutBody:SetOpen(Open)
		layoutColor1:SetOpen(Open)
		layoutColor2:SetOpen(Open)
		ent.layoutColorOpen = Open
	end

	colorChildren2[0] = RCD.JobButtons:createButton()
	colorChildren2[0]:SetSize(393, 393)
	colorChildren2[0]:SetPos(3173-393/2, 10000)
	colorChildren2[0]:SetIdView(ent:EntIndex())
	colorChildren2[0].PaintManual = true
	colorChildren2[0].posMouse = {colorChildren2[0]:GetWide()/2, colorChildren2[0]:GetTall()/2}
	colorChildren2[0].Paint = function(self,w,h,x,y)
		self.y = layoutColor2.y+150
		surface.SetDrawColor(RCD.Colors["white255"])
		surface.SetMaterial(RCD.Materials["color_circle"])
		surface.DrawTexturedRect(x, y, w, h)

		local cx, cy = RCD.JobButtons:getXCursor(0.007)-x, RCD.JobButtons:getYCursor(0.007)-y

		surface.SetDrawColor(RCD.Colors["black"])
		draw.NoTexture()
		RCD.DrawSimpleCircle(x+self.posMouse[1], y+self.posMouse[2], 20, 30)

		surface.SetDrawColor(ent.vehicleInfo["underglow"] or self.m_color or color_white)
		draw.NoTexture()
		RCD.DrawSimpleCircle(x+self.posMouse[1], y+self.posMouse[2], 15, 30)

		if self.DragStart then
			if not input.IsMouseDown(MOUSE_LEFT) then
				self.DragStart = false
			end
			local ang = math.atan2(cy-h/2, cx-w/2)
			local dist = math.Distance(w/2, h/2, cx, cy)
			if dist <= w/2 then
				dist = dist/w
				ang = ang+math.pi
				ang = -ang

				self.m_color = HSVToColor(math.deg(ang) > 0 and math.deg(ang) or math.abs(math.deg(ang)-180), dist*2, 1)
				self.posMouse = {cx, cy}

				ent.vehicleInfo["underglow"] = self.m_color
			end
		else
			local n, s, r = ColorToHSV(ent.vehicleInfo["underglow"])
			local rad = math.rad(n)
			self.posMouse = {w/2+math.cos(rad)*(s*w/2), h/2+math.sin(rad)*(s*w/2)}
		end
	end
	colorChildren2[0].DoClick = function(self)
		self.DragStart = true
	end

	for k, v in pairs(RCD.ColorPaletteColors) do
		colorChildren2[k] = RCD.JobButtons:createButton()
		colorChildren2[k]:SetSize(50, 50)
		colorChildren2[k]:SetPos(2945+((k-1)%9)*50, 10000)
		colorChildren2[k]:SetIdView(ent:EntIndex())
		colorChildren2[k].id = k
		colorChildren2[k].PaintManual = true
		colorChildren2[k].Paint = function(self,w,h,x,y)
			self.y = layoutColor2.y+600+math.floor((self.id-1)/9)*50
			surface.SetDrawColor(v)
			draw.NoTexture()
			RCD.DrawSimpleCircle(x+w/2, y+h/2, 20, 30)
		end
		colorChildren2[k].DoClick = function()
			mainModel.Model:SetColor(v)
			ent.vehicleInfo["underglow"] = v
		end
	end
	layoutPurchase:AddToLayout(layoutColor2)

	sizeY = math.max(sizeY, 915)
	layoutBody:SetOpenSize(sizeY)
	layoutColor1:SetOpenSize(sizeY)
	layoutColor2:SetOpenSize(sizeY)

	if ent.layoutColorOpen then
		layoutBody:SetOpen(true)
		layoutColor1:SetOpen(true)
		layoutColor2:SetOpen(true)

		layoutBody.h = layoutBody:GetOpenSize()
		layoutColor1.h = layoutColor1:GetOpenSize()
		layoutColor2.h = layoutColor2:GetOpenSize()
	end

	local skinChildren = {}
	local layoutSkin = RCD.JobButtons:createButton()
	layoutSkin:SetSize(1900, 100)
	layoutSkin:SetPos(1500, 150)
	layoutSkin:SetOpenSize(200)
	layoutSkin.Paint = function(self,w,h,x,y)
		surface.SetDrawColor(RCD.Colors["grey10020"])
		surface.DrawRect(x, y, w, 100)

		draw.DrawText(RCD.GetSentence("skins"), "RCD3D:Font:05", x+30, y+12, color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10010"])
		surface.DrawRect(x, y+100, w, h-100)
		
		for _, panel in pairs(skinChildren) do
			panel:Paint(panel.w, panel.h, panel.x, panel.y)
		end
	end
	layoutSkin.DoClick = function(self)
		if skinChildren then
			for _,panel in pairs(skinChildren) do
				if panel:IsHovered() then
					if panel.DoClick then
						panel:DoClick()
					end
					return
				end
			end
		end
		self:SetOpen(!self:GetOpen())
		ent.layoutSkinOpen = self:GetOpen()
	end
	layoutPurchase:AddToLayout(layoutSkin)

	if ent.layoutSkinOpen then
		layoutSkin:SetOpen(true)
		layoutSkin.h = layoutSkin:GetOpenSize()
	end

	for i = 0, mainModel.Model:SkinCount()-1 do
		skinChildren[i] = RCD.JobButtons:createButton()
		skinChildren[i]:SetSize(70, 70)
		skinChildren[i]:SetPos(1525+i*80, 0)
		skinChildren[i]:SetIdView(ent:EntIndex())
		skinChildren[i].PaintManual = true
		skinChildren[i].Paint = function(self,w,h,x,y)
			self.y = layoutSkin.y+115
			if self:IsHovered() or ent.vehicleInfo["skin"] == i then
				draw.RoundedBox(4, x, y, w, h, RCD.Colors["purple99"])
			else
				draw.RoundedBox(4, x, y, w, h, RCD.Colors["purple55"])
			end
			draw.DrawText(i, "RCD3D:Font:06", x+w/2, y+10, color_white, TEXT_ALIGN_CENTER)
		end
		skinChildren[i].DoClick = function()
			mainModel.Model:SetSkin(i)
			ent.vehicleInfo["skin"] = i
		end
	end

	local sliderB
	local layoutPrice = RCD.JobButtons:createButton()
	layoutPrice:SetSize(1900, 100)
	layoutPrice:SetPos(1500, 150)
	layoutPrice:SetOpenSize(200)
	layoutPrice.Paint = function(self,w,h,x,y)
		surface.SetDrawColor(RCD.Colors["grey10020"])
		surface.DrawRect(x, y, w, 100)
		draw.DrawText(RCD.GetSentence("yourCommission"), "RCD3D:Font:05", x+30, y+12, color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10010"])
		surface.DrawRect(x, y+100, w, h-100)

		draw.RoundedBox(10, x+50, y+150, (sliderB.x-1475)-50, 10, RCD.Colors["purple55"])
		draw.RoundedBox(10, x+(sliderB.x-1475), y+150, w-(sliderB.x-1475)-50, 10, RCD.Colors["grey"])
		sliderB:Paint(sliderB.w, sliderB.h, sliderB.x, sliderB.y)
	end
	layoutPrice.DoClick = function(self)
		if sliderB && sliderB:IsHovered() then
			sliderB:DoClick()
		else
			self:SetOpen(!self:GetOpen())
			ent.layoutPriceOpen = self:GetOpen()
		end
	end

	if ent.layoutPriceOpen then
		layoutPrice:SetOpen(true)
		layoutPrice.h = layoutPrice:GetOpenSize()
	end

	local vehicleTable = RCD.AdvancedConfiguration["vehiclesList"][ent.vehicleInfo["vehicleId"]] or {}
	vehicleTable["options"] = vehicleTable["options"] or {}

	local min, max = (vehicleTable["options"]["minCommissionPrice"] or 0), (vehicleTable["options"]["maxCommissionPrice"] or 1000)
	local commission = ent.vehicleInfo["commission"]

	sliderB = RCD.JobButtons:createButton()
	sliderB:SetSize(50, 50)
	sliderB:SetPos(1600, 0)
	sliderB:SetIdView(ent:EntIndex())
	sliderB.PaintManual = true
	sliderB.Paint = function(self,w,h,x,y)
		self.y = layoutPrice.y+130

		surface.SetDrawColor(RCD.Colors["white255"])
		draw.NoTexture()
		RCD.DrawSimpleCircle(x+w/2, y+h/2, 20, 30)

		local ratio = (self.x-1550)/(3325-1550)

		if self.StartGrag then
			if !input.IsMouseDown(MOUSE_LEFT) then
				self.StartGrag = false
				return
			end
			self.x = math.Clamp(RCD.JobButtons:getXCursor(0.007), 1550, 3325)
			commission = math.Round(ratio, 2)*max
		else
			self.x = ((commission-min)/(max-min))*(3325-1550)+1550
		end
		draw.DrawText(RCD.formatMoney(commission), "RCD3D:Font:05", 3350, y-115, RCD.Colors["white200255"], TEXT_ALIGN_RIGHT)
	end
	sliderB.DoClick = function(self)
		self.StartGrag = true
	end

	layoutPurchase:AddToLayout(layoutPrice)

	local vehicleBought = ent.vehicle

	local buyBtn = RCD.JobButtons:createButton()
	buyBtn:SetSize((vehicleBought and 945 or 1900), 150)
	buyBtn:SetPos(1500, 1450)
	buyBtn:SetIdView(ent:EntIndex())
	buyBtn.Paint = function(self,w,h,x,y)
		lerpBuy = Lerp(FrameTime()*5, lerpBuy, (self:IsHovered() and 150 or 255))

		draw.RoundedBox(10, x, y, w, h, ColorAlpha(RCD.Colors["purple55"], lerpBuy))
		draw.DrawText(vehicleBought and RCD.GetSentence("saveRentInformation") or RCD.GetSentence("rentVehicle"):format(RCD.formatMoney((vehicleTable["options"]["rentPrice"] or 0))), "RCD3D:Font:04", x+160, y+23, color_white, TEXT_ALIGN_LEFT)

		surface.SetDrawColor(RCD.Colors["grey10050"])
		draw.NoTexture()
		RCD.DrawSimpleCircle(x+h/2, y+h/2, h/3, 30)

		surface.SetDrawColor(RCD.Colors["white250250"])
		surface.SetMaterial(RCD.Materials["icon_money"])
		surface.DrawTexturedRect(x+h/2-h/8, y+h/2-h/8, h/4, h/4)
	end
	buyBtn.DoClick = function()
		if (not ent.GhostEntity:GetNoDraw() && not ent:RCDCanSpawn(ent.GhostEntity)) then RCD.Notification(5, RCD.GetSentence("rentVehicleSpace")) return end

		local vehicleColor = Color((ent.vehicleInfo["color"].r or 255), (ent.vehicleInfo["color"].g or 255), (ent.vehicleInfo["color"].b or 255))
		local neonColor = Color((ent.vehicleInfo["underglow"].r or 255), (ent.vehicleInfo["underglow"].g or 255), (ent.vehicleInfo["underglow"].b or 255))
		local bodyGroups = ent.vehicleInfo["bodyGroups"]

		ent.vehicleInfo["commission"] = commission

		net.Start("RCD:Main:Job")
			net.WriteUInt(2, 4)
			net.WriteEntity(ent)
			net.WriteUInt(ent.vehicleInfo["vehicleId"], 32)
			net.WriteUInt(ent.vehicleInfo["commission"], 32)
			net.WriteUInt((ent.vehicleInfo["skin"] or 0), 8)
			net.WriteColor(vehicleColor)
			net.WriteColor(neonColor)
			net.WriteUInt(table.Count(bodyGroups), 8)
			for k,v in pairs(bodyGroups) do
				net.WriteUInt(k, 8)
				net.WriteUInt(v, 8)
			end
		net.SendToServer()
	end

	if vehicleBought then
		local sellBtn = RCD.JobButtons:createButton()
		sellBtn:SetSize((vehicleBought and 945 or 1900), 150)
		sellBtn:SetPos(2470, 1450)
		sellBtn:SetIdView(ent:EntIndex())
		sellBtn.Paint = function(self,w,h,x,y)
			lerpSell = Lerp(FrameTime()*5, lerpSell, (self:IsHovered() and 150 or 255))

			draw.RoundedBox(10, x, y, w, h, ColorAlpha(RCD.Colors["purple55"], lerpSell))
			draw.DrawText(RCD.GetSentence("bringBack"), "RCD3D:Font:04", x+160, y+23, color_white, TEXT_ALIGN_LEFT)

			surface.SetDrawColor(RCD.Colors["grey10050"])
			draw.NoTexture()
			RCD.DrawSimpleCircle(x+h/2, y+h/2, h/3, 30)

			surface.SetDrawColor(RCD.Colors["white250250"])
			surface.SetMaterial(RCD.Materials["icon_leave"])
			surface.DrawTexturedRect(x+h/2-h/8, y+h/2-h/8, h/4, h/4)
		end
		sellBtn.DoClick = function()
			net.Start("RCD:Main:Job")
				net.WriteUInt(3, 4)
				net.WriteEntity(ent)
			net.SendToServer()
		end
	end
end

hook.Add("DrawPhysgunBeam", "RCD:Debug:3D2D", function(_, _, _, ent)
    if IsValid(ent) && ent:GetClass() == "rcd_showcase" then
        return false
    end
end)

function ENT:Initialize()
	RCD.loadMenuInformation(self)
end