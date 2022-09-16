zgo2 = zgo2 or {}
zgo2.Backpack = zgo2.Backpack or {}

/*

	The backpack swep can be used to transport weed

*/

net.Receive("zgo2.Backpack.Open", function(len, ply)
	zclib.Debug_Net("zgo2.Backpack.Open", len)
	local Backpack = net.ReadEntity()
	if not IsValid(Backpack) then return end

	Backpack.Inventory = {}

	local Count = net.ReadUInt(16)
	for i = 1, Count do
		Backpack.Inventory[ net.ReadUInt(16) ] = {
			class = net.ReadString(),
			weed_id = net.ReadUInt(16),
			model = net.ReadString(),
			weed_amount = net.ReadUInt(16),
		}
	end

	zgo2.Backpack.Open(Backpack)
end)

net.Receive("zgo2.Backpack.Update", function(len, ply)
	zclib.Debug_Net("zgo2.Backpack.Update", len)
	local Backpack = net.ReadEntity()
	if not IsValid(Backpack) then return end

	Backpack.Inventory = {}

	local Count = net.ReadUInt(16)
	for i = 1, Count do
		Backpack.Inventory[ net.ReadUInt(16) ] = {
			class = net.ReadString(),
			weed_id = net.ReadUInt(16),
			model = net.ReadString(),
			weed_amount = net.ReadUInt(16),
		}
	end
end)

function zgo2.Backpack.Open(Backpack)
	zclib.vgui.Page("Backpack", function(main, top)
		main:SetSize(800 * zclib.wM, 610 * zclib.hM)

		zgo2.vgui.ImageButton(top, zclib.Materials.Get("close"), zclib.colors[ "red01" ], function()
			main:Close()
		end, function() return false end, zgo2.language[ "Close" ])

		local seperator = zclib.vgui.AddSeperator(top)
		seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
		seperator:Dock(RIGHT)
		seperator:DockMargin(10 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)

		local content = vgui.Create("DPanel", main)
		content:Dock(FILL)
		content:DockMargin(50 * zclib.wM, 5 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
		content:SetSize(700 * zclib.wM, 300 * zclib.hM)
		content.Paint = function(s, w, h)
			draw.RoundedBox(10, 0, 0, w, h, zclib.colors[ "black_a100" ])
		end

		local list, scroll = zclib.vgui.List(content)
		list:DockMargin(10 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
		scroll.Paint = function(s, w, h) end
		list.Paint = function(s, w, h) end

		for i = 1, 24 do
			local itm = list:Add("DPanel")
			itm:SetSize(105 * zclib.wM, 105 * zclib.hM)
			itm.Paint = function(s, w, h)
				draw.RoundedBox(10, 0, 0, w, h, zclib.colors[ "black_a100" ])
			end

			local SlotData = Backpack.Inventory[i]
			if not SlotData then continue end

			local imgpnl = vgui.Create("DImageButton", itm)
			imgpnl:Dock(FILL)
			local img = zclib.Snapshoter.Get({
				class = SlotData.class,
				model = SlotData.model,
				PlantID = SlotData.weed_id,
			}, imgpnl)
			imgpnl:SetImage(img and img or "materials/zerochain/zerolib/ui/icon_loading.png")

			imgpnl.PaintOver = function(s,w,h)

				//draw.RoundedBox(0, 0, 0, w, 20 * zclib.hM, zclib.colors[ "black_a100" ])

				if s:IsHovered() then
					draw.RoundedBox(10, 0, 0, w, h, zclib.colors[ "white_a15" ])
				end
			end

			imgpnl.DoClick = function()
				zclib.vgui.PlaySound("UI/buttonclick.wav")

				net.Start("zgo2.Backpack.Drop")
				net.WriteEntity(Backpack)
				net.WriteUInt(i,32)
				net.SendToServer()

				imgpnl:SetDisabled(true)

				timer.Simple(1.5,function()
					if IsValid(imgpnl) then imgpnl:SetDisabled(false) end
				end)
			end
		end
	end)
end
