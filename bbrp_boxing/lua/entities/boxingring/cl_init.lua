local imgui = include("imgui.lua")
include("shared.lua")

-- CONFIGURATION
-- Change this if it conflicts with other addons
local leaderboardCMD = "leaderboard"
-- Betting adjustment amounts, 32 bit (2147483647) limit
local lessWager = -500 -- [<]
local lessLessWager = -5000 -- [<<]
local lessLessLessWager = -50000 -- Left [!]
local moreWager = 10000 -- [>]
local moreMoreWager = 100000 -- [>>]
local moreMoreMoreWager = 1000000 -- Right [!]
-- Colors!
local col_Title = Color(255,32,32)
local col_SignBG = Color(100,100,166)
local col_FlavorOutline = Color(255,143,143)
local col_ButtonBG = Color(60,60,100)
local col_ButtonPress = Color(200,200,0)
local col_LeaderClose = Color(255, 41, 41)
local col_LeaderCloseDark = Color(200, 34, 34)
local col_LeaderBG = Color( 29, 29, 29)
local col_LeaderInner = Color(51, 51, 51)
local col_LeaderList = Color( 68, 68, 68)
local col_White = Color(255,255,255)
local col_Black = Color(0,0,0)
local col_Yellow = Color(255,255,0)
-- This controls how fast the sweep-up animation on the leaderboard is, default 6000
local sweepSpeed = 6000
-- END CONFIGURATION

-- Fonts, wouldn't mess with these too much
surface.CreateFont( "boxCool255", {
	font = "Consolas",
	size = 255,
} )
surface.CreateFont( "boxCool84", {
	font = "Consolas",
	size = 84,
} )
surface.CreateFont( "boxCool30", {
	font = "Consolas",
	size = 30,
} )
surface.CreateFont( "boxCool25", {
	font = "Consolas",
	size = 25,
} )
surface.CreateFont( "boxCool10HUD", {
	font = "Consolas",
	size = ScreenScale(10),
} )

local isLeaderboardUp = false
local Inner2Frame
local panelSweep = 0
local initialOpenPanel = 0

-- /leaderboard or !leaderboard by default
hook.Add("OnPlayerChat", "boxingRingLeaderboard", function(sender, text)

    if ( string.lower( text ) == "/"..leaderboardCMD || string.lower( text ) == "!"..leaderboardCMD ) && sender == LocalPlayer() then
		
		openLeaderboard()

    end
	
end)

function openLeaderboard()
	-- Empty the table we have in case the server-side table has deleted any entries since we last checked
	table.Empty( boxGlobalLeaderboard )
			
	net.Start( "boxRequestLeaderboard" )
	net.SendToServer()

	initialOpenPanel = os.clock()
	panelSweep = 0
			
	local BasePanel = vgui.Create( "DFrame" )
	BasePanel:SetPos( 0,0 )
	BasePanel:SetSize( 0,0 )
	BasePanel:SetTitle( "" )
	BasePanel:ShowCloseButton( false )
	BasePanel:SetDraggable( false )

	local MFrame = vgui.Create( "DPanel", BasePanel )
	MFrame:SetPos( ScrW()*0.29, math.max( panelSweep*sweepSpeed + ScrH(), ScrH()/8 ) )
	MFrame:SetSize( ScrW()*0.42,ScrH()*0.75 )
	MFrame:MakePopup()
	MFrame.Paint = function( self, w, h )
		panelSweep = initialOpenPanel - os.clock()
		MFrame:SetPos( MFrame:GetX(), math.max( panelSweep*sweepSpeed + ScrH(), ScrH()/8 ) )
		draw.RoundedBox( 5, 0, 0, w, h, col_LeaderBG )
	end
	function MFrame:OnClose()
		isLeaderboardUp = false
	end

	local MClose = vgui.Create( "DColorButton", MFrame )
	MClose:SetCursor( "arrow" )
	MClose:SetPos( 5,5 )
	MClose:SetSize( 0,25 )
	MClose:SetTooltipPanelOverride()
	MClose:Dock( TOP )
	MClose:DockMargin( 7.5, 7.5, 7.5, 0 )
	MClose:SetText( "" )
	MClose.Paint = function( self, w, h )
		RemoveTooltip()
		if( vgui.GetHoveredPanel() != MClose ) then
			draw.RoundedBox( 5, 0, 0, w, h, col_LeaderClose )
		else
			draw.RoundedBox( 5, 0, 0, w, h, col_LeaderCloseDark )
		end
	end
	function MClose:DoClick()
		BasePanel:Close()
	end

	local InnerFrame = vgui.Create( "DPanel", MFrame )
	InnerFrame:Dock( FILL )
	InnerFrame:DockMargin( 5, 5, 5, 5 )
	InnerFrame.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, col_LeaderInner )
	end

	Inner2Frame = vgui.Create( "DPanel", InnerFrame )
	Inner2Frame:Dock( FILL )
	Inner2Frame:DockMargin( 5, 5, 5, 5 )
	Inner2Frame.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, col_LeaderInner )
	end
			
	isLeaderboardUp = true

end

net.Receive("updateLeaderboard", function(len)

	boxGlobalLeaderboard = net.ReadTable()
	if(isLeaderboardUp == true) then
		local DScrollPanel = vgui.Create( "DScrollPanel", Inner2Frame )
		DScrollPanel:Dock( FILL )

		local fakeInput = {
			["SteamID"] = "SteamID",
			["Nick"] = "Name",
			["Score"] = "Wins"
		}

		innerLeaderList( fakeInput, DScrollPanel )
		
		local boxGlobalLeaderboardSorted = {}
		local i = 0

		for k, v in pairs(boxGlobalLeaderboard) do
			i = i + 1
			boxGlobalLeaderboardSorted[i] = v
		end

		table.sort(boxGlobalLeaderboardSorted, function(a,b)
			return tonumber(a.Score) > tonumber(b.Score)
		end)

		for k, v in ipairs(boxGlobalLeaderboardSorted) do
			innerLeaderList( v, DScrollPanel )
		end
	end

end)

function innerLeaderList( v, scrollPanel )
	local DPanel = scrollPanel:Add( "DPanel" )
	DPanel:Dock( TOP )
	DPanel:DockMargin( 0, 0, 0, 5 )
	DPanel:SetSize( 800,35 )
	DPanel.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, col_LeaderList )
	end
	local DLabel1 = vgui.Create( "DLabel", DPanel )
	DLabel1:SetPos( 5,0 )
	DLabel1:SetSize( 400,35 )
	DLabel1:SetFont( "boxCool10HUD" )
	if( string.len( string.Trim(v.Nick) ) > 20 ) then
		DLabel1:SetText( string.Trim( string.Left( v.Nick, 17 ) ) .. "..." )
	else
		DLabel1:SetText( string.Trim( v.Nick ) )
	end
	DLabel1:SetColor( col_White )
	local DLabel2 = vgui.Create( "DLabel", DPanel )
	DLabel2:SetPos( 360,0 )
	DLabel2:SetSize( 300,35 )
	DLabel2:SetFont( "boxCool10HUD" )
	DLabel2:SetText( v.SteamID )
	DLabel2:SetColor( col_White )
	DLabel2:SetMouseInputEnabled( true )
	function DLabel2:DoClick()
		if(v.SteamID == "SteamID") then
			return
		end
		gui.OpenURL( "http://steamcommunity.com/profiles/"..util.SteamIDTo64( v.SteamID ) )
	end
	local DLabel3 = vgui.Create( "DLabel", DPanel )
	DLabel3:SetPos(700,0)
	DLabel3:SetSize(100,35)
	DLabel3:SetFont( "boxCool10HUD" )
	if( isnumber( v.Score ) && v.Score > 9999 ) then
		DLabel3:SetText( "9999+" )
	else
		DLabel3:SetText( v.Score )
	end
	DLabel3:SetColor( col_White )
end

-- Don't render 2D3D until it's ready
local boxFullyLoaded = false

-- Player autofill for clean reserve command
local function boxPlyCMD( cmd, stringargs )
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	local tbl = {}
	for k, v in ipairs(player.GetAll()) do
		local nick = v:Nick()
		if string.find( string.lower( nick ), stringargs ) then
			nick = "\"" .. nick .. "\""
			nick = "boxing_clean_reserve " .. nick
			table.insert(tbl, nick)
		end
	end
	return tbl
end

-- Debug win command for leaderboard
concommand.Add("boxing_win", function()
	net.Start("debugWin")
	net.SendToServer()
end)

-- Cleans the player reserve table
concommand.Add("boxing_clean_all_reserves", function()
	
	net.Start("boxCleanAllReserves")
	net.SendToServer()

end, nil, "DEBUG: Cleans the ENTIRE player reserve table, enabling all players to join any boxing ring even if they are believed to be reserved for another..\n In almost all scenarios, you should instead use boxing_clean_reserve.")

-- Frees a given player from the reserve table
concommand.Add("boxing_clean_reserve", function(ply, cmd, args, argStr)
	
	if not args[1] then MsgN( "Usage: boxing_clean_reserve <player>" ) return false end
	local nick = args[1]
	nick = string.lower( nick )
	
	for k, v in ipairs( player.GetAll() ) do
		if string.find( string.lower( v:Nick() ), nick ) then
			net.Start("boxCleanReserve")
				net.WriteString(v:SteamID())
			net.SendToServer()
			return
		end
	end
	
	MsgN( "Player not found." )

end, boxPlyCMD, "DEBUG: Cleans the player's reserve, enabling them to join a boxing match even if they are believed to be reserved for another.")

concommand.Add("boxing_help_everything_broke", function(ply, cmd, args, argStr)

	MsgN( "So, you've broken everything, the boxing rings are rendering weirdly and everyone is screaming.\nThis likely came about from misusing the debug commands.\nIn this case, the best option is to delete/reload every existing boxing ring and use boxing_clean_all_reserves." )

end)

net.Receive("boxConfirmUpdate", function(len)

	local i = net.ReadInt(16)
	EmitSound( Sound( "UI/buttonclick.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )

end)

net.Receive("updateRing", function(len)

	BoxingRings = net.ReadTable()
	boxFullyLoaded = true

end)

net.Receive("boxStartGame", function(len)

	BoxingRings = net.ReadTable()
	local localring = BoxingRings[net.ReadInt(16)]
	localring.playing = true

end)

net.Receive("boxGameCountdown", function(len)

	local localring = BoxingRings[net.ReadInt(16)]
	localring.ent.countdownNum = tostring(net.ReadInt(4))

end)

function ENT:Initialize()
	net.Start("boxRequestUpdate")
	net.SendToServer()
end

hook.Add( "InitPostEntity", "boxFullyLoadedPly", function()
	net.Start("boxRequestUpdate")
	net.SendToServer()
end )

function ENT:Draw()

	self:DrawModel()

	if(boxFullyLoaded == false || BoxingRings[self:EntIndex()] == nil || LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 490000) then
		return
	end
	
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 90)
	
	-- Bottom Title
	cam.Start3D2D(self:GetPos() + ang:Forward()*0 + ang:Up()*193	+ ang:Right()*62	, Angle(ang.x,ang.y,ang.z-49.42), 0.1)
		--							Forward - X			Up - Y			Right - Z
		draw.SimpleTextOutlined("Cuadrilátero","boxCool255",0,0,col_Title,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,4,col_Black)
		
	cam.End3D2D()
	
	-- Sign Interface
	cam.Start3D2D(self:GetPos() + ang:Forward()*0 + ang:Up()*185 + ang:Right()*19 , Angle(ang.x,ang.y,ang.z-13), 0.04)
		--							Forward - X			Up - Y			Right - Z
		-- BG Box
		draw.RoundedBox(0,-250,-250,500,500,col_SignBG)
		
		-- Wager
		draw.SimpleTextOutlined("Apuesta: "..DarkRP.formatMoney(BoxingRings[self:EntIndex()].wager),"boxCool30",0,-230,col_White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,col_Black)
		
		-- Flavor
		draw.SimpleTextOutlined(BoxingRings[self:EntIndex()].flavor,"boxCool25",0,230,col_FlavorOutline,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,col_Black)
		
		-- Join button
		draw.RoundedBox(0,-220,-200,220,180,col_ButtonBG)
		
		-- Leave button
		draw.RoundedBox(0,-220,20,220,180,col_ButtonBG)

		-- Leaderboard button
		draw.RoundedBox(0,15,-195,220,30,col_ButtonBG)
		
		-- Top contestant, max 17 char
		draw.SimpleTextOutlined("Concursante #1","boxCool30",125,-140,col_White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,col_Black)
		if BoxingRings[self:EntIndex()].player1 != "" && BoxingRings[self:EntIndex()].player1:IsValid() then
			draw.SimpleTextOutlined(string.Left(BoxingRings[self:EntIndex()].player1:Nick(), 17),"boxCool30",125,-100,col_White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,col_Black)
		end
		
		-- Bottom contestant, max 17 char
		draw.SimpleTextOutlined("Concursante #2	","boxCool30",125,100,col_White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,col_Black)
		if BoxingRings[self:EntIndex()].player2 != "" && BoxingRings[self:EntIndex()].player2:IsValid() then
			draw.SimpleTextOutlined(string.Left(BoxingRings[self:EntIndex()].player2:Nick(), 17),"boxCool30",125,140,col_White,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,col_Black)
		end
		
		-- Countdown
		if self.countdownNum == "0" then 
		else
			draw.SimpleTextOutlined(self.countdownNum,"boxCool255",125,0,col_Yellow,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,4,col_Black)
		end

		
	cam.End3D2D()
	
	-- Interactables
	if imgui.Start3D2D(self:GetPos() + ang:Forward()*0 + ang:Up()*185 + ang:Right()*19, Angle(ang.x,ang.y,ang.z-13), 0.04, 250, 200) then
	--										Forward - X		Up - Y			Right - Z	Last 2 numbers are the fadeout distance, 200 being when it starts to fade & 250 being when it's gone
		-- Drawn cursor
		imgui.xCursor(-250,-250,500,500)
	
		-- Join as a contestant
		if imgui.xTextButton("Entrar", "boxCool84", -220, -200, 220, 180, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false && PlayerReserve[LocalPlayer():EntIndex()] == nil then
				net.Start("joinRing")
					net.WriteInt(self:EntIndex(), 16)
				net.SendToServer()
			end

		end
		
		-- Leave as a contestant
		if imgui.xTextButton("Salir", "boxCool84", -220, 20, 220, 180, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("leaveRing")
					net.WriteInt(self:EntIndex(), 16)
				net.SendToServer()
			end

		end

		-- Leaderboard button
		if imgui.xTextButton("Leaderboard", "boxCool30", 15, -195, 220, 30, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			EmitSound( Sound( "UI/buttonclick.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			openLeaderboard()

		end

		-- Less money wager
		if imgui.xTextButton("<", "boxCool30", -169, -245, 30, 30, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("boxAdjustWager")
					net.WriteInt(self:EntIndex(), 16)
					net.WriteInt(lessWager, 32)
				net.SendToServer()
			end

		end

		-- WAY less money wager
		if imgui.xTextButton("<<", "boxCool30", -212, -245, 40, 30, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("boxAdjustWager")
					net.WriteInt(self:EntIndex(), 16)
					net.WriteInt(lessLessWager, 32)
				net.SendToServer()
			end

		end

		-- opposite of BIG BOY wager
		if imgui.xTextButton("!", "boxCool30", -245, -245, 30, 30, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("boxAdjustWager")
					net.WriteInt(self:EntIndex(), 16)
					net.WriteInt(lessLessLessWager, 32)
				net.SendToServer()
			end

		end

		-- More money wager
		if imgui.xTextButton(">", "boxCool30", 139, -245, 30, 30, 3, col_White, col_Yellow, col_ButtonPress) then
		
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("boxAdjustWager")
					net.WriteInt(self:EntIndex(), 16)
					net.WriteInt(moreWager, 32)
				net.SendToServer()
			end

		end

		-- WAY more money wager
		if imgui.xTextButton(">>", "boxCool30", 172, -245, 40, 30, 3, col_White, col_Yellow, col_ButtonPress) then
			
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("boxAdjustWager")
					net.WriteInt(self:EntIndex(), 16)
					net.WriteInt(moreMoreWager, 32)
				net.SendToServer()
			end

		end

		-- BIG BOY wager
		if imgui.xTextButton("!", "boxCool30", 215, -245, 30, 30, 3, col_White, col_Yellow, col_ButtonPress) then
			
			EmitSound( Sound( "UI/buttonrollover.wav" ), LocalPlayer():GetPos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 75, 0, 100 )
			if BoxingRings[self:EntIndex()].playing == false then
				net.Start("boxAdjustWager")
					net.WriteInt(self:EntIndex(), 16)
					net.WriteInt(moreMoreMoreWager, 32)
				net.SendToServer()
			end

		end
		
		imgui.End3D2D()
	end
	
end
