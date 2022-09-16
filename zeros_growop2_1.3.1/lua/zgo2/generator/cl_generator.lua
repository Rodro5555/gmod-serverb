zgo2 = zgo2 or {}
zgo2.Generator = zgo2.Generator or {}
zgo2.Generator.List = zgo2.Generator.List or {}

/*

	Generators provide power and refill over time

*/
function zgo2.Generator.Initialize(Generator)
	Generator:DrawShadow(false)
	Generator:DestroyShadow()

	timer.Simple(0.2, function()
		if IsValid(Generator) then
			Generator.m_Initialized = true
		end
	end)
end

function zgo2.Generator.OnRemove(Generator)
	Generator:StopSound("zgo2_generator_loop")
end

/*
	Draw ui
*/
function zgo2.Generator.OnDraw(Generator)

	if zgo2.config.Cable.AlwaysRender then
		zgo2.PowerLines.PreDraw()
	end

	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Generator:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	local dat = zgo2.Generator.GetData(Generator:GetGeneratorID())
	if not dat then return end

	cam.Start3D2D(Generator:LocalToWorld(dat.UIPos.vec), Generator:LocalToWorldAngles(dat.UIPos.ang), dat.UIPos.scale)
		zgo2.util.DrawBar(600, 60, zclib.Materials.Get("zgo2_icon_power"), zclib.colors[ "orange01" ],0, -20, (1 / 1000) * Generator:GetPower())
		zgo2.util.DrawBar(600, 40, zclib.Materials.Get("zgo2_icon_water"), zclib.colors[ "yellow01" ],0, 50, (1 / zgo2.Generator.GetFuelCapacity(Generator)) * Generator:GetFuel())

		zgo2.util.DrawButton(-150, 200, 100, 100, zclib.Materials.Get("switch"), Generator:GetTurnedOn() and zclib.colors[ "orange01" ] or zclib.colors[ "blue02" ], Generator:OnSwitch(LocalPlayer()))
		zgo2.util.DrawButton(150, 200, 100, 100, zclib.Materials.Get("plus"), zclib.colors[ "green01" ], Generator:OnConnect(LocalPlayer()))

		draw.SimpleText(zgo2.Generator.GetPowerNeed(Generator) .. " / " .. dat.PowerRate, zclib.GetFont("zclib_world_font_medium"), 0, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function zgo2.Generator.OnThink(Generator)

	zgo2.Generator.List[Generator] = true

	local ShowEffects = Generator:GetTurnedOn() and zclib.util.InDistance(Generator:GetPos(), LocalPlayer():GetPos(), 500)

	zclib.util.LoopedSound(Generator, "zgo2_generator_loop", ShowEffects)

	zclib.VibrationSystem.Run(Generator,ShowEffects,1)

	if ShowEffects then
		if not Generator.ExaustEffect then
			zclib.Effect.ParticleEffectAttach("zgo2_exaust", PATTACH_POINT_FOLLOW, Generator, 1)
			Generator.ExaustEffect = true
		end
	else
		if Generator.ExaustEffect then
			Generator:StopParticles()
			Generator.ExaustEffect = nil
		end
	end

	if zclib.util.InDistance(Generator:GetPos(), LocalPlayer():GetPos(), 1000) == false then
		Generator.ReceiveGeneratorData = nil
		return
	end

	// Ask the server about the current connected entities from this generator
	if (Generator.NextDataRequest == nil or CurTime() > Generator.NextDataRequest) and not Generator.ReceiveGeneratorData then
		net.Start("zgo2.Generator.UpdateAll")
		net.WriteEntity(Generator)
		net.SendToServer()
		Generator.NextDataRequest = CurTime() + 3
	end
end

/*
	Called from server to open the powerline connection selector for the player
*/
net.Receive("zgo2.Generator.Connect", function(len)
    zclib.Debug_Net("zgo2.Generator.Connect", len)

    local Generator = net.ReadEntity()

	if not IsValid(Generator) then return end
	if Generator:GetClass() ~= "zgo2_generator" then return end

	zgo2.Generator.ConnectSelector(Generator)
end)

/*
	Gets called when the server updates the player about a lamp getting connected / disconnected to / from the generator
*/
net.Receive("zgo2.Generator.Update", function(len)
	zclib.Debug_Net("zgo2.Generator.Update", len)

	local Generator = net.ReadEntity()
	local ent = net.ReadEntity()
	local connected = net.ReadBool()
	if not IsValid(Generator) then return end
	if not IsValid(ent) then return end

	if Generator.ConnectedEntities == nil then Generator.ConnectedEntities = {} end

	if connected then
		Generator.ConnectedEntities[ent] = true
	else
		Generator.ConnectedEntities[ent] = nil
	end
end)

/*
	Gets called when the server updates the player about every single lamp connected to this generator
*/
net.Receive("zgo2.Generator.UpdateAll", function(len)
	zclib.Debug_Net("zgo2.Generator.UpdateAll", len)

	local Generator = net.ReadEntity()
	local count = net.ReadUInt(10)

	local list = {}
	for i=1,count do list[i] = net.ReadEntity() end

	if not IsValid(Generator) then return end

	Generator.ConnectedEntities = {}

	for k,v in pairs(list) do
		Generator.ConnectedEntities[v] = true
	end

	Generator.ReceiveGeneratorData = true
end)

function zgo2.Generator.ConnectSelector(Generator)

	local ply = LocalPlayer()
	zclib.PointerSystem.Start(Generator, function()
		-- OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "yellow01" ]
		zclib.PointerSystem.Data.ActionName =  zgo2.language["Connect"] .. " / " .. zgo2.language["Disconnect"]
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()
		-- OnLeftClick
		local ent = zclib.PointerSystem.Data.HitEntity

		if zgo2.Generator.CanConnect(Generator,ent) then
			net.Start("zgo2.Generator.Connect")
			net.WriteEntity(Generator)
			net.WriteEntity(ent)
			net.SendToServer()
		end
	end, function()

		-- Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			local ent = zclib.PointerSystem.Data.HitEntity
			if zgo2.Generator.CanConnect(Generator,ent) and zclib.util.InDistance((Generator:GetPos() + ent:GetPos()) / 2,ply:GetPos(), zgo2.config.Cable.Distance) then
				zclib.PointerSystem.Data.MainColor = zclib.colors[ "yellow01" ]
				zclib.PointerSystem.Data.PreviewModel:SetModel(ent:GetModel())
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
				zclib.PointerSystem.Data.PreviewModel:SetPos(ent:GetPos())
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ent:GetAngles())
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
			else
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
				zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
				zclib.PointerSystem.Data.MainColor = zclib.colors[ "red01" ]
			end
		end
	end,nil,nil,function()

		for k,v in ipairs(ents.FindInSphere(LocalPlayer():GetPos(),zgo2.config.Cable.Distance)) do
			if not IsValid(v) then continue end
			if not zgo2.Generator.CanConnect(Generator,v) then continue end
			zgo2.HUD.Draw(v,function()
				draw.SimpleText("▼", zclib.GetFont("zclib_world_font_giant"), 0, 0, zclib.colors[ "yellow01" ], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end)
		end

		if not zgo2.config.Cable.AlwaysRender then
			zgo2.PowerLines.PreDraw()
		end
	end)
end
