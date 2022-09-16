zpiz = zpiz or {}

zclib.NetEvent.AddDefinition("zpiz_customer_sit", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "d1_t03_sit_bed", 1)
end, true)

zclib.NetEvent.AddDefinition("zpiz_customer_sit_random", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "uiint"
	}
}, function(received)
	local ent = received[1]
	local customerDataID = received[2]
	if customerDataID == nil then return end
	if not IsValid(ent) then return end
	local customerData = zpiz.config.Customers[customerDataID]
	local sitAnim = customerData.SitAnim[math.random(#customerData.SitAnim)]
	zclib.Animation.Play(ent, sitAnim, 1)
end, true)

zclib.NetEvent.AddDefinition("zpiz_customer_serv_random", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "uiint"
	}
}, function(received)
	local ent = received[1]
	local customerDataID = received[2]
	if customerDataID == nil then return end
	if not IsValid(ent) then return end
	local customerData = zpiz.config.Customers[customerDataID]
	local ServAnim = customerData.ServAnim[math.random(#customerData.ServAnim)]
	zclib.Animation.Play(ent, ServAnim, 1)
end, true)

zclib.NetEvent.AddDefinition("zpiz_oven_open", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "open", 1)
end, true)

zclib.NetEvent.AddDefinition("zpiz_oven_close", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "close", 1)
end, true)

zclib.NetEvent.AddDefinition("zpiz_pizza_bake", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Effect.ParticleEffect("zpizmak_oven_main", ent:GetPos(), ent:GetAngles(), ent)
end, true)
