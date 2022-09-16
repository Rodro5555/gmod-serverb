if SERVER then return end
ztm = ztm or {}
ztm.Trash = ztm.Trash or {}

function ztm.Trash.Initialize(Trash)
	zclib.EntityTracker.Add(Trash)
end

function ztm.Trash.Draw(Trash)
	if zclib.Convar.Get("zclib_cl_drawui") == 1 and zclib.util.InDistance(LocalPlayer():GetPos(), Trash:GetPos(), 500) and ztm.Player.IsTrashman(LocalPlayer()) then
		ztm.HUD.DrawTrash(Trash:GetTrash(),Trash:GetPos() + Vector(0, 0, 50))
	end
end

function ztm.Trash.OnRemove(Trash)
	ztm.Effects.Trash(Trash:GetPos(), nil)
end

local function HasToolActive()
	local ply = LocalPlayer()

	if IsValid(ply) and ply:Alive() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "gmod_tool" then
		local tool = ply:GetTool()

		if tool and table.Count(tool) > 0 and IsValid(tool.SWEP) and tool.Mode == "ztm_trashspawner" and tool.Name == "#TrashSpawner" then
			return true
		else
			return false
		end
	else
		return false
	end
end

zclib.Hook.Add("PostDrawTranslucentRenderables", "ztm_trashspawner", function()
	if HasToolActive() then
		local tr = LocalPlayer():GetEyeTrace()

		if tr.Hit and not IsValid(tr.Entity) and zclib.util.InDistance(tr.HitPos, LocalPlayer():GetPos(), 300) then
			render.SetColorMaterial()
			render.DrawWireframeSphere(tr.HitPos, 1, 4, 4, ztm.default_colors["white01"], false)
		end
	end
end)

local wMod = ScrW() / 1920
local hMod = ScrH() / 1080
local Trash_Hints = {}

net.Receive("ztm_trash_showall", function(len)
	local dataLength = net.ReadUInt(16)
	local d_Decompressed = util.Decompress(net.ReadData(dataLength))
	local positions = util.JSONToTable(d_Decompressed)

	if positions then
		Trash_Hints = positions

		zclib.Hook.Remove("HUDPaint", "ztm_TrashHints")
		zclib.Hook.Add("HUDPaint", "ztm_TrashHints", function()
			if Trash_Hints and table.Count(Trash_Hints) > 0 then
				for k, v in pairs(Trash_Hints) do
					if v then
						local pos = v:ToScreen()
						local size = 10
						surface.SetDrawColor(ztm.default_colors["red02"])
						surface.DrawRect(pos.x - (size * wMod) / 2, pos.y - (size * hMod) / 2, size * wMod, size * hMod)
					end
				end
			end
		end)
	end
end)

net.Receive("ztm_trash_hideall", function(len)
	Trash_Hints = {}
	zclib.Hook.Remove("HUDPaint", "ztm_TrashHints")
end)
