if SERVER then return end
zpiz = zpiz or {}
zpiz.Pizza = zpiz.Pizza or {}

net.Receive("zpiz_pizza_update_ingredients",function(len,ply)
	local ent = net.ReadEntity()

	local count = net.ReadUInt(16)
	local list = {}
	for i = 1,count do
		local id = net.ReadUInt(8)
		if id == nil then continue end
		table.insert(list,id)
	end

	zpiz.Pizza.UpdateIngredients(ent,list)
end)

function zpiz.Pizza.UpdateIngredients(ent,list)
	if not IsValid(ent) then return end
	ent.cl_NeededIngredients = list
end


net.Receive("zpiz_pizza_add_ingredients", function(len, ply)
	local ent = net.ReadEntity()
	local ing = net.ReadUInt(16)

	zpiz.Pizza.AddIngredient(ent,ing)
end)

function zpiz.Pizza.AddIngredient(ent,id)
	if not IsValid(ent) then return end
	if ing ~= nil then return end
	if ent.cl_AddedIngredients == nil then ent.cl_AddedIngredients = {} end

	table.insert(ent.cl_AddedIngredients, id)
end



function zpiz.Pizza.Initialize(Pizza)
	Pizza.cl_NeededIngredients = {}
	Pizza.cl_AddedIngredients = {}
end

function zpiz.Pizza.Draw(Pizza)
	if zclib.util.InDistance(LocalPlayer():GetPos(), Pizza:GetPos(), 300) then
		local cState = Pizza:GetPizzaState()
		if cState == 1 then
			zpiz.Pizza.DrawIngredients(Pizza)
		elseif cState <= 2 then
			zpiz.Pizza.DrawRawToppings(Pizza)
		elseif cState >= 3 then
			zpiz.Pizza.DrawMainInfo(Pizza)
			if not IsValid(Pizza:GetParent()) then
				zpiz.Pizza.DrawName(Pizza)
			end
		end
	end
end

local vec_up = Vector(0,0,15)

// A Clean way do display the ingredients
local size = 60

local function DrawIngredientItem(icon, y)
	surface.SetDrawColor(zpiz.colors["black02"])
	surface.SetMaterial(zpiz.materials["zpiz_circle"])
	surface.DrawTexturedRect(size * -0.5, 0 + y, size * 1.5, size * 1.5)

	surface.SetDrawColor(color_white)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(size * -0.25, size * 0.25 + y, size, size)
end

function zpiz.Pizza.DrawIngredients(Pizza)
	if table.Count(Pizza.cl_NeededIngredients) <= 0 then return end
	cam.Start3D2D(Pizza:GetPos() + vec_up, zclib.HUD.GetLookAngles(), 0.1)
		local y = 0
		for _, ing_id in pairs(Pizza.cl_NeededIngredients) do
			DrawIngredientItem(zpiz.Ingredient.GetIcon(ing_id), y)
			y = y - 80
		end
	cam.End3D2D()
end

function zpiz.Pizza.DrawRawToppings(Pizza)
	if table.Count(Pizza.cl_AddedIngredients) <= 0 then return end
	cam.Start3D2D(Pizza:LocalToWorld(Vector(0, 0, 2)), Pizza:GetAngles(), 0.1)
		for k, v in ipairs(Pizza.cl_AddedIngredients) do
			surface.SetDrawColor(zpiz.Ingredient.GetColor(v))
			surface.SetMaterial(zpiz.materials["zpiz_ingredient_top"])
			surface.DrawTexturedRectRotated(0, 0, 200, 200, 45 * k)
		end
	cam.End3D2D()
end

function zpiz.Pizza.DrawMainInfo(Pizza)
	local cState = Pizza:GetPizzaState()
	local pTop = zpiz.Pizza.GetIcon(Pizza:GetPizzaID())
	cam.Start3D2D(Pizza:LocalToWorld(Vector(0,0,2)), Pizza:GetAngles(), 0.1)
		if (cState == 3) then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(pTop)
			surface.DrawTexturedRect(-110, -110, 220, 220)
		elseif (cState == 4) then
			surface.SetDrawColor(zpiz.colors["burned"])
			surface.SetMaterial(pTop)
			surface.DrawTexturedRect(-113, -113, 226, 226)
		end
	cam.End3D2D()
end

local vec_name = Vector(0,0,10)
function zpiz.Pizza.DrawName(Pizza)
	local pName = zpiz.Pizza.GetName(Pizza:GetPizzaID())
	local charlength = string.len(pName)

	cam.Start3D2D(Pizza:GetPos() + vec_name, zclib.HUD.GetLookAngles(), 0.1)
		draw.RoundedBox(15, -(25 * charlength)  / 2, -170, 25 * charlength, 50, zpiz.colors["black02"])
		draw.DrawText(pName, zclib.GetFont("zpiz_pizza_font01"),0, -170,  color_white, TEXT_ALIGN_CENTER  )
	cam.End3D2D()
end
