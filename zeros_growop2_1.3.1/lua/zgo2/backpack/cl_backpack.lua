zgo2 = zgo2 or {}
zgo2.Backpack = zgo2.Backpack or {}

/*

	The backpack swep can be used to transport weed

*/

if not zgo2.config.Backpack.DrawModel then return end

zclib.CacheModel("models/zerochain/props_growop2/zgo2_backpack.mdl")

zclib.Hook.Remove("PostPlayerDraw", "zgo2_Backpack_draw")
zclib.Hook.Add("PostPlayerDraw", "zgo2_Backpack_draw", function(ply,flags) zgo2.Backpack.Draw(ply) end)

local function GetBonePos(ent, id)
	local pos, ang = ent:GetBonePosition(id)
	if pos == ent:GetPos() then
		local mat = ent:GetBoneMatrix(id)
		if mat then
			pos = mat:GetTranslation()
			ang = mat:GetAngles()
		end
	end

	pos = pos + ang:Up() * 2

	return pos, ang
end

function zgo2.Backpack.Draw(ply)

	if not zclib.util.InDistance(ply:GetPos(), LocalPlayer():GetPos(), 1000) then
		if IsValid(ply.zgo2_backpack) then ply.zgo2_backpack:Remove() end
		return
	end

	if not ply:HasWeapon("zgo2_backpack") then
		if IsValid(ply.zgo2_backpack) then ply.zgo2_backpack:Remove() end
		return
	end

	if IsValid(ply.zgo2_backpack) then

		local pos,ang , scale

		//print(ply:GetModel())

		local boneid = ply:LookupBone("ValveBiped.Bip01_Spine4")
		if boneid then
			local p, a = GetBonePos(ply, boneid)
			if p and a then
				pos = p
				ang = a
				ang:RotateAroundAxis(ang:Right(),-90)
				ang:RotateAroundAxis(ang:Up(),-90)

				local dat = zgo2.Backpack.Offsets[ply:GetModel()]
				if not dat then dat = zgo2.Backpack.Offsets["default"] end

				if isvector(dat) then
					pos = pos + ang:Up() * dat.y
					pos = pos + ang:Right() * dat.x
					pos = pos + ang:Forward() * dat.z
				else
					scale = dat[3]

					pos = pos + ang:Up() * dat[1].y
					pos = pos + ang:Right() * dat[1].x
					pos = pos + ang:Forward() * dat[1].z

					local baseAng = Angle(ang.p,ang.y,ang.r)

					ang:RotateAroundAxis(baseAng:Right(),dat[2].p)
					ang:RotateAroundAxis(baseAng:Up(),dat[2].y)
					ang:RotateAroundAxis(baseAng:Forward(),dat[2].r)
				end
			else
				pos = ply:GetPos()
				ang = ply:GetAngles()
			end
		else
			pos = ply:GetPos()
			ang = ply:GetAngles()
		end

		ply.zgo2_backpack:SetModelScale(0.8 * (scale or 1))
		ply.zgo2_backpack:SetPos(pos)
		ply.zgo2_backpack:SetAngles(ang)
		ply.zgo2_backpack:DrawModel()
	else
		local ent = ClientsideModel("models/zerochain/props_growop2/zgo2_backpack.mdl")
		if not IsValid(ent) then return end
		ent:Spawn()
		ent:SetNoDraw(true)
		ent:SetPredictable(false)
		ent:DrawShadow(false)
		ent:DestroyShadow()
		ent:SetMoveType(MOVETYPE_NONE)

		ply.zgo2_backpack = ent
	end
end


gameevent.Listen("player_disconnect")
zclib.Hook.Add("player_disconnect", "zgo2_Backpack_draw", function(data)

	local ply = player.GetBySteamID(data.networkid)
	if IsValid(ply) and IsValid(ply.zgo2_backpack) then
		ply.zgo2_backpack:Remove()
	end
end)
