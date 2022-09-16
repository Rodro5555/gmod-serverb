if not CLIENT then return end
net.Receive("zmlab2_Storage_OpenInterface", function(len)
    zclib.Debug_Net("zmlab2_Storage_OpenInterface",len)

    LocalPlayer().zmlab2_Storage = net.ReadEntity()

    zmlab2.Interface.Create(600,365,zmlab2.language["Storage"],function(pnl)

        zmlab2.Interface.AddModelList(pnl,zmlab2.config.Storage.Shop,function(id)
            // IsLocked
            return zmlab2.Storage.BuyCheck(LocalPlayer(),id) == false
        end,
        function(id)
            // IsSelected
            return false
        end,
        function(id)
            // OnClick
            if LocalPlayer().zmlab2_Storage:GetNextPurchase() > CurTime() then return end

            net.Start("zmlab2_Storage_Buy")
            net.WriteEntity(LocalPlayer().zmlab2_Storage)
            net.WriteUInt(id,16)
            net.SendToServer()
        end,
        function(raw_data)
            return {model = raw_data.model,render = {FOV = 35},color = raw_data.color,bodygroup = {[0] = 5}} , raw_data.name , zclib.Money.Display(raw_data.price)
        end)
    end)
end)
