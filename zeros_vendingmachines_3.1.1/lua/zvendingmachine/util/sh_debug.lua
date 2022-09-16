if SERVER then
	util.AddNetworkString("zvm_debug_machine")

	concommand.Add("zvm_debug_vendingmachine", function(ply, cmd, args)
		if IsValid(ply) and zclib.Player.IsAdmin(ply) then
			local tr = ply:GetEyeTrace()

			if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zvm_machine" then
				local ent = tr.Entity

				if ent.Products then
					PrintTable(ent.Products)
				end

				net.Start("zvm_debug_machine")
				net.WriteEntity(ent)
				net.Send(ply)
			end
		end
	end)
end

if CLIENT then
	net.Receive("zvm_debug_machine", function(len, ply)
		zclib.Debug("zvm_debug_machine Netlen: " .. len)
		local ent = net.ReadEntity()

		if IsValid(ent) then
			print("____________________")
			print(tostring(ent))
			print("BuyCount: " .. ent.BuyCount)
			print("BuyCost: " .. ent.BuyCost)
			print("____________________")

			if ent.Products then
				PrintTable(ent.Products)
			end
		end
	end)
end
