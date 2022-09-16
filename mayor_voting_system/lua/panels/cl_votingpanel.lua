/*---------------------------------------------------------
  START PlayerVotingPanel
---------------------------------------------------------*/
local PlayerVotingPanel = {}

function PlayerVotingPanel:Init()
	self:SetDrawBackground(false)
	self:SetDrawBorder(false)
	//self:SetStretchToFit(false)
	self:SetSize(350, 70)
	self.CurrentWidth = 350
	self.ColorBarWidth = 38
	self.CurrentAlpha = 0
	self.BackColor = VOTING.Theme.ControlColor
	self.TextColor = Color(255, 255, 255, 250 )
	self.HoverColor = Color(23, 55, 94, 250 )
	self.HoverTextColor = Color(142, 180, 227, 250)
	self.Hovering = false
	
	self.HeaderLbl = vgui.Create("DLabel", self)
	self.HeaderLbl:SetFont("Bebas24Font")
	self.HeaderLbl:SetColor(self.TextColor)
	
	self.VoteLbl = vgui.Create("DLabel", self)
	self.VoteLbl:SetFont("Bebas70Font")
	self.VoteLbl:SetColor(self.TextColor)
	
	self.PlayerIcon = vgui.Create("VotingPlayerIcon", self)
	
	self.VoteCircle = vgui.Create("DImage", self)
	self.VoteCircle:SetImage("mayorvoting/smallvotecircle.png")
	self.VoteCircle:SetSize(68, 65)
	self.VoteCircle:SetVisible(false)
	
	//self.BorderColor = Color(190,40,0,255)
end

function PlayerVotingPanel:SetNoActionEnbaled(results)
	self.NoAction = true
	self.HoverColor = Color(0, 0, 0, 155 )
	self.AlphaFade = 255
	self.StartAlphaFade = true
	self.HeaderLbl:SetColor(Color(153, 153, 153, 90 ))
	self.VoteLbl:SetColor(Color(153, 153, 153, 90 ))
	if results then
		self.PlayerIcon:SetVisible(false)
		self.VoteCircle:SetVisible(false)
	end
end

function PlayerVotingPanel:SetPlayer(ply)
	if not IsValid(ply) then self:SetNoActionEnbaled() end
	
	if (#ply:Nick() > 20) then
	self.HeaderLbl:SetText(string.sub(ply:Nick(), 1, 25) .. "...")
	else
	self.HeaderLbl:SetText(ply:Nick())
	end
	self.HeaderLbl:SizeToContents()
	self.CurrentPlayer = ply
	self.CurrentVotes = 0
	self.VoteLbl:SetText(tostring(self.CurrentVotes))
	self.VoteLbl:SizeToContents()
	
	self.PlayerIcon:InvalidateLayout( true )
	self.PlayerIcon:SetModel(ply:GetModel())
	self.PlayerIcon:SetSize(64, 64)
	self.PlayerIcon:SetToolTip(ply:Nick())
end

function PlayerVotingPanel:GetPlayer(ply)
	if IsValid(self.CurrentPlayer) then return self.CurrentPlayer
	else self:SetNoActionEnbaled() return nil end
end

function PlayerVotingPanel:SetColor(color)
	if not type(color) == "color" then return end
	//self.NoAction = true
	self.BackColor = color
	self.HoverTextColor = color
end

function PlayerVotingPanel:GetColor()
	return self.BackColor
end

function PlayerVotingPanel:IncreaseVote(num)
	self.CurrentVotes = (self.CurrentVotes + num)
	self.VoteLbl:SetText(tostring(self.CurrentVotes))
	self.VoteLbl:SizeToContents()
	self.CurrentAlpha = 255
end

function PlayerVotingPanel:SetText(text)
	self.HeaderLbl:SetText(text)
	self.HeaderLbl:SizeToContents()
end

function PlayerVotingPanel:SetSubText(text)
	self.SubLbl:SetText(text)
	self.SubLbl:SizeToContents()
	self.SubLbl:SetVisible(true)
end

function PlayerVotingPanel:PerformLayout()
	
	local offset = (self.CurrentWidth - self.HeaderLbl:GetWide()) / 2
	self.HeaderLbl:SetPos(offset, 3)
	
	self.VoteLbl:SetPos(300, 3)
	
	self.PlayerIcon:SetPos(3,3)

	self:SetWide( self.CurrentWidth )
end

function PlayerVotingPanel:Paint()

	if self.StartAlphaFade then
		self.AlphaFade = math.Approach( self.AlphaFade, 50, FrameTime() * 400 )
		local c = self.BackColor
		local r,g,b = c.r,c.g,c.b
		surface.SetDrawColor(r,g,b,self.AlphaFade)
	else
	surface.SetDrawColor(self.BackColor)
	end
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall())
	
	//Vote count box
	self.CurrentAlpha = math.Approach( self.CurrentAlpha, 0, FrameTime() * 200 )

	surface.SetDrawColor(self:ColorWithCurrentAlpha(VOTING.Theme.ControlColor))
	surface.DrawRect( 295, 0, self.VoteLbl:GetWide() + 10, self.VoteLbl:GetTall())
end

function PlayerVotingPanel:OnCursorEntered()
	self.Hovering = true
	self.ColorBarWidth = 38
	if not self.NoAction and not self.CurrentSelection and not LocalPlayer().HasVoted then
		self.VoteCircle:SetVisible(true)
	end
end

function PlayerVotingPanel:OnCursorExited()
	self.Hovering = false
	if not self.NoAction and not self.CurrentSelection and not LocalPlayer().HasVoted then
		self.VoteCircle:SetVisible(false)
	end
end

function PlayerVotingPanel:ToggleSelect(select)
	if select then
		self.CurrentSelection = true
	else
		self.CurrentSelection = false
	end
end

function PlayerVotingPanel:ColorWithCurrentAlpha(c)
	local r,g,b = c.r,c.g,c.b
	return Color(r,g,b,self.CurrentAlpha)
end

derma.DefineControl("PlayerVotingPanel", "Player voting panel for mayor elections", PlayerVotingPanel, "DImageButton")

/*---------------------------------------------------------
  End PlayerVotingPanel
---------------------------------------------------------*/