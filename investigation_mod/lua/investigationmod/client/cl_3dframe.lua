local PANEL = {}

AccessorFunc( PANEL, "_shouldDrawCursor", "DrawCursor", FORCE_BOOL )
AccessorFunc( PANEL, "_cusorColor", "CursorColor" )
AccessorFunc( PANEL, "_cursorRad", "CursorRadius" )

function PANEL:OnChildAdded( oChild )
	self.ChildrenList = self.ChildrenList or {}

	timer.Simple( 2, function()
		if not IsValid( oChild ) then return end
		oChild.IsHovered = function()
			return oChild.m_isHovered
		end
	end )

	table.insert( self.ChildrenList, oChild )
end

local function registerChildren( oFrame, oParent )
	table.insert( oFrame.ChildrenList, oParent )

	oParent.IsHovered = function()
		return oParent.m_isHovered
	end

	local tChildren = oParent:GetChildren()

	for _, oSecondChild in pairs( tChildren ) do
		if #oSecondChild:GetChildren() > 0 then
			registerChildren( oFrame, oSecondChild )
		else 
			table.insert( oFrame.ChildrenList, oSecondChild )
			oSecondChild.IsHovered = function()
				return oSecondChild.m_isHovered
			end
		end
	end
end

function PANEL:UpdateChildren()
	self.ChildrenList = {}
	registerChildren( self, self )
end

function PANEL:_CheckHover( iCursorPosX, iCursorPosY, bDoClick, bDown )
	for _, oPanel in pairs( self.ChildrenList or {} ) do
		if not oPanel or not IsValid( oPanel ) then continue end

		local x, y = self:GetChildPosition( oPanel )
		local rx, ry = oPanel:GetSize()
		rx, ry = rx + x, ry + y

		if iCursorPosX >= x and iCursorPosX <= rx and iCursorPosY >= y and iCursorPosY <= ry then
			if bDoClick then 
				if oPanel.DoClick and isfunction( oPanel.DoClick ) then
					oPanel:DoClick()
				end
			end

			if bDown then
				if oPanel.IsDown and isfunction( oPanel.IsDown ) then
					oPanel:IsDown()
				end
			end
			oPanel.m_isHovered = true
		else
			oPanel.m_isHovered = false
		end
	end
end

function PANEL:PaintManual3D( vCamPosition, aCamAngles, iRatio )
	if self.IsVisible and not self:IsVisible() then return end

	self:PaintManual()

    local iFrameWide, iFrameTall = self:GetSize()
    local iFramePosX, iFramePosY = self:GetPos()

    local x, y = input.GetCursorPos()

    local vPos = ( InvestigationMod.MoveView and InvestigationMod.MoveView.CurrentValues and InvestigationMod.MoveView.CurrentValues.pos ) or LocalPlayer():GetShootPos()
    local vAngle = ( ( vgui.CursorVisible() and InvestigationMod.MoveView and InvestigationMod.MoveView.CurrentValues and InvestigationMod.MoveView.CurrentValues.angle and util.AimVector(  InvestigationMod.MoveView.CurrentValues.angle, 85 * 1.19, x, y, ScrW(), ScrH() ) ) ) or ( vgui.CursorVisible() and gui.ScreenToVector( x, y ) ) or LocalPlayer():GetAimVector()

    local vCursorPositionWorld = util.IntersectRayWithPlane( 
    	vPos,
		vAngle,
		vCamPosition,
		aCamAngles:Up() )

    if not vCursorPositionWorld then return end

 	local vCursorPositionLocal, aCursorAngleLocal = WorldToLocal( vCursorPositionWorld, Angle(), vCamPosition, aCamAngles )


 	local iCursorPosX, iCursorPosY = vCursorPositionLocal.x / iRatio, vCursorPositionLocal.y / -iRatio

 	if self._shouldDrawCursor then
		self.CursorPosX, self.CursorPosY = math.Clamp( iCursorPosX, iFramePosX, iFramePosX + iFrameWide ), math.Clamp( iCursorPosY, iFramePosY, iFramePosY + iFrameTall )
	end

 	if ( input.IsKeyDown( KEY_E ) and not vgui.CursorVisible() ) or ( vgui.CursorVisible() and input.IsMouseDown( MOUSE_LEFT ) ) then
 		self.lastPressUse = true
 		return self:_CheckHover( iCursorPosX, iCursorPosY, false, true )
 	elseif self.lastPressUse then
 		self.lastPressUse = false
 		return self:_CheckHover( iCursorPosX, iCursorPosY, true, false )
 	end


 	self:_CheckHover( iCursorPosX, iCursorPosY, false, false )
end

function PANEL:PaintOver()
	if self._shouldDrawCursor then
		local iCursorRad = self._cursorRad or 1
		draw.RoundedBox( iCursorRad * 2, ( self.CursorPosX or 0 ) - iCursorRad, ( self.CursorPosY or 0 ) - iCursorRad, iCursorRad * 2, iCursorRad * 2, self._cusorColor or Color( 255, 255, 255 ) )
	end
end

derma.DefineControl( "InvestigationMod.3DFrame", "A DFrame, but able to be used in a 3D context", PANEL, "DFrame" )