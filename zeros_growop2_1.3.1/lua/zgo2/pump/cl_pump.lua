zgo2 = zgo2 or {}
zgo2.Pump = zgo2.Pump or {}
zgo2.Pump.List = zgo2.Pump.List or {}

/*

	Pumps move water from watertanks to pots

*/
function zgo2.Pump.Initialize(Pump)
	Pump:DrawShadow(false)
	Pump:DestroyShadow()

	timer.Simple(0.2, function()
		if IsValid(Pump) then
			Pump.m_Initialized = true
		end
	end)
end

/*
	Draw ui and light stuff
*/
local ui_ang = Angle(0, 0, 90)
local ui_ang01 = Angle(180, 270, -90)
local ui_ang02 = Angle(0, 180, 90)
local power_vec , power_ang = Vector(12.4, -3.8, 19.8) , Angle(0, 90, 90)
local ui_vec = Vector(0,  13.8, 10)
function zgo2.Pump.OnDraw(Pump)

	if zgo2.config.Cable.AlwaysRender then
		zgo2.Waterlines.PreDraw()
	end

	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Pump:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	cam.Start3D2D(Pump:LocalToWorld(Pump.SwitchPos), Pump:LocalToWorldAngles(ui_ang01), 0.05)
		zgo2.util.DrawButton(0, 0, 100, 100, zclib.Materials.Get("switch"),Pump:GetTurnedOn() and zclib.colors[ "orange01" ] or zclib.colors[ "blue02" ], Pump:OnSwitch(LocalPlayer()))
	cam.End3D2D()

	cam.Start3D2D(Pump:LocalToWorld(Pump.InputPos), Pump:LocalToWorldAngles(ui_ang), 0.05)
		zgo2.util.DrawButton(0, 0, 100, 100, zclib.Materials.Get("plus"), zclib.colors[ "green01" ], Pump:OnConnect_Input(LocalPlayer()))
	cam.End3D2D()

	cam.Start3D2D(Pump:LocalToWorld(Pump.OutputPos), Pump:LocalToWorldAngles(ui_ang02), 0.05)
		zgo2.util.DrawButton(0, 0, 100, 100, zclib.Materials.Get("plus"), zclib.colors[ "green01" ], Pump:OnConnect_Output(LocalPlayer()))
	cam.End3D2D()

	cam.Start3D2D(Pump:LocalToWorld(ui_vec), Pump:LocalToWorldAngles(ui_ang02), 0.05)
		draw.RoundedBox(10, -200,-50, 400,100, zclib.colors[ "black_a150" ])

		surface.SetDrawColor(zclib.colors[ "white_a100" ])
		surface.SetMaterial(zclib.Materials.Get("zgo2_icon_water"))
		surface.DrawTexturedRectRotated(-150,0, 100, 100, 0)

		draw.SimpleText(Pump:GetWaterTransferRate() .. " / s", zclib.GetFont("zclib_world_font_giant"), 50, 0, zclib.colors[ "blue02" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	// Draw some power indicator
	if Pump:GetPower() > 0 then
		cam.Start3D2D(Pump:LocalToWorld(power_vec), Pump:LocalToWorldAngles(power_ang), 0.05)
			zgo2.util.DrawBar(100,30,zclib.Materials.Get("zgo2_icon_power"), zclib.colors[ "orange01" ],0, 0, (1 / zgo2.config.Battery.Power) * Pump:GetPower())
		cam.End3D2D()
	end
end

function zgo2.Pump.OnThink(Pump)

	zclib.util.LoopedSound(Pump, "zgo2_pump_loop",Pump:GetTurnedOn() and Pump:GetPower() > 0)

	zgo2.Pump.List[Pump] = true

	if zclib.util.InDistance(Pump:GetPos(), LocalPlayer():GetPos(), 1000) == false then
		Pump.ReceiveGeneratorData = nil
		return
	end

	// Ask the server about the current connected entities from this Pump
	if (Pump.NextDataRequest == nil or CurTime() > Pump.NextDataRequest) and not Pump.ReceivePumpData then
		net.Start("zgo2.Pump.UpdateAll")
		net.WriteEntity(Pump)
		net.SendToServer()
		Pump.NextDataRequest = CurTime() + 3
	end
end

/*
	Called from server to open the powerline connection selector for the player
*/
net.Receive("zgo2.Pump.Connect.Input", function(len)
    zclib.Debug_Net("zgo2.Pump.Connect.Input", len)

    local Pump = net.ReadEntity()

	if not IsValid(Pump) then return end
	if Pump:GetClass() ~= "zgo2_pump" then return end

	zgo2.Pump.ConnectSelector(Pump,true)
end)

net.Receive("zgo2.Pump.Connect.Output", function(len)
    zclib.Debug_Net("zgo2.Pump.Connect.Output", len)

    local Pump = net.ReadEntity()

	if not IsValid(Pump) then return end
	if Pump:GetClass() ~= "zgo2_pump" then return end

	zgo2.Pump.ConnectSelector(Pump,false)
end)

/*
	Gets called when the server updates the player about a lamp getting connected / disconnected to / from the Pump
*/
net.Receive("zgo2.Pump.Update", function(len)
	zclib.Debug_Net("zgo2.Pump.Update", len)

	local Pump = net.ReadEntity()
	local ent = net.ReadEntity()
	local connected = net.ReadBool()
	local IsInput = net.ReadBool()

	if not IsValid(Pump) then return end
	if not IsValid(ent) then return end

	if IsInput then

		if connected then

			Pump.InputEntity = ent
		else

			Pump.InputEntity = nil
		end
	else
		if Pump.OutputEntities == nil then Pump.OutputEntities = {} end

		if connected then
			Pump.OutputEntities[ent] = true
		else
			Pump.OutputEntities[ent] = nil
		end
	end
end)

/*
	Gets called when the server updates the player about every single lamp connected to this Pump
*/
net.Receive("zgo2.Pump.UpdateAll", function(len)
	zclib.Debug_Net("zgo2.Pump.UpdateAll", len)

	local Pump = net.ReadEntity()
	local count = net.ReadUInt(10)

	local list = {}
	for i = 1,count do list[i] = net.ReadEntity() end
	local InputTank = net.ReadEntity()

	if not IsValid(Pump) then return end

	Pump.InputEntity = InputTank

	Pump.OutputEntities = {}
	for k,v in pairs(list) do
		Pump.OutputEntities[v] = true
	end

	Pump.ReceivePumpData = true
end)

local function CanConnect(ply,Pump,ent,IsInput)
	if not zclib.util.InDistance((Pump:GetPos() + ent:GetPos()) / 2,ply:GetPos(), zgo2.config.Cable.Distance) then return false end
	if IsInput then
		return zgo2.Pump.IsInput(Pump,ent)
	else
		return zgo2.Pump.IsOutput(Pump,ent)
	end
end

function zgo2.Pump.ConnectSelector(Pump,IsInput)

	local ply = LocalPlayer()

	zclib.PointerSystem.Start(Pump, function()
		-- OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "blue02" ]
		zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Connect" ] .. " / " .. zgo2.language[ "Disconnect" ]
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
		zclib.PointerSystem.Data.RopeStart = IsInput and Pump:LocalToWorld(Pump.InputPos) or Pump:LocalToWorld(Pump.OutputPos)
	end, function()

		-- OnLeftClick
		local ent = zclib.PointerSystem.Data.HitEntity
		if CanConnect(ply,Pump,ent,IsInput) then
			net.Start(IsInput and "zgo2.Pump.Connect.Input" or "zgo2.Pump.Connect.Output")
			net.WriteEntity(Pump)
			net.WriteEntity(ent)
			net.SendToServer()
		end

	end, function()

		-- Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			local ent = zclib.PointerSystem.Data.HitEntity
			if CanConnect(ply,Pump,ent,IsInput) then
				zclib.PointerSystem.Data.MainColor = zclib.colors[ "blue02" ]
				zclib.PointerSystem.Data.PreviewModel:SetModel(ent:GetModel())
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
				zclib.PointerSystem.Data.PreviewModel:SetPos(ent:GetPos())
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ent:GetAngles())
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
				zclib.PointerSystem.Data.PreviewModel:SetModelScale(ent:GetModelScale(),0)
			else
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
				zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
				zclib.PointerSystem.Data.MainColor = zclib.colors[ "red01" ]
			end
		end
	end,nil,nil,function()

		if not zgo2.config.Cable.AlwaysRender then
			zgo2.Waterlines.PreDraw()
		end

		for k,v in ipairs(ents.FindInSphere(LocalPlayer():GetPos(),zgo2.config.Cable.Distance)) do
			if not IsValid(v) then continue end
			if not CanConnect(ply,Pump,v,IsInput) then continue end
			zgo2.HUD.Draw(v,function()
				draw.SimpleText("▼", zclib.GetFont("zclib_world_font_giant"), 0, 0, zclib.colors[ "blue02" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end)
		end
	end)
end
