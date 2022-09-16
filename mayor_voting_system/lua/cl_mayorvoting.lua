--Mayor Voting Main Client Dist
if VOTING then VOTING = VOTING
else VOTING = {} end

VOTING.CurrentHeight = 50
include('cl_votingfonts.lua')
include('sh_votingconfig.lua')
--Include panels
include('panels/cl_votingpanel.lua')
include('panels/cl_playericon.lua')

function VOTING.OpenVoteScreen( settings )
	if not LocalPlayer() then return end
	VOTING.MainWindowOpen = true
	if !VotingMainWindow then
		VotingMainWindow = vgui.Create( "DFrame" )
		VotingMainWindow:SetSize( ScrW(), 300 )
		VotingMainWindow:SetDraggable( false )
		if not VOTING.Settings.ShowCloseButton then
			VotingMainWindow:ShowCloseButton( false )
		else
			VotingMainWindow.Close = function() VOTING.CloseVoteScreen() end
		end
		VotingMainWindow:SetTitle( "" )
		VotingMainWindow:SetBackgroundBlur( true )
		VotingMainWindow:SetZPos(9999)
		VotingMainWindow:SetDrawOnTop(true)
		VotingMainWindow.VoteTime = settings.time
		VOTING.CanCloseTime = CurTime() + settings.time
		VotingMainWindow.Paint = VOTING.PaintMainWindow
		VOTING.VoteManager = {}
		
		//Voting panels list
		local VotingPanelsList = vgui.Create( "DPanelList", VotingMainWindow )
		VotingPanelsList:SetPadding( 0 )
		VotingPanelsList:SetSpacing( 5 )
		VotingPanelsList:SetAutoSize( true )
		VotingPanelsList:SetNoSizing( false )
		VotingPanelsList:EnableHorizontal( true )
		VotingPanelsList:EnableVerticalScrollbar( false )
		VotingPanelsList.Paint = function() end
		VotingPanelsList:SetWide(ScrW() - (ScrW() / 10))
		VotingPanelsList:SetPos((ScrW() / 10) / 2, 70)
		
		//Create voting panels
		for k,v in pairs(settings.Candidates) do
			local VotingPanel = vgui.Create( "PlayerVotingPanel" )
			if IsValid(v.player) then
			VotingPanel:SetPlayer(v.player)
			VotingPanel:SetColor(VOTING.NewVotingPanelColor())
			VotingPanel.DoClick = function()
				if LocalPlayer().HasVoted then return end
				local player = VotingPanel:GetPlayer()
				if player then
				LocalPlayer():ConCommand("mayor_vote "..k)
				VotingPanel:ToggleSelect(true)
				LocalPlayer().HasVoted = true
				if (VOTING.Settings.ForceMouseCursor) then gui.EnableScreenClicker(false) end
				end
			end
			else
			VotingPanel:SetColor(VOTING.NewVotingPanelColor())
			VotingPanel:SetNoActionEnbaled(true)
			VotingPanel:SetText("Disconnected")
			end
			table.insert(VOTING.VoteManager, VotingPanel)
			VotingPanelsList:AddItem(VotingPanel)
		end
		
		local maxwidth = VotingPanelsList:GetWide()
		local curwidth  = 0
		local items = 0
		for k,v in pairs(VotingPanelsList:GetItems()) do
			curwidth = curwidth + (v.CurrentWidth) + 5
			if (curwidth > maxwidth) then break
			else items = (items + 1) end
		end
		VotingPanelsList:SetWide(355 * items)
		VotingPanelsList:SetPos((ScrW() - VotingPanelsList:GetWide()) / 2, 70)
		local rows = 0
		local panelheight = 0
		rows = math.ceil(#VOTING.VoteManager / items)
		
		VOTING.MaxHeight = 130 + (70 * rows)
		VotingMainWindow:SetSize( ScrW(), VOTING.MaxHeight )
		if VOTING.Settings.ForceMouseCursor then gui.EnableScreenClicker(true) end
	else
		VOTING.CloseVoteScreen()
	end
end
//concommand.Add("voting", VOTING.OpenVoteScreen)
//usermessage.Hook("VOTING_Open", VOTING.OpenVoteScreen)

local FKeyReleased = false

function VOTING.PaintMainWindow()	
	//Paint window itself
	surface.SetDrawColor(VOTING.Theme.WindowColor)
	
	VOTING.CurrentHeight = math.Approach( VOTING.CurrentHeight, VOTING.MaxHeight, FrameTime() * 400 )
	surface.DrawRect(0, 0, ScrW(), VOTING.CurrentHeight)
	
	//Banner heading
	local time = math.Clamp(VOTING.CanCloseTime - CurTime(), 0, VotingMainWindow.VoteTime)
	local timetext = string.FormattedTime(time, "%02i:%02i")
	local text = VOTING.Settings.VotingTitle .. " (" .. timetext  ..")"
	if VOTING.ResultsScreen then text = VOTING.Settings.ResultsTitle end
	draw.DrawText(text, "Bebas40Font", (ScrW() / 2), 10, VOTING.Theme.TitleTextColor, TEXT_ALIGN_CENTER )
	
	//Vote ticker
	if VOTING.VoteTickerAlpha > -1 then
		VOTING.VoteTickerAlpha = math.Clamp(VOTING.VoteTickerAlpha + FrameTime() * VOTING.NotificationDirFT * 300, 0, 190)
		
		local c = VOTING.VoteTickerColor
		local r,g,b = c.r,c.g,c.b
		local w,h = surface.GetTextSize(VOTING.VoteTickerMessage)

		local ypos = (ScrW() / 2) - (w / 4)
		draw.WordBox(2, ypos, (VOTING.MaxHeight - 30), VOTING.VoteTickerMessage, "OpenSans18Font", Color(r,g,b,VOTING.VoteTickerAlpha), color_white)
	end
	
end

function VOTING.CloseVoteScreen()
	if VotingMainWindow then
		VotingMainWindow:Remove()
		VotingMainWindow = nil
		VOTING.CanCloseTime = nil
		VOTING.LastPanelNumber = nil
		VOTING.VoteTickerAlpha = -1
		VOTING.VoteTickerMessage = "Se realizó una votación en las elecciones."
		VOTING.ResultsScreen = nil
		LocalPlayer().HasVoted = nil
		FKeyReleased = false
	end
	VOTING.MainWindowOpen = false
end

--NewVote Network Message
net.Receive("Voting_NewVote", function(l,c)
	 local votedata = net.ReadTable()
	 local votetime = VOTING.VoteTime
	 local settings = {}
	 settings.Candidates = votedata
	 settings.time = votetime
	 VOTING.OpenVoteScreen( settings )
	 if VOTING.Settings.MenuSounds then surface.PlaySound(VOTING.Settings.NewVoteSound) end
end)

--EndVote Network Message
net.Receive("Voting_EndVote", function(l,c)
	if not VOTING.MainWindowOpen then return end
	 local winningplayer = net.ReadEntity()

	 if winningplayer and not (winningplayer == NULL) and VOTING.VoteManager then
			VOTING.ResultsScreen = true
			for k,v in pairs(VOTING.VoteManager) do
				if not (v:GetPlayer() == winningplayer) then
					v:SetNoActionEnbaled(true)
				else
					VOTING.VoteTickerAlpha = 0
					VOTING.VoteTickerMessage = string.format("Felicitaciones al ganador, %s!", winningplayer:Nick())
					VOTING.VoteTickerColor = v:GetColor()
				end
			end
	 else
	 end
	 if VOTING.Settings.MenuSounds then surface.PlaySound(VOTING.Settings.VoteResultsSound) end
	 timer.Simple(VOTING.Settings.CloseTimeAfterVoteEnds, VOTING.CloseVoteScreen)
end)

--Vote Cast Network Message
net.Receive("Voting_VoteCast", function(l,c)
	if not VOTING.MainWindowOpen then return end
	 local candidate = net.ReadEntity()
	 local player = net.ReadEntity()

	 if not VOTING.MainWindowOpen then return end
	 for k,v in pairs(VOTING.VoteManager) do
		if (v:GetPlayer() == candidate) then
			v:IncreaseVote(1)
			
			--Show vote ticker update
			if VOTING.Settings.ShowVoteTickerUpdates and IsValid(player) and IsValid(candidate) then
				VOTING.VoteTickerAlpha = 0
				VOTING.VoteTickerMessage = string.format("%s votó por %s", player:Nick(), candidate:Nick())
				VOTING.VoteTickerColor = v:GetColor()
			end
		end
	 end
end)

VOTING.VoteTickerAlpha = -1
VOTING.VoteTickerMessage = "Se realizó una votación en las elecciones."
VOTING.VoteTickerColor = Color(26,83,255)
VOTING.NotificationDirFT = 1

VOTING.VotingStaticColors = {Color(26,83,255),Color(255,77,77),Color(230,184,0),Color(0,179,54)}

local ConfirmMenuVisible = false
function VOTING.ConfirmCandidacy()
	if ConfirmMenuVisible then return end
	ConfirmMenuVisible = true
	Derma_Query("¿Quieres participar en las próximas elecciones? " .. LocalPlayer():Nick() .. " ?", "Secretaria del Presidente",
			"Si " .. (CUR or GAMEMODE.Config.currency or "$") .. tostring(VOTING.CandidateCost), function() LocalPlayer():ConCommand("mayor_vote_enter") ConfirmMenuVisible = false end,
			"Anular", function() ConfirmMenuVisible = false end
			)
end
usermessage.Hook("VOTING_Confirm", VOTING.ConfirmCandidacy)

function VOTING.NewVotingPanelColor()
	if not VOTING.LastPanelNumber then VOTING.LastPanelNumber = 1 
	else VOTING.LastPanelNumber = (VOTING.LastPanelNumber + 1) end
	
	if VOTING.VotingStaticColors[VOTING.LastPanelNumber] then
	return VOTING.VotingStaticColors[VOTING.LastPanelNumber]
	else
		local part = math.random(1,3)
		if part == 1 then return Color(255,math.random(1,255),math.random(1,255) )
		elseif part == 2 then return Color(math.random(1,255),255,math.random(1,255) )
		else return Color(math.random(1,255),math.random(1,255),255 ) end
	end
end

function VOTING.SetupClientTeam()
	timer.Simple(2, function()
	//Find mayor team
	local TEAM
	for k,v in pairs(RPExtraTeams) do
		if string.lower(v.name) == string.lower(VOTING.MayorTeamName) then
			TEAM = v
		end
	end
	if not TEAM then return end
	TEAM.vote = false
	end)
end
hook.Add("InitPostEntity","VOTING_SetupClientTeam",VOTING.SetupClientTeam)

local function MayorVotingChatNotice(msg)
	local text = msg:ReadString() or "No message."
	chat.AddText(VOTING.Theme.NoticePrefixColor, VOTING.Settings.NoticePrefix .. " ", VOTING.Theme.NoticeTextColor, text )
end
usermessage.Hook("Voting_ChatNotice", MayorVotingChatNotice)