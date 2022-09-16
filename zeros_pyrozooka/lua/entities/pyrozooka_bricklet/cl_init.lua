include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end
function ENT:DrawTranslucent()
	self:Draw()
end

net.Receive( "pyrozooka_bricklet_FX", function( len, ply )
	local effectInfo = net.ReadTable()
	if(effectInfo)then
		if(effectInfo.parent == nil)then return end
		if(IsValid(effectInfo.parent))then
			if(effectInfo.sound)then
				effectInfo.parent:EmitSound(effectInfo.sound)
			end
			if(effectInfo.effect)then
				ParticleEffectAttach( effectInfo.effect,PATTACH_POINT_FOLLOW , effectInfo.parent,1 )
			end
		end
	end
end)
