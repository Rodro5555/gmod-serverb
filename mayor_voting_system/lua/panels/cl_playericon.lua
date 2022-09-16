--
-- Credits: TEAM GARRY
-- https://github.com/garrynewman/garrysmod/blob/master/garrysmod/lua/vgui/spawnicon.lua
-- Copy of panel with slight changes including inheritance
--

local PANEL = {}

AccessorFunc( PANEL, "m_strModelName", 		"ModelName" )
AccessorFunc( PANEL, "m_iSkin", 			"SkinID" )
AccessorFunc( PANEL, "m_strBodyGroups", 	"BodyGroup" )
AccessorFunc( PANEL, "m_strIconName", 		"IconName" )


--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetText( "" )
	
	self.Icon = vgui.Create( "ModelImage", self )
	self.Icon:SetMouseInputEnabled( false )
	self.Icon:SetKeyboardInputEnabled( false )
	
	self:SetSize( 64, 64 )	
	
	self.m_strBodyGroups = "000000000";

end

function PANEL:DoRightClick()

	local pCanvas = self:GetSelectionCanvas()
	if ( IsValid( pCanvas ) && pCanvas:NumSelectedChildren() > 0 ) then
		return hook.Run( "SpawnlistOpenGenericMenu", pCanvas )
	end

	self:OpenMenu()
end

function PANEL:Paint( w, h )

	if ( !self.Hovered ) then return end
	
	//derma.SkinHook( "Paint", "Shadow", self, w, h )

end

function PANEL:PerformLayout()
	
	self.Icon:StretchToParent( 0, 0, 0, 0 )

end

function PANEL:SetSpawnIcon( name )
	self.m_strIconName = name
	self.Icon:SetSpawnIcon( name )
end

function PANEL:SetBodyGroup( k, v )

	if ( k < 0 ) then return end
	if ( k > 9 ) then return end
	if ( v < 0 ) then return end
	if ( v > 9 ) then return end
	
	self.m_strBodyGroups = self.m_strBodyGroups:SetChar( k+1, v )

end

function PANEL:SetModel( mdl, iSkin, BodyGorups )

	if (!mdl) then debug.Trace() return end

	self:SetModelName( mdl )
	self:SetSkinID( iSkin )
	
	if ( tostring(BodyGorups):len() != 9 ) then
		BodyGorups = "000000000"
	end
	
	self.m_strBodyGroups = BodyGorups;

	self.Icon:SetModel( mdl, iSkin, BodyGorups )
	
	if ( iSkin && iSkin > 0 ) then
		self:SetToolTip( Format( "%s (Skin %i)", mdl, iSkin+1 ) )
	else
		self:SetToolTip( Format( "%s", mdl ) )
	end

end

function PANEL:RebuildSpawnIcon()

	self.Icon:RebuildSpawnIcon()

end

function PANEL:RebuildSpawnIconEx( t )

	self.Icon:RebuildSpawnIconEx( t )

end

-- Icon has been editied, they changed the skin
-- what should we do?
function PANEL:SkinChanged( i )

	-- Change the skin, and change the model
	-- this way we can edit the spawnmenu....
	self:SetSkinID( i )
	self:SetModel( self:GetModelName(), self:GetSkinID(), self:GetBodyGroup() )
	
end

function PANEL:BodyGroupChanged( k, v )

	self:SetBodyGroup( k, v )
	self:SetModel( self:GetModelName(), self:GetSkinID(), self:GetBodyGroup() )
	
end

vgui.Register( "VotingPlayerIcon", PANEL, "DLabel" )