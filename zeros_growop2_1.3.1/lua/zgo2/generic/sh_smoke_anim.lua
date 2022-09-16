zgo2 = zgo2 or {}
zgo2.SmokeAnim = zgo2.SmokeAnim or {}

/*

	Handels the smoking animation of the player world model

*/

if SERVER then
	util.AddNetworkString("zgo2.SmokeAnim.Start")
	function zgo2.SmokeAnim.Start(ply)
		net.Start("zgo2.SmokeAnim.Start")
		net.WriteEntity(ply)
		net.Broadcast()
	end

	util.AddNetworkString("zgo2.SmokeAnim.Stop")
	function zgo2.SmokeAnim.Stop(ply)
		net.Start("zgo2.SmokeAnim.Stop")
		net.WriteEntity(ply)
		net.Broadcast()
	end

	// Creates the bong exhale effect
	util.AddNetworkString("zgo2.SmokeAnim.Effect")
	function zgo2.SmokeAnim.Effect(ply,SmokeCount)
		if not IsValid(ply) then return end
		net.Start("zgo2.SmokeAnim.Effect")
		net.WriteEntity(ply)
		net.WriteUInt(SmokeCount,10)
		net.SendPVS(ply:GetPos())
	end
else
	net.Receive("zgo2.SmokeAnim.Start", function(len)
		local ply = net.ReadEntity()

		if IsValid(ply) then
			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_TAUNT_LAUGH, false)
		end
	end)

	net.Receive("zgo2.SmokeAnim.Stop", function(len)
		local ply = net.ReadEntity()

		if IsValid(ply) then
			ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		end
	end)

	local gravity = Vector(0, 0, -5)
	net.Receive("zgo2.SmokeAnim.Effect", function(len)
		local Smoker = net.ReadEntity()
		local SmokeCount = net.ReadUInt(10)
		if not SmokeCount then return end
		if not IsValid(Smoker) then return end
		if not Smoker:IsPlayer() then return end
		if not Smoker:Alive() then return end

		local Bong = Smoker:GetActiveWeapon()
		if not IsValid(Bong) then return end
		if not Bong.GetWeedID then return end

		local WeedID = Bong:GetWeedID()

		zclib.Sound.EmitFromEntity("zgo2_bong_exhale_short", Smoker)

		local attach = Smoker:GetAttachment(Smoker:LookupAttachment("mouth"))
		if not attach then return end

		local pos = attach.Pos

		if not Smoker.zgo2_SmokeEmitter or not Smoker.zgo2_SmokeEmitter:IsValid() then Smoker.zgo2_SmokeEmitter = ParticleEmitter( pos , false ) end

		local UseCount = 10
		if Bong:GetClass() == "zgo2_bong" then
			local BongData = zgo2.Bong.GetData(Bong:GetBongID())
			UseCount = math.Round(BongData.capacity / zgo2.config.Bong.Use)
		end

		local effect_length = (3 / UseCount) * SmokeCount
		if effect_length >= 3 then
			zclib.Sound.EmitFromEntity("zgo2_bong_exhale_long", Smoker)
		elseif effect_length >= 1.5 then
			zclib.Sound.EmitFromEntity("zgo2_bong_exhale_mid", Smoker)
		else
			zclib.Sound.EmitFromEntity("zgo2_bong_exhale_short", Smoker)
		end

		local function ValidEmitter() return IsValid(Smoker) and Smoker.zgo2_SmokeEmitter and Smoker.zgo2_SmokeEmitter:IsValid() end

		local col = zgo2.Plant.GetColor(WeedID)
		local function SpawnParticle()

			attach = Smoker:GetAttachment(Smoker:LookupAttachment("mouth"))
			if not attach then return end

			pos = attach.Pos

			local particle = Smoker.zgo2_SmokeEmitter:Add("zerochain/zgo2/particle/skankcloud", pos)
			particle:SetVelocity(attach.Ang:Forward() * 200)
			particle:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
			particle:SetDieTime(math.random(2, 9))
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(1, 3))
			particle:SetEndSize(math.random(80, 100))
			particle:SetColor(col.r, col.g, col.b)
			particle:SetGravity(gravity)
			particle:SetAirResistance(55)
		end

		local count = math.Round(effect_length / 0.05)

		local delay = 0.05
		for i = 1,count do
			timer.Simple(delay, function() if ValidEmitter() then SpawnParticle() end end)
			delay = delay + 0.05
		end

		timer.Simple(effect_length,function()
			if ValidEmitter() then
				Smoker.zgo2_SmokeEmitter:Finish()
				Smoker.zgo2_SmokeEmitter = NULL
			end
		end)
	end)
end
