zgo2 = zgo2 or {}
zgo2.util = zgo2.util or {}

// The render distance for ui
zgo2.util.RenderDistance_UI = 300

// A quick list for all the classes
zgo2.util.ClassList = {}
zgo2.util.ClassList["zgo2_clipper"] = true
zgo2.util.ClassList["zgo2_crate"] = true
zgo2.util.ClassList["zgo2_dryline"] = true
zgo2.util.ClassList["zgo2_generator"] = true
zgo2.util.ClassList["zgo2_lamp"] = true
zgo2.util.ClassList["zgo2_pot"] = true
zgo2.util.ClassList["zgo2_pump"] = true
zgo2.util.ClassList["zgo2_rack"] = true
zgo2.util.ClassList["zgo2_seed"] = true
zgo2.util.ClassList["zgo2_tent"] = true
zgo2.util.ClassList["zgo2_watertank"] = true
zgo2.util.ClassList["zgo2_battery"] = true
zgo2.util.ClassList["zgo2_bulb"] = true
zgo2.util.ClassList["zgo2_fuel"] = true
zgo2.util.ClassList["zgo2_jar"] = true
zgo2.util.ClassList["zgo2_logbook"] = true
zgo2.util.ClassList["zgo2_motor"] = true
zgo2.util.ClassList["zgo2_soil"] = true
zgo2.util.ClassList["zgo2_packer"] = true
zgo2.util.ClassList["zgo2_weedblock"] = true
zgo2.util.ClassList["zgo2_jarcrate"] = true
zgo2.util.ClassList["zgo2_doobytable"] = true
zgo2.util.ClassList["zgo2_splicer"] = true
zgo2.util.ClassList["zgo2_baggy"] = true

function zgo2.Print(msg)
	print("[Zero´s GrowOP 2] " .. msg)
end

function zgo2.util.ColorToHSV(col, h_mul, s_mul, v_mul)
	local h, s, v = ColorToHSV(col)

	return HSVToColor(h * h_mul, s * s_mul, v * v_mul)
end

/*
	Pushes a drawn texture inside a render target and returns that
*/
function zgo2.util.PushTexture(r,g,b,a,MatID,OnPush)

	//local rt_target = GetRenderTargetEx(MatID, zgo2.config.RenderTargetSize, zgo2.config.RenderTargetSize,RT_SIZE_NO_CHANGE,MATERIAL_RT_DEPTH_SHARED,bit.bor(2, 256,512,8192,32768,67108864),0,IMAGE_FORMAT_BGRA8888)
	local rt_target = GetRenderTargetEx(MatID, zgo2.config.RenderTargetSize, zgo2.config.RenderTargetSize,RT_SIZE_NO_CHANGE,MATERIAL_RT_DEPTH_ONLY,bit.bor(2,512,8192,67108864),0,IMAGE_FORMAT_BGRA8888)

	local mat = Matrix()
	render.SuppressEngineLighting(true)

	render.PushRenderTarget(rt_target)

		render.ClearDepth()
		render.Clear(r, g, b, a, true, true)

		render.OverrideAlphaWriteEnable(true, true)

			render.UpdateRefractTexture()

			cam.Start2D()
				cam.PushModelMatrix(mat)

					// I like to believe this actully does make the final texture look smoother and ye i know this is not antialiasing
					render.PushFilterMag( TEXFILTER.ANISOTROPIC )
					render.PushFilterMin( TEXFILTER.ANISOTROPIC )

					pcall(OnPush)

					render.PopFilterMag()
					render.PopFilterMin()

				cam.PopModelMatrix()
			cam.End2D()

			render.UpdateRefractTexture()

		render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()

	render.SuppressEngineLighting(false)

	return rt_target
end

/*
	Creates a UI Bar with the specified icon, color and progress
*/
function zgo2.util.DrawBar(w,h,icon, color,x, y, progress)

	draw.RoundedBox(15 * zclib.hM,x + -w/2, y, w, h, zclib.colors[ "black_a200" ])
	draw.RoundedBox(15 * zclib.hM,x + -w/2, y, math.Clamp(w * progress,0,w), h, color)

	surface.SetDrawColor(zclib.colors[ "white_a100" ])
	surface.SetMaterial(icon)
	surface.DrawTexturedRectRotated(x + -(w / 2) + (h / 2), y + (h / 2), h, h, 0)
end

function zgo2.util.DrawButton(x, y, w, h, icon, color, hover)
	draw.RoundedBox(h / 2, x - w / 2, y - h / 2, w, h, color)

	surface.SetDrawColor(zclib.colors[ "white_a100" ])
	surface.SetMaterial(icon)
	surface.DrawTexturedRectRotated(x, y, w, h, 0)

	if hover then
		draw.RoundedBox(h / 2, x - w / 2, y - h / 2, w, h, zclib.colors[ "white_a100" ])
	end
end

/*
	Converts the sequential job id to the job command before saving
*/
function zgo2.util.ConvertJobIDToCommand(data)

	local function ConvertItem(dat)
		if not dat.jobs then return end
		local before = table.Copy(dat.jobs)
		dat.jobs = {}

		for k,v in pairs(before) do
			local jobid = tonumber(k)

			// Does this job exist?
			if jobid and isnumber(jobid) and RPExtraTeams[jobid] then

				// Convert it
				dat.jobs[ RPExtraTeams[ jobid ].command ] = true
			end
		end
		return dat
	end

	// Is the data a single item or a list of items?
	if data.jobs then

		// Convert single item
		data = ConvertItem(data)
	else
		// Convert list
		for itm_id,itm_data in pairs(data) do
			itm_data = ConvertItem(itm_data)
		end
	end

	return data
end

/*
	Converts the job command to its job id after loading
*/
function zgo2.util.ConvertJobCommandToJobID(data)

	local function ConvertItem(dat)
		if not dat.jobs then return end
		local before = table.Copy(dat.jobs)

		dat.jobs = {}

		for k,v in pairs(before) do
			if not k then continue end

			if isnumber(k) then
				dat.jobs[k] = true
				continue
			end

			// Does this job exist?
			if not k or not isstring(k) then continue end

			// Returns the job data and id from the provided job command
			local _,jobID = DarkRP.getJobByCommand(k)

			if not jobID then
				continue
			end

			// Convert it
			dat.jobs[jobID] = true
		end
		return dat
	end

	// Is the data a single item or a list of items?
	if data.jobs then

		// Convert single item
		data = ConvertItem(data)
	else
		// Convert list
		for itm_id,itm_data in pairs(data) do
			itm_data = ConvertItem(itm_data)
		end
	end

	return data
end

/*
	Asks for confirmation on the first call
	Executes the action on the second call
	Resets after 2 seconds
*/
local HasCalled = false
local LastCall = 0
function zgo2.util.ConfirmAction(ply,action)
	if HasCalled and CurTime() > (LastCall + 2) then
		HasCalled = false
	end

	if not HasCalled then
		LastCall = CurTime()
		HasCalled = true
		zclib.Notify(ply, "Click again to confirm this action.", 0)
	else
		HasCalled = false
		pcall(action)
	end
end

/*
	Small utility function to create a lua emitter particle explosion
*/
local gravity = Vector(0, 0, -300)
function zgo2.util.ParticleExplosion(pos,scale,count,force,GetParticlePath)
	local LeafEmitter = ParticleEmitter( pos , true )
	if not LeafEmitter or not LeafEmitter:IsValid() then return end

	for i = 1,count do
		local particle = LeafEmitter:Add(GetParticlePath(), pos)
		particle:SetVelocity(VectorRand(-80,80) * force)
		particle:SetVelocityScale( true )

		particle:SetAngles(Angle(-90,math.Rand(0, 360),0))
		particle:SetAngleVelocity(Angle(0,math.Rand(0, 360),0))

		particle:SetDieTime(math.Rand(2, 9))

		local size = scale * math.Rand(1, 3)
		particle:SetStartSize(size)
		particle:SetEndSize(size)

		particle:SetCollide(true)
		particle:SetBounce(0.1)

		particle:SetGravity(gravity)
		particle:SetAirResistance(1)
	end

	LeafEmitter:Finish()
end
