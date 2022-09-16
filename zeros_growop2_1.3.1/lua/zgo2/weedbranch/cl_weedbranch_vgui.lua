zgo2 = zgo2 or {}
zgo2.Weedbranch = zgo2.Weedbranch or {}

net.Receive("zgo2.Weedbranch.OpenClipper", function(len,ply)
    zclib.Debug_Net("zgo2.Weedbranch.OpenClipper", len)

    local Weedbranch = net.ReadEntity()
	zgo2.Weedbranch.Clip(Weedbranch)
end)

function zgo2.Weedbranch.Clip(Weedbranch)

	local GameProgess = 0

	local BGPanel = vgui.Create("DButton")
	BGPanel:Dock(FILL)
	BGPanel:MakePopup()
	BGPanel:SetText("")
	BGPanel.Paint = function(s, w, h)
		zclib.util.DrawBlur(s, 5, 3)
		draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])
		if input.IsKeyDown(KEY_ESCAPE) then
			s:Remove()
		end
	end
	BGPanel.DoClick = function(s)
		zclib.vgui.PlaySound("UI/buttonclick.wav")
		s:Remove()
	end

	local mdl = vgui.Create( "DModelPanel" ,BGPanel)
	mdl:SetModel( "models/zerochain/props_growop2/zgo2_weedstick.mdl" )
	mdl:Dock(FILL)
	function mdl:LayoutEntity( Entity ) return end

	local sideLight = Color(200,200,200)
	mdl:SetDirectionalLight(BOX_TOP, color_white)
	mdl:SetDirectionalLight(BOX_FRONT, sideLight)
	mdl:SetDirectionalLight(BOX_BACK, sideLight)
	mdl:SetDirectionalLight(BOX_LEFT, sideLight)
	mdl:SetDirectionalLight(BOX_RIGHT, sideLight)

	// Disable normal leafs
	mdl.Entity:SetBodygroup(4,1)

	// Enable shrunk leafs
	mdl.Entity:SetBodygroup(6,1)
	mdl.Entity:SetBodygroup(7,1)
	mdl.Entity:SetBodygroup(8,1)

	// Disable hair
	mdl.Entity:SetBodygroup(3,1)

	local bgSet = {
		[1] = 6,
		[2] = 7,
		[3] = 8,

		[4] = 0,
		[5] = 1,
		[6] = 2,
	}

	local MouseLeft = false
	function mdl:PerformLayout(w, h)
		mdl:SetWide(h)
		mdl:Center()

		local curMouse = input.IsMouseDown(MOUSE_LEFT)

		if MouseLeft ~= curMouse and vgui.GetHoveredPanel() == self then
			MouseLeft = curMouse

			if MouseLeft then
				zclib.Sound.EmitFromPosition(EyePos(), "zgo2_plant_cut")
				GameProgess = GameProgess + 1
				mdl.Entity:SetBodygroup(bgSet[ GameProgess ], GameProgess > 3 and 1 or 0)

				if GameProgess >= 6 then
					BGPanel:Remove()
					net.Start("zgo2.Weedbranch.FinishClip")
					net.WriteEntity(Weedbranch)
					net.SendToServer()
				end
			end
		end
	end

	local PlantData = zgo2.Plant.GetData(Weedbranch:GetPlantID())
	zgo2.Plant.UpdateMaterial(mdl.Entity,PlantData,nil,true)

	mdl:SetCamPos(Vector(30,0,0))
	mdl.Entity:SetPos(vector_origin)
	mdl:SetLookAt(vector_origin)
end
