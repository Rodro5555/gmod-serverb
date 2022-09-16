zgo2 = zgo2 or {}
zgo2.Crate = zgo2.Crate or {}
zgo2.Crate.List = zgo2.Crate.List or {}

/*

	Players can use crates to easly move multiple weedbranches

*/

/*
	Called from server to inform the client that the weedbranch count changed
*/
net.Receive("zgo2.Crate.Update", function(len)
	zclib.Debug_Net("zgo2.Crate.Update", len)
	local Crate = net.ReadEntity()

	if Crate and IsValid(Crate) and Crate:IsValid() then
		zgo2.Crate.RemoveBranchModels(Crate)

		Crate.WeedBranches = {}
		for i = 1, net.ReadUInt(20) do
			Crate.WeedBranches[ net.ReadUInt(20) ] = {
				id = net.ReadUInt(20),
				amount = net.ReadUInt(20),
				dried = net.ReadBool()
			}
		end
	end
end)

function zgo2.Crate.Initialize(Crate)
	Crate:DrawShadow(false)
	Crate:DestroyShadow()
	timer.Simple(1, function()
		if IsValid(Crate) then
			Crate.m_Initialized = true
		end
	end)
end

function zgo2.Crate.OnRemove(Crate)
	zgo2.Crate.RemoveBranchModels(Crate)
end

/*
	Adds the Crate to the list
*/
function zgo2.Crate.OnThink(Crate)
	if zgo2.Crate.List[Crate] == nil then
		zgo2.Crate.List[Crate] = true
	end
end

function zgo2.Crate.PreDraw()
	for Crate,_ in pairs(zgo2.Crate.List) do

        if not IsValid(Crate) then
			continue
		end

		if not Crate.m_Initialized then continue end

		if zclib.util.InDistance(Crate:GetPos(), LocalPlayer():GetPos(), 500) == false then
			zgo2.Crate.RemoveBranchModels(Crate)
			continue
		end

		zgo2.Crate.Draw(Crate)
    end
end
zclib.Hook.Remove("PreDrawOpaqueRenderables", "zgo2_Crate_draw")
zclib.Hook.Add("PreDrawOpaqueRenderables", "zgo2_Crate_draw", function() zgo2.Crate.PreDraw() end)

function zgo2.Crate.RemoveBranchModels(Crate)
	if Crate.WeedBranches then
		for k,v in pairs(Crate.WeedBranches) do
			if v and v.ent then
				v.ent:Remove()
			end
		end
	end
end

/*
	Quick function to cut of the leafs from the sides of the crate
*/
local function ClipPlane(Crate,normal,position,func)
	local position01 = normal:Dot( Crate:LocalToWorld(position) )
	local oldEC = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, position01 )
	pcall(func)
	render.PopCustomClipPlane()
	render.EnableClipping( oldEC )
end

/*
	Draw the weedbranches
*/
local vec01 = Vector(-14,0,0)
local vec02 = Vector(14,0,0)
function zgo2.Crate.Draw(Crate)

	// Position the weedbranches on the rope
	if not Crate.WeedBranches then return end

	ClipPlane(Crate,Crate:GetUp(),vector_origin,function()

		ClipPlane(Crate,Crate:GetForward(),vec01,function()

			ClipPlane(Crate,-Crate:GetForward(),vec02,function()


				for spot, data in pairs(Crate.WeedBranches) do
					if not IsValid(data.ent) then
						local ent = ClientsideModel("models/zerochain/props_growop2/zgo2_weedstick.mdl")
						if not IsValid(ent) then continue end
						ent:Spawn()
						ent:SetNoDraw(true)
						// Creates / Updates the plants lua materials
						zgo2.Plant.UpdateMaterial(ent,zgo2.Plant.GetData(data.id))

						data.ent = ent

						if data.dried then
							// Disable normal leafs
							data.ent:SetBodygroup(4,1)

							// Enable shrunk leafs
							data.ent:SetBodygroup(6,1)
							data.ent:SetBodygroup(7,1)
							data.ent:SetBodygroup(8,1)

							// Disable hair
							data.ent:SetBodygroup(3,1)
						end
					else
						if data.ent.RndRotation == nil then data.ent.RndRotation = math.random(360) end
						if data.ent.SwenkRnd == nil then data.ent.SwenkRnd = math.random(-10,10) end

						//local wAng = Angle(math.sin(CurTime() + data.ent.RndRotation) * 2,data.ent.RndRotation + CurTime(),180 + (2 * math.sin(CurTime() + data.ent.RndRotation)))

						data.ent:SetPos(Crate:LocalToWorld(zgo2.Crate.Spots[spot]))
						data.ent:SetAngles(Crate:LocalToWorldAngles(Angle(data.ent.RndRotation,data.ent.SwenkRnd,90)))

						data.ent:DrawModel()
					end
				end

			end)
		end)
	end)
end
