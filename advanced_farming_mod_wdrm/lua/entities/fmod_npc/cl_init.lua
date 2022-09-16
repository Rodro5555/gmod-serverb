include( "shared.lua" )

local nsize = 150

function ENT:Draw()

	self:DrawModel()
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	local ang = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	
	local angle = self:GetAngles()	
	
	local boneid = self:LookupBone( "ValveBiped.Bip01_Head1" )
	local bonepos = self:GetBonePosition( boneid )	
	
	local position = bonepos + angle:Up() * 12
	
	angle:RotateAroundAxis(angle:Forward(), 0);
	angle:RotateAroundAxis(angle:Right(),0);
	angle:RotateAroundAxis(angle:Up(), 90);
	-- angle:Right()*0+angle:Up()*( math.sin(CurTime() * 2) * 2.5 + 78 )
	cam.Start3D2D(position, ang, 0.1)
		
		draw.RoundedBox( 0, -nsize/2, -25, nsize, 50, Color(40,40,40, 200 ) )
		local width = draw.SimpleTextOutlined( FarmingMod.Config.Lang["FARMER"][FarmingMod.Config.CurrentLang], "Trebuchet24" ,0,0, Color(255,255,255,500-dist), 1, 1, 1, Color(0,0,0))
		
		nsize = width + 20
		
	cam.End3D2D()
	
end