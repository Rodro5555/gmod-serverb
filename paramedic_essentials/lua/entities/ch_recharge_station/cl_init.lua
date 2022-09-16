include( "shared.lua" )

local col_black = Color( 2, 2, 2, 255 )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 100000 then
		return
	end
	
	-- Crate cooldown overhead text
	local pos = self:GetPos() + Vector( 0, 0, 70 )
	local ang = self:GetAngles()

	-- The front panel
	local PanelPos = self:GetAttachment( 1 ).Pos
	local PanelAng = self:GetAttachment( 1 ).Ang
	
	--PanelAng:RotateAroundAxis( PanelAng:Up(), 70 )
	PanelAng:RotateAroundAxis( PanelAng:Forward(), 90 )

	cam.Start3D2D( PanelPos, PanelAng, 0.04 )
		draw.RoundedBoxEx( 0, 0, 0, 530, 405, CH_AdvMedic.Config.Design.BackgroundColor, false, false, false, false )
		
		draw.SimpleTextOutlined( CH_AdvMedic.Config.Lang["Recharge Station"][CH_AdvMedic.Config.Language], "MEDIC_RechargeStationLarge", 270, 50, CH_AdvMedic.Config.Design.HeaderColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, CH_AdvMedic.Config.Design.HeaderOutline )
		
		draw.SimpleTextOutlined( CH_AdvMedic.Config.Lang["Recharges Available"][CH_AdvMedic.Config.Language], "MEDIC_RechargeStationMedium", 270, 130, CH_AdvMedic.Config.Design.SecondHeaderColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, CH_AdvMedic.Config.Design.SecondHeaderOutline )
		if self:GetNWInt( "RechargesLeft" ) then
			draw.SimpleTextOutlined( self:GetNWInt("RechargesLeft") .." ".. CH_AdvMedic.Config.Lang["Left"][CH_AdvMedic.Config.Language], "MEDIC_RechargeStationSmall", 270, 170, CH_AdvMedic.Config.Design.ChargesLeftColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, CH_AdvMedic.Config.Design.ChargesLeftOutline )
		end
		
		draw.SimpleTextOutlined( CH_AdvMedic.Config.Lang["Only to be used by paramedics"][CH_AdvMedic.Config.Language], "MEDIC_RechargeStationMedium", 270, 230, CH_AdvMedic.Config.Design.RechargeKeyColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, CH_AdvMedic.Config.Design.RechargeKeyOutline )
		draw.SimpleTextOutlined( CH_AdvMedic.Config.Lang["Press 'e' to recharge"][CH_AdvMedic.Config.Language], "MEDIC_RechargeStationSmall", 270, 270, CH_AdvMedic.Config.Design.BottomTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, CH_AdvMedic.Config.Design.BottomTextOutline )	
	cam.End3D2D()
end