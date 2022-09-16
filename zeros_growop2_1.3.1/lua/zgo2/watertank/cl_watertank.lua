zgo2 = zgo2 or {}
zgo2.Watertank = zgo2.Watertank or {}
zgo2.Watertank.List = zgo2.Watertank.List or {}

/*

	Watertanks provide water and refill over time

*/
function zgo2.Watertank.Initialize(Watertank)
	Watertank:DrawShadow(false)
	Watertank:DestroyShadow()

	timer.Simple(0.2, function()
		if IsValid(Watertank) then
			Watertank.m_Initialized = true
		end
	end)
end

/*
	Draw ui
*/
function zgo2.Watertank.OnDraw(Watertank)
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Watertank:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	local UIPos = zgo2.Watertank.GetUIPos(Watertank)
	cam.Start3D2D(Watertank:LocalToWorld(UIPos.vec), Watertank:LocalToWorldAngles(UIPos.ang), UIPos.scale)
		zgo2.util.DrawBar(800, 160, zclib.Materials.Get("zgo2_icon_water"), zclib.colors[ "blue02" ],0, 0, (1 / zgo2.Watertank.GetCapacity(Watertank)) * Watertank:GetWater())
		draw.SimpleText(Watertank:GetWater(), zclib.GetFont("zclib_world_font_giant"), 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function zgo2.Watertank.OnThink(Watertank)
	zgo2.Watertank.List[Watertank] = true
end

net.Receive("zgo2.Watertank.Use", function(len)
    zclib.Debug_Net("zgo2.Watertank.Use", len)

    local watertank = net.ReadEntity()

	if not IsValid(watertank) then return end
	if string.sub(watertank:GetClass(),1,14) ~= "zgo2_watertank" then return end

	zgo2.Watertank.Use(watertank)
end)


local function GetShootTime(from,to)
    local traveltime = from:Distance(to)
    traveltime = traveltime / 500
    return traveltime
end

local BlueAlpha = Color(86, 114, 194,50)
local vec01 = Vector(0,0,25)
function zgo2.Watertank.Use(watertank)

	local ply = LocalPlayer()
	zclib.PointerSystem.Start(watertank, function()
		-- OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "blue02" ]
		zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Water" ]
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()
		-- OnLeftClick
		local pot = zclib.PointerSystem.Data.HitEntity

		if zgo2.Watertank.GetUseWater(watertank) <= 0 then return end

		local toPos = IsValid(pot) and pot:GetPos() or zclib.PointerSystem.Data.Pos
		local traveltime = GetShootTime(watertank:GetPos(),toPos)

		if not zclib.util.InDistance(toPos,ply:GetPos(), 400)  then return end

		zclib.Sound.EmitFromPosition(watertank:GetPos(),"zgo2_water")

		zclib.ItemShooter.Add(watertank:GetPos() + vec01,toPos + vec01,traveltime,function(ent)
			ent:SetColor(zclib.colors["blue02"])
			ent:SetModel("models/hunter/misc/sphere025x025.mdl")
			ent:SetModelScale(1)
			ent:SetMaterial("models/props_combine/stasisshield_sheet")

		end,"zgo2_water","zgo2_water","zgo2_water_tail",function(ent,pos)

			zclib.Effect.ParticleEffect("zgo2_water_explosion", pos, angle_zero, LocalPlayer())

			if not IsValid(watertank) then return end
			if not IsValid(pot) then pot = watertank end

			net.Start("zgo2.Watertank.Use")
			net.WriteEntity(watertank)
			net.WriteEntity(pot)
			net.SendToServer()
		end)

	end, function()

		-- Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			local ent = zclib.PointerSystem.Data.HitEntity

			if IsValid(ent) and ent:GetClass() == "zgo2_pot" and zclib.util.InDistance((watertank:GetPos() + ent:GetPos()) / 2,ply:GetPos(), 400) then
				zclib.PointerSystem.Data.MainColor = zclib.colors[ "blue02" ]
				zclib.PointerSystem.Data.PreviewModel:SetModel(ent:GetModel())
				zclib.PointerSystem.Data.PreviewModel:SetColor(BlueAlpha)
				zclib.PointerSystem.Data.PreviewModel:SetPos(ent:GetPos())
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ent:GetAngles())
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
				zclib.PointerSystem.Data.PreviewModel:SetModelScale(ent:GetModelScale() or 1)
			else
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
				zclib.PointerSystem.Data.MainColor = zclib.colors[ "red01" ]
			end

		end
	end)
end
