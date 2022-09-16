if SERVER then return end
zmc = zmc or {}
zmc.Customertable = zmc.Customertable or {}

function zmc.Customertable.Initialize(Customertable)
    //if Customertable.CustomerData == nil then Customertable.CustomerData = {} end
end

function zmc.Customertable.Draw(Customertable)

    if zclib.util.InDistance(Customertable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then

        if Customertable.CustomerData == nil then
            // Get cached the data
            Customertable.CustomerData = zmc.CustomertableData[Customertable:EntIndex()]
           Customertable.CustomerDataChanged = true
           zmc.Customertable.RemoveClientModels(Customertable)
            return
        end

        // Rebuild ClientModels
        if Customertable.CustomerDataChanged == true then

            if Customertable.ClientModels == nil then Customertable.ClientModels = {} end

            // If the new customer data has less slots then remove anything above
            for slot,v in pairs(Customertable.ClientModels) do
                if Customertable.CustomerData[slot] == nil then
                    zmc.Customertable.RemoveCustomer(Customertable,slot)
                    zmc.Customertable.RemoveSeat(Customertable,slot)
                end
            end

            for seat_id,customer_data in pairs(Customertable.CustomerData) do
                if customer_data == nil then continue end

                if Customertable.ClientModels[seat_id] == nil then Customertable.ClientModels[seat_id] = {} end

                // Create / Update seats
                zmc.Customertable.UpdateSeat(Customertable,seat_id,customer_data)

                if customer_data.customer_id == nil or customer_data.dish_id == nil then
                    zmc.Customertable.RemoveCustomer(Customertable,seat_id)
                    continue
                end

                local DishData = zmc.Dish.GetData(customer_data.dish_id)
                if DishData == nil then
                    zmc.Customertable.RemoveCustomer(Customertable,seat_id)
                    continue
                end

                // Create / Update customer
                zmc.Customertable.UpdateCustomer(Customertable,seat_id,customer_data)

                // Create / Update food
                zmc.Customertable.UpdateFood(Customertable,seat_id,customer_data)
            end

            Customertable.CustomerDataChanged = nil
        end

        // Draw ClientModels of Dishes
        if Customertable.ClientModels then
            for k, v in pairs(Customertable.ClientModels) do
                if v then
                    zmc.Customertable.DrawCustomer(Customertable,v,k)
                end
            end
        end
    else
        zmc.Customertable.RemoveClientModels(Customertable)

        Customertable.CustomerDataChanged = true
    end
end

function zmc.Customertable.Think(Customertable) end

function zmc.Customertable.OnRemove(Customertable)
    zmc.Customertable.RemoveClientModels(Customertable)
    zmc.CustomertableData[Customertable:EntIndex()] = nil
end

//////////////// SEAT
function zmc.Customertable.UpdateCustomer(Customertable,seat_id,customer_data)
    if  Customertable.ClientModels[seat_id] and IsValid(Customertable.ClientModels[seat_id].customer) then return end
    zmc.Customertable.BuildCustomer(Customertable,seat_id,customer_data)
end

local SitAnims = {"sit_rollercoaster","sit","sit_zen"}
local function LookAtPos( ent, lookat )
    local attachment = ent:GetAttachment( ent:LookupAttachment( "eyes" ) )
    if attachment == nil then return end
    local apos = attachment.Pos + attachment.Ang:Forward() * 25
    ent:SetEyeTarget(apos)
end
function zmc.Customertable.BuildCustomer(Customertable,seat_id,customer_data)

    local CustomerMdl = zmc.config.Customers[customer_data.customer_id]
    local customer = zclib.ClientModel.AddProp()
    if not IsValid(customer) then return end
    customer:SetModel(CustomerMdl)
    customer:SetupBones() // Makes the bones work
    Customertable.ClientModels[seat_id].customer = customer

    // Find a valid sit animation
    local sitAnim = SitAnims[math.random(#SitAnims)]
    if customer:LookupSequence(sitAnim) == -1 then
        for k,v in ipairs(SitAnims) do
            sitAnim = customer:LookupSequence(v)
            if sitAnim ~= -1 then break end
        end
    end
    Customertable.ClientModels[seat_id].SitAnim = sitAnim

    // Set the eyes, BUG Doesent really work for some reason
    LookAtPos( customer, Customertable:GetPos() )
end

local EatAnim_speed = 3

local FlexToSet = {
    ["smile"] = true,
    ["right_lid_raiser"] = true,
    ["left_lid_raiser"] = true,
    //["eyes_updown"] = true
}
local FlexMoutOpen = {
    ["head_updown"] = true,
    ["jaw_drop"] = true,
    ["head_tilt"] = true,
    ["right_mouth_drop"] = true,
    ["left_mouth_drop"] = true,
}
local FlexMoutClose = {
    ["bite"] = true,
    ["right_part"] = true,
    ["left_part"] = true,
    ["left_funneler"] = true,
    ["right_funneler"] = true,
    ["presser"] = true,
}
local BoneRot = {
    ["ValveBiped.Bip01_Spine"] = true,
    ["ValveBiped.Bip01_Spine1"] = true,
    ["ValveBiped.Bip01_Spine2"] = true,
    ["ValveBiped.Bip01_Spine4"] = true,
    ["ValveBiped.Bip01_Neck1"] = true,
    ["ValveBiped.Bip01_Head1"] = true,
}

function zmc.Customertable.DrawCustomer(Customertable,CustomerData,SeatID)
    if Customertable.CustomerData[SeatID] == nil then return end
    local gotFood = Customertable.CustomerData[SeatID].received_food

    if IsValid(CustomerData.customer) then

        local TableData = zmc.Table.GetData(Customertable:GetTableID())
        local SeatData = zmc.Seat.GetData(Customertable:GetSeatID())
        if TableData and TableData.positions[SeatID] and TableData.positions[SeatID].seat and Customertable.ClientModels[SeatID] then
            local seat_data = TableData.positions[SeatID].seat

            local pos = Customertable:LocalToWorld(seat_data.pos)
            local ang = seat_data.ang
            if SeatData then
                pos = pos + CustomerData.seat:GetRight() * SeatData.sitpos.x
                pos = pos + CustomerData.seat:GetForward() * SeatData.sitpos.y
                pos = pos + CustomerData.seat:GetUp() * SeatData.sitpos.z

                ang = ang + SeatData.sitang
            end

            CustomerData.customer:SetPos(pos)
            CustomerData.customer:SetAngles(Customertable:LocalToWorldAngles(ang))
        end


        if CustomerData.SitAnim ~= -1 then
            CustomerData.customer:SetSequence(CustomerData.SitAnim)
            CustomerData.cycle = (CustomerData.cycle or 0) + (FrameTime() * 1)
            if CustomerData.cycle > 1 then CustomerData.cycle = 0 end
            CustomerData.customer:SetCycle(CustomerData.cycle)
        end

        if gotFood == true then
            CustomerData.mouth_anim = math.sin((CurTime() * (15 - (SeatID * 0.5)) * EatAnim_speed) + (SeatID * 5))
            CustomerData.bow_anim = math.sin((CurTime() * 3 * EatAnim_speed) + (SeatID * 5))

            for k,v in pairs(BoneRot) do
                local id = CustomerData.customer:LookupBone(k)
                if id == nil then continue end
                CustomerData.customer:ManipulateBoneAngles( id, Angle(0,5 - (10 * CustomerData.bow_anim),0) )
            end
        else
            CustomerData.mouth_anim = -1
            CustomerData.bow_x_anim = math.sin(CurTime() * (1 - (SeatID * 0.1)))
            CustomerData.bow_y_anim = math.cos(CurTime() * (1 - (SeatID * 0.1)))
            for k,v in pairs(BoneRot) do
                local id = CustomerData.customer:LookupBone(k)
                if id == nil then continue end
                CustomerData.customer:ManipulateBoneAngles( id, Angle(0,-5 + (3 * CustomerData.bow_y_anim),3 * CustomerData.bow_x_anim) )
            end
        end

        // Animate the mouth
        CustomerData.customer:SetFlexScale(math.sin(CurTime() * (2 - (SeatID * 0.1))) )
        local FlexNum = CustomerData.customer:GetFlexNum()
    	if ( FlexNum > 0) then
        	for i = 0, FlexNum do

        		local Name = CustomerData.customer:GetFlexName( i )

                if FlexToSet[Name] then
                    CustomerData.customer:SetFlexWeight( i, 1 )
                else
                    CustomerData.customer:SetFlexWeight( i, 0 )
                end

                if CustomerData.mouth_anim > 0 then
                    if FlexMoutOpen[Name] then CustomerData.customer:SetFlexWeight( i, CustomerData.mouth_anim ) end
                else
                    if FlexMoutClose[Name] then CustomerData.customer:SetFlexWeight( i, math.abs(CustomerData.mouth_anim) ) end
                end
        	end
        end
    end

    zmc.Customertable.DrawSeat(Customertable,CustomerData,SeatID)

    if gotFood == false then return end

    zmc.Customertable.DrawFood(Customertable,CustomerData,SeatID)
end

function zmc.Customertable.RemoveCustomer(Customertable,slot)
    local mdlData = Customertable.ClientModels[slot]
    if mdlData then
        zclib.ClientModel.Remove(mdlData.customer)
        mdlData.customer = nil

        if mdlData.plate then zmc.Dish.RemoveClientModels(mdlData.plate) end

        zclib.ClientModel.Remove(mdlData.plate)
        mdlData.plate = nil
    end
end

function zmc.Customertable.RemoveCustomerModels(Customertable)
    if Customertable.ClientModels then

        for seat_id,customer_data in pairs(Customertable.ClientModels) do
            if customer_data == nil then continue end
            zmc.Customertable.RemoveCustomer(Customertable,seat_id)
        end
    end
end
////////////////////////////////////////



//////////////// SEAT
function zmc.Customertable.UpdateSeat(Customertable,seat_id,customer_data)
    local SeatData = zmc.Seat.GetData(Customertable:GetSeatID())
    if SeatData == nil then
        zmc.Customertable.RemoveSeat(Customertable,seat_id)
        return
    end

    if IsValid(Customertable.ClientModels[seat_id].seat) and Customertable.ClientModels[seat_id].seat:GetModel() == SeatData.mdl then return end

    zmc.Customertable.RemoveSeat(Customertable,seat_id)

    zmc.Customertable.BuildSeat(Customertable,seat_id,customer_data)
end

function zmc.Customertable.BuildSeat(Customertable,seat_id,customer_data)
    local SeatData = zmc.Seat.GetData(Customertable:GetSeatID())

    local seat = zclib.ClientModel.AddProp()
    if not IsValid(seat) then return end
    seat:SetModel(SeatData.mdl or "models/zerochain/props_kitchen/zmc_seat.mdl")
    seat:SetRenderMode(RENDERMODE_NORMAL)
    Customertable.ClientModels[seat_id].seat = seat
end

function zmc.Customertable.DrawSeat(Customertable,CustomerData,SeatID)
    if not IsValid(CustomerData.seat) then return end

    local TableData = zmc.Table.GetData(Customertable:GetTableID())
    local SeatData = zmc.Seat.GetData(Customertable:GetSeatID())
    if TableData and SeatData and TableData.positions[SeatID] and TableData.positions[SeatID].seat then

        local seat_data = TableData.positions[SeatID].seat
        local pos = Customertable:LocalToWorld(seat_data.pos)

        pos = pos + CustomerData.seat:GetRight() * SeatData.offset.x
        pos = pos + CustomerData.seat:GetForward() * SeatData.offset.y
        pos = pos + CustomerData.seat:GetUp() * SeatData.offset.z

        local ang = seat_data.ang
        if SeatData.ang_offset then
            ang = ang + SeatData.ang_offset
        end

        CustomerData.seat:SetPos(pos)
        CustomerData.seat:SetAngles(Customertable:LocalToWorldAngles(ang))
    end
end

function zmc.Customertable.RemoveSeat(Customertable,SeatID)
    if Customertable.ClientModels and Customertable.ClientModels[SeatID] and Customertable.ClientModels[SeatID].seat then
        zclib.ClientModel.Remove(Customertable.ClientModels[SeatID].seat)
        Customertable.ClientModels[SeatID].seat = nil
    end
end
////////////////////////////////////////



//////////////// FOOD
function zmc.Customertable.UpdateFood(Customertable,seat_id,customer_data)
    if customer_data.received_food ~= true then return end
    if Customertable.ClientModels[seat_id] and IsValid(Customertable.ClientModels[seat_id].plate) then return end
    zmc.Customertable.BuildFood(Customertable,seat_id,customer_data)
end

function zmc.Customertable.BuildFood(Customertable,seat_id,customer_data)
    local DishData = zmc.Dish.GetData(customer_data.dish_id)
    Customertable.ClientModels[seat_id].DishID = customer_data.dish_id

    local plate = zclib.ClientModel.AddProp()
    if not IsValid(plate) then return end
    plate:SetModel(DishData.mdl or "models/zerochain/props_kitchen/zmc_plate01.mdl")
    plate:SetRenderMode(RENDERMODE_NORMAL)
    Customertable.ClientModels[seat_id].plate = plate
end

function zmc.Customertable.DrawFood(Customertable,CustomerData,SeatID)
    if not IsValid(CustomerData.plate) then return end

    local TableData = zmc.Table.GetData(Customertable:GetTableID())
    if TableData and TableData.positions[SeatID] and TableData.positions[SeatID].plate then
        local min = CustomerData.plate:GetModelBounds()
        local plate_data = TableData.positions[SeatID].plate
        local plate_pos = Vector(plate_data.pos.x,plate_data.pos.y,plate_data.pos.z - min.z)
        CustomerData.plate:SetPos(Customertable:LocalToWorld(plate_pos))
        CustomerData.plate:SetAngles(Customertable:LocalToWorldAngles(plate_data.ang))
    end

    if CustomerData.LastEffect == nil or CurTime() > CustomerData.LastEffect and CustomerData.bow_anim <= -0.8 then
        CustomerData.LastEffect = CurTime() + 0.2
        zmc.Effect.Eat(CustomerData.plate)
    end


    zmc.Dish.DrawFoodItems(CustomerData.plate,zmc.Dish.GetData(CustomerData.DishID),nil,nil)
end
////////////////////////////////////////



function zmc.Customertable.RemoveClientModels(Customertable)

    // Remove seat
    if Customertable.ClientModels then

        for seat_id,customer_data in pairs(Customertable.ClientModels) do
            if customer_data == nil then continue end
            zmc.Customertable.RemoveSeat(Customertable,seat_id)
        end
    end

    // Remove customer, plate and food
    zmc.Customertable.RemoveCustomerModels(Customertable)

    Customertable.ClientModels = nil
end
