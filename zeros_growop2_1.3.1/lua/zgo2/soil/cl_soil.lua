zgo2 = zgo2 or {}
zgo2.Soil = zgo2.Soil or {}

net.Receive("zgo2.Soil.Place", function(len)
    zclib.Debug_Net("zgo2.Soil.Place", len)
	local Soil = net.ReadEntity()

	zclib.PointerSystem.Start(Soil, function()
		-- OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
		zclib.PointerSystem.Data.ActionName =  zgo2.language[ "Place" ]
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()
		-- OnLeftClick
		net.Start("zgo2.Soil.Place")
		net.WriteEntity(Soil)
		net.SendToServer()
		zclib.PointerSystem.Stop()
	end, function()

		if IsValid(zclib.PointerSystem.Data.HitEntity) and zclib.PointerSystem.Data.HitEntity:GetClass() == "zgo2_pot" then
			zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
		else
			zclib.PointerSystem.Data.MainColor = zclib.colors[ "red01" ]
		end

		-- Update PreviewModel
		if IsValid(zclib.PointerSystem.Data.PreviewModel) then

			local ent = zclib.PointerSystem.Data.HitEntity
			if IsValid(ent) then
				zclib.PointerSystem.Data.PreviewModel:SetModel(ent:GetModel())
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
				zclib.PointerSystem.Data.PreviewModel:SetPos(ent:GetPos())
				zclib.PointerSystem.Data.PreviewModel:SetAngles(ent:GetAngles())
				zclib.PointerSystem.Data.PreviewModel:SetModelScale(ent:GetModelScale() or 1)
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
			else
				zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
				zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
				zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
			end

		end
	end, nil, function()

	end)
end)
