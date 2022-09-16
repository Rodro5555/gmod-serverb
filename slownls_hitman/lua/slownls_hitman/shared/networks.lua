--[[  
    Addon: Hitman
    By: SlownLS
]]

local TABLE = SlownLS.Hitman
local strNet = "SlownLS:Hitman:Events"

-- Intialize
if SERVER then
    util.AddNetworkString(strNet)
end

-- Function to add event
function TABLE:addEvent(strName,funcCallback)
	self.Events = self.Events or {}
	
	self.Events[strName] = funcCallback
end

-- Function to send event
function TABLE:sendEvent(strName,tblInfos,pPlayer)
    if CLIENT then
        net.Start(strNet)
        net.WriteString(strName)
        net.WriteTable(tblInfos or {})
        net.SendToServer()
    else

        if pPlayer and !IsValid(pPlayer) then return end
        
        if( not pPlayer ) then
            pPlayer = player.GetAll()
        end

        net.Start(strNet)
        net.WriteString(strName)
        net.WriteTable(tblInfos or {})
        net.Send(pPlayer)
    end
end

-- Receive
net.Receive(strNet,function(_,pPlayer)
	local strEventName = net.ReadString()
	local tblInfos = net.ReadTable() or {}

	TABLE.Events = TABLE.Events or {}

	if !strEventName then return end
	if !TABLE.Events[strEventName] then return end

    if SERVER then
	    TABLE.Events[strEventName](TABLE,pPlayer,tblInfos)
        return 
    end

    TABLE.Events[strEventName](tblInfos)
end)