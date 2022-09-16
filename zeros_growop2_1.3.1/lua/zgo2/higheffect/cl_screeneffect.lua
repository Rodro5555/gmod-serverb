zgo2 = zgo2 or {}
zgo2.ScreenEffect = zgo2.ScreenEffect or {}

/*

	ScreenEffects are show when players get stoned

*/

net.Receive("zgo2.ScreenEffect.Start", function(len)
    zclib.Debug_Net("zgo2.ScreenEffect.Start", len)

    local UniqueID = net.ReadUInt(32)
	local WeedTHC = net.ReadUInt(20)
	local Duration = net.ReadFloat()

	if LocalPlayer().zgo2_screeneffect_id ~= UniqueID then
		zgo2.ScreenEffect.Stop(true)
		LocalPlayer().zgo2_screeneffect_duration = 0
	end

	local PlantData = zgo2.Plant.GetData(UniqueID)
	if not PlantData then return end

	LocalPlayer().zgo2_screeneffect_id = UniqueID
	LocalPlayer().zgo2_screeneffect_duration = Duration
	LocalPlayer().zgo2_screeneffect_thc = WeedTHC

	zgo2.ScreenEffect.Start(PlantData)
end)

local function BuildMaterialID(PlantData,IsRefract,IsEditor)
	if not IsRefract then
		return IsEditor and "zgo2_screeneffect_editor" or "zgo2_screeneffect_" .. PlantData.uniqueid
	else
		return IsEditor and "zgo2_screeneffect_refract_editor" or "zgo2_screeneffect_refract_" .. PlantData.uniqueid
	end
end

/*
	Rebuilds / Updates all materials which are used for this ScreenEffect
*/
function zgo2.ScreenEffect.RebuildMaterial(PlantData,IsEditor)
	zgo2.ScreenEffect.GetMaterial(PlantData,BuildMaterialID(PlantData,false,IsEditor))
	zgo2.ScreenEffect.GetMaterial(PlantData,BuildMaterialID(PlantData,true,IsEditor),true)
end

// NOTE Its confusing but the vectors needs to be a string and in format "[ 0 0 0 ]" since thats how vmt likes to read it
local function ConvertToVMTVector(vec) return "[ " .. vec.x .. vec.y .. vec.z .. " ]" end

/*
	Builds / Updates the ScreenEffect material
*/
zgo2.ScreenEffect.CachedMaterials = {}
function zgo2.ScreenEffect.GetMaterial(PlantData,MatID,IsRefract)
	local m_material

	// Create / Cache the material
	if zgo2.ScreenEffect.CachedMaterials[MatID] == nil then

		local Shader = "UnlitGeneric"
		local params = {

			[ "$ignorez" ] = 1,

			[ "$basealpha" ] = 1,

			[ "$angle" ] = 0,
			[ "$translate" ] = ConvertToVMTVector(Vector(0,0,0)),
			[ "$center" ] = ConvertToVMTVector(Vector(0.5,0.5,0)),

			[ "$basescale" ] = ConvertToVMTVector(Vector(0.75,0.75,0)),
			[ "$finalscale" ] = ConvertToVMTVector(Vector(0.75,0.75,0)),

			[ "$spin_speed" ] = 0,
			[ "$spin_snap" ] = 0,

			[ "$blink_interval" ] = 1,
			[ "$blink_min" ] = 0,
			[ "$blink_max" ] = 0,

			[ "$bounce_interval" ] = 0,
			[ "$bounce_min" ] = 0,
			[ "$bounce_max" ] = 0,


			["Proxies"] = {

				["zgo2_spin"] = {
					[ "speed" ] = "$spin_speed",
					[ "snap" ] = "$spin_snap",
					[ "resultVar" ] = "$angle",
				},

				["zgo2_bounce"] = {
					[ "interval" ] = "$bounce_interval",
					[ "min" ] = "$bounce_min",
					[ "max" ] = "$bounce_max",
					[ "resultVar" ] = "$finalscale",
				}
			}
		}

		if IsRefract then
			Shader = "Refract"

			params[ "$bluramount" ] = 0

			params[ "$baserefractamount" ] = 0.01
			params[ "$refractamount" ] = 0.01

			params[ "$refracttint" ] = ConvertToVMTVector(Vector(1,1,1))

			params[ "Proxies" ][ "TextureTransform" ] = {
				[ "translateVar" ] = "$translate",
				[ "scaleVar" ] = "$finalscale",
				[ "rotateVar" ] = "$angle",
				[ "centerVar" ] = "$center",
				[ "resultVar" ] = "$bumptransform",
			}

			params[ "Proxies" ][ "zgo2_blink" ] = {
				[ "initial" ] = "$baserefractamount",
				[ "interval" ] = "$blink_interval",
				[ "min" ] = "$blink_min",
				[ "max" ] = "$blink_max",
				[ "resultVar" ] = "$refractamount",
			}
		else
			params[ "Proxies" ][ "TextureTransform" ] = {
				[ "translateVar" ] = "$translate",
				[ "scaleVar" ] = "$finalscale",
				[ "rotateVar" ] = "$angle",
				[ "centerVar" ] = "$center",
				[ "resultVar" ] = "$basetexturetransform",
			}

			params[ "Proxies" ][ "zgo2_blink" ] = {
				[ "initial" ] = "$basealpha",
				[ "interval" ] = "$blink_interval",
				[ "min" ] = "$blink_min",
				[ "max" ] = "$blink_max",
				[ "resultVar" ] = "$alpha",
			}
		end

		zgo2.ScreenEffect.CachedMaterials[ MatID ] = CreateMaterial(MatID, Shader, params)
	end
	m_material = zgo2.ScreenEffect.CachedMaterials[MatID]

	local key = "basetexture"
	if IsRefract then key = "refract" end

	local BaseTextureMat
	if PlantData.screeneffect[ key .. "_url" ] then
		zclib.Imgur.GetMaterial(tostring(PlantData.screeneffect[ key .. "_url" ]), function(result)
			if result then
				BaseTextureMat = result
			end
		end)
	end
	if not BaseTextureMat then return end

	local base_target = zgo2.util.PushTexture(255,255,255,255,MatID,function()
		surface.SetDrawColor(PlantData.screeneffect[ key .. "_color" ] or color_white)
		surface.SetMaterial(BaseTextureMat)
		surface.DrawTexturedRect(0,0,ScrW(), ScrH())
	end)
	m_material:SetTexture(IsRefract and "$normalmap" or "$basetexture", base_target)

	m_material:SetFloat("$basealpha",PlantData.screeneffect[ key .. "_alpha"] or 1)

	local scale = PlantData.screeneffect[ key .. "_scale" ]
	m_material:SetVector("$basescale",Vector(scale,scale,0))
	m_material:SetVector("$finalscale",Vector(scale,scale,0))

	m_material:SetFloat("$blink_interval", PlantData.screeneffect[ key .. "_blink_interval" ] or 0)
	m_material:SetFloat("$blink_min", PlantData.screeneffect[ key .. "_blink_min" ] or 0.1)
	m_material:SetFloat("$blink_max", PlantData.screeneffect[ key .. "_blink_max" ] or 0.2)

	m_material:SetFloat("$spin_speed", PlantData.screeneffect[ key .. "_spin_speed" ] or 0)
	m_material:SetFloat("$spin_snap", PlantData.screeneffect[ key .. "_spin_snap" ] or 0)

	m_material:SetFloat("$bounce_interval", PlantData.screeneffect[ key .. "_bounce_interval" ] or 0)
	m_material:SetFloat("$bounce_min", PlantData.screeneffect[ key .. "_bounce_min" ] or 1)
	m_material:SetFloat("$bounce_max", PlantData.screeneffect[ key .. "_bounce_max" ] or 1)

	if IsRefract then
		m_material:SetFloat("$bluramount", PlantData.screeneffect[ key .. "_blur" ] or 1)
		m_material:SetFloat("$refractamount", PlantData.screeneffect[ key .. "_ref" ] or 1)
		m_material:SetFloat("$baserefractamount", PlantData.screeneffect[ key .. "_ref" ] or 1)

		local tint = PlantData.screeneffect[ key .. "_tint" ] or color_white
		m_material:SetVector("$refracttint",zclib.util.ColorToVector(tint))
	end

	// Refresh the material
	m_material:Recompute()

	return m_material
end

/*
	Starts the screeneffect
*/
function zgo2.ScreenEffect.Start(PlantData,IsEditor)

	zgo2.ScreenEffect.Stop()

	zgo2.ScreenEffect.RebuildMaterial(PlantData,IsEditor)

	zgo2.ScreenEffect.PlayMusic(PlantData)

	local mat_diff = BuildMaterialID(PlantData,false,IsEditor)
	local mat_refract = BuildMaterialID(PlantData,true,IsEditor)

	local ply = LocalPlayer()
	hook.Add( "RenderScreenspaceEffects", "zgo2_screeneffect_editor", function()

		if not ply:Alive() then
			zgo2.ScreenEffect.Stop(true)
			return
		end

		local intensity = 1
		if not IsEditor then
			// Scales the effect according to duration
			intensity = math.Clamp((1 / (zgo2.config.HighEffect.MaxDuration * 0.3)) * ply.zgo2_screeneffect_duration, 0, 1)

			// Scales the intensity according to THC
			intensity = (intensity / 100) * (LocalPlayer().zgo2_screeneffect_thc or 50)

			ply.zgo2_screeneffect_intensity = intensity
		end

		DrawBloom(PlantData.screeneffect.bloom_darken, PlantData.screeneffect.bloom_multiply * intensity, PlantData.screeneffect.bloom_sizex, PlantData.screeneffect.bloom_sizey, PlantData.screeneffect.bloom_passes, PlantData.screeneffect.bloom_colormul, (1 / 255) * PlantData.screeneffect.bloom_color.r, (1 / 255) * PlantData.screeneffect.bloom_color.g, (1 / 255) * PlantData.screeneffect.bloom_color.b)

		DrawMaterialOverlay("!" .. mat_diff, 0)

		DrawMaterialOverlay("!" .. mat_refract, PlantData.screeneffect.refract_ref or 0)

		DrawMotionBlur(PlantData.screeneffect.mblur_addalpha, PlantData.screeneffect.mblur_drawalpha * intensity, PlantData.screeneffect.mblur_delay)

		ply:SetDSP(PlantData.screeneffect.audio_dsp,true)

		if not IsEditor then

			ply.zgo2_screeneffect_duration = math.Clamp((ply.zgo2_screeneffect_duration or 0) - (1 * FrameTime()),0,zgo2.config.HighEffect.MaxDuration)

			if ply.zgo2_screeneffect_duration <= 0 then
				zgo2.ScreenEffect.Stop(true)
			end
		end
	end)
end

/*
	Stops the screeneffect
*/
function zgo2.ScreenEffect.Stop(Reset)
	local ply = LocalPlayer()
	if Reset then
		ply.zgo2_screeneffect_duration = nil
		ply.zgo2_screeneffect_id = nil
		zgo2.ScreenEffect.StopMusic()
	end
	ply:SetDSP(0,true)
	hook.Remove( "RenderScreenspaceEffects", "zgo2_screeneffect_editor")
end

/*
	Stops the background music for this screeneffect
*/
function zgo2.ScreenEffect.StopMusic()
	local ply = LocalPlayer()
	if ply.zgo2_ScreenEffect_AudioSource and ply.zgo2_ScreenEffect_AudioSource:IsPlaying() == true then
		ply.zgo2_ScreenEffect_AudioSource:Stop()
		ply.zgo2_ScreenEffect_AudioSource = nil
	end
end

/*
	Plays the background music for this screeneffect
*/
function zgo2.ScreenEffect.PlayMusic(PlantData)
	local ply = LocalPlayer()

	if ply.zgo2_ScreenEffect_AudioSource == nil then
		ply.zgo2_ScreenEffect_AudioSource = CreateSound(ply, "zgo2_weedmusic_" .. PlantData.uniqueid)
	end

	if ply.zgo2_ScreenEffect_AudioSource:IsPlaying() == false then
		ply.zgo2_ScreenEffect_AudioSource:Play()
		ply.zgo2_ScreenEffect_AudioSource:ChangeVolume(0, 0)
		ply.zgo2_ScreenEffect_AudioSource:ChangeVolume(1, 2)
	end
end

/*
	Sets up the music used in this screen effect
*/
function zgo2.ScreenEffect.SetMusic(PlantData,path)

	// We dont need the sound folder in the path
	if string.sub(path,1,6) == "sound/" then path = string.Replace(path,"sound/","") end

	PlantData.screeneffect.audio_music = path

	sound.Add({
		name = "zgo2_weedmusic_" .. PlantData.uniqueid,
		channel = CHAN_STATIC,
		volume = 1,
		level = 80,
		pitch = { 100, 100 },
		sound = PlantData.screeneffect.audio_music
	})
end


/*
	Returns a bouncing valule with a nice ease
*/
local function Bounce(Interval)
	local time = CurTime() / Interval
	local sin = math.sin(time)
	sin = math.abs(sin)
	sin = math.ease.InSine(sin)
	return sin
end


/*

	Makes the value blink

*/
matproxy.Add({
    name = "zgo2_blink",
    init = function(self, mat, values)
		self.initial = values.initial
		self.interval = values.interval
		self.min = values.min
		self.max = values.max
		self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)

		local interval = mat:GetFloat(self.interval)
		local min = mat:GetFloat(self.min)
		local max = mat:GetFloat(self.max)

		local alpha = Lerp(0.5,min,max)
		if interval > 0 then
			alpha = Lerp(Bounce(interval),min,max)
		end
		alpha = alpha * mat:GetFloat(self.initial)

		if LocalPlayer().zgo2_screeneffect_duration and LocalPlayer().zgo2_screeneffect_duration > 0 then
			alpha = alpha * (LocalPlayer().zgo2_screeneffect_intensity or 1)
		end

		mat:SetFloat(self.ResultTo,alpha)
    end
})

/*

	Makes the value bounce, similiar to blink

*/
matproxy.Add({
    name = "zgo2_bounce",
    init = function(self, mat, values)
		self.interval = values.interval
		self.min = values.min
		self.max = values.max
		self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)

		local interval = mat:GetFloat(self.interval)
		local min = mat:GetFloat(self.min)
		local max = mat:GetFloat(self.max)

		local basescale = mat:GetVector("$basescale")
		local scale = basescale

		if interval > 0 then scale:Mul(Lerp(Bounce(interval),min,max)) end

		mat:SetVector(self.ResultTo,scale)
    end
})

/*

	Makes the value spin and snap to certain degrees

*/
matproxy.Add({
    name = "zgo2_spin",
    init = function(self, mat, values)
		self.speed = values.speed
		self.snap = values.snap
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
		local speed = mat:GetFloat(self.speed)
		local snap = mat:GetFloat(self.snap)

		local angle = CurTime() * speed
		if snap > 0 then angle = zclib.util.SnapValue(snap,angle) end

		mat:SetFloat(self.ResultTo,angle)
    end
})
