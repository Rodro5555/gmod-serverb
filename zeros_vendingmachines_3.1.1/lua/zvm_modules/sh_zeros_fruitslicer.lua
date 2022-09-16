/////////////////////////
// Zeros Fruitlsicer
// https://www.gmodstore.com/market/view/4965

zvm.AllowedItems.Add("zfs_smoothie") // Has CustomData
zvm.AllowedItems.Add("zfs_fruitbox")

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosFruitlsicer", function( data,ent,itemclass)
    if zfs then
		if itemclass == "zfs_smoothie" then
			data.ProductID = ent:GetProductID()
			data.ToppingID = ent:GetToppingID()
		elseif itemclass == "zfs_fruitbox" then
			data.FruitID = ent:GetFruitID()
		end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosFruitlsicer", function( itemclass, ent, extraData)
    if zfs then
		if itemclass == "zfs_smoothie" then
			ent:SetProductID(extraData.ProductID)
			ent:SetToppingID(extraData.ToppingID)
			zfs.Smoothie.Visuals(ent)
		elseif itemclass == "zfs_fruitbox" then
			ent:SetFruitID(extraData.FruitID)
		end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosFruitlsicer", function(ent,extraData)
    if zfs then
		local class = ent:GetClass()
		if class == "zfs_smoothie" then
			local name = "Unkown"
			local pData = zfs.Smoothie.GetData(ent:GetProductID())
			if pData then name = pData.Name end

			local tData = zfs.Topping.GetData(ent:GetToppingID())
			if tData and ent:GetToppingID() > 1 then
				name = name .. " [" .. tData.Name .. "]"
			end
			return name
		elseif class == "zfs_fruitbox" then
			local dat = zfs.Fruit.GetData(ent:GetFruitID())
			return dat.Name or "Unknown"
		end
    end
end)

hook.Add("zvm_OnItemDataPrice", "zvm_OnItemDataPrice_ZerosFruitlsicer", function(ent, extraData)
	if zfs and ent:GetClass() == "zfs_smoothie" then
		if ent.Price then
			return ent.Price
		else
			local pData = zfs.Smoothie.GetData(ent:GetProductID())
			local tData = zfs.Topping.GetData(ent:GetToppingID())
			local PriceBoni = zfs.Smoothie.GetFruitVarationBoni(ent:GetProductID()) * zfs.config.Price.FruitMultiplicator
			local FruitVariationCharge = math.Round(pData.Price * PriceBoni)
			return FruitVariationCharge + tData.ExtraPrice
		end
	end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosFruitlsicer", function(itemclass,compared_item,extraData)
    if zfs then
        if itemclass == "zfs_fruitbox" and extraData.FruitID then
            return true, compared_item.extraData.FruitID == extraData.FruitID
        elseif itemclass == "zfs_smoothie" and extraData.ProductID and extraData.ToppingID then
            return true, compared_item.extraData.ProductID == extraData.ProductID and compared_item.extraData.ToppingID == extraData.ToppingID
        end
    end
end)

zclib.Snapshoter.SetPath("zfs_fruitbox", function(ItemData)
	if ItemData.extraData then return "zfs/fruits/zfs_fruitbox_" .. ItemData.extraData.FruitID end
end)

zclib.Snapshoter.SetPath("zfs_smoothie", function(ItemData)
	if ItemData.extraData then return "zfs/smoothies/zfs_smoothie_" .. ItemData.extraData.ProductID .. "_" .. ItemData.extraData.ToppingID end
end)

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosFruitlsicer", function(cEnt, ItemData)
	if zfs and ItemData.class == "zfs_smoothie" then
		zclib.CacheModel("models/zerochain/fruitslicerjob/fs_fruitcup.mdl")
		local pData = zfs.Smoothie.GetData(ItemData.extraData.ProductID)
		local tData = zfs.Topping.GetData(ItemData.extraData.ToppingID)

		if pData and tData then
			cEnt:SetBodygroup(0, 1)
			cEnt:SetColor(zfs.Smoothie.GetColor(ItemData.extraData.ProductID))

			if tData.Model then
				zclib.CacheModel(tData.Model)
				// Create topping model
				local client_mdl = zclib.ClientModel.Add(tData.Model, RENDERGROUP_BOTH)

				if IsValid(client_mdl) then
					client_mdl:SetModel(string.lower(tData.Model))
					local ang = cEnt:GetAngles()
					ang:RotateAroundAxis(cEnt:GetUp(), 90)
					client_mdl:SetAngles(ang)
					local pos = cEnt:GetPos() + cEnt:GetUp() * 10
					client_mdl:SetPos(pos)
					client_mdl:SetParent(cEnt)
					client_mdl:SetModelScale(tData.mScale)

					render.Model({
						model = string.lower(tData.Model),
						pos = pos,
						angle = ang
					}, client_mdl)

					cEnt:CallOnRemove("zfs_remove_render_topping_" .. cEnt:EntIndex(), function(ent)
						zclib.ClientModel.Remove(client_mdl)
					end)
				end
			end
		end
	end
end)

hook.Add("zclib_PostRenderProductImage", "zclib_PostRenderProductImage_ZerosFruitlsicer", function(cEnt, ItemData)
	if zfs and ItemData.class == "zfs_fruitbox" then
		zclib.CacheModel("models/zerochain/fruitslicerjob/fs_cardboardbox.mdl")
		cam.Start3D2D(cEnt:LocalToWorld(Vector(0, 0, 16.5)), cEnt:LocalToWorldAngles(Angle(0, 180, 0)), 0.2)
			surface.SetDrawColor(color_white)
			surface.SetMaterial(zfs.Fruit.GetIcon(ItemData.extraData.FruitID))
			surface.DrawTexturedRect(-50, -50, 100, 100)
		cam.End3D2D()
	end
end)
